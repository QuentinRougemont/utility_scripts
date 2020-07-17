#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=8               
#SBATCH --nodes=1                
#SBATCH --partition=hugemem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=09:00:00
#SBATCH --mem=120G

cd $SLURM_SUBMIT_DIR

module load angsd
#date : 26-11-19
#purpose: script to create 2dSFS by chromosome in dadi dictionnary format 
#author : Q. Rougemont

if [ $# -ne 3 ]; then
    echo "USAGE: $0 ChrName infolder1 infolder2 #outfolder"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of input folder for pop1"
    echo "name of input folder for pop2"
    #echo "name of output folder"
    exit 1
else 
    CHROMO=$1
    INFOLDER1=$2 #folder where saf file pop1 are located
    INFOLDER2=$3 #folder where saf file pop2 are located
    INF1=$(basename $INFOLDER1 )
    INF2=$(basename $INFOLDER2 )
    OUTFOLDER="${INF1}"_"${INF1}"  #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "input folder name is $INFOLDER1"
    echo "input folder name is $INFOLDER2"
    echo "Output folder name is $OUTFOLDER"
fi

#ARGUEMNTS
ref=/mnt/SCRATCH/quentin/quentin/03-genome_placed/ICSASG_v2.placed.fa #$1
anc=/net/cn-1/mnt/SCRATCH/quentin/quentin/00.new/coho_rainbow_chinook.fasta.fa.gz

nt=8

samples1=($(ls ${INFOLDER1}/*.${CHROMO}.saf.idx))
if [ ${#samples1[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi

samples2=($(ls ${INFOLDER2}/*.${CHROMO}.saf.idx))
if [ ${#samples2[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi

pop1=${samples1[${i}]}
pop1=$(basename ${pop1} )
pop1=$(basename ${pop1%%.*})
echo $pop1 "pouet"
pop2=${samples2[${j}]}
pop2=$(basename ${pop2} )
pop2=$(basename ${pop2%%.*} )
#pop2=$(basename ${pop2} )
echo $pop2 "pouet"
#FOLDER
if [ ! -d "$OUTFOLDER"  ];
then 
 echo "creating output dir"
 mkdir "$OUTFOLDER"
fi

echo "Running ANGSD 2dSFS "
echo "population 1 is $samples1"
echo "pôpulation 2 is $samples2"
realSFS dadi "$samples1" \
	"$samples2" \
	-sfs $INFOLDER1/"$pop1"."$CHROMO".1dsfs \
	-sfs $INFOLDER2/"$pop2"."$CHROMO".1dsfs \
	-ref $ref \
	-anc $anc \
	-r ${CHROMO} \
	-P $nt   > "$OUTFOLDER"/${pop1}_${pop2}.${CHROMO}.2dsfs 
