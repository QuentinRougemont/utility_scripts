#!/bin/bash 

#purpose: script to prepare ALL abc input file from a ped file containing multiple population to be compared
#Author: Quentin Rougemont - quentinrougemont@orange.fr
#date: 12-10-2016
#how to: ./prepare.abc.sh input.ped input.map

INPUT_1=$1 #ped file 
INPUT_2=$2 #map file 
input_folder=input_folder/ #name of the folder containing all input files

mkdir "$input_folder"

Rscript 00-scripts/ped2matrix.R "$INPUT_1" "$INPUT_2" #usefull to produce the genotypic matrix
Rscript 00-scripts/prepare.abc.R genotypic.matrix "$input_folder"

#alternatively you can run this single script:
#Rscript prepare.abc.2.R "$INPUT_1" "$INPUT_2" "$input_folder"

input=$(echo "${input_folder%\/}" )
list=$(ls "$input_folder"* |sed -e "s/.ABC.tmp//g"  -e "s/$input//g" -e "s/\///g" | sed -e "s/ /\n/g"  )

for i in $list ; 
do
    mkdir "$input_folder"$i
    mv "$input_folder"$i.ABC.tmp "$input_folder"$i/  ;
done

#now we want to execture inputgen2py on all subfile and then execture mscalc
for i in $list ;
do
    echo -e "cd ../../"$input_folder"$i\n ../../00-scripts/inputGen_modifquentin.py  $i.ABC.tmp ${i:0:$(expr ${#i} / 2)} ${i:$(expr ${#i} / 2)} 0.2 \n" >> inputgen ;
done 

sed -i '0,/..\/..\//s///' inputgen

#autre solution:
#LIGNE=`cat inputgen | grep "../" -n -m 1` 
#NB_LIGNE="`echo $LIGNE | cut -f1 -d ':' `"  # Numéro ligne seule
#sed -i ""$NB_LIGNE"s|..\/||" "inputgen"

bash inputgen 

#now execute mscalc
for i in $list 
do
    cp "$input_folder"$i/spinput.txt "$input_folder"$i/spinput.txt.2  ;
    sed -i 's/myfifo/locus.ms/g' "$input_folder"$i/spinput.txt ;
    sed -i 's/100000/1/g' "$input_folder"$i/spinput.txt ;  
    echo -e "cd ../../"$input_folder"$i\n /usr/bin/mscalc/mscalc0 spinput.txt \n" >> ms.calc 
done
sed -i '0,/..\/..\//s///' ms.calc
bash ms.calc

#Ensuite renommer tout les ABC.stats en OBS.ABC.stat.txt
for j in $list ; 
do
    mv "$input_folder"$j/ABCstat.txt "$input_folder"$j/OBS.ABC.stat.txt
    mv "$input_folder"$j/spinput.txt.2 "$input_folder"$j/spinput.txt
    rm "$input_folder"$j/error.txt  "$input_folder"$j/spoutput.txt 
done
