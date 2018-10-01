#!/usr/bin/perl
use strict;
use warnings;
use 5.010;


#Files to run
####/home/stephmcgimpsey/Documents/subset_genus_nucleotide_combined_nocuttoff.tophitpergenomepercm
####/home/stephmcgimpsey/Documents/subset_genus_aaseq_combined_nocuttoff.tophitpergenomeperhmm


###FILE YOU ARE READING IN WILL BE HIGHEST BScore match to the hmm
##Filter by eggnog/rfam so sequences from one cm/hmm end up in the same file


open(my $file, "<", $ARGV[0]) or die "Can't open $ARGV[0]; $!";my @file=<$file>;close($file) or die "Can't close $ARGV[0]; $!";

my %modelnamestore;




for my $line (@file){
	chomp($line);
	my @line=split(/\t/,$line);
	#print "$line[0]\n";

#############RFAMMMMMMMMMM
	if($line[0]=~m/.*\.RF.*/){
	my @model=split(/\./,$line[0]); my $last =scalar(@model); my $model=$model[$last-1];
	my $genomefile="@model[0..($last-2)]"; $genomefile=~s/\s+/\./g;
	#print "RRRR $line[0]\n$line\n";
	#print "$model\n$genomefile\n";
	
	
	push( @{ $modelnamestore { $model } }, $line); 
	}

########################EGGNOG

	if($line[0]=~m/.*\.bactNOG.*/){
	#print "EEEE $line[0]\n$line\n";
	my @model=split(/\./,$line[0]); my $last =scalar(@model); my $model="@model[($last-3)..($last-1)]";$model=~s/\s+/\./g;
	my $genomefile="@model[0..($last-4)]"; $genomefile=~s/\s+/\./g;
	#print "RRRR $line[0]\n$line\n";
	#print "$model\n$genomefile\n";
	
	
	push( @{ $modelnamestore { $model } }, $line); 
	}


}
my $cnt=0;

foreach my $key (keys %modelnamestore ){
###print "$key\t@{$modelnamestore{$key}}\n";
my $filename=$ARGV[0];
$filename=~s/\..*//;
#$filename=~s/test_sets//;
#print "$key\n";
$filename="$filename\.$key";
my $fullPathFileName = "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/$filename"; 

#print "$fullPathFileName\n";

#print "$filename\n\n";
unlink("$fullPathFileName"); #we are writing out to this file :)
unlink("$fullPathFileName\.nuc"); 
###########DO THE SEQUENCE GRABBING THINGS HERE
my @valuesstore=@{$modelnamestore{$key}};
my $coord1;my $coord2; my $orfname; my $escore; my $bscore;
my @val; my @namestep1;my $length1;my $genomename;my $contigg;
my $protorrna;


############Use what worked in the other one to do this :))))))))

	foreach my $value (@valuesstore){

			if ($key=~m/RF.*/){
				@val=split(/\s+/,$value); chomp($val[0]);
				@namestep1=split(/\./,$val[0]);
				$length1=scalar(@namestep1);
				$genomename="@namestep1[0..($length1-2)]"; $genomename=~s/\s+/\./g;
				$contigg=$val[1];
				$coord1=$val[2];
				$coord2=$val[3];
				$protorrna=1;
				#$orfname="";
				#print "$genomename\t$contigg\t$coord1\t$coord2\t$val[4]\n";

			}

			if ($key=~m/bactNOG.*/){
				@val=split(/\t/,$value); chomp($val[0]); #print "@val[1..scalar(@val)]";
				@namestep1=split(/\./,$val[0]);
				$length1=scalar(@namestep1);
				$genomename="@namestep1[0..($length1-4)]"; $genomename=~s/\s+/\./g; #all good
				#my $contigg="@val[($length1-3)..($length1-1)]";$contigg=~s/\s+/\./g;
				$contigg=$val[1];
				$coord1=$val[5]; $coord1=~s/coords=//;$coord1=~s/\.\.[0-9]+//;#need these to do grab the nucleotide sequences for revtrans'n post aaseq alignment
				$coord2=$val[5];$coord2=~s/coords=[0-9]+\.\.//;
				$orfname=$val[2]; #need this to grab the right aaseq out of the concat file
				$escore=$val[3]; $bscore=$val[4];
				$protorrna=2;
				
				#print "$genomename\t$contigg\t$orfname\t$coord1\t$coord2\n";
							
			}
				

			
			my $genomefilename= "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/refseq-bacterial/$genomename"; 
			#print "$genomefilename\n";
			
			
			if(-s "$genomefilename\.ssi"){
					#print "Index available\t$genomefilename\.ssi\n";
			}
			else{
				system("esl-sfetch --index $genomefilename");
				#print "Index notavailable\n$genomefilename\.ssi\n";
			}
			if ($protorrna==1){
				system("esl-sfetch -c $coord1-$coord2 -n \42$contigg\_$coord1-$coord2 $genomename\42 $genomefilename $contigg >> $fullPathFileName");

			}

			if($protorrna==2){
			my %proteinstore;
			my $protkey;
				##protein			
				system("esl-sfetch -c $coord1-$coord2 -n \42$orfname $contigg $genomename $coord1-$coord2\42 $genomefilename $contigg >> $fullPathFileName\.nuc");
				system("esl-sfetch -n \42$orfname $contigg $genomename $coord1-$coord2\42 /media/stephmcgimpsey/GardnerLab-backup1/Refseq/genome_subset_genus_specific.aa $orfname >> $fullPathFileName");
				

#open(my $aafile, "<", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/genome_subset_genus_specific.aa") or die "Can't open /media/stephmcgimpsey/GardnerLab-backup1/Refseq/genome_subset_genus_specific.aa ; $!"; my @aafile=<$aafile>; close($aafile);


			#	foreach my $aaline (@aafile){
				#		if($aaline=~/\>orf/){	
				#			print ">>>>>>>>>>>$aaline";
				#			chomp($aaline);
				#			$protkey=$aaline;
							
				#		}
					#	else{ 
					#		chomp($aaline);
					#		push( @{ $proteinstore { $protkey } }, $aaline); 					
#
#						}
#						
#				}
#				foreach my $key1 (keys %proteinstore){
#					print "$key1\n@{ $proteinstore { $protkey } }";
#
#
#				}


			}				
				
	}







	#$cnt++;
	#last if ($cnt==5);












###############


}

##unlink("");
	
