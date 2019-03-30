#!/usr/bin/perl
use warnings;
use strict;
use List::Util 'shuffle';


#/usr/bin/time find /Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models -maxdepth 1 -regex "/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models/.*\-mixedpid\.fasta\.uniq" | parallel -j procfile --nice 5 --eta './aligner_twilightzone_bitscore_maker_forfractddata_iterativenhmmer_parallel.pl {}'

####don't run at the same time as the ggsearch only one

######################HAS TO BE RUN AFTER normal aligner has at least gotten to the alignment part of the program as have removed the fasta file making stuff at the start which groups things into their model files

##also for rerunning ggsearch as I screwed up and was saving the ssearch output to the ggsearch output like a dumb bum


#!!!!!!!!!!!!!!!!!!!!
#Paths
my $model_files="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models";
my $bitscores="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/bs_output";
my $shuffddb="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/database/shuffled_database_50pairs_redo_fasta.db";




#!!!!!!!!!!!!!!!!!!!


#my $counter=0;

#my @findresult_modelfasta=`find $model_files -maxdepth 1 -regex \42.*mixedpid.fasta.uniq\42`;
#my $numberofmodels=scalar(@findresult_modelfasta);
#print "%%%%%%%%%%%%\n@findresult_modelfasta\n%%%%%%%%%%%%%%/n";
#foreach my $model_fasta (@findresult_modelfasta){
	my $queryname=$ARGV[0]; chomp($queryname);
	#$numberofmodels=$numberofmodels-1;
	my $search_queryname=$queryname;
	$search_queryname=~s/mixedpid/queryseq/g; #this bit isn't really needed once I figure out how to loop through each sequence for query searching
	


	my $query_modelname=$queryname; $query_modelname=~s/\/Volumes\/userdata\/staff_groups\/gardnerlab\/stephmcgimpsey\/nhm_it_50\/models\///; $query_modelname=~s/\-mixedpid\.fasta\.uniq//;

	my $writefilename="$bitscores/$query_modelname.bs_redo";
	open(WRITE2, ">", "$writefilename.nhmmeriterative") or die "Couldn't make $writefilename; $!";



		
	my $test_url="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/database";
	print "Model running: $query_modelname\n";
	system("cat $shuffddb $queryname >$test_url/$query_modelname.transient_dbfile.db"); #makes the combined database #normaly 
	#system("makeblastdb -in $test_url/$query_modelname.transient_dbfile.db -out $test_url/$query_modelname.transient_dbfile.db.blast -parse_seqids -dbtype nucl >$test_url/junk.txt"); #makes the blast index/reference for the database



	system("esl-sfetch --index $test_url/$query_modelname.transient_dbfile.db >$test_url/junk.txt"); #indexes the combined database
	my $numseqsinfile=`grep -c \42^>\42 $test_url/$query_modelname.transient_dbfile.db`; chomp($numseqsinfile); #this line and the one below figure out how many sequences in the combined database
	print "Number of sequences in DB; $numseqsinfile,   ";
	my @numseqsinquery=`grep \42^>\42 $search_queryname`;
	my $scalar=scalar(@numseqsinquery); print "Number of query sequences: $scalar\t";
	#my @numseqsinquery=split(/\n/,$numseqsinquery);
	
	
###Loop through '-queryfile sequences here'
	foreach my $queryline (@numseqsinquery){ #basically for each sequence loop through all the searches



	#need to sfetch for each grep result and write it out to a temporary file to be used as the query file	
		my @splitqueryline=split('\s+',$queryline); $splitqueryline[0]=~s/\>//; ###DOUBLE CHECK THIS SECTION
		print "$splitqueryline[0]--";
		#open(TEST,"echo \42YES\42 |"); my @test=<TEST>; print "$test[0]\n";
		system("esl-sfetch --index $search_queryname >$test_url/junk.txt");
		my $query_filename_trans="$test_url/$query_modelname.transient_query.fasta";
		system("esl-sfetch $search_queryname $splitqueryline[0] >$query_filename_trans");
		
	#print "\n\n";
		 #to make ssearch and ggsearch output smaller

	my $cpu=2;

		##ITERATION 1 
		system("nhmmer --tblout $test_url/$query_modelname.redo_nhmmerit1.tbl -A $test_url/$query_modelname.redo_nhmmerit1.align --cpu $cpu --toponly --dna --noali -E 0.0000000001 $query_filename_trans $test_url/$query_modelname.transient_dbfile.db >$test_url/junk.nhmmer1");
		print "nh1..";	
		system("hmmbuild --dna --cpu $cpu $test_url/$query_modelname.redo_nhmmerit1.hmm $test_url/$query_modelname.nhmmerit1.align >$test_url/junk.hmmbuild1");
		print "hb1..";
		##ITERATION 2 
		system("nhmmer --tblout $test_url/$query_modelname.redo_nhmmerit2.tbl -A $test_url/$query_modelname.redo_nhmmerit2.align --cpu $cpu --toponly --dna --noali -E 0.0000000001 $test_url/$query_modelname.redo_nhmmerit1.hmm $test_url/$query_modelname.transient_dbfile.db >$test_url/junk.nhmmer2");
		print "nh3..";
		system("hmmbuild --dna --cpu $cpu $test_url/$query_modelname.redo_nhmmerit2.hmm $test_url/$query_modelname.redo_nhmmerit2.align >$test_url/junk.hmmbuild2");
		print "hb2..";
		##ITERATION 3 - the final one
		system("nhmmer --tblout $test_url/$query_modelname.redo_nhmmerit3.tbl --cpu $cpu --toponly --dna --noali -T -1000000000 --F1 0.3 --F2 0.1 --F3 0.003 $test_url/$query_modelname.redo_nhmmerit2.hmm $test_url/$query_modelname.transient_dbfile.db >$test_url/junk.nhmmer3");
		print "nh3\t";
		#1run search
		#2 esl-sfetch the mixed-pid sequences that are good minus the identicle matching sequence
		#3 make hmm - align the query + the others, feed into hmmbuild #Usage: hmmbuild [-options] <hmmfile_out> <msafile>
		#4run search with new hmm #Usage: nhmmer [options] <query hmmfile|alignfile> <target seqfile>
		#5 esl-sfetch the mixed-pid sequences that are good minus the identicle matching sequence
		#6 make hmm - align the query + the others, feed into hmmbuild
		#7run search with new hmm #Usage: nhmmer [options] <query hmmfile|alignfile> <target seqfile>
		#8 this is the output to use	

	#my @nhm_output=`grep -v \42^#\42 $test_url/nhmmer.iterative.tbl`;
		#open(WRITE1 ">", "$model_files/iterativehmmer_significanthits.output") or die "Couldn't make $model_files/iterativehmmer_significanthits.output; $!";
		
		#foreach my $nhm_line (@nhm_output){
		#	my @nhm_linea=split(/\s+/,$nhm_line);
		#	print WRITE1 "$nhm_linea[0]"; #this needs printed to family scores file
		#}
#
		#close(WRITE1);
		#system("esl-sfetch -f $queryname $model_files/iterativehmmer_significanthits.output >$modelfiles/iterativenhmmer_sigsequences.output");
		

		
		my $thisistheorfthatisthequerysequence=$splitqueryline[0];
		#my @new_ss_output=@ss_output[13..(scalar(@ss_output)-9)]; 


		#END ITERATIVE LOOP HERE WITH 




		my @new_nhm_output=`grep -v \42^#\42 $test_url/$query_modelname.nhmmerit3.tbl`;
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
	
		
		

	}
	####end of loop
	print "\n";

	close(WRITE2);

	# if ($counter==1){
	#last;
	#}

#}

#print "\n";
