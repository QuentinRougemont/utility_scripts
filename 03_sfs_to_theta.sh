#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=8              # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=hugemem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=48:00:00
#SBATCH --mem=150G
#cd $SLURM_SUBMIT_DIR

module load angsd
#date : 26-11-19
#purpose: script to compute thetas by chromosome 
#author : Q. Rougemont
#make sur that the sfs file are located in the outfolder!

if [ $# -ne 4 ]; then
    echo "USAGE: $0 ChrName sfsfolder outfolderName foldedStatus"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "Name of the sfsfolder which contains the 1DSFS (can be the same as outputfolder)"
    echo "name of output folder"
    echo "a string either "FOLDED/UNFOLDED" specifying whether the SAF should be folded or not"
    exit 1
else 
    CHROMO=$1
    SFSFOLDER=$2
    OUTFOLDER=$3 #folder where final sfs will appear
    FOLDED=$4    
    echo "chromosome name is $CHROMO"
    echo "input SFS folder name is $SFSFOLDER"
    echo "Output folder name is $OUTFOLDER"
    echo "the SAF will be $FOLDED"
fi

#ARGUMENTS
ref=/mnt/SCRATCH/quentin/quentin/03-genome_placed/ICSASG_v2.placed.fa 
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi
bamlist="bamlist.list"
#bamlist=list of the path to bamfiles
namepop=$(cat ${bamlist} |sed 's/.bamlist//g' )
echo $namepop
echo "bamlist is $bamlist"
#RUN ANGSD
echo "running ANGSD now "
if [ $FOLDED=="FOLDED" ];
then
   echo "running ANGSD THETA with $FOLDED version"
   angsd -b $(cat ${bamlist} )  -gl 1 \
        -anc ${ref} \
        -dosaf 1 \
	-doThetas 1\
	-r ${CHROMO} \
        -remove_bads 1 \
	-minMapQ 30 \
	-minQ 20 \
	-fold 1 \
	-P 8 \
	-pest ${SFSFOLDER}/${namepop}.${CHROMO}.1dsfs \
        -out ${OUTFOLDER}/${namepop}.${CHROMO} 
else
   echo "running ANGSD THETA with $FOLDED version"
   angsd -b $(cat ${bamlist} )  -gl 1 \
        -anc ${ref} \
        -dosaf 1 \
	-doThetas 1\
	-r ${CHROMO} \
        -remove_bads 1 \
	-minMapQ 30 \
	-minQ 20 \
	-P 8 \
	-pest ${SFSFOLDER}/${namepop}.${CHROMO}.1dsfs \
        -out ${OUTFOLDER}/${namepop}.${CHROMO} 
fi

echo "compute theta stat for each chromosome"
thetaStat do_stat ${OUTFOLDER}/${namepop}.${CHROMO}.thetas.idx 

echo "compute theta stat by sliding windows for each chromosome"
thetaStat do_stat ${OUTFOLDER}/${namepop}.${CHROMO}.thetas.idx \
    -win 250000 \
    -step 50000 \
    -outnames ${OUTFOLDER}/${namepop}.${CHROMO}.windowstats

#compress prior to analysis in R:
gzip ${OUTFOLDER}/${namepop}.${CHROMO}.windowstats.pestPG
