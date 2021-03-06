#!/usr/bin/perl
use warnings;
use strict;
use List::Util 'shuffle';


################
#has to run in /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files cause blastn is a dork about how it looks for the index file for the db
#>> 






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
my $model_files="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files";
my $bitscores="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files/bs_output";
my $shuffddb="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/shuffled_database_uniqseqs.test";
my $pid_sequences="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences";
#!!!!!!!!!!!!!!!!!!!





system("~/Documents/pid_sortnsplit_uniqueseqfixer_forpidfiles.sh");




my @findresult_fasta=`find $pid_sequences -maxdepth 1 -regex \42.*fasta.uniq\42`;# or die "Problem finding PID files: $!\n";
system("find $pid_sequences -maxdepth 1 -regex \42.*fasta.uniq\42 | xargs -ifoo esl-sfetch --index foo >$model_files/junk.txt");# or die "Problem indexing PID files: $!\n";
@findresult_fasta=shuffle(@findresult_fasta);
#print "@findresult_fasta\n";
my %pairs_store=();
#print ">>>>>>>>>>>>>>>>>>>>>>>>>>\n@findresult_fasta\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
##if(exists $ARGV[0]){
foreach my $pid (@findresult_fasta){
	chomp($pid); #print "$pid\n";
	#system("esl-sfetch --index $pid") or die "Problem indexing PID file $pid: $!\n";
	#this is to get the pairs info out of the files
	my @split_pid=split("/", $pid);
	$split_pid[7]=~s/\.fasta//; 
	chomp($split_pid[7]);#print "$split_pid[7]\t";
	my $pairs_name="\.\/$split_pid[7].pairs"; #print "$pairs_name\n";
	$pairs_name=~s/\.uniq//;
	$split_pid[7]=~s/\.uniq//;
	#print "pn: $pairs_name\n";
	my @findresult_pairs=`cat $pid_sequences/$pairs_name`;
	
	foreach my $pair (@findresult_pairs){ #this basically stores the model name as the key and the pairs of seq's plus their pid as the value so later we can do the alignments by model group
		my @split_grep=split(":",$pair);chomp($split_grep[2]);chomp($split_grep[0]);#$split_pid[7]=~s/\_pid\_seqs//;
		my $value="$split_grep[1]:$split_grep[2]:$split_pid[7].fasta.uniq";
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
system("~/Documents/pid_sortnsplit_uniqueseqfixer.sh"); #uniques modle files
system("~/Documents/pid_sortnsplit_uniqueseqfixer_forqueryseqs.sh"); #uniq's unique files
##}
my $counter=0;

my @findresult_modelfasta=`find $model_files -maxdepth 1 -regex \42.*mixedpid.fasta.uniq\42`;
my $numberofmodels=scalar(@findresult_modelfasta);
#print "%%%%%%%%%%%%\n@findresult_modelfasta\n%%%%%%%%%%%%%%/n";
foreach my $model_fasta (@findresult_modelfasta){
	my $queryname=$model_fasta; chomp($queryname);
	$numberofmodels=$numberofmodels-1;
	my $search_queryname=$queryname;
	$search_queryname=~s/mixedpid/queryseq/g; #this bit isn't really needed once I figure out how to loop through each sequence for query searching
	


	my $query_modelname=$queryname; $query_modelname=~s/\/media\/stephmcgimpsey\/GardnerLab-backup1\/Refseq\/Sequences\/pid_sequences\/model_files\///; $query_modelname=~s/\-mixedpid\.fasta\.uniq//;

	my $writefilename="$bitscores/$query_modelname.bs";
	open(WRITE2, ">", "$writefilename") or die "Couldn't make $writefilename; $!";



	$counter++;	
	print "Model running: $query_modelname\t-------\t$numberofmodels models left to run\n";
	system("cat $shuffddb $queryname >$model_files/transient_dbfile.db"); #makes the combined database
	system("makeblastdb -in $model_files/transient_dbfile.db -out $model_files/transient_dbfile.db.blast -parse_seqids -dbtype nucl >$model_files/junk.txt"); #makes the blast index/reference for the database



	system("esl-sfetch --index $model_files/transient_dbfile.db >$model_files/junk.txt"); #indexes the combined database
	my $numseqsinfile=`grep -c \42^>\42 $model_files/transient_dbfile.db`; chomp($numseqsinfile); #this line and the one below figure out how many sequences in the combined database
	print "Number of sequences in DB; $numseqsinfile,   ";
	my @numseqsinquery=`grep \42^>\42 $search_queryname`;
	my $scalar=scalar(@numseqsinquery); print "Number of query sequences: $scalar\t";
	#my @numseqsinquery=split(/\n/,$numseqsinquery);
	
	
###Loop through '-queryfile sequences here'
	foreach my $queryline (@numseqsinquery){ #basically for each sequence loop through all the searches



	#need to sfetch for each grep result and write it out to a temporary file to be used as the query file	
		my @splitqueryline=split('\s+',$queryline); $splitqueryline[0]=~s/\>//; ###DOUBLE CHECK THIS SECTION
		print "$splitqueryline[0]\t";
		system("esl-sfetch --index $search_queryname >$model_files/junk.txt");
		my $query_filename_trans="$model_files/transient_query.fasta";
		system("esl-sfetch $search_queryname $splitqueryline[0] >$query_filename_trans");
		
	#print "\n\n";

####TIME EACH ALIGNMENT INDIV
###commment in what the flags are and why we used them
	########################ssearch36 -local
		my @ss_output=`~/Software/fasta36/bin/ssearch36 -T 8 -E $numseqsinfile -3 -m 3 -n -d 0 -z 0 -q -H $query_filename_trans $model_files/transient_dbfile.db`; 
	#change -E 2 to -E $numseqsinfile
	
	########################ggsearch36 -glocal
		my @gg_output=`~/Software/fasta36/bin/ggsearch36 -T 8 -E $numseqsinfile -3 -m 3 -n -d 0 -z 0 -q -H $query_filename_trans $model_files/transient_dbfile.db`;

	#change -E 2 to -E $numseqsinfile

		#print "@ss_output[7..(scalar(@ss_output)-1)]\n"; ########sort the output into a nice table where the header it is query:seq bitscore ...
		#print "@gg_output\n";
		###

	#########################nhmmer -profile
		my @nhm_output=`nhmmer --tblout $model_files/nhmmer.tbl --cpu 8 --toponly --dna --noali -T -100000 $query_filename_trans $model_files/transient_dbfile.db`;
		#print "@nhm_output\n";

	#########################blastn -heuristic
		my @bl_output=`blastn -num_threads 8 -strand plus -task blastn -evalue 1000000 -num_alignments 0 -index_name $model_files/transient_dbfile.db.ssi -query $query_filename_trans -db $model_files/transient_dbfile.db.blast`;
		#print "@bl_output\n";
		
		
		#orf1:orf2-shuffled:s/g/h/b23.5 
		my $thisistheorfthatisthequerysequence=$splitqueryline[0];
		#my @new_ss_output=@ss_output[13..(scalar(@ss_output)-9)]; 
		my @new_ss_output=@ss_output[0..(scalar(@ss_output)-9)]; 
		foreach my $ssline (@new_ss_output){
			if($ssline=~m/^orf[0-9+]/ | $ssline=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
			my @ssline=split(/\s+/, $ssline);
			print WRITE2 "$thisistheorfthatisthequerysequence:$ssline[0]:$ssline[(scalar(@ssline)-2)]:s:";#this needs printed to family scores file
				if ($ssline[0]=~m/.*shuffled.*/){
					print WRITE2 "F\n";#this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n";#this needs printed to family scores file
				}
			}


		}
		#print "\ngg\n";
		my @new_gg_output=@ss_output[0..(scalar(@ss_output)-9)];# print "\n\n@new_gg_output\n";
		foreach my $ggline (@new_gg_output){
			if($ggline=~m/^orf[0-9+]/ | $ggline=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
			my @ggline=split(/\s+/, $ggline);
			print WRITE2 "$thisistheorfthatisthequerysequence:$ggline[0]:$ggline[(scalar(@ggline)-2)]:g:"; #this needs printed to family scores file
				if ($ggline[0]=~m/.*shuffled.*/){
					print WRITE2 "F\n"; #this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n"; #this needs printed to family scores file
				}
			}


		}
		#print "\n\n@new_ss_output";
		#my $printable=`sed -e 's/The best scores are:/' -e 's/\n/' @ss_output`;

		my @new_nhm_output=`grep -v \42^#\42 nhmmer.tbl`;
		#print "@new_nhm_output";# 

		foreach my $nhm_line (@new_nhm_output){
			my @nhm_linea=split(/\s+/,$nhm_line);
			print WRITE2 "$thisistheorfthatisthequerysequence:$nhm_linea[0]:$nhm_linea[13]:n:"; #this needs printed to family scores file
				if ($nhm_linea[0]=~m/.*shuffled.*/){
					print WRITE2 "F\n"; #this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n"; #this needs printed to family scores file
				}

		}


		#print " @bl_output";
		foreach my $bl_line (@bl_output){
			if($bl_line=~m/^orf[0-9+]/ | $bl_line=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
				my @bl_linea=split(/\s+/,$bl_line);
				print WRITE2 "$thisistheorfthatisthequerysequence:$bl_linea[0]:$bl_linea[(scalar(@bl_linea)-2)]:b:"; #this needs printed to family scores file
				if ($bl_linea[0]=~m/.*shuffled.*/){
						print WRITE2 "F\n"; #this needs printed to family scores file
					}
					else{
						print WRITE2 "T\n"; #this needs printed to family scores file
					}
			}

		}
		
		
		

	}
	####end of loop
	print "\n";

	close(WRITE2);

	# if ($counter==1){
	#last;
	#}

}

#print "\n";
