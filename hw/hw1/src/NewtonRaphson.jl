module NewtonRaphson

  using Lazy
  export optim

  function optim(init,tprime,tprime2,eps=1E-3)
    @bounce function loop(t0)
      t1 = t0 - tprime(t0) / tprime2(t)
      if abs(t1-t0) < eps 
        t1
      else
        loop(t1)
      end
    end

    loop(init)
  end

end
