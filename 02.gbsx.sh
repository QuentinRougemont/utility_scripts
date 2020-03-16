#!/bin/bash
#SBATCH -J "gbsx"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibismax
#SBATCH -A ibismax
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=00:02:30
#SBATCH --mem=10G

#header to run job on MOAB using msub command
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#script to run gbsx
#see full documentation at: https://github.com/GenomicsCoreLeuven/GBSX

#here desing for gbs data single end
#can be customized very easily
infile="your_file.gz"
outfile="03-demultiplex"
folder="02-raw/trimmed"
path="./GBSX/releases/GBSX_v1.3"
barcode="your_barcodes.txt"
rad="-rad false"
gzip="-gzip true"
qual="-q Illumina1.8"
java -jar "$path"/GBSX_v1.3.jar --Demultiplexer -f1 "$folder"/"$infile" -i "$barcode" $gzip $rad $qual -o "$outfile"
