setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/")
source("src/volcano_plot.R")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
colnames(genelist) <- c("V4", "V5")
genelist$V4 <- NULL

df <- read.table(file="replicates/WTR6_neun_ac/clusterA.bed", row.names = NULL, sep="\t", header = FALSE)
df_interact <- merge(df, genelist, by="V5")
df_interact <- df_interact[, c(2, 3, 4, 1, 5, 6)]
write.table(df_interact, file="replicates/WTR6_neun_ac/clusterA_intert.bed", row.names = F, sep="\t", col.names = F, quote=F)
