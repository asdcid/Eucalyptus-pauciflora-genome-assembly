#!/bin/bash

export PATH='/home/rob/devel/cgal/cgal-0.9.6-beta/':$PATH

ref='genome.polish.purge.fa'
in1='shortRead.validation.R1.fq'
in2='shortRead.validation.R2.fq'
threads=$4
sam='genome.polish.purge.sam'

bowtie2-build $ref $ref
bowtie2 \
    -q \
    -x $ref \
    -a \
    --no-mixed \
    -1 $in1 \
    -2 $in2 \
    -p $threads \
    -S $sam


bowtie2convert $sam
align $ref 500 20
cgal $ref

