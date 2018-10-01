library(mixtools)
setwd("~/Documents")



pdf(file="genussubset_nuc&aaseq_todecide_cutoffs.pdf")
par(mfrow=c(2,2))

data<-read.csv("/home/stephmcgimpsey/Documents/subset_genus_aa_nuc_combined_nocuttoff_maxbsoldcutoffadded.tophitpergenomeperhmm",header=FALSE, sep='\t') 
splitdata<-split(data, f = data$V1)

#data1<-read.csv("/home/stephmcgimpsey/Documents/combo_highestbs_cmhmm_alphabsorted.txt",header=FALSE,sep='\t') 



####LOOP FROM HERE#######
for (i in 1:length(splitdata)){
  x<-splitdata[[i]]$V3
  name<-splitdata[[i]]$V1
  modelname<-name[1]
  
  
  ##itsat least graphing now but these two aren't matchedup with the right model
  oldcutoff<-round(splitdata[[i]]$V5[1], digits=2)
  maxbs<-splitdata[[i]]$V4[1]

    

  #modelname
  #oldcutoff
  #maxbs
  
  hist(x, main="Histogram of Bitscores", sub=modelname,xlab="Bitscore",xlim=c(20,maxbs),cex.main=1,cex.lab=0.7,cex.axis=0.7,cex.sub=0.5)
  abline(v = oldcutoff, ############Make this line the old cutoff so we can see if its right or not
         col = "blue",
         lty = 3,
         lwd = 2)
  abline(v = maxbs, ############Make this line the old cutoff so we can see if its right or not
         col = "orange",
         lty = 3,
         lwd = 2)

  
  plot(density(x),main="Density Plot",sub=modelname,xlab="Bit Scores",xlim=c(20,maxbs),cex.main=1,cex.lab=0.7,cex.axis=0.7,cex.sub=0.5)
  abline(v = oldcutoff, ############Make this line the old cutoff so we can see if its right or not
         col = "blue",
         lty = 3,
         lwd = 2)
  abline(v = maxbs, ############Make this line the old cutoff so we can see if its right or not
         col = "orange",
         lty = 3,
         lwd = 2)

  }
########END LOOP HERE############
dev.off()
