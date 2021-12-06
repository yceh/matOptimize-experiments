use warnings;
use strict;
my $last_radius=2;
my $last_time;
my $last_score;
print "radius\tparsimony\ttime\n";
while(<>){
	if($_=~/parsimony score after optimizing: (\d+),with radius (\d+), second from start (\d+)/){
		my $new_radius=$2;
		if($new_radius>$last_radius){
			print "$last_radius\t$last_score\t$last_time\n";
		}
		$last_radius=$new_radius;
		$last_time=$3;
		$last_score=$1;
	}
}
print "$last_radius\t$last_score\t$last_time\n";
