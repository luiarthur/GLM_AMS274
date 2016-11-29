using RCall, Distributions
include("BCLogit/BCLogit.jl")

R"""
source('loadRcommon.R')
source('plot2.R')
gator <- read.table('data/gator.txt',header=TRUE)
"""

@rget gator
const N = size(gator,1)
const sex = [s == "M" ? 0. : 1. for s in gator[:sex]] # 0: Male, 1: Female
const choice = [c=="F"?3:c=="I"?1:2 for c in gator[:choice]] # 3:F, 1:I, 2:O
const X = [ ones(N) sex gator[:length] ]
const J = length(unique(choice))
const Y = [ choice[i] == j ? 1:0 for i in 1:N, j in 1:J]


@time bc1 = BCLogit.fit(Y, [ones(N) gator[:length]], [20.,20.], printFreq=100, B=2000, burn=5000)
b11 = hcat(map(b -> b[1], bc1)...)'
b21 = hcat(map(b -> b[2], bc1)...)'
acc11 = size(unique(b11,1),1) / size(b11,1)
acc21 = size(unique(b21,1),1) / size(b21,1)

R"plotPosts($b11,cname=c('intercept','length'))";
R"plotPosts($b21,cname=c('intercept','length'))";

R"plot(gator$length,gator$choice,col=ifelse(gator$sex=='M','blue','red'),pch=20,cex=2,fg='grey')"

R"pdf('../img/gator1.pdf')"
R"""
xx <- seq(min(gator$length), max(gator$length), len=100)
x0 <- cbind(1,xx)
plot2(x0,list($b11,$b21))
"""
R"dev.off()"

@time bc2 = BCLogit.fit(Y, [ones(N) sex gator[:length]], [20.,20.], printFreq=100, B=2000, burn=5000)
b12 = hcat(map(b -> b[1], bc2)...)'
b22 = hcat(map(b -> b[2], bc2)...)'
acc12 = size(unique(b12,1),1) / size(b12,1)
acc22 = size(unique(b22,1),1) / size(b22,1)

R"plotPosts($b12,cname=c('intercept','sex (M=0)','length'))"
R"plotPosts($b22,cname=c('intercept','sex (M=0)','length'))"

R"pdf('../img/gator2.pdf',w=13,h=7)"
R"""
x0_M <- cbind(1,0,xx)
x0_F <- cbind(1,1,xx)
par(mfrow=c(1,2))
plot2(x0_M,list($b12,$b22),main='Male')
plot2(x0_F,list($b12,$b22),main='Female')
par(mfrow=c(1,1))
"""
R"dev.off()"


