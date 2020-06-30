#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
#SBATCH --ntasks=8             # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=30:00:00
#SBATCH --mem=04G
module load angsd

if [ $# -ne 2 ]; then
    echo "USAGE: $0 ChrName outfolderName "
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    exit 1
else 
    CHROMO=$1
    OUTFOLDER=$2 #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "Output folder name is $OUTFOLDER"
fi

#ARGUEMNTS
ref=reference.fa.gz
anc=ancestralseq.fa.gz

bamlistlist="bamlist.list"
#check if it exists:
bamlist=$(cat ${bamlistlist})
if [ ! -f ${bamlist} ]; then
   echo "Bam file list: ${bamlist} not found!"
   continue
fi
 
nt=8

#ind and depth filtering 
ind=$( wc -l ${bamlist} |awk '{printf "%3.0f\n", $1 * 0.99 }' )
maxdp=$(awk -v var="$ind" 'BEGIN {printf "%3.0f\n", var * 9}' )
mindp=$(awk -v var="$ind" 'BEGIN {printf "%3.0f\n", var * 4}' )

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
   angsd -b ${bamlist} -gl 1 \
	-anc ${anc} \
	-ref ${ref} \
	-out ${OUTFOLDER}/${pop}.${CHROMO} \
	-remove_bads 1 -only_proper_pairs 1 -trim 0 \
	-minInd $ind\
	-r ${CHROMO} \
	-doCounts 1 -setMinDepth $mindp -setMaxDepth  $maxdp \
	-minMapQ 20 \
	-minQ 20 \
	-baq 1 -C 50\
	-uniqueOnly 1 -skipTriallelic 1 \
	-P ${nt} \
	-doHWE 1 \
        -doMajorMinor 1 -doMaf 1 -dosnpstat 1 -doPost 2 -doGeno 11
	#-minHWEpval 1e-4 \
	#-domajorminor 1 

