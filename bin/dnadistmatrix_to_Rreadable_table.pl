#!/usr/bin/perl
use strict;
use warnings;

###takes phylip dnadist outfile output and turns it into a csv with row labels (no column labels)




open(my $file, "<", $ARGV[0]) or die "Can't open $ARGV[0]; $!"; my @file =<$file>; close($file) or die "Can't close $file; $!";
my $numofseqs;
my $count=0;
my $filename=$ARGV[0];
$filename=~s/\.[a-zA-Z]+//;
$filename="$filename.rtable";
print "CSV written to:\t$filename\n";
open(WRITE, ">", $filename) or die "Can't make $filename; $!";


		$numofseqs=shift @file;
		print "Number of sequences in file:\t$numofseqs\n";


foreach my $line (@file){	
	
	if($line=~m/SEQ[0-9]+/){
		chomp($line);
		$line=~s/\s+/,/g;
		
		if ($count==0){
			
			print WRITE "$line";
			#print "$line";
			
		}
		else{
			
			print WRITE "\n$line";
		}

		$count++;
	}
	else {
		chomp($line);
		$line=~s/\s+/,/g;
		print WRITE "$line";
		#print "$line";
	}

}
print "$count\n";

close(WRITE);
