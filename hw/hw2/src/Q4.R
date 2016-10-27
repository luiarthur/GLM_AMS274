library(rcommon)

dat <- read.table("dat/ceriodaphnia.txt",header=FALSE)
colnames(dat) <- c("numOrg","conc","strain")
strainCol <- ifelse(dat[,3] == 1, rgb(0,0,1,.5),rgb(1,.5,0,.5))#, "steelblue", "orange")

mplot <- function(x,y,...) 
  plot(x,y,col=strainCol, pch=20, cex=3, fg='grey', bty='n', cex.lab=1.5,...)

pdf("../img/dat.pdf")
mplot(dat[,2],dat[,1], ylab="log( #Organisms )", xlab="conc")
legend("topright",legend=c("strain=1","strain=0"),cex=2,
       text.col=c("dodgerblue","orange"), text.font=2, bty='n')
dev.off()

pdf("../img/combo.pdf",w=13,h=7)
par(mfrow=c(2,3))
mplot(dat[,2],log(dat[,1]),       xlab="conc",ylab="LOG( #Organisms )")
mplot(dat[,2],sqrt(dat[,1]),      xlab="conc",ylab="SQRT( #Organisms )")
mplot(sqrt(dat[,2]),sqrt(dat[,1]),xlab="SQRT(conc)",ylab="SQRT( #Organisms )")
mplot(sqrt(dat[,2]),log(dat[,1]), xlab="SQRT(conc)",ylab="LOG( #Organisms )")
mplot(log(1+dat[,2]),sqrt(dat[,1]), xlab="LOG(1+conc)",ylab="SQRT( #Organisms )")
mplot(log(1+dat[,2]),log(dat[,1]),  xlab="LOG(1+conc)",ylab="LOG( #Organisms )")
par(mfrow=c(1,1))
dev.off()

mplot(dat[,2],2*sqrt(dat[,1]+3/8),       xlab="conc",ylab="log( #Organisms )")

m1 <- glm(numOrg~conc+strain,data=dat,family=poisson("log"))
m2 <- glm(numOrg~conc+strain,data=dat,family=poisson("sqrt"))
m3 <- glm(numOrg~sqrt(conc)+strain,data=dat,family=poisson("sqrt"))
m4 <- glm(numOrg~sqrt(conc)+strain,data=dat,family=poisson("log"))
m5 <- glm(numOrg~log(1+conc)+strain,data=dat,family=poisson("sqrt"))
m6 <- glm(numOrg~log(1+conc)+strain,data=dat,family=poisson("log"))
m7 <- glm(numOrg~conc+strain+conc:strain,data=dat,family=poisson("log"))

get.bic <- function(s) s$aic + s$df[1]*log(sum(s$df[1:2])-2)

m <- list(m1,m2,m3,m4,m5,m6,m7)
s <- lapply(m,summary)

M <- matrix(0,5,7)
rownames(M) <- c("deviance","AIC","BIC","pearson-resids","deviance-resids")
for (i in 1:length(m)) {
  M[1,i] <- m[[i]]$deviance
  M[2,i] <- m[[i]]$aic
  M[3,i] <- get.bic(s[[i]])
  M[4,i] <- mean(resid(m[[i]],type="pearson")^2)
  M[5,i] <- mean(resid(m[[i]],type="deviance")^2)
}
round(M,4)

plot((dat[,2]),log(dat[,1]),col=strainCol,pch=20,cex=2)
points(dat[,2],predict(m1),col=strainCol,pch=4,cex=2,lwd=2)
points(dat[,2],predict(m7),col=strainCol,pch=4,cex=2,lwd=2)

plot((dat[,2]),sqrt(dat[,1]),col=strainCol,pch=20,cex=2)
points(dat[,2],predict(m2),col=strainCol,pch=4,cex=2,lwd=2)

plot((dat[,2]),dat[,1],col=strainCol,pch=20,cex=2)
points(dat[,2],predict(m1,type="response"),col=strainCol,pch=4,cex=2,lwd=2)
points(dat[,2],predict(m2,type="response"),col=strainCol,pch=4,cex=2,lwd=2)

plot(residuals(m1,type="pearson")); abline(h=0)
plot(residuals(m1,type="deviance")); abline(h=0)
