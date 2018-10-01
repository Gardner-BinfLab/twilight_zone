setwd("~/Documents")


#PID GRAPH
barplot(c(67,33,80,54,80,60), main="Percentage of identicle residues per alignment (PID)", xlab="Percentage", beside=TRUE, col=c("blue","green","purple"), horiz= TRUE, names.arg=c("BC","BC", "AC","AC", "AB", "AB"),cex.lab=0.8,las=1, xlim=c(80,0))

#TWILIGHT ZONE GRAPH


#data<-matrix(c(100,
 #              0.97,0.98,0.99,
  #              0.98,0.98,1,
   #            95,
    #           0.95,0.96,0.98,
     #           0.96,0.97,0.98,
      #         90,
       #        0.9,0.91,0.95,
        #        0.92,0.94,0.96,
         #      85,
          #     0.84,0.85,0.91,
#                0.87,0.91,0.95,
 #              80,
  #             0.77,0.79,0.89,
   #             0.84,0.86,0.91,
    #           75,
     #          0.66,0.68,0.85,
      #          0.80,0.85,0.90,
       #        70,
        #       0.52,0.56,0.78,
         #       0.78,0.81,0.87,
          #     65,
#               0.38,0.40,0.6,
 #               0.76,0.78,0.86,
  #             60,
   #            0.3,0.32,0.5,
    #            0.73,0.76,0.84,
     #          55,
      #         0.2,0.23,0.42,
       #         0.66,0.68,0.81,
        #       50,
#               0.11,0.15,0.34,
 #               0.61,0.64,0.78,
  #             45,
   #            0.08,0.07,0.25,
    #            0.57,0.58,0.75,
     #          40,
      #         0.05,0.12,0.16,
       #         0.54,0.56,0.71,
        #       35,
#               0.035,0.09,0.11,
 #               0.49,0.52,0.67,
  #             30,
   #            0.027,0.08,0.09,
    #            0.38,0.40,0.61,
     #          25,
      #         0.02,0.06,0.07,
       #         0.32,0.36,0.5,
        #       20,
#               0.015,0.03,0.04,
 #               0.27,0.29,0.42,
  #             15,
   #            0.01,0.02,0.03,
    #             0.15,0.18,0.2,
     #          10,
      #         0.0,0.0,0.01,
       #         0.07,0.08,0.13,
        #       5,
#               0.0,0.0,0.0,
 #               0.03,0.03,0.07,
  #             0,
   #            0.0,0.0,0.0,
    #          0.01,0.02,0.03),ncol=7,nrow=21,byrow=TRUE)

#nhmmer; profilexseq heuristic aka hmmer? for prot
#blastn; seqxseq heuristic aka blastp for prot
#smith-waterman; seqxseq math aka smith waterman (blossum 62 matrix)
#dimnames(data)<-list(c(100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10,5,0),c("SWN","BN","NH","SWP","BP","PH"))
#y<-data.matrix(c(100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10,5,0))
#dimnames(y)<-list(c(100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10,5,0),c())
#length(y)


#plot(y,data[,2],col="red",pch=15)
#points(y,data[,3],col="blue", pch=16)
#points(y,data[,4],col="green",pch=17)
par(xaxs="i", yaxs="i") 
par(mar=c(5,5,3,3))
x <- seq(0, 100, 0.01)

sigmoid = function(x) {
  
  0.98 / (1 + exp(-0.15*(x-58)))
}

plot(x, sigmoid(x), col='blue',pch=1,type="n",cex=0.5, xlim=c(100,0),ylim=c(0,1),ylab="Fraction of true homologs from all aligned pairs reported as homologs", xlab="Percentage Identity (PID)", main="The Twilight Zone - Nucleotide & Amino Acid", cex.lab=0.8)
polygon(x=c(58,58,72,72),y=c(0,1,1,0),col="lavenderblush",border = NA)
polygon(x=c(20,20,35,35),y=c(0,1,1,0),col="lightblue1",border = NA)
abline(h=0.5,lty=3)
axis(side = 1, at = c(100,90,80,70,60,50,40,30,20,10,0), 
     labels = c(100,90,80,70,60,50,40,30,20,10,0))
lines(x, sigmoid(x), col='indianred4',lty=1,lwd=4)
polygon(x=c(58,58,60,60),y=c(0.47,0.53,0.53,0.47),col="lavenderblush",border = NA)
polygon(x=c(56,56,58,58),y=c(0.47,0.53,0.53,0.47),col="white",border = NA)
text(58, 0.5, "X%",cex=1.2)


sigmoid = function(x) {
  0.989 / (1 + exp(-0.15*(x-67)))
}
lines(x, sigmoid(x), col='indianred',lty=1,lwd=4)
polygon(x=c(65,65,69,69),y=c(0.47,0.53,0.53,0.47),col="lavenderblush",border = NA)
text(67, 0.5, "Y%",cex=1.2)


sigmoid = function(x) {
  0.99 / (1 + exp(-0.15*(x-72)))
}
lines(x, sigmoid(x), col='indianred1',lty=1,lwd=4)
polygon(x=c(72,72,74,74),y=c(0.47,0.53,0.53,0.47),col="white",border = NA)
polygon(x=c(70,70,72,72),y=c(0.47,0.53,0.53,0.47),col="lavenderblush",border = NA)
text(72, 0.5, "Z%",cex=1.2)



##protein

#x <- seq(0, 100, 0.01)

#sigmoid = function(x) {
  
#  0.98 / (1 + exp(-0.15*(x-20)))
#}

#lines(x, sigmoid(x), col='dodgerblue4',lty=1,cex=0.2)
polygon(x=c(20,20,22,22),y=c(0.47,0.53,0.53,0.47),col="lightblue1",border = NA)
polygon(x=c(18,18,20,20),y=c(0.47,0.53,0.53,0.47),col="white",border = NA)
text(20, 0.5, "20%",cex=1.2)


#sigmoid = function(x) {
#  0.989 / (1 + exp(-0.15*(x-28)))
#}
#lines(x, sigmoid(x), col='dodgerblue',lty=1,cex=0.2)
#polygon(x=c(26,26,30,30),y=c(0.47,0.53,0.53,0.47),col="lightblue1",border = NA)
#text(28, 0.5, "A%",cex=1.2)


#sigmoid = function(x) {
#  0.99 / (1 + exp(-0.15*(x-35)))
#}
#lines(x, sigmoid(x), col='cadetblue3',lty=1,cex=0.2)
polygon(x=c(35,35,37,37),y=c(0.47,0.53,0.53,0.47),col="white",border = NA)
polygon(x=c(33,33,35,35),y=c(0.47,0.53,0.53,0.47),col="lightblue1",border = NA)
text(35, 0.5, "35%",cex=1.2)
text(35, 0.5, "35%",cex=1.2)


