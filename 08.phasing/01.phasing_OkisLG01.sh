#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N merge__
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=8
#PBS -r n

# Move to job submission directory
cd $PBS_O_WORKDIR

#details here: https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/shapeit.html
#bcftools view --max-alleles 2 --exclude-types indels GVCFall_SNPs.final_cleaned.vcf.gz |bgzip -c > GVCFall_SNPs.final_cleaned.biallelic.vcf.gz

source /clumeq/bin/enable_cc_cvmfs

module load bcftools

VCF=final_cleaned_no_missing.biallelic.OkisLG01.vcf.gz #file splited by chromosomes
OUTPUT=${VCF%.vcf.gz}_phased

shapeit --input-vcf $VCF \
    -O $OUTPUT \
    --window 0.5 -T 8

shapeit -convert \
    --input-haps ${OUTPUT} \
    --output-vcf ${OUTPUT}.vcf

bgzip ${OUTPUT}.vcf
bcftools index ${OUTPUT}.vcf.gz


exit

#### MORE OPTIONS BELOW #####
shapeit --input-vcf $VCF \
        -M genetic_map.txt \
        -O $OUTPUT \
        --window 0.5 \
	-T 8 \
        --burn 10 \
        --prune 10 \
        --main 50 \
        --states 200 \
        --effective-size 15000

