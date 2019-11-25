library(gridExtra)
source("src/volcano_plot.R")

# Importation des données et filtrage
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
df <- import_data_txt("raw/merged_all.tsv")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
df_filtered <- filter_data(df, genelist, "Gene.name", "MGI.symbol")

# Cell type disponibles: "Cx3", "D1", "D2", "GLIA", "GLT", "N"
sample_name <- "GLIA"

# Creation des volcano
p1 <- create_volcano(df, "Gene.name", 
                     paste(sample_name, "_logFC", sep=""),
                     paste(sample_name, "_adj.P.Val", sep=""), 
                     logFC_treshold = 1, title = sample_name)
p2 <- create_volcano(df_filtered, "Gene.name", 
                     paste(sample_name, "_logFC", sep=""),
                     paste(sample_name, "_adj.P.Val", sep=""), 
                     logFC_treshold = 1, title = paste(sample_name, " filtered w/ interactors", sep=""))

sample_name <- "N"
p3 <- create_volcano(df, "Gene.name", 
                     paste(sample_name, "_logFC", sep=""),
                     paste(sample_name, "_adj.P.Val", sep=""), 
                     logFC_treshold = 1, title = sample_name)
p4 <- create_volcano(df_filtered, "Gene.name", 
                     paste(sample_name, "_logFC", sep=""),
                     paste(sample_name, "_adj.P.Val", sep=""), 
                     logFC_treshold = 1, title = paste(sample_name, " filtered w/ interactors", sep=""))

grid.arrange(p1, p3, p2, p4, nrow=2, ncol=2)

#######################################################
# Stacking des logfold & pval de Neurons et Glial à la main
df_NGLIA <- data.frame(df["N_logFC"], df["GLIA_logFC"], df["Gene.name"])
row.names(df_NGLIA) <- df_NGLIA$X.Gene.name
df_NGLIA <- stack(df_NGLIA)

df_NGLIAp <- data.frame(df["N_adj.P.Val"], df["GLIA_adj.P.Val"], df["Gene.name"])
row.names(df_NGLIAp) <- df_NGLIAp$X.Gene.name
df_NGLIAp <- stack(df_NGLIAp)
stacked_df <- data.frame(df_NGLIA$values, df_NGLIAp$values)
stacked_df["Gene.name"] <- "aaa"
p6 <- create_volcano(stacked_df, "Gene.name", 
                    "df_NGLIA.values",
                    "df_NGLIAp.values", 
                    logFC_treshold = 1, title = "Neurons vs Glial all genes")
grid.arrange(p6, p5, nrow=1)

df_NGLIA <- data.frame(df_filtered["N_logFC"], df_filtered["GLIA_logFC"], df_filtered["Gene.name"])
row.names(df_NGLIA) <- df_NGLIA$X.Gene.name
df_NGLIA <- stack(df_NGLIA)

df_NGLIAp <- data.frame(df_filtered["N_adj.P.Val"], df_filtered["GLIA_adj.P.Val"], df_filtered["Gene.name"])
row.names(df_NGLIAp) <- df_NGLIAp$X.Gene.name
df_NGLIAp <- stack(df_NGLIAp)
stacked_df <- data.frame(df_NGLIA$values, df_NGLIAp$values)
stacked_df["Gene.name"] <- "aaa"

# Volcano plot
p5 <- create_volcano(stacked_df, "Gene.name", 
                     "df_NGLIA.values",
                     "df_NGLIAp.values",
                     logFC_treshold = 1, title = "Interactors only")

updown_df_pval <- retrieve_signif_genes(stacked_df, gene_name_col = "Gene.name" , 
                                        "df_NGLIA.values", 
                                        "df_NGLIAp.values", logFC_treshold = 0.01, pval_treshold = 0.1)

# Compteage de up & down et formating du tableau
proportion_count <- updown_df_pval %>% 
  group_by(regulation) %>% 
  count() %>% as.data.frame()

# Formating du dataframe en virant une colonne et remplacement des possible NA en 0
row.names(proportion_count) <- proportion_count$regulation
proportion_count[1] <- NULL
proportion_count[is.na(proportion_count)] <- 0

# Assignation à variable des valeurs up & down. Si absentes du dataframe: assignation de 0
n_down <- 0
n_up <- 0
tryCatch({n_down <-  proportion_count[['down','n']]}, error=function(e){})
tryCatch({n_up <- proportion_count[['up','n']]}, error=function(e){})
n_total <- n_down + n_up

# Printing du résultat du test binomial.
# Utilisation de tryCatch car les valeurs 0 ont tendance à faire crash le code.
cat("\n N Interactor left (LFC <0): ", n_down, "\n ")
cat("\n N Interactor right (LFC >0): ", n_up, "\n ")
cat("\n N Interactor Total (pval < 0.05): ", n_total, "\n ")
tryCatch({
  prop_test <- binom.test(proportion_count[['down', 'n']], n_total, 0.5)
  cat("\n**Binomial test** P(Interactor=Left) = [", prop_test$conf.int, "] | P-value = ",
      prop_test$p.value, "\n")
}, error=function(e){})

tryCatch({
  prop_test <- binom.test(proportion_count[['up', 'n']], n_total, 0.5)
  cat("\n**Binomial test** P(Interactor=Right) = [", prop_test$conf.int, "] | P-value = ",
      prop_test$p.value, "\n")
}, error=function(e){})
                     