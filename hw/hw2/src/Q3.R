fabric <- read.table("dat/fabric.dat",skip=4,header=TRUE)

plot(fabric$length, log(fabric$faults))

# 3a
pmod <- glm(faults ~ length, data=fabric, family="poisson")
summary(pmod)

# 3b
qpmod <- glm(faults ~ length, data=fabric, family="quasipoisson")
summary(qpmod)

# Comment on differences:
# qpmod estimates the same. std error for intercept is larger in qpmod. 
# dipersion parameter was 2.12

# 3c
x0a <- list(length=500)
ppa <- predict(pmod,newdata=x0a,se.fit=TRUE)
pqa <- predict(qpmod,newdata=x0a,se.fit=TRUE)

x0b <- list(length=995)
ppb <- predict(pmod,newdata=x0b,se.fit=TRUE)
pqb <- predict(qpmod,newdata=x0b,se.fit=TRUE)


Ji <- function(b,x) {
  J11 <- sum(exp(b[1] + x*b[2]))
  J12 <- sum(exp(b[1] + x*b[2]) * x)
  J22 <- sum(exp(b[1] + x*b[2]) * x^2)
  solve(matrix(c(J11,J12,J12,J22),2,2))
}

ji <- Ji(coef(pmod), fabric$length)

sqrt(diag(ji))
phi <- 2.121965
summary(qpmod)
sqrt(diag(ji) * phi)

sqrt(phi * t(c(1,x0a[[1]])) %*% ji %*% c(1,x0a[[1]]))
pqa$se.fit
sqrt(phi * t(c(1,x0b[[1]])) %*% ji %*% c(1,x0b[[1]]))
pqb$se.fit
sqrt(t(c(1,x0a[[1]])) %*% ji %*% c(1,x0a[[1]]))
ppa$se.fit
sqrt(t(c(1,x0b[[1]])) %*% ji %*% c(1,x0b[[1]]))
ppb$se.fit

ppa$fit + qnorm(c(.025,.975)) * sqrt(1 * t(c(1,x0a[[1]])) %*% ji %*% c(1,x0a[[1]]))[1]
ppb$fit + qnorm(c(.025,.975)) * sqrt(1 * t(c(1,x0b[[1]])) %*% ji %*% c(1,x0b[[1]]))[1]
pqa$fit + qnorm(c(.025,.975)) * sqrt(phi * t(c(1,x0a[[1]])) %*% ji %*% c(1,x0a[[1]]))[1]
pqb$fit + qnorm(c(.025,.975)) * sqrt(phi * t(c(1,x0b[[1]])) %*% ji %*% c(1,x0b[[1]]))[1]

ci <- function(pred) pred$fit + qnorm(c(.025,.975)) * pred$se.fit

ci(ppa)
ci(ppb)
ci(pqa)
ci(pqb)

plot(fabric$length, log(fabric$faults), pch=20, col="grey", cex=3)
points(fabric$length, predict(pmod),  pch=4, cex=2)
points(fabric$length, predict(qpmod), pch=4, cex=2)
