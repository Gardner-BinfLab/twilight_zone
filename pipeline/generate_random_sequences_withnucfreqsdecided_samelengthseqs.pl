#!/usr/bin/perl
use warnings;
use strict;
use Math::Round;
use List::Util 'shuffle';


my @numbers=(0,1,2,3,4);
my @test=shuffle(@numbers);

#got this data using R - maybe write yourself a script as its the lengths of all the genes you could sample from binned into 50nuc's
my @binsizes=(50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300,1350,1400,1450,1500,1550,1600,1650,1700,1750,1800,1850,1900,1950,2000,2050,2100,2150,2200,2250,2300,2350,2400,2450,2500,2550,2600,2650,2700,2750,2800,2850,2900,2950,3000,3050,3100,3150,3200,3250,3300,3350,3400,3450,3500,3550,3600,3650,3700,3750,3800,3850,3900,3950,4000,4050,4100,4150,4200,4250,4300,4350,4400,4450,4500,4550,4600,4650,4700,4750,4800,4850,4900,4950);
 my $binsizes=(336,2,0,5,13,11,33,32,20,22,21,16,16,12,9,11,13,12,12,12,9,12,14,14,16,23,22,18,25,29,11,11,8,10,15,12,10,15,9,9,7,15,6,4,5,5,5,6,6,7,6,4,4,9,4,4,5,4,4,2,3,2,2,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1);
 my $numberofsequencesperbin=3207;

#print "What length sequences do you want? -\t";
#my $sequencelength=<STDIN>; print "\n"; chomp($sequencelength);
#print "What GC content do you want (please type as a percentage without the percentage sign)-\t";
#my $gccontent=<STDIN>; print "\n"; chomp($gccontent);
my @gccontentranges=(74,50,28);


foreach my $line (@gccontentranges){ # for each GC content; 3 of them
#my $count=0; # count initialised
	my $gccontent=$line; chomp($gccontent);
	while ($count<=$numberofsequencesperbin){ #While the count is less then the number of bin sizes
		my $number=0;

		while ($number<=$numberofsequencesperbin){
			#print "$numberofsequencesperbin[$count]:$endsize\t";
			
			
			my $sequencelength=$binsizes;

			my $number_GC=round(($gccontent/100)*$sequencelength);
			my $number_AT=round($sequencelength-$number_GC);
			my $number_G=round(0.2*$number_GC)+round(rand($number_GC-0.2*$number_GC));
			my $number_C=$number_GC-$number_G;
			my $number_A=round(0.2*$number_AT)+round(rand($number_AT-0.2*$number_AT));
			my $number_T=$number_AT-$number_A;
			#print "GC: $number_GC\tG: $number_G\tC: $number_C\nAT: $number_AT\tA: $number_A\tT: $number_T\n";

			my $count_G=0;my $count_C=0;my $count_T=0;my $count_A=0;
			my @sequence=();

			while($count_G<$number_G){
				
				push(@sequence,"G");
				$count_G++;
			}

			while($count_C<$number_C){
				
				push(@sequence,"C");
				$count_C++;
			}


			while($count_A<$number_A){
				
				push(@sequence,"A");
				$count_A++;
			}

			while($count_T<$number_T){
				
				push(@sequence,"T");
				$count_T++;
			}





			

			my @shuffseq=shuffle(@sequence);
			my $sequence=join('',@shuffseq);
			print ">$gccontent-$sequencelength.$number\n$sequence\n";#FILE
			$number++;
		}
	 $count++;
	}

}





#open(FILE,">","temp_seq_file_youcandelete.txt") or die "Can't open temp_seq_file_youcandelete.txt; $!"; 


#close(FILE);

#my $filename="$gccontent\_random_shuffled.sequences";
#system("esl-reformat fasta temp_seq_file_youcandelete.txt >temp_seq_file_youcandelete2.txt");
#system("esl-shuffle -N 1000 temp_seq_file_youcandelete2.txt >$filename");
#round
