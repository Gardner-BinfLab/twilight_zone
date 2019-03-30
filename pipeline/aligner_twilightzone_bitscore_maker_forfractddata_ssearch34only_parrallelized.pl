#!/usr/bin/perl
use warnings;
use strict;
use List::Util 'shuffle';


######################HAS TO BE RUN AFTER normal aligner has at least gotten to the alignment part of the program as have removed the fasta file making stuff at the start which groups things into their model files




#find /Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models -maxdepth 1 -regex "/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models/.*\-mixedpid\.fasta\.uniq" | parallel -j procfile --eta './aligner_twilightzone_bitscore_maker_forfractddata_ssearch34only_parrallelized.pl {}'

#!!!!!!!!!!!!!!!!!!!!
#Paths
my $model_files="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models";
my $bitscores="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/ssbs_output";
my $shuffddb="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/database/shuffled_database_50pairs_redo_fasta.db";
my $junk ="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/database";





#!!!!!!!!!!!!!!!!!!!


my $counter=0;

#my @findresult_modelfasta=`find $model_files -maxdepth 1 -regex \42.*mixedpid.fasta.uniq\42`;
my $model_fasta=$ARGV[0]; $model_fasta=~s/\.\///; chomp($model_fasta);  # print "$model_fasta\n";
#print "%%%%%%%%%%%%\n@findresult_modelfasta\n%%%%%%%%%%%%%%/n";
#foreach my $model_fasta (@findresult_modelfasta){
	my $queryname=$model_fasta; chomp($queryname);
	my $search_queryname=$queryname;
	$search_queryname=~s/mixedpid/queryseq/g; 
	


	my $query_modelname=$queryname; $query_modelname=~s/\/Volumes\/userdata\/staff_groups\/gardnerlab\/stephmcgimpsey\/nhm_it_50\/models\///;  $query_modelname=~s/\-mixedpid\.fasta\.uniq//;my $db_name_prefix=$query_modelname;

	my $writefilename="$bitscores/$query_modelname.bs.ss34";
	#print "$writefilename\n";
	open(WRITE2, ">", "$writefilename") or die "Couldn't make $writefilename; $!";


	#print "$queryname\n";
	$counter++;	
	my $test_url=$junk;
	print "Model running: $query_modelname\n";
	system("cat $shuffddb $queryname >$test_url/$db_name_prefix.transient_dbfile.db"); #makes the combined database #normaly $model_files
	#system("makeblastdb -in $test_url/transient_dbfile.db -out $test_url/transient_dbfile.db.blast -parse_seqids -dbtype nucl >$test_url/junk.txt"); #makes the blast index/reference for the database



	my $numseqsinfile=`grep -c \42^>\42 $test_url/$db_name_prefix.transient_dbfile.db`; chomp($numseqsinfile); #this line and the one below figure out how many sequences in the combined database
	print "Number of sequences in DB; $numseqsinfile,   ";
	my @numseqsinquery=`grep \42^>\42 $search_queryname`;
	my $scalar=scalar(@numseqsinquery); print "Number of query sequences: $scalar\t";
	#my @numseqsinquery=split(/\n/,$numseqsinquery);
	
	
###Loop through '-queryfile sequences here'
	foreach my $queryline (@numseqsinquery){ #basically for each sequence loop through all the searches



	#need to sfetch for each grep result and write it out to a temporary file to be used as the query file	
		my @splitqueryline=split('\s+',$queryline); $splitqueryline[0]=~s/\>//; ###DOUBLE CHECK THIS SECTION
		print "$splitqueryline[0]\t";
		#open(TEST,"echo \42YES\42 |"); my @test=<TEST>; print "$test[0]\n";
		system("esl-sfetch --index $search_queryname >$test_url/junk.txt");
		my $query_filename_trans="$test_url/$db_name_prefix.transient_query.fasta";

		#print "$search_queryname\t$splitqueryline[0]\n";
		system("esl-sfetch $search_queryname $splitqueryline[0] >$query_filename_trans");
		
	#print "\n\n";
		 #to make ssearch and ggsearch output smaller

####TIME EACH ALIGNMENT INDIV
###commment in what the flags are and why we used them

		#print "ss36 done\t";
		#system("esl-reformat -o $model_files/transient_dbfile_fasta.db FASTA $model_files/transient_dbfile.db");
	########################ggsearch36 -glocal
############
		
	#change -E 2 to -E $numseqsinfile


		####### ssearch OLD
		#open(SSOUTPUT,"~/Software/fasta-34.26.5.shar/ssearch34 -f 10 -g 6 -r \42+5/-4\42 -T 8 - E 100 -3 -n -d 0 -q -H $query_filename_trans $test_url/transient_dbfile.db 6 |") or die "Can't do the ssearch34 cause...\n $!"; my @ss_output=<SSOUTPUT>;
		
		my @ss_output=`/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/fasta-34.26.5.shar/ssearch34 -f 10 -g 6 -T 1 -r "+5/-4" -b 1000 -3 -n -d 0 -q -H $query_filename_trans $test_url/$db_name_prefix.transient_dbfile.db`; # - E 100
		print "ss34 done\t";
		
		my $thisistheorfthatisthequerysequence=$splitqueryline[0];
		#my @new_ss_output=@ss_output[13..(scalar(@ss_output)-9)]; 
		my @new_ss_output=@ss_output[0..(scalar(@ss_output)-9)]; 
		foreach my $ssline (@new_ss_output){
			if($ssline=~m/^orf[0-9+]/ | $ssline=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
			my @ssline=split(/\s+/, $ssline);
			print WRITE2 "$thisistheorfthatisthequerysequence:$ssline[0]:$ssline[(scalar(@ssline)-2)]:ss34:";#this needs printed to family scores file
				if ($ssline[0]=~m/.*shuffled.*/){
					print WRITE2 "F\n";#this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n";#this needs printed to family scores file
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

#}

#print "\n";
system("rm $test_url/$db_name_prefix.transient_query.fasta");
system("rm $test_url/$db_name_prefix.transient_dbfile.db");
