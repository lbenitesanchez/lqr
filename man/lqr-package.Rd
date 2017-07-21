\name{lqr-package}
\alias{lqr-package}
\alias{lqr-package}
\docType{package}
\title{
Robust Linear Quantile Regression
}
\description{
It fits a robust linear quantile regression model using a new family of zero-quantile distributions for the error term. This family of distribution includes skewed versions of the Normal, Student's t, Laplace, Slash and Contaminated Normal distribution. It provides estimates and full inference. It also provides envelopes plots for assessing the fit and confidences bands when several quantiles are provided simultaneously.
}
\details{
\tabular{ll}{
Package: \tab lqr\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2015-10-29\cr
License: \tab GPL (>=2)\cr
}
~~ An overview of how to use the package, including the most important functions ~~
}
\author{Christian E. Galarza <\email{cgalarza88@gmail.com}>, {Luis Benites} <\email{lsanchez@ime.usp.br}> and 
Victor H. Lachos <\email{hlachos@ime.unicamp.br}>

Maintainer: Christian E. Galarza <\email{cgalarza88@gmail.com}>
}

\references{
Galarza, C.M., Lachos, V.H., Cabral, C.R.B. and Castro, L.M. (2016). Robust Quantile Regression using a Generalized Class of Skewed Distributions. Technical Report 7, Universidade Estadual de Campinas. \url{http://www.ime.unicamp.br/sites/default/files/rp07-16.pdf}

Wichitaksorn, N., Choy, S. T., & Gerlach, R. (2014). A generalized class of skew distributions and associated robust quantile regression models. Canadian Journal of Statistics, 42(4), 579-596.
}

\keyword{package}
\keyword{quantile}
\keyword{logistic}
\keyword{bounded}
\keyword{regression}
\keyword{skewed}

\seealso{\code{\link{SKD}},\code{\link{Log.best.lqr}},
\code{\link{Log.lqr}},\code{\link{best.lqr}},\code{\link{lqr}},
\code{\link{ais}},
\code{\link[qrLMM]{QRLMM}},
\code{\link[qrNLMM]{QRNLMM}}}