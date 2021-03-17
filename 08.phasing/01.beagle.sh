#!/bin/bash

if [ $# -ne 1 ]; then
    echo "USAGE: $0 <vcfile> "
    exit 1
else 
    vcf=$1
    echo "vcffile will be $CHROMO"
    echo 
    echo 
fi



if [ ! -f beagle.18May20.d20.jar ]; then
  echo
  echo "Downloading beagle.18May20.d20.jar"
  wget http://faculty.washington.edu/browning/beagle/beagle.18May20.d20.jar
fi


echo

echo
echo "*** Running beagle analysis with \"gt=\" argument ***"
echo
java -Xmx48g  -jar beagle.18May20.d20.jar \
        gt=$vcf \
        out=out.chr1 \
        impute=true nthreads=8 #window=10000 overlap=1000 gp=false 
