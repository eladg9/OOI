% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OOI.R
\name{predict.ooi}
\alias{predict.ooi}
\title{Predict Outside Option Index}
\usage{
\method{predict}{ooi}(
  object,
  new.coef = NULL,
  new.X = NULL,
  new.Z = NULL,
  new.X.location = NULL,
  new.Z.location = NULL,
  new.wgt = NULL,
  hhi = F,
  both = F
)
}
\arguments{
\item{object}{an ooi object.}

\item{new.coef}{a new *named* vector of coefficients. Check the coefficients produced by
the main function to see the right format for this vector.}

\item{new.X}{a new X matrix / data frame.}

\item{new.Z}{a new Z matrix / data frame.}

\item{new.X.location}{a new X.location matrix / data frame.}

\item{new.Z.location}{a new Z.location matrix / data frame.}

\item{new.wgt}{a new vector of weights}

\item{hhi}{whether to predict the HHI (Herfindahl-Hirschman Index, an alternative measure for
outside options) instead of the OOI. default is FALSE.}

\item{both}{whether to return a list with both HHI and OOI when suppling new inputs (default is FALSE).
Necessary especially when predicting takes a lot of time.}
}
\value{
If there are no new arguments, returns the original results (ooi/hhi). Otherwise,
        returns a vector of ooi/hhi (or a list of both) calculated using the new arguments.
}
\description{
predicts the OOI for new coefficients (for counterfactual analysis)
and/or new data.
}
\examples{
library(OOI)
#generate data
#worker and job characteristics:
n <- 1000
men <- rbinom(n, 1, 0.5)
size <- 1 + rgeom(n, 0.1)
size[men == 0] <- size[men == 0] + 2
worker_resid <- matrix(round(runif(n, 0, 20), 1), ncol = 1)
job_location <- matrix(round(runif(n, 20, 40), 1), ncol = 1)
#prepare data
#define distance function:
dist_metric <- function(x, y){abs(y - x)}
X <- data.frame(men = men)
Z <- data.frame(size = size)
#add "x" / "z" to column names:
X <- add_prefix(X, "x.")
Z <- add_prefix(Z, "z.")
#estimate P(Z|X) / P(Z) and calculate the ooi:
ooi_object <- OOI(formula = ~ x_*z_ + x_*d + z_*d, X = X, Z = Z,
                  X.location = worker_resid, Z.location = job_location,
                  sim.factor = 3, dist.fun = dist_metric, dist.order = 3)
#we can extract the ooi using predict():
ooi <- predict(ooi_object)
#or the hhi:
ooi <- predict(ooi_object, hhi = T)
#we can also estimate the ooi with different coefficients:
coeffs <- ooi_object$coeffs
coeffs[names(coeffs) == "x.men"] <- 0
new_ooi <- predict(ooi_object, new.coef = coeffs)
#or new data:
Z2 <- data.frame(z.size = 1 + rgeom(n, 0.1))
new_ooi <- predict(ooi_object, new.Z = Z2)
}
