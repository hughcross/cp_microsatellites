#!/bin/bash

#shell script to cluster amplicons, export the consensus sequence, and take the con sequence that represents most
#note: to expand, use the merge function with usearch so to essentially dereplicate different size 
# pieces (as opposed to completely different sequences).
#expand later (maybe using uparse, or OTU picker) to pull out different alleles for heterozygotes

for x in *_trnLc.fasta
do 
echo "### $x"
y=${x%.*}
#y=${y#*_}
#echo $y

usearch -cluster_fast $x -id 0.90 -consout unformatted_con90_$y\.fasta

fasta_formatter -w 0 -i unformatted_con90_$y\.fasta > con90_$y\.fasta
#fasta formatter changes all sequences to one line, so easier to take just the first sequence

firstline=$(grep ">centroid" -m 1 con90_$y\.fasta) 

grep $firstline -A 1 con90_$y\.fasta > consensus_$y\.fasta


done

