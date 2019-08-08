#!/usr/bin/env Rscript

#14-07-2019 
#script to convert vcf to baypass input
#compute allele frequency with plink 
#you need a cluster file and a vcf 
#/!\ You need plink installed

argv <- commandArgs(T)
vcf <- argv[1] #plink freq file 
cluster <- argv[2] #cluster file 

if (argv[1]=="-h" || length(argv)==0){
cat("run as:\n./vcf2baypass.R \"vcf_file\" \n" )
}else{

if("reshape2" %in% rownames(installed.packages()) == FALSE)
	{install.packages("reshape2", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
	{install.packages("data.table", repos="https://cloud.r-project.org") }

library(reshape2)
library(data.table)


##1st step compute frequency with plink (you need plink installed)
vcf_to_ped=paste("plink --vcf",vcf , "--allow-extra-chr --recode " ) 
system(vcf_to_ped)
reshape=paste("awk '{print $1\"_\"$2, $1 }' plink.ped > pop_ind.tmp\n",
	"cut -d \" \" -f 3- plink.ped > geno.tmp \n",
	"paste pop_ind.tmp geno.tmp > plink.ped \n",
	"rm *tmp" )
system(reshape)
plinkfreq=paste("plink --file plink --allow-extra-chr --freq --within", 
	cluster,
	"--out plink" ,
	sep =" ")
system(plinkfreq)
zipfile=paste("gzip plink.frq.strat")
system(zipfile)


#2nd step read and reshape the freq
#freq <- read.table(freq)
#alternative with fread is possible
#freq <- paste("zcat", freq,sep=" ")
freq <- fread("zcat plink.frq.strat.gz")
#freq <- fread(freq)

freq$CHR_SNP <- paste(freq$CHR,freq$SNP, sep="_")                                                   
b=freq[,c(3,6,9)]                                                                             
#dat=dcast(b, CHR_SNP ~ CLST, value.var="MAF" )                                             
#dat <- row.names(dat)=dat$CHR_SNP                                                              
#dat <- dat[,-1]                                                                            
b=freq[,c(3,8,9)]
dat = dcast(b, CHR_SNP ~ CLST, value.var="NCHROBS")      
b=freq[,c(3,7,9)]
dat2 = dcast(b, CHR_SNP ~ CLST, value.var="MAC")         
                                                                                        
#write.table(dat2,"MAF",quote=F,row.names=T,col.names=T)  
#write.table(dat,"MAJ",quote=F,row.names=T,col.names=T)   

maj <- t(dat)
maf <- t(dat2)

maj <- maj[-1,]
maf <- maf[-1,]

m <- data.frame(rbind(maj,maf))
m$pop <- row.names(m)
m1 <- m[order(m$pop),]  
write.table(t(m1),"baypass",col.names=F,row.names=F,quote=F) 
}
