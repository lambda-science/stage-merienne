library(readxl)
library(biomaRt)
library(dplyr)
source("src/volcano_plot.R")
# Importation des données en listant les fichiers d'un dossier
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")

df <- import_data_excel("raw/CHip-Seq/allres.pergene.xlsx")
mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
geneID <- df[["Ensembl ID"]]

test <- getBM(attributes = c("mgi_symbol", "ensembl_gene_id"), filters = "ensembl_gene_id", values = geneID, mart = mouse)
df <- merge(df, test, by.x = "Ensembl ID", by.y = "ensembl_gene_id", all=TRUE)


names(df)[names(df) == "mgi_symbol"] <- "Gene name"
write.table(df, file = "raw/CHip-Seq/allres.txt", row.names = F, sep="\t", quote = F)