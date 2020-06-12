#purpose = "Compute basic stats"
#date    = "14/04/2017"
#authors =  "Quentin Rougemont"
#output  = "file of summary statistics"

library(pegas)

argv  <- commandArgs(TRUE)

if (argv[1]=="-h" || length(argv)==0){
        cat("\n 8 parameter needed!! \n  
	(1) pop1 (genotype data for pop1) \n" )
}else{
pop1  <- argv[1]
}

# Read Data
# On file by population composed of allele size in bp.
# loci in columns
# gene copies (gene copies = 2 * number of individuals) in rows
#first colom contain pop name
data_pop <- read.table(pop1)
data_pop1 <- data_pop[,-1]
#remove missing data
for (i in 1:length(data_pop1)){
data_pop1[which(data_pop1[,i]==0),i]<-NA
  }
number_of_loci <- dim(data_pop1)[2]
nloc=ncol(data_pop1) #équivalent 

sample_size_pop1 <- array(NA,number_of_loci)
for (i in 1:number_of_loci){
  sample_size_pop1[i]                  <- length(which(!is.na(data_pop1[,i])))
  data_pop1[which(data_pop1[,i]==0),i] <- NA
}

min.n.pop1 = min(sample_size_pop1) #for Ar computations
# Calculate statistics for the population
write.table( cbind( "mean_H",  
                    "mean_He", 
                    "mean_A",  
                    "mean_Ar", 
                    "mean_V",  
                    "mean_R",  
                    "mean_GW", 
                    "mean_P",  
                    "mean_HV",
                    "mean_Fis" 
),
file=paste("mean_sumstats",pop1, ".txt",sep="."),
quote=F,col.names=F,row.names=F,append=F)

write.table( cbind( "H_loc",    # "var_H_loc",
                    "He_loc",   # "var_He_loc",
                    "A_loc",    # "var_A_loc",
                    "Ar_loc",   # "var_Ar_loc",
                    "V_loc",    # "var_V_loc",
                    "R_loc",    # "var_R_loc",
                    "GW_loc",   # "var_GW_loc",
                    "P_loc",     #"var_P_loc", 
                    "HV_loc",
                    "Fis_loc"    #"var_HV_loc"#,
),
file=paste("locus_sumstats",pop1, ".txt",sep="."),
quote=F,col.names=F,row.names=F,append=F)

H_pop   <- array(NA,number_of_loci)
He_pop  <- array(NA,number_of_loci)
A_pop  <- array(NA,number_of_loci)
Ar_pop   <- array(NA,number_of_loci)
V_pop    <- array(NA,number_of_loci)
R_pop    <- array(NA,number_of_loci)
GW_pop   <- array(NA,number_of_loci)
P_pop    <- array(F ,number_of_loci)
HV_pop   <- array(NA,number_of_loci)
Fis_pop  <- array(NA,number_of_loci)
n_pop=array(NA,number_of_loci)
Hs_pop=array(NA,number_of_loci)
Fis2_pop=array(NA,number_of_loci)

He <- function(x)
{
    He <-1-sum( (table(x)/sum(table(x), na.rm=T))^2)
    return(He)
}
A <- function(x)
{
	A <- length(levels(x))
	return(A)
}

Ar <- function(x,y,z) #y = sample_size
{
	Ar <-sum(1 - choose(x-table(y),z)/choose(x,z))
	return(Ar)
}    
V <- function(x) #y = sample_size
{
	V <- var(x)
	return(V)
}    
R <- function(x) #y = sample_size
{
	R <- max(x)-min(x)
	return(R)
}    
GW <- function(x) #y = sample_size
{
	GW <-A(x)/(R(x) +1)
	return(GW)
}    
HV <- function(x) #y = sample_size
{
	HV <- H(x)/V(x)
	return(HV)
} 
Fis <- function(x) #y = sample_size
{
	Fis <-1-H(x)/He(x)
	return(Fis)
} 

for (locus in 1:number_of_loci){
  H_pop[locus]  <- H(as.factor(data_pop1[,locus])) # 
  He_pop[locus]  <- He(as.factor(data_pop[,locus])) # 
  n_pop[locus] <- length(which(!is.na(data_pop1[,locus])))
  Hs_pop[locus] <- 1 - sum((table(as.factor(data_pop1[,locus]))/sum(table(as.factor(data_pop1[,locus])),na.rm=T))^2) - H_pop[locus]/2/n_pop[locus]
  Hs_pop[locus] <- n_pop[locus]/(n_pop[locus]-1)*Hs_pop[locus]
  A_pop[locus]  <- A(as.factor(data_pop1[,locus])) #
  #Ar_pop[locus] <-sum(1-choose(sample_size_pop1[locus]-table(as.factor(data_pop[,locus])),min.n.pop1)/choose(sample_size_pop1[locus],min.n.pop1)) #
  Ar_pop[locus] <-Ar(sample_size_pop1[locus], as.factor(data_pop1[,locus]), min.n.pop1)#
  V_pop[locus]  <- V(data_pop1[,locus]) #
  R_pop[locus]  <- R(data_pop1[,locus]) #
  GW_pop[locus]  <- GW(data_pop1[,locus]) #
  if (A_pop[locus]>1)  P_pop[locus]  <- T #
  HV_pop[locus]  <- HV(data_pop1[,locus]) # 
  Fis_pop[locus] <- Fis(as.factor(data_pop1[,locus])) #1-(H_pop[locus]/He_pop[locus])
  Fis2_pop[locus] <- 1-(H_pop[locus]/Hs_pop[locus])
}

for (stat in c("H","He","A","Ar","R","GW","A","V","HV","P","Fis","Fis2")){   #"A","V","HV","P"
  for (subsample in c("pop" )) { #,"pop2","pop3","total")){
    assign(paste("mean",stat,subsample,sep="_"),mean(get(paste(stat,subsample,sep="_")),na.rm=T))
    assign(paste( "var",stat,subsample,sep="_"), var(get(paste(stat,subsample,sep="_")),na.rm=T))
  }
}

write.table( cbind( round(mean_H_pop,3), 
                    round(mean_He_pop,3),
                    round(mean_A_pop,3), 
                    round(mean_Ar_pop,3),
                    round(mean_V_pop,3), 
                    round(mean_R_pop,3), 
                    round(mean_GW_pop,3),
                    round(mean_P_pop,3), 
                    round(mean_HV_pop,3),
                    round(Fis_pop,3) 
),
file=paste("mean_sumstats",pop1, ".txt",sep="."),
quote=F,col.names=F,row.names=F,append=T)

loci_names  <- rep(paste("loc",seq(1,length(H_pop)),sep="."))

write.table( cbind( round(H_pop,3), 
                    round(He_pop,3),
                    round(A_pop,3), 
                    round(Ar_pop,3),
                    round(V_pop,3), 
                    round(R_pop,3), 
                    round(GW_pop,3),
                    round(P_pop,3), 
                    round(HV_pop,3),
                    round(Fis_pop,3)
),
file=paste("locus_sumstats",pop1, ".txt",sep="."),
quote=F,col.names=F,row.names=loci_names,append=T)

#cat("empirical statistics succesfully computed " )
