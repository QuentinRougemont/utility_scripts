#!/bin/bash

#12-12-18
#need to install mvftools
#script to run mvftools

if [ $# -ne 1  ]; then
    echo "USAGE: $0 vcfile"
    echo "Expecting a vcf file as input"
    exit 1
else
    input=$1
    echo "vcf file is : ${input}"
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

#####echo running mvtools now ##########
python3 /mvftools/mvftools.py \
	ConvertVCF2MVF \
	--vcf "$input" \
	--out "${input%.vcf.gz}.mvf" 

#### conversion is done ##############
