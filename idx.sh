#!/bin/bash
#need to have the ensembl GTF and FA file in current dir
STAR=/home/ziemannm/barry/sw/STAR-2.7.7a/source/STAR

GTF=combined.gtf
FA=combined.fa
CWD=$(pwd)
#GNAMES=$(echo $GTF | sed 's#.gtf#.gnames.txt#')

$STAR --runMode genomeGenerate \
--sjdbGTFfile $GTF \
--genomeSAindexNbases 13 \
--genomeDir $CWD  \
--genomeFastaFiles $CWD/$FA \
--runThreadN $(nproc)

#grep -w gene $GTF | cut -d '"' -f2,6 \
#| tr '"' '\t' | sort -k 1b,1 > $GNAMES

#grep -w gene $GTF  | cut -d '"' -f2,6,10 \
#| tr '"' '\t' > $GNAMES
