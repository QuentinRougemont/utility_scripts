
#playing to compute mean and sd on 3rd column of a dataset with a header:
mean=$(sed 1d file |awk '{sum +=$3}END{print sum / NR }' )
sd=$(sed 1d file |\
    awk '{delta = $3 - avg; avg += delta / NR; mean2 += delta * ($3 - avg); }
    END { print sqrt(mean2 / (NR-1)); }' )

echo mean is $mean
echo sd is $sd 
