#!/usr/bin/perl
use warnings;
use strict;

####THis script takes the tree output and changes the names from seq1 blah blah to phylum-seq number


##./phylip_seqnamer_phylumincluded_labels.pl 16s-rRNA_uniquegenus_phylipheaders.phylum /home/stephmcgimpsey/Documents/16srRNA_uniquegenus1.outtree 16srRNA_uniquegenus1.newtree
##TEST
##./phylip_seqnamer_phylumincluded_labels.pl 16s-rRNA_uniquegenus_phylipheaders.phylum /home/stephmcgimpsey/Documents/test_sets/test_tree

open(my $file,"<", $ARGV[0]) or die "Can't open $ARGV[0]; $!"; my @file=<$file>; close($file) or die "Can't close $ARGV[0]; $!";

open(my $file1, "<", $ARGV[1]) or die "Can't open $ARGV[1]; $!"; my @file1=<$file1>; close($file1) or die "Can't close $ARGV[1]; $!";




foreach my $line (@file){
	my @line_split=split('\t',$line);
	chomp($line_split[0]); chomp($line_split[2]);
	$line_split[1]=~s/\.[0-9]+//;
	my $newlab="$line_split[1]";
	#print "$newlab";	
	#system("sed -i 's/$line_split[0]/$newlab/g' @file1");
	foreach my $line1 (@file1){
		if ($line1=~m/$line_split[0]\:/){
			#print "$line1";
			$line1=~s/$line_split[0]\:/$newlab\:/g;
			#print "$line1";
		}
	}
}


open(WRITE,">",$ARGV[2]) or die "Can't make file $ARGV[2]; $!";
print WRITE "@file1";

close(WRITE);
