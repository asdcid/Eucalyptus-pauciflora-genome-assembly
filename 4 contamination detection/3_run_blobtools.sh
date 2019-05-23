#!/bin/bash

inputGenome='genome.fa'
outdir="/data/snowgum_assembly/blobtools/"
taxid="/data/db/taxid"
coverage_file ="genome.sort.bam"
hit_file = "last.taxified.out"


cd $outdir

echo "creating blobDB file"
# creating a blob database file from the taxified  hit file
blobtools create -i $assembly -b $coverage_file -t $hit_file -o $outdir/"genome"

echo "creating blobplot"
# There  will be two plots  one is G_C coverage plot and another one is taxid mapping plot
blobtools plot  -i  $outdir/"genome.blobDB.json" -o $outdir
