results <- read.csv('/Users/mokira/improved_count_files/DEG_res.csv')
results = results[!duplicated(results$X),]
#results = results[!duplicated(results$SYMBOL),]
library(ggrepel)
library(dplyr)
library(ggplot2)
out_file <- results[results$padj<0.05 & abs(results$log2FoldChange)>1,]
#results <- results[abs(results$log2FoldChange)>1,]
results=mutate(results, sig=ifelse(results$padj<0.05 & abs(results$log2FoldChange)>1, "Sig", "Not Sig"))
results = na.omit(results)
p = ggplot(results, aes(log2FoldChange, -log10(padj))) +
  geom_point(aes(col=sig)) +  ylim(c(0,2)) + xlim(c(-5,5)) +
  scale_color_manual(values=c("black", "#ca0020")) + 
  ggtitle("Volcano Plot")
p
head(results)
p+geom_text_repel(data=filter(results,padj <0.05 & abs(log2FoldChange)>2), aes(label=X))
