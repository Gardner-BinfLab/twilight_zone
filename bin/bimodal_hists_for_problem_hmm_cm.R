library(mixtools)
setwd("~/Documents")

##TO DO
#Loop to make lots of dataframes, one for each hmm/cm (data already split so might not have to do this)
#matrix that stores all the hmm/cm names which are in fact the dataframe names
#Loop to plot each of those dataframes


#pdf(file="genussubset_bitscoredistributions_to_identify_incorrect_cutoffs.pdf")
par(mfrow=c(2,2))

data<-read.csv("/home/stephmcgimpsey/Documents/combined_bitscores.tsv",header=FALSE, sep='\t') 
splitdata<-split(data, f = data$V1)

####LOOP FROM HERE#######
for (i in 1:length(splitdata)){
x<-splitdata[[i]]$V2
name<-splitdata[[i]]$V1
modelname<-name[1]

hist(x, main="Histogram of Bitscores", sub=modelname,xlab="Bitscore",cex.main=1,cex.lab=0.7,cex.axis=0.7,cex.sub=0.5)
abline(v = mean(x),
       col = "royalblue",
       lwd = 2)

plot(density(x),main="Density Plot",sub=modelname,xlab="Bit Scores",cex.main=1,cex.lab=0.7,cex.axis=0.7,cex.sub=0.5)


}
########END LOOP HERE############
dev.off()
