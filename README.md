# Zoonomia_Mutational_Signatures
A study of the evolutionary  mutational signatures inferred through the gVCF files and  FASTA files resourced from the Zoonomia Project

For each generation, is estimated that 100-200 new mutations enter the DNA, a process that together with recombination is thought to push evolution forward.
In this research, we analyzed the genetic data provided by the Zoonomia Consortium and deconvoluted evolutionary mutational signatures: a representation of 
mutational patterns over many generations of evolution of 119 eutherian mammalian species. A pipeline to calculate these signatures and to deconvolute them has
been built, hoping to shed light on similar mutational processes occurring in humans, and in human cancer cells. 

Due to uncertanty in the variant calling, the exact direction of the mutations is unknown ( e.g. A->C or C->A), so the results are are not informative in the form 
of a 96-entry vector, but just as a 48-entry vector. 

CONTENT OF THE REPOSITORY

-sort_scaffolds.sh : To sort the scafolds in th FASTA files and order them by scaffold number 

-fasta_TO_gav.sh : To eliminate the new line tab between scaffold number and DNA sequnece 

-Signature1.R : To read gVCF file and a modified FASTA file, and to build the mutational histogram 

-graph.R : To make the graph of the signature once the histogram has been calculated

-graph2.R : To make a "compressed" mutational signature, a 6-entry histogram where we do not account for the nearest neighbors of the mutated nucleotidee

-read_out.R : To read all the output files geenrated by "Signature1.R", build a matrix with all the mutational histograms, and prepare for deconvolution

-test_nmf.R  : To test the possible nuber of signatures to deconvolute, and then use nmf to do so. It also generates many graphs, depicts the deconvoluted
 signatures, and compare them with the ones in the COSMIC databse (generated from human cancer samples)
 
 -41586_2020_2876_MOESM3_ESM.csv : The list of animals that were analyzed by the Zoonomia consortium
 
 -"outfile_AcoCah.txt", "acocah.jpeg" and "acocah1.jpeg" re examnple of the ourputs of "Sigature1.R", "graph.R" and "graph2.R" respectively, for the animal 
 Acomys Cahirinus
 
 DATA AVAILABILITY
 
 gVCF files  : https://data.broadinstitute.org/200m_variation/
 
 HAL library : https://github.com/ComparativeGenomicsToolkit/hal
 
 HAL file  : https://cglgenomics.ucsc.edu/data/cactus/
