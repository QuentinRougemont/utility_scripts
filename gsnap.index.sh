#!/bin/bash

# Global variables
GENOMEFOLDER="./08-genome" #path to the fasta
FASTA="08-genome/eso_luc.fasta" #name of the fasta
GENOME="gmap_esox" #output

#move to present working dir
#cd $SLURM_SUBMTI_DIR

#prepare the genome
gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME" 2>&1 | tee 10_log_files/"$TIMESTAMP"_index.log
