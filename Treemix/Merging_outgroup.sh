#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

cd /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_outgroup

bcftools annotate --rename-chrs /storage/simple/users/durandk/scratch_durandk/GenFAW600/Treemix/rename.txt -O z -o SRR5132437.filtered.renamed.vcf.gz SRR5132437.filtered.vcf.gz
bcftools view \
    -r 1 -r 2 -r 3 -r 4 -r 5 -r 6 -r 7 -r 8 -r 9 -r 10 \
    -r 11 -r 12 -r 13 -r 14 -r 15 -r 16 -r 17 -r 18 -r 19 -r 20 \
    -r 21 -r 22 -r 23 -r 24 -r 25 -r 26 -r 27 -r 28 -r 29 \
    SRR5132437.filtered.vcf.gz \
    -Oz -o SRR5132437.filtered_chr1-29.vcf.gz
    
conda activate bgzip_tabix
tabix -p vcf SRR5132437.filtered_chr1-29.vcf.gz

cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/Treemix
conda activate bcftools

bcftools merge /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/GenFAW600_Whole_nocontaminated.vcf.gz.recode.vcf.gz /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_outgroup/SRR5132437.filtered_chr1-29.vcf.gz -Oz -o treemix.vcf.gz --threads 4

# filtering 
conda activate vcftools
vcftools --gzvcf treemix.vcf.gz  --remove-indels --min-alleles 2 --max-alleles 2 --recode   --recode-INFO-all --out treemix_input.vcf

conda activate bgzip_tabix

bgzip -c treemix_input.vcf.recode.vcf > treemix_input.vcf.recode.vcf.gz
tabix -p vcf treemix_input.vcf.recode.vcf.gz






