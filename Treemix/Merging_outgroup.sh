#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4


source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

LIST="/home/durandk/scratch_durandk/all_bcf/liste_bcf_amerged.txt"   # ta liste d’échantillons
DIR="/home/durandk/scratch_durandk/all_bcf"   # répertoire des liens BCF
TMP="bcf_list_to_merge.txt"

# 3. Merge BCF 

bcftools merge \
     --file-list "$LIST" \
     -Oz \
     -o merged.snps.vcf.gz \
     --threads 4

 bcftools view \
     -v snps \
     -i 'AC>0' \
     merged.snps.vcf.gz \
     -Oz -o merged.snps.filtered_bis.vcf.gz \
      --threads 4

bcftools index merged.snps.filtered.vcf.gz

bcftools annotate --rename-chrs rename.txt merged.snps.filtered.vcf.gz \
  -Oz -o merged.snps.filtered.renamed.vcf.gz --threads 4

bcftools view -t 1..29 merged.snps.filtered.renamed.vcf.gz -Oz -o merged.snps.filtered.renamed_chr1-29.vcf.gz --threads 4


