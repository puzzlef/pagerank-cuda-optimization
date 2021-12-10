#include <cmath>
#include <vector>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;




template <class G, class H>
void runPagerank(const G& x, const H& xt, int repeat) {
  enum NormFunction { L0=0, L1=1, L2=2, Li=3 };
  vector<float> *init = nullptr;

  // Find pagerank without optimization.
  auto a1 = pagerankMonolithicCuda(x, xt, init, {repeat, L1});
  auto e1 = l1Norm(a1.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda\n", a1.time, a1.iterations, e1);

  // Find pagerank skipping converged vertices with re-check.
  for (int skipCheck=2; skipCheck<16; skipCheck+=int(log2(skipCheck))) {
    auto a2 = pagerankMonolithicCuda(x, xt, init, {repeat, L1, skipCheck, 0});
    auto e2 = l1Norm(a2.ranks, a1.ranks);
    printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [skip-check=%d]\n", a2.time, a2.iterations, e2, skipCheck);
  }

  // Find pagerank skipping converged vertices after several turns.
  for (int skipAfter=2; skipAfter<64; skipAfter+=int(log2(skipAfter))) {
    auto a3 = pagerankMonolithicCuda(x, xt, init, {repeat, L1, 0, skipAfter});
    auto e3 = l1Norm(a3.ranks, a1.ranks);
    printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [skip-after=%d]\n", a3.time, a3.iterations, e3, skipAfter);
  }
}


int main(int argc, char **argv) {
  char *file = argv[1];
  int repeat = argc>2? stoi(argv[2]) : 5;
  printf("Loading graph %s ...\n", file);
  auto x  = readMtx(file); println(x);
  auto xt = transposeWithDegree(x); print(xt); printf(" (transposeWithDegree)\n");
  runPagerank(x, xt, repeat);
  printf("\n");
  return 0;
}
