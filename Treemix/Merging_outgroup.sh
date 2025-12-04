#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4


source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

#-------------------------------
# 1. Variables
# -------------------------------
LIST="/home/durandk/scratch_durandk/all_bcf/liste_bcf_amerged.txt"   # ta liste d’échantillons
DIR="/home/durandk/scratch_durandk/all_bcf"   # répertoire des liens BCF
TMP="bcf_list_to_merge.txt"


# 3. Merge BCF → garder uniquement les SNPs
#    Exclusion : indels + invariants
# -------------------------------


# bcftools merge \
#     --file-list "$LIST" \
#     -Oz \
#     -o merged.snps.vcf.gz \
#     --threads 4

# -------------------------------
# 4. Filtrer : garder uniquement SNPs (AC>0) et variants
# -------------------------------

# bcftools view \
#     -v snps \
#     -i 'AC>0' \
#     merged.snps.vcf.gz \
#     -Oz -o merged.snps.filtered_bis.vcf.gz \
#      --threads 4

#mv merged.snps.filtered.vcf.gz merged.snps.vcf.gz

# -------------------------------
# 5. Index

#bcftools index merged.snps.filtered.vcf.gz

# bcftools annotate --rename-chrs rename.txt merged.snps.filtered.vcf.gz \
#   -Oz -o merged.snps.filtered.renamed.vcf.gz

#bcftools index merged.snps.filtered.renamed.vcf.gz
bcftools view -r 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29 \
    merged.snps.filtered.renamed.vcf.gz -Oz \
    -o merged.snps.filtered.renamed_chr1-29.vcf.gz --threads 4
bcftools index merged.snps.filtered.renamed_chr1-29.vcf.gz



