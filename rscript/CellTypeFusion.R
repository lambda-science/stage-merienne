library(readxl)

setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
fileList <- paste("raw/LCM/", list.files("raw/LCM/"), sep="")

i=1
dfList <- list()
for (file in fileList){
  dfList[i] <- read.table(file=file, row.names = NULL, sep="\t", header = TRUE)
  i = i+1
}
df <- as.data.frame(dfList[5])
df <- read.table(file=fileList[2], row.names = NULL, sep="\t", header = TRUE)
