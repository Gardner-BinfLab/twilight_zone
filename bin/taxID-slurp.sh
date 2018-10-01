#!/bin/bash
#Step4
echo "Grep 1 starting..."

grep -f /home/stephmcgimpsey/Documents/accessionsaa /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep -f /home/stephmcgimpsey/Documents/accessionsab /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep -f /home/stephmcgimpsey/Documents/accessionsac /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &  
grep -f /home/stephmcgimpsey/Documents/accessionsad /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &  
grep -f /home/stephmcgimpsey/Documents/accessionsae /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt & 
grep -f /home/stephmcgimpsey/Documents/accessionsaf /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep -f /home/stephmcgimpsey/Documents/accessionsag /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep -f /home/stephmcgimpsey/Documents/accessionsah /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep -f /home/stephmcgimpsey/Documents/accessionsai /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &  
grep -f /home/stephmcgimpsey/Documents/accessionsaj /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &  
grep -f /home/stephmcgimpsey/Documents/accessionsak /home/stephmcgimpsey/Documents/nucl_wgs.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt 

wait
echo "...Grep 1 ended"

#cat /home/stephmcgimpsey/Documents/taxid/taxid_we_need11.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need10.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need9.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need8.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need7.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need6.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need5.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need4.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need3.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need2.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need1.txt >/home/stephmcgimpsey/Documents/taxid/taxid_all1.txt
#wait
#echo "Cat 1 ended"

echo "Grep 2 started..."
grep /home/stephmcgimpsey/Documents/accessionsaa /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsab /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsac /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsad /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsae /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsaf /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsag /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsah /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsai /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsaj /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsak /home/stephmcgimpsey/Documents/nucl_gb.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt 

wait
echo "...Grep 2 ended"

#cat /home/stephmcgimpsey/Documents/taxid/taxid_we_need11.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need10.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need9.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need8.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need7.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need6.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need5.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need4.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need3.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need2.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need1.txt >/home/stephmcgimpsey/Documents/taxid/taxid_all2.txt
#wait
#echo "Cat 2 ended"

echo "Grep 3 started..."
grep /home/stephmcgimpsey/Documents/accessionsaa /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsab /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsac /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsad /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsae /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsaf /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsag /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsah /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsai /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsaj /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsak /home/stephmcgimpsey/Documents/nucl_est.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt 

wait
echo "...Grep 3 ended"

#cat /home/stephmcgimpsey/Documents/taxid/taxid_we_need11.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need10.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need9.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need8.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need7.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need6.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need5.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need4.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need3.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need2.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need1.txt >/home/stephmcgimpsey/Documents/taxid/taxid_all3.txt
#wait
#echo "Cat 3 ended"

echo "Grep 4 started..."
grep /home/stephmcgimpsey/Documents/accessionsaa /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsab /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsac /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsad /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsae /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsaf /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsag /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsah /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsai /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsaj /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt &
grep /home/stephmcgimpsey/Documents/accessionsak /home/stephmcgimpsey/Documents/nucl_gss.accession2taxid >>/home/stephmcgimpsey/Documents/taxid/taxid.txt 

wait
echo "...Grep 4 ended"

#cat /home/stephmcgimpsey/Documents/taxid/taxid_we_need11.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need10.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need9.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need8.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need7.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need6.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need5.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need4.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need3.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need2.txt /home/stephmcgimpsey/Documents/taxid/taxid_we_need1.txt >/home/stephmcgimpsey/Documents/taxid/taxid_all4.txt
#wait
#echo "Cat 4 ended"

cat /home/stephmcgimpsey/Documents/taxid/taxid.txt | perl -lane 'print $F[2]' | awk '!seen[$0] {print} {++seen[$0]}' | sort -n >/home/stephmcgimpsey/Documents/taxid/taxid_ord_unq.txt


