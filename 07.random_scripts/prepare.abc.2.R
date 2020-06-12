#!/usr/bin/env rscript

#Author= "Quentin Rougemont"
#purpose = "Miniscript to reshape a genotypic matrix into all pairwise genotypic file use to prepare abc file 
#how to run = "./prepare.abc.R ped.file map.file folder  
#last uptade = "15.09.2016"
#Output = abc.input file for bash

argv <- commandArgs(TRUE) #Ped file

if (argv[1]=="-h" || length(argv)==0){
        cat("\nprepare.abc.R \"ped.file\" \"map.file\" \"folder.path\" \n" )
}else{

#input <- argv[1]
dat  <- argv[1]
loc  <-argv[2]
folder <- paste(argv[3])

dat2 <-as.matrix(read.table(dat,h=F))
dat3 <-dat2[,-c(1:6)]

dat3[dat3 == "0"] <- NA

dat4  <- read.table(loc)[,2]

dat5  <- as.matrix( t(c("ind","pop",as.character(dat4)) ))
start <- seq(1, by = 2, length = ncol(dat3) / 2)

sdf   <- sapply(start,function(i, dat3) paste(as.character(dat3[,i]),as.character(dat3[,i+1]), sep="") ,dat3 = dat3)

write.table( rbind( dat5, as.matrix( cbind(dat2[,c(1:2)],as.data.frame(sdf)) ) ),"genotypic.matrix",quote=F,col.      names=F,row.names=F)

system("sed -i 's/NANA/--/g' genotypic.matrix*", wait=FALSE)
system("sed -i 's/TRUE/T/g' genotypic.matrix*", wait=FALSE)


input_1 =  rbind( dat5, as.matrix( cbind(dat2[,c(1:2)],as.data.frame(sdf)) ) )

marker <- input_1[1, ]
input_1 <-  input_1[-1, ]

input_1[which(input_1[,1]=="Matane"), ] <-"Mat2"
input_1[which(input_1[,1]=="StJeanCote"), ] <-"StJC"
input_1[which(input_1[,1]=="StJeanGasp"), ] <-"StJG"

input_1[,1] <- substr( x=input_1[,1], start=1, stop=4)
result <- lapply( split( input_1, input_1[,1]), matrix, ncol=ncol(input_1) )

#names(result)

#target.folder = eval(parse(text = folder))

#Then write the target table:
#exemple:
for(i in 1:length(result))
{
     for(j in 1:length(result))
     {
     write.table(cbind(all,t(rbind(result[[i]],result[[j]]))),paste(folder,names(result[i]),names(result[j]),".ABC.tmp",sep=""), quote=F, row.names=F, col.names=F,sep="\t")
     }
}
# /!\ Warning this will creates a very large amount of input file!!
#Alternatively just creates a small amount of data manually:
#eg:
#write.table(cbind(all,t(rbind(result$Loir,result$Narr))),"LoirNarr.ABC.tmp", quote=F, row.names=F, col.names=F,sep="\t")
}
