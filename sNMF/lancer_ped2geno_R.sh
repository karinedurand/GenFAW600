#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G

source /home/durandk/miniconda3/etc/profile.d/conda.sh
conda activate R

Rscript ped2geno.R 


