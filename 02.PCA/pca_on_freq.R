
#DATE: 10-05-18 
#PURPOSE: script to perform PCA on frequency files
#AUTHOR: Q. Rougemont
#INPUT: compressed strata.frq file as obtained after running plink 

## common checks
if("dplyr" %in% rownames(installed.packages()) == FALSE)
{install.packages("dplyr", repos="https://cloud.r-project.org") }
if("reshape" %in% rownames(installed.packages()) == FALSE)
{install.packages("reshape", repos="https://cloud.r-project.org") }
if("ade4" %in% rownames(installed.packages()) == FALSE)
{install.packages("ade4", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
{install.packages("data.table", repos="https://cloud.r-project.org") }
if("factoextra" %in% rownames(installed.packages()) == FALSE)
{install.packages("factoextra", repos="https://cloud.r-project.org") }

## load libs
libs <- c('dplyr','resphape','ade4','data.table', 'factoextra')
invisible(lapply(libs, library, character.only = TRUE))

freq <- fread("zcat plink.frq.strat.gz")
freq2 <- dplyr::select(freq,SNP,CLST,MAF) 
freq3 <- reshape2::dcast(freq2,SNP~CLST)
freq3 <- freq3[,-1] 
freq4 <- t(freq3)
pop <- unique(freq$CLST)   
pop <- data.frame(pop)
#reg <- read.table("strata.txt")
#region <- unique(reg)

pca1 <- dudi.pca(freq4,scale=FALSE,scannf=FALSE)

p <- fviz_pca_ind(pca1, label="none", habillage=pop$pop)
#p <- fviz_pca_ind(pca1, label="none", habillage=region)

pdf(file="pca_on_freq_BC_with_CU.pdf")
p
dev.off()

p <- fviz_pca_ind(pca1, 
    label="none", 
    habillage=cu2$CU,
    addEllipses=TRUE, 
    ellipse.level=0.95)
p <- p + scale_color_brewer(palette="Dark2") +
     theme_minimal()

pdf(file="pca_on_freq_with_ellipses2.pdf")
p
dev.off()

#see more in script pca_on_vcf.R
