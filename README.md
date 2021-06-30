Performance benefit of PageRank with vertices **split by components** ([pull], [CSR]).

This experiment was for comparing performance between:
1. Find pagerank **without optimization**.
2. Find pagerank with vertices **split by components**.
3. Find pagerank with components **sorted in topological order**.

Each approach was attempted on a number of graphs, running each approach 5
times to get a good time measure. On an few graphs, **splitting vertices by**
**components** provides a **speedup**, but *sorting components in*
*topological order* provides *no additional speedup*. For road networks, like
`germany_osm` which only have *one component*, the speedup is possibly because
of the *vertex reordering* caused by `dfs()` which is required for splitting
by components.

All outputs are saved in [out](out/) and a small part of the output is listed
here. Some [charts] are also included below, generated from [sheets]. The input
data used for this experiment is available at ["graphs"] (for small ones), and
the [SuiteSparse Matrix Collection].

<br>

```bash
$ g++ -O3 main.cxx
$ ./a.out ~/data/min-1DeadEnd.mtx
$ ./a.out ~/data/min-2SCC.mtx
$ ...

# ...
#
# Loading graph /home/subhajit/data/web-Stanford.mtx ...
# order: 281903 size: 2312497 {}
# order: 281903 size: 2312497 {} (transposeWithDegree)
# [00441.055 ms; 063 iters.] [0.0000e+00 err.] pagerankSeq
# [00333.251 ms; 063 iters.] [0.0000e+00 err.] pagerankSeq [split]
# [00331.664 ms; 063 iters.] [0.0000e+00 err.] pagerankSeq [split; sort]
#
# ...
#
# Loading graph /home/subhajit/data/soc-LiveJournal1.mtx ...
# order: 4847571 size: 68993773 {}
# order: 4847571 size: 68993773 {} (transposeWithDegree)
# [11715.982 ms; 051 iters.] [0.0000e+00 err.] pagerankSeq
# [11447.048 ms; 051 iters.] [4.5725e-09 err.] pagerankSeq [split]
# [11474.953 ms; 051 iters.] [4.5754e-09 err.] pagerankSeq [split; sort]
#
# ...
```

[![](https://i.imgur.com/lvB6ae7.png)][sheets]

<br>
<br>


## References

- [STIC-D: algorithmic techniques for efficient parallel pagerank computation on real-world graphs][STIC-D algorithm]
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](http://snap.stanford.edu/class/cs246-videos-2019/lec9_190205-cs246-720.mp4)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/z8RKUMF.jpg)](https://www.youtube.com/watch?v=ocTgFXPnTgQ)

[STIC-D algorithm]: https://www.slideshare.net/SubhajitSahu/sticd-algorithmic-techniques-for-efficient-parallel-pagerank-computation-on-realworld-graphs
[SuiteSparse Matrix Collection]: https://suitesparse-collection-website.herokuapp.com
["graphs"]: https://github.com/puzzlef/graphs
[pull]: https://github.com/puzzlef/pagerank-push-vs-pull
[CSR]: https://github.com/puzzlef/pagerank-class-vs-csr
[charts]: https://photos.app.goo.gl/HqQHJ2twRK7Ge1Xc6
[sheets]: https://docs.google.com/spreadsheets/d/1YmY_KYo9cDe2YCuwTgiiT0fFnyPS9-WScDIO9n-zRSY/edit?usp=sharing
