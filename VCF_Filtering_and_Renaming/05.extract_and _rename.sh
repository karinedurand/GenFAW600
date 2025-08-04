#!/bin/bash
#SBATCH -p dgimi-eha


VCF_IN="/lustre/durandk/BIG_DATABASE/FULL_BIGDATA/out.vcf.gz"
VCF_OUT="//lustre/durandk/GenFAW600/PCA/GenFAW600_rename.vcf"


# 🟢 Liste des 29 scaffolds
CHROM_LIST="FAW_chrom.list"

# 🟢 Création du fichier contenant les noms des 31 premiers chromosomes
cat > "$CHROM_LIST" <<EOL
HiC_scaffold_1
HiC_scaffold_2
HiC_scaffold_3
HiC_scaffold_4
HiC_scaffold_5
HiC_scaffold_6
HiC_scaffold_7
HiC_scaffold_8
HiC_scaffold_9
HiC_scaffold_10
HiC_scaffold_11
HiC_scaffold_12
HiC_scaffold_13
HiC_scaffold_14
HiC_scaffold_15
HiC_scaffold_16
HiC_scaffold_17
HiC_scaffold_18
HiC_scaffold_19
HiC_scaffold_20
HiC_scaffold_21
HiC_scaffold_22
HiC_scaffold_23
HiC_scaffold_24
HiC_scaffold_25
HiC_scaffold_26
HiC_scaffold_27
HiC_scaffold_28
HiC_scaffold_29
EOL
# 🟢 Extraction des 29 scaffolds avec vcftools et renommage CHROM
/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools \
    --gzvcf "$VCF_IN" \
    $(awk '{print "--chr "$1}' "$CHROM_LIST") \
    --recode --stdout | sed 's/HiC_scaffold_//' > "$VCF_OUT"


# 🟢 Compression et indexation du fichier VCF
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c "$VCF_OUT" > "$VCF_OUT.gz"
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf "$VCF_OUT.gz"
