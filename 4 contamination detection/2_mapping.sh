#!/bin/bash

ref='genome.fa'
reads='canu_corr.min1kb.renamed.correctedReads.fasta.gz'
threads=40
outputDir='result'


name=$(basename ${ref%%.fa})
outputFile='result/'$name
ngmlr \
    -t $threads \
    -r $ref \
    -q $reads \
    -o $outputFile.sam \
    -x ont \
    --skip-write

    samtools view -hb -F 2308 -@ $threads $outputFile.sam > $outputFile.bam
    samtools sort -@ $threads $outputFile.bam > $outputFile.sort.bam
    samtools index $outputFile.sort.bam

    rm $outputFile.sam
    rm $outputFile.bam
