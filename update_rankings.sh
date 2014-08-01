#!/bin/bash

infile="$1"
if [[ ! -r "$infile" ]]
then
	echo "File \"$infile\" not found"
	exit 0
fi

bkdate=$( date +"%Y%m%d_%H%M%S" )
cp rankings rankings.$bkdate

while read winner loser sc1 sc2 ref wpn
do
	ruby cc.rb $winner $loser
	cp rankings.new rankings
done < $infile


