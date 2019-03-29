###failed trial 1 WON'T DO MORE THEN THE FIRST FILE MOSTLY - SEE TRIAL 2 BELOW THAT ACTUALLY WORKS 
#library(taxonomizr)
#taxaNodes<-read.nodes('nodes.dmp') #fine
#taxaNames<-read.names('names.dmp') #fine

#dir<-"/home/stephmcgimpsey/Documents/Accessions_splitfiles/100_split_accs/tax/"
#filenames <- list.files("~/Documents/Accessions_splitfiles/100_split_accs/com", pattern="ACC*", full.names=TRUE)
#ldf <- lapply(filenames, read.csv)
#res <- lapply(ldf, summary)
#names <- substr(filenames, 73, 77)

#for (j in 1:length(filenames)){

 # taxa<-read.csv(filenames[[j]], header=FALSE) # fine
 # outfile_name=paste(dir, names[[j]], "_tax", sep="")
  #sink(outfile_name)
  
  #for (i in 1:length(taxa)){

   # taxaId<-accessionToTaxa(taxa[[i]],"/home/stephmcgimpsey/accessionTaxa.sql") #gets taxID
   # print(taxa[[i]], max.levels=0) #prints accession
   # print(taxaId) #prints taxID
   # taxonomy<-getTaxonomy(taxaId,taxaNodes,taxaNames)
   # print(taxonomy)
  #  print("%%") #prints %% as a way to break up the taxonomic sections

 # }
  
 # sink()
  
#}


##Attempt two were all accs are in same CSV but it only has 100 acc's per line so we will iterate through per line and spit out files with 100 species taxonomy info

library(taxonomizr)
taxaNodes<-read.nodes('nodes.dmp') #fine
taxaNames<-read.names('names.dmp') #fine


dir<-"/home/stephmcgimpsey/Documents/Accessions_splitfiles/100_split_accs/tax/"
taxa<-read.csv("/home/stephmcgimpsey/Documents/Accessions_splitfiles/100_split_accs/com/100_perLine_com", header=FALSE) # fine
taxa[1,1]

#filenames <- list.files("~/Documents/Accessions_splitfiles/100_split_accs/com", pattern="ACC*", full.names=TRUE)
#names <- substr(filenames, 73, 77)



for (j in 1:nrow(taxa)){ #foreach line in the CSV
  outfile_name=paste(dir, j, "_tax", sep="") #open up a new taxonomy storage file with row number in the file name
 
  sink(outfile_name) #begins writting stuff to the new taxonomy storage file
  
  ##use 
  
  for (i in 1:ncol(taxa)){ # for 
    
    taxaId<-accessionToTaxa(taxa[j,i],"/home/stephmcgimpsey/accessionTaxa.sql") #gets taxID
    print(taxa[j,i], max.levels=0) #prints accession
    print(taxaId) #prints taxID
    taxonomy<-getTaxonomy(taxaId,taxaNodes,taxaNames)
    print(taxonomy)
    print("%%") #prints %% as a way to break up the taxonomic sections
    
  }
  
  sink()
  print 
  
}


