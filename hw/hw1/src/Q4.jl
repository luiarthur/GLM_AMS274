include("NewtonRaphson.jl")

module Q4

using RCall, NewtonRaphson, DataFrames

function J_gen(x,b)
  J11 = sum( exp(b[1] + b[2]*x) )
  J12 = sum( exp(b[1] + b[2]*x) .* x )
  J22 = sum( exp(b[1] + b[2]*x) .* (x.^2) )

  [ [J11, J12] [J12, J22] ]
end

function U_gen(x,y,b)
  U1 = sum(  -exp(b[1] + b[2]*x) .+ y )
  U2 = sum( (-exp(b[1] + b[2]*x) .+ y ).* x )
  [U1, U2]
end

function update_gen(x,y,b0)
  J(b) = J_gen(x,b)
  U(b) = U_gen(x,y,b)

  -inv(J(b0)) * U(b0)
end

(dat, col_header) = readdlm("dat/q3.dat",',',header=true)
x = log(dat[:,1])
y = dat[:,2]

update(b) = update_gen(x,y,b)

# Run -----------------------------------
println("My Implementation")
println(optim([0,0],update))
println()

# R
@rput x y
#R"plot(x,y)"
println(R"mod <- glm(y~x, family='poisson')")

end # module Q4

#=
include("Q4.jl")
=#
