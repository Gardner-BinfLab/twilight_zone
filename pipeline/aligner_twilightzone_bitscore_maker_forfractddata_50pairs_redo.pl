#!/usr/bin/perl
use warnings;
use strict;
use List::Util 'shuffle';



#find /Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models -maxdepth 1 -regex "/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models/.*\-mixedpid\.fasta\.uniq" | parallel -j procfile --eta './aligner_twilightzone_bitscore_maker_forfractddata_50pairs_redo.pl {}'



#!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!
#Paths
my $model_files="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/models";
my $bitscores="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/bs_output2";
my $shuffddb="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/database/shuffled_database_50pairs_redo_fasta.db";
#my $pid_sequences="/media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/new_50_pid_subset";




#!!!!!!!!!!!!!!!!!!!


my $model_fasta=$ARGV[0]; $model_fasta=~s/\.\///; chomp($model_fasta);  # print "$model_fasta\n";
			print "\n$model_fasta\n";
			my $familyname;
		  my @splitdata=split(/\//,$model_fasta);
		my @splitdata1=split(/\-/,$splitdata[-1]);
		$familyname=$splitdata1[0];
print "$splitdata1[0]\n";
#$numberofmodels=$numberofmodels-1; #to tell how many models left

	my $queryname=$model_fasta; chomp($queryname);# the queryname is the same as the file
	my $search_queryname="$familyname-queryseq.fasta.uniq";
	my $writefilename="$bitscores/$familyname.bs_fix2";
	open(WRITE2, ">", "$writefilename") or die "Couldn't make $writefilename; $!";

	#my $counter++;	
	my $test_url="/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/nhm_it_50/database/junk";#transient_dbfile.db
	print "Model running: $familyname\n";
	system("cat $model_fasta $shuffddb >$test_url/$familyname.transient_dbfile.db"); #makes the combined database #normaly $model_files  ###$shuffddb 
	system("makeblastdb -in $test_url/$familyname.transient_dbfile.db -out $test_url/$familyname.transient_dbfile.db.blast -parse_seqids -dbtype nucl >$test_url/junk.txt"); #makes the blast index/reference for the database

	system("esl-sfetch --index $test_url/$familyname.transient_dbfile.db >$test_url/junk.txt"); #indexes the combined database
	my $numseqsinfile=`grep -c \42^>\42 $test_url/$familyname.transient_dbfile.db`; chomp($numseqsinfile); #this line and the one below figure out how many sequences in the combined database
	print "Number of sequences in DB; $numseqsinfile,   ";
	my @numseqsinquery=`grep \42^>\42 $model_files/$search_queryname`;
	my $scalar=scalar(@numseqsinquery); print "Number of query sequences: $scalar\t";
	#my @numseqsinquery=split(/\n/,$numseqsinquery);
	
	
###Loop through '-queryfile sequences here'
	foreach my $queryline (@numseqsinquery){ #basically for each sequence loop through all the searches
		my $nss=0; my$ngg=0; my$nn=0; my $nb=0;


	#need to sfetch for each grep result and write it out to a temporary file to be used as the query file	
		my @splitqueryline=split('\s+',$queryline); $splitqueryline[0]=~s/\>//; ###DOUBLE CHECK THIS SECTION
		print "$splitqueryline[0]\t";
		system("esl-sfetch --index $model_files/$search_queryname >$model_files/junk.txt");
		my $query_filename_trans="$test_url/$familyname.transient_query.fasta";
		system("esl-sfetch $model_files/$search_queryname $splitqueryline[0] >$query_filename_trans");
		
	#print "\n\n";
		 #to make ssearch and ggsearch output smaller

####TIME EACH ALIGNMENT INDIV
###commment in what the flags are and why we used them
	########################ssearch36 -local
		my @ss_output=`/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/fasta36/bin/ssearch36 -f 10 -g 6 -r "+5/-4" -T 3 -E 100000000000 -b 450 -3 -m 3 -n -d 0 -q -H $query_filename_trans $test_url/$familyname.transient_dbfile.db`; 
	#change -E 2 to -E $numseqsinfile
		#print "ss36 done\t";
		#system("esl-reformat -o $model_files/transient_dbfile_fasta.db FASTA $model_files/transient_dbfile.db");
	########################ggsearch36 -glocal
		#my @gg_output=`~/Software/fasta-34.26.5.shar/ssearch34 -f 10 -g 6 -r "+5/-4" -T 8 - E 100 -3 -n -d 0 -q -H $query_filename_trans $test_url/transient_dbfile.db 6`; # - E 100
		# print "ss34 done\t";
	#change -E 2 to -E $numseqsinfile

		#print "@ss_output[7..(scalar(@ss_output)-1)]\n"; ########sort the output into a nice table where the header it is query:seq bitscore ...
		#print "@gg_output\n";
		###

	#########################nhmmer -profile
		my @nhm_output=`nhmmer --tblout $test_url/$familyname.nhmmer.tbl --cpu 3 --toponly --dna --noali -T -100000000000 --F1 0.3 --F2 0.1 --F3 0.003 $query_filename_trans $test_url/$familyname.transient_dbfile.db`;
		#print "@nhm_output\n"; #replaced -T -100000 with -E 100
		#print "nhmmer done \t";
	#########################blastn -heuristic
		my @bl_output=`blastn -gapopen 10 -gapextend 6 -penalty -4 -reward 5 -num_threads 3 -strand plus -task blastn -num_descriptions 450 -evalue 100000000000 -num_alignments 0 -index_name $test_url/$familyname.transient_dbfile.db.ssi -query $query_filename_trans -db $test_url/$familyname.transient_dbfile.db.blast`; #1000000^ eval that I replaced
		#print "@bl_output\n";
		#print "blastn done\n";
my @gg_output=`/Volumes/userdata/staff_groups/gardnerlab/stephmcgimpsey/fasta36/bin/ggsearch36 -f 10 -g 6 -r "+5/-4" -T 3 -E 100000000000 -b 450 -3 -m 3 -n -d 0 -q -H $query_filename_trans $test_url/$familyname.transient_dbfile.db`;
		#print "gg done\t";
		
		

		
	
		

		
		#orf1:orf2-shuffled:s/g/h/b23.5 
		my $thisistheorfthatisthequerysequence=$splitqueryline[0];
		#my @new_ss_output=@ss_output[13..(scalar(@ss_output)-9)]; 
		my @new_ss_output=@ss_output[0..(scalar(@ss_output)-9)]; 
			#print "sssearch\n@new_ss_output";
		foreach my $ssline (@new_ss_output){
			if($ssline=~m/^orf[0-9+]/ | $ssline=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
			my @ssline=split(/\s+/, $ssline);
			print WRITE2 "$thisistheorfthatisthequerysequence:$ssline[0]:$ssline[(scalar(@ssline)-2)]:s:";#this needs printed to family scores file
				if ($ssline[0]=~m/.*shuffled.*/){
					$nss++;
					print WRITE2 "F\n";#this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n";#this needs printed to family scores file
				}
			}
			if($nss>250){

				last;
			}


		}



		

		#print "\ngg\n";
		my @new_gg_output=@gg_output[0..(scalar(@gg_output)-9)];# print "\n\n@new_gg_output\n";
		#print "ggsearch\n@new_gg_output";
		foreach my $ggline (@new_gg_output){
			if($ggline=~m/^orf[0-9+]/ | $ggline=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
			my @ggline=split(/\s+/, $ggline);
			print WRITE2 "$thisistheorfthatisthequerysequence:$ggline[0]:$ggline[(scalar(@ggline)-2)]:g:"; #this needs printed to family scores file
				if ($ggline[0]=~m/.*shuffled.*/){
					$ngg++;
					print WRITE2 "F\n"; #this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n"; #this needs printed to family scores file
				}
			}#
			if($ngg>250){

				last;
			}


		}
		

		my @new_nhm_output=`grep -v "^#" $test_url/$familyname.nhmmer.tbl`;
		#print "nhmmer\n@new_nhm_output";# 
		#open(my $nhmfile, "<", "$model_files/nhmmer.tbl") or die "Can't open $model_files/nhmmer.tbl; $!"; my @new_nhm_output
		
		foreach my $nhm_line (@new_nhm_output){

			my @nhm_linea=split(/\s+/,$nhm_line);
			#print "$nhm_linea[0]\t$nhm_linea[13]\t";
			print WRITE2 "$thisistheorfthatisthequerysequence:$nhm_linea[0]:$nhm_linea[13]:n:"; #this needs printed to family scores file
				if ($nhm_linea[0]=~m/.*shuffled.*/){
					$nn++;
					print WRITE2 "F\n"; #this needs printed to family scores file
				}
				else{
					print WRITE2 "T\n"; #this needs printed to family scores file
				}
			if($nn>250){

				last;
			}
			#last if $steph==2;
			

		}


		#print "BLAST\n@bl_output";
		foreach my $bl_line (@bl_output){
			if($bl_line=~m/^orf[0-9+]/ | $bl_line=~m/^[A-Z]+\_[A-Z,0-9]+.*/){
				my @bl_linea=split(/\s+/,$bl_line);
				print WRITE2 "$thisistheorfthatisthequerysequence:$bl_linea[0]:$bl_linea[(scalar(@bl_linea)-2)]:b:"; #this needs printed to family scores file
				if ($bl_linea[0]=~m/.*shuffled.*/){
						$nb++;
						print WRITE2 "F\n"; #this needs printed to family scores file
					}
					else{
						print WRITE2 "T\n"; #this needs printed to family scores file
					}
			}

			if($nb>250){

				last;
			}

		}
		
		
	#print "\n";
		
	
	}









	####end of loop
	#print "\n";

	close(WRITE2);

	# if ($counter==1){
	#last;
	#}

#}

#print "\n";
