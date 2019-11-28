#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=8               # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=09:00:00
#SBATCH --mem=100G
#cd $SLURM_SUBMIT_DIR

module load angsd
#date : 26-11-19
#purpose: script to create 1dSFS by chromosome 
#author : Q. Rougemont

if [ $# -ne 3 ]; then
    echo "USAGE: $0 ChrName infolder1 outfolder"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of input folder"
    echo "name of output folder"
    exit 1
else 
    CHROMO=$1
    INFOLDER=$2 #folder where final sfs will appear
    OUTFOLDER=$3 #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "input folder name is $INFOLDER"
    echo "Output folder name is $OUTFOLDER"
fi

#ARGUEMNTS
ref=your_genome.fasta #should be index (samtools faidx)
nt=8

samples1=($(ls ${INFOLDER1}/*.saf.idx))
if [ ${#samples1[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi
echo "samples are: $samples1"

pop=${samples1[${i}]}
pop=$(basename ${pop%%.*})

echo "running ANGSD to produce 1D SFS now"
echo "running ANGSD on sample $pop"

realSFS "$samples1" \
	-r ${CHROMO} \
	-P $nt   > "$OUTFOLDER"/${pop}.${CHROMO}.2dsfs 
