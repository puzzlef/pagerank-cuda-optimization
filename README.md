Performance benefit of **skipping converged vertices** for **CUDA** based
PageRank ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find pagerank **without optimization**.
2. Find pagerank *skipping converged vertices* **with re-check** (in `2`-`16` turns).
3. Find pagerank *skipping converged vertices* **after several turns** (in `2`-`64` turns).

Each approach was attempted on a number of graphs, running each approach 5
times to get a good time measure. **Skip with re-check** (`skip-check`) is
done every `2`-`16` turns. **Skip after turns** (`skip-after`) is done after
`2`-`64` turns. On average, *neither* `skip-check`, nor `skip-after` gives
**better speed** than the **default (unoptimized) approach**. This could be
due to the unnessary iterations added by `skip-check` (mistakenly skipped),
and increased memory accesses performed by `skip-after` (tracking converged
count).

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
# [00168.424 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00162.337 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda
# [00169.842 ms; 051 iters.] [3.2220e-06 err.] pagerankCuda [skip-check=2]
# [00169.963 ms; 051 iters.] [3.2265e-06 err.] pagerankCuda [skip-check=3]
# [00169.904 ms; 051 iters.] [3.2348e-06 err.] pagerankCuda [skip-check=4]
# [00169.820 ms; 051 iters.] [3.2375e-06 err.] pagerankCuda [skip-check=6]
# [00169.843 ms; 051 iters.] [3.2464e-06 err.] pagerankCuda [skip-check=8]
# [00169.774 ms; 051 iters.] [3.2740e-06 err.] pagerankCuda [skip-check=11]
# [00170.497 ms; 051 iters.] [3.3190e-06 err.] pagerankCuda [skip-check=14]
# [00168.862 ms; 051 iters.] [3.2294e-06 err.] pagerankCuda [skip-after=2]
# [00168.807 ms; 051 iters.] [3.2247e-06 err.] pagerankCuda [skip-after=3]
# [00168.771 ms; 051 iters.] [3.2240e-06 err.] pagerankCuda [skip-after=4]
# [00168.737 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=6]
# [00168.713 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=8]
# [00168.717 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=11]
# [00169.499 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=14]
# [00168.802 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=17]
# [00168.865 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=21]
# [00168.743 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=25]
# [00168.943 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=29]
# [00168.862 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=33]
# [00168.817 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=38]
# [00169.524 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=43]
# [00169.056 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=48]
# [00168.912 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=53]
# [00168.800 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=58]
# [00168.851 ms; 051 iters.] [3.2209e-06 err.] pagerankCuda [skip-after=63]
#
# ...
```

[![](https://i.imgur.com/M0oVGr4.png)][sheetp]
[![](https://i.imgur.com/VnL7OqQ.png)][sheetp]
[![](https://i.imgur.com/Nlu7uGc.png)][sheetp]
[![](https://i.imgur.com/svOiSox.png)][sheetp]
[![](https://i.imgur.com/7rFFtve.png)][sheetp]
[![](https://i.imgur.com/heoESwj.png)][sheetp]
[![](https://i.imgur.com/VNH19GP.png)][sheetp]
[![](https://i.imgur.com/fTQDX96.png)][sheetp]
[![](https://i.imgur.com/ly9pvtW.png)][sheetp]
[![](https://i.imgur.com/7vULjni.png)][sheetp]
[![](https://i.imgur.com/H68ewoE.png)][sheetp]
[![](https://i.imgur.com/59SNFZy.png)][sheetp]
[![](https://i.imgur.com/Xx6YRDL.png)][sheetp]
[![](https://i.imgur.com/js2BmD3.png)][sheetp]
[![](https://i.imgur.com/MTbWHqZ.png)][sheetp]
[![](https://i.imgur.com/EfoHAEG.png)][sheetp]
[![](https://i.imgur.com/tTnKQqR.png)][sheetp]
[![](https://i.imgur.com/Ix3JQxN.png)][sheetp]
[![](https://i.imgur.com/k41RlG8.png)][sheetp]
[![](https://i.imgur.com/KfGyokd.png)][sheetp]
[![](https://i.imgur.com/HLtW60o.png)][sheetp]
[![](https://i.imgur.com/ugsQGm2.png)][sheetp]
[![](https://i.imgur.com/lHnZwUD.png)][sheetp]
[![](https://i.imgur.com/2RFrqbC.png)][sheetp]
[![](https://i.imgur.com/njcyp8L.png)][sheetp]
[![](https://i.imgur.com/U8uIH10.png)][sheetp]
[![](https://i.imgur.com/fLufmYV.png)][sheetp]
[![](https://i.imgur.com/NeNcpSy.png)][sheetp]
[![](https://i.imgur.com/BLtWtUv.png)][sheetp]
[![](https://i.imgur.com/gdkQ7d6.png)][sheetp]
[![](https://i.imgur.com/ENsz3a8.png)][sheetp]
[![](https://i.imgur.com/UgEAvHh.png)][sheetp]
[![](https://i.imgur.com/CvHzpcr.png)][sheetp]
[![](https://i.imgur.com/1YhimVf.png)][sheetp]

[![](https://i.imgur.com/Hzk0X81.png)][sheetp]
[![](https://i.imgur.com/pxz5RVh.png)][sheetp]
[![](https://i.imgur.com/Mu0BRHm.png)][sheetp]

<br>
<br>


## References

- [STIC-D: algorithmic techniques for efficient parallel pagerank computation on real-world graphs][STIC-D algorithm]
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](http://snap.stanford.edu/class/cs246-videos-2019/lec9_190205-cs246-720.mp4)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/KExwVG1.jpg)](https://www.youtube.com/watch?v=A7TKQKAFIi4)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://cstar.iiit.ac.in/~kkishore/
[STIC-D algorithm]: https://www.slideshare.net/SubhajitSahu/sticd-algorithmic-techniques-for-efficient-parallel-pagerank-computation-on-realworld-graphs
[SuiteSparse Matrix Collection]: https://suitesparse-collection-website.herokuapp.com
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/XtYLSiBuqjhupFM89
[sheets]: https://docs.google.com/spreadsheets/d/1MtKJ-2d09RttSbxDeZUz1VnZmZSktmH8moSl_8EZXYE/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vRaKnHS2Cg2-Vq15eIwhwMjguNhH3FPSNaQjw28V7NwRC-qGERn4Srcdo9hoDBL3QeWodlH5zku4cCo/pubhtml
