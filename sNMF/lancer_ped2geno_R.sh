#!/bin/bash
#SBATCH -p workq
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G


# Filtrer individus avec plus de 80% de génotypes manquants, SNPs (>5% missing), et convertir en VCF en une commande

module load statistics/R/4.3.0

Rscript ped2geno.R 
