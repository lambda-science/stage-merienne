#nom fichier: test_signi_script.R
#Maxime Alvany, 08/06/17
#Version3 (degré des quantiles divisé par 2 et barplots en noir/blanc)

library(ggplot2)



f_bargraphes <- function(subtable, n, deregulate_down=T) {

# subtable : tableau de datas contenant les lignes correspondante au groupe de comparaison étudié
# n : vecteur contenant le nombre de gènes des différents clusters.
# deregulate_down : vaut FALSE ou F pour les up. TRUE ou T pour les down.
# variables attendus dans subtable :
  # groupe1, groupe2, obs_down, obs_up, exp_down, exp_up, cluster.
  # tous de la meme taille (le nombre de clusters différents, que l'on notera h)

  # création des variables
  titre <- paste(unique(subtable$group1), unique(subtable$group2), sep = " vs ")	

  # vérification s'il s'agit des gènes down ou up
  if (deregulate_down) {

    obs <- subtable$down_obs
    exp <- subtable$down_exp
    titre <- paste(titre, ", down", sep ="")

  } else {
    obs <- subtable$up_obs
    exp <- subtable$up_exp
    titre <- paste(titre, ", up", sep ="")
  }


   return(draw_bargraphes(subtable, obs, exp, n, titre))
    
  
}




draw_bargraphes <- function(subtable, obs, exp, n, titre){

    h <- length(subtable$cluster)	

    #Calcul des bar graphes
    m <- data.frame(
      datas <- factor(c(rep("obs",h),rep("exp",h))),
      cluster <- factor(rep(subtable$cluster,2),levels=subtable$cluster),
      genes <- c(obs,exp)
    )

    lab <- f_testbinom(obs, exp, h, n)

    b <- ggplot(data=m, aes(x=cluster, y=genes, fill=datas)) +
      geom_bar(stat="identity", position=position_dodge()) +
      geom_text(aes(y=c(obs,obs)+0.03*c(obs,obs),label=c(lab,rep("",nrow(subtable)))), position=position_dodge(0.9), vjust=0,size=8) +
      ggtitle(titre) + ylab("# genes") + 
      scale_fill_manual(values=c("black","grey")) +
      theme(panel.background = element_rect(fill="white", colour = 'black'),
            panel.border=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_line(colour="grey"),
            panel.spacing=unit(5, "lines"),
	    axis.title.x = element_text(face="bold", size=32), 
	    axis.title.y = element_text(face="bold", size=32), 
	    axis.text.x = element_text(size=30), 
	    axis.text.y = element_text(size=30),
	    legend.title = element_blank(),
	    legend.text = element_text(size = 29),
	    plot.title = element_text(hjust = 0.5, size=36, face="bold"))# panel.spacing remplace panel.marging dans les versions récentes de ggplot2 size 26 correspond to conversion of size 20; legend.title = element_text(size=32, face="bold"), geom_text(size=5.5)

    return(b)

}




f_main_bargraphes <- function(subtable, n) {

# subtable : tableau de datas contenant les lignes correspondante au groupe de comparaison étudié
# n : vecteur contenant le nombre de gènes des différents clusters.
# deregulate_down : vaut FALSE ou F pour les up. TRUE ou T pour les down.
# variables attendus dans subtable :
  # groupe1, groupe2, obs_down, obs_up, exp_down, exp_up, cluster.
  # tous de la meme taille (le nombre de clusters différents, que l'on notera h)

  # création des variables
  titre <- paste(unique(subtable$group1))	
  obs <- subtable$obs
  exp <- subtable$exp
  return(draw_bargraphes(subtable, obs, exp, n, titre))
  
}





f_testbinom <- function(obs, exp, h , n) {
# h = nombre égale � la taille des vecteurs obs/exp/n (= nombre de clusters étudié)
# n = vecteurs comprennant le nombre de gènes des différents clusters
# Cette fonction renvoi le vecteur des différents seuil de significativités (étoiles)

  # Calcule des quantiles
  p <- sum(exp)/sum(n)
  q_005 <- qbinom(1-0.05/(2*h),n,p) # quantile 0.05
  q_001 <- qbinom(1-0.01/(2*h),n,p) # 0.01
  q_0001 <- qbinom(1-0.001/(2*h),n,p) # 0.001

  #Construction du vecteur des seuils (les étoiles)
  etoiles1 <- "*"
  etoiles2<- "**"
  etoiles3<- "***"
  lab <- rep("",h)
  for (i in 1:h) {

    if (obs[i] >= q_0001[i] || obs[i] <= 2*exp[i]-q_0001[i]) { lab[i] <- etoiles3 }
    else if (obs[i] >= q_001[i] || obs[i] <= 2*exp[i]-q_001[i]) { lab[i] <- etoiles2 }
    else if (obs[i] >= q_005[i] || obs[i] <= 2*exp[i]-q_005[i]) { lab[i] <- etoiles1 }
    
  }# remove else {lab[i] <- "NS"}

  return(lab)
}
