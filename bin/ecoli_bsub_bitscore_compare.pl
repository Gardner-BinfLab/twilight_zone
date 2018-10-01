#!/usr/bin/perl
use warnings;
use strict;


### ./ecoli_bsub_bitscore_compare.pl | sort -n -k3 >sum_prop_ecoli_bsub_hmms.txt



open(my $a, "<", "/home/stephmcgimpsey/Documents/Essential_HMM_CM/HMMs/combined_ecoli_bsub_eggnoghmm_tophits.txt") or die "Can't open $a; $!"; my @a=<$a>; close($a) or die "Can't close $a;$!";
my $size=scalar(@a);
#print "$size\n";
my $count=0;
while ($count<$size) {
	my $line=$a[$count]; chomp($line);
	my @split=split('\t',$line);
	my $line2=$a[$count+1]; chomp($line2);
	my @split2=split('\t',$line2);
	if($split[1]=~$split2[1]){
		my $sum=$split[3]+$split2[3];
		my $proportion=$split[3]/$sum;
		print "$split[1]\t$sum\t$proportion\t$split[0]\tCAB is B.sub, BAL is E.coli (species the proportion relates to)\n";
		

		$count=$count+2;
	}
	else { 
		
		print "$split[1]\t$split[3]\t1\t$split[0]\tCAB is B.sub, BAL is E.coli (species that has this HMM)\n";
		$count++;
		
	}

}
