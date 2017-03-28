#!/bin/bash

# Global variables
DATAOUTPUT="11-gsnap"
DATAINPUT="04-all_samples"
GENOMEFOLDER="08-genome/"
GENOME="gmap_esox"


for i in $(ls -1 $DATAINPUT/*.fq.gz)
do 
    # Align reads
    echo "Aligning $i"
    name=$(basename $i) 
    gsnap --gunzip -t 8 -A sam -m 5 -i 2 --min-coverage=0.90 \
	--dir="$GENOMEFOLDER" -d "$GENOME" --read-group-id="${name%.fq.gz}" \
        -o "$DATAOUTPUT"/"${name%.fq.gz}".sam \
	"$DATAINPUT"/$name 

    # Create bam file
    echo "Creating bam for $i"

    samtools view -Sb -q 5 -F 4 -F 256 -F 2048 \
        $DATAOUTPUT/"${name%.fq.gz}".sam >  $DATAOUTPUT/"${name%.fq.gz}".bam
	
     echo "Creating sorted bam for $base"
	samtools sort "$DATAOUTPUT"/"${name%.fq.gz}".bam > "$DATAOUTPUT"/"${name%.fq.gz}".sort
    samtools index "$DATAOUTPUT"/"${name%.fq.gz}".sort.bam  
    # Clean up
    echo "Removing "$DATAOUTPUT"/"$base".sam"
    echo "Removing "$DATAOUTPUT"/"$base".bam"
done
   	#rm $DATAOUTPUT/"$base".sam
    	#rm $DATAOUTPUT/"$base".bam
