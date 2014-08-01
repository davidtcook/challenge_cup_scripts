#!/bin/bash

echo "Total bouts fenced: $( cat 2014* | wc -l )"
echo ""
cat 2014* | awk '{ wpns[$6]++; }
END {
	for (wpn in wpns)
	{
		printf("%s: %s bouts\n", wpn, wpns[wpn]);
	}
}'

cat 2014* | awk '{ 
	win[$1]++;   overall[$1]++;
	lose[$2]++;  overall[$2]++;
	scoreline[$3 "-" $4]++;
	refs[$5]++;
}
END {
	for (fen in overall)
	{
		printf("%-15s  Total: %3d  Win: %3d  Lose: %3d  Ratio: %4.2f\n", fen, overall[fen],  win[fen], lose[fen], win[fen]/overall[fen]);
	}
}' | sort -k9,9nr

echo ""
cat 2014* | awk '{ win[$1]++; lose[$2]++; overall[$1]++; overall[$2]++; scoreline[$3 "-" $4]++; refs[$5]++ }
END {
	for (ref in refs)
	{
		printf("%-15s  Total reffed: %3d \n", ref, refs[ref]);
	}
}' | sort -k4,4nr

echo ""
cat 2014* | awk '{ win[$1]++; lose[$2]++; overall[$1]++; overall[$2]++; scoreline[$3 "-" $4]++; refs[$5]++ }
END {
	for (score in scoreline)
	{
		printf("%8s: %4d\n", score, scoreline[score]);
	}
}' | sort -k2,2nr

echo "Fencer involvement in bouts (fencing + reffing)"
cat 2014* | awk '{ parti[$1]++; parti[$2]++; parti[$5]++ }
END {
	for (fen in parti)
	{
		printf("%-15s: %4d\n", fen, parti[fen]);
	}
}' | sort -k3,3nr

