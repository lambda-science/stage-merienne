library(readxl)
library(ggplot2)
library(dplyr)

import_data_excel <- function(dataPath) {
  # Fonction pour importer des données d'un fichier excel
  # Input:  dataPath (str): chemin vers le fichier
  # Output: df (dataframe): un dataframe contenant nos données
  df <- read_excel(path=dataPath, col_names = TRUE, col_types = "guess")
  return(df)
}

import_data_txt <- function(dataPath, sep="\t") {
  # Fonction pour importer des données d'un fichier textuel
  # Input:  dataPath (str): chemin vers le fichier
  #         sep (str): caractères qui sépare les colonnes ("," pour les csv, "\t" pour tabulation)
  # Output: df (dataframe): un dataframe contenant nos données
  df <- read.table(file=dataPath, row.names = NULL, sep="\t", header = TRUE)
  return(df)
}

filter_data <- function(dataset, genelist, col_gene_data, col_genelist) {
  # Fonction pour filtrer notre dataset en mergeant avec la liste de genes
  # Input:  dataset (dataframe): le dataframe contenant les fold change
  #         genelist (dataframe): la liste de genes utilisée pour filtrer
  #         col_gene_data (str): le nom de la colonne des noms de gène dans le dataset
  #         col_genelist (str): le nom de la colonne des noms de gène dans la gène list
  # Ouput:  dataset_filtered (dataframe): dataset filtré par notre liste de gènes
  dataset_filtered <- merge(x = dataset, y = genelist, by.x = col_gene_data, by.y = col_genelist)
  as_tibble(dataset_filtered)
  return(dataset_filtered)
}


create_volcano <- function(dataset, gene_name_col, logFC_col, padj_col, logFC_treshold = 1000 , pval_treshold = 0.05, 
                           title = "Volcano Plot", down_color = "steelblue3", up_color = "red2") {
  # Fonction qui retourne un object ggplot contenant notre volcano plot.
  # Input:  dataset (dataframe): le dataframe contenant les fold change
  #         gene_name_col (dataframe): le nom de la colonne des noms de gène dans le dataset
  #         logFC_col (str): le nom de la colonne contenant nos foldchange
  #         padj_col (str): le nom de la colonne contenant nos pvaleurs
  #         logFC_treshold (num): logFoldChange treshold
  #         pval_treshold (num): p-val treshold
  #         title: (str): Titre du volcano plot
  #         down_color: (str): couleur des points sous régulé
  #         up_color: (str): couleur des points uprégulés
  # Ouput:  p1 (ggplot object)): objet ggplot contenant le volcanoplot
  
  # Conversion des p-value en numeric
  dataset[padj_col] <- as.numeric(dataset[[padj_col]])
  
  # Creation d'un dataframe temporaire contenant les colonnes d'intéret
  df_temp_adj <- select(dataset, gene_name_col, logFC_col, padj_col)
  # Création d'une colonne contenant une information de couleur selon le log2FC et pvalue.
  df_temp_adj$colors <- ifelse((df_temp_adj[[padj_col]] <=pval_treshold &
                                  df_temp_adj[[logFC_col]]<=-logFC_treshold), down_color,
                               ifelse((df_temp_adj[[padj_col]] <=pval_treshold &
                                         df_temp_adj[[logFC_col]]>=logFC_treshold), up_color, "black"))
  
  # Plotting de notre volcano plot
  p1 <- ggplot(df_temp_adj, aes(y=-log(df_temp_adj[[padj_col]]), x=df_temp_adj[[logFC_col]]) ) +
    geom_point(colour = df_temp_adj$colors) +
    geom_hline(yintercept=-log(0.05), linetype="dashed", color = "red") +
    ggtitle(title) + xlab("log2 Fold Change") + ylab("-(P-value adjusted)")
  return(p1)
}