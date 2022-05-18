#!/bin/bash
#####################################################################
#  SRR_Acc.txt file contains SRR identfiers of the respecive SRA files in following format: separated by newline
# SRR5370445
# SRR5370445
####

# srr_acc is location of SRR.Acc.txt file
srr_acc=SRR_Acc.txt

# out_dir=location of output directory
out_dir=

# for checking space
touch temp_space.txt
temp=0
while read -r line; do
                        space=$(vdb-dump --info $line | grep size | awk -F ":" '{print $2}'| tr -d ',')
                        temp=$(( $temp + $space ))
                    done < ${srr_acc}
# spcae in GB
new=$((temp*10))
new=$(echo $new | awk '{print $1/1024/1024/1024}')

echo
echo
echo
echo "###############################################################"
echo "


      	********************************************************
        *                                                      *
        *                                                      *
        * Space required for all the samples is $new GB
        *                                                      *
        *                                                      *
        ********************************************************
        "
echo
echo
echo "###############################################################"
echo
echo

while read -r line; do
                # Reading each line
                        echo $line
                        ls ${line}*
                        if [ $? -ne 0 ]
                            then
                              fasterq-dump -p $line -O ${out_dir}
                        else 
                          exit
                        done < ${srr_acc}
