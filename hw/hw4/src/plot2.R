plot2 <- function (x0, b_list, ylim=0:1, ...) {
  e1 <- exp(x0 %*% t(b_list[[1]]))
  e2 <- exp(x0 %*% t(b_list[[2]]))

  K <- ncol(x0)

  pi1 <- e1 / (1 + e1 + e2) # I
  pi2 <- e2 / (1 + e1 + e2) # O
  pi3 <-  1 / (1 + e1 + e2)  # F

  plot(x0[,K], apply(pi1,1,mean), type='n', ylim=ylim, fg='grey', 
     ylab='probability', xlab='length',las=1,...)

  lines(x0[,K], apply(pi1,1,mean), lwd=3, col='red')
  lines(x0[,K], apply(pi2,1,mean), lwd=3, col='green')
  lines(x0[,K], apply(pi3,1,mean), lwd=3, col='blue')

  color.btwn(x0[,K], apply(pi1,1,quantile,.025), apply(pi1,1,quantile,.975), 
             from=min(x0[,K]), to=max(x0[,K]), col=rgb(1,0,0,.3))
  color.btwn(x0[,K], apply(pi2,1,quantile,.025), apply(pi2,1,quantile,.975), 
             from=min(x0[,K]), to=max(x0[,K]), col=rgb(0,1,0,.3))
  color.btwn(x0[,K], apply(pi3,1,quantile,.025), apply(pi3,1,quantile,.975), 
             from=min(x0[,K]), to=max(x0[,K]), col=rgb(0,0,1,.3))
  legend("topleft",legend=c('Invertebrate','Other','Fish'),
         text.col=2:4,bty='n',cex=2)
}
