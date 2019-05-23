Scripts for genome polishing.

In general, we use long-read to polish the genome several iterations, then use short-read to polish the genome several iterations. The 3_BUSCO.sh and 4_quast.sh are used to check the quality of each iteration.

1_RaconPolish(longRead).sh is using long-read to polish the genome. If the genome is assembled by hybrid assembler, such as MaSuRCA, we don't suggest use long-read to polish it, because it seems to induce more error than correct the genome due to the error-prone long-reads.
