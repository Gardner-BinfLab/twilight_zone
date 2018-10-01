#!/usr/bin/perl
use warnings;
use strict;


#seqnum_phylum_16srRNA_annotations_iTOL.txt
#contig_phylum_16srRNA_annotations_iTOL.txt
#hexidecimal_codes_phylum.tsv 


open(my $seq,"<","seqnum_phylum_16srRNA_annotations_iTOL.txt") or die "Can't open the seqnum one; $!"; 
open(SEQ,">","seqnum_phylum_16srRNA_annotations_iTOL_hexcol.txt") or die "Can't make seqnum file; $!";

my $count=0;
while (my $row = <$seq>) {
	if ($count>=3){
	chomp $row;
	my @split=split('\s',$row);
	chomp($split[1]);chomp($split[0]);
	my @gresult=`grep "$split[1]" hexidecimal_codes_phylum.tsv`;
	my @split2=split('\s',$gresult[0]);
	chomp($split2[0]);
  	print SEQ "$split[0]\tclade\t$split2[0]\tnormal\t1\n";	
	}
	else{
	print SEQ "$row";
	}
$count++;	
}


#open(my $contig,"<","contig_phylum_16srRNA_annotations_iTOL.txt") or die "Can't open the contig one; $!"; 
#open(CONTIG,">","contig_phylum_16srRNA_annotations_iTOL_hexcol.txt") or die "Can't make contig file; $!";

#my $count1=0;
#while (my $row1 = <$contig>) {
#	if ($count1>=3){
#	chomp $row1;
#	my @split1=split('\s',$row1);
#	chomp($split1[1]);chomp($split1[0]);
#	my @gresult1=`grep "$split1[1]" hexidecimal_codes_phylum.tsv`;
#	my @split21=split('\s',$gresult1[0]);
#	chomp($split21[0]);
#	my @split22=split("_",$split1[0]);
#	$split22[1]=~s/\..*//g;
 # 	print CONTIG "$split22[0] $split22[1]\tclade\t$split21[0]\tnormal\t1\n";	
#	}
#	else{
#	print CONTIG "$row1";
#	}
#$count1++;	
#}
