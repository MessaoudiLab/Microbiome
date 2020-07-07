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
source activate qiime2-2020.6
module unload R

qiime dada2 denoise-paired --i-demultiplexed-seqs demux-paired-end.qza --o-representative-sequences rep-seqs-dada2.qza --o-table table-dada2.qza --p-trim-left-f 1 --p-trim-left-r 1 --p-trunc-len-f 240 --p-trunc-len-r 240 --p-n-threads 60 --o-denoising-stats stats-dada2.qza

qiime feature-table summarize --i-table table-dada2.qza --o-visualization table.qzv 

qiime phylogeny align-to-tree-mafft-fasttree --i-sequences rep-seqs-dada2.qza --o-alignment aligned-rep-seqs.qza --o-masked-alignment masked-aligned-rep-seqs.qza --o-tree unrooted-tree.qza --o-rooted-tree rooted-tree.qza --p-n-threads 60
