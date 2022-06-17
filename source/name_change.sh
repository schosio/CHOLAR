#!/bin/bash

# path for map file, example /home/username/map.txt
input=$1
cd $input
map_file=$2

#create a for loop to collect the files for which name has to chnaged 
for i in *.fastq
        do
	# storing first part of the filename which has to checked in mapping file
	name=$(echo $i | awk -F "_" '{print $1}')
	# storing second part of the filename which will be used as it is in new filename
        ext=$(echo $i | awk -F "_" '{print $2}')
	# starting while to open map file
        while read -r line
                do
		# storing first value of given line in the map file
                first=$( echo $line | awk '{print $1}')
		# storing second value of the given line in the map file
                second=$( echo $line | awk '{print $2}')
		# checking the old filename agaist first value in map file
                if [ $name == $first ]
                then
		# if the condition is true, changing the filename using corresponding second value in the map file 
		mv ${name}_${ext} ${second}-${name}_${ext}
                fi
                done < ${map_file}
        done
