#!/usr/bin/Rscript
options(echo=FALSE) 
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  args <- c("--help")
} else if (length(args)==1) {
  # Threshold par défaut
  args[2] = 0.0001
  args[3] = 0.05
} else if (length(args)==2) {
  cat("Error, only two argument provided. Missing either log2FoldChange threshold or p-value adjusted threshold.\n Please provide only one argument (excel file) or three (excel file, logFC threshold, pval threshold)")
}

## Message help
if("--help" %in% args) {
  cat("The R Script autovolcano.R creates volcano plots with ggplot for all comparasaion detected in a differential expression excel file provided by IGBMC.\nPNG and SVG file results are saved in a folder called \"autovolcano_output\".\n\tVersion: 1.0\n\tAuthor: Corentin Meyer\n\n\t Arguments:\n\t --arg1\t- character, name/path of excel file containing log fold and pvalues.\n\t --arg2\t- number, log fold change threshold for colors. \n\t --arg3\t- number, pvalue threshold for colors. \n\t --help\t- print this text\n\n\t Example:\n\t Rscript autovolcano.R allres.xlsx 1 0.05")
  q(save="no")
}

# Script
source("src/volcano_plot.R")
df <- import_data_excel(args[1])
auto_volcano(df, lfc_threshold = as.numeric(args[2]), pval_threshold = as.numeric(args[3]))