srand(274);

using RCall
include("hier/HierPois.jl")

R"library(rcommon)";
R"library(fields)";
R"fabric <- read.table('data/fabric.txt', skip=4, header=TRUE)";
R"summary(glm(faults ~ length, data=fabric, family=poisson))"
@rget fabric

const N = size(fabric,1)
const X = [ ones(N) fabric[:length] ]
const y = fabric[:faults] * 1.
const Σᵦ = HierPois.sym(inv(X'X)) 

function ldgammaMeanVar(x::Float64,m::Float64,s2::Float64)
  return x<0 ? -Inf : (m^2/s2-1)*log(x) - (m/s2)*x
end

J = 20
R"param_grid <- as.matrix(expand.grid(seq(1,20,len=$J),seq(1,100,len=$J)))"
@rget param_grid
λ_mean = zeros(size(param_grid,1))
λ_sd = zeros(size(param_grid,1))

function onesim(i::Int)
  md = HierPois.fit(y, X, .5, 
                    λ-> ldgammaMeanVar(λ,param_grid[i,1],param_grid[i,2]),
                    10.0, 1000, 10000, printEvery=0);
  λ_mean[i] = mean(md[3])
  λ_sd[i] = std(md[3])
  print("\r",i)
end

@time onesim.(1:length(λ_mean));

R"pdf('../img/sensitivityMean.pdf')"
R"quilt.plot(x=$param_grid[,1],y=$param_grid[,2],z=ifelse($λ_mean<30,$λ_mean,30),xlab='prior mean',ylab='prior variance',fg='grey',main=expression(~'Posterior mean for'~lambda))";
R"dev.off()"

R"pdf('../img/sensitivitySD.pdf')"
R"quilt.plot(x=$param_grid[,1],y=$param_grid[,2],z=$λ_sd,xlab='prior mean',ylab='prior variance',fg='grey',main=expression(~'Posterior SD for'~lambda))";
R"dev.off()"
