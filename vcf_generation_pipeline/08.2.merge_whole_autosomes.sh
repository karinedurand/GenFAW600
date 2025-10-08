#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G

source /storage/simple/users/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new
###merged autosomes
bcftools concat    --threads 4   --output-type z  --output GenFAW600_autosome.vcf.gz \
ALL_rename_HiC_scaffold_{1..28}.gz
bcftools index GenFAW600_autosome.vcf.gz
###merged Whole
bcftools concat    --threads 4   --output-type z  --output GenFAW600_Whole.vcf.gz GenFAW600_autosome.vcf.gz GALL_rename_HiC_scaffold_29.gz
bcftools index GenFAW600_Whole.vcf.gz
