#!/bin/bash

set -e

export PATH='/home/raymond/devel/quast/quast-4.6.0/':$PATH
export PATH="/home/raymond/devel/qualimap/qualimap_v2.2.1/":$PATH
export PATH='/home/raymond/devel/ngmlr/bin/ngmlr-0.2.6/':$PATH

inputFile='polished_genome.fa'
output='outputDir'
validationDataShort='shortRead_validation_dataset_DIR'
validationDataLong='longRead_validation_dataset.fq'
threads=60
name='polished'


    quast_output=$output/quast
    bowtie2_output=$output/bowtie2
    ngmlr_output=$output/ngmlr
    qualimap_output_long=$output/qualimap_long
    qualimap_output_short=$output/qualimap_short

    mkdir -p $quast_output
    mkdir -p $bowtie2_output
    mkdir -p $ngmlr_output
    mkdir -p $qualimap_output_short
    mkdir -p $qualimap_output_long

    #run quast get stat of genome
    echo 'quast' $name
    quast.py \
        -o $quast_output \
        -t $threads \
        -l $name \
        --eukaryote \
        --est-ref-size 500000000 \
        $inputFile

    # validate it
    echo 'validate' $name
    in1=$validationDataShort/R1.fastq.gz
    in2=$validationDataShort/R2.fastq.gz

    bowtie2-build $inputFile $inputFile

    bowtie2 \
        -q \
        -x $inputFile \
        -1 $in1 \
        -2 $in2 \
        -p $threads \
        -S $bowtie2_output/$name.sam

    rm $inputFile.*.bt2



    samtools view -bS -F 264 -@ $threads $bowtie2_output/$name.sam > $bowtie2_output/$name.bam
    samtools sort -@ $threads $bowtie2_output/$name.bam -o $bowtie2_output/$name.bowtie2.sort.bam
    samtools index $bowtie2_output/$name.bowtie2.sort.bam

    rm $bowtie2_output/$name.bam
    rm $bowtie2_output/$name.sam

    #qualimap to get mapping summary
    echo 'qualimap' $name
    qualimap \
        bamqc \
        -bam $bowtie2_output/$name.bowtie2.sort.bam \
        -outdir $qualimap_output_short \
        --java-mem-size=30G \
        -nt $threads \
        -c

    rm -r $bowtie2_output

    ngmlr \
        -t $threads \
        -x ont \
        --skip-write \
        -r $inputFile \
        -q $validationDataLong \
        -o $ngmlr_output/$name.sam

    samtools view -bS -F 2304 -@ $threads $ngmlr_output/$name.sam > $ngmlr_output/$name.bam
    samtools sort -@ $threads $ngmlr_output/$name.bam -o $ngmlr_output/$name.ngmlr.sort.bam
    samtools index $ngmlr_output/$name.ngmlr.sort.bam

    rm $ngmlr_output/$name.bam
    rm $ngmlr_output/$name.sam

    #qualimap to get mapping summary
    echo 'qualimap' $name
    qualimap \
        bamqc \
        -bam $ngmlr_output/$name.ngmlr.sort.bam \
        -outdir $qualimap_output_long \
        --java-mem-size=30G \
        -nt $threads \
        -c

