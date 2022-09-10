#!/usr/bin/env Rscript


# library(BiocManager)
# calling DESeq2 library
library(DESeq2)

directory = getwd()
# table contating count file names
meta <- data.frame('file_name'=grep('count.txt',list.files(directory),value=TRUE))
# adding empty coloumn for condition
#meta$condition <- NA
# filling values for condition
#automate the prefix input #help : https://stackoverflow.com/questions/52060891/extract-substring-in-r-using-grepl
g = regmatches(meta$file_name, regexpr("(?<=)[^ ]+(?=[-])", meta$file_name, perl = TRUE))
g2 = as.data.frame(g)
meta$condition = cbind(g2)
#for (i in 1:nrow(meta)){meta$condition[i] <- if (grepl("PCUE",meta$file_name[i])) "PCUE" else "BPHUE"}
# making variable for table that'll be given as input to DESEq
# sampleFiles will have file names
sampleFiles<-as.character(meta$file_name)
# sample name
sampleFiles_name <- sapply(strsplit(sampleFiles, split=".",fixed=T),"[",1)
# condition
sampleCondition <- meta$condition
setwd(directory)
# compiling into dataframe
sampleTable<-data.frame(sampleName=sampleFiles_name, fileName=sampleFiles, condition=sampleCondition)
# converting conditions into factor
sampleTable$condition<- factor(sampleTable$g)
# starting DESEQ
ddsHTSeq<-DESeqDataSetFromHTSeqCount(sampleTable=sampleTable, directory=directory, design=~condition)
#ddsHTSeq<-DESeqDataSetFromHTSeqCount(sampleTable=sampleTable, directory=directory, design =~sampleTable$condition)
ddsHTSeq

colData(ddsHTSeq)$condition<-factor(colData(ddsHTSeq)$condition, levels=c('BPHUE','PCUE'))
# keeping rows with count > 20
ddsHTSeq <- ddsHTSeq[ rowSums(counts(ddsHTSeq)) > 20, ]
# running DESeq function
dds<-DESeq(ddsHTSeq)
# saving results in res
res<-results(dds)
# sorting based on padj values
res<-res[order(res$padj),]

## MA PLOT 

head(res)
tiff("Basic_MAplot.tiff",height=1200,width=1200,res=300)
plotMA(res,ylim=c(-7,7),main='DESeq2')
dev.off()

## Output DEG file

write.csv(as.data.frame(res),file='DEG.csv')
results <- read.csv("DEG.csv")
results = results[!duplicated(results$X),]


## Enhanced MA plot
library(scales)
library(viridis)

ResDF <- as.data.frame(results)
ResDF$significant <- ifelse(ResDF$padj < .1, "Significant", NA)

tiff("Enhanced_MAplot.tiff",height=1200,width=1200,res=300)
ggplot(ResDF, aes(baseMean, log2FoldChange, colour=padj)) + 
  geom_point(size=1) + scale_y_continuous(limits=c(-12, 12), oob=squish) + 
  scale_x_log10()  + geom_hline(yintercept = 0, colour="darkorchid4", size=1, linetype="longdash") + 
  labs(x="mean of normalized counts", y="log fold change") + 
  scale_colour_viridis(direction=-1, trans='sqrt') + theme_bw() + ggtitle("MA PLOT")
dev.off()


## PLOT COUNT
#loop to generate plot count for novel lncRNAs present in the list
#tiff("plotcount_MSTRG12781.2.tiff",height=1200,width=1200,res=300)
##dev.off()



#volcano plot


#results = results[!duplicated(results$SYMBOL),]
library(ggrepel)
library(dplyr)
library(ggplot2)
library("EnhancedVolcano")
out_file <- results[results$padj<0.05 & abs(results$log2FoldChange)>1,]
#results <- results[abs(results$log2FoldChange)>1,]
results=mutate(results, sig=ifelse(results$padj<0.05 & abs(results$log2FoldChange)>1, "Sig", "Not Sig"))
results = na.omit(results)
tiff("basic_volcano_plot.tiff",height=1200,width=1200,res=300)
ggplot(results, aes(log2FoldChange, -log10(padj))) +
  geom_point(aes(col=sig)) +  ylim(c(0,2)) + xlim(c(-5,5)) +
  scale_color_manual(values=c("black", "#ca0020")) + 
  ggtitle("Volcano Plot")
dev.off()

## enhanced volcano plot
tiff("Enhanced_volcano_plot.tiff",height=1200,width=1200,res=300)
EnhancedVolcano(results,
                lab = rownames(results),
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 10e-4,
                FCcutoff = 1,
                legendLabels=c('Not sig.','Log (base 2) FC','p-value',
                               'p-value & Log (base 2) FC'),
                legendLabSize = 12,
                legendIconSize = 5.0,
                pointSize = 2.0,
                labSize = 4.0,
                col = c('black', 'purple', 'pink', 'red3'),
                colAlpha = 4/5,
                drawConnectors = TRUE,
                widthConnectors = 0.5,
                legendPosition = 'right',
)
dev.off()

#heatmap

#meta <- data.frame('file_name'=grep('count.txt',list.files(directory),value=TRUE))
#meta$file_name <- as.character(meta$file_name)
#setwd(directory)
library(data.table)
i=1
data_count <- fread(meta$file_name[i])
colnames(data_count) <- c("gene",sapply(strsplit(meta$file_name[i], split=".",fixed=T),"[",1))
for(i in 2:nrow(meta)){
  data <- fread(meta$file_name[i])
  colnames(data) <- c("gene",sapply(strsplit(meta$file_name[i], split=".",fixed=T),"[",1))
  data_count <- merge(data_count,data,by='gene')
}
write.table(data_count, "../Matrix-Counts.txt", col.names = TRUE
            , row.names = FALSE, quote = FALSE, sep = "\t")
rm(list=ls())
matrix_1 <- fread("../Matrix-Counts.txt")
results <- read.csv("DEG.csv")
results = results[!duplicated(results$X),]
data <- subset(results, padj<0.05&abs(log2FoldChange)>1)
matrix_1 <- matrix_1[matrix_1$gene %in% data$X,]


############ Heatmaps

if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}
data <- matrix_1
rnames <- data[,1]                            # assign labels in column 1 to "rnames"
mat_data <- data.matrix(data[,2:ncol(data)])  # transform column 2-5 into a matrix
#rownames(mat_data) <- rnames
my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)

# (optional) defines the color breaks manually for a "skewed" color transition
col_breaks = c(seq(-1,0,length=100),  # for red
               seq(0.01,0.8,length=100),           # for yellow
               seq(0.81,1,length=100))  
tiff("heatmap.tiff",height=1200,width=1200,res=300)
heatmap.2(mat_data,
          #cellnote = mat_data,  # same data set for cell labels
          main = "Heatmap",# heat map title
          scale = "row",
          #notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(9,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          #breaks=col_breaks,    # enable color transition at specified limits
          labRow=NA,
          dendrogram="column",
          cexRow = 0.2 + 1/log10(74),
          cexCol = 0.1 + 1/log10(18))# only draw a row dendrogram
            
dev.off()
#Rowv="NA")            # turn off column clustering
