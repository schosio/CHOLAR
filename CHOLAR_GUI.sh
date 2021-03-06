
description=$(zenity --forms --title="Identification of LncRNA" \
--text="Input names without (_1/_2) and other underscore ("_")" --add-entry="SAMPLE NAMES 
(sep by ',')
[Samplel,Sample2,Sample3,Sample4]" --add-entry="SAMPLE TYPES (sep by ',')
{ add condion in same order as sample } [cntrl,cntrl,treat,treat]")

[[ $? != 0 ]] && exit 1
snames=$(echo $description | cut -d'|' -f1)
stype=$(echo $description | cut -d'|' -f2)

[[ $? != 0 ]] && exit 1
array=$(echo $snames | tr "," "\n")
arr=($array)

array2=$(echo $stype | tr "," "\n")
arr2=($array2)


zenity --info --title="Annotation GTF file" --text="Select Annotation GTF file" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

GTF=$(zenity --file-selection --filename $HOME/C_files/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf \
--title="***Annotation GTF file***"  --text="Select Annoatation GTF file")
[[ $? != 0 ]] && exit 1

zenity --info --title="Splice Site file" --text="Select Splice Site file" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

SS=$(zenity --file-selection --filename $HOME/C_files/genome/human/hg38/annotation/gencode.v40.splicesite.annotation.ss \
--title="***Splice Site file***"  --text="Select Splice Site file")
[[ $? != 0 ]] && exit 1

zenity --info --title="Reference genome" --text="Select reference genome" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

REF=$(zenity --file-selection --filename $HOME/C_files/genome/human/hg38/ref_gen/hg38.fa \
--title="***Reference genome***" --text="Select reference genome")
[[ $? != 0 ]] && exit 1

zenity --info --title="Script path" --text="Select script directory" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

R=$(zenity --file-selection --directory --filename $PWD --title="***Script path***"  \
--text="Select script directory")
[[ $? != 0 ]] && exit 1

zenity --info --title="Input files directory" --text="Select Input files directory" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

IN=$(zenity --file-selection --directory --title="***Input Files directory***"  \
--text="Select Input files directory")
[[ $? != 0 ]] && exit 1

zenity --info --title="Log directory" --text="Select log directory" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

LOGF=$(zenity --file-selection --directory --filename $IN --title="***Log directory***"  \
--text="Select log directory")
[[ $? != 0 ]] && exit 1

len=${#arr[@]}
for (( idx = 0; idx < len; idx++ ));
do
        echo "${arr[idx]}       ${arr2[idx]}" >> $IN/map.txt
done

bash $R/source/name_change.sh $IN $IN/map.txt

rm $IN/map.txt


th=$(nproc --all)
th=$(($th-2))

threads=$(zenity --scale --title="Threads" --text="For faster analysis, select more no of threads" --max-value=$th)
[[ $? != 0 ]] && exit 1

echo "

sample_names = "$snames"

sample_types = "$stype"

GTF_file = "$GTF"

reference_genome = "$REF"

script_directory = "$R"

input_directory = "$IN"

log_directory = "$LOGF"

threads = "$threads | zenity --text-info --title="Summary" --width=700 --height=600 --ok-label="OK" --cancel-label="Cancel"


if [ "$?" -eq "0" ]; then
	
	bash $R/source/master_script.sh $REF $threads $GTF $SS $IN $R
fi


