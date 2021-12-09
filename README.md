Comparing various **min. compute sizes** for **CUDA** based PageRank ([pull], [CSR]).

For this experiment, the vertices were **split by components**, and were joined
together until they satisfied a **min. compute size**. Each joined component is
then run through *pagerank compute call*. **Min. compute size** was varied from
`1E+0` to `5E+7`, and pagerank was run 5 times to get a good time measure. Both
from GM and AM execution times, it is observed that with a low *min compute*,
the time taken for PageRank computation is significatly high. This is likely
because with a lot of small components, a large number of kernel calls have to
be made, which is expensive business. Again, it is observed that with a large
*min compute*, the time taken for PageRank computation is also somewhat high.
This can be made sense of by considering that large *min compute* effectively
disables splitting by components, and thus prevents any memory locality benefits
through memory coalescing or cache utilization, as explained [here]. A sweet
spot is found in the mid of the two extremes at a **min compute** of `1E+6`.

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
# [00167.968 ms; 000 iters.] [0.0000e+00 err.] pagerankNvgraph
# [00354.189 ms; 051 iters.] [3.0248e-06 err.] pagerankCuda [min-compute=1]
# [00359.688 ms; 051 iters.] [3.0147e-06 err.] pagerankCuda [min-compute=5]
# [00370.161 ms; 051 iters.] [3.0311e-06 err.] pagerankCuda [min-compute=10]
# [00215.243 ms; 051 iters.] [3.0474e-06 err.] pagerankCuda [min-compute=50]
# [00193.222 ms; 051 iters.] [3.0905e-06 err.] pagerankCuda [min-compute=100]
# [00190.736 ms; 051 iters.] [3.0432e-06 err.] pagerankCuda [min-compute=500]
# [00184.762 ms; 051 iters.] [3.0680e-06 err.] pagerankCuda [min-compute=1000]
# [00166.049 ms; 051 iters.] [3.0745e-06 err.] pagerankCuda [min-compute=5000]
# [00165.249 ms; 051 iters.] [3.0696e-06 err.] pagerankCuda [min-compute=10000]
# [00156.035 ms; 051 iters.] [3.0847e-06 err.] pagerankCuda [min-compute=50000]
# [00153.055 ms; 051 iters.] [3.0731e-06 err.] pagerankCuda [min-compute=100000]
# [00152.096 ms; 051 iters.] [3.0786e-06 err.] pagerankCuda [min-compute=500000]
# [00151.729 ms; 051 iters.] [3.0290e-06 err.] pagerankCuda [min-compute=1000000]
# [00150.901 ms; 051 iters.] [3.1235e-06 err.] pagerankCuda [min-compute=5000000]
# [00150.858 ms; 051 iters.] [3.1235e-06 err.] pagerankCuda [min-compute=10000000]
#
# ...
```

[![](https://i.imgur.com/fUfdxKB.gif)][sheetp]
[![](https://i.imgur.com/alBEubg.png)][sheetp]
[![](https://i.imgur.com/grMjxPK.png)][sheetp]

<br>
<br>


## References

- [STIC-D: Algorithmic Techniques For Efficient Parallel Pagerank Computation on Real-World Graphs](https://gist.github.com/wolfram77/bb09968cc0e592583c4b180243697d5a)
- [Adjusting PageRank parameters and Comparing results](https://arxiv.org/abs/2108.02997)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/1KQzxjU.jpg)](https://www.youtube.com/watch?v=4Xw0MrllRfQ)

[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[here]: https://github.com/puzzlef/pagerank-optimization-split-components
[charts]: https://photos.app.goo.gl/uFFqJ9NFfe5uxSxx9
[sheets]: https://docs.google.com/spreadsheets/d/1ZFnirMXPX7GFGwLaGKkbqu2f7KiTFPkvRYixq_mUDno/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vTevnZVIFXfyfpeO81c_ivPVtlfyBJ1wvxYw4L9M2yI12a7joqnP895-c_3V3eDn0v8B4p_vPO-VEMG/pubhtml
