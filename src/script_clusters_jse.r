#!/usr/bin/Rscript
#lun. 17 juil. 2017 12:14:47 CEST
#version 1   
#script R which draw histograms of disregulated genes according to the clusters, done by Jonathan Seguin, LNCA, University of Strasbourg


options(echo=FALSE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

## Default setting when no arguments passed
if(length(args) < 1) {
  args <- c("--help")
}

## Help section
if("--help" %in% args) {
  cat("The R Script script_clusters_jse.r creates histograms image with ggplot according for dysregulated gene.\nCount of genes are distributed according to the clusters and Khi² test validates the observed count according to the expected count.\n\tVersion: 1.0\n\tcreator: Jonathan Seguin, Maxime Alvany (statistical test, visual rpresentation)\n\tlast update: Jonathan Seguin\n\n\tArguments:\n\t--arg1\t- character, name/path of file which contains the count of gene per clusters\n\t--arg2\t- character, name/path of file which contains the general distribution of genes among the clusters\n\t--help\t- print this text\n\n\tExample:\n\n\t./script_clusters_jse.r filename mainCountFile\n\n")
   
   q(save="no")
}

if(length(args) < 2){
   stop("arguments missing! See the help to have more information with option --help")
}


#see the argument
for(i in 1 : length(args)){
   print(paste(i, args[i]))
}#end for i, read arguments



# load the library
library(ggplot2)

# add source to load functions --> check, research the path for the script version
source("C:/Users/Glados/Documents/GitHub/stage-merienne/src/script-maxime/script_clusters3_max_corrected_jse.r")
source("C:/Users/Glados/Documents/GitHub/stage-merienne/src/script-maxime/ggplotImages.r")



# load the file
data_red <- read.table(args[1], sep = "\t", head = T) 

# remove the cluster F
data_red <- data_red[-grep("F", data_red$cluster),] # to improve


# create the variables
groups <- union(data_red$group1, data_red$group2)
clusters <- unique(data_red$cluster)
 

# load the files containing the total of genes per clusters (must contains the F columns)
total <- read.table(args[2], head=T, sep="\t")
# remove the cluster F --> to improve
total <- total[-grep("F", total$cluster),]
# add the frequence of cluster in the table
total <- cbind(total, freq = (total$nb_gene/sum(total$nb_gene)))


# add the expected columns
data_red <- cbind(data_red, down_exp = rep(0, times=nrow(data_red)))
data_red <- cbind(data_red, up_exp = rep(0, times=nrow(data_red)))


# determine the values for the expected columns
for(gp1 in groups[1:(length(groups)-1)]){
	for(gp2 in groups[(grep(gp1, groups)+1):length(groups)]){
		
		# find index for the subtable creation
		index <- intersect(grep(gp1, data_red$group1), grep(gp2, data_red$group2))
		
		#check the index 
		if(length(index) > 0){

			# calculation of expected values
			data_red[index, "down_exp"] <- sum(data_red[index, "down_obs"]) * total$freq
			data_red[index, "up_exp"] <- sum(data_red[index, "up_obs"]) * total$freq
		
			# save in corresponding files
			saveGGplotPdf(file=paste(paste(gp1, gp2, "hist_down",sep= "_"), ".pdf", sep=""), ggplot=f_bargraphes(data_red[index,], n= total$nb_gene))
			saveGGplotPng(file=paste(paste(gp1, gp2, "hist_down",sep= "_"), ".png", sep=""), ggplot=f_bargraphes(data_red[index,], n= total$nb_gene))
			saveGGplotSvg(file=paste(paste(gp1, gp2, "hist_down",sep= "_"), ".svg", sep=""), ggplot=f_bargraphes(data_red[index,], n= total$nb_gene))
			saveGGplotPdf(file=paste(paste(gp1, gp2, "hist_up",sep= "_"), ".pdf", sep=""), ggplot=f_bargraphes(data_red[index,], n= total$nb_gene, FALSE))
			saveGGplotPng(file=paste(paste(gp1, gp2, "hist_up",sep= "_"), ".png", sep=""), ggplot=f_bargraphes(data_red[index,], n= total$nb_gene, FALSE))
			saveGGplotSvg(file=paste(paste(gp1, gp2, "hist_up",sep= "_"), ".svg", sep=""), ggplot=f_bargraphes(data_red[index,], n= total$nb_gene, FALSE))
	
		}
	}
}


