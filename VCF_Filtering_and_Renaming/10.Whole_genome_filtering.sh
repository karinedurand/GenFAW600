#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8

set -euo pipefail
# ==============================
# ENVIRONNEMENTS
# ==============================
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bgzip_tabix
#mv /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new/GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf /storage/simple/users/durandk/scratch_durandk/#GenFAW600/VCF/VCF_filtering/whole_genome/

cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new/whole_genome

#bgzip -c GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf  > GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf.gz
#tabix -p vcf GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf.gz
# ==============================
# Conversion en PLINK
# ==============================
conda activate plink2

#plink2 --vcf GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf.gz \
#  --make-bed \
#  --min-alleles 2 --max-alleles 2 \
#  --set-all-var-ids '@:#:$r:$a' \
#  --chr-set 29 \
#  --allow-extra-chr \
#  --out GenFAW600_Whole_biallelic


#plink2 --bfile GenFAW600_Whole \
#       --chr-set 29 \
#       --allow-extra-chr \
#       --missing \
#        -out GenFAW600_Whole_missing

#plink2 --bfile GenFAW600_Whole_biallelic \
#	  --chr-set 29 \
#	  --allow-extra-chr \
#	  --geno 0.8\
#	  --make-bed \
#	  --out GenFAW600_Whole_biallelic_geno0.8


#plink2 --bfile GenFAW600_Whole_biallelic_geno0.8 \
#	  --chr-set 29 \
#	  --allow-extra-chr \
#	  --indep-pairwise 50 5 0.5 \
#	  --out GenFAW600_Whole_biallelic_geno0.8

#plink2 --bfile GenFAW600_Whole_biallelic_geno0.8 \
#	  --chr-set 29 \
#	  --allow-extra-chr \
#	  --extract GenFAW600_Whole_biallelic_geno0.8.prune.in \
#	  --make-bed \
#	  --out GenFAW600_Whole_biallelic_geno0.8_Pruned0.5

# ==============================
# PCA #--geno 0.2: eliminates SNPs with more than 20% missing, retaining those with at least 80% of data present.
# ==============================
plink2 --bfile GenFAW600_Whole_biallelic_geno0.8_Pruned0.5 \
	   --chr-set 29 \
	  --allow-extra-chr \
	  --pca \
	  --out GenFAW600_Whole_biallelic_geno0.8_Pruned0.5_PCA





