using RCall, Distributions, BayesLM
R"""
source('loadRcommon.R')
gator <- read.table('data/gator.txt',header=TRUE)
"""

@rget gator
const N = size(gator,1)
const sex = [s == "M" ? 0. : 1. for s in gator[:sex]] # 0: Male, 1: Female
const X = [ones(N) sex gator[:length]]
const y = [c=="F"?0:c=="I"?1:2 for c in gator[:choice]] # 0:F, 1:I, 2:O

