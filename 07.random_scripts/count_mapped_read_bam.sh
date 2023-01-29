

#conting the number of successfully mapped read
#for single end:
for i in *bam ; do samtools view -F 0x904 -c $i |awk -v var="$i" 'END {print var"\t"$1}' ; done

#paired-end:
for i in *bam ; do 
	samtools view -F 0x4 $i | cut -f 1 | sort | uniq | wc -l |\
		awk -v var="$i" 'END {print var"\t"$1}' ;
done
