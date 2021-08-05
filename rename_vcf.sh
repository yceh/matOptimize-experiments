#!/usr/bin/bash
#TNT have taxa length restriction and don't like -, this transform taxa name in VCF 
zcat $1 |head -n 3 >$2
zcat $1 |head -n 4|tail -n 1 |less|tr "\t" "\n"|cut -d '|' -f 1|cut -d '/' -f 2|tr "\n-" "\t_" >>$2
echo >>$2
zcat $1 |tail -n +5 >>$2
