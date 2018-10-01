#https://www.statmethods.net/advstats/mds.html

setwd("~/Documents")

#for genus
#data<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_genus.rtable",header=FALSE,sep=',',row.names=1) #get rid of row.names or header bit if no row and column names
#phylum<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_genus.seqnames", header=FALSE , sep='\t',row.names=1,na.strings="")
#for species
#data<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_species.rtable",header=FALSE,sep=',',row.names=1) #get rid of row.names or header bit if no row and column names
#phylum<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_species.seqnames", header=FALSE , sep='\t',row.names=1,na.strings="")

#for species 2.0
#data<-read.csv("/home/stephmcgimpsey/Documents/16s-rRNA_uniquespecies_phylipheaders.rtable",header=FALSE,sep=',',row.names=1) #get rid of row.names or header bit if no row and column names
#phylum<-read.csv("/home/stephmcgimpsey/Documents/16s-rRNA_uniquespecies_phylipheaders.phylum", header=FALSE , sep='\t',row.names=1,na.strings="")

#for genus 2.0

data<-read.csv("/home/stephmcgimpsey/Documents/16s-rRNA_uniquegenus_phylipheaders.rtable",header=FALSE,sep=',',row.names=1) #get rid of row.names or header bit if no row and column names
phylum<-read.csv("/home/stephmcgimpsey/Documents/16s-rRNA_uniquegenus_phylipheaders.phylum", header=FALSE , sep='\t',row.names=1,na.strings="")


g<-cmdscale(data,eig=TRUE,k=2)
x<-g$points[,1]
y<-g$points[,2]
phy<-unique(t(phylum$V3))
phy<-sort(phy)
phy<-as.character(phy)
##
combodata<-cbind(x,y,phylum)
splitdata <- split( combodata , f = combodata$V3)
xaxislim<-max(x)
yaxislim<-max(y)
xaxislimm<-min(x)
yaxislimm<-min(y)


pdf(file="genus2_allcombined.pdf")
colpal<-palette(c("darkgoldenrod1","darkgoldenrod3","yellow","yellow3","burlywood1", "burlywood3","tan3","tan4","brown4","brown1","tomato","tomato3", "violetred","violetred1","thistle1","maroon1","maroon4","slateblue3", "mediumorchid3","mediumorchid4","blueviolet","mediumseagreen", "mediumspringgreen","lightseagreen","olivedrab","limegreen","navy", "lightskyblue","turquoise1","steelblue3","sienna1","tan1","chocolate1", "chocolate3","black","grey41","gray81","grey51"))   #palette(c("cadetblue2","aquamarine2", "chartreuse3", "chocolate4",   "azure4", "coral2",  "bisque2",  "blue",   "cyan4",  "blueviolet",    "darkblue", "darkgoldenrod1",  "brown1",  "darkmagenta",  "darkkhaki","darkorange2", "firebrick", "forestgreen", "darkorchid4",  "gold","darkseagreen", "darksalmon", "deeppink", "deeppink4", "gray7", "gray93","lavenderblush2","hotpink","indianred", "lightgoldenrod1", "lightpink","lightsalmon", "mediumorchid4", "lightslateblue",  "olivedrab1","navajowhite4", "peru","seashell","tan3"))



par(mar=c(2,2,2,2))

par(mar=c(2, 1, 1, 1))
layout(matrix(c(5,4,7,
                5,1,7,
                5,2,7,
                5,3,7,
                5,6,7),nrow=5,ncol=3,byrow=TRUE), heights = c(0.1,10,5,10,0.1), widths = c(0.1,5,0.1)) 


plot(splitdata$Acidobacteria$x,splitdata$Acidobacteria$y, col=colpal[1], pch=20,cex=0.5,main="MDS of the Genus distances", xlab='',ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
n<-2
lengthdata<-length(splitdata)
for (n in 2:lengthdata){
points(splitdata[[n]]$x,splitdata[[n]]$y, col=colpal[n], pch=20,cex=0.5)
n<-n+1
}
plot.new()
legend("center",c(phy),text.col=colpal,ncol=6,cex=0.5)


plot(splitdata$Acidobacteria$x,splitdata$Acidobacteria$y, col=colpal[1], main="MDS of the Genus distances", type='n',xlab='',ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
text(splitdata$Acidobacteria$x,splitdata$Acidobacteria$y, labels = row.names(splitdata$Acidobacteria), cex=0.5, col=colpal[1]) 

n<-2
for (n in 2:lengthdata){
  points(splitdata[[n]]$x,splitdata[[n]]$y, col=colpal[n], type="n")
  text(splitdata[[n]]$x,splitdata[[n]]$y, labels = row.names(splitdata[[n]]), cex=0.5, col=colpal[n]) 
  
  n<-n+1
}

par(mar=c(2, 2, 2, 2))
layout(matrix(c(8,1,1,7,
                8,6,6,7,
                8,2,3,7,
                8,9,9,7,
                8,4,5,7),nrow=5,ncol=4,byrow=TRUE), heights = c(7,2,5,0.5,5), widths = c(0.1,5,5,0.1)) 


plot(splitdata[[30]]$x,splitdata[[30]]$y, col=colpal[30], pch=20,cex=0.5,xlab='',main=splitdata[[30]]$V3[1],ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
plot(splitdata[[20]]$x,splitdata[[20]]$y, col=colpal[20], pch=20,cex=0.5,xlab='',main=splitdata[[20]]$V3[1],ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
plot(splitdata[[2]]$x,splitdata[[2]]$y, col=colpal[2], pch=20,cex=0.5,xlab='',main=splitdata[[2]]$V3[1],ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
plot(splitdata[[5]]$x,splitdata[[5]]$y, col=colpal[5], pch=20,cex=0.5,xlab='',main=splitdata[[5]]$V3[1],ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
plot(splitdata[[14]]$x,splitdata[[14]]$y, col=colpal[14], pch=20,cex=0.5,xlab='',main=splitdata[[14]]$V3[1],ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
plot.new()
legend("center",legend=c("Top 5 Phylum"), cex=1.5, bty="n")

par(mfrow=c(3,2),mar=c(3,3,3,3))
n<-1
for (n in 1:lengthdata){

  plot(splitdata[[n]]$x,splitdata[[n]]$y, col=colpal[n], pch=20,cex=0.5,xlab='',main=splitdata[[n]]$V3[1],ylab='',xlim=c(xaxislimm,xaxislim), ylim=c(yaxislimm,yaxislim))
  print(n)
  print(splitdata[[n]]$V3[1])
  
  print(length(splitdata[[n]]$x))
  
  n<-n+1
}






dev.off()
#dev.off()
#par(mar=c(3, 3,3, 3))
#plot(splitdata[[30]]$x,splitdata[[30]]$y, col=colpal[30], pch=20,cex=0.5,xlab='',ylab='',main="Top 5 Phylum for Genus Subset", xlim=c(-0.05,0.1), ylim=c(-0.25,0.15))
#points(splitdata[[20]]$x,splitdata[[20]]$y, col=colpal[20], pch=20,cex=0.5)
#points(splitdata[[5]]$x,splitdata[[5]]$y, col=colpal[5], pch=20,cex=0.5)
#points(splitdata[[2]]$x,splitdata[[2]]$y, col=colpal[2], pch=20,cex=0.5)
#points(splitdata[[14]]$x,splitdata[[14]]$y, col=colpal[14], pch=20,cex=0.5)


#actino 346 2
#bacteroidetes 447 5
#cyanobacteria 93 14
#fimicutes 870 20
#proteo 1033 30


#MAKE ANOTHER PLOT WHERE THE TEXT IS THE PHYLUM 
#MAKE A GRID PLOT WITH ALL THE PHYLUM SEPERATED
