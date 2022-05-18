directory<-'/Users/mokira/improved_count_files'
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
results <- read.csv("/Users/mokira/improved_count_files/DEG_res.csv")
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
