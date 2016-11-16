using BayesLM, Distributions, RCall
sym(M::Matrix{Float64}) = (M' + M) / 2
R"library(rcommon)"
plotpost = R"plotPosts"
plot= R"plot"
points= R"points"
add_errbar = R"add.errbar"
color_btwn = R"color.btwn"
rgb = R"rgb"

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
plotpost(β1,cnames=["Intercept","slope"]);

# Model II: logit link
function loglike2(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = invlogit.(Xb)
  sum([ logpdf(Binomial(m[i],mu[i]),y[i]) for i in 1:N ])
end
@time model2 = glm(y, X, Σᵦ*.5, loglike2, B=2000,burn=10000);
summary(model2)
β2 = hcat(map(m -> m.β, model2.post_params)...)'
plotpost(β2,cnames=["Intercept","slope"]);

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
                   B=2000,burn=10000,printFreq=10000);
summary(model3)
β3 = hcat(map(m -> m.β, model3.post_params)...)'
α = map(m->m.θ[:α], model3.post_params)
plotpost(β3,cnames=["Intercept","slope"]);
plotpost(α);

# Plot ##################
x0 = collect(linspace(1.65,1.9,1000))
function predict_p(x0::Vector{Float64}, β::Matrix{Float64}, inv_link)
  const x0b = [ones(x0) x0] * β'
  return inv_link.(x0b)
end
function predict_p(x0::Vector{Float64}, β::Matrix{Float64}, α::Vector{Float64})
  const x0b = [ones(x0) x0] * β'
  const B = length(α)
  return hcat([exp(α[b]*x0b[:,b]) ./ (1+exp(x0b[:,b])).^α[b] for b in 1:B]...)
end

# MATCH COLORS!!! FIXME
p1 = predict_p(x0,β1,invcloglog)
p1_ci = mapslices(p -> quantile(p,[.025,.975]), p1, 2)
plot(x0,mean(p1,2),xlab="",ylab="",fg="grey",bty="n",col=2,typ="l",lwd=3)
#plot(x0,mean(p1,2),xlab="",ylab="",fg="grey",bty="n",col=2,typ="n",lwd=3)
color_btwn(x0,p1_ci[:,1],p1_ci[:,2],from=minimum(x0),to=maximum(x0),rgb(1,0,0,.4))

p2 = predict_p(x0,β2,invlogit)
p2_ci = mapslices(p -> quantile(p,[.025,.975]), p2, 2)
points(x0,mean(p2,2),xlab="",ylab="",fg="grey",bty="n",col=3,typ="l",lwd=3)
color_btwn(x0,p2_ci[:,1],p2_ci[:,2],from=minimum(x0),to=maximum(x0),rgb(0,1,0,.3))

p3 = predict_p(x0,β3,α)
p3_ci = mapslices(p -> quantile(p,[.025,.975]), p3, 2)
points(x0,mean(p3,2),xlab="",ylab="",fg="grey",bty="n",col=4,typ="l",lwd=3)
color_btwn(x0,p3_ci[:,1],p3_ci[:,2],from=minimum(x0),to=maximum(x0),rgb(0,0,1,.3))

#R"""
#points(beetles$logDose,beetles$prob,pch=20,col='grey30',cex=2)
#legend("bottomright",legend=c("Data","","",""),cex=2,text.col=c("grey30",2:4), bty='n')
#"""



# Lethal Dose ##################################
#function ld(q::Float64,x0::Vector{Float64},β::Matrix{Float64},F_inv)
#  assert(length(x0) == size(β,2))
#  const X0b = β*x0
#  F_inv(q)
#end
