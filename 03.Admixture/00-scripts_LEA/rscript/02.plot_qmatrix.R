#QR 13-09-16
#Script by O. François to analysze pop structure
#install.packages(c("fields","RColorBrewer","mapplots"))
#source("http://bioconductor.org/biocLite.R")
#biocLite("LEA")

argv <- commandArgs(T)

K <- argv[1]

#if("LEA" %in% rownames(installed.packages()) == FALSE) {source("https://bioconductor.org/biocLite.R") ; biocLite("LEA") }
#if("maplots" %in% rownames(installed.packages()) == FALSE) {install.packages("maplots") }

library(LEA)
#library(mapplots)

project <- load.snmfProject("genotype.snmfProject")
ce = cross.entropy(project, K = K)
best = which.min(ce)
qmatrix <- read.table(paste("genotype.snmf/K",K,"/run", best,"/genotype_r",best,".",K,".Q", sep="")  ) 

pdf( file = paste("structure.K",K,"best_run.pdf",sep="."), 16, 5 )
barplot(t(as.matrix(qmatrix) ), col=rainbow(ncol(qmatrix) ) ,
	 border=NA ,  xlab="individuals", ylab="ancestry coefficient" )
dev.off()
