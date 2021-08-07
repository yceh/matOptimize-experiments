#!/usr/bin/bash
DIRNAME=$(dirname $0)
bash prune_tree.sh data/source/data.pb 1000 data/selected data/source/renamed.fa
{ time tnt run tnt_no_tree.run data/selected.fa data/tnt_no_tree_out.nwk ';' </dev/null ; } &> data/tnt_no_tree_log &
{ time tnt run tnt_existing_tree.run data/selected.fa data/selected.nwk data/tnt_existing_tree_out.nwk ';' </dev/null ; } &> data/tnt_existing_tree_log &
{ time matOptimize -t data/selected.nwk -v data/selected.vcf -o data/matOptimize_out.pb -n -T 1 -q 10000000 -S 0; } &> data/matOptimize_log &