#!/usr/bin/env Rscript
#script to run stammp from vcffile

argv <- commandArgs(T)

vcf <- argv[1] #vcffile to be processed
pop <- argv[2] #pop

if (argv[1]=="-h" || length(argv)==0){
cat("run as:\n./run_stamp.R \"vcffile\" \n\n" )
}else{

if("vcfR" %in% rownames(installed.packages()) == FALSE)
	{install.packages("vcfR", repos="https://cloud.r-project.org") }
if("StAMPP" %in% rownames(installed.packages()) == FALSE)
	{install.packages("StAMPP", repos="https://cloud.r-project.org") }

library(vcfR)
library(StAMPP)

vcf <- read.vcfR(vcf)
#vcf 2 genlight 
gen <- vcfR2genlight(vcf) 
pop.names <- read.table("pop")
pop.names <- read.table(pop)

### genlight to stmmpp matrix 
x2 <- as.matrix(gen) #convert genlight object to matrix 
sample <- row.names(x2) #sample names 

ploidy <- ploidy(gen) #extract ploidy info from genlight object 
x2 = x2 * (1/ploidy) #convert allele counts to frequency 
x2[is.na(x2)] = NaN 
format <- vector(length = length(sample))
#format id for the genotype data
format[1:length(format)] = "freq"  

x.stampp <- as.data.frame(cbind(sample, pop.names, ploidy, format, x2)) #convert to basic r data.frame suitable to stamppConvert 

geno <- stamppConvert(x.stampp, 'r') 
write.table(geno,"stampp_data.txt",quote=F)

fst <- stamppFst(geno,  nboots = 500, percent = 95, nclusters = 32)
#fst <- stamppFst(geno,  nboots = 500, percent = 95, nclusters = 10)
write.table(fst$Bootstraps,"bootstrapes.value",quote=F)
write.table(fst$Pvalues,"fst_pvalue",quote=F)
write.table(fst$Fsts,"fst_value",quote=F)

#stammPhylip 
nei.D.pop <- stamppNeisD(geno, pop = TRUE)
stamppPhylip(nei.D.pop, file="nei.D.pop")

}
