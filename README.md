# cp_microsatellites
Detailed pipelines for research paper on NGS sequencing of chloroplast microsatellites


**Description**

This repository details the bioinformatic analyses conducted for the manuscript: *The cpSSRs reloaded: the application of universal chloroplast markers in the genomic age* by Patricia Fuentes-Cross, Hugh B. Cross, Michael G. Gardner, Giovanni G. Vendramin, and Andrew J. Lowe. Submitted to *Molecular Ecology Resources*. The scripts contained here include the processing of raw next-generation sequencing data, creating consensus sequences for amplicon sequencing products, and metabarcoding. 


## Software used

Most of the scripts here call and utilize a range of open source tools, as well as one commercial software package (Geneious):

In order of appearance in manuscript:

* FastX Toolkit http://hannonlab.cshl.edu/fastx_toolkit/commandline.html

* Cutadapt https://github.com/marcelm/cutadapt

* Geneious http://www.geneious.com/

* USEARCH http://www.drive5.com/usearch/

* Muscle http://drive5.com/muscle/

* T-Coffee www.tcoffee.org

* OBItools https://git.metabarcoding.org/obitools/obitools/wikis/home

* VSEARCH https://github.com/torognes/vsearch

* SWARM https://github.com/torognes/swarm

* Biopython https://github.com/biopython/biopython.github.io/

* BLAST+ https://www.ncbi.nlm.nih.gov/books/NBK279690/
<br></br>

## Processing of amplicon sequence data 

### Demultiplexing

* The initial barcode demultiplexing was run using the Fastx toolkit perl script **fastx_barcode_splitter.pl**:

`cat reference_raw_seqs.fastq | fastx_barcode_splitter.pl --bcfile barcodes.txt --bol --mismatches 1 --prefix ./raw_ --suffix ".fastq" > PrimerReport_reference_Barcode.txt`

This split the sequence file into separate files for each sample. Next, each sample file was demultiplexed by primer sequence to sort into separate files for each sample/marker combination. This was run in the bash script **ref_seq_demultiplex_primer.sh** that combined trimming the adapter sequence with the Cutadapt tool, followed by demultiplexing (by primer sequence) using the same script **fastx_barcode_splitter.pl**, as above. 
<br></br>
### Quality filtering

Using the bash scripts **ccmp2\_ref\_trimmer.sh** and **trnL\_ref\_trimmer.sh**, all sequences were filtered for quality and length using cutadapt and the fastx toolkit, and primer sequences were trimmed off each end. Because sequence reads could be in either orientation, and to ensure accurate quality from both forward and reverse ends, each read was run through trimming and quality filtering, reverse complemented, and then filters were rerun. All trimmed reads were then combined. 
<br></br>

### Creating consensus sequences for marker comparison

The reads for each species sample were clustered using USEARCH and the most common centroid sequence was extracted to a new file to represent the consensus sequence. The tools were piped together using the script **cluster\_consensus.sh**. Where possible, resulting consensus sequences were compared to existing NCBI sequences of the same species/marker, to confirm the accuracy of the method.
<br></br>

### Calculation of pairwise distances

The program T-Coffee was used to align all consensus sequences for each family, then calculate pairwise distances among all species in each family for both *trn*L and ccmp2, and then average distance among species within each family was output to a file, using the bash script **pairwise_distance_measure.sh**
<br></br>
<br></br>
## Processing of soil metabarcoding data

### Demultiplexing and quality filtering

Raw sequence reads were processed the same as with the amplicon sequencing products, except that no additional sorting into separate species samples was necessary. After demultiplexing, quality and length filtering was done with the bash script **soil_amplicon_trimmer.sh**, separately on ccmp2 and *trn*L samples (using correct primer sequences). 
<br></br>
### OTU clustering

For comparison among samples that differed in number of reads, subsamples were taken of the larger samples using the obisample tool (from Obitools, see above). For example:

`obisample -s 4000 full_DeepCreeksub2_td21_261.fasta > sub1_DeepCreeksub2_td21_261.fasta`

Clustering of the sequence reads into operational taxonomic units, or OTUs, was done using the program swarm, using the related program VSEARCH to dereplicate the sequences first (see references above). As multiple samples and subsamples were clustered, a bash script, **batch_swarm.sh** was used to run through the steps on all files, and output to a text file the number of swarms (OTUs), singletons, and total swarms of more than one (ie without singletons). 
<br></br>
### Subsampling and removing repeats from reads

In order to test for biases in different regions of ccmp2 and *trn*L that could affect the comparison, different files were produced that included only the first or last 80 basepairs of each read. New files with these subsets of each read were made using the bash script **seq_first_last.py**. Additionally, the mononucleotide repeats that are prevalent in both of these chloroplast markers do not sequence well with the Ion Torrent platform, and could greatly accelerate the number of OTUs produced from the analyses. Thus, new files were made that removed any A or T repeats greater than four basepairs in length, using the python script **repeat_seq_remover.py**. For all of these subsets, new OTUs were calculated using the **batch_swarm.sh** script. 
<br></br>

### BLAST search of OTUs

All OTU sequences were searched against NCBI database using blastn on the command line, as for example:

`blastn -query dc_ccmp_sub80_swarms.fasta -db nt -out blast_dc_ccmp_sub80_swarms_fmt6_ev5.txt -evalue 1e-5 -max_target_seqs 20 -outfmt "6 qseqid sseqid staxids sscinames scomnames length evalue qcovs pident nident sstart send stitle sseq"`

All plant genera that were found in this search in both markers were extracted from the blast output using the python script **new_blast_seq_extractor.py**. These sequences were imported into Geneious for alignment and comparison of the two markers. 

Note: since creating this pipeline, I have made an all-purpose blast-parsing script that can read any blast output in tabular format. See https://github.com/hughcross/genbanking for details. 












