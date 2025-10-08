#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --array=1-29

source /storage/simple/users/durandk/miniconda3/etc/profile.d/conda.sh
conda activate bcftools

CHROMS=(
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
)

CHR=${CHROMS[$SLURM_ARRAY_TASK_ID-1]}

OUTDIR=/storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/VCF202510_new
mkdir -p $OUTDIR
cd $OUTDIR

bcftools merge --threads 8 --force-samples -r $CHR \
    /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/Schlum_clean.recode.vcf.gz \
    /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/yainna_clean.recode.vcf.gz \
    /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_2020_n106/VCF/Zhang_2020.snp.noindel.vcf.gz \
    /storage/simple/projects/faw_adaptation/Data_Backup/sfrugiperda_SNP/Zhang_PRJNA591441_156samplewithbutcommonwith2020_2023_n125/VCF/zhang_2023.snp.noindel.vcf.gz \
    /storage/simple/users/durandk/scratch_durandk/GenFAW600/VCF/zhang_37_clean.recode.vcf.gz \
    -Oz -o ${OUTDIR}/ALL_${CHR}.vcf.gz

bcftools index ${OUTDIR}/ALL_${CHR}.vcf.gz
