#!/usr/bin/perl
use strict;
use warnings;

#taxonomy grabber - from NCBI slurp 




open(my $open,  "<",  "$ARGV[0]")  or die "Can't open $ARGV[0] : $!"; my @tax = <$open>; close $open or die "$open: $!"; #opening input file 0 aka the NCBI taxonomy file that you downloaded
print "Opened file...\n";

my @split;my @accessions_16s;my %tax_store;my $line;my $joint_tax; #setting up holding arrays
my $c=0;my $line1=0;my $line2=0;my $line_counter=0; #setting up counting variables


foreach my $count (@tax) { #checking each line of the tax file
    $line_counter++; #line counter for the tax file to be used further down
    
    if ($count =~ m/.*ACCESSION.*/){ #finding lines starting with accession
        #print $count;
        @split = split(' ',$count); #splitting the line so you can access the accession
        #print $split[1], "\n";
        $accessions_16s[$c] = $split[1]; #storing the accession in a array as the value
        $c++; #increasing the array index so the next accession gets stored in the next slot
    }
    
    if ($count =~ m/.*ORGANISM.*/){ #checking the line for ORGANISM as a matching characteristic
        $line=$line_counter-1; #current line aka species name
        $line1=$line_counter; #line below current line aka start of taxonomy data
        $line2=$line_counter+1; #two lines below current line aka last line of taxonomy data
        chomp($tax[$line1]); chomp($tax[$line2]); chomp($tax[$line]); #removing whitespace
        $joint_tax = join('',$tax[$line1], $tax[$line2], $tax[$line]);#pushing the taxonomy data into one line and putting the species name on the end
        $joint_tax =~ s/\;\s+/_/g; #swaps ; for _ in the taxonomy data part of the stored value
        $joint_tax =~ s/ORGANISM\s+\w+//g; #removes ORGANISM
        $joint_tax =~ s/\.\s+/_/g; #swaps the . in the organism name with an _
        $tax_store{$accessions_16s[$c-1]}=$joint_tax; #storing the taxonomy data as a value in a hash and using the array of stored accession made in the above loop to put the appropriate accession as the key (i.e. $c-1 as we've already counted +1 after storing the array
    }
}

print "Taxonomy data extracted...\n";
####
####So the above code has stored the accession and taxonomy information in a hash; key->accession, value->taxonomy data
####

print "Opening genome list file...\t";
#opening genome accessions from the full genomes we have slurped aka the genomes we have from NCBI and can use to run our own cms and hmm's on
open( my $accs_NCBI, "<" ,'genomes_allbac_accessions.txt') or die "Can't find/open: $!"; my @NCBI_accs = <$accs_NCBI>; close $accs_NCBI or die "$accs_NCBI: $!";
print "Genome list file opened\n";
print "Starting matching protocol... \t";


#####THIS BIT IS BROKEN... ##what I want to do is take out all the accessions and corresponding keys from %tax_store that match the accessions of genomes we have downloaded
my %genome_tax; #for storing tax info of genome accessions you actually have
my $acc;
foreach $acc (@NCBI_accs){
	chomp($acc);
print "$acc\n";
	#trim whitespace and junk
	if (exists $tax_store{$acc}){
		$genome_tax{$acc}=$tax_store{$acc};
	}
}
###THIS BIT IS BROKEN... ###FIX ME :)


my %tax_counts; # initialise hash
foreach (values %tax_store) { #foreach value in the array
$tax_counts{$_}++; #basically if the value is already a key in the new array it counts +1 so tells me how many of each taxonomy there is
    ##NEED TO GET THIS SO THAT IT IS STORING THE ACCESSIONS AND THAT THE TAXONOMY VALUE IS JUST GENUS UP, NOT SPECIES INCLUSIVE
}


my $stored_counts=0;
foreach (keys %tax_counts) {
    #print "$_ : $counts{$_}\n";
    $stored_counts=$stored_counts+$tax_counts{$_};
    
}
print "Match protocol complete\n";

my $num_acc_genomes = scalar(@NCBI_accs); #number of accessions we have genomes for
my $num_acc_taxstore = keys %tax_store; #number of keys aka accessions in taxonomy store hash
my $stored_tax_genomes= keys %genome_tax; # how many keys got stored based on shared genome accessibility and taxonomic information
print 'Num Genome Accessions: ', $num_acc_genomes, "\t",'Num Accesions in Tax hash: ', $num_acc_taxstore, "\t", 'Stored counts of taxonomy', " ", $stored_counts, "\t", 'Genomes with tax info', " ", $stored_tax_genomes,"\n";






###TWO PROBLEMS- better to download taxonomic info from NCBI direct
### - list of accessions 'we have' is contaminated with things that aren't accessions so need to clean it up and sort it out using the list of URLs that we used to get the genomes



#STEP ONE TAKE ACCESSIONS LIST FROM DOWNLOAD LIST
#STEP TWO TAKE ACCESSIONS AND GET CORRESSPONDING TAXID
#STEP THREE TAKE TAXID AND MAKE THE WEBLINK TO GET THE TAXONOMY LINEAGE DATA

