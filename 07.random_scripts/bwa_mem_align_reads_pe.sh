#!/bin/bash

# Global variables
GENOMEFOLDER="08-genome"
GENOME="genome.fasta"
DATAFOLDER="04-all_samples"
NCPU=$1

# Test if user specified a number of CPUs
if [[ -z "$NCPU" ]]
then
    NCPU=8
fi

# Index genome if not alread done
# bwa index -p $GENOMEFOLDER/$GENOME $GENOMEFOLDER/$GENOME.fasta
#verify that your sample contain the R1 and R2 pattern
#verify that the samtools flag satisfy your criterion

for file in $(ls -1 $DATAFOLDER/*R1*.f*q.gz)
do
    # Name of uncompressed file
    file2=$(echo "$file" | perl -pe 's/R1/R2/')
    echo "Aligning file $file $file2"

    name=$(basename $file)
    name2=$(basename $file2)
    ID="@RG\tID:ind\tSM:ind\tPL:Illumina"

    # Align reads 1 step
    bwa mem -t "$NCPU" -k 19 -c 500 -O 0,0 -E 2,2 -T 0 \
        -R $ID $GENOMEFOLDER/$GENOME $DATAFOLDER/"$name" $DATAFOLDER/"$name2" 2> /dev/null |
        samtools view -Sb -q 20 -F 4 -F 256 -F 2048 - > $DATAFOLDER/"${name%.fq.gz}".bam

    # Sort and index
    samtools sort $DATAFOLDER/"${name%.fq.gz}".bam > $DATAFOLDER/"${name%.fq.gz}".sorted.bam
    samtools index $DATAFOLDER/"${name%.fq.gz}".sorted.bam
done
