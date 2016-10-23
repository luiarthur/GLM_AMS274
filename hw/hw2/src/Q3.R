fabric <- read.table("dat/fabric.dat",skip=4,header=TRUE)

# 3a
pmod <- glm(faults ~ length, data=fabric, family="poisson")
summary(pmod)

# 3b
qpmod <- glm(faults ~ length, data=fabric, family="quasipoisson")
summary(qpmod)

# qpmod estimates the same. std error for intercept is larger in qpmod. 
# dipersion parameter was 2.12
