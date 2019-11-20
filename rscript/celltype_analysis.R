library(readxl)
library(ggplot2)
library(dplyr)
library(gridExtra)

# Fonction pour filtrer notre dataset en mergeant avec la liste de genes
filter_data <- function(dataset, genelist) {
  dataset_filtered <- merge(x = dataset, y = genelist, by.x = 'Gene.name', by.y = 'MGI.symbol')
  as_tibble(dataset_filtered)
  return(dataset_filtered)
}

# Fonction qui retourne un object ggplot contenant notre volcano plot.
create_volcano <- function(dataset, logFC_col, padj_col) {
  # Conversion des p-value en numeric
  dataset[padj_col] <- as.numeric(dataset[[padj_col]])
  
  # Creation d'un dataframe temporaire contenant les colonnes d'intéret
  df_temp_adj <- select(dataset, `Gene.name`, logFC_col, padj_col)
  # Création d'une colonne contenant une information de couleur selon le log2FC et pvalue.
  df_temp_adj$colors <- ifelse((df_temp_adj[[padj_col]] <=0.05 &
                                  df_temp_adj[[logFC_col]]<=-1), "steelblue3",
                               ifelse((df_temp_adj[[padj_col]] <=0.05 &
                                         df_temp_adj[[logFC_col]]>=1), "red2", "grey60"))
  
  # Plotting de notre volcano plot
  p1 <- ggplot(df_temp_adj, aes(y=-log(df_temp_adj[[padj_col]]), x=df_temp_adj[[logFC_col]]) ) +
    geom_point(colour = df_temp_adj$colors) + ggtitle(logFC_col)
  return(p1)
}


df <- read.table(file="raw/merged_all.tsv", row.names = NULL, sep="\t", header = TRUE)
genelist <- read.table(file="genelist/mouseGenes.tsv", row.names = NULL, sep="\t", header = TRUE)
df_filtered <- filter_data(df, genelist)
samples <- c("Cx3", "D1", "D2", "GLT", "N")

p1 <- create_volcano(df, "D2_logFC", "D2_adj.P.Val")
p2 <- create_volcano(df_filtered, "D2_logFC", "D2_adj.P.Val")
grid.arrange(p1, p2, nrow=1)
