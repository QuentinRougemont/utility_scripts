#!/bin/bash                        
#SBATCH -J "ancestral_seq"         
#SBATCH -o log_%j                  
#SBATCH -c 10                      
#SBATCH -p medium                  
#SBATCH --mail-type=FAIL           
#SBATCH --mail-user=YOUREMAIL      
#SBATCH --time=06-00:00            
#SBATCH --mem=60G                  


module load angsd/0.931

path=$(pwd)

bamlist=bamlist.list

angsd -b ${bamlist}  -doFasta 2 -doCounts 1 \
        -ref $path/03_genome/yougenome.fasta  \
        -out ancestral_genome.fasta

