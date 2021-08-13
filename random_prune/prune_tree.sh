#!/usr/bin/bash
get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}
prune_tree(){
OUTDIR=$(dirname $(realpath $3 ))
DIRNAME=$(dirname $(realpath $BASH_SOURCE) )
TEMPFILE=$(basename $(mktemp -u $OUTDIR/XXXXX))
TEMPFILE2=$(basename $(mktemp -u $OUTDIR/XXXXX))
matUtils extract -i $1 -u "$TEMPFILE"
shuf --random-source=<(get_seeded_random 0 ) $TEMPFILE |head -n $2 > $TEMPFILE2
TREENAME=$4
FANAME=$5
SAMPTABLE=$6
echo "MN908947.3|Wuhan-Hu-1|19-12-26" >> $TEMPFILE2
matUtils extract -i $1 -s "$TEMPFILE2" -t $TREENAME 
Rscript $DIRNAME/TNT_tree.R $TREENAME $SAMPTABLE
perl $DIRNAME/filter_fasta.pl $SAMPTABLE $3 >$FANAME
faToVcf -ref=MN908947.3 $FANAME $7
rm $TEMPFILE2
rm $TEMPFILE
}
if [ $0 == "prune_tree.sh" ]
then prune_tree $1 $2 $4 $3.nwk $3.fa $3.samples $3.vcf
fi