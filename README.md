# DroneGenes

## Collection and Dissection
we placed a single drone comb (Mann Lake, MN, USA) into three colonies from each breeding for a total of 15 colonies. Drone cells were measured after the experiment and there was no differences in cell size between the 15 colonies. The drones were raised in the same colony until 3 days before eclosion. The drone comb was not placed into non-related colonies to prevent drone cannibalism. The drone comb was placed into an incubator with a temperature of 35C. Once the drones emerged, a total of 1800 drones were marked with RFID tags (Microsensys, GA, USA). This included 450 drones from each line and 150 from each colony. A UV setting glue (JSI Fly Fishing, USA) was used to attach the RFID tags, which allows the tag to be bonded instantly with a UV LED light (TaoTronics).

Drones were collected at ages 10, 14, and 20. A previous study found sperm concentration increased immediately after emergence, maximize at two weeks, and then decreased. Thus, these chosen days likely represent reproductive senescence in honey bee drones and allows us to measure variation in sperm migration and sperm concentration. Ninety drones were collected from each line during each time point (30 from each colony) and sperm was collected similar to other published protocols. Sexually mature drones were stimulated to ejaculate by pressing on the thorax and/or removing the head. This usually resulted in partial eversion of the penis. We applied furthur pressure on the abdomen to force hemolymph to the penis and release the cream colored sperm.  If semen was not found at the end of the endophallus, than this indicated non-maturity. We chose this methods because it measures the sperm drones would use during mating. A more common method measures sperm in the seminal vesicles, which only measures the sperm migrating from the testes to the seminal vesicles, but it does not accurately measure the sperm drones would use during mating or whether drones were mature. 

## Tag-seq Pre-processing
This code was for the Tag-seq processing. First, Kallisto (v0.45) was used to quantify transcript abundance from our Tag-seq dataset (Bray et al. 2016). Pseudoalignments were completed using the latest version of the Apis mellifera transcriptome (Amel_HAv3.1; (Wallberg et al. 2019)), with an average fragment length of 100 bp and a standard deviation of fragment length of 20. Second, the count data was analyzed with DeSeq2 (Anders and Huber 2012), removing any gene with fewer than 10 read counts across all samples. The counts were then normalized using FPKM (Fragments Per Kilobase of transcript per Million mapped reads) for all downstream analysis. 

## 00-RFID Flight Processing
This code was used to filter and analyze raw RFID flight data for downstream analysis. Raw flight data is in Supplementary Table 6. 

## 01-Heritability (See HTML for output)
This code was used to estimate heritability for drone reproductive traits and expression patterns. See HTML for data output. 

## 02-BIPlot (See HTML for output)
This code was used to view relationships between traits. See HTML for data output.

## 03-Data input (See HTML for output)
This code was used to input expression (Seperately for brain and gonads) and trait data. This includes kallisto to quantify gene expression. See HTML for data output.

## 04-Power and Network construction, and connectivity (See Supplementary Figures for outputs)
This code was use for gene network construction, module detection, and connectivity (Seperately for brain and gonads).This includes choosing the soft-thresholding power: analysis of network topology.

The blockwiseModules function was used to construct the brain and gonad co-expression networks and detect modules for the 8,504 genes. The parameters for co-expression network construction were optimized by checking different values using an automatic block-wise network construction and module detection method. After examining the scale-free topology fit index curve (Supplementary Figure S1, S2), a soft threshold power of 6 (high scale-free, R2 > 0.85) was found to be suitable for both brain and gonads (Langfelder and Horvath 2008). This thresholding applies a connection weight to gene pairs. The topological overlap matrix (TOM) was generated using a TOMtype unsigned approach, which views highly associated genes as having a strong connection strength (Langfelder 2013). The Partioning Around Medoids (PAM) option in cutreeDynamic was then used, as it is more robust to noise and outliers than k-means (Horvath 2011). These parameters were coupled with the recommended default settings for both minimum module size (30) and sensitivity (deepSplit=2) (Zhang and Horvath 2005). The modules were then merged using the mergeCutHeight function set at 0.30 (Supplementary Figure S3, S4).

Module connectivity was produced using an eigengene-based connection (MM equivalent module membership) (Sancho et al. 2022). MM is a measure of correlation between a gene's expression profile and the module eigengene (ME) of a given module. Values close to 1 (absolute value) indicate strong connections between genes and the module; therefore, MM denotes the strength of the connection between a gene and the eigengene of the module (Zhang and Horvath 2005) Genes with an absolute MM value greater than 0.9 are considered hub genes (Sancho et al. 2022).

## 05-Linking traits to modules (See Figures and Supplementary Figures for Outputs)
This code was used to link traits to modules. To measure module-trait relation, Spearman's correlation and p-values between module eigenvalues and the traits were estimated, followed by a Fisher's exact test to calculate overlap between shared brain and gonadal modules.

## 06-Module connectivity (See HTML for output)
This code was used for additional connectivity analysis along with Hub gene identificaiton (Seperately for brain and gonads). 

## 07-Data input for consensus module (See HTML for output)
This code was used to input brain and gonad data for consensus module.

## 08-Consensus Power and Network construction
We have chosen the soft thresholding power 6, minimum module size 30, the module detection sensitivity deepSplit
2, cut height for merging of modules 0.20 (implying that modules whose eigengenes are correlated above 1 −0.2 =
0.8 will be merged), we requested that the function return numeric module labels rather than color labels, we
have effectively turned off reassigning genes based on their module eigengene-based connectivity KME, and we
have instructed the code to save the calculated consensus topological overlap.

## 09-Corresponding Modules (See Figures and Supplementary Figures for Outputs)
This code was used to find the corresponding modules between the brain and gonad networks. This was used to find the genes (including hub genes) that overlap between the gonad and brain modules. 




