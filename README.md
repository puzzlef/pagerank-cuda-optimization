Performance benefit of **skipping in-identical vertices** for **CUDA** based
PageRank ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find PageRank **without optimization**.
2. Find PageRank **skipping rank calculation of in-identical vertices**.

Each approach was attempted on a number of graphs, running each approach 5 times
to get a good time measure. The minimum size of *in-identical groups* is varied
from 2-256, with 2 being the default (`skip2`), and the best among them is also
picked (`skipbest`). It seems **skipping all in-identicals** *(skip2)* and
**skipping in-identicals with best group size or more** *(skipbest)* **decrease
execution time by -9 to 26%**, when compared to no optimization. This speedup is
mainly observed on `indochina-2004`, and hardly any on the other graphs. This
speedup could be due to the fact that the graph `indochina-2004` has a large
number of **in-identicals** and **in-identical groups**, although it doesn't
have the highest **in-identicals %** or the highest **avg. in-identical group
size**. With respect to **GM-RATIO**, *skipping in-identicals (skip2)* completes
in **3% more time (0.97x)**, and *skipping best in-identicals (skipbest)*
completes in **1% more time (0.99x)**, than using default approach. With respect
to **AM-RATIO**, *skipping in-identicals (skip2)* completes in **1% less time
(1.01x)**, and *skipping best in-identicals (skipbest)* completes in **2% less
time (1.02x)**, than using default approach. It therefore makes sense to apply
this optimization only when the graph has a large number of in-identicals.

All outputs are saved in [out](out/) and a small part of the output is listed
here. Some [charts] are to be included below, generated from [sheets]. The input
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
# [00011.356 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda
# [00011.487 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=002; inidenticals=00100411; inidentical-groups=00013685]
# [00011.480 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=004; inidenticals=00081602; inidentical-groups=00005358]
# [00011.943 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=008; inidenticals=00068989; inidentical-groups=00002814]
# [00011.597 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=016; inidenticals=00042289; inidentical-groups=00000621]
# [00011.611 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=032; inidenticals=00033030; inidentical-groups=00000210]
# [00011.566 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=064; inidenticals=00026535; inidentical-groups=00000066]
# [00011.578 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=128; inidenticals=00022136; inidentical-groups=00000013]
# [00011.568 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=256; inidenticals=00020315; inidentical-groups=00000001]
#
# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00156.449 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda
# [00163.209 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=002; inidenticals=00914539; inidentical-groups=00203669]
# [00161.975 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=004; inidenticals=00520954; inidentical-groups=00025620]
# [00161.918 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=008; inidenticals=00418530; inidentical-groups=00003613]
# [00161.633 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=016; inidenticals=00391550; inidentical-groups=00000936]
# [00162.428 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=032; inidenticals=00378344; inidentical-groups=00000316]
# [00161.693 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=064; inidenticals=00369064; inidentical-groups=00000096]
# [00162.415 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=128; inidenticals=00362503; inidentical-groups=00000021]
# [00161.733 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-indenticals=256; inidenticals=00359326; inidentical-groups=00000004]
#
# ...
```

[![](https://i.imgur.com/9OQwymc.png)][sheetp]
[![](https://i.imgur.com/TzA7ehd.png)][sheetp]
[![](https://i.imgur.com/cZvq5mI.png)][sheetp]
[![](https://i.imgur.com/1i2Lt3A.png)][sheetp]
[![](https://i.imgur.com/txKlvLr.png)][sheetp]

<br>
<br>


## References

- [STIC-D: Algorithmic Techniques For Efficient Parallel Pagerank Computation on Real-World Graphs](https://gist.github.com/wolfram77/bb09968cc0e592583c4b180243697d5a)
- [Adjusting PageRank parameters and Comparing results](https://arxiv.org/abs/2108.02997)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/Z7oiZSS.jpg)](https://www.youtube.com/watch?v=rKv_l1RnSqs)
[![DOI](https://zenodo.org/badge/381944534.svg)](https://zenodo.org/badge/latestdoi/381944534)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/ZQgXDrhbP5h1Tnkh8
[sheets]: https://docs.google.com/spreadsheets/d/19OtYumoFGqgcKpwtbfjwfuJdgc_bf-JaSQ4H3EHQZHQ/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vSgTpK_h4XE_TZck-cTpDV6ne8EvjlOXG5D7JI8k-7QMR5Q9dCmputHDtyJxGc27_BWc0TjletpNRzw/pubhtml
