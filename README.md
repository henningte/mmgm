
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mmgm

<!-- badges: start -->

<!-- badges: end -->

Package `mmgm` provides a mixing model that allows to estimate the
degree of decomposition ($\gamma$) of a peat sample (mixture) and of its
individual components from bulk estimates of $\gamma_\text{MIRS}$
(Teickner et al. 2025).

## Installation

You can install the development version of `mmgm` like so:

``` r
remotes::install_github("henningte/mmgm")
```

## Example

To estimate the mixing model, one needs to provide a list with two data
frames as elements. The first element, `components` contains information
on components, and the second element, `mixtures`, contains information
on the mixtures (peat samples):

``` r
library(mmgm)

# show structure of the example data
mmgm_example_data
#> $components
#>     id_mixture id_component         w
#> 1.1          1            1 0.5956979
#> 1.2          1            2 0.4043021
#> 2.1          2            1 0.2799653
#> 2.2          2            2 0.7200347
#> 3.1          3            1 0.5942072
#> 3.2          3            2 0.4057928
#> 4.1          4            1 0.4683780
#> 4.2          4            2 0.5316220
#> 5.1          5            1 0.1578412
#> 5.2          5            2 0.8421588
#> 
#> $mixtures
#>   id_mixture degree_of_decomposition_2
#> 1          1                0.06227749
#> 2          2                0.01924212
#> 3          3                0.02330240
#> 4          4                0.03896350
#> 5          5                0.12042913
```

To prepare estimation of the mixing model, this list is processed with
`mmgm_make_stan_data()`:

``` r
stan_data <- 
  mmgm_make_stan_data(
    x = mmgm_example_data, 
    id_model_gamma_mirs = 2, 
    priors = mmgm_make_default_priors(x = mmgm_example_data)
  )
```

Here, `id_model_gamma_mirs` defines the model that was used to predict
$\gamma_\text{MIRS}$ (the number of the model in the `irpeatmodels`
package (Teickner 2025)). `priors` defines the priors for the mixing
model and `mmgm_make_default_priors()` is a helper function that allows
to define default priors for a given list of data.

`stan_data` can be passed to `mmgm_estimate_gamma_mirs_mixing_1()` to
estimate the mixing model using `CmdStan`. Use the [CmdStan
arguments](https://mc-stan.org/cmdstanr/reference/model-method-sample.html)
to adjust MCMC sampling:

``` r
stan_fit <- 
  mmgm_estimate_gamma_mirs_mixing_1(
    stan_data = stan_data,
    iter_warmup = 1000,
    iter_sampling = 1000,
    chains = 4,
    sig_figs = 14,
    seed = 7667
  )
#> Running MCMC with 4 sequential chains...
#> 
#> Chain 1 Iteration:    1 / 2000 [  0%]  (Warmup) 
#> Chain 1 Iteration:  100 / 2000 [  5%]  (Warmup) 
#> Chain 1 Iteration:  200 / 2000 [ 10%]  (Warmup)
#> Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 1 Exception: gamma_lpdf: Random variable[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 43, column 2 to column 40)
#> Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 1
#> Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 1 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 1
#> Chain 1 Iteration:  300 / 2000 [ 15%]  (Warmup) 
#> Chain 1 Iteration:  400 / 2000 [ 20%]  (Warmup) 
#> Chain 1 Iteration:  500 / 2000 [ 25%]  (Warmup) 
#> Chain 1 Iteration:  600 / 2000 [ 30%]  (Warmup) 
#> Chain 1 Iteration:  700 / 2000 [ 35%]  (Warmup) 
#> Chain 1 Iteration:  800 / 2000 [ 40%]  (Warmup) 
#> Chain 1 Iteration:  900 / 2000 [ 45%]  (Warmup) 
#> Chain 1 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
#> Chain 1 Iteration: 1001 / 2000 [ 50%]  (Sampling)
#> Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 1 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 49, column 4 to column 110)
#> Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 1
#> Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 1 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 1
#> Chain 1 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
#> Chain 1 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
#> Chain 1 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
#> Chain 1 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
#> Chain 1 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
#> Chain 1 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
#> Chain 1 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
#> Chain 1 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
#> Chain 1 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
#> Chain 1 Iteration: 2000 / 2000 [100%]  (Sampling) 
#> Chain 1 finished in 0.4 seconds.
#> Chain 2 Iteration:    1 / 2000 [  0%]  (Warmup) 
#> Chain 2 Iteration:  100 / 2000 [  5%]  (Warmup) 
#> Chain 2 Iteration:  200 / 2000 [ 10%]  (Warmup)
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 49, column 4 to column 110)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 49, column 4 to column 110)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: First shape parameter[1] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Iteration:  300 / 2000 [ 15%]  (Warmup) 
#> Chain 2 Iteration:  400 / 2000 [ 20%]  (Warmup) 
#> Chain 2 Iteration:  500 / 2000 [ 25%]  (Warmup) 
#> Chain 2 Iteration:  600 / 2000 [ 30%]  (Warmup) 
#> Chain 2 Iteration:  700 / 2000 [ 35%]  (Warmup) 
#> Chain 2 Iteration:  800 / 2000 [ 40%]  (Warmup) 
#> Chain 2 Iteration:  900 / 2000 [ 45%]  (Warmup)
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
#> Chain 2 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
#> Chain 2 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
#> Chain 2 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
#> Chain 2 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
#> Chain 2 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
#> Chain 2 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
#> Chain 2 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
#> Chain 2 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
#> Chain 2 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
#> Chain 2 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
#> Chain 2 Iteration: 2000 / 2000 [100%]  (Sampling) 
#> Chain 2 finished in 0.4 seconds.
#> Chain 3 Iteration:    1 / 2000 [  0%]  (Warmup) 
#> Chain 3 Iteration:  100 / 2000 [  5%]  (Warmup) 
#> Chain 3 Iteration:  200 / 2000 [ 10%]  (Warmup) 
#> Chain 3 Iteration:  300 / 2000 [ 15%]  (Warmup)
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: gamma_lpdf: Random variable[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 43, column 2 to column 40)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[1] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Iteration:  400 / 2000 [ 20%]  (Warmup) 
#> Chain 3 Iteration:  500 / 2000 [ 25%]  (Warmup) 
#> Chain 3 Iteration:  600 / 2000 [ 30%]  (Warmup) 
#> Chain 3 Iteration:  700 / 2000 [ 35%]  (Warmup) 
#> Chain 3 Iteration:  800 / 2000 [ 40%]  (Warmup) 
#> Chain 3 Iteration:  900 / 2000 [ 45%]  (Warmup) 
#> Chain 3 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
#> Chain 3 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
#> Chain 3 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
#> Chain 3 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
#> Chain 3 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
#> Chain 3 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
#> Chain 3 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
#> Chain 3 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
#> Chain 3 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
#> Chain 3 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
#> Chain 3 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
#> Chain 3 Iteration: 2000 / 2000 [100%]  (Sampling) 
#> Chain 3 finished in 0.4 seconds.
#> Chain 4 Iteration:    1 / 2000 [  0%]  (Warmup) 
#> Chain 4 Iteration:  100 / 2000 [  5%]  (Warmup)
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: First shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Iteration:  200 / 2000 [ 10%]  (Warmup) 
#> Chain 4 Iteration:  300 / 2000 [ 15%]  (Warmup) 
#> Chain 4 Iteration:  400 / 2000 [ 20%]  (Warmup) 
#> Chain 4 Iteration:  500 / 2000 [ 25%]  (Warmup) 
#> Chain 4 Iteration:  600 / 2000 [ 30%]  (Warmup) 
#> Chain 4 Iteration:  700 / 2000 [ 35%]  (Warmup) 
#> Chain 4 Iteration:  800 / 2000 [ 40%]  (Warmup) 
#> Chain 4 Iteration:  900 / 2000 [ 45%]  (Warmup) 
#> Chain 4 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
#> Chain 4 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
#> Chain 4 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
#> Chain 4 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
#> Chain 4 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
#> Chain 4 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
#> Chain 4 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
#> Chain 4 Iteration: 1600 / 2000 [ 80%]  (Sampling)
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpENUAgT/model-6f82e5cda0.stan', line 49, column 4 to column 110)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
#> Chain 4 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
#> Chain 4 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
#> Chain 4 Iteration: 2000 / 2000 [100%]  (Sampling) 
#> Chain 4 finished in 0.5 seconds.
#> 
#> All 4 chains finished successfully.
#> Mean chain execution time: 0.5 seconds.
#> Total execution time: 2.2 seconds.
```

The result is a `CmdStanMCMC` object for which methods from the
`cmdstanr` package are available, for example:

``` r
stan_fit$diagnostic_summary()
#> $num_divergent
#> [1] 0 0 0 0
#> 
#> $num_max_treedepth
#> [1] 0 0 0 0
#> 
#> $ebfmi
#> [1] 0.8314510 0.8898877 0.9007872 0.8155281
print(stan_fit$summary(), n = 40)
#> # A tibble: 37 × 10
#>    variable       mean   median      sd     mad       q5      q95  rhat ess_bulk
#>    <chr>         <dbl>    <dbl>   <dbl>   <dbl>    <dbl>    <dbl> <dbl>    <dbl>
#>  1 lp__       -47.0    -46.6     3.79    3.66   -5.37e+1 -41.4    1.00     1393.
#>  2 gamma_com…   0.169    0.117   0.160   0.119   1.24e-2   0.508  1.00     2577.
#>  3 gamma_com…   0.273    0.206   0.238   0.229   1.07e-2   0.754  1.00     2994.
#>  4 gamma_com…   0.327    0.259   0.265   0.286   1.01e-2   0.832  1.00     3250.
#>  5 gamma_com…   0.0421   0.0259  0.0508  0.0245  3.73e-3   0.135  1.00     2236.
#>  6 gamma_com…   0.0967   0.0469  0.128   0.0547  3.65e-3   0.371  1.00     2176.
#>  7 gamma_com…   0.223    0.143   0.228   0.179   3.58e-3   0.712  1.00     2936.
#>  8 gamma_com…   0.202    0.127   0.208   0.150   6.21e-3   0.653  1.00     2850.
#>  9 gamma_com…   0.158    0.0962  0.171   0.111   5.63e-3   0.534  1.00     2547.
#> 10 gamma_com…   0.454    0.438   0.285   0.364   3.78e-2   0.922  1.00     5196.
#> 11 gamma_com…   0.271    0.248   0.164   0.170   5.18e-2   0.578  1.00     2245.
#> 12 phi[1]       0.998    0.942   0.440   0.420   3.96e-1   1.81   1.00     3842.
#> 13 phi[2]       0.995    0.934   0.435   0.417   4.00e-1   1.80   1.00     4334.
#> 14 phi[3]       0.993    0.929   0.449   0.426   3.75e-1   1.83   1.00     4538.
#> 15 phi[4]       0.986    0.912   0.437   0.405   3.94e-1   1.77   1.00     4394.
#> 16 phi[5]       1.01     0.953   0.448   0.433   4.02e-1   1.86   1.00     3903.
#> 17 gamma_mir…   0.148    0.140   0.0701  0.0683  4.73e-2   0.273  1.00     2799.
#> 18 gamma_mir…   0.0499   0.0459  0.0264  0.0259  1.40e-2   0.0991 1.00     3041.
#> 19 gamma_mir…   0.0698   0.0647  0.0365  0.0347  1.97e-2   0.139  1.00     3072.
#> 20 gamma_mir…   0.105    0.0978  0.0525  0.0526  3.14e-2   0.200  1.00     2843.
#> 21 gamma_mir…   0.282    0.266   0.143   0.148   7.53e-2   0.544  1.00     2256.
#> 22 b_interce…  -3.52    -3.52    0.131   0.134  -3.73e+0  -3.31   1.00     4827.
#> 23 gamma_mir…   0.154    0.145   0.0734  0.0728  4.83e-2   0.288  1.00     2856.
#> 24 gamma_mir…   0.0571   0.0523  0.0309  0.0297  1.51e-2   0.116  1.00     2933.
#> 25 gamma_mir…   0.0782   0.0728  0.0412  0.0403  2.28e-2   0.155  1.00     2986.
#> 26 gamma_mir…   0.112    0.106   0.0564  0.0576  3.37e-2   0.215  1.00     2518.
#> 27 gamma_mir…   0.286    0.272   0.144   0.150   7.76e-2   0.545  1.00     2193.
#> 28 phi_scale… 200.     188.     88.1    83.9     7.91e+1 362.     1.00     3842.
#> 29 phi_scale… 199.     187.     87.1    83.5     8.00e+1 360.     1.00     4334.
#> 30 phi_scale… 199.     186.     89.8    85.2     7.50e+1 365.     1.00     4538.
#> 31 phi_scale… 197.     182.     87.3    81.0     7.89e+1 353.     1.00     4394.
#> 32 phi_scale… 202.     191.     89.6    86.6     8.04e+1 371.     1.00     3903.
#> 33 gamma_mix…   0.264    0.224   0.162   0.127   7.60e-2   0.591  1.00     2915.
#> 34 gamma_mix…   0.192    0.125   0.178   0.0987  3.38e-2   0.583  1.00     4092.
#> 35 gamma_mix…   0.190    0.138   0.155   0.0939  3.97e-2   0.529  0.999    3282.
#> 36 gamma_mix…   0.220    0.176   0.152   0.112   5.62e-2   0.537  1.00     2622.
#> 37 gamma_mix…   0.373    0.352   0.180   0.178   1.22e-1   0.704  1.00     2872.
#> # ℹ 1 more variable: ess_tail <dbl>
```

## Code of Conduct

Please note that the mmgm project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

# References

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0">

<div id="ref-Teickner.2025g" class="csl-entry">

Teickner, Henning. 2025. “<span class="nocase">irpeatmodels</span>: Mid
Infrared Prediction Models for Peat.”

</div>

<div id="ref-Teickner.2025h" class="csl-entry">

Teickner, Henning, Julien Arsenault, Mariusz Gałka, and Klaus-Holger
Knorr. 2025. “Estimation of the Degree of Decomposition and Past Net
Primary Production of Peat from Mid Infrared Spectra.”

</div>

</div>
