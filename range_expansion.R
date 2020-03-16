#!/usr/bin/Rscript
#QR - 22-12-17
#purpose: calculate psi index from Peter & Slatkin Evolution paper
#input file = vcffile 
#input file = geographic coordinates of every individuals (ind_id\tpop_id\t\longitute\latitude\strata)
#can be easily modified to read bedfile (see below)

if("geosphere" %in% rownames(installed.packages()) == FALSE) {install.packages("geosphere", repos="https://cloud.r-project.org") }
if("rworldmap" %in% rownames(installed.packages()) == FALSE) {install.packages("rworldmap", repos="https://cloud.r-project.org") }
if("snpStats" %in% rownames(installed.packages()) == FALSE) {source("https://bioconductor.org/biocLite.R") ; biocLite("snpStats") }

library(snpStats)
library(devtools)
library(geosphere)
library(rworldmap)
options(unzip = "unzip")
devtools::install_github("BenjaminPeter/rangeExpansion", ref="package")
library(rangeExpansion)

#load coord and extract region
coords <- ("01.data/coords_file.csv")
coord<-read.csv("01.data/coords_file.csv",header=T)
colnames(coord)<-c("id","pop","longitude","latitude","region")
region <- list( unique(coord$region))


#if SNAPP
#create SNAPP input from vcffile
argv <- commandsArgs(T)                                         
vcf <- argv[1]                                                  
convert <- paste("vcftools --vcf",vcf,"--012", sep=" ")         
system(convert)                                                 
paste_file=("paste out.012.indv out.012 |sed 's/\t/,/g' |sed 's/-1/?/g'  >01.data/data.snapp")
system(paste_file)                                              
                                                                
#if BED:
#argv <- commandArgs(T)
#data <- argv[1] #input bed file
#data <- load.plink.file(data)

ploidy <- 2
raw.data <- load.data.snapp(data,
                            coords,
                            sep=',', ploidy=ploidy)                                

pop <- make.pop(raw.data, ploidy)
psi <- get.all.psi(pop)

res <- run.regions(region=region, pop=pop, psi=psi, xlen=10,ylen=20)

