
description=$(zenity --forms --title="Identification of LncRNA" --text="Assign experiment code (no spaces!)" --add-entry="PROJECT TITLE" --add-entry="POOL NAME" --add-entry="SAMPLE NAMES 
(sep by ',')
[cntrl7,cntrl8,treat0,treat11]" --add-entry="SAMPLE TYPES (sep by ',')
[cntrl,cntrl,treat,treat]" --add-entry="LOG NAME" --add-entry="COMPARISONS 
(sep by '_VS_' and ',' for multiple comparisons)
[cntrl_VS_treat1,cntrl_VS_treat2]" --width=700 --)
pname=$(echo $description | cut -d'|' -f1)
poolname=$(echo $description | cut -d'|' -f2)
snames=$(echo $description | cut -d'|' -f3)
stype=$(echo $description | cut -d'|' -f4)
LOG=$(echo $description | cut -d'|' -f5)
comp=$(echo $description | cut -d'|' -f6)

array=$(echo $snames | tr "," "\n")
arr=($array)
READ1b=()
READ2b=()

se_pe=$(zenity --list --text="" --radiolist --column "" --column "" --hide-header --title="Paired end/Single end" TRUE "Paired_end" FALSE "Single_end")

for sample in `seq 1 "${#arr[@]}"`; do
	zenity --info --title="READ-1" --text="Select read-1 file for "${arr[$(($sample-1))]} --ok-label="OK";
	READ1a=$(zenity --file-selection --filename /opt/ngs/raw_data/ --title="***READ-1***"  --text="Select read-1 file");
	READ1b+=( ${READ1a} )
done

if [ ${se_pe} = "Paired_end" ]; then
	for sample in `seq 1 "${#arr[@]}"`; do
		zenity --info --title="READ-2" --text="Select read-2 file for "${arr[$(($sample-1))]} --ok-label="OK";
		READ2a=$(zenity --file-selection --filename /opt/ngs/raw_data/ --title="***READ-2***"  --text="Select read-2 file");
		READ2b+=( ${READ2a} )
	done
fi

function join { local IFS="$1"; shift; echo "$*"; }
READ1=$(join , ${READ1b[@]})
READ2=$(join , ${READ2b[@]})

zenity --info --title="Reference genome Hisat2" --text="Select reference genome for Hisat2" --ok-label="OK" 
o
REF_HISAT=$(zenity --file-selection --filename /opt/genome/human/hg38/ref_gen/hg19.fa --title="***Reference genome Hisat2***"  --text="Select reference genome for Hisat2")
REF_HISAT=$(echo $REF_HISAT | sed s/.fa//g)

zenity --info --title="Annotation GTF file" --text="Select Annotation GTF file" --ok-label="OK" 
GTF=$(zenity --file-selection --filename /opt/genome/human/hg38/annotation/gencode.v40.chr_patch_hapl_scaff.annotation.gtf --title="***Annotation GTF file***"  --text="Select Annoatation GTF file")

zenity --info --title="Splice Site file" --text="Select Splice Site file" --ok-label="OK" 
SS=$(zenity --file-selection --filename /opt/genome/human/hg38/annotation/gencode.v40.splicesite.annotation.ss --title="***Splice Site file***"  --text="Select Splice Site file")

zenity --info --title="Reference genome" --text="Select reference genome" --ok-label="OK" 
REF=$(zenity --file-selection --filename /opt/genome/human/hg38/ref_gen/hg38.fa --title="***Reference genome***"  --text="Select reference genome")

zenity --info --title="Script path" --text="Select script directory" --ok-label="OK" 
R=$(zenity --file-selection --directory --filename /opt/applications/src/arpir/ARPIR --title="***Script path***"  --text="Select script directory")

zenity --info --title="Output directory" --text="Select output directory" --ok-label="OK" 
OUT=$(zenity --file-selection --directory --title="***Output directory***"  --text="Select output directory")

zenity --info --title="Log directory" --text="Select log directory" --ok-label="OK" 
LOGF=$(zenity --file-selection --directory --filename /opt/ngs/logs --title="***Log directory***"  --text="Select log directory")

threads=$(zenity --forms --title="THREADS" --text="Number of threads" --add-entry="THREADS")

echo "project_name = "$pname"

pool_name = "$poolname"

sample_names = "$snames"

sample_types = "$stype"

comparisons = "$comp"

log = "$LOG"

reads_1 = "$READ1"

reads_2 = "$READ2"

hisat = "$REF_HISAT"

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

