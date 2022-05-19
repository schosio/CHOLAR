#!/bin/bash

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
                bash Miniconda3-py39_4.11.0-Linux-x86_64.sh -b -p 
                source ~/.bashrc
                
                echo "
                      ##########################################
                      
                                Miniconda is Installed      
                                
                      ##########################################
                      "
                ## Creating and activating conda environment named ngs
                conda create -n ngs python=3
                conda activate ngs
                rm Miniconda3-py39_4.11.0-Linux-x86_64.sh
                
                
        else
              	conda create -n ngs python=3
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
