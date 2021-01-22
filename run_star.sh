#!/bin/bash
REF=../ref2


run_pipeline(){
CWD=$(pwd)
FQZ1=$1
REF=$2
FQZ2=$(echo $FQZ1 | sed 's/_R1_/_R2_/')
FQ1=$(echo $FQZ1 | sed 's/.gz$/-trimmed-pair1.fastq/')
FQ2=$(echo $FQZ1 | sed 's/.gz$/-trimmed-pair2.fastq/')
BASE=$(echo $1 | sed 's/.fastq.gz//')
BAM=/home/ziemannm/barry/map/$BASE.bam

/home/ziemannm/barry/sw/skewer -t $(nproc) -q 20 $FQZ1 $FQZ2

/home/ziemannm/barry/sw/STAR-2.7.7a/source/STAR --runThreadN 30 \
--quantMode GeneCounts --genomeLoad LoadAndKeep  \
 --outSAMtype None \
 --genomeDir $REF --readFilesIn=$FQ1 $FQ2 --outFileNamePrefix $BASE.

rm $FQ1 $FQ2
}
export -f run_pipeline

parallel -j1 run_pipeline ::: *_R1_*.fastq.gz ::: $REF
/home/ziemannm/barry/sw/STAR-2.7.7a/source/STAR --genomeLoad Remove --genomeDir $REF

for TAB in *ReadsPerGene.out.tab ; do
  tail -n +5 $TAB | cut -f1,4 | sed "s/^/${TAB}\t/"
done > 3col.tsv
