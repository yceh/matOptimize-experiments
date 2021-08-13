#!/usr/bin/bash
DIRNAME=$(dirname $0)
shopt -s expand_aliases
alias time="/usr/bin/time -f '\n%e Elapsed\n%Mk resident'"
pushd DIRNAME
source prune_tree.sh
PREFIX=data/$1
VCF_PATH=$PREFIX.vcf
FA_PATH=$PREFIX.fa
SAMPLE_PATH=$PREFIX.sample
TREE_PATH=$PREFIX.nwk
prune_tree data/source/data.pb $1 data/source/renamed.fa $TREE_PATH $FA_PATH $SAMPLE_PATH $VCF_PATH
{ 
  TNTTREE=${PREFIX}_tnt_no_tree_out.nwk
  time tnt run tnt_no_tree.run $FA_PATH $TNTTREE ';' </dev/null ;
  sed -i 's/ //g' $TNTTREE
  matOptimize -t $TNTTREE -v $VCF_PATH -o /dev/null -n -r 0 
} &> ${PREFIX}_tnt_no_tree_log &
{ 
  TNTTREE=${PREFIX}_tnt_existing_tree_out.nwk
  time tnt run tnt_existing_tree.run $FA_PATH $TREE_PATH $TNTTREE ';' </dev/null ;
  sed -i 's/ //g' $TNTTREE
  matOptimize -t $TNTTREE -v $VCF_PATH -o /dev/null -n -r 0 
} &> ${PREFIX}_tnt_existing_tree_log &
{ time matOptimize -t $TREE_PATH -v $VCF_PATH -o ${PREFIX}_matoptimize_out.pb -n -T 1 -q 10000000 -s 0; } &> ${PREFIX}_matOptimize_log &
wait
perl log_greper.pl ${PREFIX}_matOptimize_log ${PREFIX}_tnt_existing_tree_log ${PREFIX}_tnt_no_tree_log