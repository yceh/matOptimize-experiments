use warnings;
use strict;
my ($matOptimize_log,$tnt_with_tree,$tnt_no_tree)=@ARGV;
my $fh;
open($fh,'<',$matOptimize_log);
my $matOpttime;
my $matOptMem;
my $matOptPar;
my $OriPar;
while(<$fh>){
    $OriPar=$1 if($_=~/after state reassignment:(.*)/);
    $matOptPar=$1 if($_=~/Final Parsimony score (.*)/);
    $matOpttime=$1 if($_=~/^(.*) Elapsed$/);
    $matOptMem=$1 if($_=~/^(.*)k resident/);
}

open($fh,'<',$tnt_with_tree);
my $tnt_with_treetime;
my $tnt_with_treeMem;
my $tnt_with_treePar;
while(<$fh>){
    $tnt_with_treePar=$1 if($_=~/after state reassignment:(.*)/);
    $tnt_with_treetime=$1 if($_=~/^(.*) Elapsed$/);
    $tnt_with_treeMem=$1 if($_=~/^(.*)k resident/);
}

open($fh,'<',$tnt_no_tree);
my $tnt_no_treetime;
my $tnt_no_treeMem;
my $tnt_no_treePar;
while(<$fh>){
    $tnt_no_treePar=$1 if($_=~/after state reassignment:(.*)/);
    $tnt_no_treetime=$1 if($_=~/^(.*) Elapsed$/);
    $tnt_no_treeMem=$1 if($_=~/^(.*)k resident/);
}

print "$OriPar\t$matOpttime\t$matOptMem\t$matOptPar\t$tnt_with_treetime\t$tnt_with_treeMem\t$tnt_with_treePar\t$tnt_no_treetime\t$tnt_no_treeMem\t$tnt_no_treePar\n";