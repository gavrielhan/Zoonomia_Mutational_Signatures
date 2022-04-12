
#####
# Changing a fasta file to a format that R can use in a simpler way
#
# Input 
# $1 a fsata file
# e.g. exAcoCah_457944.fasta

awk '{

       split($1,a,">");
       n=n+1;
       if(n==1){
               printf $0"\t"}
       else{ if(length(a)>1&&n>1)
                 {printf "\n"$0"\t"} 
             else {printf $0}
       }


}' $1  > $1.gav
