# **QIIME2 Updated 4/21/20*
This pipeline is based on QIIME2 2019.10
And follows the Moving Pictures tutorial that can be found here. [Moving Picutres Tutorial](https://docs.qiime2.org/2019.10/tutorials/moving-pictures/)
QIIME2 has very good documentation and almost all questions can be answered here. [QIIME2](https://qiime2.org/)

#### **The scripts I have added here are to run QIIME2 analysis in the UCR cluster slurm framework.**

## *Importing Data*

```

```


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
