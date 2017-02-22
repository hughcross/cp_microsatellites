#!/usr/bin/env bash

#bash script to loop through derep and swarm

# file with all cluster_list.txt

cat cluster_list2.txt | while read name

do

	filename=$(echo $name | cut -f 1 -d ';')
	newname=$(echo $name | cut -f 2 -d ';')

	echo $filename
	echo $newname

	vsearch -derep_fulllength $filename --sizeout --output derepped_$filename

	swarm -t 4 -z -f -u uclust_$newname\_swarms -w $newname\_swarms.fasta derepped_$filename > /dev/null

	numswarms=$(grep -c '^>' $newname\_swarms.fasta)
	numsingletons=$(grep -c 'size=1;' $newname\_swarms.fasta)
	numbigswarms="$((numswarms - numsingletons))"

	echo $newname ':total swarms:'$numswarms >> swarm_log2.txt

	echo $newname ':no singletons:'$numsingletons >> swarm_log2.txt

	echo $newname ':total wo singletons:'$numbigswarms >> swarm_log2.txt





done

