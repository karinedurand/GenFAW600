#!/bin/bash
#SBATCH -p cpu-dedicated
#SBATCH --account=dedicated-cpu@dgimi-eha

cd /storage/simple/users/durandk/scratch_durandk/FULL_BIGDATA/OUTGROUP_slitura


/storage/simple/projects/faw_adaptation/programs/adapterremoval-2.1.7/build/AdapterRemoval --identify-adapters --file1 SRR5132437_1.fastq.bz2 --file2 SRR5132437_2.fastq.bz2 >> log_SRR5132437.txt





