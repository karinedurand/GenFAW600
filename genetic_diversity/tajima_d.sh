#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --array=0-6
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# --- Input VCF ---
VCF="/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_new.recode.vcf.gz"

POP=(
"Invasive_east_198.pop"
"Invasive_west_62.pop"
"Mex_27.pop"
"USA_81.pop"
"USA_grasses_29.pop"
"Zambia_12.pop"
)

# --- Output directory ---
OUTDIR="tajimaD_results_new"
mkdir -p "$OUTDIR"

# --- Environment ---
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate vcftools

# --- Get current population ---
CURRENT_POP="${POP[$SLURM_ARRAY_TASK_ID]}"
POP_NAME=$(basename "$CURRENT_POP" .pop)  
OUTPREFIX="${POP_NAME}_TajimaD"


vcftools --gzvcf "$VCF" \
  --keep "$CURRENT_POP" \
  --TajimaD 100000 \
  --out "$OUTPREFIX"

