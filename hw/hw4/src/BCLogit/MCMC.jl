function gibbs{T}(init::T, update, B::Int, burn::Int; printFreq::Int=0)
  const out = Vector{T}( B+burn )
  out[1] = init
  for i in 2:(B+burn)
    out[i] = update(out[i-1])
    if printFreq > 0 && i % printFreq == 0
      print("\rProgress: ",i,"/",B+burn)
    end
  end
  out[ (burn+1):end ]
end

function metropolis(curr::Float64, cs::Float64, loglike_plus_logprior)

  const cand = rand( Distributions.Normal(curr,cs) )

  if loglike_plus_logprior(cand) - loglike_plus_logprior(curr) > log(rand())
    new_state = cand
  else
    new_state = curr
  end

  return new_state
end

function metropolis(curr::Vector{Float64}, candΣ::Matrix{Float64},
                    loglike_plus_logprior)

  const cand = rand( Distributions.MvNormal(curr,candΣ) )

  if loglike_plus_logprior(cand) - loglike_plus_logprior(curr) > log(rand())
    new_state = cand
  else
    new_state = copy(curr)
  end

  return new_state
end
