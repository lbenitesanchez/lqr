\name{Log.best.lqr}
\alias{Log.best.lqr}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Best Fit in Robust Logistic Linear Quantile Regression
}
\description{
It performs the logistic transformation in Bottai et.al. (2009) (see references) for estimating quantiles for a bounded response. Once the response is transformed, it uses the \code{best.lqr} function.
}
\usage{
Log.best.lqr(y,x,p=0.5,a=0,b=1,epsilon = 0.001,
precision = 10^-6,criterion = "AIC")
}

\arguments{
We will detail first the only three arguments that differ from \code{lqr} function.

  \item{a}{
lower bound for the response (default = 0)
}
 \item{b}{
upper bound for the response (default = 1)
}
\item{epsilon}{
a small quantity \eqn{\epsilon>0} that ensures that the logistic transform is defined for all values of \code{y}
}
\item{y}{
the response vector of dimension \eqn{n} where \eqn{n} is the total of observations.
}
\item{x}{
design matrix for the fixed effects of dimension \eqn{N x d} where \eqn{d} represents the number of fixed effects including the intercept, if considered.
}\item{p}{
An unique quantile or a set of quantiles related to the quantile regression.
}
  \item{precision}{
The convergence maximum error permitted. By default is 10^-6.
}
  \item{criterion}{
Likelihood-based criterion to be used for choosen the best model. It could be \code{AIC}, \code{BIC}, \code{HQ} or \code{loglik} (log-likelihood). By default \code{AIC} criterion will be used.
}
}
\details{
We follow the transformation in Bottai et.al. (2009) defined as

\deqn{h(y)=logit(y)=log(\frac{y-a}{b-y})}

that implies

\deqn{Q_{y}(p)=\frac{b\,exp(X\beta) + a}{1 + exp(X\beta)}}

where \eqn{Q_{y}(p)} represents the conditional quantile of the response. Once estimates for the regression coefficients \eqn{\beta_p} are obtained, inference on \eqn{Q_{y}(p)} can then be made through the inverse transform above. This equation (as function) is provided in the output. See example.

The interpretation of the regression coefficients is analogous to the interpretation of the coefficients of a logistic regression
for binary outcomes.

For example, let \eqn{x_1} be the gender (male = 0, female=1). Then \eqn{exp(\beta_{0.5,1})} represents the odds ratio of median score in males vs females, where the odds are
defined using the score instead of a probability, \eqn{(y-a)/(b-y)}. When the covariate is continous, the respective \eqn{\beta} coeficient can be interpretated as the increment (or decrement) over the log(odd ratio) when the covariate increases one unit.

}
\value{

For the best model:

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
When a grid of quantiles is provided, a graphical summary with point estimates and Confidence Intervals for model parameters is shown. Also, the result will be a list of the same dimension where each element corresponds to each quantile as detailed above.
}

\examples{
\dontrun{
##Load the data
data(resistance)
attach(resistance)

#EXAMPLE 1.1

#Comparing the resistence to death of two types of tumor-cells.
#The response is a score in [0,4].

boxplot(score~type)

#Median logistic quantile regression (Best fit distribution)
res = Log.best.lqr(y = score,x = cbind(1,type),a=0,b=4)

# The odds ratio of median score in type B vs type A
exp(res$beta[2])

#Proving that exp(res$beta[2])  is approx median odd ratio
medA  = median(score[type=="A"])
medB  = median(score[type=="B"])
rateA = (medA - 0)/(4 - medA)
rateB = (medB - 0)/(4 - medB)
odd   = rateB/rateA

round(c(exp(res$beta[2]),odd),3) #better fitted

#EXAMPLE 1.2
############

#Comparing the resistence to death depending of dose.

#descriptive
plot(dose,score,ylim=c(0,4),col="dark gray");abline(h=c(0,4),lty=2)
dosecat<-cut(dose, 6, ordered = TRUE)
boxplot(score~dosecat,ylim=c(0,4))
abline(h=c(0,4),lty=2)

#(Non logistic) Best quantile regression for quantiles
# 0.05, 0.50 and 0.95
xx1  = dose
xx2  = dose^2
xx3  = dose^3
res31 = best.lqr(y = score,x = cbind(1,xx1,xx2,xx3),p = 0.05)
res32 = best.lqr(y = score,x = cbind(1,xx1,xx2,xx3),p = 0.50)
res33 = best.lqr(y = score,x = cbind(1,xx1,xx2,xx3),p = 0.95)
res3  = list(res31,res32,res33)
seqq=seq(min(dose),max(dose),length.out = 1000)
dd = matrix(data = NA,nrow = 1000,ncol =3)
for(i in 1:3)
{
  dd[,i] = rep(res3[[i]]$beta[1],1000) + res3[[i]]$beta[2]*seqq +
    res3[[i]]$beta[3]*seqq^2 + res3[[i]]$beta[4]*seqq^3
}

plot(dose,score,ylim=c(-1,5),col="gray");abline(h=c(0,4),lty=2)
lines(seqq,dd[,1],lwd=1,col=2)
lines(seqq,dd[,2],lwd=1,col=1)
lines(seqq,dd[,3],lwd=1,col=2)

#Using logistic quantile regression for obtaining predictions inside bounds

res41 = Log.best.lqr(y = score,x = cbind(1,xx1,xx2,xx3),a=0,b=4,p = 0.05)
res42 = Log.best.lqr(y = score,x = cbind(1,xx1,xx2,xx3),a=0,b=4,p = 0.50)
res43 = Log.best.lqr(y = score,x = cbind(1,xx1,xx2,xx3),a=0,b=4,p = 0.95)
res4  = list(res41,res42,res43)
dd = matrix(data = NA,nrow = 1000,ncol =3)
for(i in 1:3)
{
  dd[,i] = rep(res4[[i]]$beta[1],1000) + res4[[i]]$beta[2]*seqq +
    res4[[i]]$beta[3]*seqq^2 + res4[[i]]$beta[4]*seqq^3
}

#Computing quantiles for the original response (Inverse trnasformation)

pred = function(predlog,a,b)
{
  return((b*exp(predlog)+a)/(1+exp(predlog)))
}

for(i in 1:3)
{
  dd[,i] = pred(dd[,i],a=0,b=4)
}           

#No more prediction curves outof bounds
plot(dose,score,ylim=c(0,4),col="gray");abline(h=c(0,4),lty=2)
lines(seqq,dd[,1],lwd=1,col=2)
lines(seqq,dd[,2],lwd=1,col=1)
lines(seqq,dd[,3],lwd=1,col=2)

}
}

\references{
Bottai, M., Cai, B., & McKeown, R. E. (2010). Logistic quantile regression for bounded outcomes. Statistics in Medicine, 29(2), 309-317.

Galarza, C.M., Lachos, V.H., Cabral, C.R.B. and Castro, L.M. (2016). Robust Quantile Regression using a Generalized Class of Skewed Distributions. Technical Report 7, Universidade Estadual de
Campinas. \url{http://www.ime.unicamp.br/sites/default/files/rp07-16.pdf}
}

\keyword{bounded}
\keyword{logistic}
\keyword{quantile}
\keyword{regression}
\keyword{skew}

\seealso{\code{\link{Log.lqr}},\code{\link{best.lqr}},\code{\link{dSKD}},\code{\link[qrLMM]{QRLMM}},
\code{\link[qrNLMM]{QRNLMM}}}