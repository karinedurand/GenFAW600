#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --array=0-29
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new/whole_genome

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools
#vcftools --gzvcf GenFAW600_Whole.vcf.gz --remove  contaminated2remove.txt --recode --recode-INFO-all --out GenFAW600_Whole_nocontaminated.vcf.gz

conda activate plink1.9
#plink   --gzvcf GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf.gz
# --set-all-var-ids @:#:$r:$a
#  --allow-extra-chr \
#  --chr-set 29 \
#  --make-bed \
#  --max-alleles 2 \
 # --min-alleles 2 \
#  --out GenFAW600_Whole_biallelic
cd /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome
#plink --bfile  GenFAW600_Whole_biallelic
#  --allow-extra-chr \
#  --chr-set 29 \
#  --make-bed \
 #--geno 0.8 \
#  --out GenFAW600_Whole_biallelic_geno08


plink --bfile GenFAW600_Whole_biallelic_geno08 \
      --remove <(echo -e "ASW_DOSE_7\tASW_DOSE_7") \
      --snps-only just-acgt \
      --recode vcf bgz \
      --out GenFAW600_Whole_biallelic_geno08_noASW
      
conda activate bgzip_tabix
      
tabix -p vcf GenFAW600_Whole_biallelic_geno08_noASW.vcf.gz


