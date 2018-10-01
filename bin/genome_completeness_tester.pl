#!/usr/bin/perl
use warnings;
use strict;
#New program to check which contigs belong to which genome and to count how many unique gene matches (ignore multiple hits to the same cm in one genome) each genome has so we can figure out which genomes to ditch

open(my $a, '<', $ARGV[0]) or die "Can't open $a; $!"; my @a=<$a>; close($a); 
open(my $b, '<', "header_filenames.txt") or die "Can't open $b; $!"; my @b=<$b>; close($b); 

my %storage;
foreach my $line2 (@b){
my @header=split('\t',$line2);
chomp($header[1]);chomp($header[0]);
$storage{$header[1]}=$header[0]; #hash stores contig as key and filename as value
}

my %countstore;
my $s;
my @split;
foreach my $line (@a){
chomp($line);
print "$line\n";
@split=split('\t',$line);$s=$split[0];$s=~s/\.[0-9]+$//; #now is just the contig number none of the rev trans annotations
chomp($s);
#print "$s\n";
	print "$storage{$s}\t$s\t$split[1]\n" if exists $storage{$s}  ;





}


