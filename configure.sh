#!/bin/bash
 
# variables
Ubu="Ubuntu"
Cen="CentOS Linux"

linux_dep=( zenity curl parallel python3-pip git libcurl4-openssl-dev libmagick++-dev libmariadbclient-dev libssl-dev)
os=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')


if [ "$(uname)" == "Darwin" ]; then
            for i in ${linux_dep[@]}; do
                        brew install -y $i
                        done
fi                        

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

            for i in ${linux_dep[@]}; do
                        if [[ $os==$Ubu ]]; then
                                    apt-get install -y $i
                        elif [[ $os==$Cen ]]; then
                                    yum install -y $i
                        fi
                        done
 fi
            



script_dir=$PWD

###########################    ##############################

which curl >/dev/null 2>&1 
if [[ $? -ne 0 ]]; then 

	mkdir -p /opt/application
	cd /opt/application
	wget -c https://github.com/curl/curl/releases/download/curl-7_55_0/curl-7.55.0.tar.gz 
	tar -xvzf curl-7.55.0.tar.gz
	rm curl-7.55.0.tar.gz
	cd curl-7.55.0/  
	./configure
	make 
	make install
	cd ..
fi

###########################    ##############################

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
                if [ "$(uname)" == "Darwin" ]; then
                            # curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
               
                if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
                            curl -O https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh
                            bash Miniconda3-py39_4.11.0-Linux-x86_64.sh -b 
                            eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
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
			    conda init bash
			    source ~/.bashrc
                            conda activate ngs
                            echo "
                                  #########################################

                                      Anaconda or Miniconda3 installed

                                  #########################################  
                             "
		 fi
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

which R > /dev/null 2>&1


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
                     
                     
                     conda config --add channels conda-forge
                     conda config --set channel_priority strict
                     conda install -q -y -c conda-forge r-base
                     
                     
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
                      r_ver=$(R --version | grep "R version" | cut -d " " -f3 | cut -d "." -f1)
                      if [[ $r_ver<=3 ]]; then
                        conda config --add channels conda-forge
                        conda config --set channel_priority strict
                        conda update -c conda-forge r-base
		      fi
fi
                     

# download and place Trimmomatic
d1=/opt/software
f1=//opt/software/Trimmomatic-0.39.zip
if [[ ! -d "$d1" ]]; then
	mkdir -p /opt/software
	if [[ ! -f "$f1" ]]; then
		curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
		mv Trimmomatic-0.39.zip $d1
		cd $d1
		unzip Trimmomatic-0.39.zip
	
	fi
fi

# install CPAT
pip3 install CPAT

#downloading Cpat files

#mkdir -p /opt/genome/human/CPAT
#curl -OL "https://github.com/schosio/CHOLAR/blob/f713ab972a42e31dac29e155053c606eed67826c/files/Human.logit.RData"
#mv Human.logit.RData /opt/genome/human/CPAT

#curl -OL "https://github.com/schosio/CHOLAR/blob/f713ab972a42e31dac29e155053c606eed67826c/files/Human_Hexamer_hg38.tsv"
#mv Human_Hexamer_hg38.tsv /opt/genome/human/CPAT



# Downloading Reference annotation file from Gencode

d2=/opt/genome/human/hg38/annotation
f2=/opt/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf
if [[ ! -d "$d2" ]]; then
	mkdir -p /opt/genome/human/hg38/annotation
	if [[ ! -f "$f2" ]]; then
		curl -OL "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz"
		mv *.annotation.gtf.gz /opt/genome/human/hg38/annotation
		cd /opt/genome/human/hg38/annotation
		gzip -d gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz
		
	fi
fi

# create splice site file
f3=/opt/genome/human/hg38/annotation/gencode.v40.splicesite.annotation.ss
if [[ ! -f "$f3" ]]; then
	hisat2_extract_splice_sites.py gencode.v40.chr_patch_hapl_scaff.annotation.gtf > gencode.v40.splicesite.annotation.ss
fi
# Downloading reference genome

d3=/opt/genome/human/hg38/ref_gen
f4=/opt/genome/human/hg38/ref_gen/hg38.fa

if [[ ! -d "$d3" ]]; then
	mkdir -p /opt/genome/human/hg38/ref_gen
	if [[ ! -f "$f4" ]]; then
		cd $script_dir
		curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
		mv hg38.fa.gz /opt/genome/human/hg38/ref_gen
		cd /opt/genome/human/hg38/ref_gen
		gzip -d hg38.fa.gz
	fi
fi

#index building 

f5=/opt/genome/human/hg38/ref_gen/gh38.1.ht2
if [[ ! -f "$f5" ]]; then
	hisat2-build hg38.fa hg38
fi
# Installing R packages

R -e 'if (!requireNamespace("BiocManager", quietly = TRUE));install.packages("BiocManager")'

R -e 'install.packages(c("BiocManager", "ggrepel", "dplyr", "ggplot", "data.table"), repos="https://cloud.r-project.org")'

R -e 'pkgs <- rownames(installed.packages());BiocManager::install(pkgs, type = "source", checkBuilt = TRUE);BiocManager::install("DESeq2")'


