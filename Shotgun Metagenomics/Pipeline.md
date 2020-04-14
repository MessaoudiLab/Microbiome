# **Required Modules:**  
**Trimmomatic: A flexible read trimming tool for Illumina NGS data:**

**BBMap is a splice-aware global aligner for DNA and RNA sequencing reads:** 

**Bowtie2 is a short read aligner:** 

**MetaBAT is a robust statistical framework for reconstructing genomes from metagenomic data:** 

**SPAdes is a genome assembly algorithm:** 

**Burrows-Wheeler Sequence aligner:** 

**Samtools is a suite of programs for interacting with high-throughput sequencing data:**

```module load trimmomatic/0.36```

```module load BBMap/38.16```

```module load bowtie2/2.2.9```

```module load metabat/0.32.4```

```module load SPAdes```

```module load bwa/0.7.17```

```module load samtools/1.9``` 
# **A few notes before starting**
### **Before starting make the following directories to stay organized**
```mkdir trimmed decon concat```

All scripts should be ran from within a single directory, and they will write output to the proper place.

### **Editing scripts for your samples**
These scriprt use "${ID}" as a placeholder for unique sample names. Before running anything you should replace ${ID} with your sample name.


# **Step1: Trim raw illumina read, removing any adapters or low quality bases:**  
This is written for samples preped using Nextera. Adjust as needed.
Also make sure to change file names.

**Input:** Read1.fq.gz Read2.fq.gz

**Output (in the ./trimmed directory):** Read1_paired_trim_R1.fastq.gz Read1_unpaired_trim_R1.fastq.gz Read2_paired_trim_R2.fastq.gz Read2_unpaired_trim_R2.fastq.gz

```java -jar /rhome/rhoadesn/Scripts/trimmomatic-0.36.jar PE -threads 48 -phred33 ${ID}_R1.fq.gz ${ID}_R2.fq.gz ./trimmed/${ID}_paired_trim_R1.fastq.gz ./trimmed/${ID}_unpaired_trim_R1.fastq.gz ./trimmed/${ID}_paired_trim_R2.fastq.gz ./trimmed/${ID}_unpaired_trim_R2.fastq.gz ILLUMINACLIP:/rhome/rhoadesn/Scripts/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36```

# **Step2: Align to host genome and keep any non-aligned reads**
This is written for samples taken from a rhesus macaque. If using samples from another host such as human you will need to insert the correct host genome.

**Input:** Read1_paired_trim_R1.fastq.gz Read1_unpaired_trim_R1.fastq.gz Read2_paired_trim_R2.fastq.gz Read2_unpaired_trim_R2.fastq.gz

**Output (in the ./decon directory):** Read1.paired.decon.fastq.gz Read1.unpaired.decon.fastq.gz Read2.paired.decon.fastq.gz Read2.unpaired.decon.fastq.gz


```bowtie2 -q -p 48 -x /rhome/rhoadesn/bigdata/Shotgun_Metagenomics/NX_metagenomes_9_6_2017/hts.igb.uci.edu/rhoadesn17090685/4R040-L8/working_names/raw/db/Macaca_mulatta/Ensembl/Mmul_1/Sequence/Bowtie2Index/genome -1 ./trimmed/${ID}_paired_trim_R1.fastq.gz -2 ./trimmed/${ID}_paired_trim_R2.fastq.gz -U ./trimmed/${ID}_unpaired_trim_R1.fastq.gz -U ./trimmed/${ID}_unpaired_trim_R2.fastq.gz --quiet --un-conc-gz ./decon/${ID}.paired.decon.fastq.gz --un-gz ./decon/${ID}.unpaired.decon.fastq.gz 1> ${ID}_host.sam 2> ${ID}.alignment_stats.txt```

#  **Remove Sam file because we don't really care about the host genome alignment**
```rm ${ID}_host.sam```

# **Concatanate the QC and decontaminated sequence files**
```cat ./decon/${ID}.paired.decon.fastq.1.gz ./decon/${ID}.paired.decon.fastq.2.gz ./decon/${ID}.paired.decon.fastq.2.gz >> ./concat/${ID}_concat.fastq.gz```

# **Run humann2:**

**Metagenomic Phylogenetic Analysis:**
```module load metaphlan2``` 

**Shortread aligner:**
```module load bowtie2```

**DIAMOND is a sequence aligner for protein and translated DNA searches:**
```module load diamond```

**MinPath (Minimal set of Pathways) is a parsimony approach for biological pathway reconstructions using protein family predictions:**
```module load minpath```

**Coding module:**
```module unload python``` 

**Qiime2 is microbiome bioinformatics platform:**
```module load qiime2/2017.8``` 

**Coding language module:**  
```module load perl```
