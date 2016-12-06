srand(274);
using BayesLM, Distributions, RCall
R"library(rcommon)";
R"fabric <- read.table('data/fabric.txt', skip=4, header=TRUE)";
R"summary(glm(faults ~ length, data=fabric, family=poisson))"
@rget fabric

const N = size(fabric,1)
const X = [ ones(N) fabric[:length] ]
const y = fabric[:faults] * 1.
const Σᵦ = BayesLM.sym(inv(X'X)) 

function ll(y::Vector{Float64}, Xb::Vector{Float64}, θ::Hyper)
  const mu = exp(Xb)
  return sum(y .* log(mu) .- mu)
end

@time mod1 = glm(y,X,Σᵦ*.5,ll,B=2000,burn=10000);
s1 = summary(mod1)
β = hcat(map(m -> m.β, mod1.post_params)...)'

R"pdf('../img/betaA.pdf')"
R"plotPosts($β, cnames=c('intercept','length'))";
R"dev.off()"

x0 = linspace(minimum(X[:,2]),maximum(X[:,2]),100)
X0 = [ones(x0) x0]
pred = BayesLM.predict(X0,β',exp)
R"pdf('../img/predA.pdf')"
R"plot(fabric$length, fabric$faults,col='grey30',bty='n',fg='grey',pch=20,ylab='Faults',xlab='Length',main='Posterior Predictive Response Mean',col.main='grey30',xlim=range($x0))"
R"lines($x0,apply($pred,1,mean),lwd=2,col='blue')"
R"color.btwn($x0, apply($pred,1,quantile,.025), apply($pred,1,quantile,.975),from=min($x0),to=max($x0),col=rgb(0,0,1,.3))"
R"dev.off()"

pred_local = BayesLM.predict(X,β',exp)
R"pdf('../img/residA.pdf')"
R"plot(apply($y-$pred_local,1,mean),ylim=c(-15,15),col='red',pch=20,bty='n',fg='grey',cex=2,main='Posterior Predictive Residuals',ylab='Residuals',col.main='grey30')"
R"abline(h=0,col='grey30')"
R"add.errbar(t(apply($y-$pred_local,1,quantile,c(.025,.975))),col='red',lwd=2)"
R"dev.off()"

function loss(truth::Vector{Float64}, postpred::Matrix{Float64}, K::Int=10000000)
  return sum(var(postpred,2) + K/(K+1) * (truth - mean(postpred,2)).^2)
end
println("Loss Poi GLM: ", loss(y, pred_local, 1000))
