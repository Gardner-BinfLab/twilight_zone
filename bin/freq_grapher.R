kingdom<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Superkingdom.accNums", sep="\t")
colnames(kingdom)<-c("Kingdom","Number")
kingdom<-kingdom[order(-kingdom$Number),]

phylum<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Phylum.accNums", sep="\t")
colnames(phylum)<-c("Phylum","Number")
phylum<-phylum[order(-phylum$Number),]

class<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Class.accNums", sep="\t")
colnames(class)<-c("Class","Number")
class<-class[order(-class$Number),]

Order<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Order.accNums", sep="\t")
colnames(Order)<-c("Order","Number")
Order<-Order[order(-Order$Number),]

family<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Family.accNums", sep="\t")
colnames(family)<-c("Family","Number")
family<-family[order(-family$Number),]

genus<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Genus.accNums", sep="\t")
colnames(genus)<-c("Genus","Number")
genus<-genus[order(-genus$Number),]

species<-read.table("/home/stephmcgimpsey/Documents/Taxonomy/Species.accNums", sep="\t")
colnames(species)<-c("Species","Number")
species<-species[order(-species$Number),]


par(las=2)

op <- par(mar=c(11,4,4,2))

pct <- round(kingdom[[2]]/sum(kingdom[[2]])*100)
lbls <- paste(kingdom[[1]], pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # ad % to labels
barplot(pct, names.arg=lbls, ylim=c(0,100), main = "Superkingdom", ylab="%", col = topo.colors(length(lbls)))

pct1 <- round(phylum[[2]]/sum(phylum[[2]])*100)
lbls1 <- paste(phylum[[1]], pct1) # add percents to labels
lbls1 <- paste(lbls1,"%",sep="") # ad % to labels
barplot(pct1, names.arg=lbls1, ylim=c(0,50), main="Phylum", ylab = "%", col = topo.colors(length(lbls1)), cex.names = 0.5)

pct2 <- round(class[[2]]/sum(class[[2]])*100)
lbls2 <- paste(class[[1]], pct2) # add percents to labels
lbls2 <- paste(lbls2,"%",sep="") # ad % to labels
barplot(pct2, names.arg=lbls2, ylim=c(0,40), main="Class", ylab = "%", col = topo.colors(length(lbls2)), cex.names = 0.5)

pct3 <- round(Order[[2]]/sum(Order[[2]])*100)
lbls3 <- paste(Order[[1]], pct3) # add percents to labels
lbls3 <- paste(lbls3,"%",sep="") # ad % to labels
barplot(pct3, names.arg=lbls3, ylim=c(0,25), main="Order", ylab = "%", col = topo.colors(length(lbls3)), cex.names = 0.2)

pct4 <- round(family[[2]]/sum(family[[2]])*100)
lbls4 <- paste(family[[1]], pct4) # add percents to labels
lbls4 <- paste(lbls4,"%",sep="") # ad % to labels
barplot(pct4, names.arg=lbls4, ylim=c(0,25), main="Family", ylab = "%", col = topo.colors(length(lbls4)), cex.names = 0.1)

pct5 <- round(genus[[2]]/sum(genus[[2]])*100)
lbls5 <- paste(genus[[1]], pct5) # add percents to labels
lbls5 <- paste(lbls5,"%",sep="") # ad % to labels
barplot(pct5, names.arg=lbls5, ylim=c(0,12), main="Genus", ylab = "%", col = topo.colors(length(lbls5)), cex.names = 0.05)



par(las=2)

phy2<-phylum[c(1:10),2]
phyn<-phylum[c(1:10),1]
pp2 <- round(phy2/sum(phylum[[2]])*100)
barplot(pp2, names.arg=phyn, ylim=c(0,50), main="Phylum", ylab = "%", col = topo.colors(length(phyn)))

cla2<-class[c(1:10),2]
clan<-class[c(1:10),1]
pc2 <- round(cla2/sum(class[[2]])*100)
barplot(pc2, names.arg=clan, ylim=c(0,40), main="Class", ylab = "%", col = topo.colors(length(clan)))

ord2<-Order[c(1:10),2]
ordn<-Order[c(1:10),1]
po2 <- round(ord2/sum(Order[[2]])*100)
barplot(po2, names.arg=ordn, ylim=c(0,25), main="Order", ylab = "%", col = topo.colors(length(ordn)))

fam2<-family[c(1:10),2]
famn<-family[c(1:10),1]
pf2 <- round(fam2/sum(family[[2]])*100)
barplot(pf2, names.arg=famn, ylim=c(0,25), main="Family", ylab = "%", col = topo.colors(length(famn)))

gen2<-genus[c(1:10),2]
gen22<-genus[c(11:10400),2]
sum(gen22)/sum(genus[[2]])*100
genn<-genus[c(1:10),1]
pg2 <- round(gen2/sum(genus[[2]])*100)
barplot(pg2, names.arg=genn, ylim=c(0,12), main="Genus", ylab = "%", col = topo.colors(length(genn)))


###SORT THIS CODE OUT AND THEN COPY TO THE ABOVE

spe2<-species[c(1:10),2] # takes top 10 valyues
spec22<-species[c(11:10400),2] #takes all others
sspec22<-round(sum(spec22)/sum(species[[2]])*100) # makes all others a percentage
spen<-species[c(1:10),1] #takes the names
spen
ps2 <- round(spe2/sum(species[[2]])*100) # makes the top 10 into percentages
ps2<-append(ps2,sspec22) #adds the 'other' percentage to the graph
ps2
spen
spen<-c(species[c(1:10),1], "Other") ###for some reason the numbers show not the bloody name!!!!
spen
ls2 <- paste(spen, ps2) # add percents to labels
ls2
ls2 <- paste(ls2,"%",sep="") # ad % to labels
ls2

barplot(ps2, names.arg=ls2, ylim=c(0,50), main="Species", ylab = "%", col = topo.colors(length(spen)), cex.names=0.6)









