#!/usr/bin/perl
use warnings;
use strict;
use Math::Round;

my $bitscores="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/bs_output";
my $model_files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files";


my @files=`find $bitscores -maxdepth 1 -regex \42.*.bs\42`; #find all the files that have model bitscore outputs
#@files="/home/stephmcgimpsey/Documents/test_modelfile_bsoutput.txt";
#print "@files\n";
#foreach file open it, iterate through each line  and split out by query sequence and then aligner. Determine cut off of bitscore when there is 0.1% fakies above the cut off aka 1 in 1000 (look for the F), fire them off to their correct PID groupings now as well via the .*.pidinfo files in $modelfiles directory











foreach my $file_line (@files){
	print "FILE: $file_line\n";
	my $count=0;
	my $checker; #basically justto initialise the routine for the first line of the file. 
	my $alignercheck;
	my $query;
	chomp($file_line);
	open(BSFILE, "<", $file_line) or die "Can't open $file_line; $!";
	my $true=0; my $false=0; my $total=0; my $prop_of_falsies=0; my $exiter=0;

	while (defined(my $bs_line = <BSFILE>)){
	chomp($bs_line);
		my @bs_split=split("\:",$bs_line);		
		$query=$bs_split[0]; #query name
		my $match=$bs_split[1]; #match in the database - could be true or false
		my $bsscore=$bs_split[2]; #bitscore of the match
		my $aligner=$bs_split[3]; #tells you what alignment software was used; s=ssearch, g=ggsearch, n=nhmmer, b=blastn
		chomp($bs_split[4]);
		my $truefalse=$bs_split[4]; #tells you if the match is a real sequence from the family (T) or a shuffled sequence (F)



		if ($count==0){ #true if the file is just opened 		
			$checker=$query; #basically justto initialise the routine for the first line of the file. 
			$alignercheck=$aligner; chomp($alignercheck);
			
			if($truefalse=~m/T/){
				$true++; 
				$total=$true+$false;
				$prop_of_falsies=$false/$total; nearest(.1,$prop_of_falsies);
				print "First file line true\t$true\t$false\t$prop_of_falsies\n";
			}
			else{
				if ($truefalse=~m/F/){
					$false++;
					$total=$true+$false;
					$prop_of_falsies=$false/$total; nearest(.1,$prop_of_falsies);
					print "First file line false\t$true\t$false\t$prop_of_falsies\n"; 
				}
				else{ #this is here in case something went awry with the write out in aligner_twilightzone_bitscore_maker.pl
					print "First line is neither true or false: $query $match $bsscore $aligner\n";
				}
			}
			##should we be ignoring the first match as it will be the same sequence?? should we be checking that the top hit is the same sequence in case shiz be cray cray.
		}


		if ($count>0){ #true if the file 
		#initialise some stuff
			if($query=~m/$checker/){#same query sequence still so keep counting
				
				if ($truefalse=~m/T/){ #have to add in a loop to check if the aligner is the same as have to empty the variables in that case
					
					if($alignercheck=~m/$aligner/){
						$true++;
						$total=$true+$false;
						$prop_of_falsies=$false/$total; nearest(.1,$prop_of_falsies);
						##print "Line is true and same aligner as above\t$true\t$false\t$prop_of_falsies\n";
						if($prop_of_falsies==0.1 && $exiter==0){
							print "Proportion met - $aligner: $query ---> True: $true\tFalse: $false\tTotal: $total\tProportion: $prop_of_falsies\n";
							$exiter++; #this stops it printing the above line over and over again once the proportion of falsies is at least 0.1 or greater

						}


					}
					else{ #this is likely to be the way it resets out
						
						print "Last line for $alignercheck -> $aligner: $query ---> True: $true\tFalse: $false\tTotal: $total\tProportion: $prop_of_falsies\n";
						$true=0;$false=0;$total=0;$prop_of_falsies=0;$exiter=0;
						$alignercheck=$aligner; chomp($alignercheck);
						$true++; 
						$total=$true+$false;
						$prop_of_falsies=$false/$total; nearest(.1,$prop_of_falsies);
						##print "Line is true and for a new aligner\t$true\t$false\t$prop_of_falsies\n";
	

					}
					
				}
				else{
					if ($truefalse=~m/F/){
						if($alignercheck=~m/$aligner/){
							$false++;
							$total=$true+$false;
							$prop_of_falsies=$false/$total; nearest(.1,$prop_of_falsies);
							##print "Line is false and the same aligner as above\t$true\t$false\t$prop_of_falsies\n";
							if($prop_of_falsies==0.1 && $exiter==0){
								print "Proportion met - $aligner: $query ---> True: $true\tFalse: $false\tTotal: $total\tProportion: $prop_of_falsies\n";
								$exiter++; #this stops it printing the above line over and over again once the proportion of falsies is at least 0.1 or greater

							}
						}
						else{ #this is likely to be the way it resets out
						
						print "Last line for $alignercheck -> $aligner : $query ---> True: $true\tFalse: $false\tTotal: $total\tProportion: $prop_of_falsies\n";
						$true=0;$false=0;$total=0;$prop_of_falsies=0;$exiter=0;
						$alignercheck=$aligner; chomp($alignercheck);
						$false++;
						$total=$true+$false;
						$prop_of_falsies=$false/$total; nearest(.1,$prop_of_falsies);
						##print "Line is false and for a new aligner\t$true\t$false\t$prop_of_falsies\n";

					}

					}
					else{
						print "Neither true or false: $query $match $bsscore $aligner\n";
					}
				}
				
				
			}

			else{
				#initialise some stuff
				print "Last line met for whole query: $checker : $true\tFalse: $false\tTotal: $total\tProportion: $prop_of_falsies\n";
				$checker=$query; # so the next file line will go through the if loop above
				$alignercheck=$aligner; chomp($alignercheck);
				#print out the hash above...
				#%bs_score=(); #empty hash ready for the next query
				$true=0;$false=0;$total=0;$prop_of_falsies=0;$exiter=0; #empty variables ready to roll
				#push(@{$bs_store{$aligner}},$bsscore); #adds the bitscore as a value to the alignment tool which is the key
				##should we be ignoring the first match as it will be the same sequence?? should we be checking that the top hit is the same sequence in case shiz be cray cray.
			}
		
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		$count++;
		#print "$bs_line\n";
	}


print "Last line met for whole file: $query ---> True: $true\tFalse: $false\tTotal: $total\tProportion: $prop_of_falsies\n";



}
