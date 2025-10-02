#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8


conda activate plink2



plink2 --bfile GenFAW600_Whole_569 \
  --chr-set 29 \
  --allow-extra-chr \
       --geno 1 \
       --make-bed \
       --out GenFAW600_Whole_569_noAllMissing
  

plink2 --bfile GenFAW600_Whole_569_noAllMissing \
	  --chr-set 29 \
	  --allow-extra-chr \
	  --indep-pairwise 50 5 0.2 \
	  --out GenFAW600_Whole_569_noAllMissing_LDprune

plink2 --bfile GenFAW600_Whole_569_noAllMissing \
	  --chr-set 29 \
	  --allow-extra-chr \
	  --extract GenFAW600_Whole_569_noAllMissing_LDprune.prune.in \
	  --make-bed \
	  --out GenFAW600_Whole_569_noAllMissing_Pruned
