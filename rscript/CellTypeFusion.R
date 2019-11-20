library(readxl)
library(biomaRt)

# Importation des données en listant les fichiers d'un dossier
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
fileList <- paste("raw/LCM/", list.files("raw/LCM/"), sep="")
# Puis en important chaque fichier dans une liste qui contient les dataframes de chaque fichier
i=1
dfList <- list()
for (file in fileList){
  dfList[[i]] <- read.table(file=file, row.names = NULL, sep="\t", header = TRUE)
  df
  i = i+1
}

# Renommage des colonnes selon le cell-type et fusion des dataset ensemble sur leur GeneID
samples <- c("Cx3", "D1", "D2", "GLT", "N")

for (i in c(1:5)) {
  colnames(dfList[[i]]) <- paste(samples[i], colnames(dfList[[i]]), sep="_")
  if (i>=2){
    dfList[[1]] <- merge(dfList[[1]], dfList[[i]], by.x = "Cx3_GeneID", by.y = paste(samples[i], "GeneID", sep="_"), all=TRUE)
  }
}

# Stockage du dataframe merged et renommage de la colonne GeneID
df_merged <- dfList[[1]]
names(df_merged)[names(df_merged) == "Cx3_GeneID"] <- "GeneID"

#################################################################################
# Faire la correspondance gene_id avec gene.name et le rajouter au tableau pour croiser plus tard avec
# les interacteurs
mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
geneID <- df_merged[["GeneID"]]
test <- getBM(attributes = c("mgi_symbol", "ensembl_gene_id"), filters = "ensembl_gene_id", values = geneID, mart = mouse)
df_merged <- merge(df_merged, test, by.x = "GeneID", by.y = "ensembl_gene_id", all=TRUE)
names(df_merged)[names(df_merged) == "mgi_symbol"] <- "Gene.name"

# Ecriture du fichier merged final
write.table(df_merged, file="raw/merged_all.tsv", sep="\t", row.names = FALSE)