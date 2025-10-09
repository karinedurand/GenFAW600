#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G


source /storage/simple/users/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools

cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new
# === Vérification qualité des individus par subset ===
vcftools --gzvcf GenFAW600_Whole.vcf.gz --remove  contaminated2remove.txt --recode --recode-INFO-all --out GenFAW600_Whole_nocontaminated.vcf.gz

vcftools --gzvcf GenFAW600_autosome.vcf.gz --remove  contaminated2remove.txt --recode --recode-INFO-all --out GenFAW600_autosome_nocontaminated.vcf.gz

vcftools --gzvcf ALL_rename_HiC_scaffold_29.gz --remove  contaminated2remove.txt --recode --recode-INFO-all --out ALL_rename_HiC_scaffold_29_nocontaminated.vcf.gz


