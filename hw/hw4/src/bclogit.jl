function bclogit(y::Vector{Int}, X::Matrix{Float64}, m::Vector{Int}, cs::Float64, 
                 B::Int, burn::Int; printFreq::int=0)

  function ll(y::Vector{Int}, Xβ::Vector{Float64}, θ::Hyper)

  end

  const Σ_β = inv(BayesLM.sym(X'X))

  return glm(y, X, cs * Σ_β, ll, B=B, burn=burn, printFreq)
end
