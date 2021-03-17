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
    OUTFOLDER=$4 #folder where final sfs will appear
    echo "chromosome name is $CHROMO"
    echo "input folder name is $INFOLDER1"
    echo "input folder name is $INFOLDER2"
    echo "Output folder name is $OUTFOLDER"
fi

#ARGUEMNTS
windows=100000 #size of the windows. Set according to the size you want

#### FASTA FILE #########
ref="your.fasta.fa"
if [[ ! -f "$ref".fai ]]; then
    echo "indexing file"
    samtools faidx $ref
fi

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

pop1=${samples1[${i}]}
pop1=$(basename ${pop1} )
pop1=$(basename ${pop1%%.*})
pop2=${samples2[${j}]}
pop2=$(basename ${pop2} )
pop2=$(basename ${pop2%%.*} )

echo "Running ANGSD FST "
echo "population 1 is $samples1"
echo "pôpulation 2 is $samples2"
realSFS fst index  "$samples1" "$samples2"  \
	-sfs "$OUTFOLDER"/${pop1}_${pop2}.${CHROMO}.2dsfs \
	-r ${CHROMO} \
	-fstout "$OUTFOLDER"/all_${pop1}_${pop2}.${CHROMO}.pbs100  -whichFST 1 

#compute FST and PBS in sliding windows:
echo "computing Fst in sliding windows of size $windows"
realSFS fst stats2 \
	"${OUTFOLDER}"/all_${pop1}_${pop2}.${CHROMO}.pbs100.fst.idx \
	-win  "$windows"\
	-step "$windows"\
	-whichFST 1 > "$OUTFOLDER"/all_${pop1}_${pop2}.${CHROMO}.pbs.100.txt
