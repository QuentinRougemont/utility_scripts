#!/usr/bin/env Rscript
#script to compute Dxy
#read data from stream
 
argv <- commandArgs(T)
input <- argv[1]
windowsize=1e5

library(data.table)
name <- basename(input)
outname <- strsplit( strsplit(input,"dist_pairdist_")[[1]][2],"gz")

input <- paste("zcat", input,sep=" ") 
dist <- fread(input)

header <- dist[c(1:2),]

pop_pairs <- ((dist[-c(1:2),1])[[1]])

#matrice des distances uniquementement 
tot = ncol(dist)
dist = dist[-c(1:2),5:tot]

#calcul des Dxy par paire de pop
dist_moyenne  <- aggregate(dist/windowsize, by=list(pop_pairs), mean)
columns = dist_moyenne[,1]
dist_moyenne <- t(dist_moyenne[,-1])
#ajouter nom des pops
colnames(dist_moyenne)=columns

#ajouter nom des CHR et longueur:
col1col2 <- t(header[(1:2),5:ncol(header)])
colnames(col1col2) = c("CHR","POS")

#tableau final:
input <- cbind(col1col2,dist_moyenne)

write.table(input,paste("dxy_",outname,"txt",sep=""), quote=F) 

