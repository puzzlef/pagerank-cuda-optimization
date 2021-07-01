Performance benefit of **CUDA** based PageRank with **vertices split by**
**components** ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find **CUDA** based pagerank **without optimization**.
2. Find **CUDA** based pagerank with vertices **split by components**.
3. Find **CUDA** based pagerank with components **sorted in topological order**.

Each approach was attempted on a number of graphs, running each approach 5
times to get a good time measure. On an few graphs, **splitting vertices by**
**components** provides a **speedup**, but *sorting components in*
*topological order* provides *no additional speedup*. For road networks, like
`germany_osm` which only have *one component*, the speedup is possibly because
of the *vertex reordering* caused by `dfs()` which is required for splitting
by components. However, **on average** there is **no speedup**.

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
# Loading graph /home/subhajit/data/web-Stanford.mtx ...
# order: 281903 size: 2312497 {}
# order: 281903 size: 2312497 {} (transposeWithDegree)
# [00011.391 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00011.144 ms; 063 iters.] [7.0093e-07 err.] pagerankCuda
# [00010.209 ms; 063 iters.] [7.0114e-07 err.] pagerankCuda [split]
# [00010.585 ms; 063 iters.] [7.0093e-07 err.] pagerankCuda [split; sort]
#
# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00168.505 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00159.829 ms; 051 iters.] [3.2208e-06 err.] pagerankCuda
# [00151.128 ms; 051 iters.] [3.1055e-06 err.] pagerankCuda [split]
# [00151.501 ms; 051 iters.] [3.3554e-06 err.] pagerankCuda [split; sort]
#
# ...
```

[![](https://i.imgur.com/HzHSUwU.png)][sheets]
[![](https://i.imgur.com/JA1yqWM.png)][sheets]

<br>
<br>


## References

- [STIC-D: algorithmic techniques for efficient parallel pagerank computation on real-world graphs][STIC-D algorithm]
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](http://snap.stanford.edu/class/cs246-videos-2019/lec9_190205-cs246-720.mp4)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/tza58mI.png)](https://www.youtube.com/watch?v=eVvonVlbcFg)

[STIC-D algorithm]: https://www.slideshare.net/SubhajitSahu/sticd-algorithmic-techniques-for-efficient-parallel-pagerank-computation-on-realworld-graphs
[SuiteSparse Matrix Collection]: https://suitesparse-collection-website.herokuapp.com
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/yVYQcTfbXNejWYjD9
[sheets]: https://docs.google.com/spreadsheets/d/1MPdNRJ_qJwLPverpRoxmGcghXNvwXEKCRg00Enea72E/edit?usp=sharing
