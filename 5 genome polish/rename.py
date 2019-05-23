#!/usr/bin/env python
# encoding: utf-8
"""
rename.py
rename the scaffolds after polished
Created by www on 12:05 am, Jan 07, 2018
"""
import numpy as np
import sys
import os
from Bio import SeqIO


def loadFile(inputFile, outputFile):
    refs    = {}
    n       = 0
    o   = open(outputFile, 'w+')
    for r in SeqIO.parse(inputFile, 'fasta'):
        r.id    = 'Sc%06d' % n
        r.description   = ''
        SeqIO.write(r, o, 'fasta')
        n += 1
    o.close()

def main():
    inputFile   = sys.argv[1]
    outputFile  = sys.argv[2]

    loadFile(inputFile, outputFile)


if __name__ == '__main__':
    main()
