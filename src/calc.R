#http://www.openreliability.org/downloads/using_abrem_vignette_version.pdf
#http://www.openreliability.org/HTML/abrem.html

library(survival)
library(abrem)

d <- data.frame(ob=c(149971, 70808, 133518, 145658,175701, 50960, 126606, 82329), state=1) 
s <- Surv(d$ob,d$state)
sr <- survreg(s~1,dist="weibull")
beta <- (1/sr$scale)
eta <- exp(sr$coefficients[1])
print(paste("beta =", beta))
print(paste("eta =", eta)) 
