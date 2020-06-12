for i in batch*obs ; 
    do sed '1,2d' $i |\
    cut -f 2- |\
    awk '{for (i=1;i<=NF;i++){a[i]+=$i;}} END {for (i=1;i<=NF;i++){printf "%.0f", a[i]; printf "\n"};printf "\n"}' |\
    awk '{sum +=$1 }END{print sum }' ; 
done 
