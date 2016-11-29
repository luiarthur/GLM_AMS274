function gibbs{T}(init::T, update, B::Int, burn::Int; printFreq::Int=0)
  const out = Array{T,1}( (B+burn) )
  out[1] = init
  for i in 2:(B+burn)
    out[i] = update(out[i-1])
    if printFreq > 0 && i % printFreq == 0
      print("\rProgress: ",i,"/",B+burn)
    end
  end
  out[ (burn+1):end ]
end
