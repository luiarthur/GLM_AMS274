srand(274);

using RCall
include("hier/HierPois.jl")

R"library(rcommon)";
R"fabric <- read.table('data/fabric.txt', skip=4, header=TRUE)";
R"summary(glm(faults ~ length, data=fabric, family=poisson))"
@rget fabric

const N = size(fabric,1)
const X = [ ones(N) fabric[:length] ]
const y = fabric[:faults] * 1.
const Σᵦ = HierPois.sym(inv(X'X)) 

function ldgammaMeanVar(x::Float64,m::Float64,s2::Float64)
  return x<0 ? -Inf : (m^2/s2)*log(x) - (m/s2)*x
end

@time mod = HierPois.fit(y, X, .5, λ-> λ<0? -Inf: -2*log(1+λ), 7.0, 2000, 10000, printEvery=1000);

(β,μ,λ,accβ,accλ) = mod

println("Acc β: ", accβ)
println("Acc λ: ", accλ)

# Posterior of Parameters
R"pdf('../img/betaB.pdf')";
R"plotPosts($β,cnames=c('intercept','length'))";
R"dev.off()";

R"pdf('../img/lambda.pdf')"
R"plotPost($λ,main=expression(lambda))";
R"dev.off()";

R"plot($y,apply($μ,2,mean),pch=20,col='blue',ylim=c(0,33),xlim=c(0,33))";
R"abline(0,1,col='grey')";
R"add.errbar(t(apply($μ,2,quantile,c(.025,.975))),x=$y,col='blue')";

# Posterior of Response Mean as a fn. of Covariate
x0 = linspace(minimum(X[:,2]),maximum(X[:,2]),100)
X0 = [ones(x0) x0]
pred = HierPois.predict(X0, β', exp)
R"pdf('../img/predB.pdf')";
R"plot(fabric$length, fabric$faults,col='grey30',bty='n',fg='grey',pch=20,ylab='Faults',xlab='Length',main='Posterior Predictive Response Mean \n (Hierarchical Model)',col.main='grey30',xlim=range($x0))"
R"lines($x0,apply($pred,1,mean),lwd=2,col='blue')"
R"color.btwn($x0, apply($pred,1,quantile,.025), apply($pred,1,quantile,.975),from=min($x0),to=max($x0),col=rgb(0,0,1,.3))"
R"dev.off()";


