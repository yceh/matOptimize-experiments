use warnings;
use strict;
my %samples;
open(my $fh,'<',$ARGV[0]);
while(<$fh>){
    chomp;
    $samples{$_}=1;
}
open($fh,'<',$ARGV[1]);
my @header_fileds;
while(<$fh>){
    if($_=~/^#CHROM/){
        @header_fileds=split /\t/,$_;
        last;
    }
}
print '1-9';
my $idx=1;
for (@header_fileds){
    if($samples{$_}){
        print ",$idx";
    }
    $idx++;
}