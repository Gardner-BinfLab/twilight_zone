#Graph with a quadruple width graph 1 and two double width graphs 2 & 3
test<-layout(matrix(c(1,1,1,1,
                      1,1,1,1,
                      2,2,3,3,
                      2,2,3,3),nrow=4,ncol=4,byrow=TRUE)) 
layout.show(test)

#Graph with Margins 4,5,6,7 & 8 with a quadruple width graph 1, a 2/3 width graph 2 and a 1/3 width graph  3 but the bottom two graphs are slightlt taller then the top one
test<-layout(matrix(c(8,4,4,4,4,4,4,4,4,4,4,7,
                      8,1,1,1,1,1,1,1,1,1,1,7,
                      8,1,1,1,1,1,1,1,1,1,1,7,
                      8,1,1,1,1,1,1,1,1,1,1,7,
                      8,1,1,1,1,1,1,1,1,1,1,7,
                      8,5,5,5,5,5,5,5,5,5,5,7,
                      8,2,2,2,2,2,2,3,3,3,3,7,
                      8,2,2,2,2,2,2,3,3,3,3,7,
                      8,2,2,2,2,2,2,3,3,3,3,7,
                      8,2,2,2,2,2,2,3,3,3,3,7,
                      8,2,2,2,2,2,2,3,3,3,3,7,
                      8,2,2,2,2,2,2,3,3,3,3,7,
                      8,6,6,6,6,6,6,6,6,6,6,7),nrow=13,ncol=12,byrow=TRUE)) 
layout.show(test)

#same as above but uses widths and heights to change up the size of the normally equally sized matric rows and columns
test<-layout(matrix(c(8,4,4,7,
                      8,1,1,7,
                      8,5,5,7,
                      8,2,3,7,
                      8,6,6,7),nrow=5,ncol=4,byrow=TRUE), heights = c(0.5,3,0.5,4,0.5), widths = c(0.25,3,2,0.25)) 
layout.show(test)

#same as above but only two graphs
test<-layout(matrix(c(3,4,7,
                      3,1,7,
                      3,5,7,
                      3,2,7,
                      3,6,7),nrow=5,ncol=3,byrow=TRUE), heights = c(0.5,3,0.5,5,0.5), widths = c(0.25,5,0.25)) 
layout.show(test)

