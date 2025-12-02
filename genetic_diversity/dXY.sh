#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --array=0-29
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

cd /storage/simple/users/durandk/scratch_durandk/GenFAW600/dxy
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bgzip_tabix

# Définir les comparaisons de populations
POP_PAIRS=(
  "Invasive_east_198:Invasive_west_62"
  "Invasive_east_198:Mex_27"
  "Invasive_east_198:USA_81"
  "Invasive_east_198:USA_grasses_29"
  "Invasive_east_198:Zambia_12"
  "Invasive_west_62:Mex_27"
  "Invasive_west_62:USA_81"
  "Invasive_west_62:USA_grasses_29"
  "Invasive_west_62:Zambia_12"
  "Mex_27:USA_81"
  "Mex_27:USA_grasses_29"
  "Mex_27:Zambia_12"
  "USA_81:USA_grasses_29"
  "USA_81:Zambia_12"
  "USA_grasses_29:Zambia_12"
)

# Récupération du chromosome à traiter à partir de l'index d'array
CHR=${SLURM_ARRAY_TASK_ID}

# Fichier VCF source
VCF_SRC=/storage/simple/projects/faw_adaptation/Data_Backup/Merged_vcf/2025_GenFAW600/whole_genome/without_lab_strain/GenFAW600_Whole_biallelic_geno08_Pruned0.5_noASW7_v42.vcf.gz

# Extraction du chromosome correspondant
VCF_TMP=${CHR}.vcf.gz
tabix -h "$VCF_SRC" "$CHR" | gzip -c > "$VCF_TMP"
module load bioinfo-cirad
module load anaconda/python3.8
# Calcul du Dxy pour chaque paire de populations
for PAIR in "${POP_PAIRS[@]}"; do
    POP1=${PAIR%%:*}
    POP2=${PAIR##*:}
    OUTNAME="${POP1}_${POP2}_chr${CHR}.dxy"
    python3 Dxy_calculate -v "$VCF_TMP" -p "$PAIR" -o "$OUTNAME" -w 100000
done




