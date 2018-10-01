#!/usr/bin/perl
use warnings;
use strict;


print "Grabbing 16srRNA sequences...this will take forever...\n";
my $cnt=0;
unlink("16s-rRNA_uniquegenus.fa");
open(my $close,'<', "/home/stephmcgimpsey/Documents/uniqgenus_noNA_candidatusincluded_topfilecmhits.txt") or die "Can't open rough 16srRNA file: $!"; 



	while(my $in = <$close>){

		my @in = split(/\s+/, $in);
		my $fullPathFileName = "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/refseq-bacterial/$in[0]"; 
				
			if(not -s "$fullPathFileName\.ssi"){
				system("esl-sfetch --index $fullPathFileName");
			}

		system("esl-sfetch -c $in[4]-$in[5] -n \42$in[2]_$in[4]-$in[5] $in[7] $in[0]\42 $fullPathFileName $in[2] >> 16s-rRNA_uniquegenus.fa");
		$cnt++;
		#last if ($cnt==5);				
		
	}
	
	close($close) or die "Can close rough 16srRNA file: $!";




print "DONE\n";
