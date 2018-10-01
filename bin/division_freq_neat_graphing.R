#Genus


test<-layout(matrix(c(4,5,3,
                    4,2,3,
                   4,1,3,
                    4,6,3),nrow=4,ncol=3,byrow=TRUE), heights = c(0.25,5,7,0.25), widths = c(0.125,7,0.125)) 
#layout.show(test)


genus<-read.table("/home/stephmcgimpsey/Documents/Genus.accNums", sep="\t",as.is = 1)
colnames(genus)<-c("Genus","Number")
genus<-genus[order(-genus$Number),]

gen2<-genus[c(1:10),2]
gen221<-genus[c(11:2083),2]

sgen22<-round(sum(gen221)/sum(genus[[2]])*100)
sg22<-round(gen221/sum(genus[[2]])*100)
sgenn<-genus[c(11:2083),1]
g1<-paste(sgenn,sg22)
g1<-paste(g1,"%",sep="")
par(mai=c(0.5,0.5,0.5,0.25))
barplot(sg22, names.arg=g1, ylim=c(0,2.1), ylab = "%", main="Genus", cex.main=2, col = topo.colors(length(g1)), cex.names=0.1, las=2)


#linch <-  max(strwidth(p222, "inch")+1, na.rm = TRUE)
#par(mai=c(linch,0.5,0.5,0.25))
#barplot(p222, names.arg=p1, ylim=c(0,0.08), ylab = "%", main="Phylum", cex.main=2, col = topo.colors(length(p1)), cex.names=0.6, las=2)





genn<-genus[c(1:10),1]
pg2 <- round(gen2/sum(genus[[2]])*100)
pg2<-rev(pg2)
pg2<-append(pg2,sgen22)
genn<-rev(genn)
genn<-append(genn,"Other")
genn <- paste(genn, pg2) # add percents to labels
genn <- paste(genn,"%",sep="")
genn<-rev(genn)
pg2<-rev(pg2)
par(mai=c(0.25,0.5,0.5,0.25))
barplot(pg2, names.arg=genn, ylim=c(0,40), ylab = "%", col = topo.colors(length(genn)), cex.names=0.6)

plot.new()
frame()
text(c(0,0),"Thanks")

#Phylum
test<-layout(matrix(c(4,5,7,
                      4,2,7,
                      4,3,7,
                      4,1,7,
              4,6,3),nrow=5,ncol=3,byrow=TRUE), heights = c(0.25,3,1,5,0.25), widths = c(0.125,5,0.125)) 

phylum<-read.table("/home/stephmcgimpsey/Documents/Phylum.accNums", sep="\t",as.is = 1)
colnames(phylum)<-c("Phylum","Number")
phylum<-phylum[order(-phylum$Number),]


p2<-phylum[c(1:10),2] #top 10

p221<-phylum[c(11:41),2] #nt10

p22<-round(sum(p221)/sum(phylum[[2]])*100,digits = 1) #not top 10

p222<-round(p221/sum(phylum[[2]])*100,digits = 5) #not top 10
p<-phylum[c(1:10),1] #top 10
p2 <- round(p2/sum(phylum[[2]])*100,digits = 1)
p1<-phylum[c(11:41),1] #not top 10
p1<-paste(p1,p222,sep="\n")
p1<-paste(p1,"%")
par(mai=c(1.5,0.5,0.5,0.25))
barplot(p222, names.arg=p1, ylim=c(0,0.08), ylab = "%", main="Phylum", cex.main=3, col = topo.colors(length(p1)), cex.names=1, las=2)


p2<-rev(p2)
p2<-append(p2,p22)
p<-rev(p)
p<-append(p,"Other")
p <- paste(p, p2,sep="\n") # add percents to labels
p <- paste(p,"%",sep="")
p<-rev(p)
p2<-rev(p2)

par(mai=c(0.25,0.5,0.5,0.25))
barplot(p2, names.arg=p, ylim=c(0,50), ylab = "%", col = topo.colors(length(p)), cex.names=0.8)

#plot.new()
#frame()
#text(c(0,0),"Thanks")

#par(mai=c(1.8,0.5,0.5,0.25))
1/2083*100