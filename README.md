Performance benefit of **CUDA** based PageRank with **vertices split by**
**components** ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find **CUDA** based PageRank **without optimization**.
2. Find **CUDA** based PageRank with vertices **split by components**.
3. Find **CUDA** based PageRank with components **sorted in topological order**.

For this experiment, the vertices were kept as is (*default*), **split by
components** (*split*), or additionally **sorted in topological order**
(*split+sort*). Small components were joined together until they satisfied a
**min. compute size**. Each joined component is then run through *PageRank
compute call*. **Min. compute size** was varied from `1E+0` to `5E+7`, and
PageRank was run 5 times to get a good time measure. From both from GM and AM
execution times, it is observed that with a low *min compute*, the time taken
for PageRank computation is significantly high (for both *split*, and
*split+sort*). This is likely because with a lot of small components, a large
number of kernel calls have to be made, which is expensive business. As *min
compute* is increased, PageRank computation time drops, and seems to stabilize
at a **min compute** of `1E+7` to `5E+7`. With respect to **GM-RATIO**, both
*split* and *split+sort* complete in **7% less time (1.08x)** compared to
default approach (no components). Write respect to **AM-RATIO**, *split*
completes in **6% less time (1.06x)**, and *split+sort* completes in **7% less
time (1.08x)** compared to default approach. This is the case for *min compute*
of *1E+7* or *5E+7*.

On a few graphs, **splitting vertices by components** provides a **speedup**,
but *sorting components in topological order* provides *no additional speedup*.
For **road networks** (and some **collaboration networks**), like `germany_osm`
which only have *one component*, the speedup is possibly because of the *vertex
reordering* caused by `dfs()` which is required for splitting by components.
However, **on average** there is a **small speedup**. Although it was observed
[here] that splitting by components can provide memory locality benefits through
better cache utilization, it appears that the cost of increased kernel calls is
significant. It is important to note here that in order to reduce work imbalance
between threads of the GPU, vertices are partitioned by degree.

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
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00167.675 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00158.358 ms; 051 iters.] [3.1615e-06 err.] pagerankCuda
# [00352.375 ms; 051 iters.] [3.0248e-06 err.] pagerankCudaSplit [min-compute=1]
# [00359.356 ms; 051 iters.] [3.0147e-06 err.] pagerankCudaSplit [min-compute=5]
# [00369.774 ms; 051 iters.] [3.0311e-06 err.] pagerankCudaSplit [min-compute=10]
# [00214.048 ms; 051 iters.] [3.0474e-06 err.] pagerankCudaSplit [min-compute=50]
# [00192.967 ms; 051 iters.] [3.0905e-06 err.] pagerankCudaSplit [min-compute=100]
# [00190.474 ms; 051 iters.] [3.0432e-06 err.] pagerankCudaSplit [min-compute=500]
# [00184.505 ms; 051 iters.] [3.0680e-06 err.] pagerankCudaSplit [min-compute=1000]
# [00165.933 ms; 051 iters.] [3.0745e-06 err.] pagerankCudaSplit [min-compute=5000]
# [00164.883 ms; 051 iters.] [3.0696e-06 err.] pagerankCudaSplit [min-compute=10000]
# [00155.632 ms; 051 iters.] [3.0847e-06 err.] pagerankCudaSplit [min-compute=50000]
# [00152.888 ms; 051 iters.] [3.0732e-06 err.] pagerankCudaSplit [min-compute=100000]
# [00152.084 ms; 051 iters.] [3.0786e-06 err.] pagerankCudaSplit [min-compute=500000]
# [00151.485 ms; 051 iters.] [3.0290e-06 err.] pagerankCudaSplit [min-compute=1000000]
# [00150.983 ms; 051 iters.] [3.1235e-06 err.] pagerankCudaSplit [min-compute=5000000]
# [00150.956 ms; 051 iters.] [3.1235e-06 err.] pagerankCudaSplit [min-compute=10000000]
# [00151.483 ms; 051 iters.] [3.1235e-06 err.] pagerankCudaSplit [min-compute=50000000]
# [00353.937 ms; 051 iters.] [3.1245e-06 err.] pagerankCudaSplitSort [min-compute=1]
# [00361.089 ms; 051 iters.] [3.1245e-06 err.] pagerankCudaSplitSort [min-compute=5]
# [00369.366 ms; 051 iters.] [3.1128e-06 err.] pagerankCudaSplitSort [min-compute=10]
# [00232.066 ms; 051 iters.] [3.1088e-06 err.] pagerankCudaSplitSort [min-compute=50]
# [00208.907 ms; 051 iters.] [3.1771e-06 err.] pagerankCudaSplitSort [min-compute=100]
# [00221.725 ms; 051 iters.] [3.1950e-06 err.] pagerankCudaSplitSort [min-compute=500]
# [00204.021 ms; 051 iters.] [3.1739e-06 err.] pagerankCudaSplitSort [min-compute=1000]
# [00175.499 ms; 051 iters.] [3.1493e-06 err.] pagerankCudaSplitSort [min-compute=5000]
# [00169.683 ms; 051 iters.] [3.1197e-06 err.] pagerankCudaSplitSort [min-compute=10000]
# [00158.064 ms; 051 iters.] [3.0843e-06 err.] pagerankCudaSplitSort [min-compute=50000]
# [00154.033 ms; 051 iters.] [3.1045e-06 err.] pagerankCudaSplitSort [min-compute=100000]
# [00151.808 ms; 051 iters.] [3.1468e-06 err.] pagerankCudaSplitSort [min-compute=500000]
# [00151.590 ms; 051 iters.] [3.1139e-06 err.] pagerankCudaSplitSort [min-compute=1000000]
# [00151.324 ms; 051 iters.] [3.0990e-06 err.] pagerankCudaSplitSort [min-compute=5000000]
# [00151.403 ms; 051 iters.] [3.0990e-06 err.] pagerankCudaSplitSort [min-compute=10000000]
# [00151.074 ms; 051 iters.] [3.0990e-06 err.] pagerankCudaSplitSort [min-compute=50000000]
#
# ...
```

[![](https://i.imgur.com/ln3gWSI.gif)][sheetp]
[![](https://i.imgur.com/01SMSvK.png)][sheetp]
[![](https://i.imgur.com/oPzKwJH.png)][sheetp]
[![](https://i.imgur.com/G5yaIo5.png)][sheetp]
[![](https://i.imgur.com/JUiwhFb.png)][sheetp]

<br>
<br>


## References

- [STIC-D: Algorithmic Techniques For Efficient Parallel Pagerank Computation on Real-World Graphs](https://gist.github.com/wolfram77/bb09968cc0e592583c4b180243697d5a)
- [Adjusting PageRank parameters and Comparing results](https://arxiv.org/abs/2108.02997)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/TSKFNzd.png)](https://www.youtube.com/watch?v=eVvonVlbcFg)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/yVYQcTfbXNejWYjD9
[sheets]: https://docs.google.com/spreadsheets/d/11jNXOQ7ytr4HoFOAD69vjhaU5i3IM2ZmnvPwq5cB_OM/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vSj76IE-B0H56eOvb_MTal8gVAzfYTv_7YpCmmi6B3UplO62Y8Q6NY4fJWq7RBg-IcQ_Dc0CA8kqPuH/pubhtml
