function fit(Y::Matrix{Int}, X::Matrix{Float64}, cs::Vector{Float64};
             B::Int=2000, burn::Int=10000, printFreq::Int=0)

  const (N,K) = size(X)

  assert( N == size(Y,1) )

  const J = size(Y,2)
  const stepSize_β = [cs[j] * sym(inv(X'X)) for j in 1:J-1]

  function ll(β::Vector{Vector{Float64}})
    out = 0.0
    for i in 1:N
      log_denom = log( sum([ 1 + exp(X[i,:]'β[j])[1] for j in 1:J-1]) )
      for j in 1:J-1
        out += Y[i,j] * ( (X[i,:]'β[j])[1] - log_denom )
      end
      out -= Y[i,J] * log_denom
    end
    return out
  end

  function update(β::Vector{Vector{Float64}})
    newβ = deepcopy(β)

    for j in 1:J-1
      const cand = rand(Distributions.MvNormal(newβ[j], stepSize_β[j]))
      newβ[j] = cand

      if ll(newβ) - ll(β) < log(rand())
        newβ[j] = copy(β[j])
      end
    end
    
    return newβ
  end

  const init = [zeros(K) for j in 1:J-1]

  gibbs(init, update, B, burn, printFreq=printFreq)

end
