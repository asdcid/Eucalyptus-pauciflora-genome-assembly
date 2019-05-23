#!/bin/bash

set -e

export PATH='/home/rob/devel/purge_haplotigs/bin/':$PATH

inputFile='genome.polish.sort.bam'


purge_haplotigs readhist $inputFile
~
