#!/bin/bash
#SBATCH -p dgimi-eha


cd /lustre/durandk/BIG_DATABASE/Zhang2023


#/home/genouest/inra_umr1333/dkarine/programs/adapterremoval-2.1.7/build/AdapterRemoval --file1 /scratch/knam/Hspp_monitoring/SNV/rawfq1/$1"_R1_001.fastq.gz"  --file2 /scratch/knam/Hspp_monitoring/SNV/rawfq1/$1"_R2_001.fastq.gz"  --basename /scratch/dkarine/HELICOVERPA/$1 --trimns --trimqualities --minquality 20 --gzip --gzip-level 9 --threads 32


/nfs/work/faw_adaptation/programs/adapterremoval-2.1.7/build/AdapterRemoval --file1 /lustre/durandk/BIG_DATABASE/Zhang2023/$1_1.fastq.gz --file2 /lustre/durandk/BIG_DATABASE/Zhang2023/$1_2.fastq.gz --basename /lustre/durandk/BIG_DATABASE/Zhang2023/$1 --trimns --trimqualities --minquality 20 --gzip --gzip-level 9 --threads 32

# --adapter1 AAGTCGGAGGCCAAGCGGTCTTAGGAAGACAA --adapter2 AAGTCGGATCGTAGCCATGTCGTTCTGTGAGCCAAGGAGTTG --gzip --gzip-level 9 --threads 32


#cutadapt -a AAGTCGGAGGCCAAGCGGTCTTAGGAAGACAA -A AAGTCGGATCGTAGCCATGTCGTTCTGTGAGCCAAGGAGTTG

