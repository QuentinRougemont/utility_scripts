#!/bin/bash
#SBATCH -J "epic"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibismax
#SBATCH -A ibismax
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=14:30:00
#SBATCH --mem=18G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

cd 02.results/
input_K=$1 #K value

if [[ -z "$input_K" ]]
then
    echo "Error: need K value to extrapolate"
    exit
fi

Rscript ../00-scripts/rscript/02.plot_map.by_K.R "$input_K" 
