#!/bin/bash


set -e

###################################################################################
REPEATMASKER_HOME="/home/raymond/devel/repeatMasker/repeatMasker/RepeatMasker/"
reference='genome.polish.purge.fa'
lib='lib.fa' #created by RepeatModeler (consensi.fa.classified) and LTR_retriver (*.LTRlib.fa)
outputDir="02_repeatMasker/"
genomeSize=
#use 4 per one threads, if set it to 10, it will use 40
threads=10
#################################################################################

divPath=$outputDir/$GENOME_NAME.repeats.divsum

if [ ! -d $outputDir ]; then
    mkdir $outputDir
fi

rm $outputDir/*

ln -s $reference $outputDir

echo 'begin to run repeatMasker'

$REPEATMASKER_HOME/RepeatMasker \
    -pa $threads                          \
    -gff                            \
    -a                      \
    -dir $outputDir     \
    -lib $lib \
    $outputDir/$(basename $reference)                  \
    1>RepeatMasker.log
    2>RepeatMasker.err


$REPEATMASKER_HOME/util/calcDivergenceFromAlign.pl  \
    -s $divPath                                     \
    $outputDir/$(basename $reference).align

$REPEATMASKER_HOME/util/createRepeatLandscape.pl    \
    -div $divPath \
    -g $genomeSize > $outputDir/$GENOME_NAME.repeats.html

