#!/bin/bash


for f in *.nuc.shuf.allaa; 
#do echo "Processing $f file.."; 
do sed -n "/.*:0/,/.*:1/p" $f | perl -lane 'if($F[0]=~m/orf.*-shuffled:1/){}else{$print "$F[0]";};' >$f.tidy; 
done



