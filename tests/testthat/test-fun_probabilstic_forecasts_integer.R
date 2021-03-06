
# ===================================================================== #
# pit_int
# ===================================================================== #


test_that("function throws an error when missing true_values",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(50, rpois(n = 10, lambda = 1:10))

            expect_error(pit_int(predictions = predictions))
          })

test_that("function throws an error when missing 'predictions'",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(50, rpois(n = 10, lambda = 1:10))

            expect_error(pit_int(true_values = true_values))
          })

test_that("function throws a warning for wrong format of true_value",
          {
            true_values <- runif(10, min = 0, max = 1)
            predictions <- replicate(10, rpois(10, lambda = 1:10))

            expect_warning(pit_int(true_values = true_values,
                               predictions = predictions))
          })

test_that("function throws a warning for wrong format of predictions",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(10, runif(10, min = 0, max = 10))

            expect_warning(pit_int(true_values = true_values,
                               predictions = predictions))

            predictions <- list(replicate(10, rpois(10, lambda = 1:10)))
            expect_error(pit_int(true_values = true_values,
                               predictions = predictions))

            predictions <- replicate(10, runif(13, min = 0, max = 10))
            expect_error(pit_int(true_values = true_values,
                             predictions = predictions))
          })


test_that("function works for correct format of true_values and predictions",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(10, rpois(10, lambda = 1:10))
            output <- pit_int(true_values = true_values,
                          predictions = predictions)
            expect_equal(length(output),
                         4)
            expect_equal(class(output),
                         "list")
            expect_equal(class(output[[1]]),
                         "numeric")
          })




# ===================================================================== #
# bias_int
# ===================================================================== #


test_that("function throws an error when missing true_values",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(50, rpois(n = 10, lambda = 1:10))

            expect_error(bias_int(predictions = predictions))
          })

test_that("function throws an error when missing 'predictions'",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(50, rpois(n = 10, lambda = 1:10))

            expect_error(bias_int(true_values = true_values))
          })

test_that("function throws a warning for wrong format of true_value",
          {
            true_values <- runif(10, min = 0, max = 1)
            predictions <- replicate(10, rpois(10, lambda = 1:10))

            expect_warning(bias_int(true_values = true_values,
                               predictions = predictions))
          })

test_that("function throws a warning for wrong format of predictions",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(10, runif(10, min = 0, max = 10))

            expect_warning(bias_int(true_values = true_values,
                               predictions = predictions))

            predictions <- list(replicate(10, rpois(10, lambda = 1:10)))
            expect_error(bias_int(true_values = true_values,
                             predictions = predictions))

            predictions <- replicate(10, runif(13, min = 0, max = 10))
            expect_error(bias_int(true_values = true_values,
                             predictions = predictions))
          })


test_that("function works for correct format of true_values and predictions",
          {
            true_values <- rpois(10, lambda = 1:10)
            predictions <- replicate(10, rpois(10, lambda = 1:10))
            output <- bias_int(true_values = true_values,
                          predictions = predictions)
            expect_equal(length(output),
                         length(true_values))
            expect_equal(class(output),
                         "numeric")
          })



# ===================================================================== #
# sharpness
# ===================================================================== #


test_that("function throws an error when missing 'predictions'",
          {
            predictions <- replicate(50, rpois(n = 10, lambda = 1:10))

            expect_error(sharpness())
          })

# test_that("function throws a warning for wrong format of predictions",
#           {
#             predictions <- replicate(10, runif(10, min = 0, max = 10))
#
#             expect_warning(sharpness(predictions = predictions))
#
#             predictions <- list(replicate(10, rpois(10, lambda = 1:10)))
#             expect_error(bias_int(true_values = true_values,
#                               predictions = predictions))
#
#             predictions <- replicate(10, runif(13, min = 0, max = 10))
#             expect_error(bias_int(true_values = true_values,
#                               predictions = predictions))
#           })


# test_that("function works for correct format of predictions",
#           {
#             true_values <- rpois(10, lambda = 1:10)
#             predictions <- replicate(10, rpois(10, lambda = 1:10))
#             output <- bias_int(true_values = true_values,
#                            predictions = predictions)
#             expect_equal(length(output),
#                          length(true_values))
#             expect_equal(class(output),
#                          "numeric")
#           })
