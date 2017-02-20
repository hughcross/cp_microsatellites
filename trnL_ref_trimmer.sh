#!/bin/bash


#scripts to process the ccmp/trnL soil data for comparison, using modified cutadapt process
# and usearch/uparse otu picking

for x in untrimPrimer_*
do 
echo "### $x"
y=${x%.*}
y=${y#*_}
#c=${y##*_}

echo $x
echo $y
#echo $c

#for trnL fwd = CGAAATCGGTAGACGCTAC, rev (not revcomp) = CCATTGAGTCTCTGCACCTATC

cutadapt -g CGAAATCGGTAGACGCTAC --trimmed-only -x trnL_ $x -o fwd_$y\.fastq > ReportCutPrimer_$y\.txt

#then rev comp: 
#note trying to pipe them to avoid so many files 

fastx_reverse_complement -Q 33 -i fwd_$y\.fastq -o rcfwd_$y\.fastq

cutadapt -g CCATTGAGTCTCTGCACCTATC --trimmed-only -x full_ rcfwd_$y\.fastq -m 50 -o rev_$y\.fastq >> ReportCutPrimer_$y\.txt

fastx_reverse_complement -Q 33 -i rev_$y\.fastq -o full_$y\.fastq

#then trim reverse primer
#cutadapt -g ATCGTACCGAGGGTTCGAAT --trimmed-only -m 50 rcfwd_$y\.fasta -o rev_$y\.fasta >> Reportcut_$y.txt

#camref tag: 1WGBR

fastq_quality_filter -Q 33 -v -q 20 -p 90 -i full_$y\.fastq -o q20p90_$y\.fastq


fwd=$(grep -c "1WGBR" fwd_$y\.fastq)
echo "forward adapters total: " $fwd >> seqs_report_$y\.txt

full=$(grep -c "1WGBR" full_$y\.fastq)
echo "both adapters total: " $full >> seqs_report_$y\.txt

qp=$(grep -c "1WGBR" q20p90_$y\.fastq)
echo "quality filtered total: " $qp >> seqs_report_$y\.txt

fastq_to_fasta -Q 33 -v -i q20p90_$y\.fastq -o $y\.fasta

done


#cutadapt -g CCATTGAGTCTCTGCACCTATC --trimmed-only -x full_ rcfwd_$y\.fasta -m 50 -o rev_$y\.fasta >> ReportCutPrimer_$y\.txt

#note that for trnL did reverse primer first and then forward
#then rev comp back (note: for trnL, leave out this step for fusion primers as they are sequenced back to front)

#fastx_reverse_complement -i rev_$y\.fasta -o fullq15_$y\.fasta
