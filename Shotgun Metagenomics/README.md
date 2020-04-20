This is ready to test (4/20/20)

# **Basic read processing**

## **Required Modules:**  
- **Trimmomatic: A flexible read trimming tool for Illumina NGS data:**
- **Bowtie2 is a short read aligner:** 

```module load trimmomatic/0.36```

```module load bowtie2/2.2.9```

## **A few notes before starting**
### **Before starting make the following directories to stay organized**
```mkdir trimmed decon concat```

All scripts should be ran from within a single directory, and they will write output to the proper place.

### **Editing scripts for your samples**
These scriprt use "${ID}" as a placeholder for unique sample names. Before running anything you should replace ${ID} with your sample name.


## **Step1: Trim raw illumina read, removing any adapters or low quality bases:**  
This is written for samples preped using Nextera. Adjust as needed.
Also make sure to change file names.

- **Input:** Read1.fq.gz Read2.fq.gz
- **Output (in the ./trimmed directory):** Read1_paired_trim_R1.fastq.gz Read1_unpaired_trim_R1.fastq.gz Read2_paired_trim_R2.fastq.gz Read2_unpaired_trim_R2.fastq.gz

```java -jar /rhome/rhoadesn/Scripts/trimmomatic-0.36.jar PE -threads 48 -phred33 ${ID}_R1.fq.gz ${ID}_R2.fq.gz ./trimmed/${ID}_paired_trim_R1.fastq.gz ./trimmed/${ID}_unpaired_trim_R1.fastq.gz ./trimmed/${ID}_paired_trim_R2.fastq.gz ./trimmed/${ID}_unpaired_trim_R2.fastq.gz ILLUMINACLIP:/rhome/rhoadesn/Scripts/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36```

## **Step2: Align to host genome and keep any non-aligned reads**
This is written for samples taken from a rhesus macaque. If using samples from another host such as human you will need to insert the correct host genome.

- **Input:** Read1_paired_trim_R1.fastq.gz Read1_unpaired_trim_R1.fastq.gz Read2_paired_trim_R2.fastq.gz Read2_unpaired_trim_R2.fastq.gz
- **Output (in the ./decon directory):** Read1.paired.decon.fastq.gz Read1.unpaired.decon.fastq.gz Read2.paired.decon.fastq.gz Read2.unpaired.decon.fastq.gz

```bowtie2 -q -p 48 -x /rhome/rhoadesn/bigdata/Shotgun_Metagenomics/NX_metagenomes_9_6_2017/hts.igb.uci.edu/rhoadesn17090685/4R040-L8/working_names/raw/db/Macaca_mulatta/Ensembl/Mmul_1/Sequence/Bowtie2Index/genome -1 ./trimmed/${ID}_paired_trim_R1.fastq.gz -2 ./trimmed/${ID}_paired_trim_R2.fastq.gz -U ./trimmed/${ID}_unpaired_trim_R1.fastq.gz -U ./trimmed/${ID}_unpaired_trim_R2.fastq.gz --quiet --un-conc-gz ./decon/${ID}.paired.decon.fastq.gz --un-gz ./decon/${ID}.unpaired.decon.fastq.gz 1> ${ID}_host.sam 2> ${ID}.alignment_stats.txt```

##  **Step2a: Remove Sam file because we don't really care about the host genome alignment and the file is large**
```rm ${ID}_host.sam```

## **Step3: Concatanate the QC and decontaminated sequence files**
Some downstream analysis don't care about paired end reads and work best with a single concatenated file for each sample.

**Input:** Read1.paired.decon.fastq.gz Read1.unpaired.decon.fastq.gz Read2.paired.decon.fastq.gz Read2.unpaired.decon.fastq.gz

**Output (in the ./concat directory):** SampleID_concat.fastq.gz

```cat ./decon/${ID}.paired.decon.fastq.1.gz ./decon/${ID}.paired.decon.fastq.2.gz ./decon/${ID}.paired.decon.fastq.2.gz >> ./concat/${ID}_concat.fastq.gz```

## **Functional and taxonomic annotation for short reads**
This will run the basic humann2 pipline. Using the chocophlan and UniRef50 database. This works best for rhesus samples but please read up on the best databases to use for your samples. UniRef90 is the default for human gut microbiome.
More info and a full tutorial can be found at [Humann2 resource](https://bitbucket.org/biobakery/biobakery/wiki/humann2)

You will also run metaphlan2 which assigns taxonomy of short reads based on single copy marker genes.
More info and a tutorial can be found here [Metaphlan2 resource](https://bitbucket.org/biobakery/biobakery/wiki/metaphlan2)


## **Required Modules:**  
- **Metaphlan2: Metagenomic Phylogenetic Analysis:**
- **Bowtie2 is a short read aligner:**
- **DIAMOND is a sequence aligner for protein and translated DNA searches:**
- **MinPath (Minimal set of Pathways) is a parsimony approach for biological pathway reconstructions using protein family predictions:**
- **Python Coding language: This will clash with running humann2**
- **Qiime2 is microbiome bioinformatics platform: Humann2 is currenly within this environment**
```module load metaphlan2``` 

```module load bowtie2```

```module load diamond```

```module load minpath```

```module unload python``` 

```module load qiime2/2017.8``` 

## **Step1: Run humann2**

- **Input (a single .fq.gz file that contains all QC'd reads for a sample):** SampleID_concat.fastq.gz
- **Otuput (there are 3 output file for gen abundance pathway abundance and pathway coverage):**

```humann2 -i ./concat/${ID}.fastq.gz -o ./outhumann --nucleotide-database /rhome/rhoadesn/bigdata/chocophlan/ --protein-database /rhome/rhoadesn/bigdata/uniref50/ --metaphlan-options=--ignore_viruses --threads 60 --remove-temp-output --o-log ./outhumann/${ID}.txt```

## **Step2: Run Metaphlan2**
This will only output species level taxonomy and also excludes viruses. See Metaphlan tutorial above to if you need other taxonomy levels.
- **Input (a single .fq.gz file that contains all QC'd reads for a sample):** SampleID_concat.fastq.gz
- **Otuput (a single text file):**


# **Genome assembly**
This section will assemble genomes from 

## **Required Modules:**  
- **BBmap: add info**
- **Bowtie2: is a short read aligner** 
- **metabat: Binning software**
- **SPAdes: assembly software** 
- **BWA: another short read aligner**


`module load BBMap/38.16`

`module load bowtie2/2.2.9`

`module load metabat/0.32.4`

`module load SPAdes`

`module load bwa/0.7.17`

`module load samtools/1.9`

## **A few notes before starting**
All scripts should be ran from within a single directory that you were previously working in.

### **Editing scripts for your samples**
These scriprt use "${ID}" as a placeholder for unique sample names. Before running anything you should replace ${ID} with your sample name.

### Assembly of short reads
`spades.py --meta -1 ./decon/${ID}.paired.decon.fastq.1.gz -2 ./decon/${ID}.paired.decon.fastq.2.gz -s ./decon/${ID}.unpaired.decon.fastq.gz -o ./assemblies/${ID}_spades_assembly -t 48`

### Concatanate the QC and decontaminated sequence files
`cat ./decon/${ID}.paired.decon.fastq.1.gz ./decon/${ID}.paired.decon.fastq.2.gz ./decon/${ID}.unpaired.decon.fastq.gz > ./concat/${ID}_concat.fastq.gz`

### Filter out contigs under 1kb
`reformat.sh in=./assemblies/${ID}_spades_assembly/contigs.fasta out=./1kb_contigs/${ID}_1kb.fasta minlength=1000`

## Index contigs for depth mapping
`bwa index -a bwtsw ./1kb_contigs/${ID}_1kb.fasta`

## Map short reads to assembled contigs
`bwa mem -t 48 ./1kb_contigs/${ID}_1kb.fasta  ./concat/${ID}_concat.fastq.gz > ${ID}.sam`

### Convert sam file to sorted bam
`samtools view -bu ${ID}.sam | samtools sort -T ${ID} -o ${ID}.sorted.bam -@ 48`

### Clean up after yourself and remove the big .SAM file
`rm ${ID}.sam`

### Generate genomic bins based on Depth and tetranucleotide frequency
`runMetaBat.sh ./1kb_contigs/${ID}_1kb.fasta ${ID}.sorted.bam`

### Move bins to a new location because metabat will not play nice
`mv *-bins-* ./bins`
