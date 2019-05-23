#!/bin/bash

set -e

export PATH='/home/raymond/devel/sniff/Sniffles-master/bin/sniffles-core-1.0.8/':$PATH

#the bam file is produced by remapping the validation long-read dataset to the genome after haplotig removal, using the script in "6 haplotig level estimation/1_mapping.sh
bamFile='genome.polish.primary.sort.bam'"
outputDir='result/'
threads=90


name=$(basename ${bamFile%%.sort.bam})
outputFile=$outputDir/$name.vcf
echo $name
sniffles \
        -t $threads \
        -m $bamFile \
        -v $outputFile
