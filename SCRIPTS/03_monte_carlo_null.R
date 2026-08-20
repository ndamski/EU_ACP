# =============================================================================
# MONTE CARLO: mechanical bias under a true null DGP
# Addresses Overall #1 (no simulation), #5 (is -0.294 distinguishable from
# zero), #6 (does the bias scale with partner trade share)
# =============================================================================
library(tidyverse)
library(fixest)

set.seed(20260818)

simulate_once <- function(n_countries = 78, n_years = 21, eu_share_mean,
                          country_fe_sd = 0.8, year_fe_sd = 0.1) {
  
  panel <- expand_grid(country = 1:n_countries, year = 1:n_years) |>
    mutate(
      country_fe = rep(rnorm(n_countries, sd = country_fe_sd), each  = n_years),
      year_fe    = rep(rnorm(n_years,    sd = year_fe_sd),    times = n_countries),
      # Intra-regional and non-EU trade generated independently of EU trade --
      # the true null this paper's critique is meant to detect.
      intra_trade  = rpois(n(), lambda = exp(3 + country_fe + year_fe + rnorm(n(), sd = 0.3))),
      non_eu_trade = rpois(n(), lambda = exp(4 + country_fe + year_fe + rnorm(n(), sd = 0.3))),
      # EU trade drawn independently -- no diversion, no expansion, by construction.
      eu_trade     = rpois(n(), lambda = exp(3 + log(eu_share_mean / (1 - eu_share_mean)) +
                                               country_fe + year_fe + rnorm(n(), sd = 0.3)))
    ) |>
    mutate(
      total_trade = intra_trade + non_eu_trade + eu_trade,
      it_share    = intra_trade / total_trade,
      s_eu        = eu_trade / total_trade
    ) |>
    group_by(country) |>
    mutate(s_eu_bar = mean(s_eu)) |>
    ungroup() |>
    mutate(it_share_fixeu = intra_trade / (intra_trade + non_eu_trade + s_eu_bar * total_trade))
  
  m_naive    <- feglm(eu_trade ~ it_share        | country + year, panel, family = "poisson")
  m_fixeu    <- feglm(eu_trade ~ it_share_fixeu  | country + year, panel, family = "poisson")
  m_disjoint <- feglm(eu_trade ~ log(intra_trade) + log(non_eu_trade) | country + year,
                      panel, family = "poisson")
  
  tibble(
    eu_share_mean = eu_share_mean,
    naive_coef = coef(m_naive)["it_share"],       naive_se = se(m_naive)["it_share"],
    fixeu_coef = coef(m_fixeu)["it_share_fixeu"],  fixeu_se = se(m_fixeu)["it_share_fixeu"],
    disjoint_coef = coef(m_disjoint)["log(intra_trade)"],
    disjoint_se   = se(m_disjoint)["log(intra_trade)"]
  )
}

eu_share_grid <- c(0.05, 0.10, 0.20, 0.30, 0.40, 0.50)  # answers #6, the scaling question
n_reps <- 200

results <- map_dfr(eu_share_grid, \(s) map_dfr(1:n_reps, \(i) simulate_once(eu_share_mean = s)))

summary_tbl <- results |>
  group_by(eu_share_mean) |>
  summarise(
    naive_mean = mean(naive_coef), naive_reject_neg = mean(naive_coef < 0 & abs(naive_coef/naive_se) > 1.96),
    fixeu_mean = mean(fixeu_coef), fixeu_reject_neg = mean(fixeu_coef < 0 & abs(fixeu_coef/fixeu_se) > 1.96),
    disjoint_mean = mean(disjoint_coef), disjoint_reject = mean(abs(disjoint_coef/disjoint_se) > 1.96)
  )

print(summary_tbl)
write_csv(summary_tbl, "OUTPUT/tables/aux_monte_carlo_null_dgp.csv")