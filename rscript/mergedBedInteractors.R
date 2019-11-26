setwd("C:/Users/Corentin/Documents/GitHub/stage-merienne")
source("src/volcano_plot.R")
df <- read.table(file="F:/seqMINER_1.3.4/lib/refGene_mm10_genebody.bed", row.names = NULL, sep="\t", header = FALSE)
genelist <- import_data_txt("genelist/mouseGenes.tsv")

merged <- merge(df, genelist["MGI.symbol"], by.x = "V5", by.y = "MGI.symbol")
write.table(merged, file="F:/seqMINER_1.3.4/lib/refGene_mm10_interactors.bed", col.names = F, row.names = F, sep = "\t")
