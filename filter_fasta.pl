use warnings;
use strict;
#Only print samples that appear in the first file from the fasta file (second)
my %samples;
open(my $fh,'<',$ARGV[0]);
while(<$fh>){
    chomp;
    $samples{$_}=1;
}
my $matched=0;
open($fh,'<',$ARGV[1]);
while(<$fh>){
    if($_=~/^>(.*)$/){
        $matched=$samples{$1};
    }
    if($matched){
        print  $_;
    }
}
