#!/usr/bin/Rscript

#script to write the list of SNPs value into a single square matrix and to perform heatmap and clustering

argv <- commandArgs(T)

tablefst <- argv[1]    #a 3 colomns dataset with pop1, pop2, fst as colomns
pop_map  <- argv[2]    #list des noms des pops, will be used as labels

data = read.table(tablefst)
pop_map = as.vector(read.table(pop_map))

mat_correlation = as.data.frame(matrix(999,nrow(pop_map),nrow(pop_map)))

colnames(mat_correlation) = pop_map[,1]
rownames(mat_correlation) = pop_map[,1]

# buid the fst correlation matrix
print("building the fst correlation matrix...")
for (i in 1:length(data[,1])){
  mat_correlation[data[i,1],data[i,2]] = data[i,3]   
  mat_correlation[data[i,2],data[i,1]] = data[i,3]
  for (colonne in 1:ncol(mat_correlation)){
    for (ligne in 1:nrow(mat_correlation)){
      if (colonne == ligne){
        mat_correlation[colonne,ligne] = 0
      }
    }
  }
  mat_correlation = round(mat_correlation, digits = 5)  
}  


write.table(mat_correlation, "table_pairwise_fst.reshaped.txt", quote=F)

####################### heatmap ################################################
heat.1 <- data
colnames(heat.1) <-  c("pop1","pop2","fst")

# Download libraries
if("ggplot2" %in% rownames(installed.packages()) == FALSE) {install.packages("ggplot2"), repos = https://cloud.r-project.org }
if("ggdendro" %in% rownames(installed.packages()) == FALSE) {install.packages("ggdendro"), repos = https://cloud.r-project.org }
if("gridExtra" %in% rownames(installed.packages()) == FALSE) {install.packages("gridExtra"), repos = https://cloud.r-project.org }

library(ggplot2)
library(ggdendro)
library(gridExtra) #used for arranging the pdf

#a simple plot with line from :https://learnr.wordpress.com/2010/01/26/ggplot2-quick-heatmap-plotting/)
(p <- ggplot(heat.1, aes(pop1, pop2)) + geom_tile(aes(fill = fst),
     colour = "white") + scale_fill_gradient(low = "white",
     high = "steelblue"))

fst <-substitute( paste( italic(F[ST]) ) )

base_size <- 9
plot.1 <-p + theme_grey(base_size = base_size) + labs(x = "",
     y = "") + scale_x_discrete(expand = c(0, 0)) +
     scale_y_discrete(expand = c(0, 0)) +
      theme(legend.position = "bottom",
      axis.text.x = element_text(size = base_size *
         0.8, angle = 330, hjust = 0, colour = "grey50")) + 
         labs(fill = fst)
pdf("heatmap_v1.pdf",width=7,height=7)
plot.1
dev.off()

#clustering:
colnames(mat_correlation) = pop_map[,1]
rownames(mat_correlation) = pop_map[,1]

heat <- mat_correlation 
rownames (heat)<- colnames(heat) ##add population name in rownames:
hc= hclust(dist(heat))
plot.0 = ggdendrogram(hc, theme_dendro=F, color= "black", size=6)+
theme(axis.text.y=element_blank(), axis.text.x= element_text(size=8,family="Helvetica",face="bold", color="grey50"), panel.background=element_blank(),
      axis.ticks=element_blank(), axis.title.y=element_blank(), axis.title.x=element_blank() ,
     )

pdf("heatmap_clustering.pdf",width=7,height=7)
gp1<-ggplotGrob(plot.0)
plot.1
gp2<-ggplotGrob(plot.1)
maxWidth = grid::unit.pmax(gp1$widths[1:5], gp2$widths[1:5])
gp1$widths[1:5] <- as.list(maxWidth)
gp2$widths[1:5] <- as.list(maxWidth)
final=grid.arrange(gp1, gp2, heights=c(1.5/5,3.5/5), ncol=1)
dev.off()
