#!/bin/bash

if [ $# -ne 1 2 ]; then
    echo "USAGE: $0 vcfile windowsize "
    echo "Expecting a vcf file as input"
    echo "size of the window"
    exit 1
else
    input=$1
    window=$2
    echo "vcf file is : ${input}"
    echo "windowsize is :${window}"
fi

if file --mime-type "$input" | grep -q gzip$; then
  echo "$input is gzipped"
else
  echo "$input is not gzipped"
  echo "will compress with bgzip"
  bgzip "$input"
  input=$( echo "$input".gz )
  echo "compression is done"
fi
#echo $input
if [ ! -d "$POP_MAP" ]
then 
    echo "warning no population map folder find"
    echo "I'll try to extract the info assuming individuals name in the vcf are as follow:"
    echo "pop1_01 pop1_02 pop2_01 pop2_02"
fi

####SOME USEFUL FUNCTION ###################################################
function popvcf () { zcat "$input" |grep "CHR" |cut -f 10- |\
    perl -pe 's/\t/\n/g' |\
    cut -d "_" -f 1 |\
    sort |\
    uniq > "list_pop" ; }

function listind () { zcat "$input" |grep "CHR" |\
    cut -f 10- |\
    perl -pe 's/\t/\n/g' | \
              sed 's/_/\t/g' | awk '{print $1"_"$2}' > "list_ind"; }

listind
popvcf

mkdir POP_MAP 2>/dev/null
for i in $(cat list_pop) ; do 
    grep $i list_ind > POP_MAP/pop.$i 
done

if [ ! -d "fst_file" ]
then 
    mkdir fst_file
fi

for i in $(ls POP_MAP/pop* |sed 's/POP_MAP\/pop.//g' )
do
    for j in $(ls POP_MAP/pop* |sed 's/POP_MAP\/pop.//g' )
    do
        if [ "$i" != "$j" ]
        then
            if [ "$i" > "$j" ]
            then
                 vcftools --gzvcf $input \
			 --weir-fst-pop POP_MAP/pop.$i\
			 --weir-fst-pop POP_MAP/pop.$j\
			 --fst-window-size $windows\
			 --window-pi-step $window\
			 --out fst_file/fst."$i".vs."$j"
            fi
        fi
    done
done
