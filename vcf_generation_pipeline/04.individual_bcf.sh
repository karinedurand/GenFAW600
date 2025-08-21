#!/bin/bash
#SBATCH -p dgimi-eha
#SBATCH --mem=5G
#SBATCH --array=2
#SBATCH -J bcftools_indiv

# Activation de l'environnement conda
source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

set -euxo pipefail

# Répertoires
REF="/storage/simple/projects/faw_adaptation/ref/sfC.ver7.fa"
OUT_DIR="/home/durandk/scratch/BIG_DATABASE/Zhang2023/BCF/"
BAM_DIR="/storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/BAM/"
BAM_LIST="/home/durandk/scratch/BIG_DATABASE/Zhang2023/BAM/liste_AR_ZHANG_37.txt"

# Lecture de la liste
mapfile -t BAM_FILES < <(sed 's/ *$//' "${BAM_LIST}")

# Récupération du nom du BAM selon SLURM_ARRAY_TASK_ID
BAM_NAME=${BAM_FILES[$SLURM_ARRAY_TASK_ID-1]}
BAM_FILE="${BAM_DIR}${BAM_NAME}"


# Noms de sortie
BAM_BASE=$(basename "${BAM_NAME}" .bam)
OUT_BCF="${OUT_DIR}${BAM_BASE}.bcf"
OUT_BCF_FILTERED="${OUT_DIR}${BAM_BASE}.filtered.bcf"

# # Étape 1 : appel des variants pour ce BAM
bcftools mpileup -Ou -f ${REF} ${BAM_FILE} -a FORMAT/DP,AD | \
bcftools call -m  -Ob -f GQ    -o ${OUT_BCF}


# Étape 2 : filtrage
bcftools filter "${OUT_BCF}" -i 'QUAL>20 && INFO/DP>10' -o "${OUT_BCF_FILTERED}"
bcftools index "${OUT_BCF_FILTERED}"
