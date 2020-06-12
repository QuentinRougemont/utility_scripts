#!/bin/bash

#utility script to split a file into several file each time a specific pattern is found
#see man csplit for more info...

input=$1   #input file  
pref=$2    #prefix to use for each new output
match=$3   #pattern to march in input file

#example:
#csplit --suppress-matched --prefix LG --suffix-format %02d map '/LG = /' '{*}
#will split input file (here a linkage map from lepmap3 each time the pattern LG occurs
#each new file will have the prefix LG

csplit --suppress-matched --prefix "$pref" --suffix-format %02d "$input" '/$match/' '{*}

