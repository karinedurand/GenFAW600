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

#echo "Fin conversion chr $CHR"

# Initialize Conda (adjust path to your Conda installation)
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bgzip_tabix

CHR="${SLURM_ARRAY_TASK_ID}"
# Rename chromosomes and compress the output 
cat /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF_filtering/GenFAW600_HiC_scaffold_"$CHR".recode.vcf | sed 's/^HiC_scaffold_\([0-9]\+\)/\1/' | bgzip -c > "$OUTDIR/GenFAW600_rename_${CHR}.vcf.gz"

# Index the renamed VCF
tabix -p vcf "$OUTDIR/GenFAW600_rename_${CHR}.vcf.gz"


