#!/bin/bash
#SBATCH -J "maski3"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=58:30:00
#SBATCH --mem=02G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR
module load vcftools

#takes a vcffile as input and the list of all populations 
INPUT=$1 #name of the vcffile
if [[ -z "$INPUT" ]]
then
    echo "Error: need vcf input file "
    exit
fi

pop_folder=$2
if [[ -z "$pop_folder" ]]
then 
    echo "Error: need pop_map folder containing pop_map for each pop"
    exit
fi

sbatch ./00.compute_fst_v2.sh
