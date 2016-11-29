module BCLogit

import Distributions

sym(M::Matrix{Float64}) = (M' + M) / 2

include("MCMC.jl")
include("fit.jl")
  
end
