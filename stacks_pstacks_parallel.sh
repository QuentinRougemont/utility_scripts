#!/bin/bash
# Move to directory where job was submitted

#EMAIL="quentinrougemont@orange.fr"

echo -e '#!/bin/bash' > pstacks.msub.sh
echo "#PBS -A ihv-653-ab" >> pstacks.msub.sh
echo "#PBS -N pstacks" >> pstacks.msub.sh
echo "#PBS -o pstacks.out" >> pstacks.msub.sh
echo "#PBS -e pstacks.err" >> pstacks.msub.sh
echo "#PBS -m bea" >> pstacks.msub.sh
echo "#PBS -l walltime=00:15:00" >> pstacks.msub.sh
echo "#PBS -M $EMAIL" >> pstacks.msub.sh
echo "#PBS  -l nodes=1:ppn=8 " >> pstacks.msub.sh

echo " " >> pstacks.msub.sh
echo 'cd "${PBS_O_WORKDIR}" ' >>  pstacks.msub.sh
#echo "module load apps/stacks/1.44" >>pstacks.msub.sh
#echo "module load compilers/intel/14.0" >> pstacks.msub.sh
echo " " >> pstacks.msub.sh

echo 'TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss) '  >> pstacks.msub.sh
echo " " >> pstacks.msub.sh  >> pstacks.msub.sh
echo -e "LOG_FOLDER="10-log_files" ">> pstacks.msub.sh
echo -e 'SCRIPT=00-scripts/colosse_jobs/stacks_1b_pstacks.sh'>> pstacks.msub.sh
echo 'cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$SCRIPT" ' >> pstacks.msub.sh

echo " " >> pstacks.msub.sh
echo "pstacks -t bam -f \$FILE -i \$cpt -o 05-stacks -m 2 --model_type snp --alpha 0.05 --pct_aln 95 2>&1 |tee 10-log_files/"$TIMESTAMP"_stacks_1b_pstacks.log" >> pstacks.msub.sh

cpt=1
for FILE in 04-all_samples/*bam; do
     export FILE cpt
     msub -v FILE,cpt pstacks.msub.sh
     let cpt+=1
done
