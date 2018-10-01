#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw/ uniq /;

##IF all > in file the same (label contigs indistinguishable -> reject)
##IF all accessions the same and words after don't match (label contigs distinguishable)
##If all accessions aren't the same and the words do/don't match (label contigs multi-accession -> keep but remember the taxonomic info will be stored under the first accession found in the genome file so will have to do some back tracking if need it so put other accession in () 




my $dir = '/media/stephmcgimpsey/GardnerLab-backup1/Refseq/refseq-bacterial';
my $unique_lines=0;
my $nonuniq_lines=0;
my $accsame_lines=0;

foreach my $file ( glob ( "$dir/*.fna" ) ) { #opens each file in the directory one at a time if it is the genome file

	open(my $input, "<", $file) or die "Can't open $file; $!"; my @input=<$input>; close($input);#opens file
		my @storage=();
		my @unique_check=();
		my @stor2=();
		my @acc_stor=();
		my @u_check= ();
		my @acc_stor1=();

	foreach my $line (@input){ #checking each line of the input
		

		if ($line=~m/>.*/){ 
			push @storage, $line; #storing all the header lines in the file in an array
		}
		
		
	}#foreach



		#print ">>\t";
		@stor2=@storage;
		@unique_check= uniq @stor2;

		my $stor_size=scalar(@storage); my $uniq_size=scalar(@unique_check);

		if ($stor_size=$uniq_size){
			#print "All lines unique\t$file\n";
			my $u_size; my $ac_size; my $line1;
			
			foreach $line1 (@storage){ #goes through all the header lines we just stored. 
				#print "$line1";
				$line1=~s/>//;
				$line1=~s/\s+.*//;
				chomp($line1);
				
				push @acc_stor, $line1;
				@acc_stor1=@acc_stor;
				@u_check= uniq @acc_stor1;
				$u_size=scalar(@u_check); $ac_size=scalar(@acc_stor);
			}
				if($u_size = $ac_size){
					$unique_lines++;
					#print "Headers Unique, Accessions Unique\t$file\n";
					#print "Diff accs; $line1\n";
				}
				else{
					print "Headers Unique, Accessions Identicle\t$file\n";
					#print "Same accs; $line1\n ";
					$accsame_lines++;
				}

		
			
		}
		else{ print "Some or all headers identicle\n";
			foreach my $line2 (@storage){ #goes through all the header lines we just stored. 
				print "$file";		
			}
			$nonuniq_lines++;
		}




#print "\n";
}#foreach

print "$unique_lines unique header genome files\t $nonuniq_lines non-unique header genome files\t $accsame_lines same accessions for unique header lines\n";
