#!/bin/bash
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

outfolder="00.fst_vcftools"
mkdir "$outfolder"

#fst vrom vcftools
for i in $(echo "$pop_folder"/* |sed "s/$pop_folder\///g" ) ; do 
    for j in  $(echo "$pop_folder"/* |sed "s/$pop_folder\///g") ; 
    do
            if [ "$i" != "$j" ] ; then
                if [[ "$i" > "$j" ]] ; then 
                    vcftools --vcf $INPUT --weir-fst-pop "$pop_folder"/$i --weir-fst-pop "$pop_folder"/$j --out "$outfolder"/fst."$i".vs."$j" ; 
                fi
            fi
    done ; 
done

#grep "weighted"  log.* |sed -e 's/Weir and Cockerham weighted Fst estimate: //g' >> table.fst ; 
#ls "$outfolder"/*.fst | sed -e 's/fst.pop.//g' -e 's/.vs.pop.//g' -e 's/.weir.fst//g' > list
#paste list table.fst > table.fst.pop
