#!/usr/bin/perl
use warnings;
use strict;



###/home/stephmcgimpsey/Documents/16srRNA_uniquegenus1.newtree
###test set ::: /home/stephmcgimpsey/Documents/test_sets/test_newick_4cladecollapse


#basically have to parse each line and find the stuff between () and if the phylo name is the same just take the branch length after the brackets replace the whole bracketed bit with the first one (minus the contig name) followed up with a :

#e.g. ((NAME:0.5,NAME:0.3):0.55,(NAME1:0.2,NAME2:0.3):0.33) --> (NAME:0.55,(NAME1:0.2,NAME2:0.3):0.33)

open(my $tree, "<", $ARGV[0]) or die "Can't open $ARGV[0]; $!"; my @tree=<$tree>; close($tree) or die "Can't close $ARGV[0]; $!";


###will have to write tree to file and then iterate back through the loop as the bracketing changes. Make a condition where as you loop through a count is kept somewhere and it that count is zero then you don't loop back through again which basically means if no changes are made in that run through then we break out.


foreach my $line (@tree){
#print "----1s\n";
	chomp($line);#print "$line\n";	
	my @split_line=split(/\(/,$line);

	foreach my $line1 (@split_line){
#print "---2s\n";
		chomp($line1);#print "$line1\n\n";
		my @split_line1=split(/\)/,$line1);

		foreach my $line2 (@split_line1){
#print "---3s\n";		my $n=0;
			chomp($line2); #print "$line2\n\n";
			my @split_line2=split(/\,/, $line2);	
			my $length=scalar(@split_line2);
			#print "NUMBER OF THINGS: $length\n";
			#print "@split_line2\n";
			my %hash_counter=();
			my @otherbits;
####what I want to do is check if all the names in the bracket are the same phylo and if 1+ is diff DON'T collapse
	#so maybe you should crop all the things in the line using s/_.*// and then compare them all by using them as the key for a hash and if the number of keys =1 at the end then they are all the same so nab the next bit			
			foreach my $line3 (@split_line2){ #pushes all the phylo and math objects into an array
				push @otherbits, $line3;
				#if ($line3=~m/[A-Za-z]+\_\w+/){ #is a phylo object
#print "-4s\n";				
					if($length>1){ #more then one phylo object at that level ######this is not specific enough
						
							$line3=~s/_.*//; chomp($line3);
							$hash_counter{$line3}++;
							print "$hash_counter{$line3}\t$line3\n";
						
					}
				#}		
			}

			if (scalar(keys %hash_counter)==1 && $length>1){
				print "$_" for keys %hash_counter;
			}
			else{
				if ($length>1){
					
				print "(@otherbits)\n";
				}
				
			}							

				
				
				
				
#########
#print "-4e\n";
		}
#print "---3e\n";

	}
#print "---2e\n";
















}
#print "----1e\n";
