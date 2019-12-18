setwd("C:/Users/Glados/Documents/GitHub/stage-merienne/replicates/WTR6_neun_ac/GO")
library(ggplot2)
library(gridExtra)
library(dplyr)
ontology <- read.delim("chart_clusterA_int.txt", header=T, sep="\t")
ontology$logpval <- -log10(ontology$FDR)
ontology$Term <- substring(ontology$Term, 12)
#ontology<-ontology[!(ontology$Category=="KEGG_PATHWAY"),]

library(data.table)
ontology <- ontology[,c("Category","logpval", "Term")]
ontology$Category <- plyr::revalue(ontology[,"Category"], 
                        c("GOTERM_BP_DIRECT"="Biological Process",
                          "GOTERM_CC_DIRECT"="Cellular Component",
                          "GOTERM_MF_DIRECT"="Molecular Function"))
ontology <- data.table(ontology,key="Category")
ontology <- ontology[, head(.SD, 5), by=Category] 
ontology <- ontology[order(ontology$logpval, decreasing = T),]

# Solution pour l'ordre https://drsimonj.svbtle.com/ordering-categories-within-ggplot2-facets
ontology <- ontology %>%
  group_by(Category) %>%
  # 1. Remove grouping
  ungroup() %>%
  # 2. Arrange by
  #   i.  facet group
  #   ii. bar height
  arrange(Category, logpval) %>%
  # 3. Add order column of row numbers
  mutate(order = row_number())

ggplot(ontology, aes(order, logpval, fill = Category)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Category, scales = "free_y", ncol=1) +
  scale_x_continuous(
    breaks = ontology$order,
    labels = ontology$Term,
    expand = c(0,0)
  ) + xlab("") + ylab("-log10(FDR)") +
  coord_flip()
