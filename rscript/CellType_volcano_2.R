setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/")
library(gridExtra)
source("src/volcano_plot.R")

# Impotation des données: le dataset, la gene list, les noms de colonnes de tout les samples
df <- import_data_excel(dataPath = "raw/LNCA/S1610_genesdiff_NeuronVsGlia.xlsx")
genelist <- import_data_txt("genelist/mouseGenes.tsv")
df_filtered <- filter_data(df, genelist, "Gene name", "MGI.symbol")
col_samples <- import_data_txt("raw/LNCA/colname.txt")
col_samples <- col_samples[[1]]
col_samples <- as.vector(col_samples)

# Boucle qui itère sur chaque nom de colonne (2 à 2 -> log fold + pval)
# Crée les volcano, crée le dataframe des interacteurs differtiellement exprimés
for (i in seq(1,2,2)){
  p1 <- create_volcano(df, "Gene name", 
                       col_samples[i],
                       col_samples[i+1], 
                       logFC_treshold = 0.0001, title = col_samples[i])
  p2 <- create_volcano(df_filtered, "Gene name", 
                       col_samples[i],
                       col_samples[i+1], 
                       logFC_treshold = 0.0001, title = paste(col_samples[i], " filtered w/ interactors", sep=""))
  
  updown_df_filtered <- retrieve_signif_genes(df_filtered, gene_name_col = "Gene name" , 
                                              col_samples[i], 
                                              col_samples[i+1], logFC_treshold = 0, pval_treshold = 0.05)
  
  grid.arrange(p1, p2, nrow=1)

}
###########################################################
# Réalisation du test binomiale (hors boucle donc pour une seule condition pour tester.)
# Code dans la boucle dans le cas du rapport
# Calcul proba de reférence (biais initial)
df <- as.data.frame(df)
updown_df_ref <- retrieve_signif_genes(df, gene_name_col = "Gene name" , 
                                        col_samples[i], 
                                        col_samples[i+1], logFC_treshold = 0, pval_treshold = 0.05)

# Compteage de up & down et formating du tableau
proportion_count <- updown_df_ref  %>% 
  group_by(regulation) %>% 
  count() %>% as.data.frame()
row.names(proportion_count) <- proportion_count$regulation
proportion_count[1] <- NULL
proportion_count[is.na(proportion_count)] <- 0

# Stockage des nombre de succès et échec (up & down)
n_down <- 0
n_up <- 0
ref_proba <- 0
tryCatch({n_down <-  proportion_count[['down','n']]}, error=function(e){})
tryCatch({n_up <- proportion_count[['up','n']]}, error=function(e){})
n_total <- n_down + n_up
tryCatch({ref_proba <- n_down/n_total}, error=function(e){})
# Sélection des genes juste sur un seuil de pval & interacteurs
updown_df_pval <- retrieve_signif_genes(df_filtered, gene_name_col = "Gene name" , 
                                        col_samples[i], 
                                        col_samples[i+1], logFC_treshold = 0, pval_treshold = 0.05)
# Comptage du nb de genes up & down
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
  prop_test <- binom.test(proportion_count[['down', 'n']], n_total, ref_proba)
  cat("\n**Binomial test** P(Interactor=Left) = [", prop_test$conf.int, "] | P-value = ",
    prop_test$p.value, "\n")
  }, error=function(e){})

tryCatch({
  prop_test <- binom.test(proportion_count[['up', 'n']], n_total, 0.5)
  cat("\n**Binomial test** P(Interactor=Right) = [", prop_test$conf.int, "] | P-value = ",
    prop_test$p.value, "\n")
}, error=function(e){})
