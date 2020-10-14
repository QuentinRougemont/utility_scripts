
#DATE: 20-10-20 
#PURPOSE: script to perform MDS plot
#AUTHOR: Q. Rougemont
#INPUT: compressed ibs file from plink 

## common checks
if("ggplot2" %in% rownames(installed.packages()) == FALSE)
{install.packages("dplyr", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
{install.packages("data.table", repos="https://cloud.r-project.org") }
if("magrittr" %in% rownames(installed.packages()) == FALSE)
{install.packages("factoextra", repos="https://cloud.r-project.org") }

## load libs
libs <- c('ggplot2','data.table', 'magrittr')
invisible(lapply(libs, library, character.only = TRUE))
#library(viridis)
#library(ggsci)

argv <- commandArgs(T)

strata <- argv[1] 

mds = fread("zcat mds_to_plot.mds.gz")
strata <- read.table(strata)  %>% set_colnames(., c("POP","IND","REGION"))

#correct areas:
mds$color <- ifelse(strata$REGION == 'Thompson', 'springgreen4',
                      'black')

#Full data
p <- ggplot(mds) + 
  geom_point(aes(x=C1, y=C2 , color=color), alpha =0.2) + #plot les points noirs
  scale_color_identity() + #add la couleur suivant le dataset
  theme_bw()

pdf(file="mds_point.pdf",12,12)
p
dev.off()

p <- ggplot(mds, aes(x=C1, y=C2, label=FID )) + 
  geom_text(check_overlap = TRUE, 
      aes(colour=factor(FID)),
      size = 3 ) + 
  theme_bw()
  
pdf(file="mds_nooveralp2.pdf",12,12)
p
dev.off()

p <- ggplot(mds, aes(x=C1, y=C2, label=FID )) + 
  geom_text( 
      aes(colour=factor(FID)),
      size = 3 ) + 
  scale_color_igv() +
  theme_bw()
  
pdf(file="mds_color.pdf",12,12)
p
dev.off()
