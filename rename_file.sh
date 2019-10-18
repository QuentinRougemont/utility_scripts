#!/bin/bash
# script to rename the prefix of 
#any long series of file with various suffix end

input=$1  #shared name of the list of file
rename=$2 #basename to replace 
newname=$3 #replacement name
     
for i in *"$input"*; 
do
	#echo -e "
	input=$i
	output=$(echo "$input" | sed -e "s/$rename/$newname/g")
	mv "$input" "$output" #"
done

#or simply use the function rename:
#rename 's/from/to/' pattern 
#beware that you need the one by Robin Barker in perl  
