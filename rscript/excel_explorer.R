library(readxl)
library(ggplot2)
library(dplyr)

# Importation de nos fichiers (dataset et gene list)
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
df <- read_excel(path="data_example/allres_S17307.xlsx", col_names = TRUE, col_types = "guess")
genelist <- read_excel(path="genelist/htt_interactors.xlsx", col_names = TRUE, col_types = "guess")

# Merging du dataset et de la gene list
df$`Gene name` = toupper(df$`Gene name`)
df_filtered <- merge(x = df, y= genelist, by.x = 'Gene name', by.y = 'Gene symbol')
as_tibble(df_filtered)

# Conversion numeric de nos colonnes p-val
df_filtered$`P-value (R6_HC vs R6_learn)` <- as.numeric(df_filtered$`P-value (R6_HC vs R6_learn)`)
df_filtered$`Adjusted p-value (R6_HC vs R6_learn)` <- as.numeric(df_filtered$`Adjusted p-value (R6_HC vs R6_learn)`)

# Ecriture de la table filtré dans un fichier
write.table(df_filtered, file = "results/df_filtered.tsv", sep = "\t", row.names = FALSE)

###############################################################
# Extraction de nos colonnes d'intérêt dans un df temporaire
df_temp <- select(df_filtered, `Gene name`, `Ensembl gene id`, `log2(R6_HC/R6_learn)`,
                  `Adjusted p-value (R6_HC vs R6_learn)`)

# Attribution des couleurs
df_temp$colors <- ifelse((df_temp$`Adjusted p-value (R6_HC vs R6_learn)` <=0.05 &
                            df_temp$`log2(R6_HC/R6_learn)`<=-0.58), "steelblue3",
                        ifelse((df_temp$`Adjusted p-value (R6_HC vs R6_learn)` <=0.05 &
                                  df_temp$`log2(R6_HC/R6_learn)`>=0.58), "red2", "grey60"))

# Plotting de nos volcano plot avec pval et pval ajustée.
ggplot(df_temp, aes(y=-log(`Adjusted p-value (R6_HC vs R6_learn)`), x=`log2(R6_HC/R6_learn)`)) +
  geom_point(colour = df_temp$colors) + ggtitle("R6_HC vs R6_learn")

ggplot(df_filtered, aes(y=-log(`P-value (R6_HC vs R6_learn)`), x=`log2(R6_HC/R6_learn)`)) + geom_point()

###############################################################
# Extraction de nos colonnes d'intérêt dans un df temporaire
df_temp <- select(df_filtered, `Gene name`, `Ensembl gene id`, `log2(R6_HC/R6_learn)`, `P-value (R6_HC vs R6_learn)`)

# Attribution des couleurs
df_temp$colors <- ifelse((df_temp$`P-value (R6_HC vs R6_learn)` <=0.05 &
                            df_temp$`log2(R6_HC/R6_learn)`<=-0.58), "steelblue3",
                         ifelse((df_temp$`P-value (R6_HC vs R6_learn)` <=0.05 &
                                   df_temp$`log2(R6_HC/R6_learn)`>=0.58), "red2", "grey60"))

# Plotting de nos volcano plot avec pval et pval ajustée.
ggplot(df_temp, aes(y=-log(`P-value (R6_HC vs R6_learn)`), x=`log2(R6_HC/R6_learn)`)) +
  geom_point(colour = df_temp$colors) + ggtitle("R6_HC vs R6_learn")

###############################################################
# Extraction de nos colonnes d'intérêt dans un df temporaire
df_temp <- select(df, `Gene name`, `Ensembl gene id`, `log2(R6_HC/R6_learn)`, `P-value (R6_HC vs R6_learn)`)

# Attribution des couleurs
df_temp$colors <- ifelse((df_temp$`P-value (R6_HC vs R6_learn)` <=0.05 &
                            df_temp$`log2(R6_HC/R6_learn)`<=-0.58), "steelblue3",
                         ifelse((df_temp$`P-value (R6_HC vs R6_learn)` <=0.05 &
                                   df_temp$`log2(R6_HC/R6_learn)`>=0.58), "red2", "grey60"))

# Plotting de nos volcano plot avec pval et pval ajustée.
ggplot(df_temp, aes(y=-log(`P-value (R6_HC vs R6_learn)`), x=`log2(R6_HC/R6_learn)`)) +
  geom_point(colour = df_temp$colors) + ggtitle("R6_HC vs R6_learn")
