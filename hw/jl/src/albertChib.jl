import Distributions.TruncatedNormal
import MCMC

# INCOMPLETE. Refer to advBayesComputing/hw/hw2/code/C++/albertChib.cpp

function albertChib_update_z(y,x,b)
  n = length(y)
  z = zeros(Int,n)

  eq0_inds = find(zi->zi==0,z)
  eq1_inds = find(zi->zi==1,z)
  
  z[eq0_inds] = rand(TruncatedNormal(x*b,1,-Inf,0),length(eq0_inds))
  z[eq1_inds] = rand(TruncatedNormal(x*b,1,0,Inf),length(eq0_inds))

  return z
end
