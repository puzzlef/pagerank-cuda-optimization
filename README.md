Performance benefit of **skipping in-identical vertices** for **CUDA** based
PageRank ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find pagerank **without optimization**.
2. Find pagerank **skipping rank calculation of in-identical vertices**.

Each approach was attempted on a number of graphs, running each approach 5
times to get a good time measure. On `indochina-2004` graph, **skipping**
**in-identicals** provides a **speedup** of `~1.3`, but on average provides
*no speedup* for other graphs. This could be due to the fact that the graph
`indochina-2004` has a large number of **inidenticals** and **inidentical**
**groups**. Although, it doesnt have the highest **inidentials %** or the
highest **avg. inidentical group size**, so i am not so sure.

All outputs are saved in [out](out/) and a small part of the output is listed
here. Some [charts] are to be included below, generated from [sheets]. The input
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
# inidenticals: 80096 inidentical-groups: 13684 {}
# [00012.125 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00011.352 ms; 063 iters.] [7.0093e-07 err.] pagerankCuda
# [00018.499 ms; 063 iters.] [7.0093e-07 err.] pagerankCuda [skip]
#
# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# inidenticals: 556210 inidentical-groups: 203669 {}
# [00168.124 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00158.059 ms; 051 iters.] [3.2208e-06 err.] pagerankCuda
# [00166.893 ms; 051 iters.] [3.2467e-06 err.] pagerankCuda [skip]
#
# ...
```

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
[charts]: https://www.example.com
[sheets]: https://www.example.com
