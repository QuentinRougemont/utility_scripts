#!/bin/bash
if [ $# -lt 1 ] ; then
    echo ""
    echo "usage: count_fastq.sh [fastq_file1] <fastq_file2> ..|| *.fastq"
    echo "counts the number of reads in a fastq file"
    echo "fastq can be compressed or not"
    echo ""
    exit 0
fi

#note: the compression check does not work on symlink files!

fastq=${@};
for i in ${fastq[@]}
do
	if file --mime-type "$i" | grep -q gzip$; then
		lines=$(zcat $i |wc -l |cut -d " " -f 1)
		count=$(($lines / 4))
		echo -n -e "\t$i : "
		echo "$count"  
	else
		lines=$(wc -l $i |cut -d " " -f 1)
		count=$(($lines / 4))
		echo -n -e "\t$i : "
		echo "$count"  
	fi
done

