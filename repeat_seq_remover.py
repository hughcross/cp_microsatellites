#!/usr/bin/env python
from ccmp_functions.file_funcs import *
from Bio import SeqIO
import re

filelist = make_list('subset_ccmp_files.txt')

for item in filelist:
	fh = open(item, 'r')
	no_repeat_filename = 'no_repeat_'+item
	#new_front = open(new_front_filename, 'w')
	seq_dict = {}
	for record in SeqIO.parse(fh, 'fasta'):
		rec_id = record.id
		recseq = str(record.seq)
		
		Arpt = re.finditer(r"AAAA+", recseq)
		start = []
		stop = []

		for match in Arpt:
			rpt_start = match.start()
			rpt_end = match.end()
			start.append(rpt_start)
			stop.append(rpt_end)

		newseq = ''
		if len(stop) == 0:
			finalseq = recseq
		elif len(stop) == 1:
			sub1 = recseq[0:start[0]]
			sub2 = recseq[stop[0]:]
			finalseq = sub1+'a'+sub2
		else:
			for i in range(0,len(stop)):
				if i == 0:
					subseq = recseq[0:start[i]]
					newseq += subseq+'a'
				else:
					subseq = recseq[stop[i-1]:start[i]]
					newseq += subseq+'a'
			finseq = recseq[stop[-1]:]
			finalseq = newseq+finseq

		Trpt = re.finditer(r"TTTT+", finalseq)
		startT = []
		stopT = []

		for match in Trpt:
			rpt_startT = match.start()
			rpt_endT = match.end()
			startT.append(rpt_startT)
			stopT.append(rpt_endT)

		newseqT = ''

		if len(stopT) == 0:
			final_seq = finalseq
		elif len(stopT) == 1:
			sub1 = finalseq[0:startT[0]]
			sub2 = finalseq[stopT[0]:]
			final_seq = sub1+'t'+sub2
			
		else:
			for i in range(0,len(stopT)):		
				if i == 0:
					subseq = finalseq[0:startT[i]]
					newseqT += subseq+'t'
				
				else:
					subseq = finalseq[stopT[i-1]:startT[i]]
					newseqT += subseq+'t'
			finseqT = finalseq[stopT[-1]:]
		
			final_seq = newseqT+finseqT

		seq_dict[rec_id]=final_seq
	#print seq_dict
	dict_to_seq(seq_dict, no_repeat_filename)








