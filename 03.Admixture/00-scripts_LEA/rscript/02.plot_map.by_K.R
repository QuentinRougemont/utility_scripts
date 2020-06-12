
#QR 13-09-16
#install.packages(c("fields","RColorBrewer","mapplots"))
#source("http://bioconductor.org/biocLite.R")
#biocLite("LEA")

argv <- commandArgs(T)

K <- argv[1]

#if("LEA" %in% rownames(installed.packages()) == FALSE) {source("https://bioconductor.org/biocLite.R") ; biocLite("LEA") }
#if("maplots" %in% rownames(installed.packages()) == FALSE) {install.packages("maplots") }

library(LEA)
#library(mapplots)
asc.raster<-("../01.data/etopo1.asc")
grid<-createGridFromAsciiRaster(asc.raster)
constraints<-getConstraintsFromAsciiRaster(asc.raster, cell_value_min=0)
coord <- read.table("../01.data/pop.coord.ind")[,c(2:3)] #coordinates file for each pop
#qmatrix11<- read.table("genotype.snmf/K11/run2/genotype_r1.11.Q")


project <- load.snmfProject("genotype.snmfProject")
ce = cross.entropy(project, K = K)
best = which.min(ce)

lColorGradients = list(
                       c("gray95",brewer.pal(9,"Reds")),
                       c("gray95",brewer.pal(9,"Greens")),
                       c("gray95",brewer.pal(9,"Blues")),
                       c("gray95",brewer.pal(9,"YlOrBr")),
                       c("gray95",brewer.pal(9,"RdPu")),
                       c("gray95",brewer.pal(9,"Purples")),
                       c("gray95",brewer.pal(9,"Greys"))
                       )
qmatrix <- read.table(paste("genotype.snmf/K",K,"/run", best,"/genotype_r",best,".",K,".Q", sep="")  ) 

pdf( file = paste("../../structure.K",K,"best_run.pdf",sep="."), 20, 12 )
maps(matrix = qmatrix, coord, grid, constraints, method = "max",
     main = "Ancestry coefficients Atlantic Salmon - K7 ", xlab = "Longitude", ylab = "Latitude", cex = 1)
map(add = T, interior = F)
dev.off()

#all_files=list.files(pattern=".Q")

#for (i in 1:length(all_files))
#{
#qmatrix <- read.table(all_files[i])
#pdf( file = paste("../../structure.K",K,"run",i".pdf",sep="."), 20, 12 )
#maps(matrix = qmatrix, coord, grid, constraints, method = "max",
#     main = "Ancestry coefficients Atlantic Salmon - K7 ", xlab = "Longitude", ylab = "Latitude", cex = 1)
#map(add = T, interior = F)
#dev.off()
#}

###############
#lColorGradients = list(
#                       c("gray95",brewer.pal(9,"Reds")),
#                       c("gray95",brewer.pal(9,"Greens")),
#                       c("gray95",brewer.pal(9,"Blues")),
#                       c("gray95",brewer.pal(9,"YlOrBr")),
#                       c("gray95",brewer.pal(9,"RdPu")),
#                       c("gray95",brewer.pal(9,"Purples")),
#                       c("gray95",brewer.pal(9,"Greys")),
#                       c("gray95",brewer.pal(9,"GnBu")),
#                       c("gray95",brewer.pal(9,"Pastel1")),
#                       c("gray95",brewer.pal(9,"OrRd")),
#                       c("gray95",brewer.pal(9,"Spectral"))
#)
#pdf(file="structure.K.11_v2_03_05.pdf",20,12)
#maps(matrix = qmatrix11, coord, grid, constraints, method = "max",
#          main = "Ancestry coefficients Atlantic Salmon - K11 ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()
#
#lColorGradients = list(
#                       c("gray95",brewer.pal(9,"Reds")),
#                       c("gray95",brewer.pal(9,"Greens")),
#                       c("gray95",brewer.pal(9,"Blues")),
#                       c("gray95",brewer.pal(9,"YlOrBr")),
#                       c("gray95",brewer.pal(9,"RdPu")),
#                       c("gray95",brewer.pal(9,"Purples")),
#                       c("gray95",brewer.pal(9,"Greys")),
#                       c("gray95",brewer.pal(9,"GnBu")),
#                       c("gray95",brewer.pal(9,"Pastel1")),
#                       c("gray95",brewer.pal(9,"OrRd")),
#                       c("gray95",brewer.pal(9,"Spectral")),
#                       c("gray95",brewer.pal(9,"BrBG")),
#                       c("gray95",brewer.pal(9,"YlGnBu")))#,
# 
#pdf(file="structure.K.13_v4.pdf",10,6)
#maps(matrix = qmatrix13, coord, grid, constraints, method = "max",
#          main = "S4 Fig Ancestry coefficients Atlantic Salmon - K13 ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

#png("Plot3.png", width = 12, height = 9, units = 'in', res = 300)
#maps(matrix = qmatrix13, coord, grid, constraints, method = "max",
#          main = "S4 Fig Ancestry coefficients Atlantic Salmon - K13 ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

#png("Plot4_K13.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix13, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

#lColorGradients = list(
#                       c("gray95",brewer.pal(9,"Reds")),
#                       c("gray95",brewer.pal(9,"Greens")),
#                       c("gray95",brewer.pal(9,"Blues")),
#                       c("gray95",brewer.pal(9,"YlOrBr")),
#                       c("gray95",brewer.pal(9,"RdPu")),
#                       c("gray95",brewer.pal(9,"Purples")),
#                       c("gray95",brewer.pal(9,"Greys")),
#                       c("gray95",brewer.pal(9,"GnBu")),
#                       c("gray95",brewer.pal(9,"Pastel1")),
#                       c("gray95",brewer.pal(9,"OrRd")),
#                       c("gray95",brewer.pal(9,"Spectral"))
#)
#png("Plot5_K11.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix11, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()
#
#qmatrix5 <- read.table("K5/run1/genotype_r1.5.Q")
#
#lColorGradients = list(
#                       c("gray95",brewer.pal(9,"Reds")),
#                       c("gray95",brewer.pal(9,"Greens")),
#                       c("gray95",brewer.pal(9,"Blues")),
#                       c("gray95",brewer.pal(9,"YlOrBr")),
#                       c("gray95",brewer.pal(9,"Purples")),
#                      )
#
#png("Plot6_K5_v2.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

#qmatrix5 <- read.table("K5/run2/genotype_r2.5.Q")

#png("Plot6_K5_v2_r2.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

#qmatrix5 <- read.table("K5/run3/genotype_r3.5.Q")
#
#png("Plot6_K5_v2_r3.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

#qmatrix5 <- read.table("K5/run4/genotype_r4.5.Q")
#
#png("Plot6_K5_v2_r4.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()
#qmatrix5 <- read.table("K5/run5/genotype_r5.5.Q")

#png("Plot6_K5_v2_r5.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()
#qmatrix5 <- read.table("K5/run6/genotype_r6.5.Q")

#png("Plot6_K5_v2_r6.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()
#qmatrix5 <- read.table("K5/run7/genotype_r7.5.Q")

#png("Plot6_K5_v2_r7.png", width = 12, height = 9, units = 'in', res = 600)
#maps(matrix = qmatrix5, coord, grid, constraints, method = "max",
#          main = " ", xlab = "Longitude", ylab = "Latitude", cex = .5)
#map(add = T, interior = F)
#dev.off()

