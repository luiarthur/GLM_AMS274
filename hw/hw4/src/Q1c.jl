using BayesLM, RCall, Distributions
R"source('Q1.R')";
srand(274);

@rget mice;
const y1 = mice[:dead] * 1.;
const y2 = mice[:malformed] * 1.;
const m1 = mice[:numSubjects];
const m2 = mice[:n2];
const N = length(y1);
const X = [ones(N) mice[:conc]];
const Σᵦ = BayesLM.sym(inv(X'X));

function ll1(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = BayesLM.invLogit.(Xb)
  sum([ logpdf(Binomial(m1[i],mu[i]),y1[i]) for i in 1:N ])
end
function ll2(y::Vector{Float64},Xb::Vector{Float64},θ::Hyper)
  const mu = BayesLM.invLogit.(Xb)
  sum([ logpdf(Binomial(m2[i],mu[i]),y2[i]) for i in 1:N ])
end


@time mod1 = glm(Array(y1), X, Σᵦ*.1, ll1, B=2000,burn=10000);
@time mod2 = glm(Array(y2), X, Σᵦ*.5, ll2, B=2000,burn=10000);
s1 = summary(mod1)
s2 = summary(mod2)

BayesLM.latex(s1)
BayesLM.latex(s2)

x0 = collect(linspace(0,500,100))
function predict(x0::Vector{Float64}, β::Matrix{Float64}, inv_link)
  const x0b = [ones(x0) x0] * β'
  return inv_link.(x0b)
end

rho1 = predict(x0, hcat(map(m -> m.β, mod1.post_params)...)', BayesLM.invLogit)
rho2 = predict(x0, hcat(map(m -> m.β, mod2.post_params)...)', BayesLM.invLogit)
rho3 = 1 .- rho2

pi_1 = rho1
pi_2 = rho2 .* (1 .- pi_1)
pi_3 = 1 .- pi_1 .- pi_2

R"pdf('../img/bayesPred.pdf')"
R"""
plot(mice$conc, seq(0,1,length=length(mice$conc)),type='n', fg='grey', 
     xlab='concentration (mg/kg per day)', ylab='probability',
     las=1, main=expression(hat(pi)(x)),cex.main=2,ylim=c(0,1))
points(mice$conc, mice$dead/mice$numSubj, pch=20, col='red', cex=2)
points(mice$conc, mice$p2*(1-mice$p1), pch=20, cex=2, col='green')
points(mice$conc, 1-mice$p1-mice$p2*(1-mice$p1), pch=20, cex=2, col='blue')
legend("left",legend=c('Dead','Malformed','Normal'),bty='n',text.col=2:4,cex=2)


lines($x0, apply($pi_1,1,mean),col='red',lwd=3)
color.btwn($x0,apply($pi_1,1,quantile,.025),apply($pi_1,1,quantile,.975),
           from=0,to=500,col=rgb(1,0,0,.3))
lines($x0, apply($pi_2,1,mean),col='green',lwd=3)
color.btwn($x0,apply($pi_2,1,quantile,.025),apply($pi_2,1,quantile,.975),
           from=0,to=500,col=rgb(0,1,0,.3))
lines($x0, apply($pi_3,1,mean),col='blue',lwd=3)
color.btwn($x0,apply($pi_3,1,quantile,.025),apply($pi_3,1,quantile,.975),
           from=0,to=500,col=rgb(0,0,1,.3))
"""
R"dev.off()"

#=
include("Q1c.jl")
=#
