library(readxl)
library(ggplot2)
library(dplyr)
library(gridExtra)

# Fonction pour importer notre dataset (expression differentielle) et notre liste de gèbe (optionelle)
import_data <- function(datasetPath, genelistPath = NA) {
  # Fonction pour importer notre dataset (expression differentielle) et notre liste de gèbe (optionelle)
  df <- read_excel(path=datasetPath, col_names = TRUE, col_types = "guess")
  names(df) <- make.names(names(df))
  # Importation de la genelist si spécifié (fichier généré après script de conversion)
  if(!is.na(genelistPath)) {
    genelist <- read.table(file=genelistPath, row.names = NULL, sep="\t", header = TRUE, quote = "")
    names(genelist) <- make.names(names(genelist))
  }
  return(list(df, genelist))
}

# Fonction pour filtrer notre dataset en mergeant avec la liste de genes
filter_data <- function(dataset, genelist) {
  dataset_filtered <- merge(x = dataset, y = genelist, by.x = 'Gene.name', by.y = 'MGI.symbol')
  as_tibble(dataset_filtered)
  return(dataset_filtered)
}

# Fonction qui retourne un object ggplot contenant notre volcano plot.
create_volcano <- function(dataset, condition1, condition2) {
  # Creation des noms de colonnes à sélectionner à partir des paramètes
  logFC_col <- paste("log2.", condition1, ".", condition2, ".", sep="")
  padj_col <- paste("Adjusted.p.value..", condition1, ".vs.", condition2, ".", sep = "")
  # Conversion des p-value en numeric
  dataset[padj_col] <- as.numeric(dataset[[padj_col]])
  
  # Creation d'un dataframe temporaire contenant les colonnes d'intéret
  df_temp_adj <- select(dataset, `Gene.name`, `Ensembl.gene.id`, logFC_col, padj_col)
  # Création d'une colonne contenant une information de couleur selon le log2FC et pvalue.
  df_temp_adj$colors <- ifelse((df_temp_adj[[padj_col]] <=0.05 &
                              df_temp_adj[[logFC_col]]<=-1), "steelblue3",
                           ifelse((df_temp_adj[[padj_col]] <=0.05 &
                                     df_temp_adj[[logFC_col]]>=1), "red2", "grey60"))
  
  # Plotting de notre volcano plot
  p1 <- ggplot(df_temp_adj, aes(y=-log(df_temp_adj[[padj_col]]), x=df_temp_adj[[logFC_col]]) ) +
       geom_point(colour = df_temp_adj$colors) + ggtitle(paste(condition1, "vs", condition2, "padj"))
  return(p1)
}

# Working directory + importation données. Conversion list de dataframe en deux dataframe
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
df_list <- import_data("data_example/allres_S17307.xlsx", "genelist/mouseGenes.tsv")
df <- as.data.frame(df_list[1])
genelist <- as.data.frame(df_list[2])

# Creation d'un filtrage des données par la gene list
df_filtered <- filter_data(df, genelist)

# Plotting d'une conditions d'intérêt avec et sans filtrage
p1 <- create_volcano(df, "R6_learn", "WT_HC")
p2 <- create_volcano(df_filtered, "R6_learn", "WT_HC")
grid.arrange(p1, p2, nrow=1)