% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fun_probabilistic_forecast_continuous.R
\name{pit}
\alias{pit}
\title{randomised Probability Integral Transformation}
\usage{
pit(true_values, predictions, num_bins = NULL)
}
\arguments{
\item{true_values}{A vector with the true observed values of size n}

\item{predictions}{nxN matrix of predictive samples, n (number of rows) being
the number of data points and N (number of columns) the
number of Monte Carlo samples}

\item{num_bins}{the number of bins in the PIT histogram.
If not given, the square root of n will be used}
}
\value{
vector with the scoring values
}
\description{
Uses a Probability Integral Transformation (PIT) to
assess the calibration of predictive Monte Carlo samples. Returns a
PIT histogram and p-values resulting from an Anderson-Darling
test for uniformity for the randomised PIT.
}
\details{
Calibration or reliability of forecasts is the ability of a model to
correctly identify its own uncertainty in making predictions. In a model
with perfect calibration, the observed data at each time point look as if
they came from the predictive probability distribution at that time.

Equivalently, one can inspect the probability integral transform of the
predictive distribution at time t,

\deqn{
u_t = F_t (x_t)
}

where \eqn{x_t} is the observed data point at time \eqn{t in t_1, …, t_n},
n being the number of forecasts, and $F_t$ is the (continuous) predictive
cumulative probability distribution at time t. If the true probability
distribution of outcomes at time t is \eqn{G_t} then the forecasts eqn{F_t} are
said to be ideal if eqn{F_t = G_t} at all times t. In that case, the
probabilities ut are distributed uniformly.

As a rule of thumb, there is no evidence to suggest a forecasting model is
miscalibrated if the p-value found was greater than a threshold of p >= 0.1,
some evidence that it was miscalibrated if 0.01 < p < 0.1, and good
evidence that it was miscalibrated if p <= 0.01.
In this context it should be noted, though, that uniformity of the
PIT is a necessary but not sufficient condition of calibration.
}
\examples{
true_values <- rnorm(30, mean = 1:30)
predictions <- replicate(200, rnorm(n = 30, mean = 1:30))
pit(true_values, predictions)
}
