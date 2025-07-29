#!/bin/bash
#SBATCH -p dgimi-eha  
#SBATCH --mem=40G

source /storage/simple/users/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

bcftools merge \
/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_2023_n88/VCF/zhang_2023.snp.noindel.vcf.gz \
/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_2023_n88/VCF/Zhang_37.snp.noindel.vcf.gz \
   /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Yainna_2022_n203/VCF/Yainna_2022.snp.noindel.bgzip.vcf.gz \
   /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Schlum_PRJNA640063_n55/VCF/Schlum_PRJNA640063.snp.noindel.vcf.gz \
   /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/CNP0001020_GUI_n163/VCF/GUI.snp.noindel.vcf.gz   -Oz -o ALLsnp.noindel.vcf.gz

bcftools index ALLsnp.noindel.vcf.gz
