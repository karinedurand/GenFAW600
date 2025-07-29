#!/bin/bash
#SBATCH -p dgimi-eha

cd /lustre/durandk/BIG_DATABASE/Zhang2023/FQ_trim

for i in *.gz
do
/storage/simple/projects/faw_adaptation/programs/adapterremoval-2.1.7/build/AdapterRemoval --identify-adapters --file1 /lustre/durandk/BIG_DATABASE/Zhang2023/FQ_trim/$i --file2 //lustre/durandk/BIG_DATABASE/Zhang2023/FQ_trim/$i >> "log_"$i.txt
done



