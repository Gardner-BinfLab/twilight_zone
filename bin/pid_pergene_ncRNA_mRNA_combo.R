#opening and storing all the required files

setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/hmmalign_output")
#do the protein stuff - single & combined + totals
#.1alipidnuc.counts
#all_mcRNA_pid.counts

mRNAtot<-read.csv("all_mRNA_pid.counts",header=FALSE, sep='')
#####ALL THE SINGLES NEXT

setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output")
#do the ncRNA stuff - single and combined + totals
#.1alipid.counts
#all_ncRNA_pid.counts
ncRNAtot<-read.csv("all_ncRNA_pid.counts",header=FALSE, sep='')
###ALL THE SINGLES NEXT


setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences")
#do the overall combo stuff - stacked mRNA/ncRNA, per gene and totals
RNAtot<-read.csv("all_mRNA_ncRNA_pid.counts",header=FALSE, sep='')

pdf(file="~/Documents/pid_breakdown_ncRNA_mRNA_combo_september.pdf")

par(mfrow=c(3,1))
#-----------------------------------------------__________------------------------------_____________________-------__________________-----------------#

##MRNA total STUFF
plot(mRNAtot$V2,mRNAtot$V1, main = "mRNA", xlab="PID %", ylab="Number of pairs per PID",pch=20,cex=0.5)

totalmRNApairs=sum(mRNAtot$V1)
totalcomboPIDmRNA=sum(mRNAtot$V1*mRNAtot$V2)
meanPIDmRNA=totalcomboPIDmRNA/totalmRNApairs
comboPIDmRNA<-mRNAtot$V1*mRNAtot$V2
modeIndexmRNA<-which.max(comboPIDmRNA)
modePIDmRNA<-mRNAtot$V2[modeIndexmRNA]

abline(v=meanPIDmRNA, col="blue")
abline(v=modePIDmRNA, col="green")
#-----------------------------------------------__________------------------------------_____________________-------__________________-----------------#
#ncRNA total stuff
plot(ncRNAtot$V2,ncRNAtot$V1, main = "ncRNA", xlab="PID %", ylab="Number of pairs per PID",pch=20,cex=0.5)

totalncRNApairs=sum(ncRNAtot$V1)
totalcomboPIDncRNA=sum(ncRNAtot$V1*ncRNAtot$V2)
meanPIDncRNA=totalcomboPIDncRNA/totalncRNApairs
comboPIDncRNA<-ncRNAtot$V1*ncRNAtot$V2
modeIndexncRNA<-which.max(comboPIDncRNA)
modePIDncRNA<-ncRNAtot$V2[modeIndexncRNA]
abline(v=meanPIDncRNA, col="blue")
abline(v=modePIDncRNA, col="green")


#-----------------------------------------------__________------------------------------_____________________-------__________________-----------------#
#Combo stuff

plot(RNAtot$V2,RNAtot$V1, main = "RNA", xlab="PID %", ylab="Number of pairs per PID",pch=20,cex=0.5)


totalRNApairs=sum(RNAtot$V1)
totalcomboPIDRNA=sum(RNAtot$V1*RNAtot$V2)
meanPIDRNA=totalcomboPIDRNA/totalRNApairs
comboPIDRNA<-RNAtot$V1*RNAtot$V2
modeIndexRNA<-which.max(comboPIDRNA)
modePIDRNA<-RNAtot$V2[modeIndexRNA]
abline(v=meanPIDRNA, col="blue")
abline(v=modePIDRNA, col="green")

#dev.off()

par(mfrow=c(1,1))
RNAtotrounded<-data.frame(round(RNAtot$V2,digits =0),RNAtot$V1)
colnames(RNAtotrounded)<-c("PID","Freq")
RNApidnames<-unique(RNAtotrounded$PID)
RNAaggregate<-aggregate(RNAtotrounded, by=list(RNAtotrounded$PID),FUN=sum)
RNAfinalbins<-data.frame(RNApidnames, RNAaggregate$Freq)
colnames(RNAfinalbins)<-c("PID","Freq")
barplot(RNAfinalbins$Freq, names.arg=RNAfinalbins$PID, main = "Summed mRNA & ncRNA", col="purple")

RNAmin<-min(RNAfinalbins$Freq)

##ncRNA
ncRNAtotrounded<-data.frame(round(ncRNAtot$V2,digits =0),ncRNAtot$V1)
colnames(ncRNAtotrounded)<-c("PID","Freq")
ncRNApidnames<-unique(ncRNAtotrounded$PID)
ncRNAaggregate<-aggregate(ncRNAtotrounded, by=list(ncRNAtotrounded$PID),FUN=sum)
ncRNAfinalbins<-data.frame(ncRNApidnames, ncRNAaggregate$Freq)
colnames(ncRNAfinalbins)<-c("PID","Freq")
barplot(ncRNAfinalbins$Freq, names.arg=ncRNAfinalbins$PID,main = "ncRNA", col="red")

ncRNAmin<-min(ncRNAfinalbins$Freq)

#mRNA
mRNAtotrounded<-data.frame(round(mRNAtot$V2,digits =0),mRNAtot$V1)
colnames(mRNAtotrounded)<-c("PID","Freq")
mRNApidnames<-unique(mRNAtotrounded$PID)
mRNAaggregate<-aggregate(mRNAtotrounded, by=list(mRNAtotrounded$PID),FUN=sum)
mRNAfinalbins<-data.frame(mRNApidnames, mRNAaggregate$Freq)
colnames(mRNAfinalbins)<-c("PID","Freq")
barplot(mRNAfinalbins$Freq, names.arg=mRNAfinalbins$PID, main ="mRNA", col="blue")

mRNAmin<-min(mRNAfinalbins$Freq)


#stacked ncRNA & mRNA
mergedncRNAmRNA<-merge(mRNAfinalbins,ncRNAfinalbins,by="PID",all=TRUE)
mergedncRNAmRNA[is.na(mergedncRNAmRNA)] <- 0

merg1<-data.frame(mergedncRNAmRNA$Freq.x,mergedncRNAmRNA$Freq.y)
merg2<-t(merg1)
par(las=1)
barplot(as.matrix(merg2), main="Combo mRNA & ncRNA",names.arg=mergedncRNAmRNA$PID, cex.names=0.5,xlab="PID",col=c("blue","red"),legend=c("mRNA","ncRNA"))
dev.off()