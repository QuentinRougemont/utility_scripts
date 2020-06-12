#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
#SBATCH --ntasks=8             # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
#SBATCH --time=30:00:00
#SBATCH --mem=12G

module load angsd
#date : 26-11-19
#purpose: script to compute depth by chromosome 
#author : Q. Rougemont

if [ $# -ne 2 ]; then
    echo "USAGE: $0 ChrName outfolderName "
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of output folder"
    exit 1
else 
    CHROMO=$1
    OUTFOLDER=$2 #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "Output folder name is $OUTFOLDER"
fi

#ARGUEMNTS
ref="your_fasta.fasta" #$1
bamlistlist="bamlist.list"
#check if it exists:
bamlist=$(cat ${bamlistlist})
if [ ! -f ${bamlist} ]; then
   echo "Bam file list: ${bamlist} not found!"
   continue
fi
 
nt=8
ind=$( wc -l ${bamlist} |awk '{print $1 }' )
maxdp=$(awk -v var="$ind" 'BEGIN {printf "%3.0f\n", var * 9}' )

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
   echo "running ANGSD with $FOLDED version"
   angsd -b ${bamlist}  \
	-ref ${ref} \
	-out ${OUTFOLDER}/${pop}.${CHROMO} \
	-remove_bads 1 -only_proper_pairs 1 -trim 0 \
	-minInd $ind\
	-r ${CHROMO} \
	-doCounts 1 -doDepth 1 -MaxDepth  $maxdp \
	-doQsDist 1 \
	-minMapQ 30 \
	-minQ 20 \
	-baq 1 -C 50\
	-uniqueOnly 1 \
	-P ${nt} 
