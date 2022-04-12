install.packages("NMF")
library(dplyr)
library(reshape2)
library(kableExtra)
library(ggplot2)
library(gridExtra)
library(BSgenome.Hsapiens.UCSC.hg19)
library(NMF)
# Load mutSignatures
library(mutSignatures)

setwd("C:/Users/gavri/Desktop/output")
file_list <- list.files(path="C:/Users/gavri/Desktop/output")
tot_out <- rep(0,96)
tot_out<- as.data.frame(tot_out)
for (i in file_list){
  myData<-read.delim(i, header = TRUE, sep = "\t", dec = ".")
  vec <- myData[length(myData[,1]),1]
  vec<-substring(vec,5)
  vec<-as.double(unlist(strsplit(vec, ',')))
  tot_out<-cbind(tot_out,vec)
}
tot_out[,1]<-NULL

#Let us deconvolute the signatures, to do so we must decide a number of signatures to obtain, but we will try more numbers and then compre the results 
num_sig<-4:30
aout<-nmf(tot_out,rank = num_sig)
#A ??? WH
w <- aout@fit@W #signatures 
h <- aout@fit@H

