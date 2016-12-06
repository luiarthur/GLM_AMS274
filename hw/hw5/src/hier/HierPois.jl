module HierPois

include("MCMC.jl")
using Distributions

export fit, sym

sym(M::Matrix{Float64}) = (M'+M)/2

immutable State
  β::Vector{Float64}
  μ::Vector{Float64}
  λ::Float64
end

rig(a::Float64, b::Float64) = rand(Gamma(a,1/b))


"""
  hierarchical poisson model fitter

  fit(y::Vector{Float64}, X::Matrix{Float64}, csβ::Float64,
      logpriorλ, csλ::Float64,
      B::Int, burn::Int; printEvery::Int=0)

  return (β,μ,λ,accβ,accλ)

  Assumes flat prior for β
"""
function fit(y::Vector{Float64}, X::Matrix{Float64}, csβ::Float64,
             logpriorλ, csλ::Float64,
             B::Int, burn::Int; printEvery::Int=0)

  const (N,K) = size(X)

  assert(length(y) == N)

  const stepβ = sym(inv(X'X)) * csβ
  const init = State(zeros(K), ones(N), 1.0)

  function update(s::State)
    # update β
    function llβ(β::Vector{Float64})
      const exb = exp(X*β)
      return sum(logpdf(Gamma(s.λ, exb[i]/s.λ), s.μ[i]) for i in 1:N)
    end
    lpβ(β::Vector{Float64}) = 0.0
    newβ = MCMC.metropolis(s.β, llβ, lpβ, stepβ)
    const exb = exp(X*newβ)

    # update μ
    newμ = [ rig(s.λ+y[i], s.λ/exb[i] + 1) for i in 1:N ]

    # update λ
    function llλ(λ::Float64)
      return λ<0 ? -Inf : sum(logpdf(Gamma(λ, exb[i]/λ), newμ[i]) for i in 1:N)
    end
    newλ = MCMC.metropolis(s.λ, llλ, logpriorλ, csλ)

    return State(newβ, newμ, newλ)
  end

  const post_params = MCMC.gibbs(init, update, B, burn, printFreq=printEvery)
  const β = hcat(map(m -> m.β, post_params)...)'
  const μ = hcat(map(m -> m.μ, post_params)...)'
  const λ = map(m -> m.λ, post_params)

  const accβ = size(unique(β,1),1) / size(β,1)
  const accλ = length(unique(λ)) / length(λ)

  return (β,μ,λ,accβ,accλ)
end

function predict(X0::Matrix{Float64},β::Matrix{Float64}, inv_link)
  inv_link.(X0 * β)
end

end # module hierPois
