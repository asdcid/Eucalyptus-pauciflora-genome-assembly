#!/bin/bash


set -e

###################################################################################
speciesName='Epau'
reference='genome.polish.purge.fa'
#the real threads that RepeatModeler used is ${threads} * 4
threads=10
###################################################################################


cd 01_repeatModeler
rm -fr *
/home/raymond/devel/repeatMasker/repeatModeler/RepeatModeler-open-1.0.11/BuildDatabase \
    -name $speciesName -engine ncbi $reference 2>&1 |tee buildDB.log

/home/raymond/devel/repeatMasker/repeatModeler/RepeatModeler-open-1.0.11/RepeatModeler \
    -engine ncbi -pa 10 -database $speciesName 2>&1 |tee repeatModeler.log

rm -r RM_*/round-*
#remove the database
rm $speciesName.*
