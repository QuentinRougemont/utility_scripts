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
#index your genome first:
#samtools faidx genome.fas
#cd $SLURM_SUBMIT_DIR

module load angsd

if [ $# -ne 3 ]; then
    echo "USAGE: $0 infolder1 infolder2 outfolder"
    exit 1
fi

#ARGUEMNTS
ref=/mnt/SCRATCH/quentin/quentin/03-genome_placed/ICSASG_v2.placed.fa #$1
#bamlistlist=$1 #list of the list of bam
INFOLDER1=$1 #first saf
INFOLDER2=$2 #second saf
OUTFOLDER=$3 #folder where final sfs will appear
nt=8

samples1=($(ls ${INFOLDER1}/*.saf.idx))
if [ ${#samples1[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi
echo "$samples1"

samples2=($(ls ${INFOLDER2}/*.saf.idx))
if [ ${#samples2[@]} -eq 0 ]; then
	echo 'No "saf" files found.'
	exit 1
fi
echo "$samples2"

bni=${samples1[${i}]}
bni=$(basename ${bni%%.*})
bnj=${samples2[${j}]}
bnj=$(basename ${bnj%%.*} )
#bnj=$(basename ${bnj} )
        realSFS "$samples1" \
		"$samples2" \
		-r ssa01 \
		-P $nt   > "$OUTFOLDER"/${bni}_${bnj}.ssa01.2dsfs 
