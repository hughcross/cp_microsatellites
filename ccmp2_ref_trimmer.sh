#!/bin/bash


#scripts to process the ccmp/trnL soil data for comparison, using modified cutadapt process
# and usearch/uparse otu picking

for x in untrimPrimer_*
do 
echo "### $x"
y=${x%.*}
y=${y#*_}
#c=${y##*_}

#echo $x
#echo $y
#echo $c


#ccmp2f	GATCCCGGACGTAATCCTG  ccmp2r ATTCGAACCCTCGGTACGAT, revcomp = ATCGTACCGAGGGTTCGAAT
cutadapt -g GATCCCGGACGTAATCCTG --trimmed-only -x ccmp2_ $x -o fwd_$y\.fastq

#then rev comp: 

fastx_reverse_complement -Q 33 -i fwd_$y\.fastq -o rcfwd_$y\.fastq
#then trim reverse primer
cutadapt -g ATCGTACCGAGGGTTCGAAT --untrimmed-output untrimmed_$y\.fastq -x full_ rcfwd_$y\.fastq -m 30 -o rev_$y\.fastq
fastx_trimmer -Q 33 -f 20 -m 80 -i untrimmed_$y\.fastq -o rev_scrap_$y\.fastq
#then revcomp back
fastx_reverse_complement -Q 33 -i rev_$y\.fastq -o full_$y\.fastq
fastx_reverse_complement -Q 33 -i rev_scrap_$y\.fastq -o fwd_scrap_$y\.fastq


#camref tag: 1WGBR

fastq_quality_filter -Q 33 -v -q 20 -p 90 -i full_$y\.fastq -o q20p90_$y\.fastq
fastq_quality_filter -Q 33 -v -q 20 -p 90 -i fwd_scrap_$y\.fastq -o scrap_$y\.fastq

fwd=$(grep -c "1WGBR" fwd_$y\.fastq)
echo $y "forward adapters total: " $fwd >> ccmp2_seqs_report.txt

full=$(grep -c "1WGBR" full_$y\.fastq)
echo $y "both adapters total: " $full >> ccmp2_seqs_report.txt

scrappy=$(grep -c "1WGBR" scrap_$y\.fastq)
echo $y "untrimmed reverse adapters total: " $scrappy >> ccmp2_seqs_report.txt

qp=$(grep -c "1WGBR" q20p90_$y\.fastq)
echo -e $y "quality filtered total: " $qp "\n">> ccmp2_seqs_report.txt

fastq_to_fasta -Q 33 -v -i q20p90_$y\.fastq -o $y\.fasta

done


#cutadapt -g CCATTGAGTCTCTGCACCTATC --trimmed-only -x full_ rcfwd_$y\.fasta -m 50 -o rev_$y\.fasta >> ReportCutPrimer_$y\.txt

#note that for trnL did reverse primer first and then forward
#then rev comp back (note: for trnL, leave out this step for fusion primers as they are sequenced back to front)

#fastx_reverse_complement -i rev_$y\.fasta -o fullq15_$y\.fasta
