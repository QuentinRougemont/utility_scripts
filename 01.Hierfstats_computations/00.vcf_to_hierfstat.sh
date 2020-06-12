#!/bin/bash

ulimit -n 3000

INPUT=$1 #name of input_file
if [[ -z "$INPUT" ]]
then
    echo "Error: need vcf input file "
    exit
fi

vcftools --vcf "$INPUT" --012

cut -f 2-  out.012 |\
	sed -e 's/2/22/g' -e 's/-1/NA/g' -e 's/1/12/g' -e 's/0/11/g' > out.tmp

sed 's/_/\t/g' out.012.indv |awk '{print $1}' > pop

paste pop out.tmp > hierfstat.data.tmp

for i in $( seq $(wc -l out.012.pos |awk '{print $1}') ) ; 
do
    echo -en "pop\tloc_"$i >> loc.tmp ;  
done ; echo -ne "\n" >> loc.tmp

cat loc.tmp hierfstat.data.tmp > hierfstat.data.txt
rm *tmp
