setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
source("src/volcano_plot.R")
basePath = "C:/Users/Glados/Documents/GitHub/stage-merienne/results/Q140-time-redo/"
file = c("clusterA.bed", "clusterB.bed", "clusterC.bed", "clusterD.bed", "clusterE.bed", "clusterF.bed")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
colnames(genelist) <- c("V4", "V5")
gene_inter <- as.vector(genelist["V5"])

for (i in file){
  df <- read.table(file=paste(basePath, i, sep=""), row.names = NULL, sep="\t", header = FALSE)
  gene_all <- as.vector(df["V5"])
  print(i)
  inter <- intersect(gene_all, gene_inter)
  print(nrow(inter))
}