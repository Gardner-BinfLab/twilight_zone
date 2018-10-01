#!/bin/bash
#Run in Refseq/
cd /media/stephmcgimpsey/GardnerLab-backup1/Refseq/;

for f in *.tRNA; do
	
	cat $f | perl -lane '$F[0]=~s/\(//g;$F[0]=~s/\)//g;$F[4]=~s/\(//g;$F[4]=~s/\)//g; $name="$F[0]_$F[1]_$F[2]-$F[3]_$F[4]_$F[5]_$F[6]"; system("esl-sfetch -c $F[2]-$F[3] -n $name genome_subset_genus_specific.fasta $F[1]");' >/media/stephmcgimpsey/GardnerLab-backup1/Refseq/tRNA_seqs/subset_genus_nucleotide_combined.$f
echo "Done with $f file..";
done
wait ${!};
echo "tRNA individual done";
