#SBATCH --job-name=new_test_assembly
#SBATCH --output=arrayJob_%A_%a.out
#SBATCH --error=arrayJob_%A_%a.err
#SBATCH --array=1
#SBATCH --time=24:00:00
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=6gb
#SBATCH --cpus-per-task 60

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
conda init bash
source activate qiime2-2019.10

qiime feature-classifier classify-sklearn --i-classifier /rhome/rhoadesn/bigdata/database/silva-132-99-nb-classifier.qza --i-reads rep-seqs-dada2-240-240.qza --o-classification taxonomy-silva-240-240.qza --p-n-jobs 60
