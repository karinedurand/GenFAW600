#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=40G

source /storage/simple/users/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools


# === Vérification qualité des individus par subset ===
#vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Schlum_PRJNA640063_n55/VCF/Schlum_PRJNA640063.snp.noindel.vcf.gz \
#  --missing-indv \
#  --out Schlum_PRJNA640063_missing

#vcftools --gzvcf /storage/simple/pr#ojects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Yainna_2022_n203/VCF/Yainna_2022.snp.noindel.bgzip.vcf.gz \
#  --missing-indv \
#  --out Yainna_2022_missing

#vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_2020_n106/VCF/Zhang_2020.snp.noindel.vcf.gz \
#  --missing-indv \
#  --out Zhang_2020_missing

#vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/zhang_2023.snp.noindel.vcf.gz \
#  --missing-indv \
#  --out Zhang_2023_missing

#vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/Zhang_37.snp.noindel.vcf.gz \
#  --missing-indv \
#  --out Zhang_37_missing


#vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Schlum_PRJNA640063_n55/VCF/Schlum_PRJNA640063.snp.noindel.vcf.gz --remove #remove_sample_MISS_schlum.txt --recode --recode-INFO-all --out Schlum_clean


#vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Yainna_2022_n203/VCF/Yainna_2022.snp.noindel.bgzip.vcf.gz --remove #remove_sample_MISS_yainna_2022uper08_csiro.txt --recode --recode-INFO-all --out yainna_clean


#no ind to remove in zhang_2020.snp.noindel.vcf.g
#no ind to remove in zhang_2023.snp.noindel.vcf.gz 

vcftools --gzvcf /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/zhang_37.snp.noindel.vcf.gz      --remove remove_sample_MISS_zhang37.txt --recode --recode-INFO-all --out zhang_37_clean

source /storage/simple/users/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools
bcftools merge --force-samples \
	Schlum_clean.recode.vcf \
	yainna_clean.recode.vcf \
	/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_2020_n106/VCF/Zhang_2020.snp.noindel.bgzip.gz \
	/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/zhang_2023.snp.noindel.vcf.gz \
	zhang_37_clean.recode.vcf  \
  -Oz -o ALL_102025.vcf.gz

bcftools index ALL_102025.vcf.gz



#bcftools query -l /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Schlum_PRJNA640063_n55/VCF/Schlum_PRJNA640063.snp.noindel.vcf.gz
#bcftools query -l /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Yainna_2022_n203/VCF/Yainna_2022.snp.noindel.bgzip.vcf.gz \
#bcftools query -l /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_2020_n106/VCF/Zhang_2020.snp.noindel.bgzip.gz \
#bcftools query -l  /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/zhang_2023.snp.noindel.vcf.gz 
#bcftools query -l /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/Zhang_37.snp.noindel.vcf.gz
#bcftools query -l/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/CNP0001020_GUI_n163/VCF/GUI.snp.noindel.vcf.gz
#bcftools query -l ALLsnp.noindel.vcf.gz

