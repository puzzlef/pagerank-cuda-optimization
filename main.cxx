#include <vector>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;




template <class G, class H>
void runPagerank(const G& x, const H& xt, bool show) {
  int repeat = 5;
  bool splitComponents = true;
  bool sortComponents  = true;
  vector<float> *init  = nullptr;

  // Find pagerank without optimization.
  auto a1 = pagerankSeq(x, xt, init, {repeat});
  auto e1 = l1Norm(a1.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankSeq\n", a1.time, a1.iterations, e1);

  // Find pagerank with vertices split by components.
  auto a2 = pagerankSeq(x, xt, init, {repeat, splitComponents});
  auto e2 = l1Norm(a2.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankSeq [split]\n", a2.time, a2.iterations, e2);

  // Find pagerank with components sorted in topological order.
  auto a3 = pagerankSeq(x, xt, init, {repeat, splitComponents, sortComponents});
  auto e3 = l1Norm(a3.ranks, a1.ranks);
  printf("[%09.3f ms; %03d iters.] [%.4e err.] pagerankSeq [split; sort]\n", a3.time, a3.iterations, e3);
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
