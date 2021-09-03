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
  time tnt run $2 $3 $TREE_PATH  $TNTTREE $4 $5 ';' </dev/null 
  sed -i 's/ //g' $TNTTREE
  matOptimize -t $TNTTREE -v $VCF_PATH -o /dev/null -n -r 0 -T 20 
}
FA1=$1/fa1
rm -f $FA1
mkfifo $FA1
#zcat $FA_PATH|tee $FA1 >$FA2 &
zcat $FA_PATH > $FA1 &
echo  >  $1/tnt_parallel_sect_log 
bash ticker.sh >>  $1/tnt_parallel_sect_log &
TICKER_PID=$!
runtnt $1/tnt_parallel_sect.nwk tnt_parallel_sect.run $FA1 $2 $3 2>&1 | stdbuf -oL -eL tr "\r" "\n" >>  $1/tnt_parallel_sect_log
kill $TICKER_PID
rm $FA1
