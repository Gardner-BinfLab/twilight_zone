#!/bin/bash
#Run in Refseq/
cd /media/stephmcgimpsey/GardnerLab-backup1/Refseq/Sequences/pid_sequences/model_files;


for f in *queryseq.fasta; do
	
	sed -e '/^>/s/$/@/' -e 's/^>/#/' $f | tr -d '\n' | tr "#" "\n" | tr "@" "\t" | sort -u -k1,1 | sed -e 's/^/>/' -e 's/\t/\n/' | sed -n '1!p' >$f.uniq
#echo "Done with $f file..";
done
wait ${!};
echo "Query files all sequence uniqued";




