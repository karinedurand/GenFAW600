#!/bin/bash
#SBATCH -p dgimi-eha


# Change to working directory
cd /lustre/durandk/GenFAW600/PCA_596ind
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools
# ==============================
# CONFIGURATION
# ==============================
VCF="/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/GenFAW600.rename.vcf.gz"

MAX_MISSING=0.1
OUTDIR="VCF_filtering"
mkdir -p $OUTDIR

#Biallélique 
/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools \
  --gzvcf "$VCF" \
  --max-alleles 2 \
  --min-alleles 2 \
  --max-missing 0.1 \
  --recode \
  --recode-INFO-all \
  --out "$OUTDIR"/GenFAW600_filtered

#  bgzip
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c "$OUTDIR"/GenFAW600_filtered.recode.vcf \
  > "$OUTDIR"/GenFAW600_filtered.vcf.gz

# Indexation tabix
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf "$OUTDIR"/GenFAW600_filtered.vcf.gz



conda deactivate 
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate plink2
# Convert to PLINK binary format
  
plink2 --vcf "$OUTDIR"/GenFAW600_filtered.vcf.gz \
     --chr-set 29 \
     --set-missing-var-ids @:#\$1,\$2 \
     --make-bed \
     --double-id \
     --allow-extra-chr \
     --out "$OUTDIR"/GenFAW600_cleanIDs
      
      
# LD pruning
plink2 --bfile "$OUTDIR"/GenFAW600_cleanIDs \
      --chr-set 29 \
      --indep-pairwise 50 5 0.2 \
      --out "$OUTDIR"/GenFAW600_LDprune

# Garder SNPs indépendants
plink2 --bfile "$OUTDIR"/GenFAW600_cleanIDs \
      --chr-set 29 \
      --extract "$OUTDIR"/GenFAW600_LDprune.prune.in \
      --make-bed \
      --out "$OUTDIR"/GenFAW600_Pruned

# Run PCA
plink2 \
  --bfile "$OUTDIR"/GenFAW600_Pruned \
  --double-id \
  --chr-set 29 \
  --allow-extra-chr \
  --pca \
  --out "$OUTDIR"/GenFAW600.PCA_PLINK
