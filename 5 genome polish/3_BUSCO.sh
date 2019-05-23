#!/bin/bash

set -e


export BUSCO_CONFIG_FILE="/home/raymond/work/Eucalyptus_pauciflora/genome/bin/genome/polish/offical/assembly_result_quality_check/busco/config.ini"
export AUGUSTUS_CONFIG_PATH="/home/raymond/devel/python/anaconda/install/config/"
export PATH='/home/raymond/devel/busco/busco/scripts/':$PATH

inputGenome='polished.genome.fa'
outputName='polished'
lineage='db/embryophyta_odb9/'
mode='genome'
threads=10




run_BUSCO.py \
    -i $inputGenome \
    -o $outputName \
    -l $lineage \
    -m $mode \
    -c $threads
