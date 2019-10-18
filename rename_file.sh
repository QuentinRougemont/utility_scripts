#!/bin/bash
# script to rename the prefix of 
#any long series of file with various suffix end

input=$1  #shared name of the list of file
rename=$2 #basename to replace 
newname=$3 #replacement name
     
for i in $( ls *$input* ); 
do
	#echo -e "
	input=$i
	output=$(echo "$input" | sed -e "s/$rename/$newname/g")
	mv "$input" "$output" #"
done
