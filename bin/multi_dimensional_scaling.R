#https://www.statmethods.net/advstats/mds.html

setwd("~/Documents")

#for genus
data<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_genus.rtable",header=FALSE,sep=',',row.names=1) #get rid of row.names or header bit if no row and column names
phylum<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_genus.seqnames", header=FALSE , sep='\t',row.names=1,na.strings="")
g<-cmdscale(data,eig=TRUE,k=2)
x<-g$points[,1]
y<-g$points[,2]
t(phylum)
c<-phylum$V3
matrix<-rbind(x,y,c)
matrix<-t(matrix)
cc<-matrix[,3]
ab<-unique(cc)
abc<-length(ab)
phylumlabels<-unique(phylum$V3)

phylumlabels<-t(phylumlabels)
phylumlabels<-as.character(phylumlabels)
##

#for species
data1<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_species.rtable",header=FALSE,sep=',',row.names=1) #get rid of row.names or header bit if no row and column names
phylum1<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bscutoff_alignedtoCM_phylipheaders_fracsremoved_weighted_species.seqnames", header=FALSE , sep='\t',row.names=1,na.strings="")
g1<-cmdscale(data1,eig=TRUE,k=2)
x1<-g1$points[,1]
y1<-g1$points[,2]
t(phylum1)
#c1<-phylum1$V3
#matrix1<-rbind(x1,y1,c1)
#matrix1<-t(matrix1)
cc1<-phylum1$V3
ab1<-unique(cc1)
abc1<-length(ab1)
phylumlabels1<-unique(phylum1$V3)

phylumlabels1<-t(phylumlabels1)
phylumlabels1<-as.character(phylumlabels1)
##
dev.off()
par(mar=c(2, 1, 2, 1), xpd=TRUE)



#par(xpd=TRUE)
library(RColorBrewer)
#color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
layout(matrix(c(5,4,7,
               5,1,7,
               5,2,7,
               5,3,7,
               5,6,7),nrow=5,ncol=3,byrow=TRUE), heights = c(0.1,10,3,10,0.1), widths = c(0.1,5,0.1)) 

#palette(sample(color,abc))
#paltokeep<-palette()
#palette(c("cadetblue2","aquamarine2", "chartreuse3", "chocolate4",   "azure4", "coral2",  "bisque2",  "blue",   "cyan4",  "blueviolet",    "darkblue", "darkgoldenrod1",  "brown1",  "darkmagenta",  "darkkhaki","darkorange2", "firebrick", "forestgreen", "darkorchid4",  "gold","darkseagreen", "darksalmon", "deeppink", "deeppink4", "gray7", "gray93","lavenderblush2","hotpink","indianred", "lightgoldenrod1", "lightpink","lightsalmon", "mediumorchid4", "lightslateblue",  "olivedrab1","navajowhite4", "peru","seashell","tan3"))
palette(c("darkgoldenrod1","darkgoldenrod3","yellow","yellow3","burlywood1", "burlywood3","tan3","tan4","brown4","brown1","tomato","tomato3", "violetred","violetred1","thistle1","maroon1","maroon4","slateblue3", "mediumorchid3","mediumorchid4","blueviolet","mediumseagreen", "mediumspringgreen","lightseagreen","olivedrab","limegreen","navy", "lightskyblue","turquoise1","steelblue3","sienna1","tan1","chocolate1", "chocolate3","black","grey41","gray81","grey51"))
colpal<-palette(c("darkgoldenrod1","darkgoldenrod3","yellow","yellow3","burlywood1", "burlywood3","tan3","tan4","brown4","brown1","tomato","tomato3", "violetred","violetred1","thistle1","maroon1","maroon4","slateblue3", "mediumorchid3","mediumorchid4","blueviolet","mediumseagreen", "mediumspringgreen","lightseagreen","olivedrab","limegreen","navy", "lightskyblue","turquoise1","steelblue3","sienna1","tan1","chocolate1", "chocolate3","black","grey41","gray81","grey51"))   #palette(c("cadetblue2","aquamarine2", "chartreuse3", "chocolate4",   "azure4", "coral2",  "bisque2",  "blue",   "cyan4",  "blueviolet",    "darkblue", "darkgoldenrod1",  "brown1",  "darkmagenta",  "darkkhaki","darkorange2", "firebrick", "forestgreen", "darkorchid4",  "gold","darkseagreen", "darksalmon", "deeppink", "deeppink4", "gray7", "gray93","lavenderblush2","hotpink","indianred", "lightgoldenrod1", "lightpink","lightsalmon", "mediumorchid4", "lightslateblue",  "olivedrab1","navajowhite4", "peru","seashell","tan3"))



colourvectorgenus<-colpal[phylum1$V3]


plot(x,y, main="MDS of the Genus distances", xlab='',ylab='',pch=20, cex=0.5, col=colourvectorgenus) #add these back in; 
plot.new()
legend("center",c(phylumlabels),text.col=unique(colourvectorgenus),ncol = 6,cex=0.5)
plot(x,y, main="MDS of the Genus distances", xlab='',ylab='',type="n", col=colourvectorgenus) #add these back in; 
text(x, y, labels = row.names(data), cex=0.5, col=colourvectorgenus) 


par(mar=c(2, 1, 2, 1), xpd=TRUE)
layout(matrix(c(5,4,7,
              5,1,7,
               5,2,7,
               5,3,7,
               5,6,7),nrow=5,ncol=3,byrow=TRUE), heights = c(0.1,10,3,10,0.1), widths = c(0.1,5,0.1)) 
palette(sample(color,abc1))

plot(x1,y1, main="MDS of the Species distances", xlab='',ylab='',pch=20, cex=0.5, col=cc1 ) #add these back in; 
plot.new()
legend("center",c(phylumlabels1),text.col=colpal,ncol = 6, cex=0.5)
plot(x1,y1, main="MDS of the Species distances", xlab='',ylab='',type="n", col=cc1 ) #add these back in; 
text(x1, y1, labels = row.names(data1), cex=0.5, col=cc1) 


##Figure out how to split the data by genus and graph them seperately

