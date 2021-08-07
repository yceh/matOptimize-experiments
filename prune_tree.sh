#!/usr/bin/bash
get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}
DIRNAME=$(dirname $0)
TEMPFILE=$(basename $(mktemp -u $(pwd)/XXXXX))
TEMPFILE2=$(basename $(mktemp -u $(pwd)/XXXXX))
matUtils extract -i $1 -u "$TEMPFILE"
shuf  $TEMPFILE |head -n $2 > $TEMPFILE2
TREENAME=$3.nwk
FANAME=$3.fa
SAMPTABLE=${3}.samples
echo "MN908947.3|Wuhan-Hu-1|19-12-26" >> $TEMPFILE2
matUtils extract -i $1 -s "$TEMPFILE2" -t $TREENAME 
Rscript $DIRNAME/TNT_tree.R $TREENAME $SAMPTABLE
perl $DIRNAME/filter_fasta.pl $SAMPTABLE $4 >$FANAME
faToVcf -ref=MN908947.3 $FANAME ${3}.vcf
rm $TEMPFILE2
rm $TEMPFILE
