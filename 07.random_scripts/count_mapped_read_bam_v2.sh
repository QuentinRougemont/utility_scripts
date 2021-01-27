#!/bin/bash

#source /clumeq/bin/enable_cc_cvmfs
#module load samtools
#improved version as compared to previous one

if [ $# -lt 1 ] ; then
    echo ""
    echo "usage: count_mapped_read_bam_v2.sh  [bam_file1] <bam_file2> ..|| *.bam"
    echo "counts the number of mapped reads in a bam file"
    echo ""
    exit 0
fi

bam=${@};

OUTFOLDER="07-stats"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi


for i in ${bam[@]}
do
    input=$(basename $i )
    samtools view -F 0x4 "$i" |\
     wc -l |awk -v var=$i '{print var, $1 }' >> $OUTFOLDER/mapped_read_"$input".txt; 
done  

