# matOptimize-experiments
# Data for 100K-sample tree and 1M-sample tree
  https://doi.org/10.5281/zenodo.6709905

# Run TNT
```
bash benchmark_tnt.sh <folder>
```
It expects tnt to be in $PATH. TNT can be obtained from http://www.lillo.org.ar/phylogeny/tnt. Only latest versions from the website and we couldn't distribute the version we used due to licensing restriction.
It also expect init.fa.gz (FASTA input for TNT), init.nwk (newick input for TNT) and init.vcf.gz (VCF input for matOptimize to compute parsimony score again).

# Run matOptimize
```
mpirun -np <number of processes> --hostfile <hostfile> matOptimize -i <input protobuf> -o <output protobuf> -n -m 0.000001
```
-n is for not dumping protobuf
-m 0.000001 is to keep matOptimize running until no improvement can be done.
hostfile expect one hostname per line, and the same number of lines as <number of processes>.
