# matOptimize-experiments
# Data for 100K-sample tree and 1M-sample tree
  https://doi.org/10.5281/zenodo.6709905

# Run TNT
```
bash benchmark_tnt.sh <directory> <number of processes for parallel sectorial search> <number of processes for parallel TBR move>
```
It expects tnt to be in $PATH, init.fa.gz (FASTA input for TNT), init.nwk (newick input for TNT) and init.vcf.gz (VCF input for matOptimize to compute parsimony score again) in the directory. TNT can be downloaded from http://www.lillo.org.ar/phylogeny/tnt. Only latest versions is available from the website and we couldn't re-distribute the older version we used due to licensing restriction.

The log (tnt_parallel_sect_log) and the newick file (tnt_parallel_sect.nwk) will be in the same folder in the end.

# Run matOptimize
```
mpirun -np <number of processes> --hostfile <hostfile> matOptimize -i <input protobuf> -o <output protobuf> -n -m 0.000001
```
-n is for not dumping protobuf
-m 0.000001 is to keep matOptimize running until no improvement can be done.
hostfile expect one hostname per line, and the same number of lines as <number of processes>.
