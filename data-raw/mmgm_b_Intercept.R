## code to prepare `mmgm_b_Intercept` dataset goes here

requireNamespace("irpeatmodels", quietly = TRUE)

mmgm_b_Intercept <-
  data.frame(
    model_id = 1:3,
    .draws =
      I(list(
        as.data.frame(irpeatmodels::model_degree_of_decomposition_1_brms)[["b_Intercept"]],
        as.data.frame(irpeatmodels::model_degree_of_decomposition_2_brms)[["b_Intercept"]],
        as.data.frame(irpeatmodels::model_degree_of_decomposition_3_brms)[["b_Intercept"]]
      ))
  )

mmgm_b_Intercept$model_name <-
  paste0("model_degree_of_decomposition_", mmgm_b_Intercept$model_id)
mmgm_b_Intercept$b_intercept_p1 <-
  vapply(mmgm_b_Intercept$.draws, FUN = mean, FUN.VALUE = numeric(1))
mmgm_b_Intercept$b_intercept_p2 <-
  vapply(mmgm_b_Intercept$.draws, FUN = sd, FUN.VALUE = numeric(1))
mmgm_b_Intercept$.draws <- NULL

usethis::use_data(mmgm_b_Intercept, overwrite = TRUE)
