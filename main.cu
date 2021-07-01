#include <cmath>
#include <vector>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;




#define REPEAT 5

template <class G, class H>
void runPagerank(const G& x, const H& xt, bool show) {
  vector<float> *init = nullptr;

  // Find pagerank using nvGraph.
  auto a1 = pagerankNvgraph(xt, init, {REPEAT});
  auto e1 = l1Norm(a1.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankNvgraph\n", a1.time, a1.iterations, e1);

  // Find pagerank without optimization.
  auto a2 = pagerankCuda(xt, init, {REPEAT});
  auto e2 = l1Norm(a2.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda\n", a2.time, a2.iterations, e2);

  // Find pagerank skipping converged vertices with re-check.
  for (int skipCheck=2; skipCheck<16; skipCheck+=int(log2(skipCheck))) {
    auto a3 = pagerankCuda(xt, init, {REPEAT, skipCheck, 0});
    auto e3 = l1Norm(a3.ranks, a1.ranks);
    printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [skip-check=%d]\n", a3.time, a3.iterations, e3, skipCheck);
  }

  // Find pagerank skipping converged vertices after several turns.
  for (int skipAfter=2; skipAfter<64; skipAfter+=int(log2(skipAfter))) {
    auto a4 = pagerankCuda(xt, init, {REPEAT, 0, skipAfter});
    auto e4 = l1Norm(a4.ranks, a1.ranks);
    printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [skip-after=%d]\n", a4.time, a4.iterations, e4, skipAfter);
  }
}


int main(int argc, char **argv) {
  char *file = argv[1];
  bool  show = argc > 2;
  printf("Loading graph %s ...\n", file);
  auto x  = readMtx(file); println(x);
  auto xt = transposeWithDegree(x); print(xt); printf(" (transposeWithDegree)\n");
  runPagerank(x, xt, show);
  printf("\n");
  return 0;
}
