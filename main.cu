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

  // Find CUDA based pagerank, adjust min-component-size from 1E+0 - 1E+8.
  for (int C=1, i=0; C<5*xt.order(); C*=i&1? 2:5, i++) {
    int minComponentSize = C;
    auto a2 = pagerankCuda(x, xt, init, {REPEAT, minComponentSize});
    auto e2 = l1Norm(a2.ranks, a1.ranks);
    printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [min-component-size=%d]\n", a2.time, a2.iterations, e2, minComponentSize);
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
