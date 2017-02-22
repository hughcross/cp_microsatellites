#!/bin/bash


#script to align and determine average distances

for x in consensus_*

do 

y=${x%.*}
y=${y#*_}
#c=${y##*_}

echo $x
echo $y

t_coffee $x

t_coffee -other_pg seq_reformat -in $y\.aln -output sim > dist_$y\.txt

grep "TOT" dist_$y\.txt | awk '{print "'$y' " $4}' >> ccmp2_sum_dists.txt


done

 