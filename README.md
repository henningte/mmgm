
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
frames as elements. The first element, `components`, contains
information on components, and the second element, `mixtures`, contains
information on the mixtures (peat samples). The structure of this list
is described in detail in the documentation for `mmgm_make_stan_data()`
(`?mmgm_make_stan_data`). Here, we use the example data from `mmgm`,
`mmgm_example_data`:

``` r
library(mmgm)
library(cmdstanr)

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
#> # A tibble: 5 × 2
#>   id_mixture degree_of_decomposition_2
#> *      <int> <quantits>               
#> 1          1 0.06227749               
#> 2          2 0.01924212               
#> 3          3 0.02330240               
#> 4          4 0.03896350               
#> 5          5 0.12042913
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
    iter_warmup = 2000,
    iter_sampling = 2000,
    chains = 4,
    sig_figs = 14,
    seed = 7667
  )
#> Running MCMC with 4 sequential chains...
#> 
#> Chain 1 Iteration:    1 / 4000 [  0%]  (Warmup)
#> Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 1 Exception: gamma_lpdf: Random variable[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 43, column 2 to column 40)
#> Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 1
#> Chain 1 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 1 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 1 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 1 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 1
#> Chain 1 Iteration:  100 / 4000 [  2%]  (Warmup) 
#> Chain 1 Iteration:  200 / 4000 [  5%]  (Warmup) 
#> Chain 1 Iteration:  300 / 4000 [  7%]  (Warmup) 
#> Chain 1 Iteration:  400 / 4000 [ 10%]  (Warmup) 
#> Chain 1 Iteration:  500 / 4000 [ 12%]  (Warmup) 
#> Chain 1 Iteration:  600 / 4000 [ 15%]  (Warmup) 
#> Chain 1 Iteration:  700 / 4000 [ 17%]  (Warmup) 
#> Chain 1 Iteration:  800 / 4000 [ 20%]  (Warmup) 
#> Chain 1 Iteration:  900 / 4000 [ 22%]  (Warmup) 
#> Chain 1 Iteration: 1000 / 4000 [ 25%]  (Warmup) 
#> Chain 1 Iteration: 1100 / 4000 [ 27%]  (Warmup) 
#> Chain 1 Iteration: 1200 / 4000 [ 30%]  (Warmup) 
#> Chain 1 Iteration: 1300 / 4000 [ 32%]  (Warmup) 
#> Chain 1 Iteration: 1400 / 4000 [ 35%]  (Warmup) 
#> Chain 1 Iteration: 1500 / 4000 [ 37%]  (Warmup) 
#> Chain 1 Iteration: 1600 / 4000 [ 40%]  (Warmup) 
#> Chain 1 Iteration: 1700 / 4000 [ 42%]  (Warmup) 
#> Chain 1 Iteration: 1800 / 4000 [ 45%]  (Warmup) 
#> Chain 1 Iteration: 1900 / 4000 [ 47%]  (Warmup) 
#> Chain 1 Iteration: 2000 / 4000 [ 50%]  (Warmup) 
#> Chain 1 Iteration: 2001 / 4000 [ 50%]  (Sampling) 
#> Chain 1 Iteration: 2100 / 4000 [ 52%]  (Sampling) 
#> Chain 1 Iteration: 2200 / 4000 [ 55%]  (Sampling) 
#> Chain 1 Iteration: 2300 / 4000 [ 57%]  (Sampling) 
#> Chain 1 Iteration: 2400 / 4000 [ 60%]  (Sampling) 
#> Chain 1 Iteration: 2500 / 4000 [ 62%]  (Sampling) 
#> Chain 1 Iteration: 2600 / 4000 [ 65%]  (Sampling) 
#> Chain 1 Iteration: 2700 / 4000 [ 67%]  (Sampling) 
#> Chain 1 Iteration: 2800 / 4000 [ 70%]  (Sampling) 
#> Chain 1 Iteration: 2900 / 4000 [ 72%]  (Sampling) 
#> Chain 1 Iteration: 3000 / 4000 [ 75%]  (Sampling) 
#> Chain 1 Iteration: 3100 / 4000 [ 77%]  (Sampling) 
#> Chain 1 Iteration: 3200 / 4000 [ 80%]  (Sampling) 
#> Chain 1 Iteration: 3300 / 4000 [ 82%]  (Sampling) 
#> Chain 1 Iteration: 3400 / 4000 [ 85%]  (Sampling) 
#> Chain 1 Iteration: 3500 / 4000 [ 87%]  (Sampling) 
#> Chain 1 Iteration: 3600 / 4000 [ 90%]  (Sampling) 
#> Chain 1 Iteration: 3700 / 4000 [ 92%]  (Sampling) 
#> Chain 1 Iteration: 3800 / 4000 [ 95%]  (Sampling) 
#> Chain 1 Iteration: 3900 / 4000 [ 97%]  (Sampling) 
#> Chain 1 Iteration: 4000 / 4000 [100%]  (Sampling) 
#> Chain 1 finished in 1.9 seconds.
#> Chain 2 Iteration:    1 / 4000 [  0%]  (Warmup)
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 49, column 4 to column 110)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 49, column 4 to column 110)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 2 Exception: beta_lpdf: First shape parameter[1] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 2 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 2 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 2
#> Chain 2 Iteration:  100 / 4000 [  2%]  (Warmup) 
#> Chain 2 Iteration:  200 / 4000 [  5%]  (Warmup) 
#> Chain 2 Iteration:  300 / 4000 [  7%]  (Warmup) 
#> Chain 2 Iteration:  400 / 4000 [ 10%]  (Warmup) 
#> Chain 2 Iteration:  500 / 4000 [ 12%]  (Warmup) 
#> Chain 2 Iteration:  600 / 4000 [ 15%]  (Warmup) 
#> Chain 2 Iteration:  700 / 4000 [ 17%]  (Warmup) 
#> Chain 2 Iteration:  800 / 4000 [ 20%]  (Warmup) 
#> Chain 2 Iteration:  900 / 4000 [ 22%]  (Warmup) 
#> Chain 2 Iteration: 1000 / 4000 [ 25%]  (Warmup) 
#> Chain 2 Iteration: 1100 / 4000 [ 27%]  (Warmup) 
#> Chain 2 Iteration: 1200 / 4000 [ 30%]  (Warmup) 
#> Chain 2 Iteration: 1300 / 4000 [ 32%]  (Warmup) 
#> Chain 2 Iteration: 1400 / 4000 [ 35%]  (Warmup) 
#> Chain 2 Iteration: 1500 / 4000 [ 37%]  (Warmup) 
#> Chain 2 Iteration: 1600 / 4000 [ 40%]  (Warmup) 
#> Chain 2 Iteration: 1700 / 4000 [ 42%]  (Warmup) 
#> Chain 2 Iteration: 1800 / 4000 [ 45%]  (Warmup) 
#> Chain 2 Iteration: 1900 / 4000 [ 47%]  (Warmup) 
#> Chain 2 Iteration: 2000 / 4000 [ 50%]  (Warmup) 
#> Chain 2 Iteration: 2001 / 4000 [ 50%]  (Sampling) 
#> Chain 2 Iteration: 2100 / 4000 [ 52%]  (Sampling) 
#> Chain 2 Iteration: 2200 / 4000 [ 55%]  (Sampling) 
#> Chain 2 Iteration: 2300 / 4000 [ 57%]  (Sampling) 
#> Chain 2 Iteration: 2400 / 4000 [ 60%]  (Sampling) 
#> Chain 2 Iteration: 2500 / 4000 [ 62%]  (Sampling) 
#> Chain 2 Iteration: 2600 / 4000 [ 65%]  (Sampling) 
#> Chain 2 Iteration: 2700 / 4000 [ 67%]  (Sampling) 
#> Chain 2 Iteration: 2800 / 4000 [ 70%]  (Sampling) 
#> Chain 2 Iteration: 2900 / 4000 [ 72%]  (Sampling) 
#> Chain 2 Iteration: 3000 / 4000 [ 75%]  (Sampling) 
#> Chain 2 Iteration: 3100 / 4000 [ 77%]  (Sampling) 
#> Chain 2 Iteration: 3200 / 4000 [ 80%]  (Sampling) 
#> Chain 2 Iteration: 3300 / 4000 [ 82%]  (Sampling) 
#> Chain 2 Iteration: 3400 / 4000 [ 85%]  (Sampling) 
#> Chain 2 Iteration: 3500 / 4000 [ 87%]  (Sampling) 
#> Chain 2 Iteration: 3600 / 4000 [ 90%]  (Sampling) 
#> Chain 2 Iteration: 3700 / 4000 [ 92%]  (Sampling) 
#> Chain 2 Iteration: 3800 / 4000 [ 95%]  (Sampling) 
#> Chain 2 Iteration: 3900 / 4000 [ 97%]  (Sampling) 
#> Chain 2 Iteration: 4000 / 4000 [100%]  (Sampling) 
#> Chain 2 finished in 1.5 seconds.
#> Chain 3 Iteration:    1 / 4000 [  0%]  (Warmup) 
#> Chain 3 Iteration:  100 / 4000 [  2%]  (Warmup) 
#> Chain 3 Iteration:  200 / 4000 [  5%]  (Warmup) 
#> Chain 3 Iteration:  300 / 4000 [  7%]  (Warmup)
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: gamma_lpdf: Random variable[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 43, column 2 to column 40)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[1] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Iteration:  400 / 4000 [ 10%]  (Warmup) 
#> Chain 3 Iteration:  500 / 4000 [ 12%]  (Warmup) 
#> Chain 3 Iteration:  600 / 4000 [ 15%]  (Warmup) 
#> Chain 3 Iteration:  700 / 4000 [ 17%]  (Warmup) 
#> Chain 3 Iteration:  800 / 4000 [ 20%]  (Warmup) 
#> Chain 3 Iteration:  900 / 4000 [ 22%]  (Warmup) 
#> Chain 3 Iteration: 1000 / 4000 [ 25%]  (Warmup)
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 3 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 3 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 3 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 3
#> Chain 3 Iteration: 1100 / 4000 [ 27%]  (Warmup) 
#> Chain 3 Iteration: 1200 / 4000 [ 30%]  (Warmup) 
#> Chain 3 Iteration: 1300 / 4000 [ 32%]  (Warmup) 
#> Chain 3 Iteration: 1400 / 4000 [ 35%]  (Warmup) 
#> Chain 3 Iteration: 1500 / 4000 [ 37%]  (Warmup) 
#> Chain 3 Iteration: 1600 / 4000 [ 40%]  (Warmup) 
#> Chain 3 Iteration: 1700 / 4000 [ 42%]  (Warmup) 
#> Chain 3 Iteration: 1800 / 4000 [ 45%]  (Warmup) 
#> Chain 3 Iteration: 1900 / 4000 [ 47%]  (Warmup) 
#> Chain 3 Iteration: 2000 / 4000 [ 50%]  (Warmup) 
#> Chain 3 Iteration: 2001 / 4000 [ 50%]  (Sampling) 
#> Chain 3 Iteration: 2100 / 4000 [ 52%]  (Sampling) 
#> Chain 3 Iteration: 2200 / 4000 [ 55%]  (Sampling) 
#> Chain 3 Iteration: 2300 / 4000 [ 57%]  (Sampling) 
#> Chain 3 Iteration: 2400 / 4000 [ 60%]  (Sampling) 
#> Chain 3 Iteration: 2500 / 4000 [ 62%]  (Sampling) 
#> Chain 3 Iteration: 2600 / 4000 [ 65%]  (Sampling) 
#> Chain 3 Iteration: 2700 / 4000 [ 67%]  (Sampling) 
#> Chain 3 Iteration: 2800 / 4000 [ 70%]  (Sampling) 
#> Chain 3 Iteration: 2900 / 4000 [ 72%]  (Sampling) 
#> Chain 3 Iteration: 3000 / 4000 [ 75%]  (Sampling) 
#> Chain 3 Iteration: 3100 / 4000 [ 77%]  (Sampling) 
#> Chain 3 Iteration: 3200 / 4000 [ 80%]  (Sampling) 
#> Chain 3 Iteration: 3300 / 4000 [ 82%]  (Sampling) 
#> Chain 3 Iteration: 3400 / 4000 [ 85%]  (Sampling) 
#> Chain 3 Iteration: 3500 / 4000 [ 87%]  (Sampling) 
#> Chain 3 Iteration: 3600 / 4000 [ 90%]  (Sampling) 
#> Chain 3 Iteration: 3700 / 4000 [ 92%]  (Sampling) 
#> Chain 3 Iteration: 3800 / 4000 [ 95%]  (Sampling) 
#> Chain 3 Iteration: 3900 / 4000 [ 97%]  (Sampling) 
#> Chain 3 Iteration: 4000 / 4000 [100%]  (Sampling) 
#> Chain 3 finished in 1.7 seconds.
#> Chain 4 Iteration:    1 / 4000 [  0%]  (Warmup)
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[3] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: First shape parameter[2] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Informational Message: The current Metropolis proposal is about to be rejected because of the following issue:
#> Chain 4 Exception: beta_lpdf: Second shape parameter[5] is 0, but must be positive finite! (in 'C:/Users/henni/AppData/Local/Temp/RtmpWsY5DI/model-331c6bf6412a.stan', line 48, column 4 to column 151)
#> Chain 4 If this warning occurs sporadically, such as for highly constrained variable types like covariance matrices, then the sampler is fine,
#> Chain 4 but if this warning occurs often then your model may be either severely ill-conditioned or misspecified.
#> Chain 4
#> Chain 4 Iteration:  100 / 4000 [  2%]  (Warmup) 
#> Chain 4 Iteration:  200 / 4000 [  5%]  (Warmup) 
#> Chain 4 Iteration:  300 / 4000 [  7%]  (Warmup) 
#> Chain 4 Iteration:  400 / 4000 [ 10%]  (Warmup) 
#> Chain 4 Iteration:  500 / 4000 [ 12%]  (Warmup) 
#> Chain 4 Iteration:  600 / 4000 [ 15%]  (Warmup) 
#> Chain 4 Iteration:  700 / 4000 [ 17%]  (Warmup) 
#> Chain 4 Iteration:  800 / 4000 [ 20%]  (Warmup) 
#> Chain 4 Iteration:  900 / 4000 [ 22%]  (Warmup) 
#> Chain 4 Iteration: 1000 / 4000 [ 25%]  (Warmup) 
#> Chain 4 Iteration: 1100 / 4000 [ 27%]  (Warmup) 
#> Chain 4 Iteration: 1200 / 4000 [ 30%]  (Warmup) 
#> Chain 4 Iteration: 1300 / 4000 [ 32%]  (Warmup) 
#> Chain 4 Iteration: 1400 / 4000 [ 35%]  (Warmup) 
#> Chain 4 Iteration: 1500 / 4000 [ 37%]  (Warmup) 
#> Chain 4 Iteration: 1600 / 4000 [ 40%]  (Warmup) 
#> Chain 4 Iteration: 1700 / 4000 [ 42%]  (Warmup) 
#> Chain 4 Iteration: 1800 / 4000 [ 45%]  (Warmup) 
#> Chain 4 Iteration: 1900 / 4000 [ 47%]  (Warmup) 
#> Chain 4 Iteration: 2000 / 4000 [ 50%]  (Warmup) 
#> Chain 4 Iteration: 2001 / 4000 [ 50%]  (Sampling) 
#> Chain 4 Iteration: 2100 / 4000 [ 52%]  (Sampling) 
#> Chain 4 Iteration: 2200 / 4000 [ 55%]  (Sampling) 
#> Chain 4 Iteration: 2300 / 4000 [ 57%]  (Sampling) 
#> Chain 4 Iteration: 2400 / 4000 [ 60%]  (Sampling) 
#> Chain 4 Iteration: 2500 / 4000 [ 62%]  (Sampling) 
#> Chain 4 Iteration: 2600 / 4000 [ 65%]  (Sampling) 
#> Chain 4 Iteration: 2700 / 4000 [ 67%]  (Sampling) 
#> Chain 4 Iteration: 2800 / 4000 [ 70%]  (Sampling) 
#> Chain 4 Iteration: 2900 / 4000 [ 72%]  (Sampling) 
#> Chain 4 Iteration: 3000 / 4000 [ 75%]  (Sampling) 
#> Chain 4 Iteration: 3100 / 4000 [ 77%]  (Sampling) 
#> Chain 4 Iteration: 3200 / 4000 [ 80%]  (Sampling) 
#> Chain 4 Iteration: 3300 / 4000 [ 82%]  (Sampling) 
#> Chain 4 Iteration: 3400 / 4000 [ 85%]  (Sampling) 
#> Chain 4 Iteration: 3500 / 4000 [ 87%]  (Sampling) 
#> Chain 4 Iteration: 3600 / 4000 [ 90%]  (Sampling) 
#> Chain 4 Iteration: 3700 / 4000 [ 92%]  (Sampling) 
#> Chain 4 Iteration: 3800 / 4000 [ 95%]  (Sampling) 
#> Chain 4 Iteration: 3900 / 4000 [ 97%]  (Sampling) 
#> Chain 4 Iteration: 4000 / 4000 [100%]  (Sampling) 
#> Chain 4 finished in 1.5 seconds.
#> 
#> All 4 chains finished successfully.
#> Mean chain execution time: 1.6 seconds.
#> Total execution time: 7.2 seconds.
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
#> [1] 0.9133058 0.8814643 0.8198589 0.8952592
print(stan_fit$summary(), n = 40)
#> # A tibble: 37 × 10
#>    variable       mean   median      sd     mad       q5      q95  rhat ess_bulk
#>    <chr>         <dbl>    <dbl>   <dbl>   <dbl>    <dbl>    <dbl> <dbl>    <dbl>
#>  1 lp__       -47.0    -46.6     3.70    3.52   -5.37e+1 -41.6    1.00     2663.
#>  2 gamma_com…   0.170    0.115   0.164   0.120   1.09e-2   0.513  1.00     4937.
#>  3 gamma_com…   0.279    0.209   0.240   0.234   1.11e-2   0.763  1.000    6008.
#>  4 gamma_com…   0.326    0.262   0.272   0.297   8.58e-3   0.849  1.00     7353.
#>  5 gamma_com…   0.0436   0.0271  0.0516  0.0261  3.51e-3   0.139  1.00     4426.
#>  6 gamma_com…   0.0938   0.0468  0.121   0.0547  3.34e-3   0.361  1.00     5142.
#>  7 gamma_com…   0.223    0.143   0.225   0.179   4.92e-3   0.711  1.00     6409.
#>  8 gamma_com…   0.199    0.125   0.206   0.149   6.28e-3   0.648  1.00     6300.
#>  9 gamma_com…   0.161    0.0951  0.174   0.110   6.03e-3   0.543  1.000    6260.
#> 10 gamma_com…   0.456    0.437   0.283   0.362   3.90e-2   0.924  1.000    9569.
#> 11 gamma_com…   0.271    0.242   0.165   0.165   5.49e-2   0.586  1.00     5311.
#> 12 phi[1]       1.000    0.939   0.444   0.423   3.92e-1   1.81   1.00     8554.
#> 13 phi[2]       0.989    0.924   0.433   0.409   3.99e-1   1.79   1.000    8599.
#> 14 phi[3]       0.981    0.918   0.439   0.415   3.76e-1   1.79   1.00     7699.
#> 15 phi[4]       0.989    0.918   0.441   0.419   3.92e-1   1.82   1.000    8326.
#> 16 phi[5]       1.00     0.946   0.445   0.430   3.93e-1   1.83   1.00     8336.
#> 17 gamma_mir…   0.147    0.138   0.0727  0.0710  4.55e-2   0.281  1.00     5104.
#> 18 gamma_mir…   0.0501   0.0465  0.0263  0.0262  1.40e-2   0.0984 1.00     5258.
#> 19 gamma_mir…   0.0704   0.0649  0.0372  0.0367  1.99e-2   0.139  1.000    6989.
#> 20 gamma_mir…   0.105    0.0978  0.0523  0.0512  3.26e-2   0.202  1.00     6868.
#> 21 gamma_mir…   0.284    0.265   0.142   0.144   8.20e-2   0.545  1.00     5718.
#> 22 b_interce…  -3.52    -3.52    0.133   0.133  -3.74e+0  -3.30   1.00    10570.
#> 23 gamma_mir…   0.154    0.145   0.0763  0.0746  4.68e-2   0.295  1.00     5037.
#> 24 gamma_mir…   0.0578   0.0534  0.0315  0.0303  1.55e-2   0.117  1.00     4971.
#> 25 gamma_mir…   0.0788   0.0715  0.0423  0.0412  2.29e-2   0.158  1.000    6206.
#> 26 gamma_mir…   0.113    0.104   0.0566  0.0544  3.52e-2   0.218  1.00     6643.
#> 27 gamma_mir…   0.287    0.269   0.145   0.146   8.20e-2   0.554  1.00     5482.
#> 28 phi_scale… 200.     188.     88.8    84.6     7.84e+1 362.     1.00     8554.
#> 29 phi_scale… 198.     185.     86.6    81.9     7.97e+1 359.     1.000    8599.
#> 30 phi_scale… 196.     184.     87.8    82.9     7.53e+1 357.     1.00     7699.
#> 31 phi_scale… 198.     184.     88.3    83.8     7.85e+1 364.     1.000    8326.
#> 32 phi_scale… 201.     189.     88.9    86.0     7.86e+1 366.     1.00     8336.
#> 33 gamma_mix…   0.268    0.229   0.164   0.132   7.72e-2   0.613  1.00     5950.
#> 34 gamma_mix…   0.195    0.126   0.185   0.0988  3.46e-2   0.612  1.00     8335.
#> 35 gamma_mix…   0.188    0.139   0.153   0.0978  4.03e-2   0.520  1.000    6371.
#> 36 gamma_mix…   0.220    0.175   0.153   0.111   5.55e-2   0.543  1.00     5402.
#> 37 gamma_mix…   0.374    0.350   0.183   0.179   1.22e-1   0.719  1.00     5984.
#> # ℹ 1 more variable: ess_tail <dbl>
```

## Code of Conduct

Please note that the mmgm project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Funding

This study was funded by the Deutsche Forschungsgemeinschaft (DFG,
German Research Foundation) grant no. KN 929/23-1 to Klaus-Holger Knorr
and grant no. PE 1632/18-1 to Edzer Pebesma.

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Teickner.2025g" class="csl-entry">

Teickner, Henning. 2025. *<span class="nocase">irpeatmodels</span>:
<span class="nocase">Mid-infrared</span> Prediction Models for Peat*.
Zenodo. <https://doi.org/10.5281/ZENODO.17187912>.

</div>

<div id="ref-Teickner.2025h" class="csl-entry">

Teickner, Henning, Julien Arsenault, Mariusz Gałka, and Klaus-Holger
Knorr. 2025. *Estimation of the Degree of Decomposition of Peat and Past
Net Primary Production from Mid-Infrared Spectra*.

</div>

</div>
