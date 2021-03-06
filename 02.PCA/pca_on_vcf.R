#!/usr/bin/env Rscript

#DATE: 10-05-18
#PURPOSE: script to perform PCA on vcffiles
#AUTHOR: Q. Rougemont
#INPUT: vcf file (compressed or not) , strata file in the form "ind"\t"pop"

argv <- commandArgs(T)

if (argv[1]=="-h" || length(argv)==0){
cat("run as:\n./pca_on_vcf.R vcf_file \n" )
}else{

vcf <- argv[1] #vcf_file

## common checks
if("dplyr" %in% rownames(installed.packages()) == FALSE)
{install.packages("dplyr", repos="https://cloud.r-project.org") }
if("vcfR" %in% rownames(installed.packages()) == FALSE)
{install.packages("vcfR", repos="https://cloud.r-project.org") }
if("ade4" %in% rownames(installed.packages()) == FALSE)
{install.packages("ade4", repos="https://cloud.r-project.org") }
if("adegenet" %in% rownames(installed.packages()) == FALSE)
{install.packages("adegenet", repos="https://cloud.r-project.org") }
if("factoextra" %in% rownames(installed.packages()) == FALSE)
{install.packages("factoextra", repos="https://cloud.r-project.org") }
if("vegan" %in% rownames(installed.packages()) == FALSE)
{install.packages("vegan", repos="https://cloud.r-project.org") }
if("ggsci" %in% rownames(installed.packages()) == FALSE)
{install.packages("ggsci", repos="https://cloud.r-project.org") }

## load libs
libs <- c('dplyr','vcfR','ade4','adegenet', 'factoextra', 'vegan', 'ggsci')
invisible(lapply(libs, library, character.only = TRUE))

## load and transform data
strata <- read.table("strata.txt",h=T, sep = "\t")
#change colnames in case they are not set appropriately
colnames(strata) <- c("IND","POP")


vcf<-read.vcfR(vcf, verbose=F)
genpop <- vcfR2genind(vcf)
X <- scaleGen(genpop, NA.method=c("mean")) #imputation

## perform the PCA
pca1 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=20)

## singificance of axis
eig.val <- get_eigenvalue(pca1) #first we get the eigen value in
                                #an easy form
eig.val$eig <- eig.val$variance.percent/100 #percent
expected <- bstick(length(eig.val$eig) )
signif <- eig.val$eig > expected #get signifcicant axis
# using this we can choose a number of axis1
#head signif

## look at eigen vals:
pdf(file="eigen_value.pca.salmon.pdf")
barplot(pca1$eig[1:50],main="PCA eigenvalues", col=heat.colors(50))
dev.off()

############################################################################
##the most basic and awfull plot
pdf(file="pca.li.pdf")
s.label(pca1$li,xax=1, yax=2)
title("PCA full salmon\naxes 1-2")
add.scatter.eig(pca1$eig[1:20], 3,1,2)
dev.off()

####### Save a few stuff of interest ########################################
#sauvegarde des %d'inertie capturée etc
inertie<-inertia.dudi(pca1, row.inertia = TRUE, col.inertia = TRUE)
sink("pca.inertie.25.10.txt")
print(inertie)
sink()

res.var <- get_pca_var(pca1)
sink("coord.txt")
print(res.var$coord)
sink()

res.ind <- get_pca_ind(pca1)
sink("coord.ind.txt")
print(res.ind$coord)
sink()

#eigen value to file:
sink("res.eigen.txt")
print(eig.val)
sink()

#### NICE PLOT ###############
p <- fviz_pca_ind(pca1, label="none", habillage=strata$POP,
                  addEllipses=TRUE, ellipse.level=0.95)
p <- p + scale_color_brewer(palette="Dark2") +
  theme_minimal()

pdf(file="pca_from_vcffile.pdf")
p
dev.off()

#### change display:
#### Si moins de 20 grps:
p <- fviz_pca_ind(pca1,axes = c(1,2), label="none", 
    habillage=strata$POP,
    addEllipses=F, ellipse.level=0.95)
p <- p + scale_color_igv() + theme_minimal()
pdf(file="pca_from_vcffile_axe12_v2.pdf")
p
dev.off()

#### with text:

p <- fviz_pca_ind(pca1, label="none", pointsize = 0.0) +
    geom_text(aes(label=strata$POP, 
        colour=factor(strata$POP)),
        size = 2 )
p <- p + scale_color_igv() + theme_minimal()
pdf(file="pca_from_vcffile_v9.pdf")
p
dev.off()

#without prior on pop:
pdf(file="pca.full.1_2.pdf", 12,12)
colorplot(pca1$li[c(1,2)],
    pca1$li,
    transp=TRUE,
    cex=3,
    xlab="PC 1",
    ylab="PC 2")
abline(v=0,h=0,col="grey", lty=2)
dev.off()

}
