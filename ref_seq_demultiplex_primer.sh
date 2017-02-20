#!/bin/bash


for x in raw_*
do 
echo "### $x"
y=${x%.*}
y=${y#*_}

cutadapt -g TACTGCGTACCAATTCAC -a GTTACTCAGGACTCATCGTC -n 10 -O 6 --trimmed-only -m 50 -x "$y"_ $x -o cutadaptTEMP_$y\.fastq > Reportcut_$y.txt

cat cutadaptTEMP_$y\.fastq | fastx_barcode_splitter.pl --bcfile primers.txt --bol --mismatches 1 --prefix ./untrimPrimer_"$y"_ --suffix ".fastq" > PrimerReport_$y\_Barcode.txt

cat PrimerReport_$y\_Barcode.txt >> all_ref1_primercounts.txt

done


