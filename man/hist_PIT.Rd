% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_functions.R
\name{hist_PIT}
\alias{hist_PIT}
\title{PIT Histogram}
\usage{
hist_PIT(PIT_samples, num_bins = NULL)
}
\arguments{
\item{PIT_samples}{A vector with the PIT values of size n}

\item{num_bins}{the number of bins in the PIT histogram.
If not given, the square root of n will be used}
}
\value{
vector with the scoring values
}
\description{
Make a simple histogram of the probability integral transformed values to
visually check whether a uniform distribution seems likely.
}
\examples{
true_values <- rpois(30, lambda = 1:30)
predictions <- replicate(200, rpois(n = 30, lambda = 1:30))
logs(true_values, predictions)
}
