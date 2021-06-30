Comparing various **min. compute sizes** for **CUDA** based PageRank ([pull], [CSR]).

For this experiment, the vertices were **split by components**, and were
joined together until they satisfied a **min. compute size**. Each joined
component is then run through *pagerank compute call*. **Min. compute size**
was varied from `1E+0` to `5E+7`, and pagerank was run 5 times to get a good
time measure. A **min. compute size** of `5E+6` would be a good choice,
similar to [levelwise CUDA].

All outputs are saved in [out](out/) and a small part of the output is listed
here. Some [charts] are also included below, generated from [sheets]. The input
data used for this experiment is available at ["graphs"] (for small ones), and
the [SuiteSparse Matrix Collection].

<br>

```bash
$ nvcc -std=c++17 -Xcompiler -lnvgraph -O3 main.cu
$ ./a.out ~/data/min-1DeadEnd.mtx
$ ./a.out ~/data/min-2SCC.mtx
$ ...

# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00168.072 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00355.320 ms; 051 iters.] [3.1464e-06 err.] pagerankCuda [min-compute-size=1]
# [00359.799 ms; 051 iters.] [3.1664e-06 err.] pagerankCuda [min-compute-size=5]
# [00370.237 ms; 051 iters.] [3.1290e-06 err.] pagerankCuda [min-compute-size=10]
# [00213.362 ms; 051 iters.] [3.0922e-06 err.] pagerankCuda [min-compute-size=50]
# [00194.312 ms; 051 iters.] [3.1552e-06 err.] pagerankCuda [min-compute-size=100]
# [00190.662 ms; 051 iters.] [3.0660e-06 err.] pagerankCuda [min-compute-size=500]
# [00184.615 ms; 051 iters.] [3.0706e-06 err.] pagerankCuda [min-compute-size=1000]
# [00165.183 ms; 051 iters.] [3.1470e-06 err.] pagerankCuda [min-compute-size=5000]
# [00165.696 ms; 051 iters.] [3.1430e-06 err.] pagerankCuda [min-compute-size=10000]
# [00155.293 ms; 051 iters.] [3.2172e-06 err.] pagerankCuda [min-compute-size=50000]
# [00152.922 ms; 051 iters.] [3.1857e-06 err.] pagerankCuda [min-compute-size=100000]
# [00151.506 ms; 051 iters.] [3.1882e-06 err.] pagerankCuda [min-compute-size=500000]
# [00151.525 ms; 051 iters.] [3.1615e-06 err.] pagerankCuda [min-compute-size=1000000]
# [00151.800 ms; 051 iters.] [3.1055e-06 err.] pagerankCuda [min-compute-size=5000000]
# [00151.167 ms; 051 iters.] [3.1055e-06 err.] pagerankCuda [min-compute-size=10000000]
#
# ...
```

[![](https://i.imgur.com/fUfdxKB.gif)][sheets]

<br>
<br>


## References

- [STIC-D: algorithmic techniques for efficient parallel pagerank computation on real-world graphs][STIC-D algorithm]
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](http://snap.stanford.edu/class/cs246-videos-2019/lec9_190205-cs246-720.mp4)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/j3ml4cd.jpg)](https://www.youtube.com/watch?v=4Xw0MrllRfQ)

[STIC-D algorithm]: https://www.slideshare.net/SubhajitSahu/sticd-algorithmic-techniques-for-efficient-parallel-pagerank-computation-on-realworld-graphs
[SuiteSparse Matrix Collection]: https://suitesparse-collection-website.herokuapp.com
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[levelwise CUDA]: https://github.com/puzzlef/pagerank-levelwise-cuda-adjust-compute-size
[charts]: https://photos.app.goo.gl/uFFqJ9NFfe5uxSxx9
[sheets]: https://docs.google.com/spreadsheets/d/1ZFnirMXPX7GFGwLaGKkbqu2f7KiTFPkvRYixq_mUDno/edit?usp=sharing
