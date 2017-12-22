#!/usr/bin/Rscript
#QR - 22-12-17

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

data <- ("01.data/data.snapp")
coords <- ("01.data/coords_file.csv")

coord<-read.csv("01.data/coords_file.csv",header=T)
colnames(coord)<-c("pop","longitude","latitude","region")

region <- list( unique(coord$region))

ploidy <- 2

raw.data <- load.data.snapp(data,
                            coords,
                            sep=',', ploidy=ploidy)                                

pop <- make.pop(raw.data, ploidy)
psi <- get.all.psi(pop)

res <- run.regions(region=region, pop=pop, psi=psi, xlen=10,ylen=20)
