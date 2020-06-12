#!/usr/bin/Rscript
##!/usr/local/bioinfo/src/R/R-3.2.2/bin/Rscript

if("LEA" %in% rownames(installed.packages()) == FALSE) {source("https://bioconductor.org/biocLite.R") ; biocLite("LEA") }

library(LEA)

#conversion to genotype format
argv <- commandArgs(T)
input <- argv[1]
output = vcf2geno(input,"02.results/genotype.geno")

#1. Estimating K
obj.at = snmf("./02.results/genotype.geno", K = 1:100, ploidy = 2, entropy = T,repetitions=10,alpha=10,percentage=0.05,
              CPU = 10,project = "new")

pdf(file="CV.full.data.pdf",12,8)
plot(obj.at, col = "blue4", cex = 1.4, pch = 19)
dev.off()

