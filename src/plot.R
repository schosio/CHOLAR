# library(BiocManager)
# calling DESeq2 library
install.package("DESeq2)")
library(DESeq2)

# directory = /path/to/count/files
directory = getwd()
# table contating count file names
meta <- data.frame('file_name'=grep('count.txt',list.files(directory),value=TRUE))
# adding empty coloumn for condition
# meta$condition <- NA
# filling values for condition
# automate the prefix input #help : https://stackoverflow.com/questions/52060891/extract-substring-in-r-using-grepl
g = regmatches(meta$file_name, regexpr("(?<=)[^ ]+(?=[-])", meta$file_name, perl = TRUE))
g2 = as.data.frame(g)
meta$condition = cbind(g2)
# for (i in 1:nrow(meta)){meta$condition[i] <- if (grepl("PCUE",meta$file_name[i])) "PCUE" else "BPHUE"}
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
sampleTable$condition<- factor(sampleTable$condition)
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
tiff("deseq2_MAplot_gt20_res2.tiff",height=1200,width=1200,res=300)
plotMA(res,ylim=c(-7,7),main='DESeq2')
dev.off()

## Output DEG file

write.csv(as.data.frame(res),file='DEG.csv')

## PLOT COUNT

tiff("plotcount_MSTRG12781.2.tiff",height=1200,width=1200,res=300)
plotCounts(dds, gene="MSTRG.12781.2", intgroup="condition")

dev.off()



#volcano plot
results <- read.csv('/DEG.csv')
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

#heatmap

meta <- data.frame('file_name'=grep('count.txt',list.files(directory),value=TRUE))
meta$file_name <- as.character(meta$file_name)
setwd(directory)
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
results <- read.csv("/home/nikola/Haneesh_exosomes/htseq_files/DEG_res.csv")
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
rownames(mat_data) <- rnames
my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)

# (optional) defines the color breaks manually for a "skewed" color transition
col_breaks = c(seq(-1,0,length=100),  # for red
               seq(0.01,0.8,length=100),           # for yellow
               seq(0.81,1,length=100))  
heatmap.2(mat_data,
          #cellnote = mat_data,  # same data set for cell labels
          main = "Heatmap",# heat map title
          scale = "row",
          #notecol="black",      # change font color of cell labels to black
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,9),     # widens margins around plot
          col=my_palette,       # use on color palette defined earlier
          #breaks=col_breaks,    # enable color transition at specified limits
          labRow=NA,
          dendrogram="column")     # only draw a row dendrogram
#Rowv="NA")            # turn off column clustering
