# Twilight Zone of Nucleotide Homology

Research by Stephanie McGimpsey 

Supervision by Paul Gardner

## Database Creation

### GENOME DOWNLOAD
Download Genomes
```
genome-slurp.sh
```
Contig uniqueness check

### TAXONOMY DOWNLOAD
Setup taxonomizr
```
taxonomizr_setup.R
```
Get taxonomy data for NCBI RefSeq genome accession IDs
```
taxonomizr_steph.R
```

### CORE GENE SELECTION - mRNA

### GENUS REPRESENTATIVE SUBSET SELECTION
Concatenate genomes in to one file, reverse translate and index 
```
find . -name "*.fna" -print0 | xargs -0 cat >combined_refseq_genomes.fna
esl-sfetch --index combined_refseq_genomes.fna
esl-translate -l 20 combined_refseq_genomes.fna >6FrameTrans_combined_refseq_genomes.txt
sl-sfetch --index 6FrameTrans_combined_refseq_genomes.txt
```
Search genomes for 16s rRNA
```
```
Search genomes for six DNA replication genes - split 6 frame translation file up first to allow parallel implementation
```
./database_splitter.pl
```
### CORE GENES FOR GENUS REPRESENTATIVE SUBSET


## Twilight Zone Calculation
### PID CALCULATION & SELECTION


### ALIGNMENT


### SENSITIVITY CALCULATION


### TWILIGHT ZONE AND BOOTSTRAP
