setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/bs_output/twilight")
#dev.off()
pdf("/home/stephmcgimpsey/Graphs_4_thesis/201_pairs_twizone_tidy.pdf",width=8,height=4)
par(mar=c(2.5,2.5,2,1),mgp=c(1.5,0.5,0))

ssearch<-vector()
ggsearch<-vector()
blast<-vector()
nhmmer<-vector()
ss34<-vector()
nhmmerit<-vector()
pidarray<-vector()

colnhmmer<-"deepskyblue"
colnhmmerit<-"dodgerblue4"
colssearch<-"violetred3"
colggsearch<-"seagreen3"
colssearch34<-"pink"
colblast<-"purple"
par(mar=c(2.5,2.5,2,1),mgp=c(1.5,0.5,0))
file.names <- dir("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/bs_output/twilight", pattern =".twi")
i=1;
for(i in 1:length(file.names)){
  piddata<-read.csv(file.names[i],sep ='\t',header=FALSE)
  
  splitdata <- split( piddata , f = piddata$V4)
  
  sfreq<-sum(splitdata$s$V3)/length(splitdata$s$V3)
  gfreq<-sum(splitdata$g$V3)/length(splitdata$g$V3)
  bfreq<-sum(splitdata$b$V3)/length(splitdata$b$V3)
  nfreq<-sum(splitdata$n$V3)/length(splitdata$n$V3)
  nitfreq<-sum(splitdata$i$V3)/length(splitdata$i$V3)
  ss34freq<-sum(splitdata$ss34$V3)/length(splitdata$ss34$V3)
  ssearch[i]<-sfreq
  ggsearch[i]<-gfreq
  blast[i]<-bfreq
  nhmmer[i]<-nfreq
  ss34[i]<-ss34freq
  nhmmerit[i]<-nitfreq
  pidarray[i]<-piddata$V7[1]
  
  i<-i+1
}

matnhm<-matrix(c(pidarray,nhmmer),ncol=2)
matnhm<-matnhm[order(matnhm[,1]),]

matnhm1<-matrix(c(pidarray,nhmmerit),ncol=2)
matnhm1<-matnhm1[order(matnhm1[,1]),]

matnhm2<-matrix(c(pidarray,ssearch),ncol=2)
matnhm2<-matnhm2[order(matnhm2[,1]),]

matnhm3<-matrix(c(pidarray,ggsearch),ncol=2)
matnhm3<-matnhm3[order(matnhm3[,1]),]

matnhm4<-matrix(c(pidarray,ss34),ncol=2)
matnhm4<-matnhm4[order(matnhm4[,1]),]

matnhm5<-matrix(c(pidarray,blast),ncol=2)
matnhm5<-matnhm5[order(matnhm5[,1]),]


plot(matnhm, col=colnhmmer, pch=16,xlim=c(100,15), ylim=c(0,1), main="201 pairs per PID subset Twilight Zone",type='l',xlab="PID (%)",ylab="Sensitivity")
points(matnhm1, col=colnhmmerit, pch=16,type='l')
points(matnhm2, col=colssearch, pch=16,type='l')
points(matnhm3, col=colggsearch, pch=16,type='l')
points(matnhm4, col=colssearch34, pch=4,type='l')
points(matnhm5, col=colblast, pch=16,type='l')


text(51,0.52,labels="47.2%",col=colblast)
text(38,0.52,labels="39.5%",col=colnhmmer)
text(38,0.48,labels="40.4%",col=colssearch)
text(43,0.52,labels="43.55%",col=colggsearch)
text(14,0.52,labels="12.05%",col=colnhmmerit)


abline(h=0.5)
legend(100,0.4,bty="n",cex=1,legend=c("nhmmer v3.1b2 iterative (3 rounds)","nhmmer v3.1b2", "ssearch36","ggsearch36","blastn 2.7.1+"),lty=1,lwd=2,col=c(colnhmmerit,colnhmmer,colssearch,colggsearch,colblast))

#abline(v=12.05)
#abline(v=47.2)
#abline(v=40.4)
#abline(v=39.5)
#abline(v=43.55)
#abline(v=12.1)

dev.off()
#############################################
############################################
#########################################
pdf("/home/stephmcgimpsey/Graphs_4_thesis/201_pairs_twizone.pdf",width=8,height=4)
par(mar=c(2.5,2.5,2,1),mgp=c(1.5,0.5,0))

plot(pidarray,nhmmer, col=colnhmmer, pch=16, xlim=c(100,0), ylim=c(0,1), main="50 pairs per PID subset Twilight Zone")
points(pidarray,nhmmerit, col=colnhmmerit, pch=16)
points(pidarray,ssearch, col=colssearch, pch=16)
points(pidarray,ggsearch, col=colggsearch, pch=16)
points(pidarray,ss34, col=colssearch34, pch=4)
points(pidarray,blast, col=colblast, pch=16)

spl3 <- smooth.spline(x = pidarray, y = nhmmer, df = 12)
lines(spl3, col = colnhmmer,lty=2,lwd=2)
spl2 <- smooth.spline(x = pidarray, y = nhmmerit, df = 12)
lines(spl2, col = colnhmmerit,lty=2,lwd=2)
spl1 <- smooth.spline(x = pidarray, y = ssearch, df = 12)
lines(spl1, col = colssearch,lty=1,lwd=2)
spl4 <- smooth.spline(x = pidarray, y = ggsearch, df = 12)
lines(spl4, col = colggsearch,lty=2,lwd=2)
spl5 <- smooth.spline(x = pidarray, y = ss34, df = 12)
lines(spl5, col = colssearch34,lty=2,lwd=2)
spl6 <- smooth.spline(x = pidarray, y = blast, df = 12)
lines(spl6, col = colblast,lty=2,lwd=2)
abline(h=0.5)
text(55,0.55,labels="blast",col=colblast)
text(35,0.7,labels="nhmmer",col=colnhmmer)
text(30,0.45,labels="ssearch",col=colssearch)
text(60,0.65,labels="ggsearch",col=colggsearch)
text(25,0.8,labels="nhmmerit",col=colnhmmerit)
text(32,0.55,labels="ssearch34",col=colssearch34)
dev.off()
