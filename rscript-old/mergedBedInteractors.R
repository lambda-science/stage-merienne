setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
source("src/volcano_plot.R")
df <- read.table(file="C:/Users/Glados/Documents/GitHub/stage-merienne/raw/CHip-Seq/refGene_mm10_genebody.bed", row.names = NULL, sep="\t", header = FALSE)
genelist <- import_data_txt("genelist/mouseGenes.tsv")
gene_inter <- as.vector(genelist["V5"])
gene_inter <- unique(gene_inter)
merged <- merge(df, genelist["MGI.symbol"], by.x = "V5", by.y = "MGI.symbol")
merged <- merged[, c(2,3,4,5,1,6)]
write.table(merged, file="C:/Users/Glados/Desktop/seqMINER_1.3.4/lib/refGene_mm10_interactors.bed",
            col.names = F, row.names = F, sep = "\t", quote=F)
