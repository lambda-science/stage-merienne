setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
source("src/volcano_plot.R")
df <- read.table(file="C:/Users/Glados/Documents/GitHub/stage-merienne/results/chip/Q140-compare/export_low_all.bed",
              row.names = NULL, sep="\t", header = FALSE)
df2 <- read.table(file="C:/Users/Glados/Documents/GitHub/stage-merienne/results/chip/Q140-compare/export_low_interact.bed",
                  row.names = NULL, sep="\t", header = FALSE)

gene_all <- as.vector(df["V5"])
gene_all <- unique(gene_all)
gene_inter <- as.vector(df2["V5"])
gene_inter <- unique(gene_inter)

intess <- intersect(gene_all, gene_inter)
