#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw/shuffle/;



foreach my $i (@ARGV){
	open(my $a, "<", "$i") or die "Can't open $i; $!"; my @a=<$a>; close($a);
	open(A, ">", "$i.chosen") or die "Can't make $i.chosen; $!";
	open(B, ">", "$i.accNums") or die "Can't make $i.accNums; $!";
print "Enter the max number of accesssions you want for $i: ";

my $X = <STDIN>; # I moved chomp to a new line to make it more readable
chomp $X; # Get rid of newline character at the end
exit 0 if ($X eq "");


	foreach my $line (@a){	
		#print "foreach\n";
		if ($line=~m/>.*/){
			chomp($line);
			print A "$line\n";
			$line=~s/>//g;
			print B "$line\t";
			#print "header line\n";


		}
		else{
			#print "accessions line\n";
			
			my @line_array=split /\s/, $line; #this is working
			print B scalar(@line_array),"\n";
			@line_array=shuffle(@line_array);
			
			
			##now put in a bit that prints the first 10 elements or all the accessions if it has a smaller set then ten
				if (scalar(@line_array)<$X){
					
					#print ">>>>Less then $X accessions\n";
					my $Z=scalar(@line_array)-1;
					print A "@line_array[0..$Z]\n";				
				}
				else{
					my $P=$X-1;
					print A "@line_array[0..$P]\n";
				}
		}
	}
close(A);
close(B);
}


