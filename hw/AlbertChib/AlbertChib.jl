module AlbertChib

import Distributions.TruncatedNormal, Distributions.MultivariateNormal
import MCMC

export gibbs_ac

immutable State
  beta::Array{Float64,1}
end

function gibbs_ac(y::Array{Int,1}, X::Array{Float64,2}, V::Array{Float64,2};
                  B::Int=1000, burn::Int=1000,printFreq::Int=0)

  const (n,k) = size(X)
  S = inv(X'X + inv(V))
  S = (S + S') / 2
  const SX = S * X'

  function update_z(b::Array{Float64,1})
    const n = length(y)
    const Xb = X*b

    z = Array{Float64,1}(n)
    
    for i in 1:n
      if y[i] == 0
        z[i] = rand(TruncatedNormal(Xb[i],1,-Inf,0))
      else
        z[i] = rand(TruncatedNormal(Xb[i],1,0,Inf))
      end
    end

    return z
  end

  function update(state::State)
    const new_z = update_z(state.beta)
    const new_beta = rand( MultivariateNormal(SX*new_z,S) )

    return State(new_beta)
  end

  const init_z = rand(0:1,n)
  const init_beta = zeros(k)

  return MCMC.gibbs(State(init_beta), update, B, burn, printFreq=printFreq)
end

end

#=
include("AlbertChib.jl")
using Distributions, RCall
R"library(rcommon)"

# generate data:
n = 2000
X = [ones(n) randn(n,2)]
beta = [1,2,3]
p = map(xb -> cdf(Normal(0,1),xb), X*beta)
y = map(p_i->rand(Bernoulli(p_i)),p)
V = eye(3)

# Since this is probit, and not logistic, regression. Should not get same answers.
@time out = AlbertChib.gibbs_ac(y,X,V,B=100,burn=10,printFreq=0)
beta_post = hcat(map(o -> o.beta, out)...)'

@rput beta_post y X
R"plotPosts(beta_post,legend.pos='topleft',stats=FALSE)";
R"my.pairs(cbind(y,X))"
=#
