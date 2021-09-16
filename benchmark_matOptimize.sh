#!/usr/bin/bash
TIME=24
if [ $# -eq 2 ]
then
	TIME=$2
fi
set -e
TERM=linux
cd $(dirname $0)
shopt -s expand_aliases
alias time="/usr/bin/time -f '\n%e Elapsed\n%Mk resident\n%U user\n%S sys'"
VCF_PATH=$1/init.vcf.gz
TREE_PATH=$1/init.nwk
{ time matOptimize -t $TREE_PATH -v $VCF_PATH -o $1/matOptimize_out.pb -n -M $TIME; } &> $1/matOptimize_log
