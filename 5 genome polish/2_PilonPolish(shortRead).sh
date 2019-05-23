#!/bin/bash
set -e


polish()
{
    inputR1=$1
    inputR2=$2
    outputDir=$3
    ref=$4
    threads=$5
    pilon=$6
    round=$7

    mkdir  $outputDir

    echo $ref
    echo $inputFile
    refDir=$outputDir/ref
    bowtie2Dir=$outputDir/bowtie2
    resultDir=$outputDir/result

    mkdir  $refDir
    mkdir  $bowtie2Dir
    mkdir  $resultDir


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


    #index
    ln $ref $refDir
    ref=$refDir/$(basename ${ref})
    build_index $ref

    #run bowtie2
    outputBowtie2=$bowtie2Dir/$name.sort.bam
    run_bowtie2 $inputR1 $inputR2 $bowtie2Dir $ref $threads $name $outputBowtie2

    #run nanopolish
    outputPilon=$resultDir
    run_pilon $outputBowtie2 $outputPilon $ref $threads $pilon

    #sort and rename scaffold
    outputFile=$resultDir/pilon$n.fa
    python $renameScript ${outputPilon}/pilon.fa $outputFile
    rm $outputPilon/pilon.fa

    #clean bowtie2 result and index
    rm $refDir/*

    echo $ref
    echo $outputBowtie2
}

build_index()
{
    indexFile=$1
    bowtie2-build -q $indexFile $indexFile
}

run_bowtie2()
{
    in1=$1
    in2=$2
    outputDir=$3
    ref=$4
    threads=$5
    name=$6
    outputFile=$7

    bowtie2 \
        -q \
        -x $ref \
        -1 $in1 \
        -2 $in2 \
        -p $threads \
        -S $outputDir/$name.sam

    samtools sort \
        -@ $threads \
        -o $outputFile \
        $outputDir/$name.sam

    samtools index \
        $outputFile
    rm $outputDir/$name.sam
    rm ${ref}*.bt2
}

run_pilon()
{
    echo run_pilon
    bowtie2_inputFile=$1
    outputDir=$2
    ref=$3
    threads=$4
    pilon=$5

    java -Xmx500G -jar $pilon \
        --genome $ref \
        --frags $bowtie2_inputFile \
        --outdir $outputDir \
        --changes \
        --vcf \
        --threads $threads \
        --fix all
    rm $bowtie2_inputFile
    rm ${bowtie2_inputFile}.bai
    rm $outputDir/*.vcf

    mv $outputDir/pilon.fasta $outputDir/pilon.fa
}


inputR1='shortRead.R1.fq'
inputR2='shortRead.R2.fq'
outputDir_all='polishPilon'
ref_ori='genome.racon.fa'
threads=90
polish_round=10
pilon=/PATH/OF/PILON
renameScript=rename.py

echo $threads
cd $outputDir_all


n=1

outputDir=round-$n
echo polish
polish $inputR1 $inputR2 $outputDir $ref_ori $threads $pilon $n
echo "finish round 1"

if [[ $polish_round == 1 ]]
then
    cp round-1/result/*.fa final/
    exit
fi


while [ $n -lt $polish_round ]
do
    ref=round-$n/result/*.fa
    n=$(( $n + 1 ))
    outputDir=round-$n
    polish $inputR1 $inputR2 $outputDir $ref $threads $pilon $n

    echo "round finish " $n

done

cp round-$n/result/*.fa final/
#rm -r round*
~
