#' Estimates the mixing model from \insertCite{Teickner.2025h;textual}{mmgm}
#'
#' @family mmgm_estimate_mixing_model
#'
#' @param stan_data An object as returned by `mmgm_make_stan_data()`.
#'
#' @param ... Named arguments to the `sample()` method of CmdStan model
#' objects: <https://mc-stan.org/cmdstanr/reference/model-method-sample.html>
#'
#' @return A `CmdStanMCMC` object with the estimated mixing model. The model has
#' the following parameters:
#' \describe{
#'   \item{`gamma_component`}{The degree of decomposition (\eqn{\gamma}) of each
#'   component.}
#'   \item{`gamma_mixture`}{\eqn{\gamma} of each mixture.}
#'   \item{`gamma_mirs_mixture_obs`}{Average \eqn{\gamma_\text{MIRS}} of the
#'   mixtures.}
#'   \item{`phi`}{A scaled version of the scale parameter of the beta
#'   distribution for \eqn{\gamma_\text{MIRS}} of the mixtures.}
#'   \item{`b_intercept`}{Intercept of the linear model that predicts
#'   \eqn{\gamma_\text{MIRS}} from mid infrared spectra.}
#' }
#'
#' @references
#'   \insertAllCited{}
#'
#' @examples
#' if (instantiate::stan_cmdstan_exists()) {
#'
#' cmdstanr::check_cmdstan_toolchain(fix = FALSE, quiet = TRUE)
#'
#' stan_data <-
#'   mmgm_make_stan_data(
#'     x = mmgm_example_data,
#'     id_model_gamma_mirs = 2L,
#'     priors = mmgm_make_default_priors(x = mmgm_example_data)
#'   )
#'
#' fit <-
#'   mmgm_estimate_gamma_mirs_mixing_1(
#'     stan_data,
#'     iter_sampling = 50,
#'     iter_warmup = 30,
#'     chains = 2,
#'     sig_figs = 14,
#'     seed = 7667
#'   )
#'
#'  fit$summary()
#' }
#'
#' @export
mmgm_estimate_gamma_mirs_mixing_1 <- function(stan_data, ...) {

  model <- instantiate::stan_package_model(name = "gamma_mirs_mixing_1", package = "mmgm")
  model$sample(data = stan_data, ...)

}
