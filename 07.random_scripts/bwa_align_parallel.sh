#!/bin/bash
echo -e '#!/bin/bash' > msub.bwa.sh
echo "#PBS -A ihv-653-ab" >> msub.bwa.sh
echo "#PBS -N bwa" >> msub.bwa.sh
echo "#PBS -o bwa.out" >> msub.bwa.sh
echo "#PBS -e bwa.err" >> msub.bwa.sh
echo "#PBS -m bea" >> msub.bwa.sh
echo "#PBS -l walltime=00:15:00" >> msub.bwa.sh
echo "#PBS -M $EMAIL" >> msub.bwa.sh
echo "#PBS  -l nodes=1:ppn=8 " >> msub.bwa.sh
echo " " >> msub.bwa.sh 
echo 'cd "${PBS_O_WORKDIR}" ' >>  msub.bwa.sh
echo 'GENOMEFOLDER="08-genome" ' >>msub.bwa.sh
echo 'GENOME="eso.luc.fasta"   '>>msub.bwa.sh
echo 'DATAFOLDER="04-all_samples" '>>msub.bwa.sh
echo " ">>msub.bwa.sh
echo 'module load compilers/gcc/4.8.5  apps/mugqic_pipeline/2.1.1  mugqic/bwa/0.7.12 '>>msub.bwa.sh
echo 'module load  mugqic/samtools/1.2'>>msub.bwa.sh
echo " ">>msub.bwa.sh

# Index genome if not alread done
# bwa index -p $GENOMEFOLDER/$GENOME $GENOMEFOLDER/$GENOME.fasta

echo 'for file in $(ls -1 $DATAFOLDER/*.fq.gz)'>>msub.bwa.sh
#echo "for file in $(cat $list)>>msub.bwa.sh
echo "do">>msub.bwa.sh
echo 'echo "    Aligning file $file" '>>msub.bwa.sh
echo " ">>msub.bwa.sh
echo '  name=$(basename $file)'>>msub.bwa.sh
echo "  ID="@RG\tID:ind\tSM:ind\tPL:IonProton" ">>msub.bwa.sh
echo " " >>msub.bwa.sh
echo "  # Align reads 1 step">>msub.bwa.sh
echo '  bwa mem -t "$NCPU" -k 19 -c 500 -O 0,0 -E 2,2 -T 0 -R $ID \ '>>msub.bwa.sh
echo '  $GENOMEFOLDER/$GENOME $DATAFOLDER/"$name" 2> /dev/null | '>>msub.bwa.sh
echo "  samtools view -Sb -q 4 -F 4 -F 256 -F 2048 \ ">>msub.bwa.sh
echo '   - > $DATAFOLDER/"${name%.fq.gz}".bam '>>msub.bwa.sh
echo "done" >>msub.bwa.sh
