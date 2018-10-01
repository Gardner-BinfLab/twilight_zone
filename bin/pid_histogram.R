setwd("~/Documents")

data2<-read.csv("pid_distribution_nuc.tsv",header=FALSE,sep='') 
data1<-read.csv("pid_distribution_ncRNA.tsv",header=FALSE,sep='') 
data<-read.csv("pid_distribution_aaseq.tsv",header=FALSE,sep='') 



collsum<-colSums(data1)
percentages<-data1$V1/collsum[1]*100 #think the percentages are sorted now
newdatam<-data.frame(data1$V2,percentages) 

collsum2<-colSums(data)
perc<-data$V1/collsum2[1]*100
newstam<-data.frame(data$V2,perc)


collsum1<-colSums(data2)
perc1<-data2$V1/collsum1[1]*100
newndata<-data.frame(data2$V2,perc1)



par(mfrow=c(1,3))

plot(data1$V2,data1$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset",main = "ncRNA",col="red")
plot(data$V2,data$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset", main = "AA",col="blue")
plot(data2$V2,data2$V1, xlab="Percent Identity (PID%)", ylab="Number of pairs from the dataset", main= "mRNA",col="purple")

plot(newdatam$data1.V2,newdatam$percentages, xlab="Percent Identity (PID%)", ylab="Percentage of pairs from the dataset", main = "Non-coding RNA",  cex=1, col="red")

plot(newstam$data.V2,newstam$perc, xlab="Percent Identity (PID%)", ylab="Percentage of pairs from the dataset", main = "Amino acid",  cex=1, col="blue")


plot(newndata$data2.V2,newndata$perc1, xlab="Percent Identity (PID%)", ylab="Percentage of pairs from the dataset", main = "mRNA",  cex=1, col="purple")

