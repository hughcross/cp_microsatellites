#!/bin/bash


#scripts to process the ccmp/trnL soil data for comparison, using modified cutadapt process


for x in ts1_*
do 
echo "### $x"
y=${x%.*}
y=${y#*_}



#for ccmp2 fwd = GATCCCGGACGTAATCCTG, for ccmp2 rev (not revcomp) = ATCGTACCGAGGGTTCGAAT
#for trnL fwd = CGAAATCGGTAGACGCTAC, rev (not revcomp) = CCATTGAGTCTCTGCACCTATC
cutadapt -g CCATTGAGTCTCTGCACCTATC --trimmed-only -x "$y"_ $x -o fwd_$y\.fastq
#then rev comp: 
 
fastx_reverse_complement -Q 33 -i fwd_$y\.fastq -o rcfwd_$y\.fastq
#then trim reverse primer
#cutadapt -g ATCGTACCGAGGGTTCGAAT --trimmed-only -m 50 rcfwd_$y\.fastq -o rev_$y\.fastq
cutadapt -g CGAAATCGGTAGACGCTAC --trimmed-only rcfwd_$y\.fastq -m 80 -o full_$y\.fastq
#note that for trnL did reverse primer first and then forward
#then rev comp back (note: for trnL, leave out this step for fusion primers as they are sequenced back to front)

#fastx_reverse_complement -Q 33 -i rev_$y\.fastq -o full_$y\.fastq

fastq_quality_filter -Q 33 -v -q 20 -p 90 -i full_$y\.fastq -o q20p90_$y\.fastq


fastq_to_fasta -Q 33 -v -i q20p90_$y\.fastq -o final_$y\.fasta

#ccmp2 tag: 467HD
#trnL tag: 

echo "final total sequences:" >> Reportcut.txt

fwd=$(grep -c "467HD" fwd_$y\.fastq)

echo $y "forward adapters total: " $fwd >> Reportcut.txt
grep -c ">" final_$y\.fasta >> Reportcut.txt

done
