#!/usr/bin/bash
mkfifo temp_fifo
START_TREE=public-2021-08-10.all.masked.pb.gz
matUtils summary -i $START_TREE -s temp_fifo&
cut -f 1 temp_fifo|tail -n +2 |parallel --pipe "sed 's/\(.*|\([^|]*\)\)/\1\t\2/;s=\(.*/\(.*\)|\t$\)=\1\2=;s/\(\t[0-9]\{4\}$\)/\1-99-99/;s/\(\t[0-9]\{4\}-[0-9]\{2\}$\)/\1-99/; s/\t?$/\t99/;'" |shuf|sort -s -k 2 --parallel=40 >date_sorted_samples
awk 'BEGIN {OFS="\t"} {print $1,"s" NR-1}' date_sorted_samples>sample_rename
rm temp_fifo