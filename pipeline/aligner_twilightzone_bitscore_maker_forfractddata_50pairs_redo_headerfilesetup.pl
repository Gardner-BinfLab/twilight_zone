#!/usr/bin/perl
use warnings;
use strict;
use List::Util 'shuffle';


################
#has to run in /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files cause blastn is a dork about how it looks for the index file for the db
#>> 

##have to fix the bloody .sh scripts and filehandles so it finds the right files


##>find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files -maxdepth 1 -regex ".*ENOG4108UUX-mixedpid.fasta.uniq\|.*Ala-mixedpid.fasta.uniq" | parallel -j 2 --eta './aligner_twilightzone_bitscore_maker_forfractddata_jan28thredo.pl {}'

#test run >>find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files -maxdepth 1 -regex ".*ENOG4108UUX-mixedpid.fasta.uniq\|.*Ala-mixedpid.fasta.uniq" | parallel -j 2 --eta './aligner_twilightzone_bitscore_maker_forfractddata_jan28thredo.pl {}'


#>>ncRNA while ssearch36 - find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files -maxdepth 1 -regex ".*RF[0-9]+\-mixedpid\.fasta\.uniq" | parallel -j 2 --eta './aligner_twilightzone_bitscore_maker_forfractddata_jan28thredo.pl {}'

#tRNAS find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files -maxdepth 1 -regex "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files/[A-Za-z]+\-mixedpid\.fasta\.uniq" | parallel -j 2 --eta './aligner_twilightzone_bitscore_maker_forfractddata_jan28thredo.pl {}'

#mRNA find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files -maxdepth 1 -regex "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files/ENOG.*\-mixedpid\.fasta\.uniq" | parallel -j 6 --eta './aligner_twilightzone_bitscore_maker_forfractddata_jan28thredo.pl {}'
################




###open pid pairs files
###make groups based on family but tag them with correct PID
##run the alignments with each family (by opening fasta files and grepping them all together using sfetch I think?? or sed thing from pid_sortnsplit.pl and writing them to a file before concatenating in a pipe with false db) and the false DB



#local SW, glocal SW, blast, hm/cmalign
###grep out the bitscores and maybe the evalues
###create matrices of these scores for each pair


##/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/#_pid_seqs.fasta
##/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/#_pid_seqs.pairs <<tells you the model kind
###/media/stephmcgimpsey/GardnerLab-backup1/Refseq/shuffled_database.test
##/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/all_nocuttoff_aaseq_proteincoding.shuf ##aaseq shuffled <-DON"T NEED THIS

#./bin/ggsearch36
#./bin/ssearch36





#!!!!!!!!!!!!!!!!!!!!
#Paths
#my $model_files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/model_files";
#my $bitscores="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset/bs_output";
#my $shuffddb="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/gene_sequences/shuffled_versions/shuffled_database_fracted_uniqseqs_fasta.db";
#my $pid_sequences="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/bs_cuttoff/aligned_sequences/length_fractd_alignments/PID/PIDsubset";




#!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!
#Paths
my $model_files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset/model_files";
my $pid_sequences="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset";




#!!!!!!!!!!!!!!!!!!!





#system("~/Documents/pid_sortnsplit_uniqueseqfixer_forpidfiles_fractd.sh"); # only has to run once




my @findresult_fasta=`find $pid_sequences -maxdepth 1 -regex \42.*fasta.uniq\42`;# or die "Problem finding PID files: $!\n";
system("find $pid_sequences -maxdepth 1 -regex \42.*fasta.uniq\42 | xargs -ifoo esl-sfetch --index foo >$model_files/junk.txt");# or die "Problem indexing PID files: $!\n";
@findresult_fasta=shuffle(@findresult_fasta);
#print "@findresult_fasta\n";
my %pairs_store=();
#print ">>>>>>>>>>>>>>>>>>>>>>>>>>\n@findresult_fasta\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
##if(exists $ARGV[0]){
foreach my $pid (@findresult_fasta){
	my $testlength=scalar(@findresult_fasta);
	chomp($pid); #print "$pid\n";
	#system("esl-sfetch --index $pid") or die "Problem indexing PID file $pid: $!\n";
	#this is to get the pairs info out of the files
	my @split_pid=split("/", $pid);
	#print "@split_pid\n$split_pid[-1]\n";


	$split_pid[-1]=~s/\.fasta\.uniq//; 
	chomp($split_pid[-1]);#print "$split_pid[7]\t";
	my $pairs_name="$split_pid[-1].pairs"; #print "$pairs_name\n";
	#print "pn: $pairs_name\tnum pid: $testlength\n";
	my @findresult_pairs=`cat $pid_sequences/$pairs_name`;
	
	foreach my $pair (@findresult_pairs){ #this basically stores the model name as the key and the pairs of seq's plus their pid as the value so later we can do the alignments by model group
		my @split_grep=split(":",$pair);chomp($split_grep[2]);chomp($split_grep[0]);#$split_pid[7]=~s/\_pid\_seqs//;
		my $value="$split_grep[1]:$split_grep[2]:$split_pid[-1].fasta.uniq";
		#print "$split_grep[1]:$split_grep[2]:$split_pid[-1].fasta.uniq\n";
		push(@{$pairs_store{$split_grep[0]}}, $value);	#stores both sequence names plus the PID file name as the value in the hash	
	}
}


foreach my $model (keys %pairs_store){ #foreach model storesd
	
	open(WRITE,">", "$model_files/$model-mixedpid.fasta") or die "Can't make file $model-mixedpid.fasta; $!";
	open(WRITE3,">", "$model_files/$model.pidinfo") or die "Can't make file $model-mixedpid.pidinfo; $!";
	open(WRITE1,">", "$model_files/$model-queryseq.fasta") or die "Can't make file $model-queryseq.fasta; $!";
	my @values=@{$pairs_store{$model}}; #dereference the array stored as the value of the hash
	my $size_value=scalar(@values); #figure out the size of the array aka

	foreach my $valuesl (@values){
		print WRITE3 "$valuesl\n"; 
	}
	close(WRITE3);
	
	foreach my $pid_val (@values){ #for each sequence pair stored in the hash
		#print "$model\t$pid_val\n";
		my @split_seqpairs=split(":", $pid_val); chomp($split_seqpairs[2]); #split based in the : which splits out the two sequence names and the PID filename
		
		my @sfetch=`esl-sfetch $pid_sequences/$split_seqpairs[2] $split_seqpairs[0]`; chomp($sfetch[0]); #grabs the sequence for the first sequence name from the PID file
		
	
			print WRITE "$sfetch[0]\n"; print WRITE1 "$sfetch[0]\n";

			shift(@sfetch);@sfetch = grep /\S+/, @sfetch; s{^\s+|\s+$}{}g foreach @sfetch;

			my $m=0;
			while ($m<scalar(@sfetch)){ #writing the actual fasta sequence
				print WRITE "$sfetch[$m]\n"; print WRITE1 "$sfetch[$m]\n";	
				$m++;
			}



		my @sfetch1=`esl-sfetch $pid_sequences/$split_seqpairs[2] $split_seqpairs[1]`; chomp($sfetch1[0]); #grabs the second sequence and writes it just to the mixed PID file
		print WRITE "$sfetch1[0]\n";shift(@sfetch1); s{^\s+|\s+$}{}g foreach @sfetch1;
		my $l=0;
		while ($l<scalar(@sfetch1)){#writing the actual fasta sequence
			print WRITE "$sfetch1[$l]\n"; 
			$l++;
		} #while
		
	} #foreach
close(WRITE);
close(WRITE1);


}#foreach



#############Just so you know, you will have to use the .pairs files to get the bitscores and sequence pairs sorted back into the right places as when you remove duplicates sequences (due to the same sequence being in multiple PID files) from the mixed and query fasta files, you are removing PID info for that duplicate too.

print "Fixing model files to remove duplicates...\t";
system("~/Documents/pid_sortnsplit_uniqueseqfixer_fractd.sh"); #uniques modle files 
system("~/Documents/pid_sortnsplit_uniqueseqfixer_forqueryseqs_fractd.sh"); #uniq's unique files 
##}
