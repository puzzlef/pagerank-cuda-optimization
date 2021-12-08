#include <vector>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;




#define SPLIT_COMPONENTS true
#define SORT_COMPONENTS  true

template <class G, class H>
void runPagerank(const G& x, const H& xt, int repeat) {
  enum NormFunction { L0=0, L1=1, L2=2, Li=3 };
  vector<float> *init = nullptr;

  // Find pagerank using nvGraph.
  auto a1 = pagerankNvgraph(x, xt, init, {repeat, L1});
  auto e1 = l1Norm(a1.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankNvgraph\n", a1.time, a1.iterations, e1);

  // Find pagerank without optimization.
  auto a2 = pagerankMonolithicCuda(x, xt, init, {repeat, L1});
  auto e2 = l1Norm(a2.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda\n", a2.time, a2.iterations, e2);

  // Find pagerank with vertices split by components.
  auto a3 = pagerankMonolithicCuda(x, xt, init, {repeat, L1, SPLIT_COMPONENTS});
  auto e3 = l1Norm(a3.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [split]\n", a3.time, a3.iterations, e3);

  // Find pagerank with components sorted in topological order.
  auto a4 = pagerankMonolithicCuda(x, xt, init, {repeat, L1, SPLIT_COMPONENTS, SORT_COMPONENTS});
  auto e4 = l1Norm(a4.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankCuda [split; sort]\n", a4.time, a4.iterations, e4);
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
