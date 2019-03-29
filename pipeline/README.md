# Twilight Zone of Nucleotide Homology

Research by Stephanie McGimpsey 

Supervision by Paul Gardner

## Database Creation

### GENOME DOWNLOAD
Download Genomes
```
genome-slurp.sh
```
Store accession and contig names as reference to filename
```
grep -H -R ">" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/refseq-bacterial/ | uniq | perl -lane '$F[0]=~s/.*\///; $F[0]=~s/\:\>/\t/;print $F[0];' >/home/stephmcgimpsey/Documents/header_filenames.txt
/home/stephmcgimpsey/Documents/header_to_accesion.pl
```

### TAXONOMY DOWNLOAD
Setup taxonomizr
```
taxonomizr_setup.R
```
Get taxonomy data for NCBI RefSeq genome accession IDs
```
taxonomizr_steph.R
```
Split genomes by taxonomy rank

```
/home/stephmcgimpsey/Documents/accession_choser.pl
```


Labelled contigs, filenames with genus
```
 cat ~/Documents/Genus | perl -ane 'if($F[0]=~/>.*/){$F[0]=~s/>//;$N=$F[0];} else { $k=0; while ($k<scalar(@F)){print "$N\t";system("grep -w $F[$k] header_filenames.txt"); $k=$k+1;}}' >filename_genus_firstcontigsonly.txt
```

Make taxonomic rank tree
```
(echo "(" && cat classphylum_counts_genussubset.txt | awk '{print $2"_"$1}' | uniq | sed 's/\_/ /' | perl -lane 'if($F[0] eq $newClass ){ $orders .= ($F[1] . ","); }else{chop($orders); print "($orders)$newClass,"; $orders="$F[1],"; $newClass = $F[0]; } ' && echo ")Bacteria;") >halfwaydone_genussubset_tree_newick.dnd
cat phylum_counts_genussubset.txt | awk '{print $2"_"$1}' | perl -lane '$printthis=$F[0]; chomp($printthis); $checker=$F[0]; $checker=~s/\_[0-9]+//g; print "$checker\t$printthis"; system("sed 's/$checker/$printthis/g' halfwaydone_genussubset_tree_newick.dnd");'
Upload to iTOL + taxonomy_colourer_iTOL_genussubset.txt + taxonomy_phylumlabeller_iTOL_genussubset.txt
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
cmsearch -g RF00177.cm combined_refseq_genomes.fna
./cmsearch_to_seqs.pl 1 2 header_filenames.txt /home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/all_genomes_16srRNA_no#.tbl
cat ~/Documents/Essential_HMM_CM/CMs/rough_cmsearch_filenames_16srRNA_bitscorecutoffadded.txt | perl -ane 'if($F[0]=~/>/){$F[0]=~s/>//; print "$F[0]\t"; system("grep -w $F[0] filename_genus_firstcontigsonly.txt");}else{print "@F\n";}' >allcmhits_filenames_genus_coordsBS.txt
```
Search genomes for six DNA replication genes -split 6 frame translation file up first to allow parallel implementation
```
./database_splitter.pl
ls *.fa | parallel --jobs 36 --eta --nice 5 'hmmsearch -o output.txt --noali -E 1e-7 --tblout {}.tbl /Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/new_testset_eggnog.hmm {}'
find . -regex ".*.tbl" -print0 | cat | grep -v ^">" >combined_eval1e10_hmmhits_parrallelrun.txt 
cat combined_eval1e10_hmmhits_parrallelrun.txt | perl -lane '$F[0]=~s/.[0-9]+$//; print "$F[0]\t$F[2]\t$F[4]\t$F[5]\t@F[18..scalar(@F)]";' >cat combined_eval1e10_hmmhits_parrallelrun_tidy.txt
./hmm_cm_contig_to_genome.pl combined_eval1e10_hmmhits_parrallelrun_tidy.txt
cat combined_eval1e10_hmmhits_parrallelrun_filenames.txt |  sort -k1,1 -k5,5nr | sort -u -k1,1 >combined_eval1e10_hmmhits_parrallelrun_tophitperhmmpergenome.txt
cat combined_eval1e10_hmmhits_parrallelrun_tophitperhmmpergenome.txt | perl -lane '$F[0]=~s/.fna.bactNOG.*//;print "$F[0]";' | uniq -c | sort -k1,1 | perl -lane 'print "$F[0]";' | uniq -c
cat allcmhits_filenames_genus_coordsBS.txt | perl -ane 'if($F[0]=~/GCF_.*/){if($F[1]=~/NA/){$N=1;}else{print "$F[0]\t$F[1]";$N=0;}}else{next if ($N=~1); print "\t$F[0]\t$F[3]\t$F[7]\t$F[8]\t$F[9]\t$F[14]\t$F[15]\n";}' | sort -u -k1,1 | sort -k2,2 -k8,8nr | sort -u -k2,2 >uniqgenus_noNA_candidatusincluded_topfilecmhits.txt
./sequence_grabber_from_coordinates.pl uniqgenus_noNA_candidatusincluded_topfilecmhits.txt
```
### CORE GENES FOR GENUS REPRESENTATIVE SUBSET
mRNA core genes - HMM search of genus representative reverse translated genomes 
```
ls *.fa | parallel --jobs 36 --eta --nice 5 'hmmsearch --noali --cut_ga --tblout {}.tbl /Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/146_coregenes_gacutoff.hmm {} >/dev/null'
```
ncRNA core genes - CM search of genus representative genomes
```
ls *.fa | parallel --jobs 36 --eta --nice 5 'cmsearch --T 20 --noali --tblout {}.tbl /Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/combined_9cms_1thirdmaxbs.cm {} >/dev/null'
```

tRNA core genes - tRNAscan of genus representative genomes
```
ls *.fna |  parallel --jobs 36 --eta --nice 5 'tRNAscan-SE -B -o {}.tRNA {}'
```

Length restrictions

Top match chosen

Reverse translation in from for protein genes

## Twilight Zone Calculation
### PID CALCULATION & SELECTION



### ALIGNMENT
Four core alignment algorithms

nhmmer iterative

ssearch34


### FPR SIMILARITY THRESHOLD
Determining the similarity threshold and labelling true homologous pairs as above or below
```
./twilightzone_maker_forfractd.pl
```

### TWILIGHT ZONE SENSITIVITY PER PID AND BOOTSTRAP
Bootstrap and Graph all rolled into one
```
final_twizone.R
```
## SHUFFLED AND RANDOM CONTROLS
### SHUFFLED


### RANDOM
