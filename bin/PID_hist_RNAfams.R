setwd("~/Documents")


data1<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00001.alipid.pidcounts",header=FALSE,sep='') 
data5<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00005.alipid.pidcounts",header=FALSE,sep='') 
data10<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00010.alipid.pidcounts",header=FALSE,sep='') 
data11<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00011.alipid.pidcounts",header=FALSE,sep='') 
data13<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00013.alipid.pidcounts",header=FALSE,sep='') 
data23<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00023.alipid.pidcounts",header=FALSE,sep='') 
data169<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00169.alipid.pidcounts",header=FALSE,sep='') 
data177<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF00177.alipid.pidcounts",header=FALSE,sep='') 
data1854<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined.RF01854.alipid.pidcounts",header=FALSE,sep='') 

cs1<-colSums(data1)
p1<-data1$V1/cs1[1]*100 #think the percentages are sorted now
ndata1<-data.frame(data1$V2,p1) 

cs5<-colSums(data5)
p5<-data5$V1/cs5[1]*100 #think the percentages are sorted now
ndata5<-data.frame(data5$V2,p5) 

cs10<-colSums(data10)
p10<-data10$V1/cs10[1]*100 #think the percentages are sorted now
ndata10<-data.frame(data10$V2,p10) 

cs11<-colSums(data11)
p11<-data11$V1/cs11[1]*100 #think the percentages are sorted now
ndata11<-data.frame(data11$V2,p11) 

cs13<-colSums(data13)
p13<-data13$V1/cs13[1]*100 #think the percentages are sorted now
ndata13<-data.frame(data13$V2,p13) 

cs23<-colSums(data23)
p23<-data23$V1/cs23[1]*100 #think the percentages are sorted now
ndata23<-data.frame(data23$V2,p23) 

cs169<-colSums(data169)
p169<-data169$V1/cs169[1]*100 #think the percentages are sorted now
ndata169<-data.frame(data169$V2,p169) 

cs177<-colSums(data177)
p177<-data177$V1/cs177[1]*100 #think the percentages are sorted now
ndata177<-data.frame(data177$V2,p177) 

cs1854<-colSums(data1854)
p1854<-data1854$V1/cs1854[1]*100 #think the percentages are sorted now
ndata1854<-data.frame(data1854$V2,p1854) 







pdf("RNA_fams_PIDS.pdf")

par(mfrow=c(3,1))

plot(data1$V2,data1$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00001 - 5S \n ~120 Nucleotides Long",col="red")
plot(data5$V2,data5$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00005 - tRNA \n ~76-90 Nucleotides Long",col="red")
plot(data10$V2,data10$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00010 - RNaseP Class A \n ~350 Nucleotides Long",col="red")
plot(data11$V2,data11$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00011 - RNaseP Class B\n ~350-600 Nucleotides Long",col="red")
plot(data13$V2,data13$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00013 - 6S \n ~184 Nucleotides Long",col="red")
plot(data23$V2,data23$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00023 - tmRNA \n ~350 Nucleotides Long",col="red")
plot(data169$V2,data169$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00169 - Small SRP \n ~100 Nucleotides Long",col="red")
plot(data177$V2,data177$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF00177 16srRNA \n ~1542 Nucleotides Long",col="red")
plot(data1854$V2,data1854$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "RF01854 - Large SRP \n ~250 Nucleotides Long",col="red")


plot(ndata1, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00001 - 5S \n ~120 Nucleotides Long",col="darkred") 
plot(ndata5, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00005 - tRNA \n ~76-90 Nucleotides Long",col="darkred")
plot(ndata10, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00010 - RNaseP Class A \n ~350 Nucleotides Long",col="darkred")
plot(ndata11, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00011 - RNaseP Class B\n ~350-600 Nucleotides Long",col="darkred")
plot(ndata13, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00013 - 6S \n ~184 Nucleotides Long",col="darkred")
plot(ndata23, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00023 - tmRNA \n ~350 Nucleotides Long",col="darkred")
plot(ndata169, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00169 - Small SRP \n ~100 Nucleotides Long",col="darkred")
plot(ndata177, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF00177 16srRNA \n ~1542 Nucleotides Long",col="darkred")
plot(ndata1854, xlab="Percent Identity (PID%)", ylab="% of pairs from the dataset",main = "RF01854 - Large SRP \n ~250 Nucleotides Long",col="darkred")


dev.off()

