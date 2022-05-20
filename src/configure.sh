#!/bin/bash

script_dir=$PWD

apt-get install -y curl


which conda || which anaconda > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
            	 echo "
                      #########################################

                        Anaconda or Miniconda3 not installed

                      #########################################  

                                 So let's install it

                      #########################################
 
                             Installing Miniconda now !!

                      #########################################
                      
     For further reading visit https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html

                      #########################################
                "
                
                curl -O https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh
                bash Miniconda3-py39_4.11.0-Linux-x86_64.sh -b -p $HOME/miniconda
                eval "$($HOME/miniconda/bin/conda shell.bash hook)"
                conda init
                source ~/.bashrc
                
                echo "
                      ##########################################
                      
                                Miniconda is Installed      
                                
                      ##########################################
                      "
                ## Creating and activating conda environment named ngs
                conda create -q -y -n ngs python=3
                conda activate ngs
                rm Miniconda3-py39_4.11.0-Linux-x86_64.sh
                
                
        else
              	conda create -q -y -n ngs python=3
                conda activate ngs
                echo "
                      #########################################

                          Anaconda or Miniconda3 installed

                      #########################################  
                 "
fi


which fastqc >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
            	  echo "
                      #########################################

                               fastqc not installed

                      #########################################  

                                So let's install it

                      #########################################

                              Installing fastqc now !!

                      #########################################
                      "
                conda install -q -y -c bioconda fastqc
                
                echo "
                      ##########################################
                      
                                   Installed fastqc      
                                
                      ##########################################
                      "
                echo " 
                
                for more information visit https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
                
                "
        else
               	echo "
                      ##########################################
                      
                             fastqc is already installed      
                                
                      ##########################################
                      "
fi

which multiqc >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
                echo "
                      #########################################

                               multiqc not installed

                      #########################################  
 
                                So let's install it

                      #########################################

                              Installing multiqc now !!

                      #########################################
                      "
                conda install -q -y -c bioconda multiqc
                
                echo "
                      ##########################################
                      
                                Installed multiqc      
                                
                      ##########################################
                      "
                echo " 
                
                For further reading  visit https://multiqc.info/ 
                
                "
        else
              	echo "
                      ##########################################
                      
                             multiqc is already installed      
                                
                      ##########################################
                      "
fi





which hisat2 >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
            	 echo "
                      #########################################

                                hisat2 not installed

                      #########################################  

                                So let's install it

                      #########################################
 
                              Installing hisat2 now !!

                      #########################################
                      "
                conda install -q -y -c bioconda hisat2
                
                echo "
                      ##########################################
                      
                                Installed hisat2      
                                
                      ##########################################
                      "
                
                echo " 
                
                For further reading https://daehwankimlab.github.io/hisat2/#:~:text=HISAT2%20is%20a%20fast%20and,for%20graphs%20(Sir%C3%A9n%20et%20al.
                
                "
        else
              	echo "
                      ##########################################
                      
                             hisat2 is already installed      
                                
                      ##########################################
                      "
fi



which samtools >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
              	 echo "
                      #########################################

                              samtools not installed

                      #########################################  

                              So let's install it

                      #########################################

                           Installing samtools now !!

                      #########################################
                      "
                conda install -q -y -c bioconda samtools
                
                echo "
                      ##########################################
                      
                                Installed samtools      
                                
                      ##########################################
                      "
                
                echo " Please visit http://www.htslib.org/ "
        else
            	  echo "
                      ##########################################
                      
                             samtools is already installed      
                                
                      ##########################################
                      "
fi

which stringtie >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
              	echo "
                      #########################################

                              stringtie not installed

                      #########################################  

                              So let's install it

                      #########################################

                           Installing stringtie now !!

                      #########################################
                      "
                conda install -q -y -c bioconda stringtie
                echo "
                      ##########################################
                      
                                Installed stringtie      
                                
                      ##########################################
                      "
 
                echo " Please visit https://ccb.jhu.edu/software/stringtie/#:~:text=StringTie%20is%20a%20fast%20and,variants%20for%20each%20gene%20locus. "
        else
              	echo "
                      ##########################################
                      
                             stringtie is already installed      
                                
                      ##########################################
                      "
fi

which gffcompare > /dev/null 2>&1

if [[ $? -ne 0 ]]; then
              	echo "
                      #########################################

                              gffcompare not installed

                      #########################################  

                              So let's install it

                      #########################################

                           Installing gffcompare now !!

                      #########################################
                      "
                conda install -q -y -c bioconda gffcompare
                
                echo "
                      ##########################################
                      
                                Installed gffcompare      
                                
                      ##########################################
                      "
                
                
        else
            	  echo "
                      ##########################################
                      
                             gffcompare is already installed      
                                
                      ##########################################
                      "
fi

which gffread >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
            	  echo "
                      #########################################

                              gffread not installed

                      #########################################  

                              So let's install it

                      #########################################

                             Installing gffread now !!

                      #########################################
                      "
                conda install -q -y -c bioconda gffread
                
                echo "
                      ##########################################
                      
                                 Installed gffread      
                                
                      ##########################################
                      "
                
                
        else
              	echo "
                      ##########################################
                      
                             gffread is already installed      
                                
                      ##########################################
                      "
fi

which htseq-count >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
              	echo "
                      #########################################

                                 htseq not installed

                      #########################################  

                                 So let's install it

                      #########################################

                               Installing htseq now !!

                      #########################################
                      "
                conda install -q -y -c bioconda htseq
                
                echo "
                      ##########################################
                      
                                  Installed htseq      
                                
                      ##########################################
                      "
               
               
        else
              	echo "
                      ##########################################
                      
                             htseq is already installed      
                                
                      ##########################################
                      "
fi

which R > dev/null 2>&1


if [[ $? -ne 0 ]]; then
              	echo "
                      #########################################

                                 r not installed

                      #########################################  

                                 So let's install it

                      #########################################

                               Installing r now !!

                      #########################################
                      "
                      
                     conda install -q -y -c r r
                     
                     echo "
                      ##########################################
                      
                                  Installed r      
                                
                      ##########################################
                      "
            else
              	
                        
                        
                        echo "
                      ##########################################
                      
                             r is already installed      
                                
                      ##########################################
                      "
fi
                     

# Downloading Reference annotation file from Gencode

mkdir -p /opt/genome/human/hg38/annotation
curl -OL "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz"
mv *.annotation.gtf.gz /opt/genome/human/hg38/annotation
cd /opt/genome/human/hg38/annotation
gzip -d gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz

# create splice site file
hisat2_extract_splice_sites.py gencode.v40.chr_patch_hapl_scaff.annotation.gtf > gencode.v40.splicesite.annotation.ss

# Downloading reference genome

cd $script_dir
curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
mkdir -p /opt/genome/human/hg38/ref_gen
mv hg38.fa.gz /opt/genome/human/hg38/ref_gen
cd /opt/genome/human/hg38/ref_gen
gzip -d hg38.fa.gz

#index building 

hisat2-build hg38.fa gh38

# Installing R packages

R -e 'install.packages(c("BiocManager", "ggrepel", "dplyr", "ggplot", "data.table"));source("https://bioconductor.org/biocLite.R");biocLite(c("DESeq2"))'


