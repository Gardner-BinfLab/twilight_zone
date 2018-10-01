#!/usr/bin/perl
use strict; use warnings;

####BETH GAVE YOU THE BASE CODE FOR THIS AND YOU HACKED IT TO WORK FOR YOUR OWN NEEDS ####ACKNOWLEGEMENTS
#DOESN"T WORK AS CAN"T GET FIGTREE TO MAKE THE BLOCK AT THE TOP TO ANNOTATE WITH!!!!!!!!!

##hexdecimal gradient code generator: https://www.strangeplanet.fr/work/gradient-generator/index.php


###run in ~/Documents >>./colour_tree.pl TREE hexidecimal_codes_phylum.tsv 

####what format does the tree file have to be in???? not just newick maybe nexus?? doesn't look like it 
#use phylip retree to put it in phylip??? 16srRNA_uniquegenus_contigonly.tree

if (not defined $ARGV[2]){
	print "missing arguments. use tree, gradient, then sRNAs\n";
	exit;
}

my $tree = $ARGV[0];
my $gradient = $ARGV[1];
my $srnas = $ARGV[2];
chomp($gradient);
chomp($srnas);
chomp($tree);


open(GRADIENT, "< $gradient"); 
open(IN, "< $srnas");
my %hex_gradient;

while(<GRADIENT>){
	my $line = $_; #stores the line from the file in a nice variable
	chomp($line); #removes whitespace
	my @list = split("\t",$line); #split based on tab so hex and label split (my file is 0=hex, 1=tax)
	$hex_gradient{$list[1]} = $list[0]; #stores hex and taxonomy in a hash (key=tax, value=hex)
}

close GRADIENT;
my %acc_colours;

while(<IN>){ ### this loop flicks through the sRNA file (in my case I think this should be the contig name phylum)
	if($_ =~/^\s+(\d+)\s+(\S+)/){ #starts with whitespace (any amount) then has any number of didgets then whitespace then any non whitespace character ######!!!!!!!!!!!!!!! Can change this to just a line starting with anything but whitespace
		$acc_colours{$2} = $hex_gradient{$1}; #$2 is contig name and $1 is taxonomy 
	}
}

close IN;

open(TREE, "< $tree");
open(OUT, "> coloured_$tree");

while(<TREE>){ #flicks through the tree file
	if($_ =~/^\s+([A-Z0-9]+)/){ #finds something that starts with whitespace and then any number of combo of letters and numbers
		if (defined $acc_colours{$1}){ #checks if that node name has a corresponding colour
			my $line = $_;
			chomp $line;
			print OUT $line," ",$acc_colours{$1},"\n"; #prints out the node name and the colour corressponding with it
			}
		else{
			print OUT $_;
		}
	}
	else{
		print OUT $_;
		}
}
close TREE;
close OUT;





