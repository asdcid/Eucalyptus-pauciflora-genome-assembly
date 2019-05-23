#!/bin/bash
inputGenome='genome.fa'
outdir="/data/snowgum_assembly/blobtools/"
db="ncbi_database_nt"

cd $outdir

echo "runiing blast"
blastn \
    -query $inputGenome \
    -db $db"nt" \
    -outfmt '6 qseqid saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore' \
    -max_target_seqs 1 \
    -max_hsps 1 \
    -num_threads 40 \
    -evalue 1e-20 \
    -out ${outdir}/"blast.out"
