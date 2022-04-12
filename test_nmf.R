#install.packages("BiocManager")
#BiocManager::install("sigminer", dependencies = TRUE)
library(sigminer)

file_list <- list.files(path="C:/..../output") #the directory that contains just the output files
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


#run this tests to check the appropriate number of signatures to deconvolute 
if( !isCHECK() ){
  
  V <- tot_out
  y <- as.numeric(unlist(V))
  V<-matrix(y,nrow=96)
  
  # Use a seed that will be set before each first run
  res <- nmfEstimateRank(V, seq(3,20), method='brunet', nrun=10)
  # or equivalently
  res <- nmf(V, seq(3,20), method='brunet', nrun=10)
  
  # plot all the measures
  plot(res)
  # or only one: e.g. the cophenetic correlation coefficient
  plot(res, 'cophenetic')
  
  # run same estimation on randomized data
  rV <- randomize(V)
  rand <- nmfEstimateRank(rV, seq(3,20), method='brunet', nrun=10)
  plot(res, rand)
  
}

#deconvolute the signatures after running a second test to identify the apropriate number of signatures to deconvolute
newV<-t(V)
colnames(newV)<-mut$final
rownames(newV)<-1:119
e1<-bp_extract_signatures(newV, range = 8:20, n_bootstrap = 10, n_nmf_run = 15)
bp_show_survey2(e1, highlight = 7)
obj <- bp_get_sig_obj(e1, 7)
show_sig_profile(obj, mode = "SBS", style = "cosmic",params_label_size = 0.5, font_scale = 0.3)
show_sig_exposure(obj, rm_space = TRUE)
sim <- get_sig_similarity(obj, sig_db = "SBS")
if (require(pheatmap)) {
  pheatmap::pheatmap(sim$similarity)
}

write.csv(obj["Signature"][["Signature"]],"C:/..../signatures.csv", row.names = TRUE) #add your directory to save the econvoluted signatures 
