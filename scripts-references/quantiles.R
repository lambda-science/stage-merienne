setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/")
library(gridExtra)
source("src/volcano_plot.R")
library(ggplot2)
library(tidyverse)
library(plyr)
library(reshape2)
library(ggpubr)
# Impotation des données
df <- import_data_excel(dataPath = "raw/LNCA/Q140_RNA-Seq.xlsx")

# Calcul des moyennes des réplicats (RPKM)
df$WT_RPKM <- rowMeans(df[c("WT_F1_6m (normalized read counts)",
                            "WT_F2_6m (normalized read counts)",
                            "WT_F3_6m (normalized read counts)",
                            "WT_F4_6m (normalized read counts)",
                            "WT_M1_6m (normalized read counts)",
                            "WT_M2_6m (normalized read counts)",
                            "WT_M3_6m (normalized read counts)",
                            "WT_M4_6m (normalized read counts)")], na.rm=TRUE)
df$qnt <- cut(df$WT_RPKM , breaks=quantile(df$WT_RPKM, probs=c(0, 0.25, 0.5, 0.75, 0.99, 1)),
              labels=1:5, include.lowest=TRUE)

#Filtrer pour n'avoir que les interacteurs 
genelist <- import_data_txt("genelist/mouseGenes.tsv")
df <- filter_data(df, genelist, "Gene.name", "MGI.symbol")

# On simplifie le tableau en virant des colonnes et en mettant ensembl ID en row name
df_all <- df[,c("Ensembl gene id", "WT_RPKM", "qnt")]
#row.names(df) <- df[,"Ensembl gene id"]
df_all["Ensembl gene id"] <- NULL

# Stacking des colonnes WT et R6 RPKM en conservant l'information de quantile
boxplot_df <- melt(df_all, id="qnt")
boxplot_df$qnt <- revalue(boxplot_df[,"qnt"], 
                          c("1"="<25%", "2"="25-50%", "3"="50-75%", "4"="75-99%", "5"=">99%"))
boxplot_df %>%
  ggplot(aes(x=qnt, y=value, fill=variable)) +
  geom_boxplot() +
  geom_jitter(color="grey50", size=0.1, alpha=0.3)+
  ggtitle("WT vs Q140 quantile comparaison (interactors only)") +
  scale_y_continuous(trans='log10') +
  xlab("Quantile") + ylab("Mean RPKM")

my_quantiles = c("<25%", "25-50%", "50-75%", "75-99%", ">99%")
a <- seq(1:5)
for (i in my_quantiles){
  print(i)
  print(nrow(boxplot_df[boxplot_df[,"qnt"]==i & boxplot_df[,"variable"]=="WT_RPKM",]))
}
