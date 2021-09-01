use List::Util qw(max);
my $mem_acc=0;
my $max_mem=0;
my $last_time;
my $start_time;
my $last_par_score=0;
my @funcs=(
    sub {
        if ($_[0]=~/TICKER:tick_start/){
            return 1;
        }else{
            return 0;
        }
    },
    sub {
        if ($_[0]=~/TICKER:mem: *(\d+)/){
            $mem_acc+=$1;
            return 1;
        }else{
            if($_[0]=~/TICKER:time: *(\d+)/){
                $last_time=$1;
            }
            $max_mem=max($max_mem,$mem_acc);
            return 0;
        }
    }
);
my $state=0;
while (<>){
    if ($_=~/TICKER:start: *(\d+)/){
        $start_time=$1;
    }elsif($_=~/TICKER:/){
        $state=$funcs[$state]->($_);
    }elsif ($_=~/Totals:.* (\d+) *$/){
        my $elapsed=$last_time-$start_time;
        if($1!=$last_par_score){
            print("$elapsed\t$1\n");
            $last_par_score=$1;
        }
    }
}
print "max_mem\t $max_mem\n"