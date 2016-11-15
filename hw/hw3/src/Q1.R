library(rcommon)

# Read Data
beetles <- read.csv("dat/beetles.dat",skip=1)
beetles$prob <- beetles$numDied/beetles$numBeetles

# Exploratory Analysis
my.pairs(beetles[,c("logDose","prob")])

# Fit models
link <- c("logit","probit","cloglog")
models <- lapply(as.list(link), function(lnk){
  glm(prob~logDose, 
      weights=numBeetles, 
      family=binomial(link=lnk),
      data=beetles)
})
names(models) <- sapply(models,function(m) m$family$link)

# Residual Analysis: mean squared deviance residuals
dev_resid <- lapply(models,function(x) resid(x,type="deviance"))
sapply(dev_resid,function(x) mean(x^2))

# Pred_Pi
pred_pi <- sapply(models,predict,type="response")
plot(beetles$prob,pred_pi[,1],ylim=0:1,type='n',fg='grey',bty='n',
     ylab="pi hat",xlab="observed probability")
for (i in 1:3) 
  points(beetles$prob,pred_pi[,i],pch=i+1,cex=2,lwd=3,col='grey30')
abline(0,1,col='grey')
legend("bottomright",legend=link,pch=2:4,cex=2,
       col='grey', text.col='grey',box.col='grey')

## grid predictions
xx <- seq(1.65, 1.9, length=100)
pred_pi_grid<-sapply(models,predict,newdata=list(logDose=xx),type="response")
plot(xx,pred_pi_grid[,1],ylim=0:1,type='n',fg='grey',bty='n',
     ylab="pi hat grid",xlab="observed probability")
for (i in 1:3) 
  lines(xx,pred_pi_grid[,i],col=i+1,lwd=3)
abline(0,1,col='grey')
points(beetles$logDose,beetles$prob,pch=20,col='grey30',cex=2)
legend("bottomright",legend=c("Data",link),cex=2,text.col=c("grey30",2:4),
       bty='n')
