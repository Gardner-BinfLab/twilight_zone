matrix<-c(10,100,1000)
matrix2<-c(0.25,1.92,18.15)
matrix3<-rbind(matrix,matrix2)
matrix3<-t(matrix3)
plot(matrix3)
lines(lowess(matrix3))
coef(matrix3)
model<-lm(matrix~matrix2)
coef(model)
