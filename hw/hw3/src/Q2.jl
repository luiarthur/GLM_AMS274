using BayesLM, Distributions, RCall
sym(M::Matrix{Float64}) = (M' + M) / 2
R"library(rcommon)"
plotpost = R"plotPosts"
plot= R"plot"
points= R"points"
lines= R"lines"
density= R"lines"
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
println(summary(model1))
β1 = hcat(map(m -> m.β, model1.post_params)...)'
R"pdf('../img/model1post.pdf')"
plotpost(β1,cnames=["Intercept","slope"]);
R"dev.off()"



# Model II: logit link
function loglike2(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = invlogit.(Xb)
  sum([ logpdf(Binomial(m[i],mu[i]),y[i]) for i in 1:N ])
end
@time model2 = glm(y, X, Σᵦ*.5, loglike2, B=2000,burn=10000);
summary(model2)
β2 = hcat(map(m -> m.β, model2.post_params)...)'
R"pdf('../img/model2post.pdf')"
plotpost(β2,cnames=["Intercept","slope"]);
R"dev.off()"

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
R"pdf('../img/model3post.pdf')"
plotpost(β3,cnames=["Intercept","slope"]);
R"dev.off()"

R"pdf('../img/alpha.pdf')"
plotpost(α);
R"dev.off()"

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

R"pdf('../img/curve.pdf')"
# Cloglog
p1 = predict_p(x0,β1,invcloglog)
p1_ci = mapslices(p -> quantile(p,[.025,.975]), p1, 2)
plot(x0,mean(p1,2),xlab="",ylab="",fg="grey",bty="n",col=2,typ="l",lwd=4,
     main="Dose-response Curves")
color_btwn(x0,p1_ci[:,1],p1_ci[:,2],from=minimum(x0),to=maximum(x0),rgb(1,0,0,.2))

# Logit
p2 = predict_p(x0,β2,invlogit)
p2_ci = mapslices(p -> quantile(p,[.025,.975]), p2, 2)
lines(x0,mean(p2,2),xlab="",ylab="",fg="grey",bty="n",col="darkgreen",lwd=4)
color_btwn(x0,p2_ci[:,1],p2_ci[:,2],from=minimum(x0),to=maximum(x0),rgb(0,1,0,.2))

# Modified Logit
p3 = predict_p(x0,β3,α)
p3_ci = mapslices(p -> quantile(p,[.025,.975]), p3, 2)
lines(x0,mean(p3,2),xlab="",ylab="",fg="grey",bty="n",col=4,lwd=4)
color_btwn(x0,p3_ci[:,1],p3_ci[:,2],from=minimum(x0),to=maximum(x0),rgb(0,0,1,.2))

R"""
points(beetles$logDose,beetles$prob,pch=20,col='grey30',cex=2)
legend("topleft",legend=c("Data","cloglog","logit","modified-logit"),cex=2,text.col=c("grey30",2:4), bty='n')
""";
R"dev.off()";



# Lethal Dose ##################################
function cloglog(p::Float64)
  assert(0<p<1)
  return log(-log(1-p))
end
function logit(p::Float64)
  assert(0<p<1)
  return log(p/(1-p))
end
function logit(p::Float64,a::Vector{Float64})
  assert(0<p<1)
  return log(p.^(1./α) ./ (1-p.^(1./α)))
end

ld(q::Float64,β::Matrix{Float64},link) = (link(q) - β[:,1]) ./ β[:,2]
function ld(q::Float64,β::Matrix{Float64},link,θ)
  return (link(q,θ) - β[:,1]) ./ β[:,2]
end

ld_50_1 = ld(.5, β1, cloglog)  # red
ld_50_2 = ld(.5, β2, logit)    # green
ld_50_3 = ld(.5, β3, logit, α) # blue

R"""
pdf("../img/ld.pdf")
color.den(density($ld_50_1),lwd=3,
          from=quantile($ld_50_1,.025),to=quantile($ld_50_1,.975),
          col.area=rgb(1,0,0,.3),col.den='red',
          col.main="grey30", fg='grey',bty='n',
          main='Lethal Dose (50%)',
          xlim=range(c($ld_50_1,$ld_50_2,$ld_50_3)))
color.den(density($ld_50_2),lwd=3,
          from=quantile($ld_50_2,.025),to=quantile($ld_50_2,.975),
          add=TRUE,col.area=rgb(0,1,0,.3),col.den='green')
color.den(density($ld_50_3),lwd=3,
          from=quantile($ld_50_3,.025),to=quantile($ld_50_3,.975),
          add=TRUE,col.area=rgb(0,0,1,.3),col.den='blue')
legend("topleft",legend=c("cloglog","logit","modified-logit"),
       cex=1.5,text.col=2:4, bty='n')
       dev.off()
""";

# Model I other independent normal priors
β_logprior1(β::Vector{Float64}) = (-(β-100)' * (β-100)/2)[1]
β_logprior2(β::Vector{Float64}) = (-(β-100)' * (β-100)/(2*100))[1]
β_logprior3(β::Vector{Float64}) = (-(β-100)' * (β-100)/(2*100000))[1]
@time model1_1 = glm(y,X,Σᵦ*.05,loglike1,β_logprior=β_logprior1, B=2000,burn=10000);
@time model1_2 = glm(y,X,Σᵦ*.3,loglike1,β_logprior=β_logprior2, B=2000,burn=10000);
@time model1_3 = glm(y,X,Σᵦ*.3,loglike1,β_logprior=β_logprior3, B=2000,burn=10000);

BayesLM.latex(summary(model1))
BayesLM.latex(summary(model1_1))
BayesLM.latex(summary(model1_2))

BayesLM.latex(summary(model2))
BayesLM.latex(summary(model3))

const pp = y ./ m
pred_1 =  predict_p(X[:,2], β1, invcloglog)
pred_2 =  predict_p(X[:,2], β2, invlogit)
pred_3 =  predict_p(X[:,2], β3, α)
r1 = pp .- pred_1
r2 = pp .- pred_2
r3 = pp .- pred_3

sse_1 = vec(mapslices(x -> sqrt(mean(x.^2)), r1, 1)) 
sse_2 = vec(mapslices(x -> sqrt(mean(x.^2)), r2, 1)) 
sse_3 = vec(mapslices(x -> sqrt(mean(x.^2)), r3, 1)) 


R"""
post.lines <- function(v,...) {
  qt <- quantile(v,c(.025,.975))
  color.den(density(v),from=qt[1],to=qt[2],...)
}
"""

R"pdf('../img/resid.pdf')"
R"post.lines($sse_1,col.area=rgb(1,0,0,.4),lwd=3,col.den='red',xlim=c(.02,.1),fg='grey',bty='n',main='RMSE')"
R"post.lines($sse_2,col.area=rgb(0,1,0,.4),lwd=3,col.den='green',add=TRUE)"
R"post.lines($sse_3,col.area=rgb(0,0,1,.4),lwd=3,col.den='blue',add=TRUE)"
R"legend('topright',legend=c('cloglog','logit','modified-logit'), cex=1.5,text.col=2:4, bty='n')"
R"dev.off()"

mean(sse_1 - sse_2 .< 0)
mean(sse_3 - sse_2 .< 0)
mean(sse_3 - sse_1 .< 0)

# Quad Loss
function loss(truth::Vector{Float64}, postpred::Matrix{Float64}, K::Int=10000000)
  return sum(var(postpred,2) + K/(K+1) * (truth - mean(postpred,2)).^2)
end

loss(pp, pred_1, 1000) # cloglog
loss(pp, pred_2, 1000) # logit 
loss(pp, pred_3, 1000) # modified logit
