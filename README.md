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

* SWARM https://github.com/torognes/swarm

* BLAST+ https://www.ncbi.nlm.nih.gov/books/NBK279690/
<br></br>

## Initial processing of high throughput sequence data 

### Demultiplexing

* The initial barcode demultiplexing was run using the Fastx toolkit perl script **fastx_barcode_splitter.pl**:

`cat reference_raw_seqs.fastq | fastx_barcode_splitter.pl --bcfile barcodes.txt --bol --mismatches 1 --prefix ./raw_ --suffix ".fastq" > PrimerReport_reference_Barcode.txt`

This split the sequence file into separate files for each sample. Next, each sample file was demultiplexed by primer sequence to sort into separate files for each sample/marker combination. This was run in the bash script **ref_seq_demultiplex_primer.sh** that combined trimming the adapter sequence with the Cutadapt tool, followed by demultiplexing (by primer sequence) using the same script **fastx_barcode_splitter.pl**, as above. 
<br></br>
### Quality and length filtering of sequences



ccmp2\_ref\_trimmer.sh
trnL\_ref_trimmer.sh

<br></br>
### Creating consensus sequences

cluster\_consensus.sh 
(for now, add consensus_builder later)











