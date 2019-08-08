

#extracting very basic stats with hierfstats
#input file => hierstat input file

if("hierfstat" %in% rownames(installed.packages()) == FALSE)
	{install.packages("hierfstat", repos="https://cloud.r-project.org") }

library(hierfstat)

data = read.table("hierfstat.data.txt", header=T, sep="\t")

#basic_stats
stats <- basic.stats(data, diploid=TRUE)
write.table(stats$perloc,"hierfstat.diversity.index.",quote=F,row.names=T,col.names=T)
write.table(stats$Ho, "hierfstat.ho",quote=F,row.names=T,col.names = T)
write.table(stats$Hs, "hierfstat.hs",quote=F,row.names=T,col.names = T)
write.table(stats$Fist,"hierfstats.fis",quote=F, row.names=T, col.names=T)
write.table(stats$overall,"hierfstats.overall",quote=F,row.names=T,col.names=T)

#fst and p-value
x<-boot.ppfst(data, nboot=1000, quant=c(0.025,0.975), diploid=TRUE)

write.table(x$ul,"fst.upper_limit", quote=F,col.names=F, row.names=F)
write.table(x$ll,"fst.lower_limit", quote=F,col.names=F, row.names=F)

wcfst<-pairwise.WCfst(data,diploid=TRUE)
write.table(wcfst,"pairwise.WC.fst", quote=F,row.names=F,col.names=F)

#run beta 
beta1 <- betas(data, nboot=100)
write.table(t(rbind(beta1$betaiovl,beta1$ci)),"beta_iovl_ci", col.names=c("beta","2.5%","97.5%"), row.names=T)

#individual ancestry coeff
ind.coan<-betas(cbind(1:nrow(data),data[,-1]),betaij=T)
image(1:nrow(data),1:nrow(data),ind.coan,xlab="Inds",ylab="Inds")
write.table(ind.coan, "ind.coan", quote=F)
#extracting individual inbreeding coefficients
ind.inb<-(diag(ind.coan)*2-1)
hist(ind.inb,breaks=seq(-1,1,0.05),xlab="Individual inbreeding coeeficients");abline(v=c(0,0.3,0.7),col="red",lwd=2)

pdf(file="hist")
hist(ind.inb,breaks=seq(-1,1,0.05),xlab="Individual inbreeding coeeficients");abline(v=c(0,0.3,0.7),col="red",lwd=2)
dev.off()

#extracting var comp glob
#levels = data.frame(data$pop)
#loci = data[,2:ncol(data)]
#res = varcomp.glob(levels=levels, loci=loci, diploid=T)
#print(res$loc)
#print(res$F)

