
#DATE: 10-05-18 
#PURPOSE: script to perform PCA on vcffiles
#AUTHOR: Q. Rougemont
#INPUT: vcf file (compressed or not) , strata file

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

## load libs
libs <- c('dplyr','vcfR','ade4','adegenet', 'factoextra')
invisible(lapply(libs, library, character.only = TRUE))

## load and transform data
strata <- read.table("strata.txt",h=T, sep = "\t")                                                                                                                                                                   
vcf<-read.vcfR(vcf, verbose=F)                                                                                                                                                                                     
genpop <- vcfR2genind(vcf)   
X <- scaleGen(genpop, NA.method=c("mean")) #imputation                                                                                                                                                

## perform the PCA
pca1 <- dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=20)                                                                                                                                                      

## singificance of axis
eig.val <- get_eigenvalue(pca1) #first we get the eigen value in an easy form
eig.val$eig <- eig.val$variance.percent/100 #percent
expected <- bstick(length(eig.val$eig) ) 
signif <- eig.val$eig > expected #get signifcicant axis
# using this we can choose a number of axis1 

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
p <- fviz_pca_ind(pca1, label="none", habillage=strata$REG,
                  addEllipses=TRUE, ellipse.level=0.95)
p <- p + scale_color_brewer(palette="Dark2") +
  theme_minimal()

pdf(file="pca_from_vcffile.pdf")
p
dev.off()
