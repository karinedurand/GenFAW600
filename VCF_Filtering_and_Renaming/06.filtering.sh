#!/bin/bash
#SBATCH -p dgimi-eha


# Change to working directory
cd /lustre/durandk/GenFAW600/PCA_596ind
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools
# ==============================
# CONFIGURATION
# ==============================
VCF="/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/GenFAW600_rename.vcf.gz"

MAX_MISSING=0.1
MAF=0.01
OUTDIR="VCF_filtered"
mkdir -p $OUTDIR


#Biallélique 
echo "[2] Filtre biallélique..."
bcftools view -m2 -M2 -v snps "$OUTDIR/GenFAW600.rename.vcf" -Oz -o "$OUTDIR/step2_biallelic.vcf.gz"
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf "$OUTDIR/step2_biallelic.vcf.gz"
echo "  SNPs restants : $(bcftools view -H VCF_steps/step2_biallelic.vcf.gz | wc -l)"
echo

# max-missing
echo "[3] Filtre max-missing ($MAX_MISSING)..."
bcftools view -i "F_MISSING<=$MAX_MISSING" "$OUTDIR/step2_biallelic.vcf.gz" -Oz -o "$OUTDIR/step3_maxmissing.vcf.gz"
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p vcf "$OUTDIR/step3_maxmissing.vcf.gz"
echo "  SNPs restants : $(bcftools view -H VCF_steps/step3_maxmissing_0.1.vcf.gz | wc -l)"
echo
