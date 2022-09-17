Performance benefit of **skipping converged vertices** for **CUDA** based
PageRank ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find PageRank **without optimization**.
2. Find PageRank *skipping converged vertices* **with re-check** (in `2`-`16` turns).
3. Find PageRank *skipping converged vertices* **after several turns** (in `2`-`64` turns).

Each approach was attempted on a number of graphs, running each approach 5 times
to get a good time measure. **Skip with re-check** (`skip-check`) is done every
`2`-`16` turns. **Skip after turns** (`skip-after`) is done after `2`-`64`
turns.

Results indicate that the optimizations provide an improvement on only a
few graphs (without introducing too much error):
- For `web-Stanford`, a `skip-check` of `11`-`14` appears to work best.
- For `web-BerkStan`, a `skip-check` of `8`-`14` appears to work best.
- For other graphs, there is no improvement.

On average however, *neither* `skip-check`, nor `skip-after` gives **better
speed** than the **default (unoptimized) approach** (considering the error
introduced due to skipping). This could be due to the unnecessary iterations
added by `skip-check` (mistakenly skipped), and increased memory accesses
performed by `skip-after` (tracking converged count).

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
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00162.126 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda
# [00169.448 ms; 051 iters.] [1.9773e-09 err.] pagerankCuda [skip-check=2]
# [00169.080 ms; 051 iters.] [4.6557e-09 err.] pagerankCuda [skip-check=3]
# [00169.111 ms; 051 iters.] [6.1110e-09 err.] pagerankCuda [skip-check=4]
# [00169.113 ms; 051 iters.] [1.1584e-08 err.] pagerankCuda [skip-check=6]
# [00169.172 ms; 051 iters.] [3.3697e-08 err.] pagerankCuda [skip-check=8]
# [00169.154 ms; 051 iters.] [6.5356e-08 err.] pagerankCuda [skip-check=11]
# [00169.901 ms; 051 iters.] [1.2554e-07 err.] pagerankCuda [skip-check=14]
# [00168.043 ms; 051 iters.] [9.5494e-09 err.] pagerankCuda [skip-after=2]
# [00168.051 ms; 051 iters.] [1.5228e-09 err.] pagerankCuda [skip-after=3]
# [00168.042 ms; 051 iters.] [6.8778e-10 err.] pagerankCuda [skip-after=4]
# [00168.046 ms; 051 iters.] [2.0807e-10 err.] pagerankCuda [skip-after=6]
# [00168.015 ms; 051 iters.] [9.7309e-11 err.] pagerankCuda [skip-after=8]
# [00167.987 ms; 051 iters.] [2.8471e-11 err.] pagerankCuda [skip-after=11]
# [00168.526 ms; 051 iters.] [5.6239e-12 err.] pagerankCuda [skip-after=14]
# [00168.021 ms; 051 iters.] [9.5213e-13 err.] pagerankCuda [skip-after=17]
# [00168.362 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=21]
# [00168.032 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=25]
# [00168.040 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=29]
# [00168.973 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=33]
# [00168.467 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=38]
# [00168.034 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=43]
# [00168.021 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=48]
# [00168.038 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=53]
# [00168.036 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=58]
# [00168.070 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-after=63]
#
# ...
```

[![](https://i.imgur.com/wcpqS4z.gif)][sheetp]
[![](https://i.imgur.com/Ukl771H.gif)][sheetp]

[![](https://i.imgur.com/bMdnihr.png)][sheetp]
[![](https://i.imgur.com/tdZOpI2.png)][sheetp]
[![](https://i.imgur.com/0kvtkU9.png)][sheetp]

<br>
<br>


## References

- [STIC-D: Algorithmic Techniques For Efficient Parallel Pagerank Computation on Real-World Graphs](https://gist.github.com/wolfram77/bb09968cc0e592583c4b180243697d5a)
- [Adjusting PageRank parameters and Comparing results](https://arxiv.org/abs/2108.02997)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/KExwVG1.jpg)](https://www.youtube.com/watch?v=A7TKQKAFIi4)
[![ORG](https://img.shields.io/badge/org-puzzlef-green?logo=Org)](https://puzzlef.github.io)
[![DOI](https://zenodo.org/badge/381913855.svg)](https://zenodo.org/badge/latestdoi/381913855)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/XtYLSiBuqjhupFM89
[sheets]: https://docs.google.com/spreadsheets/d/1MtKJ-2d09RttSbxDeZUz1VnZmZSktmH8moSl_8EZXYE/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vRaKnHS2Cg2-Vq15eIwhwMjguNhH3FPSNaQjw28V7NwRC-qGERn4Srcdo9hoDBL3QeWodlH5zku4cCo/pubhtml
