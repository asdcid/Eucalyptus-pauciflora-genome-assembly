#!/bin/bash

set -e

export PATH="/home/raymond/devel/purgeHaplotigs/purge_haplotigs/bin/":$PATH

ref='genome.polish.fa'
cov='coverage_stats.csv'
alignment='genome.polish.sort.bam'
threads=95
output='genome_purge'

purge_haplotigs  purge \
    -g $ref \
    -c $cov \
    -b $alignment \
    -t $threads \
