#http://www.openreliability.org/downloads/using_abrem_vignette_version.pdf
#http://www.openreliability.org/HTML/abrem.html
#source("/home/ec2-user/git/weibull/src/calc.R")
#"beta = 3.31363465580381"
#"eta = 130895.039243954" 
#"results= 66371.7972451016" "results= 32659.8667437512"

library(survival)
library(abrem)
library(jsonlite)

doWeibull <- function(fTimeVector,bFactors) {
	d <- data.frame(ob=fTimeVector, state=1) 
	s <- Surv(d$ob,d$state)
	sr <- survreg(s~1,dist="weibull")
	beta <- (1/sr$scale)
	eta <- exp(sr$coefficients[1])
	#print(paste("beta =", beta))
	#print(paste("eta =", eta)) 
	v <- qweibull(c(0.1,0.01),beta,eta)
	return(v)
}

inJSON <- paste('{"failTimes":[149971, 70808, 133518, 145658,175701, 50960, 126606, 82329],"bFactors":[0.1,0.01]}')
inData <- fromJSON(inJSON)

fTimeVector <- inData$failTimes
bFactors <- inData$bFactors

#results <- doWeibull(c(149971, 70808, 133518, 145658,175701, 50960, 126606, 82329),c(0.1,0.01))
results <- doWeibull(fTimeVector,bFactors)
outputObj <- data.frame(bFactors, results)
#outputObj$bFactors <- bFactors
#outputObj$timeEstimates <- results
outputStr <-  paste(toJSON(outputObj, pretty=TRUE))
print(outputStr)
