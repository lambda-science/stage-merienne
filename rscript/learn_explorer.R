library(gridExtra)
source("src/volcano_plot.R")
DT::datatable(matrix())

df <- import_data_excel(dataPath = "data_example/allres_S17307.xlsx")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
df_filtered <- filter_data(df, genelist, "Gene name", "MGI.symbol")
col_samples <- import_data_txt("data_example/colnames.txt")
col_samples <- col_samples[[1]]
col_samples <- as.vector(col_samples)

for (i in seq(1,30,2)){
p1 <- create_volcano(df, "Gene name", 
                     col_samples[i],
                     col_samples[i+1], 
                     logFC_treshold = 1, title = col_samples[i])
p2 <- create_volcano(df_filtered, "Gene name", 
                     col_samples[i],
                     col_samples[i+1], 
                     logFC_treshold = 1, title = paste(col_samples[i], " filtered w/ interactors", sep=""))

updown_df_filtered <- retrieve_signif_genes(df_filtered, gene_name_col = "Gene name" , 
                                            col_samples[i], 
                                            col_samples[i+1], logFC_treshold = 1)

grid.arrange(p1, p2, nrow=1)
}