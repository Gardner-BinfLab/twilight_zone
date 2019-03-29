#!/usr/bin/perl
use warnings;
use strict;
#use Math::Round;
use File::Basename;




#my $bitscores="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/all_aligners_split"; #201 pairs
#my $bitscores="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split"; # 50 pairs
my $bitscores="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/new_nhmmit_March4th";
#my $model_files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files";#201 pairs
my $model_files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/model_files";# 50 pairs

#my $twilight="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/twi_FPR_checks/1_in_2000";#for FPR checking
#my $twilight="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/bs_output/twilight/FPR_0"; #FPR checking
my $twilight=$bitscores;
#my $twilight="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/bs_output/twilight"; #201 pairs
#my $twilight="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/twilight";# 50 pairs



#my @files="/home/stephmcgimpsey/Documents/test_modelfile_bsoutput.txt";
#my @files="/home/stephmcgimpsey/Documents/file_testerfor_bitscoreuniquer.txt";
#print "@files\n";
#foreach file open it, iterate through each line  and split out by query sequence and then aligner. Determine cut off of bitscore when there is 0.1% fakies above the cut off aka 1 in 1000 (look for the F), fire them off to their correct PID groupings now as well via the .*.pidinfo files in $modelfiles directory


my $cutoff=2;

my $counter=0;

my @files=`find $bitscores -maxdepth 1 -regex \42.*\.bs*\42`; #for the normal run
#my @files=`find $bitscores -maxdepth 1 -type f \\\( -name "*.b.bs" -o -name "*.s.bs" \\\)`;#for the FPR run as only using ssearch and blastn
#my @files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/bs_output/all_split/ENOG4105CEY.g.bs";

my @twilightfiles=`find $twilight -maxdepth 1 -regex \42.*.twi\42`;

if (scalar(@twilightfiles)>1){ #unlinks the twi files if they exist as that would have been from a previous run and we append later on in the loop rather then overwrite
	foreach my $twifile_line (@twilightfiles){
		chomp($twifile_line);
		unlink($twifile_line);
		print "unlinked: $twifile_line\n";
		
	}
}







foreach my $file (@files){ #foreach alignment search output file from 
    chomp($file);
    my $familyname;
    if($file=~/.*.bs$/){ # stores family name in variable for opening the other files required to get counts etc
	$familyname=basename($file,".bs");
	$familyname=~s/\..*//;
    }
	#print "$familyname\n";
	#PID INFO & GC & LENGTH
	my $pairsinfo="$familyname.pidinfo.gl.dupsout"; #give GC, length, PID info for all pairs that only had one hit to a model
	my $fasta_file="$familyname-mixedpid.fasta.uniq"; #the actual sequences
	my $numberoftruehomologsingenefamily=`grep "^>" $model_files/$fasta_file | wc -l`; $numberoftruehomologsingenefamily=$numberoftruehomologsingenefamily-1; #tells us the number of true homologs for the gene family
	#print "True Homologs: $numberoftruehomologsingenefamily\n";
	my %pidSeqsHash;
	my %GCpairs;
	my %Lpairs;
    open(PIN, "<$model_files/$pairsinfo") or die "FATAL: where the fuck is [$pairsinfo]?\n[$!]"; #opens the pid pairs info file
	    while(my $pin = <PIN>){

		if($pin =~ m/.*_pid_seqs.fasta.uniq/){ #iterates through the PID pairs
			chomp($pin);
	
			my @pin_split=split(/:/,$pin); chomp($pin_split[0]); chomp($pin_split[1]); chomp($pin_split[2]); # chomps it all up

		    	$pidSeqsHash{$pin_split[0]}{$pin_split[1]}=$pin_split[2]; #stores the two sequences as a hash of hash with value being the PID file
		    	$GCpairs{$pin_split[0]}{$pin_split[1]}=$pin_split[3]; #stores the GC info as value of a hash of hash's which are the two sequences
		    	$Lpairs{$pin_split[0]}{$pin_split[1]}=$pin_split[4]; #stores the length info as value of a hash of hash's which are the two sequences
		}
	    }
    close(PIN);




    	#Find query sequences that meet inclusion criteria
	print "FILENAME: $file"; # this is just so we know what file we are up to
	my @sequences_F=`grep \42:F\42 $file | tr ":" "\t" | cut -f 1 | sort -d | uniq -c`; # counts how many queries have a false
	my $length_F=scalar(@sequences_F);
	my @sequence_T=`grep \42:T\42 $file | tr ":" "\t" | cut -f 1 | sort -d | uniq`;  #counts how many queries have a true
	my $length_T=scalar(@sequence_T);
	#print "This many sequences with trues found in file $length_T and this many also have at least one false $length_F\n";
	#fill this:
	my %includeSeqs; my %notincludeSeqs;
	

	#now need to iterate through each file and split it by query then count trues till 28 falses found (skip if query==match)	
	#use sequence_T - iterate through one by one 	

	foreach my $true_line (@sequence_T){ #foreach query
		chomp($true_line);
		#print "$true_line\n";
		my @sequence_array=`grep "^$true_line" $file`; # grab all the lines where the query is the first sequence
		my $false=0; my $n=0;	my @array_4_check=(); my %dup_check=();  my %dup_checkF=(); #counting variables are reset
		my @aligner=split(/:/,$sequence_array[0]); my $aligner=$aligner[3]; #splits the line up so we can grab the aligner 

		foreach my $match_line (@sequence_array){ # for each line for the query
			my @splitarray=split(/:/,$match_line); #split it up
			my $key_new="$splitarray[0]:$splitarray[1]"; #make the key a combo of the names
			if($match_line=~m/.*:T/){ # if the match is equal to a true then jump in here
				if (!defined($dup_check{$key_new})){	#skips duplicate matches so only take the top score for a query-match combo		
					$includeSeqs{$key_new}++; #puts it in a hash we use later for figuring out if things are above the threshold or not
					#push @array_4_check, $key_new; #only need this for problem shooting
					$dup_check{$key_new}++; #puts it in a hash for us to use for duplicate checking 
				}
			}
			if($match_line=~m/.*:F/){ #if the match is a shuffled sequence it jumps in here
				if (!defined($dup_checkF{$key_new})){	#skips duplicate matches as we only want the top score to be included in the counting for a query-match combo
					#print "$match_line\t";
					$n++; #n is basically a false counting variable so we stop looking for matches when it reaches the cut off of 1 in 10,000 FPR
					$dup_checkF{$key_new}++; #puts it in a hash for us to use for duplicate checking 
				}
			}
			last if $n==$cutoff; # if we reach the cut off this causes the loop stop and moves on to the next bit

		}
			#print "\n";



		#print to file
		my $first_key=$true_line; # this is just to set the query to be the first key
		foreach my $second_key (keys %{$pidSeqsHash{$first_key}}){ #for each match
			chomp($second_key);
			my $check="$true_line:$second_key"; #create the key checker
			if (exists $includeSeqs{$check}){ #if it is in the includeSeqs part then its above the threshold and is a true homolog 
				my @PIDT_split=split(/_/,$pidSeqsHash{$first_key}{$second_key}); #grabs the PID info
				my $file_true="$PIDT_split[0].twi"; #tells us what file to write to
				open(WRITE, ">>", "$twilight/$file_true") or die "Can't make T $twilight/$file_true; $!"; # opens the file
				print WRITE "$first_key\t$second_key\t1\t$aligner\t$GCpairs{$first_key}{$second_key}\t$Lpairs{$first_key}{$second_key}\t$PIDT_split[0]\n"; #writes to the file
				close(WRITE); # closes the file
			}
			else{ # if it isn't in the includesSeqs part then its below the threshold
				my @PIDF_split=split(/_/,$pidSeqsHash{$first_key}{$second_key}); #grabs PID info
				my $file_false="$PIDF_split[0].twi"; #tells us what file to write to
				open(WRITE1, ">>", "$twilight/$file_false") or die "Can't make F $twilight/$file_false; $!"; # opens said file
				print WRITE1 "$first_key\t$second_key\t0\t$aligner\t$GCpairs{$first_key}{$second_key}\t$Lpairs{$first_key}{$second_key}\t$PIDF_split[0]\n"; #writes to file
				close(WRITE1); #closes file
			}
		}



	  
	}

	
#$counter++;
	print"\n";  
		#last if $counter==15;  

}







