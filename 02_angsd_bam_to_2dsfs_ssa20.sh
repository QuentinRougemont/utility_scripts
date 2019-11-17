#!/bin/bash
#SBATCH --job-name="angsd"
#SBATCH -o log_%j
##SBATCH -c 8
#SBATCH --ntasks=16              # 1 core(CPU)
#SBATCH --nodes=1                # Use 1 node
#SBATCH --partition=smallmem
##SBATCH -p small
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=129:00:00
#SBATCH --mem=12G

#script to subsample bam based on coverage
#dependancies: jvarkit see
#see: http://lindenb.github.io/jvarkit/Biostar154220.html
#and http://lindenb.github.io/jvarkit/sortsamrefname.html
 
#index your genome first:
#samtools faidx genome.fasta

module load angsd

if [ $# -ne 3 ]; then
    echo "USAGE: $0 bamlist.list outfolder chromosome"
    exit 1
fi

#ARGUEMNTS
ref=/net/cn-1/mnt/SCRATCH/quentin/quentin/03-genome_placed/ICSASG_v2.placed.fa #$1
bamlistlist=$1 #list of the list of bam
OUTFOLDER=$2 #folder where final sfs will appear
ssa=$3 #name of the chromosome
nt=16

#FOLDER
if [ ! -d "$OUTFOLDER"  ];
then 
 echo "creating output dir"
 mkdir "$OUTFOLDER"
fi

#RUN ANGSD
for bamlist in $(cat ${bamlistlist}); do
    if [ ! -f ${bamlist} ]; then
        echo "Bam file list: ${bamlist} not found!"
        continue
    fi
   
    bn=${bamlist%%.*}
    if [ -f ${bn} ]; then
        continue
    fi
    angsd -b ${bamlist} -gl 1 \
	-anc ${ref} \
	-ref ${ref} \
	-out ${OUTFOLDER}/${bn} \
	-dosaf 1 \
	-remove_bads 1 -only_proper_pairs 1 -trim 0 \
	-minInd 8  \
	-r ${ssa} \
	-baq 1 \
	-C 50 -doCounts 1 -setMinDepth 4 -setMaxDepth 100 \
	-minMapQ 30 \
	-minQ 30 \
	-uniqueOnly 1 \
	-doHWE 1 \
	-minHWEpval 1e-4 \
	-domajorminor 1 \
	-P ${nt}
done
