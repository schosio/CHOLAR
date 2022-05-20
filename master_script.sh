#!/bin/bash
set -e
set -v

# configure the system for running the master_script.sh
bash configure.sh
#seting variables

#idx = location of reference genome index of the aligner to be used
# in this case it is hisat2 and it was created using hisat2-build function
idx=$1

# threads variable denote the number of cores that are going to be used in the program
threads=$2

#annotation = location of annotation file
annotation=$3

#splicefile = location of gtf annotation file, created using hisat2
# command to create splicesite file is:  python hisat2_extract_splice_sites.py
splicefile=$4

# date command to log the timestamp
date

#creating directory for storing fastqc_report of raw fastq files
mkdir raw_fastqc_report

# run fastqc on all fastq or fastq.gz files
find . -type f \( -name "*.fastq.gz" -o -name "*.fastq" \) | parallel -j $threads -v -I% --max-args 1 fastqc -o raw_fastqc_report/
cd raw_fastqc_report
#running multiqc to combine all fastqc reports
multiqc .

cd ..
# prossesing the data using trimmomatic v 0.39
date
for infile in *1.fastq
        do
	echo $infile
        name=$(echo $infile | awk -F"_." '{print $1}')
        R1_paired=${name}_1paired.fastq
        R1_unpaired=${name}_1unpaired.fastq
        R2_paired=${name}_2paired.fastq
        R2_unpaired=${name}_2unpaired.fastq
          java -jar /home/chaos/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads $threads -phred33 -summary \
        ${name}_statsSummaryFile.txt $infile ${name}_2.fastq $R1_paired $R1_unpaired $R2_paired $R2_unpaired \
        ILLUMINACLIP:/home/chaos/softwares/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:40:15 LEADING:28 TRAILING:28 AVGQUAL:28 MINLEN:50 
done

#sorting the output files in different directories
rm *unpaired.fastq* 

mkdir Paired 
mv *paired.fastq* Paired/

mkdir raw_fastq
mv *.fastq* raw_fastq/

mkdir trim_summary
mv *SummaryFile.txt trim_summary

#running fastqc on processed files
cd Paired/
mkdir processed_fastqc_report
find . -type f \( -name "*.fastq.gz" -o -name "*.fastq" \) | parallel -j $threads -v -I% --max-args 1 fastqc -o processed_fastqc_report/
cd processed_fastqc_report
multiqc .

cd ..
#moving processed files into main directory
mv processed_fastqc_report/ ../

#running alignment using HISAT 2

date 

#loop for hisat2

for i in *1paired.fastq
do
  	name=$(echo $i | awk -F"_" '{print $1}')
        R1_pair=${name}_1paired.fastq
        R2_pair=${name}_2paired.fastq
        #display the command used
        #options for hisat: -p is for threads used, --known-splicesite-infile is for splice site file
        #options for samtools: view is for file conversion, -bS is for .bam as output and .sam as input
        #options for samtools: sort is for sorting, -n is sorting by name, -o is for output
        #options for samtools: fixmate is for fix mate information, markdup is for marking duplicates
        hisat2 -p $threads -x $idx --known-splicesite-infile $splicefile -1 $R1_pair -2 $R2_pair | samtools view -@ $threads -bS - | samtools \
        sort -@ $threads -n - -o $name.sorted.bam
done

# removing PCR duplicates and index the bam files
for j in *.sorted.bam
do
  	name1=$(echo $j | awk -F".sorted." '{print $1}')
        #options for samtools: fixmate is for fix mate information, markdup is for marking duplicates
        samtools fixmate -@ $threads -m $j - | samtools sort -@ $threads - | samtools markdup -@ $threads -rs - $name1.rmPCRdup.bam
        samtools index -@ 40 -b $name1.rmPCRdup.bam
done

rm *.sorted.bam
rm *.fastq


for i in *rmPCRdup.bam
do
  	name=$(echo $i | awk -F".rmPCRdup" '{print $1}')
        #options for stringtie: -G is for annotation file, -o is for output gtf file, -p is or threads, -b is for location of ballown table files
        #options for stringtie: -A is for output of gene abundance file
        stringtie $i -G ${annotation} -o $name.gencode.gtf -p $threads 
done


annotation=/home/chaos/GENCODE/annotation_file/gencode.v38.annotation.gtf
#out_file = name of merged tf file
out_file=data_merge_annotation.gtf
ls *gencode.gtf > temp.gtf.list

stringtie --merge -p $threads -G $annotation -m 200 -F 1 -c 200 -o $out_file temp.gtf.list 

rm temp.gtf.list
#STEP 8 comparing the information in merged gtf from stringtie and annotation file
#merge_gtf = location of merged gtf file created in STEP 7

# comparing the transcript assembly with refrence annotation

gffcompare -r ${annotation} -M -o common-merged $out_file

# extract the no of putative novel transcript and save it in a report file
nov_trans=$(cat common-merged.annotated.gtf |  awk '$3=="transcript" && $2=="StringTie"' | grep -v 'class_code "="' wc -l)

echo No of novel transcripts in the sample is $nov_trans > novel_trans_report.txt

# extract the genomic coordinates of putative novel transcripts
cat common-merged.annotated.gtf |  awk '$3=="transcript" && $2=="StringTie"' | grep -v 'class_code "="' >common_novel_transcript.gtf

# extract the genomic sequences of the novel transcripts.

gffread -w common_novel_transcript_seq.fa -g /home/chaos/INDEX/hg38/hisat2/hg38.fa common_novel_transcript.gtf

# run htseq count
mkdir htseq_files

for i in *rmPCRdup.bam
do
  	name=$(echo $i | awk -F".rmPCRdup" '{print $1}')
        htseq-count -f bam $i -a 30 -s no -i transcript_id common-merged.annotated.gtf > ${name}.count.txt
done

mv *.count.txt htseq_files/

cd htseq_files/

plot.R
