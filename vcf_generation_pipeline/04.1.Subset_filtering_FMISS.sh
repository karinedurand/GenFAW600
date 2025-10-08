#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=40G
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

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

conda activate bgzip_tabix
#bgzip -c Schlum_clean.recode.vcf > Schlum_clean.recode.vcf.gz
#tabix -p vcf Schlum_clean.recode.vcf.gz
#bgzip -c yainna_clean.recode.vcf  > yainna_clean.recode.vcf.gz
#tabix -p vcf yainna_clean.recode.vcf.gz
bgzip -c zhang_37_clean.recode.vcf> zhang_37_clean.recode.vcf.gz
tabix -p vcf zhang_37_clean.recode.vcf.gz
