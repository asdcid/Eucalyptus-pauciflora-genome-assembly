#!/bin/bash


set -e

export PATH='/home/raymond/devel/purgeHaplotigs/purge_haplotigs/bin/':$PATH


low=17
mid=102
high=195
inputFile='genome.polish.sort.bam.genecov'
outputFile='coverage_stats.csv'

purge_haplotigs  contigcov \
    -i $inputFile \
    -l $low \
    -m $mid \
    -h $high \
    -o $outputFile
