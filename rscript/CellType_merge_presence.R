library(readxl)
library(biomaRt)
library(dplyr)

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
samples <- c("Cx3", "D1", "D2", "GLIA", "GLT", "N")

for (i in c(1:6)) {
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

#################################################################################
# Code pour avoir une matrice présence / absence
# Creation des noms de colonnes à récup. basé sur les noms de samples
sample_column <- paste(samples, "logFC", sep="_")

# Sélection des subsets et de la liste des gènes dans un dataframe à part
df_sub <- select(df_merged, "GeneID", sample_column)
gene_list <- select(df_merged, "GeneID", "Gene.name")

# Formattage avant traitement (ID gene en row names), supression col inutile
row.names(df_sub) <- df_sub$"GeneID"
row.names(gene_list) <- gene_list$"GeneID"
df_sub$GeneID <- NULL
gene_list$GeneID <- NULL

# Traitement: Valeur = présent (1), NA = absent (0)
df_sub[!is.na(df_sub)] <- TRUE
df_sub[is.na(df_sub)] <- FALSE
# Merging matrice de présence et gene name
df_presence_absence <- merge(df_sub, gene_list, by='row.names')

# Importation et filtrage par liste des interacteurs de mHTT
genelist_filt <- read.table(file="genelist/mouseGenes.tsv", row.names = NULL, sep="\t", header = TRUE)
df_presence_absence_filt <- merge(x = df_presence_absence, y = genelist_filt, by.x = 'Gene.name', by.y = 'MGI.symbol')
df_presence_absence_filt["HGNC.symbol"] <- NULL

# Formattage des tables en renommant les colonnes, organisée et triée et en les écrivant dans des fichiers
colnames(df_presence_absence) <- c("Ensembl Gene ID", "Cx3", "D1", "D2", "GLIA", "GLT", "Neurons", "Gene name")
colnames(df_presence_absence_filt) <- c("Gene name", "Ensembl Gene ID", "Cx3", "D1", "D2", "GLIA", "GLT", "Neurons")
df_presence_absence <- select(df_presence_absence, "Gene name", everything())
df_presence_absence <- df_presence_absence[order(df_presence_absence$`Gene name`),]
write.table(df_presence_absence, file="results/pres_abs/dataset.tsv", sep="\t", row.names = FALSE)
write.table(df_presence_absence_filt, file="results/pres_abs/dataset_filtred.tsv", sep="\t", row.names = FALSE)
