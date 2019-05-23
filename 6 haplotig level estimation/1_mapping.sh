#!/bin/bash


set -e

export PATH='/home/rob/devel/purge_haplotigs/bin/':$PATH
export PATH='/home/raymond/devel/ngmlr/bin/ngmlr-0.2.6/':$PATH

ref='genome.polish.fa'
reads='canu_corr.min1kb.renamed.correctedReads.fasta.gz'
threads=40



name=$(basename ${ref%%.fa})
bamFile='../result/'$name
ngmlr \
    -t $threads \
    -r $ref \
    -q $reads \
    -o $bamFile.sam \
    -x ont \
    --skip-write

samtools sort -@ $threads $bamFile.sam > $bamFile.sort.bam
samtools index $bamFile.sort.bam

rm $bamFile.sam
