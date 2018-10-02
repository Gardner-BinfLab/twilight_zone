#!/usr/bin/perl
use warnings;
use strict;
use List::Util 'shuffle';

###open pid pairs files
###make groups based on family but tag them with correct PID <-grab the aa seq
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

##########SOME WEIRD SHIT IS HAPPENING for both the write out to query file and mixed pid file. Its really f'd up, Check terminal...


#!!!!!!!!!!!!!!!!!!!

my @findresult_fasta=`find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences -maxdepth 1 -regex ".*fasta"`;
`find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences -maxdepth 1 -regex ".*fasta" | xargs -ifoo esl-sfetch --index foo`;
@findresult_fasta=shuffle(@findresult_fasta);
#print "@findresult_fasta\n";
my %pairs_store=();

foreach my $pid (@findresult_fasta){
	#this is to get the pairs info out of the files
	my @split_pid=split("/", $pid);
	$split_pid[7]=~s/\.fasta//; chomp($split_pid[7]);#print "$split_pid[7]\t";
	my $pairs_name="\.\/$split_pid[7].pairs"; #print "$pairs_name\n";
	my @findresult_pairs=`cat /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/$pairs_name`;
	
	foreach my $pair (@findresult_pairs){ #this basically stores the model name as the key and the pairs of seq's plus their pid as the value so later we can do the alignments by model group
		my @split_grep=split(":",$pair);chomp($split_grep[2]);chomp($split_grep[0]);#$split_pid[7]=~s/\_pid\_seqs//;
		my $value="$split_grep[1]:$split_grep[2]:$split_pid[7].fasta";
		push(@{$pairs_store{$split_grep[0]}}, $value);	#print "$value\n";	
	}
}


foreach my $model (keys %pairs_store){
	my $n=0;
	open(WRITE,">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/$model-mixedpid.fasta") or die "Can't make file $model-mixedpid.fasta; $!";
	open(WRITE1,">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/$model-queryseq.fasta") or die "Can't make file $model-queryseq.fasta; $!";
	my @values=@{$pairs_store{$model}};
	my $size_value=scalar(@values);
	#print "$model\t$size_value\n";
	foreach my $pid_val (@values){
		#print "$model\t$pid_val\n";
		my @split_seqpairs=split(":", $pid_val); chomp($split_seqpairs[2]);
		#print "$split_seqpairs[0]\t$split_seqpairs[1]\t$split_seqpairs[2]\n";
		my @sfetch=`esl-sfetch /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/$split_seqpairs[2] $split_seqpairs[0]`; chomp($sfetch[0]);
		
		if ($n<=0){
			print WRITE "$sfetch[0]:$split_seqpairs[2]\n"; print WRITE1 "$sfetch[0]:$split_seqpairs[2]\n";

			shift(@sfetch);@sfetch = grep /\S+/, @sfetch; s{^\s+|\s+$}{}g foreach @sfetch;

			my $m=0;
			while ($m<scalar(@sfetch)){
				print WRITE "$sfetch[$m]\n"; print WRITE1 "$sfetch[$m]\n";	
$m++;
			}


			close(WRITE1);
		}
		else{
			print WRITE "$sfetch[0]:$split_seqpairs[2]\n"; shift(@sfetch);@sfetch = grep /\S+/, @sfetch; s{^\s+|\s+$}{}g foreach @sfetch;

			my $q=0;
			while ($q<scalar(@sfetch)){
				print WRITE "$sfetch[$q]\n";
$q++; 
			}

		}

		my @sfetch1=`esl-sfetch /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/$split_seqpairs[2] $split_seqpairs[1]`; chomp($sfetch1[0]);
		print WRITE "$sfetch1[0]:$split_seqpairs[2]\n";shift(@sfetch1); s{^\s+|\s+$}{}g foreach @sfetch1;
		my $l=0;
		while ($l<scalar(@sfetch1)){
			print WRITE "$sfetch1[$l]\n"; 
$l++;
		} #while
	$n++;
	} #foreach
close(WRITE);


}#foreach









#my @findresult_modelfasta=`find /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files -maxdepth 1 -regex ".*mixedpid.fasta"`;

#foreach my $model_fasta (@findresult_modelfasta){
#	my $queryname=$model_fasta;
#	my $shuffddb="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/shuffled_database.test";
	
#	$queryname=~s/mixedpid/queryseq/g;
	#print "$queryname\n$model_fasta\n";
##this takes ten years

	
#	my @cat=`cat $shuffddb $queryname >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/transient_dbfile.db`;
	#open(WRITE2, ">", "/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/transient_dbfile.db") or die " Can't make transient_dbfile.db; $!";
	#print WRITE2 "@cat";
	#close(WRITE2);

##this takes ten years



#	`esl-sfetch --index /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/transient_dbfile.db`;
#	my @ss_output=`~/Software/fasta36/bin/ssearch36 $queryname /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/transient_dbfile.db`;

#	print "$ss_output[0]\n";

	###

	###./bin/glsearch36 QUERY LIBRARY

	#




#}

#print "\n";
