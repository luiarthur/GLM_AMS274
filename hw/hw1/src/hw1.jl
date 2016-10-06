include("NewtonRaphson.jl")

using Distributions, NewtonRaphson

y = [ -.774, .597, 7.575, .397, -.865, -.318, -.125, .961, 1.039 ]
n = length(y)

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

# update function for for newton raphson
update(t::Real) = t1(y,t) / t2(y,t)

# updates for scoring method
J(x,t) = -length(x)/8
score(t::Real) = t1(y,t) / J(y,t)

#=
include("hw1.jl")

using RCall

B = 100000
@rput loglike B


R" xx <- seq(-5,8,length=B) "
R" ll <- sapply(xx,loglike) "
R"""plot(xx,ll,type='l',fg='grey',bty='n',cex.lab=1.3,
         xlab=expression(theta),ylab='likelihood',lwd=2,
         col='grey30')"""
R" mx <- xx[which.max(ll)] "
R" abline(v=mx,col='red',lwd=2) "
R"""legend('topright',legend=paste('maximum at theta =', round(mx,3)), 
           text.col='grey30',bty='n',cex=1.5)"""

# Newton
optim(0, update, eps=1E-3, maxIts = B, printIts=true)
optim(.18, update, eps=1E-3, maxIts = B, printIts=true)
optim(10, update, eps=1E-3, maxIts = B, printIts=true)

# Fisher
optim(0, score, eps=1E-3, maxIts = B, printIts=true)
optim(.18, score, eps=1E-3, maxIts = B, printIts=true)
optim(10, score, eps=1E-3, maxIts = B, printIts=true)

#---------------
y2 = [0.0, 5, 9]
loglike2(t) = loglike_gen(y2,t)
update2(t::Real) = t1(y2,t) / t2(y2,t)
score2(t::Real) = t1(y2,t) / J(y2,t)

@rput loglike2

R" xx <- seq(-20,20,length=B) ";
R" ll <- sapply(xx,loglike2) ";
R"""plot(xx,ll,type='l',fg='grey',bty='n',cex.lab=1.3,
         xlab=expression(theta),ylab='likelihood',lwd=2,
         col='grey30')"""
R" mx <- xx[which.max(ll)] "
R" abline(v=mx,col='red',lwd=2) "
R"""legend('topleft',legend=paste('maximum at theta =', round(mx,3)), 
           text.col='grey30',bty='n',cex=1.5)"""

# Newton 
optim(-1,   update2, eps=1E-3, maxIts = B, printIts=true)
optim(4.67, update2, eps=1E-3, maxIts = B, printIts=true)
optim(10,   update2, eps=1E-3, maxIts = B, printIts=true)

# Fisher
optim(-1,   score2, eps=1E-3, maxIts = B, printIts=true)
optim(4.67, score2, eps=1E-3, maxIts = B, printIts=true)
optim(10,   score2, eps=1E-3, maxIts = B, printIts=true)

=#
