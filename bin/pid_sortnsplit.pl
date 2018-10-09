#!/usr/bin/perl
use warnings;
use strict;
use Math::Round;
use List::Util qw(shuffle);

####this thing selects sequences from the pid files for each pid based on the number of pairs you stipulate

#./pid_sortnsplit.pl /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/subset_genus_nucleotide_combined_nocuttoff_allPIDcombined.counts /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/hmmalign_output/subset_genus_aaseq_combined_nocuttoff_allPIDcombined.counts
print "How many pairs do you want?\t";
my $num_of_pairs_per_PID=<STDIN>; chomp($num_of_pairs_per_PID);
my $cutoff=round($num_of_pairs_per_PID*0.2); #print "$print\n";
open(my $ncRNA, "<", $ARGV[0]) or die "Can't open $ARGV[0]; $!"; #subset_genus_nucleotide_combined_nocuttoff_allPIDcombined.counts
open(my $mRNA, "<", $ARGV[1]) or die "Can't open $ARGV[1]; $!"; #subset_genus_aaseq_combined_nocuttoff_allPIDcombined.counts


my %PID;

while (my $ncline = <$ncRNA>){
	##store each unique header model:species1:species2 as the value and the rounded PID as the key so we can create a hash of PID's
	my @split=split('\s+',$ncline);
	my $value="$split[0]:$split[1]:$split[2]"; chomp($value);
	my $key=round($split[3]); chomp($key);
	push( @{ $PID { $key } }, $value); 
}

#print "\n";


while (my $mline = <$mRNA>){

	##store each unique header model:species1:species2 as the value and the rounded PID as the key so we can create a hash of PID's - same hash as ncRNA
	#skip if PID =0 (have a look at these later...)
	my @split1=split('\s+',$mline);
	my $value1="$split1[0]:$split1[1]:$split1[2]"; chomp($value1);
	my $key1=round($split1[3]); chomp($key1);
	if ($key1>0){
		push( @{ $PID { $key1 } }, $value1); 
	}
}

my %PID_selected=();
foreach my $kline (sort {$a<=>$b} keys %PID){
	my $loopbreaker=0;
	my $pid_num="$kline%";
	open(WRITE,">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/$kline\_pid_seqs.fasta") or die "Can't make $kline% file; $!";
	open(WRITE1,">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/$kline\_pid_seqs.pairs") or die "Can't make $kline% pairs file; $!";
	my @array=@{$PID{$kline}};
	@array= shuffle @array;
	my $size = scalar(@array);
	print "$kline\n";
	my @randnumarray=();
	my %model_abundance_check=();
	my $model_type_check=();
	##need to also include some way to at least force one ncRNA pair into each PID as long as there is one to find 
	for (my $count=0;$count<$num_of_pairs_per_PID; $count++){
		my $random_number = int(rand($size));
		#print $random_number, "\t";
		my @namesplit=split(":",$array[$random_number]);
		
		my $modelname=$namesplit[0]; chomp($modelname);
		#print "$modelname\n";
		if (exists $model_abundance_check{$modelname}){ #only for models that currently have been included for that pid
			if ($model_abundance_check{$modelname}<$cutoff){ # less then 20%
				$model_abundance_check{$modelname}++;
				my @info4seq=split(":",$array[$random_number]);
				#print "$array[$random_number]\n";
				#push( @{ $PID_selected { $pid_num } }, $array[$random_number]); 
				#print "$info4seq[0]\n"; 
				chomp($info4seq[0]);
				if ($info4seq[0]=~m/RF.*/){ #prints sequences that are less then 20% are are ncRNA
					
					my $filename="subset_genus_nucleotide_combined.$info4seq[0]";
					my @grepresult1=`sed -n "/>$info4seq[1].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult1); print WRITE for @grepresult1;
					print WRITE1 "$array[$random_number]\n";
					my@grepresult11=`sed -n "/>$info4seq[2].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult11);print WRITE for @grepresult11;
				}

			
				else{ #prints sequences that are less then 20% and are mRNA
					my $filename="subset_genus_aaseq_combined_nocuttoff.bactNOG.$info4seq[0].meta_raw.nuc"; #subset_genus_aaseq_combined_nocuttoff.bactNOG.ENOG4105C6P.meta_raw.nuc
					my @grepresult3=`sed -n "/>$info4seq[1].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult3); print WRITE for @grepresult3;
					print WRITE1 "$array[$random_number]\n";
					my@grepresult33=`sed -n "/>$info4seq[2].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult33);print WRITE for @grepresult33;					

										
				}
			}
		
			else{ #more then 20% so doesn't print them
				$model_abundance_check{$modelname}++;
				
				
				if ($loopbreaker<$size*2){
					#print "Exists but more then 20%$array[$random_number]\t$random_number\n";	
					$count=$count-1;
					
				}
				else {
					last;
				}


				$loopbreaker++;	
					
			}
		}
		
		else{ #for models that haven't yet been included
			$model_abundance_check{$modelname}++;
			my @info4seq1=split(":",$array[$random_number]);chomp($info4seq1[0]);
			if ($info4seq1[0]=~m/RF.*/){ #first time sequence for a model that is ncRNA
					
				my $filename="subset_genus_nucleotide_combined.$info4seq1[0]";
				my @grepresult2=`sed -n "/>$info4seq1[1].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult2); print WRITE for @grepresult2;
				print WRITE1 "$array[$random_number]\n";
				my@grepresult21=`sed -n "/>$info4seq1[2].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult21);print WRITE for @grepresult21;
			

			}
		
			else{ #first time sequence for a model that is mRNA
				my $filename="subset_genus_aaseq_combined_nocuttoff.bactNOG.$info4seq1[0].meta_raw.nuc"; #subset_genus_aaseq_combined_nocuttoff.bactNOG.ENOG4105C6P.meta_raw.nuc
				my @grepresult4=`sed -n "/>$info4seq1[1].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult4); print WRITE for @grepresult4;
				print WRITE1 "$array[$random_number]\n";
				my@grepresult44=`sed -n "/>$info4seq1[2].*/,/>.*/p" /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename`; pop(@grepresult44);print WRITE for @grepresult44;					

										
			}
		
			#print "$array[$random_number]\n";
			#push( @{ $PID_selected { $pid_num } }, $array[$random_number]); 
		} 
		#print "\n";
	}
	


	#print "$array[$random_number]\t";

	#print "\n";
close(WRITE1);
close(WRITE);
}
#print "\n";


###randomly pick 10 values for each PID


# generate a random number in perl in the range 20-49


