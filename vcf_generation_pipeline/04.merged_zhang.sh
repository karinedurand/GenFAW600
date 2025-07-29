#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH --mem=50G

conda activate bcftools_env

#Définir les répertoires
BCF_DIR="/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/BCF/"
OUT_DIR="/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/"
#-m all mean "merge all sites" 
# Fusionner tous les fichiers BCF en un seul VCF.gz
#cd /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_2023_n88/BCF/
# for i in /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_2023_n88/BCF/*.bcf
# do 
# bcftools index $i
# done
for i in
bcftools merge -Oz -m all -l /home/durandk/scratch/BIG_DATABASE/Zhang2023/BAM/liste_AR_ZHANG_37.txt  -o ${OUT_DIR}Zhang_37.snp_invariant.vcf.gz


bcftools index ${OUT_DIR}Zhang_37.snp_invariant.vcf.gz
