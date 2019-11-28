#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=16             # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=10:00:00
#SBATCH --mem=10G

module load angsd
#date : 26-11-19
#purpose: script to create saf file by chromosome 
#author : Q. Rougemont

if [ $# -ne 3 ]; then
    echo "USAGE: $0 ChrName outfolderName foldedStatus"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of output folder"
    echo "a string either "FOLDED/UNFOLDED" specifying whether the SAF should be folded or not"
    exit 1
else 
    CHROMO=$1
    OUTFOLDER=$2 #folder where final sfs will appear
    FOLDED=$3    
    echo "chromosome name is $CHROMO"
    echo "Output folder name is $OUTFOLDER"
    echo "the SAF will be $FOLDED"
fi

#ARGUEMNTS
ref=/net/cn-1/mnt/SCRATCH/quentin/quentin/03-genome_placed/ICSASG_v2.placed.fa #$1
bamlistlist="bamlist.list"
#check if it exists:
bamlist=$(cat ${bamlistlist})
if [ ! -f ${bamlist} ]; then
   echo "Bam file list: ${bamlist} not found!"
   continue
fi
 
nt=16

#FOLDER
if [ ! -d "$OUTFOLDER"  ];
then 
 echo "creating output dir"
 mkdir "$OUTFOLDER"
fi

pop=${bamlist%%.*}
if [ -f ${pop} ]; then
    continue
fi

#RUN ANGSD
echo "running ANGSD now "
if [ $FOLDED=="FOLDED" ];
then
   echo "running ANGSD with $FOLDED version"
   angsd -b ${bamlist} -gl 1 \
	-anc ${ref} \
	-out ${OUTFOLDER}/${pop}.${CHROMO} \
	-dosaf 1 \
	-remove_bads 1 -only_proper_pairs 1 -trim 0 \
	-minInd 8  \
	-r ${CHROMO} \
	-doCounts 1 -setMinDepth 4 -setMaxDepth 100 \
	-minMapQ 30 \
	-minQ 20 \
	-uniqueOnly 1 \
	-fold 1 \
	-P ${nt}
	#-doHWE 1 \
	#-minHWEpval 1e-4 \
	#-domajorminor 1 \
	#-P ${nt}
else
   angsd -b ${bamlist} -gl 1 \
	-anc ${ref} \
	-out ${OUTFOLDER}/${pop}.${CHROMO} \
	-dosaf 1 \
	-remove_bads 1 -only_proper_pairs 1 -trim 0 \
	-minInd 8  \
	-r ${CHROMO} \
	-doCounts 1 -setMinDepth 4 -setMaxDepth 100 \
	-minMapQ 30 \
	-minQ 20 \
	-uniqueOnly 1 \
	-P ${nt}
	#-doHWE 1 \
	#-minHWEpval 1e-4 \
	#-domajorminor 1 \
	#-P ${nt}
fi
