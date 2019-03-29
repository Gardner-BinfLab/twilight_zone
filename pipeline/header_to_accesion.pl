#!/usr/bin/perl
use strict;
use warnings;


###STEP3.1###
#this opens the file of accession numbers and then searches the file with TAX ID's in it 
#ARGV1=acc's. $ARGV2=taxID+acc


open(my $open, '<', "$ARGV[0]") or die "Can't open $ARGV[0]: $!"; my @accessions=<$open>; close $open or die "$open: $!";
print "Accession file open\n";
#open(my $open1, '<', "$ARGV[1]") or die "Can't open $ARGV[1]: $!"; my @taxID=<$open1>; close $open1 or die "$open1: $!"; #############this is way tooooooo big so need to split it and then open and close each file to free up memory
#shift @taxID; #this only needs to happen once
#print "TaxID file open\n";
my $acc_filename="accessions.txt";
open(OUT, '>', "$acc_filename") or die "Can't make file: $!";

foreach my $line (@accessions){
	chomp($line);
#remove the > and everything after 
	$line=~s/\>//g;
	my @line=split('\s+',$line);
	my $acc_version=$line[0];
	print OUT "$acc_version\n";
	
}


close(OUT);
print "Accessions saved to new file: $acc_filename\n";

#foreach my $line1 (@taxID){
	#	my @line1=split('\t',$line1);
	#	my $tax_ID=$line1[1];
#choose the accession version IE 2nd column
		#if ($tax_ID=~m/$acc_version/){
		#	print OUT "$line1[2]\n";
#remove the line from the taxID array so that the search space becomes smaller everytime they find a matching accession
		#}
		#else{
		#	#print "$tax_ID \t $acc_version \n";
		#}
	#}

