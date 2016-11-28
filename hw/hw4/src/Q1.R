source("loadRcommon.R")

mice <- read.csv("data/mice.csv")
mice$p1 <- mice$dead/mice$numSubj
mice$n2 <- mice$numSubj - mice$dead
mice$p2 <- mice$malf/mice$n2

mod1 <- glm(p1 ~ conc, 
            weights=numSubjects, 
            family=binomial(link=logit), data=mice)

mod2 <- glm(p2 ~ conc, 
            weights=n2,
            family=binomial(link=logit), data=mice)

newconc <- seq(0, 500, len=100)
predict(mod1,newdata=list(conc=newconc),type="response")
p1 <- predict(mod1,newdata=list(conc=newconc),type="response")
p2 <- predict(mod2,newdata=list(conc=newconc),type="response")
p3 <- 1 - p2

pi1 <- p1
pi2 <- p2 * (1-pi1)
pi3 <- 1 - pi1 - pi2

pdf("../img/freqPred.pdf")
plot(mice$conc, seq(0,1,length=length(mice$conc)),type='n', fg='grey', 
     xlab='concentration (mg/kg per day)', ylab='probability',
     las=1, main=expression(hat(pi)(x)),cex.main=2,ylim=c(0,1))
points(mice$conc, mice$dead/mice$numSubj, pch=20, col='red', cex=2)
lines(newconc, pi1, col='red', lwd=3)
points(mice$conc, mice$p2*(1-mice$p1), pch=20, cex=2, col='green')
lines(newconc, pi2, col='green', lwd=3)
points(mice$conc, 1-mice$p1-mice$p2*(1-mice$p1), pch=20, cex=2, col='blue')
lines(newconc, pi3, col='blue', lwd=3)
legend("left",legend=c('Dead','Malformed','Normal'),bty='n',text.col=2:4,cex=2)
dev.off()
