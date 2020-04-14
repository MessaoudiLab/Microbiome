# **Required Modules:**  
**Trimmomatic: A flexible read trimming tool for Illumina NGS data:**
```module load trimmomatic/0.36```

**BBMap is a splice-aware global aligner for DNA and RNA sequencing reads:**
```module load BBMap/38.16```

**Bowtie2 is a short read aligner:**
```module load bowtie2/2.2.9```

**MetaBAT is a robust statistical framework for reconstructing genomes from metagenomic data:**
```module load metabat/0.32.4```

**SPAdes is a genome assembly algorithm:**
```module load SPAdes```

**Burrows-Wheeler Sequence aligner:**
```module load bwa/0.7.17```

**Samtools is a suite of programs for interacting with high-throughput sequencing data:**
```module load samtools/1.9```  

# **Trim raw illumina read, removing any adapters or low quality bases:**  
```java -jar /rhome/rhoadesn/Scripts/trimmomatic-0.36.jar PE -threads 48 -phred33 ${ID}_R1.fq.gz ${ID}_R2.fq.gz ./trimmed/${ID}_paired_trim_R1.fastq.gz ./trimmed/${ID}_unpaired_trim_R1.fastq.gz ./trimmed/${ID}_paired_trim_R2.fastq.gz ./trimmed/${ID}_unpaired_trim_R2.fastq.gz ILLUMINACLIP:/rhome/rhoadesn/Scripts/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36```

# **Align to host genome and keep any non-aligned reads**
```bowtie2 -q -p 48 -x /rhome/rhoadesn/bigdata/Shotgun_Metagenomics/NX_metagenomes_9_6_2017/hts.igb.uci.edu/rhoadesn17090685/4R040-L8/working_names/raw/db/Macaca_mulatta/Ensembl/Mmul_1/Sequence/Bowtie2Index/genome -1 ./trimmed/${ID}_paired_trim_R1.fastq.gz -2 ./trimmed/${ID}_paired_trim_R2.fastq.gz -U ./trimmed/${ID}_unpaired_trim_R1.fastq.gz -U ./trimmed/${ID}_unpaired_trim_R2.fastq.gz --quiet --un-conc-gz ./decon/${ID}.paired.decon.fastq.gz --un-gz ./decon/${ID}.unpaired.decon.fastq.gz 1> ${ID}_host.sam 2> ${ID}.alignment_stats.txt```

#  **Remove Sam file because we don't really care about the host genome alignment**
```rm ${ID}_host.sam```

# **Concatanate the QC and decontaminated sequence files**
```cat ./decon/${ID}.paired.decon.fastq.1.gz ./decon/${ID}.paired.decon.fastq.2.gz ./decon/${ID}.paired.decon.fastq.2.gz >> ./concat/${ID}_concat.fastq.gz```

\
