#!/bin/bash
#SBATCH -p cpu-ondemand
#SBATCH --mem=120G


module load bioinfo-cirad
module load java/jre1.8.0_31

cd /lustre/durandk/GenFAW600/sNMF/

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate plink2
plink2 --bfile GenFAW600_Whole_569_Pruned \
 	--chr-set 29 \
 	--allow-extra-chr \
       --geno 0.8 \
       --recode vcf  \
       --out GenFAW600_geno0.8
