#' Creates a list with default parameter values for a given set of mixtures and components
#'
#' @param x A list with the same structure as argument `x` in
#' `mmgm_make_stan_data()`.
#'
#' @export
mmgm_make_default_priors <- function(x) {

  stopifnot(length(x) == 2 && all(names(x) %in% c("components", "mixtures")))
  N <- nrow(x$mixtures)
  K_total <- nrow(x$components)

  list(
    gamma_component_p1 = rep((0.5) * 2, K_total),
    gamma_component_p2 = rep((1 - 0.5) * 2, K_total),
    phi_p1 = rep(5, N),
    phi_p2 = rep(5/200, N),
    phi_p3 = rep(200, N)
  )

}
