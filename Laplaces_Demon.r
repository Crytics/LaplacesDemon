###############################################
# Laplace's Demon
# ---------------------------------
# Created by  : Adam Nguyen
# Updated by  : Adam Nguyen
# Created at  : 11/04/2014
# Updated at  : xx/xx/xxxx
# Description : Standalone Bayesian Environment
###############################################

#Clear Envisubronment
#rm(list = ls(all = TRUE))

#update.packages(ask = FALSE, dependencies = c('Suggests'))

#Set Directory
setInternet2(TRUE)
Sys.setenv(language = "en", tz = 'UTC')
options(max.print = 500)
setwd("C:/Users/adam.nguyen/Documents/GitHub/LaplacesDemon")
source(paste(c("C:/Users/adam.nguyen/Desktop/R/GH/", "library.R"), collapse = "")) #Get library
source(paste(c("C:/Users/adam.nguyen/Desktop/R/GH/", "break_munging.txt"), collapse = "")) #Get tools

#Install relevant libraries
#install.packages("devtools")
#install_github("Statisticat/LaplacesDemon")
library(devtools)
library(LaplacesDemon)

#Import data
data(demonsnacks)

#Convert dataframe into list
N <- nrow(demonsnacks)
J <- ncol(demonsnacks)
y <- log(demonsnacks$Calories)
X <- cbind(1, as.matrix(demonsnacks[,c(1,3:10)]))
for (j in 2:J) {X[,j] <- CenterScale(X[,j])}
mon.names <- c("LP","sigma")
parm.names <- as.parm.names(list(beta=rep(0,J), log.sigma=0))
MyData <- list(J=J, X=X, mon.names=mon.names, parm.names=parm.names, y=y)

#Laplace's Demon estimation of Bayesian model of specified likelihood
Model <- function(parm, Data)
{
### Parameters
beta <- parm[1:Data$J]
sigma <- exp(parm[Data$J+1])
### Log(Prior Densities)
beta.prior <- dnormv(beta, 0, 1000, log=TRUE)
sigma.prior <- dhalfcauchy(sigma, 25, log=TRUE)
### Log-Likelihood
mu <- tcrossprod(beta, Data$X)
LL <- sum(dnorm(Data$y, mu, sigma, log=TRUE))
### Log-Posterior
LP <- LL + sum(beta.prior) + sigma.prior
Modelout <- list(LP=LP, Dev=-2*LL, Monitor=c(LP,sigma), yhat=mu,
parm=parm)
return(Modelout)
}

#Initiate setting
Initial.Values <- c(rep(0,J), log(1))
set.seed(666)

#Awaken the Demon
Fit <- LaplacesDemon(Model, Data=MyData, Initial.Values,
Covar=NULL, Iterations=2000, Status=100, Thinning=2,
Algorithm="AMWG", Specs=list(Periodicity=10))

#Demonic Suggestion
str(Fit)
Fit
Consort(Fit)

#Appeasing the Demon
Initial.Values <- as.initial.values(Fit)
Fit <- LaplacesDemon(Model, Data=MyData, Initial.Values,
     Covar=NULL, Iterations=60000, Status=244, Thinning=60,
     Algorithm="CHARM", Specs=NULL)
Consort(Fit)

#Appeasing the Demon Twice
Initial.Values <- as.initial.values(Fit)
Fit <- LaplacesDemon(Model, Data=MyData, Initial.Values,
     Covar=NULL, Iterations=420000, Status=62500, Thinning=420,
     Algorithm="CHARM", Specs=list(alpha.star=0.44))
Consort(Fit)

#Visions of the Demon
BurnIn <- Fit$Rec.BurnIn.Thinned
plot(Fit, BurnIn, MyData, PDF=FALSE, Params=Fit$Parameters)
caterpillar.plot(Fit, Parms=1:10)
Pred <- predict(Fit, Model, MyData)
summary(Pred, Discrep="Chi-Square")
plot(Pred, Style="Density", Rows=1:9)
