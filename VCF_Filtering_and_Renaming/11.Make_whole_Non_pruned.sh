#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=50G
#SBATCH --job-name=vcf_filter_biallelic
#SBATCH --output=logs/vcf_filter_%j.out
#SBATCH --error=logs/vcf_filter_%j.err

# --- Working Directory ---
cd /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome

# --- Environment Setup ---
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools

# --- Input / Output Paths ---
VCF_IN="GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf.gz"
OUTPREFIX="GenFAW600_Whole__biallelic_geno08"

vcftools --gzvcf "$VCF_IN" \
  --max-missing 0.2 \
  --min-alleles 2 \
  --max-alleles 2 \
  --recode \
  --recode-INFO-all \
  --out "${OUTPREFIX}"


conda activate bgzip_tabix

bgzip -c "${OUTPREFIX}.recode.vcf" > "${OUTPREFIX}.vcf.gz"
tabix -p vcf "${OUTPREFIX}.vcf.gz"

