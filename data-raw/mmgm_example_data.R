## code to prepare `mmgm_example_data` dataset goes here

requireNamespace("irpeatmodels", quietly = TRUE)
requireNamespace("irpeat", quietly = TRUE)
requireNamespace("posterior", quietly = TRUE)

set.seed(39348)

mixtures <- irpeat::irpeat_sample_data[1:5, ]
mixtures$id_mixture <- seq_len(nrow(mixtures))
mixtures <- irpeat::irp_degree_of_decomposition_2(mixtures, do_summary = TRUE, summary_function_sd = posterior::sd)
mixtures <- mixtures[, c("id_mixture", "degree_of_decomposition_2")]
components <- mixtures[, setdiff(colnames(mixtures), "degree_of_decomposition_2"), drop = FALSE]
components <-
  split(components, f = components$id_mixture)
components <-
  lapply(
    components,
    FUN =
      function(.x) {
        .x <- .x[rep(1L, 2L), ]
        .x$id_component <- 1:2
        .x$w <- rbeta(2L, 1, 1)
        .x$w <- .x$w/sum(.x$w)
        as.data.frame(.x)
      }
  )
components <- do.call("rbind", components)

mmgm_example_data <-
  list(
    components = components,
    mixtures = mixtures
  )

usethis::use_data(mmgm_example_data, overwrite = TRUE)
