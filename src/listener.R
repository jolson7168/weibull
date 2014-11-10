#source("/home/ec2-user/git/rservice/src/listener2.R")
#inJSON <- paste('{"failTimes":[149971, 70808, 133518, 145658,175701, 50960, 126606, 82329],"bFactors":[0.1,0.01]}')


library(httpuv)
library(jsonlite)
library(survival)
library(abrem)


calcWeibull <- function(fTimeVector,bFactors) {
	d <- data.frame(ob=fTimeVector, state=1) 
	s <- Surv(d$ob,d$state)
	sr <- survreg(s~1,dist="weibull")
	beta <- (1/sr$scale)
	eta <- exp(sr$coefficients[1])
	v <- qweibull(bFactors,beta,eta)
	return(v)
}

doWeibull <-function(bodyStr) {

	inData <- fromJSON(bodyStr)
	results <- calcWeibull(inData$failTimes,inData$bFactors)
	return(paste(toJSON(data.frame(inData$bFactors, results), pretty=TRUE)))

}


	.lastMessage <- NULL
app <- list(
	call = function(req) {
		wsUrl = paste(sep='','"',"ws://",ifelse(is.null(req$HTTP_HOST), req$SERVER_NAME, req$HTTP_HOST),'"')
		print(req$REQUEST_METHOD)
		bod <- req[["rook.input"]]
		postdata <- bod$read_lines()
		list(
			status = 200L,
			headers = list(
				'Content-Type' = 'application/json'
			),
			body = paste(doWeibull(postdata))
		)
	},

	onWSOpen = function(ws) {
		ws$onMessage(function(binary, message) {
			.lastMessage <<- message
			ws$send(message)
		})
	}
)
server <- runServer("0.0.0.0", 5729, app, interruptIntervalMs = ifelse(interactive(), 100,1000))
print(server)
