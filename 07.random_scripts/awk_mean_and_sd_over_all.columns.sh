#!/bin/bash

#compute mean and standard deviation over a matrix file 
#output: 2 colomns file with mean\sd for each colomns of the file

awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}}
           END {for (i=1;i<=NF;i++) {
           printf "%f %f \n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR)}
          }' file
