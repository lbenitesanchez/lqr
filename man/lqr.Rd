\name{lqr}
\alias{lqr}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Robust Linear Quantile Regression
}
\description{
It fits a robust linear quantile regression model using a new family of zero-quantile distributions for the error term. This family of distribution includes skewed versions of the Normal, Student's t, Laplace, Slash and Contaminated Normal distribution. It provides estimates and full inference. It also provides envelopes plots for assessing the fit and confidences bands when several quantiles are provided simultaneously.
}
\usage{
lqr(y,x,p=0.5,dist="normal",nu="",gama="",precision=10^-6,envelope=FALSE,CI=0.95)

#lqr(y, x, p = 0.5, dist = "normal")
#lqr(y, x, p = 0.5, dist = "t")
#lqr(y, x, p = 0.5, dist = "laplace")
#lqr(y, x, p = 0.5, dist = "slash")
#lqr(y, x, p = 0.5, dist = "cont")

#lqr(y, x, p = c(0.25,0.50,0.75), dist = "normal")
}

\arguments{
  \item{y}{
the response vector of dimension \eqn{n} where \eqn{n} is the total of observations.
}
\item{x}{
design matrix for the fixed effects of dimension \eqn{N x d} where \eqn{d} represents the number of fixed effects including the intercept, if considered.
}\item{p}{
An unique quantile or a set of quantiles related to the quantile regression.
}
  \item{dist}{
represents the distribution to be used for the error term. The values are \code{normal} for Normal distribution, \code{t} for Student's t distribution, \code{laplace} for Laplace distribution, \code{slash} for Slash distribution and \code{cont} for the Contaminated normal distribution.
}
\item{nu}{
It represents the degrees of freedom when \code{dist = t}. For the Slash distribution (\code{dist = slash}) it is a shape parameter \eqn{\nu>0}. For the Contaminated Normal distribution, \eqn{\nu} is the parameter that represents the percentage of outliers. When is not provided, we use the MLE.
}
  \item{gama}{
It represents a scale factor for the contaminated normal distribution. When is not provided, we use the MLE.
}
  \item{precision}{
The convergence maximum error permitted. By default is 10^-6.
}
  \item{envelope}{
if \code{TRUE}, it will show a confidence envelope for a curve based on bootstrap replicates.
By default it is \code{TRUE} when just one quantile is provided.
If a grid of quantiles is provided it will be \code{FALSE} by default.
}
  \item{CI}{
Confidence to be used for the Confidence Interval when a grid of quantiles is provided. Default = 0.95.
}
}
\details{
When a grid of quantiles is provided, a graphical summary with point estimates and Confidence Intervals for model parameters is shown.
}
\value{
\item{iter}{number of iterations.}
\item{criteria}{attained criteria value.}
\item{beta}{fixed effects estimates.}
\item{sigma}{scale parameter estimate for the error term.}
\item{nu}{Estimate of \code{nu} parameter detailed above.}
\item{gamma}{Estimate of \code{gamma} parameter detailed above.}
\item{SE}{Standard Error estimates.}
\item{table}{Table containing the inference for the fixed effects parameters.}
\item{loglik}{Log-likelihood value.}
\item{AIC}{Akaike information criterion.}
\item{BIC}{Bayesian information criterion.}
\item{HQ}{Hannan-Quinn information criterion.}
\item{fitted.values}{vector containing the fitted values.}
\item{residuals}{vector containing the residuals.}
}
\author{Christian E. Galarza <\email{cgalarza88@gmail.com}>, {Luis Benites} <\email{lsanchez@ime.usp.br}> and
Victor H. Lachos <\email{hlachos@ime.unicamp.br}>

Maintainer: Christian E. Galarza <\email{cgalarza88@gmail.com}>
}
\note{
If a grid of quantiles is provided, the result will be a list of the same dimension where each element corresponds to each quantile as detailed above.
}

\examples{
\dontrun{
#Example 1
##Load the data
data(ais)
attach(ais)

##Setting
y<-BMI
x<-cbind(1,LBM,Sex)

## Fitting a median regression with Normal errors (by default)

modelF = lqr(y[Sex==1], x[Sex==1,1:2])
modelM = lqr(y[Sex==0], x[Sex==0,1:2])
plot(LBM,BMI,col=Sex+1,xlab="Lean Body Mass",ylab="Body4 Mass Index",main="Quantile Regression")
abline(a = modelF$beta[1],b = modelF$beta[2],lwd=2,col=2)
abline(a = modelM$beta[1],b = modelM$beta[2],lwd=2,col=4)

#COMPARING SOME MODELS for median regression
x<-cbind(1,LBM)

modelN  = lqr(y,x,dist = "normal")
modelT  = lqr(y,x,dist = "t")
modelL  = lqr(y,x,dist = "laplace")

#Comparing AIC criterias
modelN$AIC;modelT$AIC;modelL$AIC

#This could be automatically done using best.lqr()
best.model = best.lqr(y, x, p = 0.75, criterion = "AIC")

#Let's use a grid of quantiles
modelfull = lqr(y,x,p = seq(from = 0.10,to = 0.90,by = 0.05),dist = "normal")

#Plotting quantiles 0.10,0.25,0.50,0.75 and 0.90

plot(LBM,BMI,xlab = "Lean Body Mass"
     ,ylab = "Body Mass Index", main = "Quantile Regression",pch=16)
abline(a = modelfull[[1]]$beta[1],b = modelfull[[1]]$beta[2],lwd=2,lty=1,col=2)
abline(a = modelfull[[17]]$beta[1],b = modelfull[[17]]$beta[2],lwd=2,lty=1,col=2)
abline(a = modelfull[[4]]$beta[1],b = modelfull[[4]]$beta[2],lwd=2,lty=1,col=3)
abline(a = modelfull[[14]]$beta[1],b = modelfull[[14]]$beta[2],lwd=2,lty=1,col=3)
abline(a = modelfull[[9]]$beta[1],b = modelfull[[9]]$beta[2],lwd=2,lty=1,col=4)


#Example 2
##Load the data

data(crabs,package = "MASS")

crabs$sex <- as.character(crabs$sex)
crabs$sex[crabs$sex=="M"]=0
crabs$sex[crabs$sex=="F"]=1
crabs$sex = as.numeric(crabs$sex)

attach(crabs)
head(crabs)

##Setting
y  <- BD
x  <- cbind(1,FL,sex)
plot(crabs)

## Fitting a median regression with Normal errors (by default)
modelF = lqr(y[sex==1], x[sex==1,1:2])
modelM = lqr(y[sex==0], x[sex==0,1:2])
plot(FL,BD,col=sex+1,xlab="Frontal lobe size",ylab="Body depth",main="Quantile Regression")
abline(a = modelF$beta[1],b = modelF$beta[2],lwd=2,col=2)
abline(a = modelM$beta[1],b = modelM$beta[2],lwd=2,col=4)

#COMPARING SOME MODELS for median regression
x<-cbind(1,FL)

modelN  = lqr(y,x,dist = "normal")
modelT  = lqr(y,x,dist = "t")
modelL  = lqr(y,x,dist = "laplace")
modelS  = lqr(y,x,dist = "slash")
modelC  = lqr(y,x,dist = "cont" )

#Comparing AIC criterias
modelN$AIC;modelT$AIC;modelL$AIC;modelS$AIC;modelC$AIC

#Let's use a grid of quantiles
modelfull = lqr(y,x,p = seq(from = 0.10,to = 0.90,by = 0.05),dist = "t")

#Plotting quantiles 0.10,0.25,0.50,0.75 and 0.90

plot(FL,BD,xlab = "Frontal lobe size"
     ,ylab = "Body depth", main = "Quantile Regression",pch=16)
abline(a = modelfull[[1]]$beta[1],b = modelfull[[1]]$beta[2],lwd=2,lty=1,col=2)
abline(a = modelfull[[17]]$beta[1],b = modelfull[[17]]$beta[2],lwd=2,lty=1,col=2)
abline(a = modelfull[[4]]$beta[1],b = modelfull[[4]]$beta[2],lwd=2,lty=1,col=3)
abline(a = modelfull[[14]]$beta[1],b = modelfull[[14]]$beta[2],lwd=2,lty=1,col=3)
abline(a = modelfull[[9]]$beta[1],b = modelfull[[9]]$beta[2],lwd=2,lty=1,col=4)
}
}

\references{
Galarza, C.M., Lachos, V.H., Cabral, C.R.B. and Castro, L.M. (2016). Robust Quantile Regression using a Generalized Class of Skewed Distributions. Technical Report 7, Universidade Estadual de
Campinas. \url{http://www.ime.unicamp.br/sites/default/files/rp07-16.pdf}

Wichitaksorn, N., Choy, S. T., & Gerlach, R. (2014). A generalized class of skew distributions and associated robust quantile regression models. Canadian Journal of Statistics, 42(4), 579-596.
}

\keyword{package}
\keyword{quantile}
\keyword{regression}
\keyword{skew}

\seealso{\code{\link{best.lqr}},\code{\link{Log.lqr}},
\code{\link{Log.best.lqr}},\code{\link{dSKD}},\code{\link[qrLMM]{QRLMM}},
\code{\link[qrNLMM]{QRNLMM}}}
