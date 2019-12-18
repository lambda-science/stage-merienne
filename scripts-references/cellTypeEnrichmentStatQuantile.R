setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/")

# Importation de toutes nos données
library(gridExtra)
library(knitr)
source("src/volcano_plot.R")
df <- import_data_excel(dataPath = "replicates/TypeVsGrp/allres_cell_type_analyse_Corentin_readCount.xlsx")
# Garder que les top 50% genes
# Calcul des moyennes des réplicats (RPKM)
index_RPKM <- grep("(normalized read counts)", colnames(df))
df$WT_RPKM <- rowMeans(df[c(index_RPKM)], na.rm=TRUE)
df$qnt <- cut(df$WT_RPKM , breaks=quantile(df$WT_RPKM, probs=c(0, 0.5, 1)),
              labels=1:2, include.lowest=TRUE)
df <- df[df[, "qnt"] == 2,]

genelist <- import_data_txt("genelist/mouseGenes.tsv")
df_filtered <- filter_data(df, genelist, "Gene name", "MGI.symbol")
col_samples <- import_data_txt("raw/TypeVsGrp/colnames.txt")
col_samples <- col_samples[[1]]
col_samples <- as.vector(col_samples)
#################################################################################
# Test binomial
# Calcul probao de reférence (biais initial)
for (i in seq(1,8,2)){
  df <- as.data.frame(df)
  updown_df_ref <- retrieve_signif_genes(df, gene_name_col = "Gene name" , 
                                         col_samples[i], 
                                         col_samples[i+1], logFC_treshold = 0, pval_treshold = 0.05)
  
  # Compteage de up & down et formating du tableau
  n_up <- nrow(updown_df_ref[updown_df_ref[, "regulation"] == "up",])
  n_down <- nrow(updown_df_ref[updown_df_ref[, "regulation"] == "down",])
  n_NS <- nrow(df) - nrow(updown_df_ref)
  # Stockage des nombre de succès et échec (up & down)
  
    # Selection de tout les interacteurs < 0.05 pval
  updown_df_pval <- retrieve_signif_genes(df_filtered, gene_name_col = "Gene name" , 
                                          col_samples[i], 
                                          col_samples[i+1], logFC_treshold = 0.0001, pval_treshold = 0.05)
  
  # Compteage de up & down et formating du tableau
  int_up <- nrow(updown_df_pval[updown_df_pval[, "regulation"] == "up",])
  int_down <- nrow(updown_df_pval[updown_df_pval[, "regulation"] == "down",])
  int_NS <- nrow(df) - nrow(updown_df_pval)
  
  # Stockage des nombre de succès et échec (up & down)
   int_NS <- nrow(df_filtered) - nrow(updown_df_pval)
  
  cat(col_samples[i], "\n")
  cat("n_up", n_up, "n_down", n_down, "n_NS", n_NS, "\n")
  cat("int_up", int_up, "int_down", int_down, "int_NS", int_NS, "\n")
}
