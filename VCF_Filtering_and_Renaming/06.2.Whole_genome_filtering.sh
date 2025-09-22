#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account dgimi-eha
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
OUTDIR="/storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/ALL"

bcftools concat    --threads 4   --output-type z  --output GenFAW600_Whole.vcf.gz GenFAW600_autosome.vcf.gz GenFAW600_rename_29.vcf.gz 
 
bcftools index GenFAW600_Whole.vcf.gz


# ==============================
# Conversion en PLINK
# ==============================
conda activate plink2
echo "=== Conversion VCF → PLINK ==="
plink2 --vcf GenFAW600_Whole \
       --make-bed \
       --chr-set 29 \
       --allow-extra-chr \
       --set-all-var-ids @:#:\$r:\$a \
       --max-alleles 2 \
       --min-alleles 2 \
       --max-missing 0.1 \
       --out GenFAW600_Whole


plink2 --bfile GenFAW600_Whole \
       --chr-set 29 \
       --allow-extra-chr \
       --missing \
        -out GenFAW600_Whole

#plink2 --bfile GenFAW600_ALL \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --remove GenFAW600_All_top_removesample.txt \
#  --make-bed \
#  --out GenFAW600_ALL_573
  
#plink2 --bfile GenFAW600_ALL_573 \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --set-all-var-ids @:#:\$r:\$a \
#  --make-bed \
#  --out GenFAW600_ALL_573_uniq

#plink2 --bfile GenFAW600_ALL_573_uniq \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --indep-pairwise 50 5 0.2 \
#  --out GenFAW600_ALL_573_LDprune

#plink2 --bfile GenFAW600_ALL_573_uniq \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --extract GenFAW600_ALL_573_LDprune.prune.in \
#  --make-bed \
#  --out GenFAW600_ALL_573_Pruned

# ==============================
# PCA
# ==============================
#plink2 --bfile GenFAW600_ALL_573_Pruned \
#   --chr-set 29 \
#  --allow-extra-chr \
#  --pca \
#  --out GenFAW600_ALL_573_PCA







