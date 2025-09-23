#!/bin/bash
#SBATCH -p cpu-ondemand
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8

set -euo pipefail
# ==============================
# ENVIRONNEMENTS
# ==============================
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

# ==============================
# CONFIG
# ==============================


#bcftools concat    --threads 4   --output-type z  --output GenFAW600_Whole.vcf.gz GenFAW600_autosome.vcf.gz GenFAW600_rename_29.vcf.gz 
 
#bcftools index GenFAW600_Whole.vcf.gz


# ==============================
# Conversion en PLINK
# ==============================
conda activate plink2
cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF_filtering/ALL

#plink2  --vcf GenFAW600_Whole.vcf.gz \
#  --make-bed \
#  --set-all-var-ids  '@:#:$r:$a' \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --out GenFAW600_Whole


#plink2 --bfile GenFAW600_Whole \
#       --chr-set 29 \
#       --allow-extra-chr \
#       --missing \
#        -out GenFAW600_Whole_missing

plink2 --bfile GenFAW600_Whole \
  --chr-set 29 \
  --allow-extra-chr \
  --import-max-alleles 2 \
  --remove remove_samples_whole_0.85.txt \
  --make-bed \
  --out GenFAW600_Whole_569
  

plink2 --bfile GenFAW600_Whole_569 \
	  --chr-set 29 \
	  --allow-extra-chr \
	  --indep-pairwise 50 5 0.2 \
	  --out GenFAW600_Whole_569_LDprune

plink2 --bfile GenFAW600_Whole_569 \
	  --chr-set 29 \
	  --allow-extra-chr \
	  --extract GenFAW600_Whole_569_LDprune.prune.in \
	  --make-bed \
	  --out GenFAW600_Whole_569_Pruned

# ==============================
# PCA
# ==============================
plink2 --bfile GenFAW600_Whole_569_Pruned \
	   --chr-set 29 \
	  --allow-extra-chr \
	  --pca \
	  --out GenFAW600_Whole_569_Pruned_PCA






