#!/bin/bash
#SBATCH -p cpu-ondemand
#SBATCH --mem=120G

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate plink2
cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/sNMF/Alpha100/
plink2 \
  --bfile /storage/simple/users/durandk/scratch_durandk/GenFAW600/PCA_596ind/PCA_ALL/GenFAW600_Whole_biallelic_geno08_Pruned0.5 \
  --chr-set 29 \
  --allow-extra-chr \
  --remove remove_ASW7.txt \
  --recode vcf \
  --out GenFAW600_Whole_biallelic_geno08_Pruned0.5_noASW7
