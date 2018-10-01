#!/usr/bin/perl
use warnings;
use strict;

open(my $hmm, "<", "/home/stephmcgimpsey/Documents/Essential_HMM_CM/HMMs/Eggnog/146_coregenes.hmm") or die "Can't open concatenated hmm file; $!"; my @hmm=<$hmm>; close($hmm) or die "Can't close file; $!";
open(HMM, ">", "/home/stephmcgimpsey/Documents/Essential_HMM_CM/HMMs/Eggnog/146_coregenes_gacutoff.hmm");

my $gacutoffline=();
my $count=0;
foreach my $line (@hmm){
	

#Find HMMER3 - use that to reset any storage variables
	if($line=~m/HMMER3.*/){
		print HMM "$line";

	}
#Use name to grep the ~/Documents/Essential_HMM_CM/HMMs/Eggnog/hmm_highestbitscorepossible.txt
#Find the cutoff , divide by 3
	elsif($line=~m/NAME.*/){
		print HMM "$line";
		my @split=split(/\s+/,$line); chomp($split[1]);
		my $namestore="$split[1].fa.hmm";
		print "$namestore\t";
		my @grep=`grep -w $namestore ~/Documents/Essential_HMM_CM/HMMs/Eggnog/hmm_highestbitscorepossible.txt`;
		chomp($grep[0]);
		my @split2=split(/\s+/,$grep[0]);
		chomp($split2[1]); my $maxbs=$split2[1];
		my $gacutoff=$maxbs/3; $gacutoff=sprintf("%.2f", $gacutoff);
		$gacutoffline="GA    $gacutoff $gacutoff;\n";
		#print "$gacutoffline";
		#print "$maxbs\t$gacutoff\n";
		$count++;
		
	}
#add line into file below CKSUM
#GA[4x\s]NUM[1x\s]NUM;	
	elsif ($line=~m/CKSUM.*/){
		print HMM "$line";
		print HMM "$gacutoffline";
	}
	else{
		print HMM "$line";
	}
#just print the rest of the lines in order













}
print "\nNumber of HMM's with GA cut off added: $count\n";

close(HMM);

