library(rcommon)

dat <- read.table("dat/ceriodaphnia.txt",header=FALSE)
colnames(dat) <- c("numOrg","conc","strain")
strainCol <- ifelse(dat[,3] == 1, rgb(0,0,1,.5),rgb(1,.5,0,.5))#, "steelblue", "orange")

mplot <- function(x,y,...) 
  plot(x,y,col=strainCol, pch=20, cex=3, fg='grey', bty='n',...)

mplot(dat[,2],dat[,1], ylab="log( #Organisms )", xlab="conc")
legend("topright",legend=c("strain=1","strain=0"),cex=2,
       text.col=c("dodgerblue","orange"), text.font=2, bty='n')


par(mfrow=c(3,2))
mplot(dat[,2],log(dat[,1]),       xlab="conc",ylab="log( #Organisms )")
mplot(dat[,2],sqrt(dat[,1]),      xlab="conc",ylab="sqrt( #Organisms )")
mplot(sqrt(dat[,2]),sqrt(dat[,1]),xlab="sqrt(conc)",ylab="sqrt( #Organisms )")
mplot(sqrt(dat[,2]),log(dat[,1]), xlab="sqrt(conc)",ylab="log( #Organisms )")
mplot(log(1+dat[,2]),sqrt(dat[,1]), xlab="log(1+conc)",ylab="sqrt( #Organisms )")
mplot(log(1+dat[,2]),log(dat[,1]),  xlab="log(1+conc)",ylab="log( #Organisms )")
par(mfrow=c(1,1))

plot(log(dat[,2]+10),sqrt(dat[,1]),col=strainCol,pch=20,cex=2)
  
m1 <- glm(numOrg~conc+strain,data=dat,family=poisson("log"))
m2 <- glm(numOrg~conc+strain,data=dat,family=poisson("sqrt"))
m3 <- glm(numOrg~sqrt(conc)+strain,data=dat,family=poisson("sqrt"))
m4 <- glm(numOrg~sqrt(conc)+strain,data=dat,family=poisson("log"))
m5 <- glm(numOrg~log(1+conc)+strain,data=dat,family=poisson("sqrt"))
m6 <- glm(numOrg~log(1+conc)+strain,data=dat,family=poisson("log"))
m7 <- glm(numOrg~conc+strain+conc:strain,data=dat,family=poisson("log"))

summary(m1)
summary(m2)
summary(m3)
summary(m4)
summary(m5)
summary(m6)
summary(m6)


plot((dat[,2]),log(dat[,1]),col=strainCol,pch=20,cex=2)
points(dat[,2],predict(m1),col=strainCol,pch=4,cex=2,lwd=2)
points(dat[,2],predict(m7),col=strainCol,pch=4,cex=2,lwd=2)

plot((dat[,2]),sqrt(dat[,1]),col=strainCol,pch=20,cex=2)
points(dat[,2],predict(m2),col=strainCol,pch=4,cex=2,lwd=2)

plot((dat[,2]),dat[,1],col=strainCol,pch=20,cex=2)
points(dat[,2],predict(m1,type="response"),col=strainCol,pch=4,cex=2,lwd=2)
points(dat[,2],predict(m2,type="response"),col=strainCol,pch=4,cex=2,lwd=2)
