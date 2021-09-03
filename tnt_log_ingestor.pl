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
	    $mem_acc=0;
            return 0;
        }
    }
);
my $xss_time;
my $started=0;
sub print_progress{
	if($started==1){
		print("$xss_time\t$_[0]\t0\n");
		print("$xss_time\t$_[0]\t1\n");
		$started=2;
	}elsif($started==2){
        my $elapsed=$last_time-$start_time;
        if($_[0]!=$last_par_score){
            print("$elapsed\t$1\t1\n");
            $last_par_score=$_[0];
        }
	}
}
my $state=0;
open(my $fh,'<',$ARGV[0]);
my $init_par_score=$ARGV[1];
print ("0\t$init_par_score\t1\n");

while (<$fh>){
    if ($_=~/TICKER:start: *(\d+)/){
        $start_time=$1;
    }elsif($_=~/TICKER:/){
        $state=$funcs[$state]->($_);
    }elsif($_=~/jobs lauched (\d+)/){
	print ("$1\t$init_par_score\t0\n");
    }elsif($_=~/xss stage (\d+)/){
	$xss_time=$1;
	$started=1;
    }elsif ($_=~/Totals:.* (\d+) *$/){
	print_progress($1);
    }elsif ($_=~/--.*TBR.*of.* (\d+) * \d+ /){
	print_progress($1);
    }
}
print "max_mem\t $max_mem\n"
