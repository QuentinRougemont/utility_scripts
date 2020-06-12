#!/bin/bash

#12-12-18
#script to compute distance using mvftools
#need to install mvftools
#the path to the software is added to the .bashrc 


if [ $# -ne 1  ]; then
    echo "USAGE: $0 mvfile windowsize"
    echo "Expecting a mvf file as input"
    exit 1
else
    input=$1
    window=$2
    echo "mvf file is : ${input}"
    echo "windowsize is :${window}"

fi


#Running!
#####echo running mvtools now ##########
python3 /home/qurou/software/mvftools/mvftools.py \
	CalcPairwiseDistances \
	--mvf "$input" \
	--out pairdist_"${input%.mvf}".$window \
	--windowsize $window

