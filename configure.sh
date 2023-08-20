#!/bin/bash
# Script Name: configure.sh
# Author: Haneesh J
# Date: September 23, 2021
#
# Description: The following script is to configure the linux (UBUNTU or CentOS) system with NGS tools and files 
#              required for RNA-seq analysis i.e. reference genome, reference annotation file 
#
#
# Input type: NA
# Output: NA
#
#
#

linux_dep=( zenity curl parallel python3-pip git libcurl4-openssl-dev \
        libmagick++-dev libmariadbclient-dev libssl-dev r-base)


if [[ -n "$( uname | grep Darwin)" ]]
        then
        
        for i in ${linux_dep[@]}
                do
                echo "
              #########################################
                           System is macOS 
              #########################################  
                         Checking dependencies
              ######################################### 
                     Installing the $i !!
              #########################################"
                brew install $i
                done                        

elif [[ -n "$(expr substr $(uname -s) 1 5 | grep Linux)" ]]
        then
        
        if [[ -n "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' \
                | grep Ubuntu)" ]]
                then
                
                sudo apt-get update -y
                sudo apt-get upgrade -y
                for i in ${linux_dep[@]}
                        do
                        echo "
              #########################################
                           System is Ubuntu
              #########################################  
                         Checking dependencies
              ######################################### 
                     Installing the $i !!
              #########################################"
                        sudo apt-get install -y $i
                        done

        elif [[ -n "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' \
                | grep CentOS)" ]]
                then
                
                sudo yum update -y
                sudo yum upgrade -y
                for i in ${linux_dep[@]}
                        do
                        echo "
              #########################################
                           System is CentOS
              #########################################  
                         Checking dependencies
              ######################################### 
                     Installing the $i !!
              #########################################"
                        sudo yum install -y $i
                        done
        fi
        
 fi
            



script_dir=$PWD

###########################    ##############################

 
if [[ -z "$(which curl | grep curl)" ]]
        then 

	sudo mkdir -p $HOME/C_files/application
	cd $HOME/C_files/application
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

genome_dep=( fastqc multiqc hisat2 samtools )


if [[ -n "$( uname | grep Darwin)" ]]
        then
        
        for i in ${genome_dep[@]}
                do
                echo "
              #########################################
                           System is macOS 
              #########################################  
                         Checking dependencies
              ######################################### 
                     Installing the $i !!
              #########################################"
                brew install $i
                done                        

elif [[ -n "$(expr substr $(uname -s) 1 5 | grep Linux)" ]]
        then
        
        if [[ -n "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' \
                | grep Ubuntu)" ]]
                then

                for i in ${genome_dep[@]}
                        do
                        if [[ -z "$(which $i | grep $i)" ]]
				then
        			echo "
              #########################################
                         $i not installed
              #########################################  
                         So let's install it
              #########################################
                       Installing $i now !!
              #########################################
              "
        			sudo apt-get install -y $i
        
       		 		echo "
              ##########################################
              
                          Installed $i      
                        
              ##########################################
              "
               
			else
      				echo "
              ##########################################
              
                     $i is already installed      
                        
              ##########################################
              "
			fi
			
		
                        done

        elif [[ -n "$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"' \
                | grep CentOS)" ]]
                then
                
                for i in ${genome_dep[@]}
                        do
                        if [[ -z "$(which $i | grep $i)" ]]
				then
        			echo "
              #########################################
                         $i not installed
              #########################################  
                         So let's install it
              #########################################
                       Installing $i now !!
              #########################################
              "
        			sudo apt-get install -y $i
        
       		 		echo "
              ##########################################
              
                          Installed $i      
                        
              ##########################################
              "
               
			else
      				echo "
              ##########################################
              
                     $i is already installed      
                        
              ##########################################
              "
			fi
                        done
        fi
        
 fi

 #######################  ###########################################


if [[ -z "$(which htseq-count | grep htseq-count)" ]]
then
        
        pip install HTSeq
        
               
else
      	echo "
              ##########################################
              
                     HTSeq is already installed      
                        
              ##########################################
              "
fi





# download and place Trimmomatic
d1=$HOME/C_files/application
f1=$HOME/C_files/application/Trimmomatic-0.39.zip
if [[ ! -d "$d1" ]]
then
	mkdir -p $HOME/C_files/application
	if [[ ! -f "$f1" ]]
        then
		curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
		mv Trimmomatic-0.39.zip $d1
		cd $d1
		unzip Trimmomatic-0.39.zip
	
	fi
elif [[ (-d "$d1") && (! -f "$f1") ]]
then
        curl -O http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
	mv Trimmomatic-0.39.zip $d1
	cd $d1
	unzip Trimmomatic-0.39.zip
elif [[ (! -d $HOME/C_files/application/Trimmomatic-0.39) && ( -f "$f1") ]]
then
        unzip $f1
else 
        echo" Trimmomatic is present"

fi

# download and place stringtie, gffcompare, gffread
d1=$HOME/C_files/application
if [[ ! -d "$d1" ]]
then
	mkdir -p $HOME/C_files/application
	if [[ -z "$(which stringtie | grep stringtie)" ]]
        then
		wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-2.1.6.Linux_x86_64.tar.gz
  		tar -xzvf stringtie-2.1.6.Linux_x86_64.tar.gz
		cd stringtie-2.1.6.Linux_x86_64
		make release
	
	fi
elif [[ (-d "$d1") && (-z "$(which stringtie | grep stringtie)") ]]
then
        wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-2.1.6.Linux_x86_64.tar.gz
  	tar -xzvf stringtie-2.1.6.Linux_x86_64.tar.gz
	cd stringtie-2.1.6.Linux_x86_64
	make release
else 
        echo" stringtie is present"

fi
########
if [[ -z "$(which gffcompare | grep gffcompare)" ]]
then
        wget http://ccb.jhu.edu/software/stringtie/dl/gffcompare-0.12.6.Linux_x86_64.tar.gz
	tar -xzvf gffcompare-0.12.6.Linux_x86_64.tar.gz
	cd gffcompare-0.12.6.Linux_x86_64/
else 
        echo " is present"
fi

# install CPAT

if [[ -z "$(which cpat.py | grep cpat.py)" ]]
then
        pip3 install CPAT
else 
        echo "CPAT is present"
fi
#downloading Cpat files

#mkdir -p /opt/genome/human/CPAT
#curl -OL "https://github.com/schosio/CHOLAR/blob/f713ab972a42e31dac29e155053c606eed67826c/files/Human.logit.RData"
#mv Human.logit.RData /opt/genome/human/CPAT

#curl -OL "https://github.com/schosio/CHOLAR/blob/f713ab972a42e31dac29e155053c606eed67826c/files/Human_Hexamer_hg38.tsv"
#mv Human_Hexamer_hg38.tsv /opt/genome/human/CPAT



# Downloading Reference annotation file from Gencode

d2=$HOME/C_files/genome/human/hg38/annotation
f2=$HOME/C_files/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf
if [[ (! -d "$d2") && (! -f "$f2") ]]
then
	mkdir -p $HOME/C_files/genome/human/hg38/annotation
        curl -OL "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz"
	sudo mv *.annotation.gtf.gz $HOME/C_files/genome/human/hg38/annotation
	cd $HOME/C_files/genome/human/hg38/annotation
	sudo gzip -d gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz
elif [[ ( -d "$d2") && (! -f "$f2") ]]
then
        curl -OL "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz"
	sudo mv *.annotation.gtf.gz $HOME/C_files/genome/human/hg38/annotation
	cd $HOME/C_files/genome/human/hg38/annotation
	sudo gzip -d gencode.v40.chr_patch_hapl_scaff.annotation.gtf.gz
else
        echo " Annotation file is present"
		
fi

# create splice site file
f3=$HOME/C_files/genome/human/hg38/annotation/gencode.v40.splicesite.annotation.ss
if [[ ! -f "$f3" ]]
then
	hisat2_extract_splice_sites.py $HOME/C_files/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf \
         > gencode.v40.splicesite.annotation.ss
else 
        echo "splice site file is present"
fi
# Downloading reference genome

d3=$HOME/C_files/genome/human/hg38/ref_gen
f4=$HOME/C_files/genome/human/hg38/ref_gen/hg38.fa

if [[ (! -d "$d3") && (! -f "$f4") ]]
then
	mkdir -p $HOME/C_files/genome/human/hg38/ref_gen
        cd $script_dir
	curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
	mv hg38.fa.gz $HOME/C_files/genome/human/hg38/ref_gen
	cd $HOME/C_files/genome/human/hg38/ref_gen
	gzip -d hg38.fa.gz

elif [[ (-d "$d3") && (-f "$f4.gz") && (! -f "$f4") ]]
then
        rm *.gz
        cd $script_dir
	curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
	mv hg38.fa.gz $HOME/C_files/genome/human/hg38/ref_gen
	cd $HOME/C_files/genome/human/hg38/ref_gen
	gzip -d hg38.fa.gz

elif [[ (-d "$d3") && (! -f "$f4") ]]
then
	cd $script_dir
	curl -OL "http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz"
	mv hg38.fa.gz $HOME/C_files/genome/human/hg38/ref_gen
	cd $HOME/C_files/genome/human/hg38/ref_gen
	gzip -d hg38.fa.gz
else
        echo " reference genome file is present"

fi

#index building 

f5=$HOME/C_files/genome/human/hg38/ref_gen/hg38.1.ht2
if [[ ! -f "$f5" ]]
then
	hisat2-build hg38.fa hg38.fa
else
        echo " indexed genome is present"
fi
# Installing R packages

Rscript $script_dir/source/conf.R
