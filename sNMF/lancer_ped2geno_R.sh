#!/bin/bash
#SBATCH -p workq
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G

 module load     bioinfo/PLINK/1.90b7 


#!/bin/bash

# Filtrer individus avec plus de 80% de génotypes manquants, SNPs (>5% missing), et convertir en VCF en une commande


# plink --bfile GenFAW600_Whole_569_Pruned \
# 	--chr-set 29 \
# 	--allow-extra-chr \
#       --geno 0.8 \
#       --recode vcf  \
#       --out GenFAW600_geno0.8



module load statistics/R/4.3.0


#Rscript ped2geno.R GenFAW600_geno0.8_filt.ped  GenFAW600_geno0.8_filt
Rscript ped2geno.R 