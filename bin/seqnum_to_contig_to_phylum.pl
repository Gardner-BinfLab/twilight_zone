#!/usr/bin/perl
use strict;
use warnings;

###takes phylip dnadist seq names and uses another file to find the corressponding contig and then uses that contig to find the corresponding filename then use the original genome slurp thing to find the corresponding accession number and then uses the phylum file to assign the correct phylum

##use like ./seqnum_to_contig_to_phylum.pl seqnum_contig_phylum_oneswecouldfindmatchesfor_genus.txt <16srRNA_distmatrix_weighted_genus.rtable> or 
# ./seqnum_to_contig_to_phylum.pl seqnum_contig_phylum_oneswecouldfindmatchesfor_species.txt <16srRNA_distmatrix_weighted_species.rtable>

print "DNAdist .rtable file:\n";
my $matrix =<STDIN>; #
#print "Filename to put output:\n";
my $namerr=$ARGV[0];

chomp($matrix);
open(my $file, "<", $matrix) or die "Can't open $matrix; $!"; my @file =<$file>; close($file) or die "Can't close $file; $!";

open(WRITE,">", "$ARGV[0]") or die "Can't open $ARGV[0]; $!";

foreach my $line (@file){
	my @line=split(',',$line); my $seqname=$line[0]; chomp($line[0]);
		
	my @grep= `grep -w $line[0] /home/stephmcgimpsey/Documents/16s-rRNA_uniquespecies_phylipheaders.names`; #finds the right seq name to matching contig
	my @grepsplit=split('\s',$grep[0]);
	chomp($grepsplit[1]);
	#print "Contig: $grepsplit[1]\t";
	

	my @grep1= `grep -w "$grepsplit[1]" filename_phylum.txt`;
	




	if (scalar(@grep1)>=1){
		chomp($grep1[0]);
		#print "File/Phylum: $grep1[0]\n";
		print WRITE "$line[0]\t$grep1[0]\n";
		#print WRITE "@grepsplit[0..1,3]\t$grep1[0]\n";

			
		#print "$seqname\t$grepsplit[1]\t$grepsplit1[1]\n";	
	}
	else {
		print WRITE "$grepsplit[0]\t$grepsplit[1]\tNA\t$grepsplit[3]\n";
	}
	
	
	
}

close(WRITE);






###############BOTTOM BIT IF YOU ARE USING TIDY CM SEARCH OUTPUT TO FIND TOTAL HITS PHYLUM DISTRIBUTION



#foreach my $line (@file){
	#my @line=split('\s+',$line); 
	
	
	#my @grep= `grep -w $line[0] /home/stephmcgimpsey/Documents/16s-rRNA_bitscorecutoffadded_phylipseqnames_tocontigs.txt`; #finds the right seq name to matching contig
	#my @grepsplit=split('\s',$grep[0]);
	#chomp($grepsplit[1]);
	#print "Contig: $grepsplit[1]\t";
	
	#chomp($line[3]);
	#my @grep1= `grep -w "$line[3]" filename_phylum.txt`;
	




#if (scalar(@grep1)>=1){
#$line[0]=~s/>//;
#chomp($grep1[0]);
#print "File/Phylum: $grep1[0]\n";
#print WRITE "$line[0]\t$grep1[0]\n";
##print WRITE "@grepsplit[0..1,3]\t$grep1[0]\n";

	
#print "$seqname\t$grepsplit[1]\t$grepsplit1[1]\n";	
#}
#else {
#print WRITE "$line[0]\t$line[1]\tNA\t$line[3]\n";
#}
	
	
	

#}

#close(WRITE);



