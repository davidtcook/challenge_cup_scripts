#!/bin/bash

fencer="$1"
weapon="$2"
datespec="$3"

cat 2014${datespec}* | grep -i "$fencer" | grep -i " $weapon$" | awk '{ 
	win[$1]++;   overall[$1]++;
	lose[$2]++;  overall[$2]++;
	hfor[$1]     = hfor[$1]     + $3;
	hagainst[$1] = hagainst[$1] + $4;
	hfor[$2]     = hfor[$2]     + $4;
	hagainst[$2] = hagainst[$2] + $3;
	scoreline[$3 "-" $4]++;
	refs[$5]++;
}
END {
	for (fen in overall)
	{
		printf("%-15s  Total: %3d  Win: %3d  Lose: %3d  Ratio: %4.2f  For: %d  Agt: %d  Index: %d\n", fen, overall[fen],  win[fen], lose[fen], win[fen]/overall[fen], hfor[fen], hagainst[fen], hfor[fen] - hagainst[fen]);
	}
}' | sort -k9,9nr

