
if (!requireNamespace(c("BiocManager", "ggrepel", "dplyr", "ggplot", "data.table"), quietly = TRUE))
	install.packages(c("BiocManager", "ggrepel", "dplyr", "ggplot", "data.table"), repos="https://cloud.r-project.org")
pkgs <- rownames(installed.packages());BiocManager::install(pkgs, type = "source", checkBuilt = TRUE);BiocManager::install("DESeq2")
