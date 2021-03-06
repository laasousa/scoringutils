% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fun_probabilistic_forecast_continuous.R
\name{bias}
\alias{bias}
\title{Determines bias of a continuous forecast}
\usage{
bias(true_values, predictions)
}
\arguments{
\item{true_values}{A vector with the true observed values of size n}

\item{predictions}{nxN matrix of predictive samples, n (number of rows) being
the number of data points and N (number of columns) the
number of Monte Carlo samples}
}
\value{
vector of length n with the biases of the predictive samples with
respect to the true values.
}
\description{
Determines bias from predictive Monte-Carlo samples for integer values
as the proportion of predictive samples greater than the true values
}
\details{
Bias is measured as

\deqn{
B_t (P_t, x_t) = 1 - (P_t (x_t))
}

where \eqn{P_t} is the empirical cumulative distribution function of the
prediction for the true value \eqn{x_t}. Computationally, \eqn{P_t (x_t)} is
just calculated as the fraction of predictive samples for \eqn{x_t}
that are smaller than \eqn{x_t}.
}
\examples{
true_values <- rnorm(30, mean = 1:30)
predictions <- replicate(200, rnorm(n = 30, mean = 1:30))
bias(true_values, predictions)
}
\author{
Nikos Bosse \email{nikosbosse@gmail.com}
}
