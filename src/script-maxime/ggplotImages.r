# Functions  to save ggplot in files

# add the function --> to improve: put in source R files
#### fonction to save ggplot figures in png files
#   file, character, name of png file
#   ggplot, ggplot2 object, figure which must be save
#   ..., option for ggsave function
####
saveGGplotPng <- function(file, ggplot, ...){
#### fonction to save ggplot figures in png files
#   file, character, name of png file
#   ggplot, ggplot2 object, figure which must be save
#   ..., option for ggsave function
####
	png(file)
	ggplot		
	dev.off()
	ggsave(file, ...)
	print(paste(file, "saved!"))

}


#### fonction to save ggplot figures in pdf files
#   file, character, name of pdf file
#   ggplot, ggplot2 object, figure which must be save
#   ..., option for ggsave function
####
saveGGplotPdf <- function(file, ggplot, ...){
#### fonction to save ggplot figures in pdf files
#   file, character, name of png file
#   ggplot, ggplot2 object, figure which must be save
#   ..., option for ggsave function
####
	pdf(file)
	ggplot		
	dev.off()
	ggsave(file, ...)
	print(paste(file, "saved!"))
}


#### fonction to save ggplot figures in svg files
#   file, character, name of pdf file
#   ggplot, ggplot2 object, figure which must be save
#   ..., option for ggsave function
####
saveGGplotSvg <- function(file, ggplot, ...){
#### fonction to save ggplot figures in svg files
#   file, character, name of png file
#   ggplot, ggplot2 object, figure which must be save
#   ..., option for ggsave function
####
	svg(file)
	print(ggplot)		
	dev.off()
	ggsave(file, ...)
	print(paste(file, "saved!"))
}


