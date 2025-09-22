#!/bin/bash
#SBATCH --job-name=plink_all
#SBATCH -p cpu-ondemand
#SBATCH --mem=50G


# ==============================
# ENVIRONNEMENTS
# ==============================
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

# ==============================
# 1. Merging
# ==============================

#bcftools concat \
 --threads 4 \
 --output-type z \
 --output GenFAW600_autosome.vcf.gz \
 GenFAW600_rename_1.vcf.gz \
 GenFAW600_rename_2.vcf.gz \
 GenFAW600_rename_3.vcf.gz \
 GenFAW600_rename_4.vcf.gz \
 GenFAW600_rename_5.vcf.gz \
 GenFAW600_rename_6.vcf.gz \
 GenFAW600_rename_7.vcf.gz \
 GenFAW600_rename_8.vcf.gz \
 GenFAW600_rename_9.vcf.gz \
 GenFAW600_rename_10.vcf.gz \
 GenFAW600_rename_11.vcf.gz \
 GenFAW600_rename_12.vcf.gz \
 GenFAW600_rename_13.vcf.gz \
 GenFAW600_rename_14.vcf.gz \
 GenFAW600_rename_15.vcf.gz \
 GenFAW600_rename_16.vcf.gz \
 GenFAW600_rename_17.vcf.gz \
 GenFAW600_rename_18.vcf.gz \
 GenFAW600_rename_19.vcf.gz \
 GenFAW600_rename_20.vcf.gz \
 GenFAW600_rename_21.vcf.gz \
 GenFAW600_rename_22.vcf.gz \
 GenFAW600_rename_23.vcf.gz \
 GenFAW600_rename_24.vcf.gz \
 GenFAW600_rename_25.vcf.gz \
 GenFAW600_rename_26.vcf.gz \
 GenFAW600_rename_27.vcf.gz \
 GenFAW600_rename_28.vcf.gz
# Index du VCF final (obligatoire pour bcftools, samtools, etc.)
bcftools index GenFAW600_autosome.vcf.gz

conda activate plink2

plink2 \
  --vcf GenFAW600_autosome.vcf.gz \
  --make-bed \
  --chr-set 29 \
  --allow-extra-chr \
  --set-all-var-ids @:#:\$r:\$a \
  --max-alleles 2 \
  --min-alleles 2 \
  --max-missing 0.1 \
  --out GenFAW600_autosomes.filtered


# ==============================
# 3. Calculer la missingness
# ==============================

## Autosomes
plink2 --bfile GenFAW600_autosomes.filtered \
        --chr-set 29 \
#       --allow-extra-chr \
          --missing \
  --out GenFAW600_autosomes.filtered_missing



# ==============================
# 4. LD pruning + PCA
# ==============================

# AUTOSOMES
# ==============================

#plink2--bfile GenFAW600_autosomes.filtered \
#--chr-set 29 \
#--allow-extra-chr \
#--remove GenFAW600_autosomes_samples_high_missing.txt \
#--make-bed \
#--out GenFAW600_autosomes.filtered

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


