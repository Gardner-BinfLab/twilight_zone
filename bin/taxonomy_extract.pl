#!/usr/bin/perl
use strict;
use warnings;

#taxonomy grabber - from NCBI slurp 


#input file

open(my $open,  "<",  "$ARGV[0]")  or die "Can't open $ARGV[0] : $!"; my @tax = <$open>; close $open or die "$open: $!";
print "Opened file\n";
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
my $sized = keys %tax_store;
open( my $accs_NCBI, "<" ,'/Users/Stephanie/OneDrive/Thesis/Refseq_b/genomes_allbac_accessions.txt') or die "Can't find/open: $!"; my @NCBI_accs = <$accs_NCBI>; close $accs_NCBI or die "$accs_NCBI: $!";
#print @NCBI_accs, "\n";
my $size = scalar(@NCBI_accs);
#####PRINT ONLY THOSE WITH KEYS MATCHING THE ACCESSION LIST YOU HAVE FOR THE GENOMES YOU ARE GETTING
my @matches;
foreach (keys %tax_store) {

@matches = grep {$_} @NCBI_accs;
    
}
my $size2 = scalar(@matches);
#print @matches, "\n";
#print $size, $size2, "\n";


#print "Finding common accessions between genomes and NCBI 16s";
#my %hash_slice;
####instead of this just use the $vari as the key to grab the tax_store values as the accessions should be the same
#foreach my $vari (@matches) {
# $vari =~ s/^\s+|\s+$//g;
    # foreach (keys %tax_store){
        #print 'This is in the matrix ', $vari, "\t", 'This is the current key ', "$_ \n";
    #   $_ =~ s/^\s+|\s+$//g;
    #  if ($vari =~ m/^$_$/i){
    ## IF KEY EXISTS...
# if (exists $tax_store{$vari}){
#    $hash_slice{$vari} = $tax_store{$vari};
#    print "$_ : $hash_slice{$_}\n";
# }
    #     print 'This is the matrix ', $vari, 'This is the match ', "$_ \n";
    
    # }
    # }
#}


##USE @MATCHES to nab the tax info and group things into same species folders

##SORT THIS SHODDY SHIT OUT...
#my %counts = ();
#my $value;
#foreach my $key (sort keys %hash_slice) {
    # $value = $hash_slice{$key}; #makes the value a scalar I can search for
#   if ($value exists $counts{$value}) {
#       $counts{$value} = [];
#   }
#   push $counts{$value}, $key;
#};

    
    my %counts;
    foreach (values %tax_store) {
        $counts{$_}++;
    }
my $counter=0;
foreach (keys %counts) {
    #print "$_ : $counts{$_}\n";
    $counter=$counter+$counts{$_};
    
}

print 'Num Accessions: ', $size, "\t",'Num Keys in Tax hash: ', $sized, " ", $ac_size, "\t",'Num tax stored: ', $counter, "\n"

#print @accessions_16s, "\n";
#my $length = scalar(@accessions_16s);
#print "$length\t $lengthy\n"; - error checking variable


### what I want to do... remove duplicates accession numbers from the hash
### take the reduced number and then check it against the genomes that we have
### push the accessions into the value and the tax into the key
