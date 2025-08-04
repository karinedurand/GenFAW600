#!/bin/bash
#SBATCH -p dgimi-eha


# 📌 Étape 1 : Filtrer les SNPs et nettoyer le VCF avec VCFtools
# Supprime les SNPs avec une fréquence allèle mineure < 5%
 # Supprime les SNPs avec > 5% de génotypes manquants

 cd /lustre/durandk/GenFAW600/PCA
  /storage/simple/projects/faw_adaptation/programs/vcftools_0.1.13/bin/vcftools  \
  --gzvcf /lustre/durandk/GenFAW600/PCA/GenFAW600_rename.vcf.gz \
           --maf 0.05  \
           --recode --stdout | /storage/simple/projects/faw_adaptation/programs/htslib-1.9/bgzip -c > GenFAW600.PCA.vcf.gz

 # Indexer le VCF filtré
/storage/simple/projects/faw_adaptation/programs/htslib-1.9/tabix -p GenFAW600.PCA.vcf.gz
#KIWOONG NE VEUT PAS DE FILTRATION, JUSTE SNP FILTRE SUR LD
/storage/simple/projects/faw_adaptation/programs/plink1.9/plink  --vcf GenFAW600.PCA.vcf.gz \
     --allow-extra-chr \
     --chr-set 29 \
     --double-id \
     --make-bed \
     --out GenFAW600.PCA

#Produce a list of SNP without LD
/storage/simple/projects/faw_adaptation/programs/plink1.9/plink  --bfile GenFAW600.PCA \
      --allow-extra-chr \
      --chr-set 29 \
      --indep-pairwise 50 5 0.2 \
      --out pruned

📌 Étape 4 : Garder uniquement les SNPs sélectionnés après LD pruning
/storage/simple/projects/faw_adaptation/programs/plink1.9/plink --bfile GenFAW600.PCA\
      --allow-extra-chr \
      --chr-set 29 \
      --extract pruned.prune.in \
      --make-bed \
      --out GenFAW600.PCA_pruned


#ensuite reformater le bim
awk '{if ($2 == ".") $2 = "SNP"NR; print $1, $2, $3, $4, $5, $6}' GenFAW600.PCA_pruned.bim > GenFAW600.PCA_pruned.bim_corrected.bim

