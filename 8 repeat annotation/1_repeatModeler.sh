#!/bin/bash


set -e

###################################################################################
REPEATMODELER_HOME='/home/raymond/devel/repeatMasker/repeatModeler/RepeatModeler-open-1.0.11/'
speciesName='Epau'
reference='genome.polish.purge.fa'
#use 4 per one threads, if set it to 10, it will use 40
threads=10
###################################################################################


$REPEATMODELER_HOME/BuildDatabase \
    -name $speciesName -engine ncbi $reference 2>&1 |tee buildDB.log

$REPEATMODELER_HOME/RepeatModeler \
    -engine ncbi -pa 10 -database $speciesName 2>&1 |tee repeatModeler.log

rm -r RM_*/round-*
#remove the database
rm $speciesName.*
