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
#SBATCH --time=16:00:00
#SBATCH --mem=200G

#cd $SLURM_SUBMIT_DIR

module load angsd
#date : 26-11-19
#purpose: script to create 2dSFS by chromosome 
#author : Q. Rougemont

if [ $# -ne 4 ]; then
    echo "USAGE: $0 ChrName infolder1 infolder2 outfolder"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of input folder for pop1"
    echo "name of input folder for pop2"
    echo "name of output folder"
    exit 1
else 
    CHROMO=$1
    INFOLDER1=$2 #folder where final sfs will appear
    INFOLDER2=$3
    OUTFOLDER=$4 #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "input folder name is $INFOLDER1"
    echo "input folder name is $INFOLDER2"
    echo "Output folder name is $OUTFOLDER"
fi

#### FASTA FILE #############
ref="your.fasta.fa"
if [[ ! -f "$ref".fai ]]; then
    echo "indexing file"
    samtools faidx $ref
fi

#### OTHER ARGUMENTS: #######
nt=8 #number of threads

samples1=($(ls ${INFOLDER1}/*.${CHROMO}.saf.idx))
if [ ${#samples1[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi
echo "samples pop1 are: $samples1"

samples2=($(ls ${INFOLDER2}/*.${CHROMO}.saf.idx))
if [ ${#samples2[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi
echo "samples pop2 are: $samples2"

#FOLDER
if [ ! -d "$OUTFOLDER"  ];
then
 echo "creating output dir"
 mkdir "$OUTFOLDER"
fi

pop1=${samples1[${i}]}
pop1=$(basename ${pop1} )
pop1=$(basename ${pop1%%.*})
echo $pop1
pop2=${samples2[${j}]}
echo $pop2
pop2=$(basename ${pop2} )
pop2=$(basename ${pop2%%.*} )

echo "Running ANGSD 2dSFS "
echo "population 1 is $samples1"
echo "population 2 is $samples2"

realSFS "$samples1" \
	"$samples2" \
	-r ${CHROMO} \
	-P $nt   > "$OUTFOLDER"/${pop1}_${pop2}.${CHROMO}.2dsfs 
