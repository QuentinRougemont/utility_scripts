#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=6               # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06:00:00
#SBATCH --mem=6G

#cd $SLURM_SUBMIT_DIR

module load angsd
#date : 26-11-19
#purpose: script to create 2dSFS by chromosome 
#author : Q. Rougemont

if [ $# -ne 5 ]; then
    echo "USAGE: $0 ChrName infolder1 infolder2 infolder3 outfolder"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of input folder for pop1"
    echo "name of input folder for pop2"
    echo "name of input folder for pop3"
    echo "name of output folder the jSFS should already be here!" 
    exit 1
else 
    CHROMO=$1
    INFOLDER1=$2 #folder where saf file pop1 are located
    INFOLDER2=$3 #folder where saf file pop2 are located
    INFOLDER3=$4 #folder where saf file pop3 are located
    OUTFOLDER=$5 #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "input folder name is $INFOLDER1"
    echo "input folder name is $INFOLDER2"
    echo "input folder name is $INFOLDER3"
    echo "Output folder name is $OUTFOLDER"
fi

#ARGUEMNTS
windows=100000 #size of the windows set according to the size you want
ref="your_genome.fasta" #$1
nt=8
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
samples3=($(ls ${INFOLDER3}/*.${CHROMO}.saf.idx))
if [ ${#samples3[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi
echo "samples pop3 are: $samples3"

pop1=${samples1[${i}]}
pop1=$(basename ${pop1} )
pop1=$(basename ${pop1%%.*})
pop2=${samples2[${j}]}
pop2=$(basename ${pop2} )
pop2=$(basename ${pop2%%.*} )
pop3=${samples3[${j}]}
pop3=$(basename ${pop3} )
pop3=$(basename ${pop3%%.*} )

echo "Running ANGSD FST "
echo "population 1 is $samples1"
echo "pôpulation 2 is $samples2"
echo "population 3 is $samples3"
realSFS fst index  "$samples1" "$samples2" "$samples3" \
	-sfs "$OUTFOLDER"/${pop1}_${pop2}.${CHROMO}.2dsfs \
        -sfs "$OUTFOLDER"/${pop1}_${pop3}.${CHROMO}.2dsfs \
	-sfs "$OUTFOLDER"/${pop2}_${pop3}.${CHROMO}.2dsfs \
	-r ${CHROMO} \
	-fstout "$OUTFOLDER"/all_${pop1}_${pop2}_${pop3}.${CHROMO}.pbs100  -whichFST 1 
#compute FST and PBS in sliding windows:
echo "computing Fst in sliding windows of size $windows"
realSFS fst stats2 \
	"${OUTFOLDER}"/all_${pop1}_${pop2}_${pop3}.${CHROMO}.pbs100.fst.idx \
	-win  "$windows"\
	-step "$windows"\
	-whichFST 1 > "$OUTFOLDER"/all_${pop1}_${pop2}_${pop3}.${CHROMO}.pbs.100.txt

