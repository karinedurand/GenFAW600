#!/bin/bash
#SBATCH --job-name=plink_chr
#SBATCH -p cpu-ondemand
#SBATCH --array=1-29                # <-- job array pour les chr 1..29
#SBATCH --mem=32G                   # mémoire par tâche (ajuste si besoin)
#SBATCH --cpus-per-task=4


set -euo pipefail

# ==============================
# CONFIG
# ==============================
VCF="/storage/simple/users/durandk/scratch_durandk/FULL_BIGDATA/ALLsnp.noindel_576.vcf.gz"
OUTDIR="/storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF_filtering"
CHR="HiC_scaffold_${SLURM_ARRAY_TASK_ID}"

echo "=== Conversion chromosome $CHR ==="

/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools \
  --gzvcf "$VCF" \
  --chr "$CHR" \
  --recode \
  --recode-INFO-all \
  --out "$OUTDIR/GenFAW600_${CHR}"

source /home/durandk/miniconda3/etc/profile.d/conda.sh

# renamed
CHR_SCAFFOLD="HiC_scaffold_${SLURM_ARRAY_TASK_ID}"
CHR_NUM="${SLURM_ARRAY_TASK_ID}"

conda activate bcftools


CHR_MAPPING="chr_mapping_${CHR_NUM}.txt"
echo -e "${CHR_SCAFFOLD}\t${CHR_NUM}" > "$CHR_MAPPING"


# 
bcftools annotate \
    --rename-chrs "$CHR_MAPPING" \
    "$OUTDIR/GenFAW600_${CHR_SCAFFOLD}.recode.vcf" \
    -O z \
    -o "$OUTDIR/GenFAW600_rename_${CHR_NUM}.vcf.gz"

#
conda activate bgzip_tabix  

tabix -p vcf "$OUTDIR/GenFAW600_rename_${CHR_NUM}.vcf.gz"
