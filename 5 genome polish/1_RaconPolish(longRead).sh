#!/bin/bash

set -e

ulimit -c unlimited

export PATH='/home/raymond/devel/polish/racon/racon/bin/':$PATH
export PATH='/home/raymond/devel/ngmlr/bin/ngmlr-0.2.6/':$PATH

polish()
{
    inputFile=$1
    outputDir=$2
    ref=$3
    threads=$4
    round=$5

    mkdir $outputDir

    echo $ref
    echo $inputFile
    refDir=$outputDir/ref
    ngmlrDir=$outputDir/ngmlr
    resultDir=$outputDir/result

    mkdir $refDir
    mkdir $ngmlrDir
    mkdir $resultDir

    if [[ $ref == *.fasta ]]
    then
        name=$(basename ${ref%%.fasta})
    elif [[ $ref == *.fa ]]
    then
        name=$(basename ${ref%%.fa})
    else
        echo "[ERROR] The assembly file for polishing is not end with 'fa' or 'fasta'"
        exit 1
    fi

    #run ngmlr
    outputNgmlr=$ngmlrDir/$name.sam
    run_ngmlr $inputFile $ngmlrDir $ref $threads $name $outputNgmlr

    echo finish ngmlr
    #run nanopolish
    outputRacon=$resultDir/${name}.polished.racon.tmp.fa
    run_racon $inputFile $outputRacon $outputNgmlr $ref $threads


    #rename scaffold
    outputFile=$resultDir/${name%%.racon*}.racon$round.fa
    python $renameScript $outputRacon $outputFile
    rm $outputRacon

    #clean the ngmlr result
    rm $outputNgmlr

    echo $ref
    echo $outputNgmlr
}


run_ngmlr()
{
    inputFile=$1
    outputDir=$2
    ref=$3
    threads=$4
    name=$5
    outputFile=$6

    ngmlr \
        -t $threads \
        -x ont \
        -r $ref \
        -q $inputFile \
        -o $outputFile

    #clean the ngmlr index
    rm ${ref}*.ngm

    #bwa mem \
    #    -x ont2d \
    #    -t $threads \
    #    $ref \
    #    $inputFile > $outputFile

}

run_racon()
{
    echo run_racon
    inputFile=$1
    outputFile=$2
    ngmlr_inputFile=$3
    ref=$4
    threads=$5

    racon \
        --sam \
        -t $threads \
        $inputFile \
        $ngmlr_inputFile \
        $ref \
        $outputFile


}


inputFile='/home/ashutosh/nanogenome/canu_corr.min35kb.renamed.correctedReads.fasta.gz'
outputDir='polished'
ref='genome.fa'
threads=90
polish_round=10
renameScript=rename.py
cd $outputDir


n=1

#first round polish
outputDir=round-$n
echo polish
polish $inputFile $outputDir $ref $threads $n
echo "finish round 1"


if [[ $polish_round == 1 ]]
then
    cp round-1/result/*.fa final/
    exit
fi

#begin >=2 round polish
while [ $n -lt $polish_round ]
do
    ref=round-$n/result/*.fa
    n=$(( $n + 1 ))
    outputDir=round-$n
    polish $inputFile $outputDir $ref $threads $n

    echo "finish round " $n

done

cp round-$n/result/*.fa final/
#rm -r round*
