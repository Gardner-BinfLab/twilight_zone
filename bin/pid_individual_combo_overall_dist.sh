#!/bin/bash
#Run in Documents
cd /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output;

for f in *.1alipid; do
	echo "Processing $f file..";
	cat $f | grep -v ^"#" | perl -lane 'print"$F[2]";' | sort -n | uniq -c >$f.counts;
done
wait ${!};
echo "ncRNA individual done";


find . -regex ".*\.1alipid" | xargs -ifoo cat foo | grep -v ^"#"| perl -lane 'print "$F[2]"' >all_ncRNA_pid.rawcounts;
cat all_ncRNA_pid.rawcounts | sort -n | uniq -c >all_ncRNA_pid.counts;
wait ${!};
echo "ncRNA combo done";






cd /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/hmmalign_output;

for f in *.1alipidnuc; do
	echo "Processing $f file.."; 
	cat $f | grep -v ^"#"| perl -lane 'print"$F[2]";' | sort -n | uniq -c >$f.counts;
done
wait ${!};
echo "mRNA individual done";


find . -regex ".*\.1alipidnuc"  | xargs -ifoo cat foo | grep -v ^"#"|  perl -lane 'print"$F[2]";' >all_mRNA_pid.rawcounts;
cat all_mRNA_pid.rawcounts | sort -n | uniq -c >all_mRNA_pid.counts;
wait ${!};
echo "mRNA combo done";





cd /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences;

cat /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/hmmalign_output/all_mRNA_pid.rawcounts /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/cmalign_output/all_ncRNA_pid.rawcounts | sort -n | uniq -c >all_mRNA_ncRNA_pid.counts
wait ${!};
echo "ncRNA & mRNA combo done";
