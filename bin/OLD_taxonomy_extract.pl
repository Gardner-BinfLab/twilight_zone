#!/usr/bin/perl
use strict;
use warnings;


#taxonomy grabber - from NCBI slurp 
#Arg 1 = file of taxonomic data
#Arg 2 = file of accessions of genomes you have



#input file

open(my $open,  "<",  "$ARGV[0]")  or die "Can't open $ARGV[0] : $!"; my @tax = <$open>; close $open or die "$open: $!";
print "Opened $ARGV[0]\n";
#find ‘Accession’, take F1
#find the
#print $tax[10], "\n";
my @split;
my @accessions_16s;
my %tax_store;
my $c=0;
my $line;
my $line1=0;
my $line2=0;
my $line_counter=0;
my $joint_tax;
#my $lengthy=0; - error checking variable

foreach my $count (@tax) {
    $line_counter++;
    if ($count =~ m/.*ACCESSION.*/){
        #print $count;
        @split = split(' ',$count);
        #print $split[1], "\n";
        $accessions_16s[$c] = $split[1];
        
        #$lengthy++; - error checking variable
       $c++;
    }
    if ($count =~ m/.*ORGANISM.*/){
        $line=$line_counter-1;
        $line1=$line_counter;
        $line2=$line_counter+1;
        chomp($tax[$line1]); chomp($tax[$line2]); chomp($tax[$line]);
        $joint_tax = join('',$tax[$line1], $tax[$line2], $tax[$line]);#will have to remove annoying whitespace and colons later
        #my @array = split(';', $joint_tax);#my @new = grep(s/\s*$//g, @array);#my $ar = reverse($array[4]);#chomp($ar);#$array[4] =~ s/\s+//;#my $ar2 = reverse($ar);#print $array[4], "\n";#print $joint_tax, "\n";
        
        $tax_store{$accessions_16s[$c-1]}=$joint_tax;
        #$lengthy++; - error checking variable
    }
    
    
}
print "Split taxonomic file into accession and taxonomy info and stored in a hash\n";
#### Fixes taxonomic description to be seperated by underscores and contain domain -> species nicely
#### key= accession, value= taxonomic info
#my @taxie;
my $ac_size= scalar(@accessions_16s);
foreach (keys %tax_store) {
    $tax_store{$_} =~ s/\;\s+/_/g;
    $tax_store{$_} =~ s/ORGANISM\s+\w+//g;
    $tax_store{$_} =~ s/\.\s+/_/g;
    #@taxie= split('_',$tax_store{$_});
    #print @taxie, "\n";
    #print "$_ : $tax_store{$_}\n";
}
print "Taxonomy cleaned up and uniformly semi-colon delimited\n";
my $sized = keys %tax_store;
open( my $accs_NCBI, "<" ,"$ARGV[1]") or die "Can't find/open: $!"; my @NCBI_accs = <$accs_NCBI>; close $accs_NCBI or die "$accs_NCBI: $!";
print "Opened $ARGV[1]\n";
my $size = scalar(@NCBI_accs);
#####PRINT ONLY THOSE WITH KEYS MATCHING THE ACCESSION LIST YOU HAVE FOR THE GENOMES YOU ARE GETTING
my @matches;
foreach (keys %tax_store) {

@matches = grep {$_} @NCBI_accs;
    
}
my @keyss = keys %tax_store;
print "Matching accessions from taxonomy file and genome accessions found\n";
my $size2 = scalar(@matches);


my $scalar_count;
my %counts2;
my %counts;
my%rev_tax_store=reverse %tax_store;
foreach (keys %tax_store) { 
####FIX THIS UP!!!
#if matches one from @matches then shove it in the counts, key -> value and vice versa
#if value already exists then make value an array by pushing the new accession on to the existing one
	#$counts2{$_}++; #count how many taxonomy are duplicates
	#push ( @{$counts{$_}}, $rev_tax_store{$_});
	#print "$_, @{$counts{$_}}, $counts2{$_}\n";
}

open( OUTPUT, ">" ,"Tax&acc.txt") or die "Can't find/open: $!";
print "Made output file\n";
my $counter=0;

my @v;

foreach (keys %counts ){
#@v=$counts{$_};
    print OUTPUT "$_\t", "@{$counts{$_}}\n";
}


close OUTPUT or die "$!";
print "closed output file\n";


my $tester = keys %counts;
print 'Num Accessions of Genomes: ', $size, "\t",'Num Keys in Taxonomy hash: ', $sized, " ", $ac_size, "\t", "Num of unique taxonomys stored: ", $tester , "\n";


