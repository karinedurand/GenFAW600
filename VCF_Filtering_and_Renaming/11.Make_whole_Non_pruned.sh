#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=4
#SBATCH --mem=50G


# --- Working Directory ---
cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new/whole_genome/

# --- Environment Setup ---
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools

# --- Input / Output Paths ---
VCF_IN="/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/GenFAW600_Whole_nocontaminated.recode.vcf.gz"
OUTPREFIX="GenFAW600_Whole_biallelic_geno08"

#vcftools --gzvcf "$VCF_IN" \
#  --remove remove.txt \
#  --max-missing 0.8 \
#  --min-alleles 2 \
#  --max-alleles 2 \
#  --recode --recode-INFO-all \
#  --out "${OUTPREFIX}"

# Ensure file is fully written
sync

# --- Compress + Index ---
conda activate bgzip_tabix

bgzip -c "${OUTPREFIX}.recode.vcf" > "${OUTPREFIX}.recode2.vcf.gz"
tabix -p vcf "${OUTPREFIX}.recode2.vcf.gz"
