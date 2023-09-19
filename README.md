# DroneGenes

## Collection and Dissection
we placed a single drone comb (Mann Lake, MN, USA) into three colonies from each breeding for a total of 15 colonies. Drone cells were measured after the experiment and there was no differences in cell size between the 15 colonies. The drones were raised in the same colony until 3 days before eclosion. The drone comb was not placed into non-related colonies to prevent drone cannibalism. The drone comb was placed into an incubator with a temperature of 35C. Once the drones emerged, a total of 1800 drones were marked with RFID tags (Microsensys, GA, USA). This included 450 drones from each line and 150 from each colony. A UV setting glue (JSI Fly Fishing, USA) was used to attach the RFID tags, which allows the tag to be bonded instantly with a UV LED light (TaoTronics).

Drones were collected at ages 10, 14, and 20. A previous study found sperm concentration increased immediately after emergence, maximize at two weeks, and then decreased. Thus, these chosen days likely represent reproductive senescence in honey bee drones and allows us to measure variation in sperm migration and sperm concentration. Ninety drones were collected from each line during each time point (30 from each colony) and sperm was collected similar to other published protocols. Sexually mature drones were stimulated to ejaculate by pressing on the thorax and/or removing the head. This usually resulted in partial eversion of the penis. We applied furthur pressure on the abdomen to force hemolymph to the penis and release the cream colored sperm.  If semen was not found at the end of the endophallus, than this indicated non-maturity. We chose this methods because it measures the sperm drones would use during mating. A more common method measures sperm in the seminal vesicles, which only measures the sperm migrating from the testes to the seminal vesicles, but it does not accurately measure the sperm drones would use during mating or whether drones were mature. 

## Tag-seq Pre-processing
This code was for the Tag-seq processing. First, Kallisto (v0.45) was used to quantify transcript abundance from our Tag-seq dataset (Bray et al. 2016). Pseudoalignments were completed using the latest version of the Apis mellifera transcriptome (Amel_HAv3.1; (Wallberg et al. 2019)), with an average fragment length of 100 bp and a standard deviation of fragment length of 20. Second, the count data was analyzed with DeSeq2 (Anders and Huber 2012), removing any gene with fewer than 10 read counts across all samples. The counts were then normalized using FPKM (Fragments Per Kilobase of transcript per Million mapped reads) for all downstream analysis. 

## 00-RFID Flight Processing
Thi


## 01-Heritability

## 02-Radar Plot

## 03-BIPlot

## 04-Data input

## 05-Power and Network construction

## 06-Linking traits to modules

## 07-Module connectivity

## 08-HUB Gene Expression with trait senescence


