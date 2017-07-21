\name{SKD}
\alias{SKD}
\alias{dSKD}
\alias{pSKD}
\alias{qSKD}
\alias{rSKD}

\title{Skew Family Distributions
}
\description{Density, distribution function, quantile function and random generation for a Skew Family Distribution useful for quantile regression. This family of distribution includes skewed versions of the Normal, Student's t, Laplace, Slash and Contaminated Normal distribution, all with location parameter equal to \code{mu}, scale parameter \code{sigma} and skewness parameter \code{p}.
}

\usage{
dSKD(y, mu = 0, sigma = 1, p = 0.5, dist = "normal", nu = "", gama = "")
pSKD(q, mu = 0, sigma = 1, p = 0.5, dist = "normal", nu = "", gama = "",
lower.tail = TRUE)
qSKD(prob, mu = 0, sigma = 1, p = 0.5, dist = "normal", nu = "", gama = "",
lower.tail = TRUE)
rSKD(n, mu = 0, sigma = 1, p = 0.5, dist = "normal", nu = "", gama = "")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y,q}{
vector of quantiles.
}
  \item{prob}{
vector of probabilities.
}
  \item{n}{
number of observations.
}
  \item{mu}{
location parameter.
}
  \item{sigma}{
scale parameter.
}
  \item{p}{
skewness parameter.
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
  \item{lower.tail}{
logical; if TRUE (default), probabilities are P[X \eqn{\le} x] otherwise, P[X > x].
}
}

\details{
If \code{mu}, \code{sigma}, \code{p} or \code{dist} are not specified they assume the default values of 0, 1, 0.5 and \code{normal}, respectively, belonging to the Symmetric Standard Normal Distribution denoted by \eqn{SKN(0,1,0.5)}.

The scale parameter \code{sigma} must be positive and non zero. The skew parameter \code{p} must be between zero and one (0<\code{p}<1).

This family of distributions generalize the skew distributions in Wichitaksorn et.al. (2014) as an scale mixture of skew normal distribution. Also the Three-Parameter Asymmetric Laplace Distribution defined in Koenker and Machado (1999) is a special case.
}

\value{
\code{dSKD} gives the density, \code{pSKD} gives the distribution function, \code{qSKD} gives the quantile function, and \code{rSKD} generates a random sample.

The length of the result is determined by n for \code{rSKD}, and is the maximum of the lengths of the numerical arguments for the other functions \code{dSKD}, \code{pSKD} and \code{qSKD}.
}

\references{
Galarza, C.M., Lachos, V.H., Cabral, C.R.B. and Castro, L.M. (2016). Robust Quantile Regression using a Generalized Class of Skewed Distributions. Technical Report 7, Universidade Estadual de Campinas. \url{http://www.ime.unicamp.br/sites/default/files/rp07-16.pdf}

Wichitaksorn, N., Choy, S. T., & Gerlach, R. (2014). A generalized class of skew distributions and associated robust quantile regression models. Canadian Journal of Statistics, 42(4), 579-596.
}

\author{Christian E. Galarza <\email{cgalarza88@gmail.com}>, {Luis Benites} <\email{lsanchez@ime.usp.br}> and
Victor H. Lachos <\email{hlachos@ime.unicamp.br}>

Maintainer: Christian E. Galarza <\email{cgalarza88@gmail.com}>
}

\note{
The numerical arguments other than \code{n} are recycled to the length of the result.
}

\seealso{
\code{\link{lqr}},\code{\link{ais}}
}

\examples{
\dontrun{
## Let's plot (Normal Vs. Student-t's with 4 df)
##Density
sseq = seq(15,65,length.out = 1000)
dens = dSKD(y=sseq,mu=50,sigma=3,p=0.75)
plot(sseq,dens,type="l",lwd=2,col="red",xlab="x",ylab="f(x)", main="Normal Vs. t(4) densities")
dens2 = dSKD(y=sseq,mu=50,sigma=3,p=0.75,dist="t",nu=4)
lines(sseq,dens2,type="l",lwd=2,col="blue",lty=2)

## Distribution Function
df = pSKD(q=sseq,mu=50,sigma=3,p=0.75,dist = "laplace")
plot(sseq,df,type="l",lwd=2,col="blue",xlab="x",ylab="F(x)", main="Laplace Distribution function")
abline(h=1,lty=2)

##Inverse Distribution Function
prob = seq(0.001,0.999,length.out = 1000)
idf = qSKD(prob=prob,mu=50,sigma=3,p=0.25,dist="cont",nu=0.3,gama=0.1) # 1 min appox
plot(prob,idf,type="l",lwd=2,col="gray30",xlab="x",ylab=expression(F^{-1}~(x)))
title(main="Skew Cont. Normal Inverse Distribution function")
abline(v=c(0,1),lty=2)

#Random Sample Histogram
sample = rSKD(n=20000,mu=50,sigma=3,p=0.2,dist="slash",nu=3)
seqq2 = seq(25,100,length.out = 1000)
dens3 = dSKD(y=seqq2,mu=50,sigma=3,p=0.2,dist="slash",nu=3)
hist(sample,breaks = 70,freq = FALSE,ylim=c(0,1.05*max(dens3,na.rm = TRUE)),main="")
title(main="Histogram and True density")
lines(seqq2,dens3,col="blue",lwd=2)
}
}

\keyword{package}
\keyword{quantile}
\keyword{distribution}
\keyword{skew}