#!/bin/zsh




brew install -q curl
brew install -q git
brew install -q parallel
brew install -q wget
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
                conda activate ngs
                echo "
                      #########################################
                          Anaconda or Miniconda3 installed
                      #########################################  
                 "
fi
