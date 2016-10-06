module NewtonRaphson

using Lazy
export optim

"""
    optim(init, update; eps=1E-3, maxIts=1000, printIts=false)

Newton Raphson Optimizer finds maxima by iteratively computing

``θ_{new} = θ_{old} - f(θ_{old})``
 
where ``f(x) = t'(x)/ t''(x)``.

The algorithm stops when either

* convergence has occured, OR
* the number of iterations takes too long (> maxIts).

# Arguments
* `init::Real`    : initial value for newton raphson optimizer
* `update`        : is the function ``t'(θ) / t''(θ)``
* `eps::Real`     : how much the current iteration has to be to the 
                    previous before stopping. (default: 1000)
* `maxIts::Int`   : maximum number of iterations before stopping. (default: 1000)
* `printIts::Bool`: whether or not info should be printed. (default: false)

"""
function optim(init, update; eps=1E-3, maxIts = 1000, printIts = false)

  @bounce function loop(t0,it)
    t1 = t0 - update(t0)

    if it == maxIts
      warn("Iteration: ",it," - Not Converged.")
      t1
    elseif abs(t1-t0) < eps
      println("Converged in ",it," iterations.")
      t1
    else
      loop(t1,it+1)
    end

  end

  loop(init,1)
end

end
