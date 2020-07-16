
VCF=$1  #compressed vcf file

for i in $(cat list_chromosomes ) ;
do
	bcftools view -r $i ${VCF} |bgzip -c > ${VCF%.vcf.gz}.$i.vcf.gz
	tabix -p vcf ${VCF%.vcf.gz}.$i.vcf.gz
done 
 

