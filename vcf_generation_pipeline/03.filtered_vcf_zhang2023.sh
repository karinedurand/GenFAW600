#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH --mem=50G


# Définir les répertoires
VCF_DIR="/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_2023_n88/VCF/"

# Changer de répertoire
cd ${VCF_DIR}
pwd 
#/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf  Zhang_2020.snp_invariant.vcf.gz
# Étape 1 : Retirer les indels du VCF fusionné
#/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools \
# --gzvcf zhang_2023.snp_invariant.vcf.gz --remove-indels --recode --recode-INFO-all \
# --stdout | gzip -c > zhang_2023.snp_invariant.noindel.vcf.gz
# zcat  zhang_2023.snp_invariant.noindel.vcf.gz | /storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c > zhang_2023.snp_invariant.noindel.bgzip.vcf.gz  
# /storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf  zhang_2023.snp_invariant.noindel.bgzip.vcf.gz 



/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools \
 --gzvcf zhang_2023.snp_invariant.vcf.gz \
 --remove-indels \
 --min-alleles 2 --max-alleles 2 \
 --recode --recode-INFO-all \
 --stdout | /storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c > zhang_2023.snp.noindel.vcf.gz


/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf zhang_2023.snp.noindel.vcf.gz
