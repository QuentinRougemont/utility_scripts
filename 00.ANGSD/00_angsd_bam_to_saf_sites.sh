#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=8             # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=18:00:00
#SBATCH --mem=06G

module load angsd
#date : 26-11-19
#purpose: script to create saf file by chromosome subsetting reggion 
#author : Q. Rougemont
if [ $# -ne 3 ]; then
    echo "USAGE: $0 ChrName outfolderName Sites"
    echo "Expecting the following values on the command line, in that order"
    echo "Name of the chromosome"
    echo "name of output folder"
    echo "sites specifying [chr]\t[pos]"
    exit 1
else 
    CHROMO=$1
    OUTFOLDER=$2 #folder where final sfs will appear
    REGION=$3
    echo "chromosome name is $CHROMO"
    echo "Sites file is "$REGION" "
fi

#### FASTA FILE #############
ref="your.fasta.fa"
if [[ ! -f "$ref".fai ]]; then
    echo "indexing file"
    samtools faidx $ref
fi
#### OTHER ARGUMENTS: #######
anc=$ref
bamlistlist="bamlist.list"
#check if it exists:
bamlist=$(cat ${bamlistlist})
if [ ! -f ${bamlist} ]; then
   echo "Bam file list: ${bamlist} not found!"
   continue
fi
 
nt=8 #number of threads
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
angsd -b ${bamlist} -gl 1 \
	-dosaf 1 \
	-anc $anc \
	-ref $ref \
	-out ${OUTFOLDER}/${pop}.${CHROMO} \
	-r $CHROMO \
	-sites ${REGION} \
	-P ${nt}

INFOLDER=$OUTFOLDER
samples1=($(ls ${INFOLDER}/*.${CHROMO}.saf.idx))

#construct 1D SFS
realSFS "$samples1" \
	-r ${CHROMO} \
	-P $nt   > "$OUTFOLDER"/${pop}.${CHROMO}.1dsfs 
