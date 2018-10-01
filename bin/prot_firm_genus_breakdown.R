#Genus


test<-layout(matrix(c(4,5,3,
                      4,2,3,
                      4,1,3,
                      4,6,3),nrow=4,ncol=3,byrow=TRUE), heights = c(0.25,5,5,0.25), widths = c(0.125,7,0.125)) 
#layout.show(test)


genus_p<-read.table("/home/stephmcgimpsey/Documents/Genus_proteo.accNums", sep="\t",as.is = 1)
colnames(genus_p)<-c("Genus","Number")
genus_p<-genus_p[order(-genus_p$Number),]

genus_f<-read.table("/home/stephmcgimpsey/Documents/Genus_firmi.accNums", sep="\t",as.is = 1)
colnames(genus_f)<-c("Genus","Number")
genus_f<-genus_f[order(-genus_f$Number),]



p<-genus_p[,2] #proteo x
f<-genus_f[,2] #firmi x
pn<-genus_p[,1] #proteo y
fn<-genus_f[,1] #firmi y

pp<-round(p/sum(genus_p[[2]])*100, digits=3)
ff<-round(f/sum(genus_f[[2]])*100, digits=3)
pl<-paste(pn,pp, sep= "\n")
pl<-paste(pl,"%",sep="")
fl<-paste(fn,ff,sep="\n")
fl<-paste(fl,"%",sep="")
par(mai=c(0.5,0.5,0.5,0.25))
barplot(pp, names.arg=pl, ylim=c(0,20), ylab = "%", main="Proteobacteria Genus % Breakdown", cex.main=2, col = topo.colors(length(pl)), cex.names=0.2, las=2)
barplot(ff, names.arg=fl, ylim=c(0,35), ylab = "%", main="Firmicutes Genus % Breakdown", cex.main=2, col = topo.colors(length(fl)), cex.names=0.2, las=2)





###top 10 proteo

test<-layout(matrix(c(4,5,7,
                      4,2,7,
                      4,3,7,
                      4,1,7,
                      4,6,3),nrow=5,ncol=3,byrow=TRUE), heights = c(0.25,3,1,5,0.25), widths = c(0.125,5,0.125)) 

gen2<-genus_p[c(1:10),2]
gen221<-genus_p[c(11:893),2]

sgen22<-round(sum(gen221)/sum(genus_p[[2]])*100,digits=3)
sg22<-round(gen221/sum(genus_p[[2]])*100,digits=3)
sgenn<-genus_p[c(11:893),1]
g1<-paste(sgenn,sg22,sep="\n")
g1<-paste(g1,"%",sep="")
par(mai=c(0.5,0.5,0.5,0.25))
barplot(sg22, names.arg=g1, ylim=c(0,2), ylab = "%", main="Proteobacteria Genus % Breakdown (893 gen)", cex.main=2, col = topo.colors(length(g1)), cex.names=0.1, las=2)






genn<-genus_p[c(1:10),1]
pg2 <- round(gen2/sum(genus_p[[2]])*100,digits=3)
pg2<-rev(pg2)
pg2<-append(pg2,sgen22)
genn<-rev(genn)
genn<-append(genn,"Other")
genn <- paste(genn, pg2, sep="\n") # add percents to labels
genn <- paste(genn,"%",sep="")
genn<-rev(genn)
pg2<-rev(pg2)
par(mai=c(0.25,0.5,0.5,0.25))
barplot(pg2, names.arg=genn, ylim=c(0,40), ylab = "%", col = topo.colors(length(genn)), cex.names=0.8)


#top ten firmicutes
test<-layout(matrix(c(4,5,7,
                      4,2,7,
                      4,3,7,
                      4,1,7,
                      4,6,3),nrow=5,ncol=3,byrow=TRUE), heights = c(0.25,3,1,5,0.25), widths = c(0.125,5,0.125)) 


p2<-genus_f[c(1:10),2] #top 10

p221<-genus_f[c(11:412),2] #nt10

p22<-round(sum(p221)/sum(genus_f[[2]])*100,digits = 3) #not top 10

p222<-round(p221/sum(genus_f[[2]])*100,digits = 3) #not top 10
p<-genus_f[c(1:10),1] #top 10
p2 <- round(p2/sum(genus_f[[2]])*100,digits = 3)
p1<-genus_f[c(11:412),1] #not top 10
p1<-paste(p1,p222,sep="\n")
p1<-paste(p1,"%")
par(mai=c(0.5,0.5,0.5,0.25))
barplot(p222, names.arg=p1, ylim=c(0,0.5), ylab = "%", main="Firmicutes Genus % Breakdown (412 gen)", cex.main=3, col = topo.colors(length(p1)), cex.names=0.1, las=2)


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