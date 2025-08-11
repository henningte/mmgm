data {
  int<lower=1> N;
  int<lower = 1> K_total;
  array[N, 3] int<lower=1> index_components;
  vector<lower = 0, upper = 1>[K_total] w;
  vector<lower = 0>[N] gamma_mirs_mixture_obs_p1;
  vector<lower = 0>[N] gamma_mirs_mixture_obs_p2;
  real b_intercept_p1;
  real<lower = 0.0> b_intercept_p2;

  // parameters
  vector<lower = 0>[K_total] gamma_component_p1;
  vector<lower = 0>[K_total] gamma_component_p2;
  vector<lower = 0>[N] phi_p1;
  vector<lower = 0>[N] phi_p2;
  vector<lower = 0>[N] phi_p3;
}

parameters {
  vector<lower=0, upper=1>[K_total] gamma_component;
  vector<lower=0>[N] phi;
  vector<lower = 0.0, upper = 1.0>[N] gamma_mirs_mixture_obs;
  real b_intercept;
}

transformed parameters {
  vector<lower=0, upper = 1>[N] gamma_mirs_mixture;
  vector[N] phi_scaled = phi .* phi_p3;
  {
    vector[K_total] gamma_mirs_component;
    gamma_mirs_component = logit(gamma_component) - b_intercept;
    for(n in 1:N) {
      int index_from = index_components[n, 2];
      int index_to = index_components[n, 3];
      gamma_mirs_mixture[n] = inv_logit(dot_product(w[index_from:index_to], gamma_mirs_component[index_from:index_to]) + b_intercept);
    }
  }
}

model {
  // Priors
  gamma_component ~ beta(gamma_component_p1, gamma_component_p2); // example prior, can be changed based on domain knowledge
  phi ~ gamma(phi_p1, phi_p2 .* phi_p3); // small noise
  b_intercept ~ normal(b_intercept_p1, b_intercept_p2);

  // likelihood
  {
    gamma_mirs_mixture_obs_p1 ~ beta(gamma_mirs_mixture_obs .* gamma_mirs_mixture_obs_p2, (1.0 - gamma_mirs_mixture_obs) .* gamma_mirs_mixture_obs_p2);
    gamma_mirs_mixture_obs ~ beta(gamma_mirs_mixture .* phi_scaled, (1.0 - gamma_mirs_mixture) .* phi_scaled);
  }

}

generated quantities {

  vector[N] gamma_mixture;
  for(n in 1:N) {
    int index_from = index_components[n, 2];
    int index_to = index_components[n, 3];
    vector[index_components[n, 1]] m0_component = w[index_from:index_to] ./ (1.0 - gamma_component[index_from:index_to]);
    real m0_mixture = sum(m0_component);
    m0_component = m0_component / m0_mixture;
    gamma_mixture[n] = dot_product(m0_component, gamma_component[index_from:index_to]);
  }

}
