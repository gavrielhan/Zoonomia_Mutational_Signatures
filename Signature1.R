#!/Local/bfe_maruvka/R-3.6.3/bin/Rscript
#install.packages("vcfR")
library(vcfR)
AcoCah_vcf<-read.vcfR("CanFam_VD1.vcf.gz") #open the vcf file that you want to analyze
AcoCah_vcf<-data.frame(AcoCah_vcf@fix)
AcoCah_vcf$ALT<-sub(',<NON_REF>',"",AcoCah_vcf$ALT)

#eliminate indels

AcoCah_vcf$REF<-as.character(AcoCah_vcf$REF)
AcoCah_vcf<-AcoCah_vcf[nchar(AcoCah_vcf$ALT)==1,]
AcoCah_vcf<-AcoCah_vcf[nchar(AcoCah_vcf$REF)==1,]

#make the mutation type list 
mut<-data.frame(read.csv('SBS_signatures_genome_builds.csv'))
colnames(mut)<-c('Type','Subtype')
mut<-mut[order(mut$Type),]
for (i in 1:96) {
  mut$final[i]<-paste0(substr(mut$Subtype[i],1,1),"[",mut$Type[i],"]",substr(mut$Subtype[i],3,3))
}


#make the sequence matrix, finalscaf will be a matrix containing scaffolds and the respective sequence  

con<-file("CanLup_584697.fasta.gav_rfinal.gav","r")# open the fasta.gav file corresponding to the vcf
i<-1
itr<-1
nscaff<-AcoCah_vcf[!duplicated(AcoCah_vcf$CHROM),1]
hist_mut<-replicate(96,0)
h<-rep("N",3)
g<-rep("N",3)

while(i<=length(nscaff)) {
  line<-readLines(con,1)
  scaf<-strsplit(line,"\t")
  if(identical(line,character(0))) {break}
  while (is.na(scaf[[1]][1])) {
    line<-readLines(con,1)
    scaf<-strsplit(line,"\t")
    if(identical(line,character(0))) {break}
  }
  p0<-paste0(">",nscaff[i])
  if (scaf[[1]][1]==p0) {
#we can check the sequence in the scaffold
    scaf<-strsplit(scaf[[1]][2],"") 
#we are now going to look at all the mutations in that scaffold 
    while(AcoCah_vcf[itr,1]==nscaff[i] && itr<=length(AcoCah_vcf[,1])){
      pos<-as.numeric(AcoCah_vcf[itr,'POS'])
      trp<-toupper(paste0(scaf[[1]][pos-1],scaf[[1]][pos],scaf[[1]][pos+1]))
#define type of mutation 
      
      typm<-paste0(AcoCah_vcf$REF[itr],'>',AcoCah_vcf$ALT[itr])
      
#in case the mutation has to be reversed, we do so

      if (!typm %in% mut$Type) {
        trp<-strsplit(trp,"")
        typm<-strsplit(typm,"")
 
        for (b in (1:3)) {  
          if(!is.na(trp[[1]][b])){
            if (trp[[1]][b]=="A") {h[b]<-"T"}
            else if (trp[[1]][b]=="T") {h[b]<-"A"}
            else if (trp[[1]][b]=="G") {h[b]<-"C"}
            else if(trp[[1]][b]=="C") {h[b]<-"G"}
            if (typm[[1]][b]=="A") {g[b]<-"T"}
            else if (typm[[1]][b]=="T") {g[b]<-"A"}
            else if (typm[[1]][b]=="G") {g[b]<-"C"}
            else if(typm[[1]][b]=="C") {g[b]<-"G"}
            else {g[b]<-">"}
           }
        }
        trp<-paste0(h[1],h[2],h[3])
        typm<-paste0(g[1],g[2],g[3])
      }
 #..... typm is mutation type, remember the mutation happen in both strands
 #find position of mutational histogram to which +1 must be added 
      fin<-paste0(substr(trp,1,1),"[",typm,"]",substr(trp,3,3))
      ind<-which(mut$final %in% fin)
      hist_mut[ind]<-hist_mut[ind]+1
      itr<-itr+1  
    }
    i<-i+1
  }
}
print(itr)
print(i)
#make graph of mutational signature 

hist_mut<-hist_mut/sum(hist_mut)
hist_mut<-data.frame(hist_mut)
rownames(hist_mut)<-mut$final
hist_mut<-as.matrix(hist_mut)
hist_mut<-t(hist_mut)
print(paste(as.character(hist_mut[1,]), collapse=", "))
