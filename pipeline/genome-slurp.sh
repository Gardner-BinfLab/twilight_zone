#!/bin/bash

pattern='./.'
case $1 in 
-h)
	echo -e "Helpful Information.\nThis script is used to slurp all bacterial genomes from the NCBI ftp or https.\nIt requires you to tell it a directory and file name where you want to put the list of FTP url's that are used to slurp the genomes. A great example of what you could use is:\n\t~/Documents/ftp_genomes.txt\nIf you are having trouble running this then please make sure you are\na)\tConnected to the internet\nb)\tHave curl, awk, sed and wget all functionally working on your Linux system (Mac users need to change the -r in sed to -E)"
;;
*)
echo -e "Congratulations, you apparently know what you are doing!\nCOMMENCING THE SLURP..."
curl 'ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt' | \
awk '{FS="\t"} !/^#/ {print $20} ' | \
sed -r 's|(ftp://ftp.ncbi.nlm.nih.gov/genomes/all/.+/)(GCF_.+)|\1\2/\2_genomic.fna.gz|' > $
wget --input $1
wait
echo "Slurping complete, enjoy your genomes!"
esac
