#!/bin/bash
#SBATCH --partition=dgimi-eha
#SBATCH --mem=5G


VCF="ALLsnp.noindel.vcf.gz"    
THRESH=0.8              



/storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools --gzvcf "$VCF" --missing-indv --out missing



awk -v t=$THRESH 'NR>1 && $5>t {print $1, $5}' missing.imiss \
   > remove_sample.txt"


