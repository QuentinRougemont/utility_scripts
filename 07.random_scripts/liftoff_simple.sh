#!/bin/bash
#Purpose: miniscript to run liftoff
#Author: QR
#Date: 09-02-2023
#Note: install liftoff through conda or pip first!

##  ------------------------ general parameters --------------------------------  ##
while [ $# -gt 0 ] ; do
  case $1 in
    -gff ) GFF="$2" ;echo "the gff file  is: $GFF" >&2;;
    -r | --ref) Ref="$2" ;echo "refenrence genome is $Ref" >&2;;
    -t | --target) Target="$2" ;echo "target genome is $Target" >&2;;
    -o | --output) out="$2" ;echo "output gff will be $out" >&2;;
    -h | --help) echo -e "Option required:
	-gff \t the gff file to lift
	-o/--output \t Output gff prefix
	-r/--ref \t the reference genome associated with the gff
	-t/--target\t the target genome
	Optional: 
	additional option can be commented/uncommented directly in the script" >&2;exit 1;;
    esac
    shift
done

if [ -z "$GFF" ] || [ -z "$Ref" ] || [ -z "$Target" ] || [ -z $out ]; then
        echo >&2 "Fatal error: GFF, Ref genome, Target genome and output are not defined"
exit 2
fi
## ------------------- general input -----------------------------------------##
NCPU=8
echo "-------------------"
echo target is $Target
echo "-------------------"
echo ref is $Ref
## --------------------------    liftoff option    ---------------------------##
output="-o $out"
g="-g $GFF"
a="-a 0.5"
s="-s 0.5"
d="-d 2"
i="-infer_genes"
p="-p $NCPU"
c="-copies"
e="-exclude_partial"
#direct="-dir directory"
u="-u unmapped_features.txt"
m="-mm2_options=-a --end-bonus 5 --eqx -N 50 -p 0.5"  #to add
#f="-flank "  #to add
pol="-polish"

liftoff -g $GFF \
	-o "$out".gff3 \
	"$pol" \
	"$m" \
	"$u"  \
	"$e"  \
	-dir intermediate_files \
	"$a" "$s" "$d" \
	-infer_genes \
	"$p" \
	"$c" \
	$Target $Ref
