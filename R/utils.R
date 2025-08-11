#' Helper function to compute phi for a beta distribution from mu and sd
#'
#' @noRd
#' @keywords Internal
compute_beta_phi <- function(mean, sd) {
  # Check for valid input
  if (any(mean <= 0) || any(mean >= 1)) {
    stop("Mean must be between 0 and 1 (exclusive).")
  }
  if (any(sd <= 0)) {
    stop("Standard deviation must be positive.")
  }

  # Compute the concentration parameter (common factor)
  var <- sd^2
  common_factor <- (mean * (1 - mean) / var) - 1

  # Compute alpha and beta
  alpha <- mean * common_factor
  beta <- (1 - mean) * common_factor

  # Compute phi (total concentration)
  phi <- alpha + beta

  phi
}
