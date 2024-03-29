library(dplyr)
library(readxl)
library(ggplot2)
source("src/ggplotImages.r")

import_data_excel <- function(dataPath) {
  # Fonction pour importer des donn�es d'un fichier excel
  # Input:  dataPath (str): chemin vers le fichier
  # Output: df (dataframe): un dataframe contenant nos donn�es
  df <- read_excel(path=dataPath, col_names = TRUE, col_types = "guess")
  return(df)
}

import_data_txt <- function(dataPath, sep="\t") {
  # Fonction pour importer des donn�es d'un fichier textuel
  # Input:  dataPath (str): chemin vers le fichier
  #         sep (str): caract�res qui s�pare les colonnes ("," pour les csv, "\t" pour tabulation)
  # Output: df (dataframe): un dataframe contenant nos donn�es
  df <- read.table(file=dataPath, row.names = NULL, sep=sep, header = TRUE)
  return(df)
}

export_data_txt <- function(dataset, PathFilename, sep="\t") {
  write.table(dataset, file=PathFilename, sep=sep, row.names = FALSE, quote=FALSE)
}

filter_data <- function(dataset, genelist, col_gene_data, col_genelist) {
  # Fonction pour filtrer notre dataset en mergeant avec la liste de genes
  # Input:  dataset (dataframe): le dataframe contenant les fold change
  #         genelist (dataframe): la liste de genes utilis�e pour filtrer
  #         col_gene_data (str): le nom de la colonne des noms de g�ne dans le dataset
  #         col_genelist (str): le nom de la colonne des noms de g�ne dans la g�ne list
  # Ouput:  dataset_filtered (dataframe): dataset filtr� par notre liste de g�nes
  dataset_filtered <- merge(x = dataset, y = genelist, by.x = col_gene_data, by.y = col_genelist)
  #as_tibble(dataset_filtered)
  return(dataset_filtered)
}


create_volcano <- function(dataset, gene_name_col, logFC_col, padj_col, logFC_treshold = 0 , pval_treshold = 0.05, 
                           title = "Volcano Plot", down_color = "steelblue3", up_color = "red2") {
  # Fonction qui retourne un object ggplot contenant notre volcano plot.
  # Input:  dataset (dataframe): le dataframe contenant les fold change
  #         gene_name_col (dataframe): le nom de la colonne des noms de g�ne dans le dataset
  #         logFC_col (str): le nom de la colonne contenant nos foldchange
  #         padj_col (str): le nom de la colonne contenant nos pvaleurs
  #         logFC_treshold (num): logFoldChange treshold
  #         pval_treshold (num): p-val treshold
  #         title: (str): Titre du volcano plot
  #         down_color: (str): couleur des points sous r�gul�
  #         up_color: (str): couleur des points upr�gul�s
  # Ouput:  p1 (ggplot object)): objet ggplot contenant le volcanoplot
  
  # Conversion des p-value en numeric
  dataset[padj_col] <- as.numeric(as.character(dataset[[padj_col]]))
  dataset[logFC_col] <- as.numeric(as.character(dataset[[logFC_col]]))
  # Creation d'un dataframe temporaire contenant les colonnes d'int�ret
  df_temp_adj <- dplyr::select(dataset, gene_name_col, logFC_col, padj_col)
  df_temp_adj <- na.omit(df_temp_adj)
  # Cr�ation d'une colonne contenant une information de couleur selon le log2FC et pvalue.
  #
  df_temp_adj$colors <- "black"
  if (logFC_treshold != 0){
    df_temp_adj$colors <- ifelse((df_temp_adj[[padj_col]] <=pval_treshold &
                                  df_temp_adj[[logFC_col]]<=-logFC_treshold), down_color,
                          ifelse((df_temp_adj[[padj_col]] <=pval_treshold &
                                  df_temp_adj[[logFC_col]]>=logFC_treshold), up_color, "black"))
  }
  # Plotting de notre volcano plot
  p1 <- ggplot(df_temp_adj, aes(y=-log10(df_temp_adj[[padj_col]]), x=df_temp_adj[[logFC_col]]) ) +
    geom_point(colour = df_temp_adj$colors) +
    geom_hline(yintercept=-log10(pval_treshold), linetype="dashed", color = "red") +
    ggtitle(title) + xlab("log2 Fold Change") + ylab("-log10(P-value adjusted)")
  return(p1)
}


retrieve_signif_genes <- function(dataset, gene_name_col, logFC_col, padj_col, 
                                  logFC_treshold = 1000 , pval_treshold = 0.05) {
  # Fonction qui retourne un dataframe contenant les g�nes diff�rentiellement exprim� dans une condition
  # Input:  dataset (dataframe): le dataframe contenant les fold change
  #         gene_name_col (dataframe): le nom de la colonne des noms de g�ne dans le dataset
  #         logFC_col (str): le nom de la colonne contenant nos foldchange
  #         padj_col (str): le nom de la colonne contenant nos pvaleurs
  #         logFC_treshold (num): logFoldChange treshold
  #         pval_treshold (num): p-val treshold
  # Ouput:  updown_df (dataframe)): dataframe contenant le nom, logFC, pval et regulation des g�nes significatifs
  
  dataset[padj_col] <- as.numeric(dataset[[padj_col]])
  # Creation d'un dataframe temporaire contenant les colonnes d'int�ret
  df_temp <- dplyr::select(dataset, gene_name_col, logFC_col, padj_col)
  
  # Ajoute d'une colonne "r�gulation" donnant l'expression des g�nes
  df_temp$regulation <- ifelse((df_temp[[padj_col]] <=pval_treshold &
                                  df_temp[[logFC_col]]<=-logFC_treshold), "down",
                               ifelse((df_temp[[padj_col]] <=pval_treshold &
                                         df_temp[[logFC_col]]>=logFC_treshold), "up", NA))
  
  # S�lection des lignes sans NA (= tout les g�nes diff�rentiellement exprim� dans cette condition)
  updown_df <- df_temp[complete.cases(df_temp), ]
  updown_df <- updown_df[order(updown_df[logFC_col], decreasing = TRUE),]
  return(updown_df)
}

auto_volcano <- function(dataset, gene_col = "Gene name", lfc_threshold = 1, pval_threshold = 0.05){
  # Fonction qui d�tecte et sauvegarde dans un dossier tout les volcano plot d'un dataset de RNA-seq 
  # contenant des colonnes log2 et Adjusted pval (sur base de fichier de l'IGBMC). 
  # Input:  dataset (dataframe): le dataframe contenant les fold change
  #         gene_col (dataframe): le nom de la colonne des noms de g�ne dans le dataset
  #         lfc_threshold (num): logFoldChange treshold
  #         pval_threshold (num): p-val treshold
  # Ouput:  Aucun, �crit des fichiers .png dans le dossier "autovolcano_output" � la racine du working directory
  index_logFC <- grep("log2", colnames(dataset))
  index_pval <- grep("Adj", colnames(dataset))
  if (dir.exists(paths = "autovolcano_output") == F){
    dir.create("autovolcano_output")
  }
  for (i in 1:length(index_logFC)){
    p1 <- create_volcano(dataset, gene_col, colnames(df)[index_logFC[i]], colnames(df)[index_pval[i]],
                         logFC_treshold=lfc_threshold, pval_treshold=pval_threshold,
                         title = substring(colnames(df)[index_logFC[i]], 5))

    saveGGplotPng(paste("autovolcano_output/",i, ".png", sep=""), p1)
  }
}
