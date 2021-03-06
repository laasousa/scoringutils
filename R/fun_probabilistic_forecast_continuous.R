#' @title LogS
#'
#' @description
#' Wrapper around the \code{\link[scoringRules]{logs_sample}} function from the
#' \code{scoringRules} package.
#' @param true_values A vector with the true observed values of size n
#' @param predictions nxN matrix of predictive samples, n (number of rows) being
#' the number of data points and N (number of columns) the
#' number of Monte Carlo samples
#' @return vector with the scoring values
#' @examples
#' true_values <- rpois(30, lambda = 1:30)
#' predictions <- replicate(200, rpois(n = 30, lambda = 1:30))
#' logs(true_values, predictions)
#' @export


logs <- function(true_values, predictions) {

  # ============== Error handling ==============

  if (missing(true_values) | missing(predictions)) {
    stop("true_values or predictions argument missing")
  }

  n <- length(true_values)

  if (is.data.frame(predictions)) {
    predictions <- as.matrix(predictions)
  }
  if (!is.matrix(predictions)) {
    stop("'predictions' should be a matrix")
  }
  if (nrow(predictions) != n) {
    msg = cat("matrix 'predictions' must have n rows, ",
              "where n is the number of true_values to predict. ")
    stop(msg)
  }

  # ============================================

  scoringRules::logs_sample(y = true_values,
                            dat = predictions)
}



#' @title randomised Probability Integral Transformation
#'
#' @description Uses a Probability Integral Transformation (PIT) to
#' assess the calibration of predictive Monte Carlo samples. Returns a
#' PIT histogram and p-values resulting from an Anderson-Darling
#' test for uniformity for the randomised PIT.
#'
#' @details
#' Calibration or reliability of forecasts is the ability of a model to
#' correctly identify its own uncertainty in making predictions. In a model
#' with perfect calibration, the observed data at each time point look as if
#' they came from the predictive probability distribution at that time.
#'
#' Equivalently, one can inspect the probability integral transform of the
#' predictive distribution at time t,
#'
#' \deqn{
#' u_t = F_t (x_t)
#' }
#'
#' where \eqn{x_t} is the observed data point at time \eqn{t in t_1, …, t_n},
#' n being the number of forecasts, and $F_t$ is the (continuous) predictive
#' cumulative probability distribution at time t. If the true probability
#' distribution of outcomes at time t is \eqn{G_t} then the forecasts eqn{F_t} are
#' said to be ideal if eqn{F_t = G_t} at all times t. In that case, the
#' probabilities ut are distributed uniformly.
#'
#' As a rule of thumb, there is no evidence to suggest a forecasting model is
#' miscalibrated if the p-value found was greater than a threshold of p >= 0.1,
#' some evidence that it was miscalibrated if 0.01 < p < 0.1, and good
#' evidence that it was miscalibrated if p <= 0.01.
#' In this context it should be noted, though, that uniformity of the
#' PIT is a necessary but not sufficient condition of calibration.
#'
#' @param true_values A vector with the true observed values of size n
#' @param predictions nxN matrix of predictive samples, n (number of rows) being
#' the number of data points and N (number of columns) the
#' number of Monte Carlo samples
#' @param num_bins the number of bins in the PIT histogram.
#' If not given, the square root of n will be used
#' @return vector with the scoring values
#' @examples
#' true_values <- rnorm(30, mean = 1:30)
#' predictions <- replicate(200, rnorm(n = 30, mean = 1:30))
#' pit(true_values, predictions)
#' @export



pit <- function(true_values,
                predictions,
                num_bins = NULL) {


  # ============== Error handling ==============

  if (missing(true_values) | missing(predictions)) {
    stop("true_values or predictions argument missing")
  }

  if (all.equal(true_values, as.integer(true_values)) == TRUE) {
    warning("The true_values provided are all integers.
            Maybe you want to score integer predictions instead?")
  }

  n <- length(true_values)

  if (is.data.frame(predictions)) {
    predictions <- as.matrix(predictions)
  }
  if (!is.matrix(predictions)) {
    stop("'predictions' should be a matrix")
  }
  if (nrow(predictions) != n) {
    msg = cat("matrix 'predictions' must have n rows, ",
              "where n is the number of true_values to predict. ")
    stop(msg)
  }
  if (all.equal(as.vector(predictions), as.integer(predictions)) == TRUE) {
    warning("predictions provided are all integers.
        Maybe you want to score integer predictions instead?")
  }

  # ============================================

  n_pred <- ncol(predictions)

  # calculate emipirical cumulative distribution function as
  # Portion of (y_true <= y_predicted)
  P_x <- vapply(seq_along(true_values),
                function(i) {
                  sum(predictions[i, ] <= true_values[i]) / n_pred
                },
                .0)

  hist_PIT <- scoringutils::hist_PIT(P_x)

  calibration <- goftest::ad.test(P_x)$p.value
  names(calibration) <- "p_value"

  return(list(hist_PIT = hist_PIT,
              calibration = calibration))

}



#' @title Determines bias of a continuous forecast
#'
#' @description
#' Determines bias from predictive Monte-Carlo samples for integer values
#' as the proportion of predictive samples greater than the true values
#'
#' @details
#' Bias is measured as
#'
#' \deqn{
#' B_t (P_t, x_t) = 1 - (P_t (x_t))
#' }
#'
#' where \eqn{P_t} is the empirical cumulative distribution function of the
#' prediction for the true value \eqn{x_t}. Computationally, \eqn{P_t (x_t)} is
#' just calculated as the fraction of predictive samples for \eqn{x_t}
#' that are smaller than \eqn{x_t}.
#'
#' @param true_values A vector with the true observed values of size n
#' @param predictions nxN matrix of predictive samples, n (number of rows) being
#' the number of data points and N (number of columns) the
#' number of Monte Carlo samples
#' @return vector of length n with the biases of the predictive samples with
#' respect to the true values.
#' @author Nikos Bosse \email{nikosbosse@gmail.com}
#' @examples
#' true_values <- rnorm(30, mean = 1:30)
#' predictions <- replicate(200, rnorm(n = 30, mean = 1:30))
#' bias(true_values, predictions)
#' @export


bias <- function(true_values, predictions) {

  # ============== Error handling ==============

  if (missing(true_values) | missing(predictions)) {
    stop("true_values or predictions argument missing")
  }

  if (all.equal(true_values, as.integer(true_values)) == TRUE) {
    warning("The true_values provided are all integers.
            Maybe you want to score integer predictions instead?")
  }

  n <- length(true_values)

  if (is.data.frame(predictions)) {
    predictions <- as.matrix(predictions)
  }
  if (!is.matrix(predictions)) {
    stop("'predictions' should be a matrix")
  }
  if (nrow(predictions) != n) {
    msg = cat("matrix 'predictions' must have n rows, ",
              "where n is the number of true_values to predict. ")
    stop(msg)
  }
  if (all.equal(as.vector(predictions), as.integer(predictions)) == TRUE) {
    warning("predictions provided are all integers.
        Maybe you want to score integer predictions instead?")
  }

  # ============================================

  n_pred <- ncol(predictions)

  # empirical cdf
  P_x <- vapply(seq_along(true_values),
                function(i) {
                  sum(predictions[i,] <= true_values[i]) / n_pred
                },
                .0)
  return(1 - P_x)
}
