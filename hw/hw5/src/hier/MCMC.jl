module MCMC

import Distributions.Normal, Distributions.MvNormal
export gibbs, metropolis

"""
generic gibbs sampler
"""
function gibbs{T}(init::T, update, B::Int, burn::Int; printFreq::Int=0)
  const out = Vector{T}(B)
  out[1] = init

  for i in 2:(B+burn)
    if i <= burn + 1
      out[1] = update(out[1])
    else
      out[i-burn] = update(out[i-burn-1])
    end

    if printFreq > 0 && i % printFreq == 0
      print("\rProgress: ",i,"/",B+burn)
    end
  end

  return out
end

"""
metropolis step with normal proposal
"""
function metropolis(curr::Float64, ll, lp, cs::Float64)

  const cand = rand(Normal(curr,cs))

  if ll(cand) + lp(cand) - ll(curr) - lp(curr) > log(rand())
    new_state = cand
  else
    new_state = curr
  end

  return new_state
end

"""
metropolis step with multivariate normal proposal
"""
function metropolis(curr::Vector{Float64}, ll, lp, candΣ::Matrix{Float64})

  const cand = rand( MvNormal(curr,candΣ) )

  if ll(cand) + lp(cand) - ll(curr) - lp(curr) > log(rand())
    new_state = cand
  else
    new_state = copy(curr) # is the copy necessary?
  end

  return new_state
end


end # module MCMC
