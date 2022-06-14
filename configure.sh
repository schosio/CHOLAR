#!/bin/bash
 

linux_dep=( zenity curl parallel python3-pip git libcurl4-openssl-dev libmagick++-dev libmariadbclient-dev libssl-dev)


if [[ -n "$( uname | grep Darwin)" ]]; then
        for i in ${linux_dep[@]}; do
                sudo brew install -y $i
                done                        

elif [[ -n "$(expr substr $(uname -s) 1 5) | grep Linux" ]]; then

        for i in ${linux_dep[@]}; do
                if [[ -n "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' | grep Ubuntu)" ]]; then
                        sudo apt-get update -y
                        sudo apt-get upgrade -y
                        sudo apt-get install -y $i
                elif [[ -n "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' | grep CentOS)" ]]; then
                        sudo yum update -y
                        sudo yum upgrade -y
                        sudo yum install -y $i
                fi
                done
 fi
            



script_dir=$PWD

###########################    ##############################

 
if [[ -z "$(which curl | grep curl)" ]]; then 

	sudo mkdir -p /opt/application
	cd /opt/application
	wget -c https://github.com/curl/curl/releases/download/curl-7_55_0/curl-7.55.0.tar.gz 
	tar -xvzf curl-7.55.0.tar.gz
	rm curl-7.55.0.tar.gz
	cd curl-7.55.0/  
	sudo ./configure
	sudo make 
	sudo make install
	cd ..
fi

###########################    ##############################


if [[ (-z "$(which conda | grep conda)") && (-n "$( uname | grep Darwin)") ]]; then
        echo "
              #########################################
              System is macOS and conda is not installed
              #########################################  
                         So let's install it
              ######################################### 
                     Installing Miniconda now !!
              #########################################
        
        For further reading visit https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
              #########################################"
        # curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

        
elif [[ (-z "$(which conda | grep conda)") && (-n "$(expr substr $(uname -s) 1 5) | grep Linux") ]]; then
        echo "
              #########################################
                System is LINUX and conda is not installed
              #########################################  
                         So let's install it
              ######################################### 
                     Installing Miniconda now !!
              #########################################
        
        For further reading visit https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html
              #########################################"
        curl -O https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh
        sudo bash Miniconda3-py39_4.11.0-Linux-x86_64.sh -b 
        eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
        source ~/.bashrc
        
        ## Creating and activating conda environment named ngs
        conda create -q -y -n ngs python=3
        conda activate ngs
        rm Miniconda3-py39_4.11.0-Linux-x86_64.sh
        echo "
              ##########################################
                        Miniconda is Installed 
                         on your Linux system  
                      NGS environment is created
                            and activated   
              ##########################################
              "

elif [[ -n "$(conda env list | grep ngs)" ]]; then
        source ~/anaconda3/etc/profile.d/conda.sh
        conda activate ngs
        echo "
              ##########################################
                    Miniconda is already Installed
                      NGS environment is present
                          NGS is Activated      
              ##########################################
              "
elif [[ (-n "$(which conda | grep conda)") && (-z "$(conda env list | grep ngs)") ]]; then
        conda create -q -y -n ngs python=3
	conda init bash
	source ~/.bashrc
        conda activate ngs
        echo "
              #########################################
                    NGS is created and activated
              #########################################  
         "
		 
fi



if [[ -z "$(which fastqc | grep fastqc)" ]]; then
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
        
        for more information visit https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
        
else
       	echo "
              ##########################################
              
                     fastqc is already installed      
                        
              ##########################################
              "
fi


if [[ -z "$(which multiqc | grep multiqc)" ]]; then
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



if [[ -z "$(which hisat2 | grep hisat2)" ]]; then
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




if [[ -z "$(which samtools | grep samtools)" ]]; then
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


if [[ -z "$(which stringtie | grep stringtie)" ]]; then
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


if [[ -z "$(which gffcompare | grep gffcompare)" ]]; then
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


if [[ -z "$(which gffread | grep gffread)" ]]; then
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


if [[ -z "$(which htseq-count | grep htseq-count)" ]]; then
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



if [[ -z "$(which R | grep R)" ]]; then
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
elif [[ -z "$(which R | grep envs)" ]]; then
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

elif [[ (-z "$(which R | grep envs)") && ( $(R --version | grep "R version" | cut -d " " -f3 | cut -d "." -f1) -le 3 ) ]]; then
      	
                
                
        echo "
        ##########################################
        
               r is already installed      
                  
        ##########################################
        "
        
        conda config --add channels conda-forge
        conda config --set channel_priority strict
        conda update -c conda-forge r-base
        echo "
                ##########################################
                
                       Updated R version to current one      
                          
                ##########################################
                "
	
fi                     

# download and place Trimmomatic
d1=/opt/software
f1=/opt/software/Trimmomatic-0.39.zip
if [[ ! -d "$d1" ]]; then
	sudo mkdir -p /opt/software
	if [[ ! -f "$f1" ]]; then
		curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
		sudo mv Trimmomatic-0.39.zip $d1
		cd $d1
		sudo unzip Trimmomatic-0.39.zip
	
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
	sudo mkdir -p /opt/genome/human/hg38/annotation
	if [[ ! -f "$f2" ]]; then
		curl -OL "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz"
		sudo mv *.annotation.gtf.gz /opt/genome/human/hg38/annotation
		cd /opt/genome/human/hg38/annotation
		sudo gzip -d gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz
		
	fi
fi

# create splice site file
f3=/opt/genome/human/hg38/annotation/gencode.v40.splicesite.annotation.ss
if [[ ! -f "$f3" ]]; then
	hisat2_extract_splice_sites.py /opt/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf > gencode.v40.splicesite.annotation.ss
fi
# Downloading reference genome

d3=/opt/genome/human/hg38/ref_gen
f4=/opt/genome/human/hg38/ref_gen/hg38.fa

if [[ ! -d "$d3" ]]; then
	sudo mkdir -p /opt/genome/human/hg38/ref_gen
	if [[ ! -f "$f4" ]]; then
		cd $script_dir
		curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
		sudo mv hg38.fa.gz /opt/genome/human/hg38/ref_gen
		cd /opt/genome/human/hg38/ref_gen
		sudo gzip -d hg38.fa.gz
        elif [[ -f "$f4.gz" ]]; then
                sudo rm *.gz
                cd $script_dir
		curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
		sudo mv hg38.fa.gz /opt/genome/human/hg38/ref_gen
		cd /opt/genome/human/hg38/ref_gen
		sudo gzip -d hg38.fa.gz

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
