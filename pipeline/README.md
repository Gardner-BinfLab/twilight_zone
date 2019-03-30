# Twilight Zone of Nucleotide Homology 
### 50 Pairs Subset

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
```
find . -regex ".*1hmmalign" | perl -lane '$C=$F[0];$C=~s/1hmmalign/1hmmalignclust/; system("esl-reformat --replace .:- -o $C clustal $F[0]");' 
find . -regex ".*1cmalign" | perl -lane '$C=$F[0];$C=~s/1cmalign/1cmalignclust/; system("esl-reformat --replace .:- -o $C clustal $F[0]");' 
find . -maxdepth 1 -regex ".*.1hmmalignclust" | xargs -ifoo esl-alimanip --lnfract 0.333 --lxfract 1.667 -o foo.fractd foo
find . -maxdepth 1 -regex ".*.1cmalignclust" | xargs -ifoo esl-alimanip --lnfract 0.333 --lxfract 1.667 -o foo.fractd foo
```

Top match chosen - from pool of sequence left after previous steps
```
cat subset_genus_nucleotide_combined.all | perl -ane '$F[0]=~chomp($F[0]); system("grep -w $F[0] header_filenames.txt"); print "$F[3]\t$F[7]\t$F[8]\t$F[9]\t$F[14]\t$F[15]\n";' | perl -ane 'if($F[0]=~/GCF.*/){print "$F[0].";$G=$F[1];}else{print "$F[0]\t$G\t$F[1]\t$F[2]\t$F[3]\t$F[4]\t$F[5]\n";}' | sort -k1,1 -k6,6nr | sort -u -k1,1 >subset_genus_nucleotide_combined_nocuttoff.tophitpergenomepercm 
cat subset_genus_aaseq_combined.all | perl -lane '$F[18]=~s/source=//; system("grep -w $F[18] header_filenames.txt");print "$F[0]\t$F[2]\t$F[4]\t$F[5]\t$F[19]";' | perl -ane 'if($F[0]=~/GCF.*/){print "$F[0].";$c=$F[1];}else{print "$F[1]\t$c\t$F[0]\t$F[2]\t$F[3]\t$F[4]\n";}' | sort -k1,1 -k5,5nr | sort -u -k1,1 >subset_genus_aaseq_combined_nocuttoff.tophitpergenomeperhmm
cat subset_genus_nucleotide_combined.tophitpergenomepercm subset_genus_aaseq_combined.tophitpergenomeperhmm | perl -lane '$F[0]=~s/.*\.fna\.//; $F[0]=~s/bactNOG\.//;$F[0]=~s/\..*raw//; if($F[0]=~m/ENOG.*/){print "$F[0]\t$F[1]\t$F[4]";}if($F[0]=~/RF.*/){print "$F[0]\t$F[1]\t$F[5]";};' >subset_genus_aa_nuc_combined.tophitpergenomeper
```

Reverse translation in from for protein genes
```
find . -regex ".*1hmmalignclust.fractd.clust2" | perl -lane '$F[0]=~s/\.\///;$C=$F[0];$G=$F[0];$C=~s/\.clust2//;$G=~s/\.1hmmalignclust.fractd.clust2/\.fractd.fixedheader/;$C=~s/1hmmalignclust/1hmmalignclustnuc/;system("/home/stephmcgimpsey/Scripts/pal2nal.v14/pal2nal.pl /length_fractd_alignments/$F[0] /gene_sequences/$G >/length_fractd_alignments/$C");'
```


## Twilight Zone Calculation
### PID CALCULATION & SELECTION

PID of all sequences
```
find . -maxdepth 1 -regex ".*.1hmmalignclustnuc.fractd" | perl -lane '$F[0]=~s/\.\///; $F[0]=~s/\:/\t/;$C=$F[0]; $C=~s/1hmmalignclustnuc\.fractd/1alipidnuc/; system("esl-alipid $F[0] >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/$C")'
find . -maxdepth 1 -regex ".*1cmalignclust.fractd.clust2" | perl -lane '$F[0]=~s/\.\///; $F[0]=~s/\:/\t/;$C=$F[0]; $C=~s/1cmalignclust\.fractd\.clust2/1alipidnuc/; system("esl-alipid $F[0] >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/$C")'
```

50 Pairs selection based on PIDs
```
pid_sortnsplit_forfractddata.pl
```


Make sets of files required for alignment process
```
aligner_twilightzone_bitscore_maker_forfractddata_50pairs_redo_headerfilesetup.pl
```

### ALIGNMENT
Four core alignment algorithms
```
find /models -maxdepth 1 -regex "/models/.*\-mixedpid\.fasta\.uniq" | parallel -j procfile --eta './aligner_twilightzone_bitscore_maker_forfractddata_50pairs_redo.pl {}'
```

Split the four outputs into different files
```
for f in `find . -maxdepth 1 -regex ".*.bs_fix2" | perl -lane '$F[0]=~s/\.bs_fix2//; $F[0]=~s/\.\///;print "$F[0]";'`;do grep ":s:" $f.bs_fix2 >/all_aligners_split/$f.s.bs;grep ":n:" $f.bs_fix2 >/all_aligners_split/$f.n.bs;grep ":b:" $f.bs_fix2 >/media/all_aligners_split/$f.b.bs;grep ":g:" $f.bs_fix2 >//all_aligners_split/$f.g.bs;done
```

nhmmer iterative
```
find /models -maxdepth 1 -regex "/models/.*\-mixedpid\.fasta\.uniq" | parallel -j procfile --nice 5 --eta './aligner_twilightzone_bitscore_maker_forfractddata_iterativenhmmer_parallel.pl {}'
```

ssearch34
```
find /models -maxdepth 1 -regex "/models/.*\-mixedpid\.fasta\.uniq" | parallel -j procfile --eta './aligner_twilightzone_bitscore_maker_forfractddata_ssearch34only_parrallelized.pl {}'
```


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
### SHUFFLED CONTROLS AND SHUFFLED DATABASE SET UP (same procedure, different sequences)
Shuffled sequences
```
for f in `find . -maxdepth 1 -regex ".*ENOG.*-mixedpid.fasta.uniq"`;do esl-shuffle -N 2 -k 3 -o $f.shuf $f;done
for f in `find . -maxdepth 1 -regex ".*RF.*-mixedpid.fasta.uniq"`;do esl-shuffle -N 2 -d -o $f.shuf $f;done
find . -maxdepth 1 -regex ".*.fasta.uniq.shuf" | xargs -ifoo cat foo >shuffled_database_50pairs_redo_fasta.db
```
PID calculation - translate proteins, align all to cm/hmm, revtrans protein, alipid
```
for f in `find . -maxdepth 1 -regex ".*ENOG.*-mixedpid.fasta.uniq.shuf"`;do translate -1 -o $f.aa --watson $f;done
 find . -regex ".*.aa" |perl -lane '$F[0]=~s/\.\///; $F[0]=~s/\:/\t/;$C=$F[0];$C=~s/subset_genus_aaseq_combined_nocuttoff\.//;$C="$C\.fa.hmm";print"$F[0]\t$C"; system("hmmalign -o /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/hmmalign_output/$F[0].1hmmalign /home/stephmcgimpsey/Documents/Essential_HMM_CM/HMMs/Eggnog/bactNOG_hmm/$C $F[0]");'
for f in `find . -maxdepth 1 -regex ".*.align"`;do esl-reformat clustal $f $f.clustal;done
find . -regex ".*.align.clust" | perl -lane '$F[0]=~s/\.\///;$C=$F[0];$G=$F[0];$G=~s/align.clust//;$C=~s/align.clust/.nucalign/;system("/home/stephmcgimpsey/Scripts/pal2nal.v14/pal2nal.pl $F[0] $G >$C");'
find . -regex ".*.nucalign" | perl -lane 'system("esl-alipid $F[0] >$F[0].pid")'
find . -regex ".*SHUFFLED NCRNA" |perl -lane '$F[0]=~s/\.\///; $C=$F[0];$C=~s/\.fixedheader//;$G=$C;$C=~s/subset_genus_nucleotide_combined\.//;$C="$C\.cm";print"$F[0]\t$C"; system("cmalign -o /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/cmalign_output/$G.1cmalign /home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/Essential/$C $F[0]");'
find . -regex ".*.nucalign" | perl -lane 'system("esl-alipid $F[0] >$F[0].pid")'
```



### RANDOM
Generate Random Sequences
```
generate_random_sequences_withnucfreqsdecided_samelengthseqs.pl
```

Align Random Sequences
```
GC_simulation_data_aligner.pl
```

PID of Random Sequence
```
GC_simulation_alipid.pl
```

