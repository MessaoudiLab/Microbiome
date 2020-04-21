# **QIIME2 Updated 4/21/20*
This pipeline is based on QIIME2 2019.10
And follows the Moving Pictures tutorial that can be found here. [Moving Picutres Tutorial](https://docs.qiime2.org/2019.10/tutorials/moving-pictures/)
QIIME2 has very good documentation and almost all questions can be answered here. [QIIME2](https://qiime2.org/)

#### **The scripts I have added here are to run QIIME2 analysis in the UCR cluster slurm framework.**
This allow the user to run th

## *Step1: Importing Data*
To run this batch script you will need to create a directory with all of you sequence files in a fastq.gz. 

Unless you edit the script the directory must be called **seqs**

To use this script file names must be in the Casava format ex. SampleID_L001_R1_001.fastq.gz

For importing other formats of data see. [QIIME2 importing data](https://docs.qiime2.org/2019.10/tutorials/importing/)


```
Qiime2_import_dada.sh
```
Input: Directory of sequencing files called seqs

Output1: demux-paired-end.qza

Output2: demux.qzv

**If you are having trouble and want to run this script outside of the queueing system see section 2**


## **Step2: Sequence quality control and feature table construction**
In this step we use the program dada2 but there are other options. See QIIME2 documentation for other options and troubleshooting.



## **Getting into a QIIME environment:**  
This is just a little trick to make sure that our cluster and QIIME2 are speaking the same language. 
Then entering the QIIME2 virtual environment

```
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
conda init bash
source activate qiime2-2019.10
```

## **Importing data**
>Paired End
```qiime tools import 
--type 'SampleData[PairedEndSequencesWithQuality]'   
--input-path ./seqs/   
--input-format CasavaOneEightSingleLanePerSampleDirFmt   
--output-path demux-pairedend.qza```

>Single end


```module load trimmomatic/0.36```

```module load bowtie2/2.2.9```

## **A few notes before starting**
### **Before starting make the following directories to stay organized**
```mkdir trimmed decon concat```

All scripts should be ran from within a single directory, and they will write output to the proper place.
