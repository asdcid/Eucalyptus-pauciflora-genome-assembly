#!/bin/bash

export PATH="/home/rob/devel/mummer4/install/bin/":$PATH

set -e

query='assembly.1.fa'
outputFile='assembly1_vs_assembly2.fa'
ref='assembly.2.fa'
identity=75
threads=10

nucmer \
        --maxmatch  \
        --prefix=$outputFile  \
        $ref \
        $query
delta-filter \
    -m \
    -i $identity \
    $outputFile.delta > ${outputFile}.${identity}.delta


dnadiff -d ${outputFile}.${identity}.delta \
    --prefix=$outputFile

