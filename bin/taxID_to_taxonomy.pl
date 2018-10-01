#!/usr/bin/perl
use LWP::Simple;


# Download taxonomy records corresponding to a list of GI numbers.

#$db = 'taxonomy'; #taxonomy
#open(my $OPEN, ">", $ARGV[0]) or die "Can't open $ARGV[0]; $!"; my @OPENED=<$OPEN>; close $OPEN or die "Can't close $ARGV[0]";

#foreach my $LINE (@OPEN){

#$id_list = $LINE; #needs to be comma delimited and 5000 or less
$id_list=$ARGV[0];
#$url ="https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=$id_list&lvl=0";
#$data= get($url);
#print "$data\n";

#assemble the epost URL
$base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
$url = $base . "epost.fcgi?db=$db&id=$id_list";
print "$url\n";

#post the epost URL
$output = get($url);

#parse WebEnv and QueryKey
$web = $1 if ($output =~ /<WebEnv>(\S+)<\/WebEnv>/);
$key = $1 if ($output =~ /<QueryKey>(\d+)<\/QueryKey>/);

### include this code for EPost-ESummary
#assemble the esummary URL
$url = $base . "esummary.fcgi?db=$db&query_key=$key&WebEnv=$web";
print "$url\n";
#post the esummary URL
$docsums = get($url);
print "$docsums";

### include this code for EPost-EFetch
#assemble the efetch URL
$url = $base . "efetch.fcgi?db=$db&query_key=$key&WebEnv=$web";
$url .= "&rettype=fasta&retmode=text";
print "$url\n";
post the efetch URL
$data = get($url);
print "$data";

#}

