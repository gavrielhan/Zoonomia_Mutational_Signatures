####
# Sorting the Scaffolds in the .gav file 
#Input
# $1 .gav file


awk '
 
BEGIN { 
    FS="\t"; 
    
} 
       
{
  split($1,scaf_v,"_");
  if (length(scaf_v)>3 && scaf_v[4]+0 == scaf_v[4]){
      if(count_scaf[scaf_v[3]]<=scaf_v[4]){
        count_scaf[scaf_v[3]]=scaf_v[4];
        a[scaf_v[3]"_"scaf_v[4]]=$0;
      }
      else{
        a[scaf_v[3]"_"scaf_v[4]]=$0;
        }    
     }
    
  else {
   count_scaf[scaf_v[3]]=1; 
   a[scaf_v[3]"_0"]=$0;  
 }
}

END {
  for(i=0;i<length(count_scaf);i++) {
    for(j=0;j<=count_scaf[i];j++){
       if(a[i"_"j]){print(a[i"_"j]);}
 }
}

}
' $1  > $1_rfinal.gav