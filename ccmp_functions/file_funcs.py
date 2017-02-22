#!/usr/bin/env python

# basic functions
from Bio.Seq import Seq
from Bio.Blast import NCBIXML
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import IUPAC
from Bio import SeqIO
##import sys

def make_list(file_list):
    """convert lines in file to elements of list. for make_list"""
    file=open(file_list, 'r')
    new_list = []
    for line in file:
        line = line.strip('\n')
        new_list.append(line)
    return new_list


def extract_seqs_name(seq_list, new_file_name, seq_file_name):
    """take input list of sequence ids and extract them from input filename to new fasta file"""
    #new_file_name = 'extracted_'+seq_file_name
    new_file = open(new_file_name, 'w')
    for seq in SeqIO.parse(seq_file_name, 'fasta'):
        rec_id = seq.id
        
        if rec_id in seq_list:
            SeqIO.write(seq, new_file, 'fasta')

def dict_to_seq(hit_dict, outfile_name):
    outfile = open(outfile_name, 'w')
    for key, value in hit_dict.iteritems():
        rec = SeqRecord(Seq(value, IUPAC.unambiguous_dna), id=key, description='')
        SeqIO.write(rec, outfile, 'fasta')
    outfile.close()
    return outfile

 




