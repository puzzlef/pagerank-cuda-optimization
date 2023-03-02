Exploration of **optimizations** to *CUDA-based PageRank algorithm* for link analysis.

<br>


### Splitting Components

This experiment ([split-components]) was for comparing performance between:
1. Find **CUDA** based PageRank **without optimization**.
2. Find **CUDA** based PageRank with vertices **split by components**.
3. Find **CUDA** based PageRank with components **sorted in topological order**.

For this experiment, the vertices were kept as is (*default*), **split by
components** (*split*), or additionally **sorted in topological order**
(*split+sort*). Small components were joined together until they satisfied a
**min. compute size**. Each joined component is then run through *PageRank
compute call*. **Min. compute size** was varied from `1E+0` to `5E+7`, and
PageRank was run 5 times to get a good time measure.

From both from GM and AM execution times, it is observed that with a low *min*
*compute*, the time taken for PageRank computation is significantly high (for
both *split*, and *split+sort*). This is likely because with a lot of small
components, a large number of kernel calls have to be made, which is expensive
business. As *min compute* is increased, PageRank computation time drops, and
seems to stabilize at a **min compute** of `1E+7` to `5E+7`. With respect to
**GM-RATIO**, both *split* and *split+sort* complete in **7% less time (1.08x)**
compared to default approach (no components). Write respect to **AM-RATIO**,
*split* completes in **6% less time (1.06x)**, and *split+sort* completes in
**7% less time (1.08x)** compared to default approach. This is the case for *min*
*compute* of *1E+7* or *5E+7*.

On a few graphs, **splitting vertices by components** provides a **speedup**,
but *sorting components in topological order* provides *no additional speedup*.
For **road networks** (and some **collaboration networks**), like `germany_osm`
which only have *one component*, the speedup is possibly because of the *vertex*
*reordering* caused by `dfs()` which is required for splitting by components.
However, **on average** there is a **small speedup**. Although it was observed
[here] that splitting by components can provide memory locality benefits through
better cache utilization, it appears that the cost of increased kernel calls is
significant. It is important to note here that in order to reduce work imbalance
between threads of the GPU, vertices are partitioned by degree.

[split-components]: https://github.com/puzzlef/pagerank-cuda-optimization/tree/split-components

<br>


### Splitting Components and Adjusting Compute size

For this experiment ([split-components-adjust-compute-size]), the vertices were
**split by components**, and were joined together until they satisfied a **min.**
**compute size**. Each joined component is then run through *pagerank compute*
*call*. **Min. compute size** was varied from `1E+0` to `5E+7`, and pagerank was
run 5 times to get a good time measure.

Both from GM and AM execution times, it is observed that with a low *min*
*compute*, the time taken for PageRank computation is significatly high. This is
likely because with a lot of small components, a large number of kernel calls
have to be made, which is expensive business. Again, it is observed that with a
large *min compute*, the time taken for PageRank computation is also somewhat
high. This can be made sense of by considering that large *min compute*
effectively disables splitting by components, and thus prevents any memory
locality benefits through memory coalescing or cache utilization, as explained
[here]. A sweet spot is found in the mid of the two extremes at a **min**
**compute** of `1E+6`.

[split-components-adjust-compute-size]: https://github.com/puzzlef/pagerank-cuda-optimization/tree/split-components-adjust-compute-size

<br>


### Skipping In-identical vertices

This experiment ([skip-inidenticals]) was for comparing performance between:
1. Find PageRank **without optimization**.
2. Find PageRank **skipping rank calculation of in-identical vertices**.

Each approach was attempted on a number of graphs, running each approach 5 times
to get a good time measure. The minimum size of *in-identical groups* is varied
from 2-256, with 2 being the default (`skip2`), and the best among them is also
picked (`skipbest`).

It seems **skipping all in-identicals** *(skip2)* and **skipping in-identicals**
**with best group size or more** *(skipbest)* **decrease execution time by -9 to**
**26%**, when compared to no optimization. This speedup is mainly observed on
`indochina-2004`, and hardly any on the other graphs. This speedup could be due
to the fact that the graph `indochina-2004` has a large number of
**in-identicals** and **in-identical groups**, although it doesn't have the
highest **in-identicals %** or the highest **avg. in-identical group size**.
With respect to **GM-RATIO**, *skipping in-identicals (skip2)* completes in **3%**
**more time (0.97x)**, and *skipping best in-identicals (skipbest)* completes in
**1% more time (0.99x)**, than using default approach. With respect to
**AM-RATIO**, *skipping in-identicals (skip2)* completes in **1% less time**
**(1.01x)**, and *skipping best in-identicals (skipbest)* completes in **2% less**
**time (1.02x)**, than using default approach. It therefore makes sense to apply
this optimization only when the graph has a large number of in-identicals.

[skip-inidenticals]: https://github.com/puzzlef/pagerank-cuda-optimization/tree/skip-inidenticals

<br>


### Skipping Chain vertices

This experiment ([skip-chains]) was for comparing performance between:
1. Find PageRank **without optimization**.
2. Find PageRank **skipping rank calculation of chain vertices**.

Each approach was attempted on a number of graphs, running each approach 5 times
to get a good time measure. The minimum size of *chains* is varied from 2-256,
with 2 being the default (`skip2`), and the best among them is also picked
(`skipbest`). A **chain** here means a set of *uni-directional links* connecting
one vertex to the next, without any additional edges. *Bi-directional links* are
**not** considered as **chains**. Note that most graphs don't have enough chains
to provide an advantage. Road networks do have chains, but they are
*bi-directional*, and thus not considered here.

It seems **skipping all chains** *(skip2)* **decreases execution time by -11 to**
**6%**, while **skipping chains with best group size or more** *(skipbest)*
**decreases execution time by -9 to 6%**, when compared to no optimization.
Please note that some other these small speedups can be attributed to randomness
(execution time has small variations). With respect to **GM-RATIO**, *skipping*
*chains (skip2)* and *skipping best chains (skipbest)* completes in **4% more**
**time (0.96x)** than using default approach. With respect to **AM-RATIO**,
*skipping chains (skip2)* completes in **4% more time (0.96x)**, and *skipping*
*best chains (skipbest)* completes in **3% more time (0.97x)**, than using
default approach. It therefore makes sense to apply this optimization only when
the graph has a large number of chains.

[skip-chains]: https://github.com/puzzlef/pagerank-cuda-optimization/tree/skip-chains

<br>


### Skipping Converged vertices

This experiment ([skip-converged]) was for comparing performance between:
1. Find PageRank **without optimization**.
2. Find PageRank *skipping converged vertices* **with re-check** (in `2`-`16` turns).
3. Find PageRank *skipping converged vertices* **after several turns** (in `2`-`64` turns).

Each approach was attempted on a number of graphs, running each approach 5 times
to get a good time measure. **Skip with re-check** (`skip-check`) is done every
`2`-`16` turns. **Skip after turns** (`skip-after`) is done after `2`-`64`
turns.

Results indicate that the optimizations provide an improvement on
few graphs (without introducing too much error):
- For `web-Stanford`, a `skip-check` of `11`-`14` appears to work best.
- For `web-BerkStan`, a `skip-check` of `8`-`14` appears to work best.
- For other graphs, there is no improvement.

On average however, *neither* `skip-check`, nor `skip-after` gives **better
speed** than the **default (unoptimized) approach** (considering the error
introduced due to skipping). This could be due to the unnecessary iterations
added by `skip-check` (mistakenly skipped), and increased memory accesses
performed by `skip-after` (tracking converged count).

[skip-converged]: https://github.com/puzzlef/pagerank-cuda-optimization/tree/skip-converged

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
[![ORG](https://img.shields.io/badge/org-puzzlef-green?logo=Org)](https://puzzlef.github.io)
[![DOI](https://zenodo.org/badge/381743698.svg)](https://zenodo.org/badge/latestdoi/381743698)


[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://www.iiit.ac.in/people/faculty/kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
