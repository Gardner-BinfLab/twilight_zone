#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

###ARGV[0] is the accession to filenames file ~/Documents/
####ARGV[1] is the cmsearch output 

##Run in ~/Documents directory
##./cmsearch_to_seqs.pl 1 2 header_filenames.txt /home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/all_genomes_16srRNA_no#.tbl #remove 1 or 2 if step already run

##start wth grabbing all the contig names, cutting them down and checking how many match each filename
#if multiple - pick highest scoring one and discard the matches from the cmsearch hits array

print "INSTRUCTIONS\n\n- To get a list of contig hits that match up to filenames for sorting type\n\t./cmsearch_to_seqs.p 1 headerfilenames.txt /home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/all_genomes_16srRNA.tbl\n- If you also want to grab the sequences\n\t./cmsearch_to_seqs.p 1 2 headerfilenames.txt /home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/all_genomes_16srRNA.tbl\n- If you just want the sequences and have already run step 1 all you have to type is\n\t./cmsearch_to_seqs.pl 2\n\n-----------------------------------------------------\n\n";


my $sizeARGV=scalar(@ARGV);
my %cmsearch_filename=();
my %lengthBS_filename=();
my %headtofile;
my %canthave;
if ($ARGV[0]=~1){
	print "Matching contigs to filenames...this will take ages...\n";
	open(my $open, '<', $ARGV[$sizeARGV-2]) or die "Can't open $ARGV[$sizeARGV-2]: $!"; my @open=<$open>; close($open) or die "Can close $ARGV[$sizeARGV-2]: $!"; ##header->filenames
	print "Filename to contig file opened\n";
	open(my $open1, '<', $ARGV[$sizeARGV-1]) or die "Can't open $ARGV[$sizeARGV-1]: $!"; my @open1=<$open1>; close($open1) or die "Can close $ARGV[$sizeARGV-1]: $!"; #cmsearch output that has had the HASHED content removed - grep -v ^"#" all_genomes_16srRNA.tbl >all_genomes_16srRNA_no#.tbl
	print "CMsearch tidy output file opened\n";
	#my $pattern='^#.*';
	#@open1=grep ! /$pattern/, @open1; #greps non # lines aka result lines in the output
	
	open(WRITE,'>', "/home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/rough_cmsearch_filenames_16srRNA_bitscorecutoffadded.txt") or die "Can't make rough_cmsearch_filenames_16srRNA.txt; $!"; #file to write top hit matches to
	foreach my $fileline (@open){
		my @splitzz=split('\t',$fileline);chomp($splitzz[0]);chomp($splitzz[1]); 
		$headtofile{$splitzz[1]}=$splitzz[0];

	}

	open(my $open2, '<', "genomes_lessthan5_hmmhits_forDNArepGenomecompletenessTesting.txt") or die "Can't open genomes_lessthan5_hmmhits_forDNArepGenomecompletenessTesting.txt: $!"; my @open2=<$open2>; close($open2) or die "Can close genomes_lessthan5_hmmhits_forDNArepGenomecompletenessTesting.txt: $!";
	foreach my $fileline2 (@open2){ 
		chomp($fileline2);
		$fileline2="$fileline2.fna";
		#print "$fileline2\n";
		$canthave{$fileline2}=1;

	}
my $nnn=0;

	foreach my $l (@open1){ #iterate through every line of cmsearch output that doesn't start with #
		#print ". ";
		my @info=split('\s+', $l); #split the search lines so we can...
		my $results=$headtofile{$info[0]};
		chomp($results);
		#my @results=grep /$info[0]/, @open; #access the contig name and use it to find the filename from @open which has contigs+filenames
		#chomp($results[0]); my @info2=split('\s+',$results[0]);
		#print "$info2[0]\t$l";
		my $lengthh=abs($info[7]-$info[8]);
					#my @potmatch=grep -w "$results", @open2;
					#print "$results\t";
if (exists $canthave{$results}){
print "$results\t";
}
else{




		if ($lengthh>=1000 && $lengthh<=2000){ #only stores those of reasonable length (16s is approax 1500 so 1000-2000nucs long)
				#print "l:$info[14] ";
			chomp($results); #print "$matcheroonie\n";



				if($info[14]>=563.9952){
					
					#if (scalar(@potmatch)=~0){
			my $bslength="$info[14]_$info[0]";
			push @{ $cmsearch_filename{$results} }, $l;
			push @{ $lengthBS_filename{$results} }, $bslength;
			#print "MATCH ";
					#}
					#else {print "$matcheroonie\n";}
				}	
		}
		else{}
		@info=();
		$nnn++;
		#print "$nnn ";
	}
	}
print "\n";
	foreach my $key (keys%cmsearch_filename ){
		#print ". ";

	#######FIX WHAT U ADD so its only the top hit here
	#Grab out the scores and the lengths 7,8,14
	#lenght must be 1000-2000
	#score just has to be the highest
	my @value=@{ $lengthBS_filename{$key} };
		#print "HASH ORDER:\t@value\n";
	my @newvalues=reverse sort(@value);
	

	my @valsforpickingline=split("_", $newvalues[0]);
	#print "!!!!!!@valsforpickingline\n";
	my @cmsearchlines=@{ $cmsearch_filename{$key} };
	chomp($valsforpickingline[0]);chomp($valsforpickingline[1]);
	my @grepresult= grep /$valsforpickingline[0]/ && /$valsforpickingline[0]/, @cmsearchlines;
	
	
		print WRITE ">$key\n$grepresult[0]";

	}

	close(WRITE);
	##step 2.0
	#open that file && take top hit and use it to open genome files, find the right contig, grab the right sequence, invert or don't
	#7,8,9 give the strandedness (9) plus start and end coords, 14 gives the bitscore

}




if ($ARGV[0]=~2 | (exists $ARGV[1] && $ARGV[1]=~2)){
	print "Grabbing 16srRNA sequences...this will take forever...\n";
	my %seen; 
	my $n=0;
	my $cnt=0;
	my $fileName=''; 
	unlink("16s-rRNA_bitscorecutoffadded.fa");
	open(my $close,'<', "/home/stephmcgimpsey/Documents/Essential_HMM_CM/CMs/rough_cmsearch_filenames_16srRNA_bitscorecutoffadded.txt") or die "Can't open rough 16srRNA file: $!"; 
	while(my $in = <$close>){
		if($in=~/^>(\S+)/){
			$fileName=$1;
			
		}		
		elsif( $in=~/SSU_rRNA_bacteria/ && not defined($seen{$fileName}) ){
			
			my @in = split(/\s+/, $in);
			if($in[0]=~/^\S+$/ && $in[7]=~/^\d+$/ ){
				my $fullPathFileName = "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/refseq-bacterial/$fileName"; 
				if(not -s "$fullPathFileName\.ssi"){
					system("esl-sfetch --index $fullPathFileName");
				}
				system("esl-sfetch -c $in[7]-$in[8] -n \42$in[0]_$in[7]-$in[8] $in[14] $fileName\42 $fullPathFileName $in[0] >> 16s-rRNA_bitscorecutoffadded.fa");
				
				$cnt++;
				#last if ($cnt==5);
			}			

			$seen{$fileName}=1;		
		}
	}	
	close($close) or die "Can close rough 16srRNA file: $!";


}

print "DONE\n";


