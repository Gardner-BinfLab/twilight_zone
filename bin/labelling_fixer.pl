#!/usr/bin/perl
use warnings;
use strict;

##RUN THIS FIRST IT YOU HAVEN"T ALREADY!!!
##cat ~/Documents/Taxonomy/Phylum | perl -ane 'if($F[0]=~/>.*/){$F[0]=~s/>//;$N=$F[0];} else { $k=0; while ($k<scalar(@F)){print "$N\t";system("grep -w $F[$k] header_filenames.txt"); $k=$k+1;}}' >filename_phylo_firstcontigsonly.txt



my @storage;

#open header_filename and store in a hash, push the contigs to be an array
open(my $file, "<", "header_filenames.txt") or die "Can't open header_filenames.txt; $!"; my @file =<$file>; close($file) or die "Can't close $file; $!";

open(my $file1, "<", "filename_phylo_firstcontigsonly.txt") or die "Can't open filename_phylo_firstcontigsonly.txt; $!"; my @file1 =<$file1>; close($file1) or die "Can't close $file1; $!";
open(WRITE, ">", "filename_phylum.txt") or die "Can't make filename_phylum.txt; $!";
my %filename_contig;
my %filename_phylum;

foreach my $line (@file){
my @line=split('\t',$line);
chomp($line[0]);chomp($line[1]); #splits out the filename and the contig
push @{ $filename_contig{$line[0]} }, $line[1]; # filename=key, contigs =values


}

foreach my $line1 (@file1){
my @line1=split('\t',$line1);
chomp($line1[0]);chomp($line1[1]); #filename=key, phylum=value
$filename_phylum{$line1[1]}=$line1[0];
}

foreach my $key(keys %filename_contig){
my @values=@{$filename_contig{$key}};
if (exists $filename_phylum{$key}){
foreach my $v (@values){
print WRITE "$v\t$filename_phylum{$key}\t$key\n"; #prints contig, phylum, filename
}
}
else {
print "$key\n";
}
}

close(WRITE);

