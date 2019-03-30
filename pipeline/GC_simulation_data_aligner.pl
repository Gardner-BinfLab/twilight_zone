#!/usr/bin/perl
use warnings;
use strict;

##open GC content fiiles (use the txt files as it goes >header on one line, sequence on the next, otherwise fasta format means I'll have to invoke a sed one liner)
##pick first sequence off, align to rest of database
##remove it from the file (not permanently)
##repeat with next sequence
##reduces repeat alignments 


#>>./GC_simulation_data_aligner.pl GC_simulation_lengthredone.txt
#./GC_simulation_data_aligner.pl GC_simulation_lengthredone.txt GC_simulation_100nuclengthredone_1000seq.txt GC_simulation_1000nuclengthredone_1000seq.txt


foreach my $file (@ARGV){
	chomp($file); my $file_for_filename=$file; $file_for_filename=~s/\.txt//;print "$file_for_filename\t";
	open(my $file_content, "<", $file) or die "Can't open $file; $!"; my @file_content=<$file_content>; close($file_content) or die "Can't close $file; $!";
	my $size_file=scalar(@file_content); my $num_seqs=$size_file/2; my $test=$size_file; my @file4chomping=@file_content;
	
	while($num_seqs>1){
		print "Query + database size: $num_seqs\n";
		my @query=@file4chomping[0..1]; 
		my $queryname=$query[0];
		$queryname=~s/\>//;
		print "$queryname"; chomp($queryname);
		shift(@file4chomping); shift(@file4chomping);
		$size_file=scalar(@file4chomping);
		$num_seqs=$size_file/2;
				open(WRITE1, ">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_query_sequences.txt") or die "Can't make temp_query_sequences.txt; $!";
		print WRITE1 for @query;	
		close(WRITE1);

		print "Number of sequences left: $num_seqs\n";
		open(WRITE, ">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_database_sequences.txt") or die "Can't make temp_database_sequences.txt; $!";
		print WRITE for @file4chomping;	
		close(WRITE);

		system("esl-reformat FASTA /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_database_sequences.txt >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_database_sequences.fasta");
		system("esl-reformat FASTA /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_query_sequences.txt >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_query_sequences.fasta");

		system("esl-sfetch --index /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_database_sequences.fasta >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/junk.file");
		my $num_seqs_to_show=$num_seqs+1;

		my @ss_output=`~/Software/fasta36/bin/ggsearch36 -C 30 -M 50-6400 -f 10 -g 6 -r "+5/-4" -T 6 -E 1000000000000000 -b $num_seqs_to_show -3 -m 10 -d $num_seqs_to_show -n -q -H -z -1 /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_query_sequences.fasta /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/temp_database_sequences.fasta`; #ggsearch only finds thing 80% or 120% of length so M is forcing it to align to the whole database
		
		#my $filename="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$file_for_filename-$queryname.ggsearch";
		my $filename="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Shuffled/$file_for_filename-$queryname.ggsearch";
		open(WRITE2, ">", $filename) or die "$filename; $!";
		print WRITE2 "@ss_output";
		close(WRITE2);
		#print "@ss_output\n";
		

		#if ($test>$size_file){
		#last;
		#}








	}



}

print "\n";






