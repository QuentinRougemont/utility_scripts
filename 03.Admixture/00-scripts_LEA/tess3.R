library(tess3r)  
library(mapplots)

z <- read.table("pop_ind_region_latitute.txt")        
coords <- z[,c(3,4)]
genotype <- read.table("filtered_m6_p60_x0_S5_whitelist_2019-11-02.singleton.unlinked.recode.lfmm")

#works also with lfmm file with 9 replaced by NA
tess3.obj <- tess3(X = genotype, coord = as.matrix(coords), K = 1:100, 
                   method = "projected.ls", ploidy = 2, openMP.core.num = 10) 

#plot the corss entropy :
pdf(file="cv.pdf")                                  
plot(tess3.obj, pch = 19, col = "blue",             
     xlab = "Number of ancestral populations",      
     ylab = "Cross-validation score")               
dev.off()                                           

#save data to work on my laptop since raster is not supported
saveRDS(tess3.obj, file = "my_data.rds")
quit()
exit
#then on my laptop:
tess3.obj <- readRDS(file = "my_data.rds")

q.matrix <- qmatrix(tess3.obj, K = 5)
write.table(cbind(ind_geo[,c(1,2,5)],q.matrix),"qmatrix_K5", row.names=F,col.names=F, quote=F)
q.matrix <- qmatrix(tess3.obj, K = 4)
write.table(cbind(ind_geo[,c(1,2,5)],q.matrix),"qmatrix_K4", row.names=F,col.names=F, quote=F)

q.matrix <- qmatrix(tess3.obj, K = 2)
q.matrix <- qmatrix(tess3.obj, K = 3)
write.table(cbind(ind_geo[,c(1,2,5)],q.matrix),"qmatrix_K3", row.names=F,col.names=F, quote=F)

#do some spatial interpolation:
my.colors <- c("tomato",  "lightblue")
my.palette <- CreatePalette(my.colors, 9)
pdf(file="spatial_interpolK2.pdf")
plot(q.matrix, as.matrix(coords), method = "map.max", interpol = FieldsKrigModel(10),  
     main = "Ancestry coefficients",
     xlab = "Longitude", ylab = "Latitude", 
     resolution = c(300,300), cex = .4, 
     col.palette = my.palette)
dev.off()
#write.table(cbind(ind_geo,q.matrix),"qmatrix_K5", row.names=F,col.names=F, quote=F)

my.colors <- c("tomato", "orange", "lightblue")
my.palette <- CreatePalette(my.colors, 9)
pdf(file="spatial_interpolK3.pdf")
plot(q.matrix, as.matrix(coords), method = "map.max", interpol = FieldsKrigModel(10),  
     main = "Ancestry coefficients",
     xlab = "Longitude", ylab = "Latitude", 
     resolution = c(300,300), cex = .4, 
     col.palette = my.palette)
dev.off()
#K4
my.colors <- c("tomato", "orange", "lightblue", "wheat")
my.palette <- CreatePalette(my.colors, 9)
pdf(file="spatial_interpolK4.pdf")
plot(q.matrix, as.matrix(coords), method = "map.max", interpol = FieldsKrigModel(10),  
     main = "Ancestry coefficients",
     xlab = "Longitude", ylab = "Latitude", 
     resolution = c(300,300), cex = .4, 
     col.palette = my.palette)
dev.off()
#K5
my.colors <- c("tomato", "orange", "lightblue", "wheat","olivedrab")
my.palette <- CreatePalette(my.colors, 9)
pdf(file="spatial_interpolK5.pdf")
plot(q.matrix, as.matrix(coords), method = "map.max", interpol = FieldsKrigModel(10),  
     main = "Ancestry coefficients",
     xlab = "Longitude", ylab = "Latitude", 
     resolution = c(300,300), cex = .4, 
     col.palette = my.palette)
dev.off()

### Spatial interpolation for K6
my.colors <- c("tomato", "orange", "lightblue", "wheat","olivedrab","darkgrey")
my.palette <- CreatePalette(my.colors, 9)
q.matrix <- qmatrix(tess3.obj, K = 6)
write.table(cbind(ind_geo[,c(1,2,5)],q.matrix),"qmatrix_K6", row.names=F,col.names=F, quote=F)

pdf(file="spatial_interpolK6.pdf")
plot(q.matrix, as.matrix(coords), method = "map.max", interpol = FieldsKrigModel(10),  
     main = "Ancestry coefficients",
     xlab = "Longitude", ylab = "Latitude", 
     resolution = c(300,300), cex = .4, 
     col.palette = my.palette)
dev.off()

#do some pie chart plots instead
#reshape data                                                                                           
K = ncol(q.matrix)                                                                                       
Npop <-  length(unique(ind_geo$V1))                                                                            
coord.pop <- unique(coords)                                                                              
pop <- ind_geo$V1

pop <- as.data.frame(pop)

tmp1<- mapply(rowsum, as.data.frame(q.matrix), as.data.frame(pop))  
dimnames(tmp1)<- list(levels(factor(pop[,1]))) #, 1:nrow(samp.siz.1[,c(1)]))                         
tmp <-as.matrix(table(pop) )
tmp <- matrix(rep(tmp[,1],K),ncol=K,byrow=F)
#tmp=rep(cbind(tmp),K)                                                                       
qpop<-tmp1/tmp                                                                                          

#perform plot                                                                                           
pdf(file=paste("admixture.proportion.K",K,"best_run.pdf",sep="") ,22 , 10 )                             
plot(coords, xlab = "Longitude", ylab = "Latitude", type = "n", main= paste("Admixture proportions accros
 Coho salmon native range K=" , K ,sep=" ") )                                                           
map(add = T, col = "grey90", fill = TRUE)                                                               

for (i in 1:Npop){                                                                                      
  add.pie(z = qpop[i,], x = coord.pop[i,1], y = coord.pop[i,2], labels = "",radius=0.45,                  
          col = c(rainbow(K) ) ) } #,"red","darkgreen","yellow"))}                                                
dev.off()                                                                                               

# 
