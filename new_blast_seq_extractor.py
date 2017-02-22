#!/usr/bin/env python

# format of blast results
# qseqid sseqid staxids sscinames scomnames length evalue qcovs pident nident sstart send stitle sseq

from ccmp_functions.file_funcs import *
#from Bio import SeqIO

# This was run on all blast files, for example:
blastfile = open('blast_dc_trnL_sub2k_swarms_fmt6_ev5.txt', 'r')

search_terms = make_list('ccmp_blast_genera.txt')
hitlist = []
query_list = []
pine_dict = {}
euc_dict = {}
pine_otulist = []
euc_otulist = []

for line in blastfile:
	line = line.strip('\n')
	line_parts = line.split('\t')
	queryfull = line_parts[0]
	query = queryfull +';'
	ref_id = line_parts[1]
	taxid = line_parts[2]
	length = line_parts[5]
	sciname = line_parts[3]
	genus = sciname.split(' ')[0]
	common = line_parts[4]
	qcov = int(line_parts[7])
	sseq = line_parts[13].replace('-','')
	if qcov >= 90:
		if genus in search_terms:
			newsci = sciname.replace(' ','_')
			newid = newsci+'_'+ref_id
			if ref_id in hitlist:
				if genus == 'Pinus':
					if len(sseq) > len(pine_dict[newid]):
						pine_dict[newid]=sseq
				else:
					if len(sseq) > len(euc_dict[newid]):
						euc_dict[newid]=sseq
				
			else:
				hitlist.append(ref_id)
				#gb_file.write(ref_id+'\t'+taxid+'\t'+sciname+'\t'+common+'\n')
				newsci = sciname.replace(' ','_')
				newid = newsci+'_'+ref_id
				if genus == 'Pinus':
					pine_dict[newid]=sseq
				else:
					euc_dict[newid]=sseq

			if query in query_list:

				pass
			else:
				query_list.append(query)
				if genus == 'Pinus':
					pine_otulist.append(query)
				else:
					euc_otulist.append(query)

#print len
#print query_list
print len(query_list)
#print hitlist
print pine_otulist
print len(hitlist)
#print len(euc_dict['Angophora_costata_gi|442569228|gb|KC180805.1|'])
#print euc_dict
#print pine_dict

# now extract seqs to file with function (dict to seq), then extract otus
dict_to_seq(euc_dict, 'dc_trnL_euc_ref_seqs.fasta')
dict_to_seq(pine_dict, 'dc_trnL_pinus_ref_seqs.fasta')
extract_seqs_name(euc_otulist, 'dc_trnL_euc_otu_seqs.fasta', 'dc_trnL_sub2k_swarms.fasta')
extract_seqs_name(pine_otulist, 'dc_trnL_pinus_otu_seqs.fasta', 'dc_trnL_sub2k_swarms.fasta')




