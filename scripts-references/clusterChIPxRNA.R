setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/")
# Importation de toutes nos données
library(gridExtra)
source("src/volcano_plot.R")
df <- import_data_excel(dataPath = "raw/LNCA/Q140_RNA-Seq.xlsx")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
genelistA <- import_data_txt("genelist/clusterA_inter.txt")

df_filtered <- filter_data(df, genelist, "Gene.name", "MGI.symbol")
df_filteredA <- filter_data(df, genelistA, "Gene.name", "Gene.name")

# Volcano
p1 <- create_volcano(df_filtered, "Gene.name", 
                     "log2(Q140_6m/WT_6m)",
                     "Adjusted p-value (Q140_6m vs WT_6m)", 
                     logFC_treshold = 0.0001, pval_treshold = 0.05, title = "All interactors (Q140 vs WT)")
p2 <- create_volcano(df_filteredA, "Gene.name", 
                     "log2(Q140_6m/WT_6m)",
                     "Adjusted p-value (Q140_6m vs WT_6m)", 
                     logFC_treshold = 0.0001, pval_treshold = 0.05, title = "Interactors in A only")
grid.arrange(p1, p2, nrow=1)

#################################################################################
# Test binomial
# Calcul probao de reférence (biais initial)

genelist <- import_data_txt("genelist/mouseGenes.tsv")
df_filteredA <- filter_data(df_filtered, genelistA, "Gene.name", "Gene.name")

df <- as.data.frame(df)
updown_df_ref <- retrieve_signif_genes(df_filtered, gene_name_col = "Gene.name" , 
                                       "log2(Q140_6m/WT_6m)", 
                                       "Adjusted p-value (Q140_6m vs WT_6m)", logFC_treshold = 0, pval_treshold = 0.05)

# Compteage de up & down et formating du tableau
n_up <- nrow(updown_df_ref[updown_df_ref[, "regulation"] == "up",])
n_down <- nrow(updown_df_ref[updown_df_ref[, "regulation"] == "down",])
n_NS <- nrow(df_filtered) - nrow(updown_df_ref)
# Stockage des nombre de succès et échec (up & down)

# Selection de tout les interacteurs < 0.05 pval
updown_df_pval <- retrieve_signif_genes(df_filteredA, gene_name_col = "Gene.name" , 
                                        "log2(Q140_6m/WT_6m)", 
                                        "Adjusted p-value (Q140_6m vs WT_6m)", logFC_treshold = 0, pval_treshold = 0.05)

# Compteage de up & down et formating du tableau
int_up <- nrow(updown_df_pval[updown_df_pval[, "regulation"] == "up",])
int_down <- nrow(updown_df_pval[updown_df_pval[, "regulation"] == "down",])

# Stockage des nombre de succès et échec (up & down)
int_NS <- nrow(df_filteredA) - nrow(updown_df_pval)

cat("Cluster A")
cat("n_up", n_up, "n_down", n_down, "n_NS", n_NS, "\n")
cat("int_up", int_up, "int_down", int_down, "int_NS", int_NS, "\n")