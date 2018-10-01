#!/usr/bin/perl
use strict;
use warnings;
use English;

my $dir = '~/Documents/Accessions_splitfiles/100_split_accs';
open(OUT, '>', "100_perLine_com") or die "Can't make file: $!";
foreach my $fp (glob("$dir/ACC*")) {

	#printf $fp;


	open(my $fh, '<', $fp) or die "Can't open $fp: $!"; my @accessions=<$fh>; close $fh or die "$fh: $!";
		
	$fp =~ s/.*\///;
	#open(OUT, '>', "$fp\_com") or die "Can't make file: $!";
	my $k=1;
	  foreach my $line (@accessions) {
		if ($k=~scalar(@accessions)){
			chomp($accessions[$k-1]);
	    		print OUT "$accessions[$k-1]";
		} else{
			chomp($accessions[$k-1]);
	    		print OUT "$accessions[$k-1],";
		}
	$k++;
	  }
	  print OUT "\n";
	#close(OUT)
}

#NZ_CWSG01000001.1NZ_FCXG01000001.1
