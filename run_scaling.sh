set -xve
set -o pipefail
function prep() {
echo matoptimize-mpi-main > hostfile
for i in `seq 1 $1 `
do echo matoptimize-mpi-$i >> hostfile
done
for i in ` seq $2 $3 `
do gcloud compute instances delete  matoptimize-mpi-$i --zone=us-west1-b -q  &
done
wait
}
{ /usr/bin/time mpirun -np 32 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o warmup.pb -r 8 -N 1 -m 0 -n ; } &> warmup.log
{ /usr/bin/time mpirun -np 32 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o strong_32.pb -m 0 -r 1024 -N 6 -n ; } &> strong_32.log
prep 15 16 31
{ /usr/bin/time mpirun -np 16 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o weak_16.pb -z 0.5 -m 0 -r 1024 -N 6 -n ; } &> weak16.log
{ /usr/bin/time mpirun -np 16 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o strong_16.pb -r 1024 -m 0 -N 6 -n ; } &> strong16.log
prep 7 8 15
{ /usr/bin/time mpirun -np 8 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o weak_8.pb -z 0.25 -r 1024 -m 0 -N 6 -n ; } &> weak8.log
{ /usr/bin/time mpirun -np 8 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o strong_8.pb -r 1024 -N 6 -n -m 0 ; } &> strong8.log
prep 3 4 7
{ /usr/bin/time mpirun -np 4 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o weak_4.pb -z 0.125 -r 1024 -N 6 -n -m 0 ; } &> weak4.log
{ /usr/bin/time mpirun -np 4 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o strong_4pb -r 1024 -N 6 -n -m 0 ; } &> strong4.log
prep 1 2 3
{ /usr/bin/time mpirun -np 2 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o weak_2.pb -z 0.0625  -r 1024 -N 6 -n -m 0 ; } &> weak2.log
{ /usr/bin/time mpirun -np 2 --hostfile hostfile usher/build/matOptimize -a  starter_intermediate.pb -o strong_2.pb  -r 1024 -N 6 -n -m 0 ; } &> strong2.log
gcloud compute instances delete  matoptimize-mpi-1 --zone=us-west1-b -q
sudo shutdown +0
