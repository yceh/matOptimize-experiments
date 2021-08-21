#!/usr/bin/bash
set -e
TERM=linux
cd $(dirname $0)
export LD_LIBRARY_PATH=../usher/build/tbb_cmake_build/tbb_cmake_build_subdir_release
shopt -s expand_aliases
alias time="/usr/bin/time -f '\n%e Elapsed\n%Mk resident\n%U user\n%S sys'"
VCF_PATH=$1/init.vcf.gz
FA_PATH=$1/init.fa.gz
TREE_PATH=$1/init.nwk
runtnt()
{ 
  TNTTREE=$1
  time tnt run $2 $3 $TREE_PATH  $TNTTREE ';' </dev/null ;
  sed -i 's/ //g' $TNTTREE
  matOptimize -t $TNTTREE -v $VCF_PATH -o /dev/null -n -r 0 
}
FA1=$1/fa1
rm -f $FA1
mkfifo $FA1
#zcat $FA_PATH|tee $FA1 >$FA2 &
zcat $FA_PATH > $FA1 &
runtnt $1/tnt_parallel_sect.nwk tnt_parallel_sect.run $FA1 &> $1/tnt_parallel_sect_log &
# { time matOptimize -t $TREE_PATH -v $VCF_PATH -o $1/matoptimize_out.pb -n -T 40 -q 10000000 -s 0 -r 20 -d 1; } &> $1/matOptimize_log &
wait
rm $FA1
#perl log_greper.pl $1/matOptimize_log $1/tnt_rss_log $1/tnt_xss_log 
