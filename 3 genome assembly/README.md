We separated our long-read and short-read data into assembly dataset (~90% of reads) and validation dataset (~10% of reads) by randomly assigning the trimmed and filtered reads into the two datasets. The scripts we used for random selection are in https://github.com/roblanf/splitreads

We first used Canu to correct the long-reads (assembly dataset), and then separated the corrected long-read dataset into 2 subsets: 1kb (all reads > 1kb) and 35kb (all reads > 35kb).

We used the two long-read dataset (1kb and 35kb) and the short read dataset to perform six different assemblies with 4 assemblers: Canu, Flye, Marvel and MaSuRCA. Canu, Flye and Marvel are long-read assemblers, whereas MaSuRCA is hybrid assembler. The six assemblies are: Canu_1kb, Canu_35kb, Flye_1kb, Flye_35kb, Marvel_35kb, MaSuRCA_1kb, MaSuRCA_35kb (the 1kb and 3kb mean using 1kb/35kb long-read dataset)
