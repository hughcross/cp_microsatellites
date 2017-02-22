#!/usr/bin/env python

# script to sample first and last 80 bp of each sequence
from ccmp_functions.file_funcs import make_list
from Bio import SeqIO

# make list of files, but for now, to test
filelist = make_list('first_last_ccmp_list.txt')

#seqfile = open('sub80_Deep_Creek_td21_ccmp_H112.fasta', 'r') # for single sequences
#output = open('fr80bp_sub80_Deep_Creek_td21_ccmp_H112.fasta', 'w')
#Routput = open('r80bp_sub80_Deep_Creek_td21_ccmp_H112.fasta', 'w')


for seqin in filelist:
	seqfile = open(seqin, 'r')
	outputname = 'f80bp_'+seqin
	Routputname = 'r80bp_'+seqin
	output = open(outputname, 'w')
	Routput = open(Routputname, 'w')

	for record in SeqIO.parse(seqfile, 'fasta'):
		seq = record.seq
		if len(seq) < 80:
			continue
		else:
			frontrec = record[:80]
			lastrec = record[-80:]
			SeqIO.write(frontrec, output, 'fasta')
			SeqIO.write(lastrec, Routput, 'fasta')

	output.close(); Routput.close()
