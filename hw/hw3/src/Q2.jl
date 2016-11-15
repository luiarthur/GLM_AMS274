using BayesLM, Distributions, RCall
sym(M::Matrix{Float64}) = (M' + M) / 2
R"library(rcommon)"
plot = R"plotPosts"

srand(1);

R"""
beetles <- read.csv("dat/beetles.dat",skip=1)
beetles$prob <- beetles$numDied/beetles$numBeetles
"""
@rget beetles;
invcloglog(xb::Float64) = 1-exp(-exp(xb))
invlogit(xb::Float64) = 1 / (1 + exp(-xb))

const y = beetles[:numDied] * 1.
const m = beetles[:numBeetles]
const N = length(y)
const X = [ones(N) beetles[:logDose]]
const Σᵦ = sym(inv(X'X)) 

# Model I: cloglog link
function loglike1(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = invcloglog.(Xb)
  sum([ logpdf(Binomial(m[i],mu[i]),y[i]) for i in 1:N ])
end
@time model1 = glm(y, X, Σᵦ*.3, loglike1, B=2000,burn=10000);
summary(model1)
β1 = hcat(map(m -> m.β, model1.post_params)...)'
plot(β1,cnames=["Intercept","slope"])

# Model II: logit link
function loglike2(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = invlogit.(Xb)
  sum([ logpdf(Binomial(m[i],mu[i]),y[i]) for i in 1:N ])
end
@time model2 = glm(y, X, Σᵦ*.5, loglike2, B=2000,burn=10000);
summary(model2)
β2 = hcat(map(m -> m.β, model2.post_params)...)'
plot(β2,cnames=["Intercept","slope"])

# Model III: modified logit link
lp_θ(θ::Hyper) = log(θ[:α])*(2-1) - θ[:α]*.01 # Gamma log prior, a=2,b=.01
function loglike3(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = exp(θ[:α]*Xb) ./ (1+exp(Xb)).^θ[:α]
  sum([ logpdf(Binomial(m[i],mu[i]),y[i]) for i in 1:N ])
end
@time model3 = glm(y, X, Σᵦ*2.5, loglike3, 
                   Σ_θ=eye(Float64,1)*.01, 
                   θ_bounds=[0. Inf], 
                   θ_names=[:α], 
                   θ_logprior=lp_θ,
                   B=5000,burn=100000);
summary(model3)
β3 = hcat(map(m -> m.β, model3.post_params)...)'
α = map(m->m.θ[:α], model3.post_params)
plot(β3,cnames=["Intercept","slope"])
plot(α)
