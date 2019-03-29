#setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/twilight")
setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/new_nhmmit_March4th")
#dev.off()

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
file.names <- dir("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/new_nhmmit_March4th", pattern =".twi")
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



####################################################
###################################BOOTSTAPPING
####################################################
setwd("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/new_nhmmit_March4th/bootstrap_ready")
library(data.table)
library(boot)
##pick 200 with replacement 100-1000 times
#for each aligner sum the 1's and divide by 200
#do this for each file
#find min % and max % of tru homolgs found for the 100-1000 iterations
#save them to be able to add as error bars on twilight graph
storeofinfo<-matrix(0, nrow = 100, ncol = 19)
##have to write a foreach loop to open a file 
i<-1
file.names <- dir("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/new_nhmmit_March4th/bootstrap_ready", pattern =".bootready")
for(i in 1:length(file.names)){
  piddata<-read.csv(file.names[i],sep ='\t',header=FALSE)
  sactual<- sum(piddata$V11)/length(piddata$V11)
  gactual<- sum(piddata$V5)/length(piddata$V5)
  nactual<- sum(piddata$V9)/length(piddata$V9)
  bactual<- sum(piddata$V3)/length(piddata$V3)
  niactual<- sum(piddata$V7)/length(piddata$V7)
  ss34actual<-sum(piddata$V13)/length(piddata$V13)
  
  simplesum <- function(data,i) {
    thingme<-data[i,]
    thigme<-data
    sum1<- sum(thingme$V11)/length(thingme$V11)
    sum2<- sum(thingme$V5)/length(thingme$V5)
    sum3<- sum(thingme$V9)/length(thingme$V9)
    sum4<- sum(thingme$V3)/length(thingme$V3)
    sum5<- sum(thingme$V7)/length(thingme$V7)
    sum6<- sum(thingme$V13)/length(thingme$V13)
    sumvec<-c(sum1,sum2,sum3,sum4,sum5,sum6)
    return(sumvec)
  }
  
  set.seed(200)
  bootob<- boot(piddata,simplesum,R=10000,stype="i")
  #smin<-min(bootob[["t"]][,1])
  #gmin<-min(bootob[["t"]][,2])
  #nmin<-min(bootob[["t"]][,3])
  #bmin<-min(bootob[["t"]][,4])
  #nimin<-min(bootob[["t"]][,5])
  #ss34min<-min(bootob[["t"]][,6])
  #smax<-max(bootob[["t"]][,1])
  #gmax<-max(bootob[["t"]][,2])
  #nmax<-max(bootob[["t"]][,3])
  #bmax<-max(bootob[["t"]][,4])
  #nimax<-max(bootob[["t"]][,5])
  #ss34max<-max(bootob[["t"]][,6])
  quans<-quantile(bootob[["t"]][,1],probs=c(0.025,0.975))
  quang<-quantile(bootob[["t"]][,2],probs=c(0.025,0.975))
  quann<-quantile(bootob[["t"]][,3],probs=c(0.025,0.975))
  quanb<-quantile(bootob[["t"]][,4],probs=c(0.025,0.975))
  quanni<-quantile(bootob[["t"]][,5],probs=c(0.025,0.975))
  quanss34<-quantile(bootob[["t"]][,6],probs=c(0.025,0.975))
  
  #x<-file.names[i-1]
  #max <- unlist(strsplit(x, "_"))
  #pid1<-max[1]
  #pid<-as.numeric(pid1)
  pid<-piddata$V15[1]
  
  storeofinfo[pid,1]<-pid
  storeofinfo[pid,2]<-sactual
  storeofinfo[pid,3]<-quans[1]
  storeofinfo[pid,4]<-quans[2]
  storeofinfo[pid,5]<-gactual
  storeofinfo[pid,6]<-quang[1]
  storeofinfo[pid,7]<-quang[2]
  storeofinfo[pid,8]<-nactual
  storeofinfo[pid,9]<-quann[1]
  storeofinfo[pid,10]<-quann[2]
  storeofinfo[pid,11]<-bactual
  storeofinfo[pid,12]<-quanb[1]
  storeofinfo[pid,13]<-quanb[2]
  storeofinfo[pid,14]<-niactual
  storeofinfo[pid,15]<-quanni[1]
  storeofinfo[pid,16]<-quanni[2]
  storeofinfo[pid,17]<-ss34actual
  storeofinfo[pid,18]<-quanss34[1]
  storeofinfo[pid,19]<-quanss34[2]
  
  ##same the actual, min and max for each aligner to a matrix
  i<-i+1
}
##end for loop
#pdf("/home/stephmcgimpsey/Graphs_4_thesis/50_pairs_bootstrap.pdf",width=8,height=4)

colnames(storeofinfo)<-c("PID","Sactual","Smin","Smax","Gactual","Gmin","Gmax","Nactual","Nmin","Nmax","Bactual","Bmin","Bmax","NIactual","NImin","NImax","SS34actual","SS34min","SS34max")
twizone<-as.data.frame(storeofinfo)

#dev.off()

###RANDOM TANGENT - NO MODELLING
#pdf("/home/stephmcgimpsey/Graphs_4_thesis/50_pairs_twizone_final_distributionofPAIRS.pdf",width=8,height=6)
layout(matrix(c(3,1,4,
                3,2,4),nrow=2,ncol=3,byrow=TRUE), heights = c(10,3), widths = c(0.1,10,0.1)) 


par(mar=c(3,3,0.5,1),mgp=c(1.5,0.5,0))
plot(twizone$PID,twizone$Sactual, type='n',xlim=c(100,0),ylim=c(0,1),xlab="PID %",ylab="Sensitivity with fixed FPR (1 in 10,000)",main=NULL, cex.lab=1.5,cex.axis=1.5)
#rect(43.91, 0, 27.27, 1, col = "lightgrey", border = NA,density=50)
#rect(34.63, 0, 34.94, 1, col = "yellow", border = NA,density=50)


rect(43,0,50,1,border=NA,density=100,col=rgb(160,32,240,150,maxColorValue = 255)) #blast
rect(41,0,49,0.98,border=NA,density=100,col=rgb(67,205,128,150,maxColorValue = 255))#ggsearch
rect(37,0,40,1,border=NA,density=100,col=rgb(0,191,255,150,maxColorValue = 255))#nhmmer
rect(38,0,40,0.98,border=NA,density=100,col=rgb(205,50,120,150,maxColorValue = 255))#ssearch

points(twizone$PID,twizone$Sactual,col=colssearch,cex=1,pch=16,type="l",lwd=4)
points(twizone$PID,twizone$Nactual,col=colnhmmer,cex=1,pch=16,type="l",lwd=4)
points(twizone$PID,twizone$Bactual,col=colblast,cex=1,pch=16,type="l",lwd=4)
points(twizone$PID,twizone$Gactual,col=colggsearch,cex=1,pch=16,type="l",lwd=4)

#abline(v=71,col="goldenrod1",lwd=4,lty=3)
abline(v=32,col="darkorange",lwd=4,lty=3)
#text(73,0.48,labels="Randomly Generated Sequences 95% CI",cex=1,srt=90,font=2,col="goldenrod1")
text(34,0.75,labels="Shuffled Genes 95% CI",cex=1,srt=90,font=2,col="darkorange")

rect(0,0,20,1,border=NA,density=100,col=rgb(0,0,0,200,maxColorValue = 255))
rect(37,0,50,1,border=NA,density=10,col="black")
abline(h=0.5,col="black")
text(10,0.95,labels="Nucleotide PIDs\ncorresponding to the\nAmino Acid Twilight Zone",cex=0.7,col="white")


legend(105,0.4,bty="n",cex=1,legend=c("nhmmer v3.1b2", "ssearch36","ggsearch36","blastn 2.7.1+"),lty=1,lwd=2,col=c(colnhmmer,colssearch,colggsearch,colblast))



par(mar=c(0.5,3,0,1),mgp=c(1.5,0.5,0))
pairsdata<-read.csv("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/50pairs_ncRNA_mRNA_per_PID_tidy.tsv",sep ='\t',header=FALSE)
pairsdata[is.na(pairsdata)] <- 0
barplotdata<-data.frame(pairsdata$V2,pairsdata$V3,row.names = pairsdata$V1)


barplot(t(as.matrix(barplotdata)),col=c("goldenrod","darkorange4"), ylim=c(50,0),border=NA,main=NULL,ylab ="Number of Sequence Pairs", xlab=NULL,cex.main=1.5,axisnames = FALSE,cex.lab=1.5,cex.axis=1.5)

# values


# Now use mtext() for the axis labels
#mtext(text = c(0,100), side = 1, at = mp, line = 0,cex=0.8)
legend(40,107,c("ncRNA","mRNA"), pch = 15, cex=0.8,col=c("darkorange4","goldenrod"),ncol=2,bty = "n")


#dev.off()


