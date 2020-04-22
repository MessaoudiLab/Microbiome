#!/bin/bash

#SBATCH --job-name=new_test_assembly
#SBATCH --output=arrayJob_%A_%a.out
#SBATCH --error=arrayJob_%A_%a.err
#SBATCH --array=1
#SBATCH --time=24:00:00
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2gb
#SBATCH --cpus-per-task 60

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
conda init bash
source activate qiime2-2019.10

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]'   --input-path seqs/   --input-format CasavaOneEightSingleLanePerSampleDirFmt   --output-path demux-paired-end.qza

qiime demux summarize   --i-data demux-paired-end.qza   --o-visualization demux.qzv
