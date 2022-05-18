# library(BiocManager)
# calling DESeq2 library
library(DESeq2)

# directory = /path/to/count/files
directory<-'/Users/mokira/brahma_htseq_analysis'
# table contating count file names
meta <- data.frame('file_name'=grep('count.txt',list.files(directory),value=TRUE))
# adding empty coloumn for condition
meta$condition <- NA
# filling values for condition
for (i in 1:nrow(meta)){meta$condition[i] <- if (grepl("AT",meta$file_name[i])) "AT" else "SUS"}
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
ddsHTSeq

colData(ddsHTSeq)$condition<-factor(colData(ddsHTSeq)$condition, levels=c('SUS','AT'))
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
plotMA(res1,ylim=c(-3,3),main='DESeq2')
dev.off()

## Output DEG file

write.csv(as.data.frame(res),file='DEG_res.csv')

## PLOT COUNT

tiff("plotcount_MSTRG1161.tiff",height=1200,width=1200,res=300)
plotCounts(dds, gene="MSTRG.2059.1", intgroup="condition")

dev.off()


## 
