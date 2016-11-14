library(rcommon)

# Read Data
beetles <- read.csv("dat/beetles.dat",skip=1)
beetles$prob <- beetles$numDied/beetles$numBeetles

# Exploratory Analysis
my.pairs(beetles[,c("logDose","prob")])

# Fit models
models <- lapply(as.list(c("logit","probit","cloglog")), 
                 function(lnk){
  glm(prob~logDose, 
      weights=numBeetles, 
      family=binomial(link=lnk),
      data=beetles)
})

# Residual Analysis
dev_resid <- lapply(models,function(x) resid(x,type="deviance"))

par(mfrow=c(3,1))
lapply(dev_resid,plot)
par(mfrow=c(1,1))
