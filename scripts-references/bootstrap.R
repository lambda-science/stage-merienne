library(ggplot2)
library(gridExtra)
library(car)

# Script pour technique de bootstrap
# Importation
setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/results/Q140-time-redo")
df <- read.delim("density_noF_all.txt", sep="\t", header = F, quote="")
sample_size <- read.delim("density_inte.txt", sep="\t", header = F, quote="")
sample_size <- nrow(sample_size)
# Création interation & dataframe
n_iter = 1000
bigDf <- data.frame()
# Boucle d'itération
for (i in seq(1:n_iter)){
  # Sampling
  my_sample <- df[sample(nrow(df), sample_size), ]
  # Calcul des moyennes de notre échantillon pour chaque bin (colonne)
  allMean <- colMeans(my_sample)
  # Ajout de cette ligne de moyenne dans notre tableau résultat
  bigDf <- rbind(bigDf, allMean)
}
# Renommage des colonnes (bin) (rbind crée des noms horribles)
colnames(bigDf) <- seq(1:815)
# Calcul des moyenne de nos 1000 iterations pour chaque bin
allMean <- colMeans(bigDf)
# Creation d'un nouveau dataframe contenant: moyenne, std, x
allMean <- as.data.frame(allMean)
# Calcule de la standard deviation
allMean$std <- apply(bigDf, 2, sd)
# x pour bins: 1 à 200
allMean$x <- seq(1:815)

# Impotation de notre courbe interacteurs
df_int <- read.delim("density_inte.txt", sep="\t", header = F, quote="")
df_int <- as.matrix(df_int)
# Moyenne + colonne de x
intMean <- colMeans(df_int)
intMean <- as.data.frame(intMean)
intMean$x <- seq(1:length(intMean[[1]]))

library(ggplot2)
library(gridExtra)
plot_area <- function(allmean, intmean, range_left, range_right, title="Area Plot"){
  p2 <- ggplot()+
    geom_area(intMean[range_left:range_right,], mapping=aes(x=x, y=intMean, fill="Interactors")) +
    geom_area(allMean[range_left:range_right,], mapping=aes(x=x, y=allMean, fill="All Genes")) +
    geom_vline(xintercept=(range_left+20), linetype="dashed", color = "red") +
    geom_vline(xintercept=(range_left+180), linetype="dashed", color = "red") + labs("Gene List") + 
    geom_errorbar(allMean[range_left:range_right,], mapping=aes(ymin=allMean-2*std, ymax=allMean+2*std, x=x), width=.2, ) +
    xlab("Bins") + ylab("Mean density (tag / 50bp)") + ggtitle(title)
  
  p3 <- ggplot()+
    geom_area(intMean[(range_left+14):(range_left+34),], mapping=aes(x=x, y=intMean, fill="Interactors")) +
    geom_area(allMean[(range_left+14):(range_left+34),], mapping=aes(x=x, y=allMean, fill="All Genes")) +
    geom_vline(xintercept=(range_left+20), linetype="dashed", color = "red") + labs("Gene List") + 
    geom_errorbar(allMean[(range_left+14):(range_left+34),], mapping=aes(ymin=allMean-2*std, ymax=allMean+2*std, x=x), width=.2, ) +
    xlab("Bins") + ylab("Mean density (tag / 50bp)") + ggtitle(paste(title, "(zoomed)"))
  return(list(p2,p3))
}
# Plotting des aires + barre d'erreur + ligne verticales
# WT 2M : 0 200 ; Q140 2M 206 405 ; WT 6M  411 610 ; Q140 6M 616 815 (intercept +20 et +180)
a = plot_area(allmean = allmean, intmean = intmean, range_left = 1, range_right = 200, title="WT 2m all cluster - K27ac signal")
b = plot_area(allmean = allmean, intmean = intmean, range_left = 206, range_right = 405, title="Q140 2m all cluster - K27ac signal")
c = plot_area(allmean = allmean, intmean = intmean, range_left = 411, range_right = 610, title="WT 6m all cluster - K27ac signal")
d = plot_area(allmean = allmean, intmean = intmean, range_left = 616, range_right = 815, title="Q140 6m all cluster - K27ac signal")
grid.arrange(a[[1]], b[[1]], c[[1]], d[[1]])
grid.arrange(a[[2]], b[[2]], c[[2]], d[[2]])