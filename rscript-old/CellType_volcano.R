library(gridExtra)
source("src/volcano_plot.R")

# Importation des données et filtrage
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
df <- import_data_txt("raw/merged_all.tsv")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
df_filtered <- filter_data(df, genelist, "Gene.name", "MGI.symbol")

# Cell type disponibles: "Cx3", "D1", "D2", "GLIA", "GLT", "N"
sample_name <- "N"

# Creation des volcano
p1 <- create_volcano(df, "Gene.name", 
                     paste(sample_name, "_logFC", sep=""),
                     paste(sample_name, "_adj.P.Val", sep=""), 
                     logFC_treshold = 1, title = sample_name)
p2 <- create_volcano(df_filtered, "Gene.name", 
                     paste(sample_name, "_logFC", sep=""),
                     paste(sample_name, "_adj.P.Val", sep=""), 
                     logFC_treshold = 1, title = paste(sample_name, " filtered w/ interactors", sep=""))

grid.arrange(p1, p2, nrow=1)

updown_df <- retrieve_signif_genes(df, gene_name_col = "Gene.name" , paste(sample_name, "_logFC", sep=""),
                                   paste(sample_name, "_adj.P.Val", sep=""), logFC_treshold = 1)
View(updown_df)

updown_df_filtered <- retrieve_signif_genes(df_filtered, gene_name_col = "Gene.name" , paste(sample_name, "_logFC", sep=""),
                                            paste(sample_name, "_adj.P.Val", sep=""), logFC_treshold = 1)
View(updown_df_filtered)

