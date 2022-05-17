#!/bin/bash

# path for map file, example /home/username/map.txt
map_file=$1

# variable for mentioning pattern of files to be picked, example .fastq
pattern=$2

# delimiter for seperating filename, example _
delim=$3
#create a for loop to collect the files for which name has to chnaged 
for i in *${pattern}
        do
	# storing first part of the filename which has to checked in mapping file
	name=$(echo $i | awk -F "${delim}" '{print $1}')
	# storing second part of the filename which will be used as it is in new filename
        ext=$(echo $i | awk -F "${delim}" '{print $2}')
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
                    	mv ${name}${delim}${ext} ${second}${delim}${ext}
                fi
                done < ${map_file}
        done
