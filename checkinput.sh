#!/bin/bash

if [[ $# -ne 1 ]]
then
	echo "Usage: checkinput.sh <input file>"
	exit 0
fi

line=1
filelist=( 2* )
nfiles=${#filelist[*]}
i=0
while (( i < nfiles ))
do
	if [[ ${filelist[i]} = "$1" ]]
	then
		unset filelist[i]
		continue
	fi
	(( i = i + 1 ))
done

while read winner loser sc1 sc2 ref wpn
do
	if ! grep -q $winner ${filelist[*]}
	then
		echo "Line $line $winner is new"
	fi
	if ! grep -q $loser ${filelist[*]}
	then
		echo "Line $line $loser is new"
	fi
	if ! grep -q $ref ${filelist[*]}
	then
		echo "Line $line $ref is new"
	fi
	case $wpn in
	"E" | "F" | "S" ) ;;
	*               ) echo "Line $line bad weapon $wpn" ;;
	esac
	(( line = line + 1 ))
done < $1
