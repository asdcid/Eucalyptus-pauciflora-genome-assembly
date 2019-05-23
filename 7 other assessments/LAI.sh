#!/bin/bash

export PATH='/home/rob/devel/ltr_finder/LTR_FINDER.x86_64-1.0.6/':$PATH


ref='genome.polish.purge.fa'
outputDir='result'

name=$(basename ${ref%%.fa})

outputFinder=$outputDir/${name}.finder.scn

outputHarvest=$outputDir/${name}.harvest.scn
outputHarvestNONTGCA=$outputDir/${name}.harvest.nonTGCA.scn

#ltr_finder
ltr_finder \
    -D 15000 \
    -d 1000 \
    -L 7000 \
    -l 100 \
    -p 20 \
    -C \
    -M 0.9 \
    $ref > $outputFinder

#ltrharvest
gt suffixerator \
    -db $ref \
    -indexname $ref \
    -tis -suf -lcp -des -ssp -sds -dna

gt ltrharvest \
    -index $ref \
    -similar 90 \
    -vic 10 \
    -seed 20 \
    -seqids yes \
    -minlenltr 100 \
    -maxlenltr 7000 \
    -mintsd 4 \
    -maxtsd 6 \
    -motif TGCA \
    -motifmis 1 > $outputHarvest



gt ltrharvest \
    -index $ref \
    -similar 90 \
    -vic 10 \
    -seed 20 \
    -seqids yes \
    -minlenltr 100 \
    -maxlenltr 7000 \
    -mintsd 4 \
    -maxtsd 6  > $outputHarvestNONTGCA

    
#run LTR_retriever to get the LAI score  
LTR_retriever \
    -genome $ref \
    -inharvest $outputHarvest \
    -infinder $outputFinder \
    -nonTGCA $outputHarvestNONTGCA \
    -threads $threads


mv $ref.pass.list $2
mv $ref.pass.list.gff3 $2
mv $ref.LTRlib.fa $2
mv $ref.nmtf.LTRlib.fa $2
mv $ref.LTRlib.redundant.fa $2
mv $ref.out.gff $2
mv $ref.out.fam.size.list $2
mv $ref.out.superfam.size.list $2
mv $ref.out.LTR.distribution.txt $2
mv $ref.out.LAI $2
