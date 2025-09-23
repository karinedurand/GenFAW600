#!/bin/bash
#SBATCH --job-name=plink_all
#SBATCH -p cpu-ondemand
#SBATCH --mem=50G


# ==============================
# ENVIRONNEMENTS
# ==============================
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate plink2

plink2 \
  --vcf GenFAW600_rename_29.vcf.gz \
  --make-bed \
  --chr-set 29 \
  --allow-extra-chr \
  --set-all-var-ids @:#:\$r:\$a \
  --max-alleles 2 \
  --min-alleles 2 \
  --max-missing 0.1 \
  --out GenFAW600_Z
  
# ==============================
# 3. Calculer la missingness
# ==============================

## Z
plink2  --bfile GenFAW600_Z \
        --chr-set 29 \
        --allow-extra-chr \
        --missing \
        --out GenFAW600_Z_missing

#awk 'NR>1 && $6>0.1 {print $1, $2, $6}' GenFAW600_Z_missing.imiss \
#  > GenFAW600_Z_samples_high_missing.txt


# ==============================
# 4. LD pruning + PCA
# ==============================

## AUTOSOMES
# ==============================

#plink2--bfile GenFAW600_autosomes \
#--chr-set 29 \
#--allow-extra-chr \
#--remove GenFAW600_autosomes_samples_high_missing.txt \
#--make-bed \
#--out GenFAW600_autosomes_573

#plink2 --bfile GenFAW600_autosomes_573 \
#--chr-set 29 \
#--allow-extra-chr \
#--indep-pairwise 50 5 0.2 \
#--out GenFAW600_autosomes_573_LDprune

#plink2 --bfile GenFAW600_autosomes_573 \
#--chr-set 29 \
#--allow-extra-chr \
#--extract GenFAW600_autosomes_LDprune.prune.in \
#--make-bed \
#--out GenFAW600_autosomes_573_Pruned

#plink2 --bfile GenFAW600_autosomes_573_Pruned \
# --chr-set 29 \
#--allow-extra-chr \
#--pca \
#--out GenFAW600_autosomes_573_PCA

## CHR 29 (Z)
# ==============================

#plink2 --bfile GenFAW600_Z \
#--chr-set 29 \
#--allow-extra-chr \
#--remove GenFAW600_Z_samples_high_missing.txt \
#--make-bed \
#--out GenFAW600_Z_576

#plink2 --bfile GenFAW600_Z_576 \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --indep-pairwise 50 5 0.2 \
#  --out GenFAW600_Z_576_LDprune

#plink2 --bfile GenFAW600_Z_576 \
#  --chr-set 29 \
#  --extract GenFAW600_Z_576_LDprune.prune.in \
#  --make-bed \
#  --out GenFAW600_Z_576_LDprune

plink2 --bfile GenFAW600_Z_576_LDprune\
  --chr-set 29 \
  --pca \
  --out GenFAW600_Z_576_PCA

