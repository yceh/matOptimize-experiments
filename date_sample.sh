#!/usr/bin/bash
set -e
cd $(dirname $0)
export LD_LIBRARY_PATH=../usher/build/tbb_cmake_build/tbb_cmake_build_subdir_release
SOURCE=data/source
TRANSPOSE_VCF_SRC=$SOURCE/transposed_renamed.pb
SAMPLE_SRC=$SOURCE/sample_rename
TREE_PB_SRC=$SOURCE/public-2021-08-10.all.masked.pb.gz
REF=../usher/test/NC_045512v2.fa
OUTDIR=data/$1

SAMPLE_OUT=$OUTDIR/samples
mkdir -p $OUTDIR
head -n $1 $SAMPLE_SRC > $SAMPLE_OUT
SAMPLE_TEMP=$OUTDIR/sample_temp
PRE_RENAME_TEMP=$OUTDIR/pb_temp
RENAMED_PB_OUT=$OUTDIR/init.pb
cut -f 1 $SAMPLE_OUT > $SAMPLE_TEMP
matUtils extract -i $TREE_PB_SRC -s $SAMPLE_TEMP -o $PRE_RENAME_TEMP &>/dev/null
rm $SAMPLE_TEMP
matUtils mask -i $PRE_RENAME_TEMP -r $SAMPLE_OUT -o $RENAMED_PB_OUT &>/dev/null
rm $PRE_RENAME_TEMP
NWK_OUT=$OUTDIR/init.nwk
matUtils extract -i $RENAMED_PB_OUT -t $NWK_OUT
Rscript TNT_tree.R $NWK_OUT
VCF_OUT=$OUTDIR/init.vcf.gz
FA_OUT=$OUTDIR/init.fa.gz
transposed_vcf_to_vcf -i $TRANSPOSE_VCF_SRC -r $REF -v $VCF_OUT -s $SAMPLE_OUT &
transposed_vcf_to_fa -i $TRANSPOSE_VCF_SRC -o $FA_OUT -s $SAMPLE_OUT -r $REF
wait
