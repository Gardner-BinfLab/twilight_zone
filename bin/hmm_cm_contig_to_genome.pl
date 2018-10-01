#!/usr/bin/perl
use strict;
use warnings;

### RUN IT LIKE THIS  ./hmm_cm_contig_to_genome.pl genome_test_for_completeness_new_tidy.txt 

### RUN IN cd /home/stephmcgimpsey/Documents

##Test step
#Opens header to filename file
#Stores file name as key and header as value in a hash
#trims to the file name to just the accession part
#spits the file names out as a count and tells you the % of the total number of filenames that are present
my @store;
my @results;
#open header->contig

#open(my $open, '<', "/home/stephmcgimpsey/Documents/header_filenames.txt") or die "Can't open header_filenames.txt: $!"; my @open=<$open>; close($open) or die "Can close header_filenames.txt: $!";
####open(my $open, '<', "header_filenames.txt") or die "Can't open header_filenames.txt: $!"; my @open=<$open>; close($open) or die "Can close header_filenames.txt: $!";
####my $orig_size=scalar(@open);
#open $ARGV[0] aka the contigs grepped from hm/cm output
open(my $open1, '<', "$ARGV[0]") or die "Can't open $ARGV[0]: $!"; my @accessions=<$open1>; close $open1 or die "$open1: $!";
my $num_contig=scalar(@accessions);
#find matching line from argv0 to head/contig

open(WRITE, '>', "contig_filename_hmmsearch_genometest.txt") or die "Can't make contig_filename_hmmsearch_genometest.txt; $!";
foreach my $line (@accessions){
	@results=();
	my @ll=split(/\s+/,$line);
	chomp($ll[0]);
	#print "$ll[0]\n";
	@results=`grep -w "$ll[0]" header_filenames.txt`;
####@results=grep /$ll[0]/, @open;
	
	#@open=grep ! /$line/, @open;
	#print "$line\n";print "$results[0]\n";
	$results[0]=~s/\t.*//;#$results[0]=~s/_genomic.fna//;$results[0]=~s/.*_//;
	#push @store, $results[0];
	chomp($results[0]);
	print WRITE"$results[0].$ll[1]\t$line";


	#my $size=scalar(@open);print "$size\t";




}
close(WRITE);
#do your magic


###NEXT STEPS IN THE TERMINAL!!!
#->$ cat contig_filename_hmmsearch_genometest.txt |  sort -k1,1 -k5,5nr | sort -u -k1,1 >top_contiggenome_hmmsearchhit_genomecompleteness.txt






#my $new_size=scalar(@open); #number of filenames left in open
#my $matches=scalar(@results); #number of matches
#my $percent_found=($matches/$orig_size)*100;
#print "$matches found\n$new_size left\n$percent_found% Percent genomes found\n";
