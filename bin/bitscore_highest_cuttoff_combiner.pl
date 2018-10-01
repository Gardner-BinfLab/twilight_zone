#!/usr/bin/perl
use strict;
use warnings;
#use Math::Round;


open(my $open1, '<', "combo_highestbs_cmhmm_alphabsorted.txt") or die "Can't open: $!"; my @accessions1=<$open1>; close $open1 or die "$open1: $!";

open(my $open2, '<', "subset_genus_aa_nuc_combined_nocuttoff.tophitpergenomeperhmm") or die "Can't open: $!"; my @accessions2=<$open2>; close $open2 or die "$open2: $!";

open(WRITE, '>', "subset_genus_aa_nuc_combined_nocuttoff_maxbsoldcutoffadded.tophitpergenomeperhmm") or die "Can't open: $!";

my %maxbitscore;

foreach my $line (@accessions1){
	chomp($line);
	my @holder=split(/\s+/,$line);
	chomp($holder[0]);
	chomp($holder[1]);
	$maxbitscore{$holder[0]}=$holder[1];	
}

foreach my $line1 (@accessions2){
	chomp($line1);
	my @holder1=split(/\s+/,$line1);
	chomp($holder1[0]);
	my $maxbitscore=$maxbitscore{$holder1[0]};
	my $oldcutoff=$maxbitscore/3;
	#ssprintf("%.2f", $oldcutoff);
	print WRITE "$holder1[0]\t$holder1[1]\t$holder1[2]\t$maxbitscore\t$oldcutoff\n";		
}


close(WRITE);


