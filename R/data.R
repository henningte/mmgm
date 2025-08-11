#' Intercepts from the `irpeatmodels` prediction models for \eqn{\gamma_\text{MIRS}}
#'
#' This dataset is used internally in the mixing model.
#'
#' @format ## `mmgm_b_Intercept`
#' A data frame with 3 rows and 4 columns:
#' \describe{
#'   \item{`model_id`}{Integer value. The identifier of the model in the
#'   `irpeatmodels` package.}
#'   \item{`model name`}{Character value. The name of the model in the
#'   `irpeatmodels` package.}
#'   \item{`b_intercept_p1`}{Numeric value. The average of the intercept of the
#'   model.}
#'   \item{`b_intercept_p2`}{Numeric value. The standard deviation of the
#'   intercept of the model.}
#' }
#'
"mmgm_b_Intercept"

#' Example data in the `mmgm` package
#'
#' @format ## `mmgm_example_data`
#' A list with two elements. The list has the same structure as argument `x` in
#' `mmgm_make_stan_data()`.
#'
"mmgm_example_data"
