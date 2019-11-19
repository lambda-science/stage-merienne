library(biomaRt)
library(readxl)

# Fonction pour convertir notre liste de gène humain en liste de gène de souris grace à BiomaRt
human_to_mouse <- function(x){
  # Connection aux databses
  human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  
  # Récupération des informations (mgi_symbol) à partir de nos hgnc_symbol
  genesV2 = getLDS(attributes = c("hgnc_symbol"), filters = "hgnc_symbol", values = x , mart = human, attributesL = c("mgi_symbol"), martL = mouse, uniqueRows=T)
  return(genesV2)
}

setwd("C:/Users/Glados/Documents/GitHub/stage-merienne")
genelist <- read_excel(path="genelist/htt_interactors.xlsx", col_names = TRUE, col_types = "guess")
names(genelist) <- make.names(names(genelist))

newGeneList <- human_to_mouse(genelist[["Gene.symbol"]])
write.table(newGeneList, file="genelist/mouseGenes.tsv",row.names = FALSE, sep="\t")

#df <- read_excel(path="data_example/allres_S17307.xlsx", col_names = TRUE, col_types = "guess")
#names(df) <- make.names(names(df))
#df_filtered <- merge(x = df, y= newGeneList, by.x = 'Gene.name', by.y = 'MGI.symbol')