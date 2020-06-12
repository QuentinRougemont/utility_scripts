if("hierfstat" %in% rownames(installed.packages()) == FALSE)
        {install.packages("hierfstat", repos="https://cloud.r-project.org") }

library(hierfstat)

data = read.table("hierfstat.data.txt", header=T, sep="\t") #obtained using 00.vcf_to_hierfstat.sh

#run beta 
beta1 <- betas(data, nboot=100)
write.table(t(rbind(beta1$betaiovl,beta1$ci)),"beta_iovl_ci", col.names=c("beta","2.5%","97.5%"), row.names=T)

