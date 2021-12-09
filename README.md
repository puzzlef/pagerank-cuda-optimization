Performance benefit of **CUDA** based PageRank with **vertices split by**
**components** ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find **CUDA** based pagerank **without optimization**.
2. Find **CUDA** based pagerank with vertices **split by components**.
3. Find **CUDA** based pagerank with components **sorted in topological order**.

Each approach was attempted on a number of graphs, running each approach 5
times to get a good time measure. On an few graphs, **splitting vertices by**
**components** provides a **speedup**, but *sorting components in*
*topological order* provides *no additional speedup*. For **road networks**
(and some **web graph**), like `germany_osm` which only have *one component*,
the speedup is possibly because of the *vertex reordering* caused by `dfs()`
which is required for splitting by components. However, **on average** there
is **no speedup**.

All outputs are saved in [out](out/) and a small part of the output is listed
here. Some [charts] are also included below, generated from [sheets]. The input
data used for this experiment is available at ["graphs"] (for small ones), and
the [SuiteSparse Matrix Collection]. This experiment was done with guidance
from [Prof. Dip Sankar Banerjee] and [Prof. Kishore Kothapalli].

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
# [00011.339 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00011.281 ms; 063 iters.] [7.0093e-07 err.] pagerankCuda
# [00010.335 ms; 063 iters.] [7.0114e-07 err.] pagerankCuda [split]
# [00010.381 ms; 063 iters.] [7.0093e-07 err.] pagerankCuda [split; sort]
#
# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00167.890 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00159.698 ms; 051 iters.] [3.1616e-06 err.] pagerankCuda
# [00151.696 ms; 051 iters.] [3.0290e-06 err.] pagerankCuda [split]
# [00151.516 ms; 051 iters.] [3.1139e-06 err.] pagerankCuda [split; sort]
#
# ...
```

[![](https://i.imgur.com/uXlPCB3.png)][sheetp]
[![](https://i.imgur.com/UooLZXJ.png)][sheetp]

<br>
<br>


## References

- [STIC-D: Algorithmic Techniques For Efficient Parallel Pagerank Computation on Real-World Graphs](https://gist.github.com/wolfram77/bb09968cc0e592583c4b180243697d5a)
- [Adjusting PageRank parameters and Comparing results](https://arxiv.org/abs/2108.02997)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/tza58mI.png)](https://www.youtube.com/watch?v=eVvonVlbcFg)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/yVYQcTfbXNejWYjD9
[sheets]: https://docs.google.com/spreadsheets/d/11jNXOQ7ytr4HoFOAD69vjhaU5i3IM2ZmnvPwq5cB_OM/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vSj76IE-B0H56eOvb_MTal8gVAzfYTv_7YpCmmi6B3UplO62Y8Q6NY4fJWq7RBg-IcQ_Dc0CA8kqPuH/pubhtml
