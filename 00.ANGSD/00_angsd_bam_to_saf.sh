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
#date : 01-04-20
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

#### FASTA FILE #############
ref="your.fasta.fa"
if [[ ! -f "$ref".fai ]]; then
    echo "indexing file"
    samtools faidx $ref
fi

#### OTHER ARGUMENTS: #######
bamlistlist="bamlist.list"
#check if it exists:
bamlist=$(cat ${bamlistlist})
if [ ! -f ${bamlist} ]; then
   echo "Bam file list: ${bamlist} not found!"
   continue
fi
 
nt=16 #number of threads

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

ind=$( wc -l ${bamlist} |awk '{printf "%3.0f\n", $1 * 0.9}' )
maxdp=$(awk -v var="$ind" 'BEGIN {printf "%3.0f\n", var * 10}' ) #value of 10 = meanDP+1*SD
mindp=$(awk -v var="$ind" 'BEGIN {printf "%3.0f\n", var * 3}' )  #value of  3 = meanDP-1*SD 


#RUN ANGSD
echo "running ANGSD now "
if [[ $FOLDED == "FOLDED" ]];
then
   echo "running ANGSD with $FOLDED version"
   angsd -b ${bamlist} -gl 1 \
	-anc ${ref} \
	-out ${OUTFOLDER}/${pop}.${CHROMO} \
	-dosaf 1 \
	-remove_bads 1 -only_proper_pairs 1 -trim 0 \
	-minInd ${ind} \
	-r ${CHROMO} \
	-doCounts 1 -setMinDepth $mindp -setMaxDepth $maxdp \
	-minMapQ 30 \
	-minQ 20 \
	-baq 1 -C 50\
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
	-minInd ${ind} \
	-r ${CHROMO} \
	-doCounts 1 -setMinDepth $mindp -setMaxDepth $maxdp\
	-minMapQ 30 \
	-minQ 20 \
	-baq 1 -C 50\
	-uniqueOnly 1 \
	-P ${nt}
	#-doHWE 1 \
	#-minHWEpval 1e-4 \
	#-domajorminor 1 \
	#-P ${nt}
fi
