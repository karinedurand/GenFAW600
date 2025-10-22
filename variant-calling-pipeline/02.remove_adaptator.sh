#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha
#SBATCH --cpus-per-task=32

/nfs/work/faw_adaptation/programs/adapterremoval-2.1.7/build/AdapterRemoval --file1 SRR5132437_1.fastq.bz2 --file2 SRR5132437_2.fastq.bz2 --basename SRR5132437 --trimns --trimqualities --minquality 20 --gzip --gzip-level 9 --threads 32
