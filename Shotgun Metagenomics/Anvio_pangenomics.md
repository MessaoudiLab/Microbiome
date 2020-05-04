

# **Anvio pangenomics pipeline**
Since the microbiome of monkeys is not that well characterized, we often rely on genome assemblies to find microbes associated
associated with a disease state.

Anvio is a great program with functionallity well beyond this simple pipeline and really good documentation amd tutorials can be found here.
[Anvio Website](http://merenlab.org/software/anvio/)
[Anvio Pangenome Tutorial](http://merenlab.org/2016/11/08/pangenomics-v2/)

** Special note **
While anvio can be run on the cluster, it uses a web based data visualization tool that works better if you run Anvio locally.

Local installation is easy and directions can be found here.
[Anvio Conda Installation](http://merenlab.org/2016/06/26/installation-v2/)
When installing, Anvio will download all needed programs, within its virtual environment.

## **Enter the virtual environment:**  
```soure activate Anvio-6.1```


## **A few notes before starting**
### **Very important that all of your genomes of interest are in a single directory, alone.**

All scripts should be ran from within a single directory, and they will write output to the proper place.

## **Step1A: Make anvio databases:**
This step makes a kmer profile of your genome and identifies ORF using prodigal.
(It does not assign function)

One samples at a time
``` anvi-gen-contigs-database -f contigs.fa -o contigs.db```

## **Step1B: Assign COG function:**
This step takes a while and sometimes fails. It is not mandatory, but you will appreciate it later.

```anvi-run-ncbi-cogs contigs.db```



## **Step2: Import into Anvio:**  
You will need to make a text file that lists all of your input genome names and the path to the files.

See anvio pangenome analysis for example. For some reason genome names cannot start with a number.

```anvi-gen-genomes-storage -e external-genomes.txt -o Input-GENOMES.db```


## **Step3: Pangenome analysis:** 
This step actually conducts the pangenome anylsis, comparing gene content, constructing basic trees etc.

```anvi-pan-genome -g Input-GENOMES.db -n PROJECT_NAME --exclude-partial-gene-calls```

## **Step4: Display the pangenome:** 
 This script will open a Chrome window with your pan genome. 

``` anvi-display-pan -g INPUT-GENOMES.db -p PROJECT_NAME/MY-PAN.db```

## ** The rest:**
There are about 12 other scripts to really make this thing look good, they are all explained well in the Anvio documentation.
[Anvio Pangenome Tutorial](http://merenlab.org/2016/11/08/pangenomics-v2/)


Also consider using anvio for your other phylogenomic and metagenomic needs!!
