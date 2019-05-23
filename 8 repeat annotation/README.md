We use RepeatMasker pipeline to annotate the repeats. We first run RepeatModeler to get the conserved repeat library (```consensi.fa.classified```), 
and then combine this library and the LTR library produced by LTR_retriever (in ```7 other assessments/LAI.sh```)
to create a custom repeat library for RepeatMasker.
