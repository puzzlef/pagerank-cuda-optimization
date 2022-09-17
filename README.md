Performance benefit of **skipping chain vertices** for **CUDA** based
PageRank ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find PageRank **without optimization**.
2. Find PageRank **skipping rank calculation of chain vertices**.

Each approach was attempted on a number of graphs, running each approach 5 times
to get a good time measure. The minimum size of *chains* is varied from 2-256,
with 2 being the default (`skip2`), and the best among them is also picked
(`skipbest`). A **chain** here means a set of *uni-directional links* connecting
one vertex to the next, without any additional edges. *Bi-directional links* are
**not** considered as **chains**. Note that most graphs don't have enough chains
to provide an advantage. Road networks do have chains, but they are
*bi-directional*, and thus not considered here. It seems **skipping all chains**
*(skip2)* **decreases execution time by -11 to 6%**, while **skipping chains
with best group size or more** *(skipbest)* **decreases execution time by -9 to
6%**, when compared to no optimization. Please note that some other these small
speedups can be attributed to randomness (execution time has small variations).
With respect to **GM-RATIO**, *skipping chains (skip2)* and *skipping best
chains (skipbest)* completes in **4% more time (0.96x)** than using default
approach. With respect to **AM-RATIO**, *skipping chains (skip2)* completes in
**4% more time (0.96x)**, and *skipping best chains (skipbest)* completes in
**3% more time (0.97x)**, than using default approach. It therefore makes sense
to apply this optimization only when the graph has a large number of chains.

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
# [00011.371 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda
# [00011.726 ms; 063 iters.] [2.5968e-09 err.] pagerankCuda [skip-chains=002; chain-vertices=00001265; chains=00000575]
# [00011.673 ms; 063 iters.] [9.5497e-12 err.] pagerankCuda [skip-chains=004; chain-vertices=00000051; chains=00000002]
# [00011.697 ms; 063 iters.] [9.5497e-12 err.] pagerankCuda [skip-chains=008; chain-vertices=00000051; chains=00000002]
# [00011.992 ms; 063 iters.] [9.5497e-12 err.] pagerankCuda [skip-chains=016; chain-vertices=00000051; chains=00000002]
# [00011.948 ms; 063 iters.] [7.5033e-12 err.] pagerankCuda [skip-chains=032; chain-vertices=00000034; chains=00000001]
# [00011.873 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=064; chain-vertices=00000000; chains=00000000]
# [00011.860 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=128; chain-vertices=00000000; chains=00000000]
# [00011.853 ms; 063 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=256; chain-vertices=00000000; chains=00000000]
#
# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [00157.950 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda
# [00160.251 ms; 051 iters.] [3.9981e-09 err.] pagerankCuda [skip-chains=002; chain-vertices=00015182; chains=00007435]
# [00158.980 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=004; chain-vertices=00000008; chains=00000002]
# [00159.280 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=008; chain-vertices=00000000; chains=00000000]
# [00158.992 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=016; chain-vertices=00000000; chains=00000000]
# [00158.958 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=032; chain-vertices=00000000; chains=00000000]
# [00159.059 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=064; chain-vertices=00000000; chains=00000000]
# [00159.376 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=128; chain-vertices=00000000; chains=00000000]
# [00158.963 ms; 051 iters.] [0.0000e+00 err.] pagerankCuda [skip-chains=256; chain-vertices=00000000; chains=00000000]
#
# ...
```

[![](https://i.imgur.com/D3MrFHJ.png)][sheetp]
[![](https://i.imgur.com/yvmncTr.png)][sheetp]
[![](https://i.imgur.com/QHxGOiF.png)][sheetp]
[![](https://i.imgur.com/jmJbljg.png)][sheetp]
[![](https://i.imgur.com/9zwY03H.png)][sheetp]

<br>
<br>


## References

- [STIC-D: Algorithmic Techniques For Efficient Parallel Pagerank Computation on Real-World Graphs](https://gist.github.com/wolfram77/bb09968cc0e592583c4b180243697d5a)
- [Adjusting PageRank parameters and Comparing results](https://arxiv.org/abs/2108.02997)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/CB5t3WL.jpg)](https://www.youtube.com/watch?v=gUHejU7qyv8)
[![ORG](https://img.shields.io/badge/org-puzzlef-green?logo=Org)](https://puzzlef.github.io)
[![DOI](https://zenodo.org/badge/381967720.svg)](https://zenodo.org/badge/latestdoi/381967720)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/aZrQrYTmLAJMhQBQ9
[sheets]: https://docs.google.com/spreadsheets/d/1XFDSB-OjMi7vKQuAh6jWqBCBhtvvnaPg-xOn7D91_sY/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vSoYTEti_-5sZiH8ijiyozkGoA09cSzi_25PQAvcj2-7LeAQRKjMby4sXOim7bmihSI2YIgOE9g_JPK/pubhtml
