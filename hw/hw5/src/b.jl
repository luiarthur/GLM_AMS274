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

function lpλ(λ::Float64)
  return λ<0 ? -Inf : -2*log(1+λ)
end

(csλ, csβ) = (1.0, .5)
mod = HierPois.fit(y, X, csβ, lpλ, csλ, 2000, 10000, printEvery=100)

β = hcat(map(m -> m.β, mod)...)'
μ = hcat(map(m -> m.μ, mod)...)'
λ = map(m -> m.λ, mod)

println("Acc β: ", size(unique(β,1),1) / size(β,1))
println("Acc λ: ", length(unique(λ)) / length(λ))

R"plotPosts($β)";
R"plotPost($λ)";


#=
include("b.jl")
=#
