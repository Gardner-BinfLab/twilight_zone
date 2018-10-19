#!/usr/bin/perl
use warnings;
use strict;




#./tree_maker.pl classphylum_counts_genussubset.txt phylum_counts_genussubset.txt

open(FILE,"<", $ARGV[0]) or die "Can't open $ARGV[0]; $!";
open(FILE1,"<", $ARGV[1]) or die "Can't open $ARGV[1]; $!";

