include("NewtonRaphson.jl")

module Q3

using RCall, NewtonRaphson
function plot(loglike,rng,B,legendPos)
  @rput rng loglike B legendPos
  R" xx <- seq(rng[1],rng[2],length=B) "
  R" ll <- sapply(xx,loglike) "
  R"""plot(xx,ll,type='l',fg='grey',bty='n',cex.lab=1.3,
           xlab=expression(theta),ylab='likelihood',lwd=2,
           col='grey30')""";
  R" mx <- xx[which.max(ll)] "
  R" abline(v=mx,col='red',lwd=2) ";
  R"""legend(legendPos,legend=paste('maximum at theta =', round(mx,3)), 
             text.col='grey30',bty='n',cex=1.3)""";
end;

function t1(x,t)
  num = 2*(x-t)
  denom = 1 + (x-t).^2
  sum( num ./ denom )
end

function t2(x,t)
  num = 2 * (x-t-1) .* (x-t+1)
  denom = (1 + (x-t).^2).^2
  - sum( num ./ denom )
end

# likelihood function:
function loglike_gen(x,t)
  n = length(x)
  -n*log(pi) - sum(log( 1 + (x-t).^2 ))
end
loglike(t) = loglike_gen(y,t)

### part b

# Data
y = [ -.774, .597, 7.575, .397, -.865, -.318, -.125, .961, 1.039 ]
# update function for for newton raphson
update(t::Real) = t1(y,t) / t2(y,t)
# updates for scoring method
J(x,t) = -length(x)/8
score(t::Real) = t1(y,t) / J(y,t)

### part c
y2 = [0.0, 5, 9]
loglike2(t) = loglike_gen(y2,t)
update2(t::Real) = t1(y2,t) / t2(y2,t)
score2(t::Real) = t1(y2,t) / J(y2,t)

### Run ---------------------------------------------------------------
B = 100000

# part b --------------------------------------------------------------
# Newton
println("Part b | newton | inits: 0, .18, 10 | eps = 1E-3")
println(NewtonRaphson.optim(0,   update, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(.18, update, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(10,  update, eps=1E-3, maxIts = B, printIts=true))
println()

# Scoring
println("Part b | scoring | inits: 0, .18, 10 | eps = 1E-3")
println(NewtonRaphson.optim(0,   score, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(.18, score, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(10,  score, eps=1E-3, maxIts = B, printIts=true))
println()

# part c --------------------------------------------------------------

# Newton 
println("Part c | newton | inits: 0, .18, 10 | eps = 1E-3")
println(NewtonRaphson.optim(-1,   update2, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(4.67, update2, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(10,   update2, eps=1E-3, maxIts = B, printIts=true))
println()

# Scoring
println("Part c | scoring | inits: 0, .18, 10 | eps = 1E-3")
println(NewtonRaphson.optim(-1,   score2, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(4.67, score2, eps=1E-3, maxIts = B, printIts=true))
println(NewtonRaphson.optim(10,   score2, eps=1E-3, maxIts = B, printIts=true))
println()

# plots ---------------------------------------------------------------

R"pdf('../img/sim.pdf',w=13,h=7)"
R"par(mfrow=c(1,2))"
plot(loglike, [-5,8], B,"topright")
plot(loglike2, [-20,20], B, "topleft")
R"par(mfrow=c(1,1))"
R"dev.off()"

end # module Q3

#=
include("Q3.jl")
=#
