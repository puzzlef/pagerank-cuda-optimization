#pragma once
#include "_main.hxx"
#include "DiGraph.hxx"
#include "vertices.hxx"
#include "edges.hxx"
#include "csr.hxx"
#include "mtx.hxx"
#include "snap.hxx"
#include "copy.hxx"
#include "transpose.hxx"
#include "deadEnds.hxx"
#include "selfLoop.hxx"
#include "dfs.hxx"
#include "components.hxx"
#include "topologicalSort.hxx"
#include "dynamic.hxx"
#include "pagerank.hxx"
#include "pagerankCuda.hxx"
#include "pagerankMonolithicCuda.hxx"

#ifndef NVGRAPH_DISABLE
#include "pagerankNvgraph.hxx"
#else
#define pagerankNvgraph pagerankCuda
#endif
