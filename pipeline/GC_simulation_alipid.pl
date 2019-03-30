#!/usr/bin/perl
use warnings;
use strict;
use Math::Round;



my $file=$ARGV[0];
chomp($ARGV[0]);
$ARGV[0]=~s/\.\///;
print "$ARGV[0]\n";
open(DATAOUT,">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].pid") or die "Can't make the file' $!";

open(FILE,"<","/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0]") or die "Can't open $ARGV[0];$!"; my @file_content=<FILE>; close(FILE) or die "Can't close $file; $!";

 #print "@alignments";
my $i=0;
my @array;

foreach my $line (@file_content) { 
	if ($line=~m/^>/){
		if($i>0){
			$i=$i+1;
		}
		$array[$i]=$line;		
		$i=$i+1;

	}
	else{
	chomp($line);
		if(defined $array[$i]){
			$array[$i]="$array[$i]$line";			
		}
		else{
			$array[$i]=$line;
		}
	} 

}


$i=$i+1;
#}
 #print "@array";


my $j=0;

while ($j<=(scalar(@array)-3)){
	
		unlink("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].temp");
		open(REFORMAT,">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].temp") or die "$!";
		#print REFORMAT "$array[$j]$array[$j+1]\n$array[$j+2]$array[$j+3]";
print REFORMAT $array[$j]; 
foreach my $seqLine (unpack('(a[60])*', $array[$j+1])) { print REFORMAT $seqLine, "\n"; }
print REFORMAT $array[$j+2]; 
foreach my $seqLine1 (unpack('(a[60])*', $array[$j+3])) { print REFORMAT $seqLine1, "\n"; }
		close(REFORMAT);

	system("esl-reformat --informat a2m clustal /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].temp >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].reformattemp");
	my @output=`esl-alipid --dna /media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].reformattemp`;
	my @split_output=split(/\s+/,$output[1]);
	my $PID=round($split_output[2]);
	print DATAOUT "$split_output[0]\t$split_output[1]\t$PID\n";
	$j=$j+4;
		
}




close(DATAOUT);


unlink("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].reformattemp");
unlink("/media/stephmcgimpsey/GardnerLab-backup1/Refseq/GC_simulation/$ARGV[0].temp");

