#!/usr/bin/Rscript
##!/usr/local/bioinfo/src/R/R-3.2.2/bin/Rscript

#Author= "Quentin Rougemont"
#purpose = "Miniscript to reshape a classical ped file into a genotypic matrix (usefull for several programms)
#how to run = "03.run.spacemix.R sample.covariance.matrix sample.size x_y.coordinates fast.model.opts long.model.opts nloci 
#last uptade = "15.09.2016"
#Output = genotypic matrix (AC, TG, AA, CC, etc. with inds in row, mk in cols)

argv <- commandArgs(TRUE) #Ped file

if (argv[1]=="-h" || length(argv)==0){
	cat("\nped2matrix.R \"input.ped\" \"input.map\" \n" )
}else{



dat  <-argv[1] 
loc  <-argv[2]
dat2 <-as.matrix(read.table(dat,h=F)) 
dat3 <-dat2[,-c(1:6)] 

dat3[dat3 == "0"] <- NA

dat4  <- read.table(loc)[,2]

dat5  <- as.matrix( t(c("ind","pop",as.character(dat4)) ))
start <- seq(1, by = 2, length = ncol(dat3) / 2)

sdf   <- sapply(start,function(i, dat3) paste(as.character(dat3[,i]),as.character(dat3[,i+1]), sep="") ,dat3 = dat3) 

sdf[sdf=="NANA"] <- "--"
sdf[sdf=="TRUE"] <- "T"

write.table( rbind( dat5, as.matrix( cbind(dat2[,c(1:2)],as.data.frame(sdf)) ) ),"genotypic.matrix",quote=F,col.names=F,row.names=F)

}
