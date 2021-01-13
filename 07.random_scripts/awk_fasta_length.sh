
#script to compute the length of a fasta
fasta=$1
output=$(basename $fasta)
output_folder=LENGTH
if [ ! -d "$output_folder" ]
then 
    echo "creating out-dir"
    mkdir "$output_folder"
fi
awk '/^>/ {if (seqlen){print seqlen}; print ;seqlen=0;next; } { seqlen += length($0)}END{print seqlen}' $fasta >> $output_folder/fasta_$output.txt

