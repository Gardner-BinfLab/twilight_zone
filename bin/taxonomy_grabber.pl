#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my@tidy;
my $num_args=scalar(@ARGV);
my $num=0;
my $num1=0;
#HELP section - for -h --help h help --h no args given
if (@ARGV eq 0 || $ARGV[0] eq "-h" || $ARGV[0] eq "h" || $ARGV[0] eq "-help" || $ARGV[0] eq "--help" || $ARGV[0] eq "--h"){
print "I see you need some help...\n\nStep 1: If you have a direct R output file from taxonomizr_steph.R please use -r <messy.file.name> <name.you.want.for.tidy.output>\n\nStep 2: If you have already used -r then please choose which taxonomic division you would like to divide the genomes by;\n\t-k\tSuperkingdom\n\t-p\tPhylum\n\t-c\tClass\n\t-o\tOrder\n\t-f\tFamily\n\t-g\tGenus\n\t-s\tSpecies\n\n\tYou can select multiple but please arrange them seperately (e.g -k -g).\n\tThe very last argument you should give is the tidy file name or if you are utilizing Step 1 please give a file prefix you would like the tidy file to be written to.\n\nHere are some examples;\n\n./taxonomy_grabber.pl -r example.messy example.tidy\nThis will just take example.messy and tidy it up and write it to example.tidy\n\n./taxonomy_grabber.pl -r example.messy -f -g example.tidy\nThis will do the same as above but will also split the genomes into groups based on Family and Genus. These will be written to files with Family or Genus as the filename. These will write to the pwd directory.\n\n./taxonomy_grabber.pl -o example.tidy\nThis assumes that you have already done step one at some other time and want to divide up the genomes in example.tidy by Order.\n\n";
} else{
	#print"passed\n";
	if ($ARGV[0] eq "-r"){
print ">>>Tidying to $ARGV[$num_args-1]\n";
		if ($num_args>=3){
			open(my $mess, "<", $ARGV[1]) or die "Can't open $ARGV[1]: $!"; my @mess=<$mess>; close($mess) or die "Can't close $ARGV[1]: $!";
			open(OUT, ">", $ARGV[$num_args-1]) or die "Can't make file $ARGV[$num_args-1]:$!";
			print OUT "Accession\tTax ID\tSuperkingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n";
			foreach my $f_line (@mess){ 
				chomp($f_line);
				#print "$f_line";

				if ($f_line=~m/\[1\]\s[A-Z].*/){ #accessions
				$f_line=~s/\[1\] //g;
				print OUT "$f_line\t";
					$num1++;

				}
				if ($f_line=~m/\[1\]\s[0-9]/){ #taxIDs
					$f_line=~s/\[1] //g;
					print OUT "$f_line\t";###!!!!!!!!!!!!!!! n->t

				}
				if ($f_line=~m/[0-9]\s\"[A-Za-z\s]+\".*/){ #names of stuff
					$f_line=~s/[0-9]+\s+//g; #removes the tax ID
					$f_line=~s/NA/\"NA\"/g;
					my @f_line=split /\"\s+\"/, $f_line; ###############PROBLEM!!!!!!!!!!!!! NA are not found in quotation marks so aren't being split off properly!!!! Hence they make the keys wrong futher down in the hash
						foreach my $flin (@f_line){
							$flin=~s/\"//g;
							print OUT "$flin\t";
						}
			
				}
				if ($f_line eq "[1] \"%%\""){
					#print "%% found\n";
					print OUT "\n";
					$num++;
				}
				
			}
			close(OUT);
		}
		else{
			print "Please type ./taxonomy_grabber.pl -h as you are entering too small a number of arguments for the algorithm\n";		
		}
	} 
	if ($ARGV[0]!~m/-r/ or $ARGV[2]=~m/\-.*/){
		print ">>>Taxonomic divisions chosen\n";
		open(my $tidy, "<", $ARGV[$num_args-1]) or die "Can't open $ARGV[$num_args-1]: $!"; @tidy=<$tidy>; close($tidy) or die "Can't close $ARGV[$num_args-1]: $!";
		foreach my $i (@ARGV){
			#print "$i\n";
			if ($i=~m/-k/){	#2
				print ">Superkingdom\n";
				open(K, ">", "Superkingdom") or die "Can't make Superkingdom file:$!";
				my %khash; #hash to store the phylum names and accessions in
				foreach my $klin (@tidy){
					chomp($klin);
					if($klin=~m/Accession.*/){ #skipping header
					}
					else{
						my@ksplit=split /\t/, $klin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$ksplit[2] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy					
						push( @{$khash{$ksplit[2]}}, $ksplit[0]);						
					}
				}
			#print Dumper(\%khash); #prints hash so you can see it
			foreach my $keysk (sort keys %khash) {
				print K ">$keysk\n@{ $khash{$keysk} }\n";			
			}
			close(K)
			}


			if ($i=~m/-p/){	#3
				print ">Phylum\n";
				open(P, ">", "Phylum") or die "Can't make Phylum file:$!";
				my %phash; #hash to store the phylum names and accessions in
				foreach my $plin (@tidy){
					chomp($plin);
					if($plin=~m/Accession.*/){ #skipping header
					}
					else{
						my@psplit=split /\t/, $plin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$psplit[3] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy	
						push( @{$phash{$psplit[3]}}, $psplit[0]);					
					}
				}
			#print Dumper(\%phash); #prints hash so you can see it
			foreach my $keysp (sort keys %phash) {
				print P ">$keysp\n@{ $phash{$keysp} }\n";			
			}
			close(P)
			}


			if ($i=~m/-c/){	#4
				print ">Class\n";
				open(C, ">", "Class") or die "Can't make Class file:$!";
				my %chash; #hash to store the phylum names and accessions in
				foreach my $clin (@tidy){
					chomp($clin);
					if($clin=~m/Accession.*/){ #skipping header
					}
					else{
						my@csplit=split /\t/, $clin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$csplit[4] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy
						push( @{$chash{$csplit[4]}}, $csplit[0]);					
					}
				}
			#print Dumper(\%chash); #prints hash so you can see it
			foreach my $keysc (sort keys %chash) {
				print C ">$keysc\n@{ $chash{$keysc} }\n";			
			}
			close(C)	
			}
			if ($i=~m/-o/){	#5
				print ">Order\n";
				open(O, ">", "Order") or die "Can't make Order file:$!";
				my %ohash; #hash to store the phylum names and accessions in
				foreach my $olin (@tidy){
					chomp($olin);
					if($olin=~m/Accession.*/){ #skipping header
					}
					else{
						my@osplit=split /\t/, $olin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$osplit[5] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy		
						push( @{$ohash{$osplit[5]}}, $osplit[0]);
				}
				}
			#print Dumper(\%ohash); #prints hash so you can see it
			foreach my $keyso (sort keys %ohash) {
				print O ">$keyso\n@{ $ohash{$keyso} }\n";			
			}	
			close(O)
			}
			if ($i=~m/-f/){	#6
				print ">Family\n";
				open(F, ">", "Family") or die "Can't make Family file:$!";
				my %fhash; #hash to store the phylum names and accessions in
				foreach my $flin (@tidy){
					chomp($flin);
					if($flin=~m/Accession.*/){ #skipping header
					}
					else{
						my@fsplit=split /\t/, $flin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$fsplit[6] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy
						push( @{$fhash{$fsplit[6]}}, $fsplit[0]);					
					}
				}
			#print Dumper(\%fhash); #prints hash so you can see it
			foreach my $keysf (sort keys %fhash) {
				print F ">$keysf\n@{ $fhash{$keysf} }\n";			
			}	
			close(F)
			}
			if ($i=~m/-g/){	#7
				print ">Genus\n";
				open(G, ">", "Genus") or die "Can't make Genus file:$!";
				my %ghash; #hash to store the phylum names and accessions in
				foreach my $glin (@tidy){
					chomp($glin);
					if($glin=~m/Accession.*/){ #skipping header
					}
					else{
						my@gsplit=split /\t/, $glin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$gsplit[7] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy
						push( @{$ghash{$gsplit[7]}}, $gsplit[0]);		
					}
				}
			#print Dumper(\%ghash); #prints hash so you can see it
			foreach my $keysg (sort keys %ghash) {
				print G ">$keysg\n@{ $ghash{$keysg} }\n";			
			}
			close(G)	
			}
			if ($i=~m/-s/){	#8
				print ">Species\n";
				open(S, ">", "Species") or die "Can't make Species file:$!";
				my %shash; #hash to store the phylum names and accessions in
				foreach my $slin (@tidy){
					chomp($slin);
					if($slin=~m/Accession.*/){ #skipping header
					}
					else{
						my@ssplit=split /\t/, $slin; #splitting based on tabs and this is where the PROBLEM FROM ABOVE SCREWS UP THE HASH IN THE NEXT STEP
						$ssplit[8] //= 'NA'; #fixes any line with undefined phylum or entire taxonomy
						push( @{$shash{$ssplit[8]}}, $ssplit[0]);					
					}
				}
			#print Dumper(\%shash); #prints hash so you can see it
			foreach my $keyss (sort keys %shash) {
				print S ">$keyss\n@{ $shash{$keyss} }\n";			
			}
			close(S)
			}
		}

	}
}
