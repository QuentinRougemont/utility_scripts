#!/usr/bin/Rscript

if("LEA" %in% rownames(installed.packages()) == FALSE) {source("https://bioconductor.org/biocLite.R") ; biocLite("LEA") }
if("mapplots" %in% rownames(installed.packages()) == FALSE) {install.packages("mapplots") }

library(LEA)
library(mapplots)

argv <- commandArgs(T)

if (argv[1]=="-h" || length(argv)==0){
	cat("\nplot_pie_chart.R \"coord_and_pop table (first col= individuals second and third col=coord\" \"K values to run\" \n" )
}else{

coord_and_pop <- argv[1]
K <- argv[2]

#read data
project <- load.snmfProject("genotype.snmfProject")    
coord <- read.table(coord_and_pop)[,c(2:3)] #coordinates file for each pop
pop <- as.matrix((read.table(coord_and_pop)[,1] )) #pop names
ce = cross.entropy(project, K = K)                     
best = which.min(ce)                                   
qmatrix <- read.table(paste("genotype.snmf/K",K,"/run", best,"/genotype_r",best,".",K,".Q", sep="")  )

#reshape data
K = ncol(qmatrix)
Npop <-  length(unique(pop))
coord.pop <- unique(coord)

tmp1<- mapply(rowsum, as.data.frame(qmatrix), as.data.frame(pop))
dimnames(tmp1)<- list(levels(factor(pop[,c(1)]))) #, 1:nrow(samp.siz.1[,c(1)]))
tmp<-as.matrix(table(pop))
tmp=rep(cbind(tmp),ncol(qmatrix))
qpop<-tmp1/tmp

#perform plot
pdf(file=paste("admixture.proportion.K",K,"best_run.pdf",sep="") ,22 , 10 )
plot(coord, xlab = "Longitude", ylab = "Latitude", type = "n", main= paste("Admixture proportions accross Coho salmon native range K=" , K ,sep=" ") )
map(add = T, col = "grey90", fill = TRUE)

for (i in 1:Npop){
add.pie(z = qpop[i,], x = coord.pop[i,1], y = coord.pop[i,2], labels = "",radius=0.45,
col = c(rainbow(K) ) ) } #,"red","darkgreen","yellow"))}
dev.off()
}
