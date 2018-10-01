setwd("~/Documents")
dev.off()
data1<-read.csv("/home/stephmcgimpsey/Documents/16srRNA_bitscore0dp_freqs.csv",header=FALSE,sep=',') 
data<-read.csv("/home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/bitscores_16srRNA_withevalthreshmet.txt",header=FALSE) 
x<-data$V1
x1<-data1$V1
y1<-data1$V2
#matrix<-c(x,y)
c<-length(x)
hist(x, breaks=500, main="Histogram of Bitscores for 16srRNA showing the frequency of each", xlab="Bitscore to 0dp", xlim = c(0,1670))
abline(v = mean(x),
       col = "royalblue",
       lwd = 2)
m<-mean(x)
std<-sqrt(var(x))
stand1<-m-std
stand11<-m-std*2

abline(v = stand1,
       col = "red",
       lwd = 2)
abline(v = stand11,
       col = "red",
       lwd = 2)


# Create the function.
getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


m<-mean(x)
std<-sqrt(var(x))
stand1<-m-std
stand11<-m-std*2
me<-median(x)
mo<-getmode(x)
newstand11<-me-std*2
newmostand11<-mo-std*2

newx<-x1[-(0:stand1)]
newxR<-x[0:1000]
mo2<-getmode(newxR)
nm<-match(newx[0],x)
lenx<-length(newx)
leny<-length(y1)
lenmis<-leny-lenx
lenmis<-lenmis+1
newy<- y1[lenmis:leny]

me<-median(x)
mo<-getmode(x)
m<-mean(x)

plot(newx,newy,pch=16)
abline(v = me,
       col = "red",
       lwd = 2)
abline(v = mo,
       col = "pink",
       lwd = 2)
abline(v = m,
       col = "royalblue",
       lwd = 2)
plot(density(x),xlim=c(-400,2000),main="Density plot of distribution of bitscores",xlab="Bit Scores")
abline(v = me,
       col = "red",
       lwd = 2)
abline(v = newstand11,
       col = "red",
       lwd = 2, lty=2)
abline(v = mo,
       col = "green",
       lwd = 2)
abline(v = mo2,
       col = "green",
       lwd = 2, cex=0.5)
abline(v =newmostand11,
       col = "green",
       lwd = 2, lty=2)
abline(v = m,
       col = "blue",
       lwd = 2)
abline(v = stand11,
       col = "blue",
       lwd = 2, lty=2)



d<-161.083+(201.4561)
dd<-1549.7083-(201.4561)
d2<-161.083+(201.4561*2)
dd2<-1549.7083-(201.4561*2)
d3<-161.083+(201.4561*3)
dd3<-1549.7083-(201.4561*3)
plot(x1,y1,col="black",pch=16)


library(mixtools)
wait1 <- normalmixEM(x, lambda = .5, mu = c(mo2, mo), sigma = 5, arbmean=TRUE, arbvar=TRUE)
plot(wait1, density=TRUE)


abline(v = dd,
       col = "deeppink4",
       lwd = 2)
abline(v = dd2,
       col = "deeppink",
       lwd = 2)
abline(v = dd3,
       col = "thistle1",
       lwd = 2)
abline(v = 1549.7083,
       col = "red",
       lwd = 2)
abline(v = 201.4561,
       col = "royalblue",
       lwd = 2)

abline(v = d,
       col = "cornflowerblue",
       lwd = 2)
abline(v = d2,
       col = "cadetblue1",
       lwd = 2)
abline(v = d3,
       col = "aliceblue",
       lwd = 2)

wait1[c("lambda", "mu", "sigma")]
summary(wait1)

#help("normalmixEM") #mu=mean #sigma=std
