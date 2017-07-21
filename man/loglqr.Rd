\name{Log.lqr}
\alias{Log.lqr}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Robust Logistic Linear Quantile Regression
}
\description{
It performs the logistic transformation in Bottai et.al. (2009) (see references) for estimating quantiles for a bounded response. Once the response is transformed, it uses the \code{lqr} function.
}
\usage{
Log.lqr(y,x,p=0.5,a=0,b=1,dist = "normal",nu="",gama="",precision = 10^-6,
epsilon = 0.001,CI=0.95)
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
  \item{CI}{
Confidence to be used for the Confidence Interval when a grid of quantiles is provided. Default = 0.95.
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

boxplot(score~type,ylab="score",xlab="type")

#Student't median logistic quantile regression
res = Log.lqr(y = score,x = cbind(1,type),a=0,b=4,dist="t")

# The odds ratio of median score in type B vs type A
exp(res$beta[2])

#Proving that exp(res$beta[2])  is approx median odd ratio
medA  = median(score[type=="A"])
medB  = median(score[type=="B"])
rateA = (medA - 0)/(4 - medA)
rateB = (medB - 0)/(4 - medB)
odd   = rateB/rateA

round(c(exp(res$beta[2]),odd),3)


#EXAMPLE 1.2
############

#Comparing the resistence to death depending of dose.

#descriptive
plot(dose,score,ylim=c(0,4),col="dark gray");abline(h=c(0,4),lty=2)
dosecat<-cut(dose, 6, ordered = TRUE)
boxplot(score~dosecat,ylim=c(0,4))
abline(h=c(0,4),lty=2)

#Slash (Non logistic) quantile regression for quantiles 0.05, 0.50 and 0.95
xx1  = dose
xx2  = dose^2
xx3  = dose^3
res3 = lqr(y = score,x = cbind(1,xx1,xx2,xx3),p = c(0.05,0.50,0.95),dist="slash")
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

res4 = Log.lqr(y = score,x = cbind(1,xx1,xx2,xx3),a = 0,b = 4,p = c(0.05,0.50,0.95),dist="slash")
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

#EXAMPLE 1.3
############

#A full model using dose and type for a grid of quantiles

typeB = 1*(type=="B")
res5 = Log.lqr(y = score,x = cbind(1,xx1,xx2,xx3,typeB,typeB*xx1),a = 0,b = 4,
               p = seq(from = 0.05,to = 0.95,by = 0.05),dist = "t")
ddA = ddB = matrix(data = NA,nrow = 1000,ncol = 5)
for(i in 1:5)
{
  k = c(2,5,10,15,18)[i]
  ddA[,i] = rep(res5[[k]]$beta[1],1000) + res5[[k]]$beta[2]*seqq + res5[[k]]$beta[3]*
    seqq^2 + res5[[k]]$beta[4]*seqq^3
  ddB[,i] = rep(res5[[k]]$beta[1],1000) + (res5[[k]]$beta[2] + res5[[k]]$beta[6])*
    seqq + res5[[k]]$beta[3]*seqq^2 + res5[[k]]$beta[4]*seqq^3  + res5[[k]]$beta[5]
}

#Computing quantiles for the original response (Inverse transformation)

for(i in 1:5)
{
  ddA[,i] = pred(ddA[,i],a=0,b=4)
  ddB[,i] = pred(ddB[,i],a=0,b=4)
} 

#Such a beautiful plot
par(mfrow=c(1,2))
plot(dose,score,ylim=c(0,4),col=c((type == "B")*8+(type == "A")*1),main="Type A")
abline(h=c(0,4),lty=2)
lines(seqq,ddA[,1],lwd=2,col=2)
lines(seqq,ddA[,2],lwd=1,col=4)
lines(seqq,ddA[,3],lwd=2,col=1)
lines(seqq,ddA[,4],lwd=1,col=4)
lines(seqq,ddA[,5],lwd=2,col=2)

legend(x = 0,y=4,legend = c("p=0.10","p=0.25","p=0.50","p=0.75","p=0.90")
       ,col=c(2,4,1,4,2),lwd=c(2,1,2,1,2),bty = "n",cex=0.65)

plot(dose,score,ylim=c(0,4),col=c((type == "B")*1 + (type == "A")*8),
     main="Type B");abline(h=c(0,4),lty=2)
lines(seqq,ddB[,1],lwd=2,col=2)
lines(seqq,ddB[,2],lwd=1,col=4)
lines(seqq,ddB[,3],lwd=2,col=1)
lines(seqq,ddB[,4],lwd=1,col=4)
lines(seqq,ddB[,5],lwd=2,col=2)
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

\seealso{\code{\link{Log.best.lqr}},\code{\link{best.lqr}},\code{\link{dSKD}},\code{\link[qrLMM]{QRLMM}},
\code{\link[qrNLMM]{QRNLMM}}}