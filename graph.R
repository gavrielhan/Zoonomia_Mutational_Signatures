setwd("C:/Users/gavri/Desktop/Cancer/Mut Signatures/VCF")
mut<-data.frame(read.csv('SBS_signatures_genome_builds.csv'))
colnames(mut)<-c('Type','Subtype')
mut<-mut[order(mut$Type),]
for (i in 1:96) {
  mut$final[i]<-paste0(substr(mut$Subtype[i],1,1),"[",mut$Type[i],"]",substr(mut$Subtype[i],3,3))
}

hist_mut<-data.frame(hist_mut)
rownames(hist_mut)<-mut$final
hist_mut<-as.matrix(hist_mut)
hist_mut<-t(hist_mut)

library(ggplot2)
 
frequencyPlot<-function(yourMatrixHere){
  
  NAMES96Vec<-colnames(yourMatrixHere)
  
  color<-factor(substr(NAMES96Vec,3,5))
  
  colors<-as.character(factor(substr(NAMES96Vec,3,5),labels = c("#03bdee","#000000","#e52a25","#97989c","#a3ce62","#a6844e")))
  
  PLOT<-ggplot(NULL,cex =0.3, aes(x = factor(x = NAMES96Vec,levels = NAMES96Vec), y = yourMatrixHere,fill =color)) +
    
    geom_col(color="black",size = 1)+
    
    theme_classic()+
    
    ylab("")+
    
    theme(axis.text.x = element_text(angle = 90,vjust = 0.33, hjust=0.5,size = 13,colour=colors,face = "bold"))+
    
    theme(axis.title.x = element_blank(),
          
          legend.title = element_blank(),
          
          legend.text = element_text(size=26),
          
          axis.text.y = element_text(size=14))+
    
    scale_y_continuous(labels = scales::percent)+
  
  scale_fill_manual(values = c("#03bdee","#000000","#e52a25","#97989c","#a3ce62","#a6844e"))

# ggtitle("mutational profile: cosmic.v3.may2019")

PLOT

}
dev.new(width=10, height=4)
frequencyPlot(hist_mut)


