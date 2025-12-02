#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=80G
#SBATCH -c 1


source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools

for i in {1..29}
do
  vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz --LROH --chr $i --out ${i}_roh_result
done

