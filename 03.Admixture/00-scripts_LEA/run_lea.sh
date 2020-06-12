#!/bin/bash
#SBATCH -J "fulladmix"
#SBATCH -o log_%j
#SBATCH -c 10
#SBATCH -p large
##SBATCH --mail-type=FAIL
##SBATCH --mail-user=YOUREMAIL
#SBATCH --time=21-00:00
#SBATCH --mem=01G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

input=$1 #this must be a vcffile

if [ ! -d "02.results" ]
then 
	mkdir 02.results
fi 
Rscript 00-scripts/rscript/01.structure.lea.R "$input"
