

#plot very simple tree from Fst based results

library(ape)
library(phytools)
library(stats)


tablefst <- argv[1]    #a 3 colomns dataset with pop1, pop2, fst as colomns
pop_map  <- argv[2]    #list des noms des pops, will be used as labels

tablefst <- "pairwise.fst.tx"
pop_map = "strata.txt"

data = read.table(tablefst, h = T)
pop_map = as.vector(read.table(pop_map))
pop_map = data.frame(unique(pop_map[,2]))

mat_correlation = as.data.frame(matrix(999,nrow(pop_map),nrow(pop_map)) )

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

fst.matrix <- as.matrix(mat_correlation)


## create a tree ##
root.tree <- as.phylo(hclust(dist(fst.matrix), method = "average"))
bootstrap.value <- boot.phylo(
	phy = root.tree, 
	x = fst.matrix, 
	FUN = function(xx) as.phylo(hclust(dist(xx), method = "average")) , 
	block = 1, 
	B = 10000, 
	trees = FALSE, 
	rooted = TRUE)
	 
bootstrap.value <- round((bootstrap.value/10000)*100, 0)
bootstrap.value
root.tree$node.label <- bootstrap.value

write.tree(tree, "fst.tree")
#tr = read.tree("fst.tree")

pdf(file = "test.pdf", width = 7, height = 7) #, dpi = 600)
plotTree(root.tree)
dev.off()

