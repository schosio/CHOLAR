
description=$(zenity --forms --title="Identification of LncRNA" --text="Assign experiment code (no spaces!)" --add-entry="SAMPLE NAMES 
(sep by ',')
[Samplel,Sample2,Sample3,Sample4]" --add-entry="SAMPLE TYPES (sep by ',')
[cntrl,cntrl,treat,treat]" --width=700)

[[ $? != 0 ]] && exit 1
snames=$(echo $description | cut -d'|' -f1)
stype=$(echo $description | cut -d'|' -f2)

[[ $? != 0 ]] && exit 1
array=$(echo $snames | tr "," "\n")
arr=($array)

array2=$(echo $stype | tr "," "\n")
arr2=($array2)

len=${#arr[@]}
for (( idx = 0; idx < len; idx++ ));
do
        echo "${arr[idx]}       ${arr2[idx]}" >>map.txt
done

bash name_change.sh

rm map.txt

zenity --info --title="Annotation GTF file" --text="Select Annotation GTF file" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

GTF=$(zenity --file-selection --filename /opt/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf --title="***Annotation GTF file***"  --text="Select Annoatation GTF file")
[[ $? != 0 ]] && exit 1

zenity --info --title="Splice Site file" --text="Select Splice Site file" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

SS=$(zenity --file-selection --filename /opt/genome/human/hg38/annotation/gencode.v40.splicesite.annotation.ss --title="***Splice Site file***"  --text="Select Splice Site file")
[[ $? != 0 ]] && exit 1

zenity --info --title="Reference genome" --text="Select reference genome" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

REF=$(zenity --file-selection --filename /opt/genome/human/hg38/ref_gen/hg38.fa --title="***Reference genome***"  --text="Select reference genome")
[[ $? != 0 ]] && exit 1

zenity --info --title="Script path" --text="Select script directory" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

R=$(zenity --file-selection --directory --filename /opt/applications/src/arpir/ARPIR --title="***Script path***"  --text="Select script directory")
[[ $? != 0 ]] && exit 1

zenity --info --title="Output directory" --text="Select output directory" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

OUT=$(zenity --file-selection --directory --title="***Output directory***"  --text="Select output directory")
[[ $? != 0 ]] && exit 1

zenity --info --title="Log directory" --text="Select log directory" --ok-label="OK" 
[[ $? != 0 ]] && exit 1

LOGF=$(zenity --file-selection --directory --filename /opt/ngs/logs --title="***Log directory***"  --text="Select log directory")
[[ $? != 0 ]] && exit 1

threads=$(zenity --forms --title="THREADS" --text="Number of threads" --add-entry="THREADS")
[[ $? != 0 ]] && exit 1

echo "

sample_names = "$snames"

sample_types = "$stype"

BED_file = "$BED"

GTF_file = "$GTF"

reference_genome = "$REF"

script_directory = "$R"

output_directory = "$OUT"

log_directory = "$LOGF"

threads = "$threads | zenity --text-info --title="Summary" --width=700 --height=600 --ok-label="OK" --cancel-label="Cancel"

if [ ${se_pe} = "Paired_end" ]; then
	if [ "$?" -eq "0" ]; then
		cd ${OUT}
		bash $R/master.sh $REF $threads $GTF $SS #-n $pname -pn $poolname -sn $snames -r1 $READ1 -r2 $READ2 -type $stype -rb $REF_BOWTIE -rh $REF_HISAT -rs $REF_STAR -bed $BED -ph $PHIX -rib1 $RIB1 -rib2 $RIB2 -t $threads -g $GTF -a $alignment -l $library -q $quant -r $REF -dea $dea -r_path $R -o $OUT -tertiary $tertiary -cat $max_cat -comp $comp 2>&1 >> ${LOGF}/${LOG}.log
	fi
fi

#if [ ${se_pe} = "Single_end" ]; then
#	if [ "$?" -eq "0" ]; then
#		cd ${OUT}
#		python $R/ARPIR.py -n $pname -pn $poolname -sn $snames -r1 $READ1 -type $stype -rb $REF_BOWTIE -rh $REF_HISAT -rs $REF_STAR -bed $BED -ph $PHIX -rib1 $RIB1 -rib2 $RIB2 -t $threads -g $GTF -a $alignment -l $library -q $quant -r $REF -dea $dea -r_path $R -o $OUT -tertiary $tertiary -cat $max_cat -comp $comp 2>&1 >> ${LOGF}/${LOG}.log
#	fi
#fi

