#!/bin/bash


# Fichier du chromosome 1 passé en argument
CHR1="$1"

# Fichier de sortie
OUTPUT="whole.LROH"

# On vide ou crée le fichier de sortie
> "$OUTPUT"


cat "$CHR1" >> "$OUTPUT"

# Ajout des chromosomes 2 à 29
for chr in $(seq 2 29); do
        tail -n +2 "$chr"_roh_result.LROH >> "$OUTPUT"
done


