#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem 50G

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Invasive_east_198.pop  --weir-fst-pop Invasive_west_62.pop --fst-window-size 100000 --fst-window-step 10000  --out Invasive_east_198_inasive_west
 
vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Invasive_east_198.pop  --weir-fst-pop Mex_27.pop --fst-window-size 100000 --fst-window-step 10000  --out Invasive_east_198_mexico
 
vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Invasive_east_198.pop --weir-fst-pop USA_81.pop --fst-window-size 100000 --fst-window-step 10000 --out Invasive_east_198_USA_81
 
vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Invasive_east_198.pop --weir-fst-pop USA_grasses_29.pop --fst-window-size 100000 --fst-window-step 10000 --out Invasive_east_198_USA_grasses_29

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Zambia_12.pop --weir-fst-pop Invasive_east_198.pop --fst-window-size 100000 --fst-window-step 10000 --out Zambia_Invasive_east_198

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Mex_27.pop --weir-fst-pop Invasive_west_62.pop --fst-window-size 100000 --fst-window-step 10000 --out Mex_Invasive_west_62

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Invasive_west_62.pop --weir-fst-pop USA_81.pop --fst-window-size 100000 --fst-window-step 10000 --out Invasive_west_62_USA_81

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Invasive_west_62.pop --weir-fst-pop USA_grasses_29.pop --fst-window-size 100000 --fst-window-step 10000 --out Invasive_west_62_USA_grasses_29

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Zambia_12.pop --weir-fst-pop Invasive_west_62.pop --fst-window-size 100000 --fst-window-step 10000 --out Zambia_Invasive_west_62

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Mex_27.pop --weir-fst-pop USA_81.pop --fst-window-size 100000 --fst-window-step 10000 --out Mex_USA_81

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Mex_27.pop --weir-fst-pop USA_grasses_29.pop --fst-window-size 100000 --fst-window-step 10000 --out Mex_USA_grasses_29

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Zambia_12.pop  --weir-fst-pop Mex_27.pop --fst-window-size 100000 --fst-window-step 10000  --out Zambia_mexico
  
vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop USA_81.pop --weir-fst-pop USA_grasses_29.pop --fst-window-size 100000 --fst-window-step 10000 --out USA_81_USA_grasses_29

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Zambia_12.pop --weir-fst-pop USA_81.pop --fst-window-size 100000 --fst-window-step 10000 --out Zambia_USA_81

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz  --weir-fst-pop Zambia_12.pop --weir-fst-pop USA_grasses_29.pop --fst-window-size 100000 --fst-window-step 10000 --out Zambia_USA_grasses_29


