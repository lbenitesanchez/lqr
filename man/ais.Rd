\name{resistance}
\alias{resistance}
\docType{data}
\title{Tumor-cell resistance to death}
\description{
The experiment consists in measure the resistance to death of two types of tumor-cells over different doses of a experimental drug. P.D.: Simulated dataset.
}
\format{This data frame contains the following columns:
 \describe{
    \item{dose}{
Quantity of dose of an experimental drug.
    }
    \item{type}{
Type of tumor-cell. Type A and B.
    }
    \item{score}{
Bounded response between 0 and 4.
    }
 }
}

\details{
This dataset was generated in order to be fitted with a logistic quantile regression since the response is bounded.
}

\keyword{datasets}
