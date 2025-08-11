#' Prepares the list to use as data input to the mixing model
#'
#' @param x A list with two elements:
#' \describe{
#'   \item{`components`}{A data frame with a row for each component in the
#'   mixtures and the following columns:
#'   \describe{
#'     \item{`id_mixture`}{Unique integer for each mixture.}
#'     \item{`id_component`}{Unique integer for each component within a mixture
#'     (the first component of each mixture has `id_component == 1`).}
#'     \item{`w`}{The mass fraction of the component in the mixture. `w` must
#'     sum to 1 across each value of `id_mixture`.}
#'   }}
#'   \item{`mixtures`}{A data frame with a row for each mixture and the
#'   following columns:
#'   \describe{
#'     \item{`id_mixture`}{Unique integer for each mixture.}
#'     \item{`degree_of_decomposition_1`, `degree_of_decomposition_2`, or
#'     `degree_of_decomposition_3`}{Predictions of \eqn{\gamma_\text{MIRS}} for
#'     each mixture, as created with `irpeat::irp_degree_of_decomposition_1()`,
#'     `irpeat::irp_degree_of_decomposition_2()` or
#'     `irpeat::irp_degree_of_decomposition_3()`. One or more of the columns may
#'     be present. The columns must be `quantities` objects.}
#'   }}
#' }
#'
#' @param id_model_gamma_mirs An integer specifying which \eqn{\gamma_\text{MIRS}}
#' predictions to use in the mixing model. The corresponding column must be
#' present in `x`. For example if `id_model_gamma_mirs == 1`, then values of
#' column `degree_of_decomposition_1` in `x` will be used to estimate the mixing
#' model. See the `irpeatmodels` package for details.
#'
#' @param priors A list specifying prior parameters for the mixing model. See
#' `mmgm_default_priors` for the structure of this list.
#'
#' @return A list that can be used as input to `mmgm_estimate_mixing_model()`.
#'
#' @examples
#' mmgm_make_stan_data(
#'   x = mmgm_example_data,
#'   id_model_gamma_mirs = 2L,
#'   priors = mmgm_make_default_priors(x = x)
#' )
#'
#' @export
mmgm_make_stan_data <- function(x, id_model_gamma_mirs, priors = mmgm_make_default_priors(x = x)) {

  stopifnot(length(x) == 2 && all(names(x) %in% c("components", "mixtures")))
  stopifnot(is.numeric(id_model_gamma_mirs) && length(id_model_gamma_mirs) == 1 && id_model_gamma_mirs %in% 1:3)
  stopifnot(is.list(priors))
  variable_target_gamma_mirs <- paste0("degree_of_decomposition_", id_model_gamma_mirs)
  if(! variable_target_gamma_mirs %in% colnames(x$mixtures)) {
    stop(paste0("`id_model_gamma_mirs` has value ", id_model_gamma_mirs, ", but no column `", variable_target_gamma_mirs, "` is present in `x$mixtures`."))
  }
  if(! (inherits(x$mixtures[[variable_target_gamma_mirs]], "quantities") || inherits(x$mixtures[[variable_target_gamma_mirs]], "rvar"))) {
    stop(paste0("`", variable_target_gamma_mirs, "` must be either a `quantities` or a `rvar` object."))
  }
  if(inherits(x$mixtures[[variable_target_gamma_mirs]], "quantities")) {
    requireNamespace("quantities", quietly = TRUE)
    x$mixtures[[variable_target_gamma_mirs]] <- units::drop_units(x$mixtures[[variable_target_gamma_mirs]])
  }

  x$components <- x$components[order(x$components$id_mixture, x$components$id_component), ]
  x$mixtures <- x$mixtures[order(x$mixtures$id_mixture), ]

  components_summary <-
    split(x$components, f = x$components$id_mixture) |>
    lapply(
      FUN = function(.x) {
        res <-
          data.frame(
          id_mixture = .x$id_mixture[[1]],
          n_components = nrow(.x),
          w_sum = sum(.x$w)
        )
        stopifnot(length(unique(.x$id_component)) == nrow(.x))
        stopifnot(all.equal(res$w_sum, 1.0))
        res
      }
    )
  components_summary <-
    do.call("rbind", components_summary)

  index_components <-
    data.frame(
      size = components_summary$n_components
    )
  index_components$start <- c(1, cumsum(index_components$size[-length(index_components$size)]) + 1)
  index_components$end <- cumsum(index_components$size)

  gamma_mirs_mixture_obs_p1 <- errors::drop_errors(x$mixtures[[variable_target_gamma_mirs]])
  gamma_mirs_mixture_obs_p2 <- compute_beta_phi(gamma_mirs_mixture_obs_p1, errors::errors(x$mixtures[[variable_target_gamma_mirs]]))

  stan_data <-
    list(
      N = nrow(x$mixtures),
      K_total = nrow(x$components),
      w = x$components$w,
      gamma_mirs_mixture_obs_p1 = gamma_mirs_mixture_obs_p1,
      gamma_mirs_mixture_obs_p2 = gamma_mirs_mixture_obs_p2,
      b_intercept_p1 = mmgm_b_Intercept$b_intercept_p1[mmgm_b_Intercept$model_id == id_model_gamma_mirs],
      b_intercept_p2 = mmgm_b_Intercept$b_intercept_p2[mmgm_b_Intercept$model_id == id_model_gamma_mirs],
      index_components =
        index_components |>
        as.matrix()
    )

  stan_data <-
    c(stan_data, priors)

  stan_data

}
