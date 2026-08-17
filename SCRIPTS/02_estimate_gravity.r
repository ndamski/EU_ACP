# =============================================================================
# EU-ACP GRAVITY MODEL - ESTIMATION                            [SCRIPT 02 of 02]
# =============================================================================
# Research question:
#   Does intra-regional trade integration (IT Share) among ACP blocs act as a
#   stumbling block or a building block for bilateral trade with EU members?
#   Secondary: does an in-force EPA moderate that relationship?
#
# Panel: 78 ACP countries (7 RECs) x EU-27 + UK (GBR 1995-2020) x 1995-2021.
# Estimator: PPML (fepois) with EU-partner x year and ACP-country fixed effects.
#
# -----------------------------------------------------------------------------
# RUN WITH source() IN A FRESH SESSION:
#   source(file.path(PROJ_ROOT, "SCRIPTS", "02_estimate_gravity.R"), echo = TRUE)
# Never paste. RStudio silently truncates large pastes.
#
# Do not trust the completion message at the end -- it fires regardless.
# Section 19 verifies the files actually landed on disk with a timestamp from
# this run.
# -----------------------------------------------------------------------------
# Run after 01_build_panel.R has saved eu_acp_panel.rds.
# =============================================================================

library(tidyverse)
library(fixest)        # fepois, feols, fenegbin, etable, se, wald, setFixest_dict
library(RColorBrewer)

set.seed(42)
RUN_START <- Sys.time()


# =============================================================================
# 0. CONFIGURATION
# =============================================================================
PROJ_ROOT <- "C:/Users/ndams/Documents/EU_ACP_Trade_Paper"

if (!dir.exists(PROJ_ROOT))
  stop("PROJ_ROOT does not exist: ", PROJ_ROOT)

# --- Inference --------------------------------------------------------------
# it_share is constant across the 28 EU partners within an ACP country-year, so
# the effective number of independent draws on the key regressor is the number
# of ACP countries, not the number of dyads. ~acp_iso3 (78 clusters) allows
# arbitrary correlation across partners AND over time within a country.
# Section 9 reports every alternative; change this line to change the paper.
CLUSTER_MAIN <- ~acp_iso3
CLUSTER_LABEL <- "ACP country"

# --- Sample period ----------------------------------------------------------
# 1995 keeps five extra years for the 70 non-SADC countries but requires the
# bloc-specific NA rule in Section 2 to be defended in print. 2000 makes the
# sample definition a one-line statement ("BACI coverage of SACU begins in
# 2000") at the cost of the pre-Cotonou window. Both are estimated regardless;
# this flag only decides which is the headline.
SAMPLE_START     <- 2000L
ALT_SAMPLE_START <- 1995L

# --- Optional / slow --------------------------------------------------------
RUN_NEGBIN <- TRUE     # fenegbin takes several minutes; set FALSE while iterating
SAVE_FIGS  <- TRUE

DIR_DATA <- file.path(PROJ_ROOT, "DATA")
DIR_OUT  <- file.path(PROJ_ROOT, "OUTPUT")
DIR_FIG  <- file.path(DIR_OUT, "figures")
DIR_TAB  <- file.path(DIR_OUT, "tables")

dir.create(DIR_FIG, recursive = TRUE, showWarnings = FALSE)
dir.create(DIR_TAB, recursive = TRUE, showWarnings = FALSE)

PANEL_RDS <- file.path(DIR_DATA, "eu_acp_panel.rds")

# -----------------------------------------------------------------------------
# Output filenames, prefixed with the table number they carry in the paper.
# This is the whole mapping in one place -- when a table is renumbered, change
# it here and nowhere else. "aux_" files are supporting output not numbered in
# the paper.
#
# RENUMBERED 2026-08-11 to match reading order in paper_master_draft.md.
# Old numbers (this section's numbering before today) in parens for anyone
# cross-referencing an old draft or an old session handoff.
#
#   Table 1  main specifications                          (unchanged)
#   Table 2  predicted trade differences (contrasts)       (unchanged)
#   Table 3  MECHANICAL ENDOGENEITY BATTERY                (was Table 5)
#   Table 4  ratio restriction test                        (was Table 3,
#                                                            table_ratio_restriction.tex)
#   Table 5  directional decomposition (naive share, EPA)  (was Table 3 --
#                                                            note this is a
#                                                            DIFFERENT old
#                                                            "Table 3" than
#                                                            the ratio-
#                                                            restriction one
#                                                            above; the two
#                                                            were previously
#                                                            distinguished
#                                                            only by file name,
#                                                            not by number,
#                                                            which is exactly
#                                                            the confusion this
#                                                            renumbering fixes)
#   Table 6  REC heterogeneity (interaction model)         (was Table 4)
#   Table 7  robustness: estimators and measurement        (was Table 6)
#   Table 8  robustness: sample restrictions                (was Table 7)
#   Table 9  external check: China/US as substitute outcome, and China's
#            trade share as a covariate (three columns as of this session;
#            sourced from table9_diversion_check.tex)
#   Table 10 direction-matched robustness: EU-component-fixed share and
#            direction-matched ex-EU share (promoted this session from
#            aux_directional_clean.tex, previously unnumbered and, it turned
#            out, never actually cited anywhere in the paper -- see notes at
#            its declaration below)
#   (clustering ladder, aux_cluster_sensitivity.tex, is NOT a numbered table
#   in the paper -- see notes at its declaration below.)
# -----------------------------------------------------------------------------
F_T1_MAIN       <- file.path(DIR_TAB, "table1_main_results.tex")
F_T2_MARGINAL   <- file.path(DIR_TAB, "table2_marginal_effects.tex")
F_T2_MARGINAL_C <- file.path(DIR_TAB, "table2_marginal_effects.csv")
F_T3_MECHANICAL <- file.path(DIR_TAB, "table3_mechanical_endogeneity.tex")
F_T4_RESTRICTION <- file.path(DIR_TAB, "table4_ratio_restriction.tex")
F_T5_DIRECTION  <- file.path(DIR_TAB, "table5_direction_results.tex")
F_T6_RECINTER   <- file.path(DIR_TAB, "table6_rec_interactions.tex")
F_T7_ESTIMATORS <- file.path(DIR_TAB, "table7_robustness_estimators.tex")
F_T8_SAMPLE     <- file.path(DIR_TAB, "table8_robustness_sample.tex")
F_T9_DIVERSION  <- file.path(DIR_TAB, "table9_diversion_check.tex")
F_T10_DIRCLEAN  <- file.path(DIR_TAB, "table10_directional_construction.tex")

# NOT a numbered table in the paper -- kept as "aux_" rather than a "tableN_"
# name that would fake a citation that doesn't exist. See notes at the
# section that writes it (Section 8).
F_AUX_CLUSTER   <- file.path(DIR_TAB, "aux_cluster_sensitivity.tex")
F_AUX_CLUSTER_C <- file.path(DIR_TAB, "aux_cluster_sensitivity.csv")
# aux_disjoint_decomposition.tex REMOVED entirely 2026-08-11 (was previously
# corrected from "deprecated" to "keep" earlier the same session -- this is
# a further revision, not a reversal of that correction). All 5 of its
# columns are now accounted for elsewhere with no information lost: columns
# (2)-(4) duplicated Table 4's Disjoint rows exactly; column (1) is fully
# preserved as a console message in Section 10.3 (the "Baseline on the
# log-spec sample" line); column (5), the China-share control, was relocated
# to Section 10.3b next to the other China/diversion-partner checks, per
# discussion with the user about where it thematically belongs.

F_AUX_LEAVEOUT  <- file.path(DIR_TAB, "aux_leave_one_rec_out.tex")
F_AUX_SUMSTATS  <- file.path(DIR_TAB, "aux_summary_statistics.csv")
F_AUX_MISSING   <- file.path(DIR_TAB, "aux_missing_covariates.csv")
F_AUX_EUSHARE   <- file.path(DIR_TAB, "aux_eu_trade_share.csv")
F_AUX_PERIODS   <- file.path(DIR_TAB, "aux_beta_by_period.csv")
F_AUX_CONSOL    <- file.path(DIR_TAB, "aux_results_consolidated.csv")
F_AUX_RESTRICT  <- file.path(DIR_TAB, "aux_ratio_restrictions.csv")


EXPECTED_OUTPUTS <- c(
  F_T1_MAIN, F_T2_MARGINAL, F_T2_MARGINAL_C, F_T3_MECHANICAL, F_T4_RESTRICTION,
  F_T5_DIRECTION, F_T6_RECINTER, F_T7_ESTIMATORS, F_T8_SAMPLE, F_T9_DIVERSION,
  F_AUX_CLUSTER, F_AUX_CLUSTER_C, F_T10_DIRCLEAN, F_AUX_LEAVEOUT, F_AUX_SUMSTATS,
  F_AUX_EUSHARE, F_AUX_PERIODS, F_AUX_CONSOL, F_AUX_RESTRICT
)


# =============================================================================
# 0.5 HELPERS
# =============================================================================
# Defined up front because Sections 9, 11, 15, 17 and 18 all need them, and
# because fenegbin may legitimately fail to converge, leaving m2_nb NULL.
safe_coef <- function(model, var) {
  if (is.null(model)) return(NA_real_)
  if (var %in% names(coef(model))) coef(model)[[var]] else NA_real_
}
safe_se <- function(model, var, vcov = NULL) {
  if (is.null(model)) return(NA_real_)
  s <- if (is.null(vcov)) model else tryCatch(summary(model, cluster = vcov),
                                              error = function(e) model)
  if (var %in% names(se(s))) se(s)[[var]] else NA_real_
}
safe_nobs <- function(model) {
  if (is.null(model)) NA_integer_ else nobs(model)
}

# Significance from the exact ratio, never from a rounded one.
stars <- function(coef, se) {
  t <- abs(coef / se)
  case_when(
    is.na(t)    ~ "",
    t > 2.576   ~ "***",
    t > 1.960   ~ "**",
    t > 1.645   ~ "*",
    TRUE        ~ ""
  )
}

# Percentage change in trade implied by a CHANGE of `delta` in the regressor.
pct_change <- function(b, delta) 100 * (exp(b * delta) - 1)

# fixest::wald() returns a list; older versions name the elements differently.
# This pulls the statistic and p-value out without assuming which.
wald_bits <- function(w) {
  if (is.null(w)) return(list(stat = NA_real_, p = NA_real_))
  s <- if (!is.null(w$stat)) w$stat else if (!is.null(w[["Wald"]])) w[["Wald"]] else NA_real_
  p <- if (!is.null(w$p)) w$p else if (!is.null(w[["p-value"]])) w[["p-value"]] else NA_real_
  list(stat = as.numeric(s), p = as.numeric(p))
}

fit_ppml <- function(fml, dat, cl = CLUSTER_MAIN) {
  fepois(fml, data = dat, cluster = cl)
}


# =============================================================================
# 1. LOAD AND VALIDATE PANEL
# =============================================================================
if (!file.exists(PANEL_RDS))
  stop("Panel not found: ", PANEL_RDS, "\n  Run 01_build_panel.R first.")

panel <- readRDS(PANEL_RDS)

# A corrupt .rds containing fixest::panel() would otherwise fail three lines
# down with "object of type 'closure' is not subsettable", which reads like a
# pipeline bug and is not.
if (!is.data.frame(panel))
  stop("eu_acp_panel.rds does not contain a data frame -- it holds an object ",
       "of class '", paste(class(panel), collapse = "/"), "'.\n",
       "  Restore from eu_acp_panel.csv and re-save.")

prov <- attr(panel, "provenance")
if (!is.null(prov)) {
  message("Panel provenance: built ", format(prov$built, "%Y-%m-%d %H:%M"),
          " | BACI ", prov$baci, " | Gravity ", prov$gravity,
          " | years ", paste(prov$years, collapse = "-"),
          " | MRT/TLS fix ", if (isTRUE(prov$mrt_tls_fix)) "ON" else "OFF")
} else {
  message("Panel carries no provenance stamp (built before stamping was added).")
}

if (n_distinct(panel$acp_iso3) != 78)
  stop(sprintf("Expected 78 ACP countries, got %d.", n_distinct(panel$acp_iso3)))

# total_trade and intra_trade are REQUIRED by Section 3's mechanical diagnostics.
# They come through the intra_rec_share join in 01_build_panel.R.
required_cols <- c("pair_id","ACP_to_EU","EU_to_ACP","total_bilateral",
                   "it_share","it_share_exeu","it_intensity",
                   "total_trade","intra_trade",
                   "ln_dist","lang","colonial","contiguity","epa",
                   "gdp_acp","gdp_eu","pop_acp","ln_gdp_acp",
                   "exporter_year","acp_iso3","eu_iso3","year","rec")
missing_cols <- setdiff(required_cols, names(panel))
if (length(missing_cols) > 0)
  stop("Panel missing columns: ", paste(missing_cols, collapse = ", "),
       "\n  total_trade / intra_trade come from the intra_rec_share select() ",
       "in 01_build_panel.R. If they are absent the panel predates that change.")

# Post-conference additions (2026-08-04). These reach the panel only through
# the 2026-08-04 revision of 01_build_panel.R. Guarded rather than required,
# so this script still runs against an older panel -- it just skips the four
# new robustness columns instead of failing. Message fires once, here, rather
# than being rediscovered separately at each point of use below.
NEW_CONTROL_COLS <- c("china_trade", "us_trade", "eu_partner_hhi", "export_hhi",
                      "peg_cemac", "peg_waemu", "peg_comoros",
                      "peg_cma", "peg_eccu", "peg_pacific",
                      "eur_peg", "other_currency_union", "gdp_pc_eu")
HAS_NEW_CONTROLS <- all(NEW_CONTROL_COLS %in% names(panel))
if (!HAS_NEW_CONTROLS) {
  message("Post-conference control columns (china_trade, us_trade, ",
          "eu_partner_hhi, export_hhi, the six granular currency-union flags, ",
          "gdp_pc_eu) absent from the panel. Rebuild with the current ",
          "01_build_panel.R to enable the robustness columns on Tables 6 and ",
          "10, the currency-peg / export-concentration diagnostic in Section ",
          "11.5, and the diversion parallel-DV section. Proceeding without them.")
}

if (anyDuplicated(panel[, c("acp_iso3","eu_iso3","year")]))
  stop("Duplicate acp_iso3 x eu_iso3 x year rows - check panel build.")

if (any(panel$eu_iso3 == "GBR" & panel$year == 2021))
  stop("GBR x 2021 rows present - check EU_EXIT filter in 01_build_panel.R.")
if (!any(panel$eu_iso3 == "GBR"))
  stop("GBR absent from panel - delete eu_acp_panel.rds and re-run 01.")

n_eu <- n_distinct(panel$eu_iso3)
if (n_eu != 28)
  stop(sprintf("Expected 28 EU partners (EU-27 + GBR), got %d.", n_eu))

REC_LEVELS  <- c("ECOWAS","Central Africa","SADC","EAC","ESA","CARIFORUM","PIF")
REC_COLOURS <- setNames(brewer.pal(7, "Set2"), REC_LEVELS)

# Short, syntactically safe tags for the interaction columns built in Section 12.
REC_TAGS <- c("ECOWAS" = "ECOWAS", "Central Africa" = "CAF", "SADC" = "SADC",
              "EAC" = "EAC", "ESA" = "ESA", "CARIFORUM" = "CARIFORUM",
              "PIF" = "PIF")

# factor(rec, levels = REC_LEVELS) silently converts any unlisted label to NA.
# The historical failure mode is a script-01 revision that writes "COMESA"
# instead of "ESA", which would wipe twelve countries without an error.
unknown_recs <- setdiff(na.omit(unique(as.character(panel$rec))), REC_LEVELS)
if (length(unknown_recs))
  stop("Panel contains REC labels absent from REC_LEVELS: ",
       paste(unknown_recs, collapse = ", "),
       ".\n  factor() would turn these into NA silently.")

panel <- panel |>
  mutate(
    rec        = factor(rec, levels = REC_LEVELS),
    acp_region = case_when(
      rec %in% c("ECOWAS","Central Africa","SADC","EAC","ESA") ~ "Africa",
      rec == "CARIFORUM" ~ "Caribbean",
      rec == "PIF"       ~ "Pacific"
    ),
    ln_trade_plus = log1p(total_bilateral),
    pop_acp_ln    = log(pop_acp)
  )

# gdp_pc_eu arrives from script 01 as a level (gdp_eu / pop_eu). It is NOT
# usable as a naked regressor: it varies only at eu_iso3 x year, exactly the
# level the exporter_year fixed effect already spans, so a level term would be
# perfectly collinear with that FE and fixest would silently drop it -- the
# same failure mode as entering eur_peg as a level against the acp_iso3 FE
# above. The Linder hypothesis is about income SIMILARITY between the two
# trading partners, not either side's level in isolation, so the standard fix
# is also the economically correct one: an EU-ACP per-capita income gap, which
# varies at the full dyad-year level and is not spanned by either FE.
if (HAS_NEW_CONTROLS) {
  panel <- panel |>
    mutate(
      ln_gdp_pc_eu  = if_else(gdp_pc_eu > 0, log(gdp_pc_eu), NA_real_),
      ln_gdp_pc_acp = ln_gdp_acp - pop_acp_ln,
      gdp_pc_gap    = abs(ln_gdp_pc_eu - ln_gdp_pc_acp)
    )
}


# =============================================================================
# 2. BACI COVERAGE CORRECTION - SADC PRE-2000
# =============================================================================
# BACI has no records at all for SACU countries (BWA, LSO, NAM, SWZ, ZAF) before
# 2000; Comtrade reported the customs union under a single code until then. The
# consequence is not confined to SACU: because SACU members are absent from the
# data, the intra-SADC trade of AGO, COD and MOZ also reads exactly 0.0000 for
# 1995-1999. Every SADC member therefore shows it_share = 0 across those five
# years, while all six other RECs are continuous through the 1999-2000 boundary
# (ECOWAS 0.130 -> 0.156, EAC 0.158 -> 0.158, ESA 0.0478 -> 0.0524,
# CARIFORUM 0.145 -> 0.119).
#
# Those zeros are missing data, not observed absence of integration. Left in,
# they hand the highest-integration bloc five years of artificial zero IT share
# next to whatever EU trade is recorded, producing a within-country association
# between integration and trade that the fixed effects cannot absorb and that is
# entirely an artifact of coverage. Reproduced: leaving them in gives +0.638
# (0.345); the old donor-pool imputation gives -0.3413 (0.2831), reproducing the
# published figure to seven significant digits; removing them gives -2.688.
#
# ---------------------------------------------------------------------------
# NOTE ON THE DELETED IMPUTATION. Earlier versions filled SACU's missing
# it_share from the annual mean of the non-SACU SADC members. That apparatus is
# gone. Two reasons. First, four of its five original donors (MWI, ZMB, ZWE ->
# ESA; TZA -> EAC) carry a different bloc's integration share, so it was
# substituting an intra-ESA measure for an intra-SADC one. Second, once the
# donor pool is corrected to the three countries that actually carry
# rec == "SADC" (MOZ, AGO, COD), no donor has positive intra-bloc trade in
# 1995-1999 either -- because they traded with the absent SACU five. Zero cells
# are imputable. The honest treatment is NA, which is what this block does.
# ---------------------------------------------------------------------------
SADC_COVERAGE_START <- 2000L
SACU_ISO3 <- c("BWA","SWZ","LSO","NAM","ZAF")

sadc_pre <- panel |> filter(rec %in% "SADC", year < SADC_COVERAGE_START)
message(sprintf(
  "SADC pre-%d BACI coverage gap: %d dyad-years set to NA (%d already NA).",
  SADC_COVERAGE_START, nrow(sadc_pre), sum(is.na(sadc_pre$it_share))
))

# any_of() rather than a bare c(): this block runs at the top of the script,
# long before HAS_DIR_SHARES / HAS_DIR_COMPONENTS are defined, so it is the one
# place that cannot be guarded by a flag. Tidyselect skips absent columns, which
# keeps the script runnable against a pre-rebuild panel.
#
# intra_imports and intra_exports are included; non_eu_imports and
# non_eu_exports are NOT. The coverage defect is in the intra-regional
# numerator, not in the non-EU aggregates, and total_trade / non_eu_trade are
# already left untouched by this rule. Blanking the denominators too would be
# inconsistent with how the pooled measures are handled, and would change
# nothing in estimation anyway -- an NA numerator drops the row on its own.
panel <- panel |>
  mutate(across(
    any_of(c("it_share", "it_share_exeu", "it_share_exeu_x", "it_share_exeu_m",
             "it_intensity", "intra_trade", "intra_imports", "intra_exports")),
    ~if_else(rec %in% "SADC" & year < SADC_COVERAGE_START, NA_real_, .x)
  ))

# Audit trail: which SACU country-years were affected, for the data appendix.
sacu_audit <- panel |>
  filter(acp_iso3 %in% SACU_ISO3, year < SADC_COVERAGE_START) |>
  distinct(acp_iso3, year) |>
  count(acp_iso3, name = "n_years_blanked")
message("SACU country-years touched by the coverage rule (pre-", SADC_COVERAGE_START, "):")
print(sacu_audit)

panel_full <- panel

if (SAMPLE_START >= SADC_COVERAGE_START) {
  message("  The SADC coverage rule does not bind in the headline sample: every ",
          "row it blanks is dropped by the period filter regardless. It is ",
          "retained because panel_full feeds the alternative-start column, ",
          "where it does bind.")
}

# Headline sample. panel_full above keeps the full 1995-2021 span for the
# alternative-start column in Section 14; everything below this line runs on
# SAMPLE_START onward, including the s_eu quantities built in Section 3.
panel <- panel |> filter(year >= SAMPLE_START)

if (min(panel$year) != SAMPLE_START)
  stop("Period filter did not bind: panel starts at ", min(panel$year), ".")

message(sprintf("Headline sample: %d-%d, %s dyad-years, %d ACP countries.",
                SAMPLE_START, max(panel$year),
                format(nrow(panel), big.mark = ","),
                n_distinct(panel$acp_iso3)))


# =============================================================================
# 3. DERIVED VARIABLES FOR THE MECHANICAL-ENDOGENEITY BATTERY
# =============================================================================
# The identity that organises this whole section:
#
#     it_share       = intra_trade / total_trade
#     it_share_exeu  = intra_trade / non_eu_trade
#     total_trade    = non_eu_trade + eu_trade
#     s_eu           = eu_trade / total_trade
#
#  =>  it_share = it_share_exeu * (1 - s_eu)
#
# The baseline regressor therefore contains a term, (1 - s_eu), that falls
# mechanically whenever the ACP country's EU trade rises. Since the dependent
# variable IS a component of EU trade, part of any negative coefficient on
# it_share is arithmetic rather than economics. Everything below is built to
# measure how much.
#
# eu_trade is reconstructed by summing the dependent variable across the 28 EU
# partners within each ACP country-year. That is exactly the quantity sitting
# inside the denominator, so the reconstruction is definitional rather than
# approximate -- and the identity above gives a free validation check.
# ---------------------------------------------------------------------------
eu_trade_ct <- panel |>
  group_by(acp_iso3, year) |>
  summarise(eu_trade = sum(total_bilateral, na.rm = TRUE), .groups = "drop")

panel <- panel |>
  left_join(eu_trade_ct, by = c("acp_iso3", "year")) |>
  mutate(
    s_eu         = if_else(total_trade > 0, eu_trade / total_trade, NA_real_),
    non_eu_trade = total_trade - eu_trade
  )

# --- Unit and consistency checks --------------------------------------------
# If total_trade and total_bilateral were on different scales, s_eu would blow
# straight through 1. This is the check that catches it.
s_eu_bad <- panel |> filter(!is.na(s_eu), s_eu < 0 | s_eu > 1) |> nrow()
if (s_eu_bad > 0) {
  panel |> filter(!is.na(s_eu), s_eu < 0 | s_eu > 1) |>
    distinct(acp_iso3, year, s_eu, total_trade, eu_trade) |>
    arrange(desc(s_eu)) |> head(20) |> print()
  stop(s_eu_bad, " country-years have an EU trade share outside [0, 1]. ",
       "total_trade (from BACI, script 01 Section 6) and total_bilateral ",
       "(script 01 Section 7) are probably on different scales.")
}

# it_share_exeu * (1 - s_eu) must reproduce it_share. A material gap means the
# reconstructed EU aggregate does not match the one script 01 netted out --
# most likely a GBR handling difference (script 01 excludes GBR from the ex-EU
# denominator in every year; the panel drops GBR rows only from 2021).
identity_check <- panel |>
  filter(!is.na(it_share), !is.na(it_share_exeu), !is.na(s_eu)) |>
  distinct(acp_iso3, year, it_share, it_share_exeu, s_eu) |>
  mutate(implied = it_share_exeu * (1 - s_eu),
         gap     = abs(implied - it_share))
message(sprintf(
  "IT-share identity check: max |implied - actual| = %.2e, mean = %.2e (n = %d)",
  max(identity_check$gap, na.rm = TRUE),
  mean(identity_check$gap, na.rm = TRUE),
  nrow(identity_check)
))
if (mean(identity_check$gap, na.rm = TRUE) > 0.005) {
  identity_check |> arrange(desc(gap)) |> head(15) |> print()
  warning("The IT-share identity does not close to within 0.005. The ex-EU ",
          "denominator in script 01 and the EU aggregate reconstructed here ",
          "are measuring different things. Resolve before using Table 3.",
          call. = FALSE)
}

# --- china_share (added 2026-08, post-conference) ---------------------------
# Same construction as s_eu, filtered to CHN instead of EU_ISO3, using
# china_trade carried through from 01_build_panel.R (there, since only that
# script has access to raw `baci`; panel here has no China bilateral flows to
# reconstruct the aggregate from the way eu_trade_ct is reconstructed above).
# Purpose: rules out a China-side contamination of the "clean" non_eu_trade
# denominator before a referee asks the question. Used only as an added
# control in the deprecated Section 10.3 disjoint-decomposition output only -- never enters the baseline formula, and the deprecation there applies here too.
if (HAS_NEW_CONTROLS) {
  panel <- panel |>
    mutate(china_share = if_else(total_trade > 0, china_trade / total_trade,
                                 NA_real_))
  
  china_bad <- panel |> filter(!is.na(china_share),
                               china_share < 0 | china_share > 1) |> nrow()
  if (china_bad > 0)
    stop(china_bad, " country-years have china_share outside [0, 1]. ",
         "china_trade in the panel and total_trade are probably inconsistent.")
  
  message(sprintf("China trade share: mean %.4f, max %.4f (n = %d non-missing).",
                  mean(panel$china_share, na.rm = TRUE),
                  max(panel$china_share, na.rm = TRUE),
                  sum(!is.na(panel$china_share))))
  
  # --- us_share (added this session, for symmetry with china_share) ---------
  # Same construction, filtered to us_trade instead of china_trade. Added
  # for symmetry in Table 9's covariate check (both partners now tested both
  # as a substitute outcome AND as a share-control), not because a referee
  # is as likely to ask the US version unprompted -- China's rising trade
  # share is the more obvious confound story. Kept anyway since the
  # asymmetry (China tested both ways, US only one) had no principled reason
  # behind it once china_share existed as a pattern to copy.
  panel <- panel |>
    mutate(us_share = if_else(total_trade > 0, us_trade / total_trade,
                              NA_real_))
  
  us_bad <- panel |> filter(!is.na(us_share),
                            us_share < 0 | us_share > 1) |> nrow()
  if (us_bad > 0)
    stop(us_bad, " country-years have us_share outside [0, 1]. ",
         "us_trade in the panel and total_trade are probably inconsistent.")
  
  message(sprintf("US trade share: mean %.4f, max %.4f (n = %d non-missing).",
                  mean(panel$us_share, na.rm = TRUE),
                  max(panel$us_share, na.rm = TRUE),
                  sum(!is.na(panel$us_share))))
}

# --- s_eu summary, for the paper's data section -----------------------------
eu_share_summary <- panel |>
  filter(!is.na(s_eu), !is.na(rec)) |>
  distinct(acp_iso3, year, rec, s_eu) |>
  group_by(rec) |>
  summarise(mean_s_eu = round(mean(s_eu), 4),
            sd_s_eu   = round(sd(s_eu), 4),
            .groups = "drop")

eu_share_by_year <- panel |>
  filter(!is.na(s_eu)) |>
  distinct(acp_iso3, year, s_eu) |>
  group_by(year) |>
  summarise(mean_s_eu = round(mean(s_eu), 4), .groups = "drop")

message("EU share of ACP total trade, by REC:")
print(eu_share_summary)
message(sprintf("Pooled mean EU share of ACP trade: %.4f",
                mean(panel$s_eu, na.rm = TRUE)))
write_csv(
  bind_rows(
    eu_share_summary |> transmute(grouping = as.character(rec), mean_s_eu, sd_s_eu),
    eu_share_by_year |> transmute(grouping = as.character(year), mean_s_eu,
                                  sd_s_eu = NA_real_)
  ),
  F_AUX_EUSHARE
)

# --- it_share_fixeu: the scale-comparable mechanical control ----------------
# it_share_exeu answers the endogeneity question but is roughly 1/(1 - s_eu)
# times larger than it_share, so its coefficient cannot be read against the
# baseline without a scale adjustment the reader has to take on trust.
#
# it_share_fixeu holds the EU component of the denominator at the country's own
# average EU dependence instead of removing it:
#
#     it_share_fixeu = it_share_exeu * (1 - mean_t(s_eu))
#
# Time variation in the denominator's EU component -- the mechanical channel --
# is gone. Time variation in intra-regional trade and in non-EU trade -- the
# economics -- is untouched. And because it differs from it_share only in
# replacing s_eu(c,t) with s_eu(c), the two variables have essentially the same
# mean and spread, so their coefficients ARE directly comparable.
panel <- panel |>
  group_by(acp_iso3) |>
  mutate(s_eu_bar = mean(s_eu, na.rm = TRUE)) |>
  ungroup() |>
  mutate(
    s_eu_bar       = if_else(is.finite(s_eu_bar), s_eu_bar, NA_real_),
    it_share_fixeu = it_share_exeu * (1 - s_eu_bar),
    s_eu_dev       = s_eu - mean(s_eu, na.rm = TRUE)
  )

scale_check <- panel |>
  summarise(
    mean_it        = mean(it_share,       na.rm = TRUE),
    mean_it_fixeu  = mean(it_share_fixeu, na.rm = TRUE),
    mean_it_exeu   = mean(it_share_exeu,  na.rm = TRUE),
    sd_it          = sd(it_share,         na.rm = TRUE),
    sd_it_fixeu    = sd(it_share_fixeu,   na.rm = TRUE),
    ratio_exeu     = mean(it_share_exeu / it_share, na.rm = TRUE)
  )
message(sprintf(
  "Scale check -- mean it_share %.4f | it_share_fixeu %.4f | it_share_exeu %.4f (ratio %.3f)",
  scale_check$mean_it, scale_check$mean_it_fixeu,
  scale_check$mean_it_exeu, scale_check$ratio_exeu
))
message(sprintf(
  "  SD it_share %.4f vs it_share_fixeu %.4f -- these must be close for the ",
  scale_check$sd_it, scale_check$sd_it_fixeu
))
message("  Table 3 columns (1) and (3) to be read as comparable magnitudes.")

# --- Log decomposition ------------------------------------------------------
# ln(it_share)      = ln(intra) - ln(total)     [total contains EU trade]
# ln(it_share_exeu) = ln(intra) - ln(non-EU)    [clean]
#
# Estimating ln(intra) and ln(non-EU) with free coefficients nests the ex-EU
# share as the restriction b_intra = -b_nonEU, which Section 11 tests. The
# unrestricted version is the one that can actually identify a stumbling block:
# intra-regional trade is trade with non-EU partners and has no arithmetic link
# to any EU dyad whatsoever.
#
# intra_trade == 0 for a number of Pacific and Central African country-years.
# log() sends those to NA and PPML drops them; the count is reported so the
# sample loss is on the record rather than silent.
panel <- panel |>
  mutate(
    ln_intra  = if_else(intra_trade  > 0, log(intra_trade),  NA_real_),
    ln_noneu  = if_else(non_eu_trade > 0, log(non_eu_trade), NA_real_),
    ln_total  = if_else(total_trade  > 0, log(total_trade),  NA_real_)
  )

# Non-overlapping decomposition. ln_intra and ln_noneu overlap (intra-regional
# trade is part of non-EU trade), so the coefficient on ln_intra is already a
# composition effect. Splitting non-EU trade into its regional and extra-regional
# halves makes that explicit and is easier to explain in print: the two
# regressors are disjoint, and b_intra is the effect of regional trade holding
# extra-regional non-EU trade fixed.
panel <- panel |>
  mutate(
    extra_noneu = non_eu_trade - intra_trade,
    ln_extra    = if_else(extra_noneu > 0, log(extra_noneu), NA_real_)
  )

# Import- and export-side components. it_share_exeu_m is intra_imports /
# non_eu_imports, so decomposing it needs its own components: ln_intra and
# ln_noneu above are built from TOTAL trade and would attribute export-side
# variation to the import equation. This is the only remaining open question in
# the mechanical battery -- the share form is rejected in every direction, but
# the import side stays negative under all three share treatments, and until
# the components are matched to the direction we cannot say whether that is a
# real narrow effect or the same arithmetic.
#
# One caveat that belongs in print if the import-side result ends up mattering:
# script 01 builds non_eu_exports / non_eu_imports by netting out every member
# of EU_ISO3 in every year, whereas the panel retains GBR through 2020 and drops
# it only in 2021. So ln_noneu_m / ln_noneu_x sit on a marginally wider EU
# definition than the ln_noneu reconstructed in this section. The gap is one
# partner in 26 of 27 years and will not move ln_intra_m, but it is a real
# inconsistency in the denominators rather than a rounding matter.
#
# Guarded on column presence for the same reason as HAS_DIR_SHARES in Section
# 10: the components reach the panel only via the extended select() in script
# 01, so a pre-rebuild panel should degrade rather than fail.
if (all(c("intra_imports", "non_eu_imports", "intra_exports", "non_eu_exports")
        %in% names(panel))) {
  panel <- panel |>
    mutate(
      ln_intra_m = if_else(intra_imports  > 0, log(intra_imports),  NA_real_),
      ln_noneu_m = if_else(non_eu_imports > 0, log(non_eu_imports), NA_real_),
      ln_intra_x = if_else(intra_exports  > 0, log(intra_exports),  NA_real_),
      ln_noneu_x = if_else(non_eu_exports > 0, log(non_eu_exports), NA_real_)
    )
} else {
  message("Side-matched trade components absent from the panel. The ",
          "direction-matched log decomposition will be skipped in Section 10.4.")
}

zero_intra <- panel |>
  filter(!is.na(it_share), is.na(ln_intra)) |>
  distinct(acp_iso3, year, rec) |>
  count(rec, name = "n_country_years")
message("Country-years with zero intra-regional trade (dropped by the log specs):")
print(zero_intra)


# =============================================================================
# 4. DICTIONARY
# =============================================================================
DICT <- c(
  ln_gdp_acp         = "ln(ACP GDP)",
  pop_acp_ln         = "ln(ACP population)",
  ln_dist            = "ln(Distance)",
  contiguity         = "Contiguity",
  lang               = "Common Language",
  colonial           = "Colonial Tie",
  epa                = "EPA (=1 in force)",
  it_share           = "IT Share",
  it_share_exeu      = "IT Share (ex-EU denominator)",
  it_share_fixeu     = "IT Share (EU component fixed)",
  it_share_centered  = "IT Share (centred)",
  it_intensity       = "IT Intensity",
  ln_intra           = "ln(Intra-REC trade)",
  ln_noneu           = "ln(Non-EU trade)",
  ln_total           = "ln(Total trade)",
  ln_extra           = "ln(Extra-regional non-EU trade)",
  ln_intra_m         = "ln(Intra-REC imports)",
  ln_noneu_m         = "ln(Non-EU imports)",
  ln_intra_x         = "ln(Intra-REC exports)",
  ln_noneu_x         = "ln(Non-EU exports)",
  s_eu_dev           = "EU trade share (demeaned)",
  china_share        = "China trade share",
  eu_partner_hhi     = "EU-partner concentration (HHI)",
  export_hhi         = "Export concentration (HS-chapter HHI)",
  eur_peg            = "EUR peg (CEMAC/WAEMU/Comoros)",
  other_currency_union = "Other currency union (CMA/ECCU/Pacific)",
  peg_cemac          = "CEMAC (EUR peg)",
  peg_waemu          = "WAEMU (EUR peg)",
  peg_comoros        = "Comoros (EUR peg)",
  peg_cma            = "CMA (rand peg)",
  peg_eccu           = "ECCU (USD peg)",
  peg_pacific        = "Pacific dollarization (NZD/AUD)",
  gdp_pc_gap         = "EU-ACP GDP p.c. gap (Linder)",
  "epa:it_share"     = "EPA $\\times$ IT Share",
  "epa:it_share_centered" = "EPA $\\times$ IT Share (centred)",
  "it_share:s_eu_dev"     = "IT Share $\\times$ EU trade share",
  it_ECOWAS          = "IT Share $\\times$ ECOWAS",
  it_CAF             = "IT Share $\\times$ Central Africa",
  it_SADC            = "IT Share $\\times$ SADC",
  it_EAC             = "IT Share $\\times$ EAC",
  it_ESA             = "IT Share $\\times$ ESA",
  it_CARIFORUM       = "IT Share $\\times$ CARIFORUM",
  it_PIF             = "IT Share $\\times$ PIF"
)

setFixest_dict(c(
  DICT,
  exporter_year = "EU-partner $\\times$ year",
  acp_iso3      = "ACP country"
))


# =============================================================================
# 5. SUMMARY STATISTICS AND DIAGNOSTICS
# =============================================================================
sumstats <- panel |>
  filter(!is.na(rec)) |>
  distinct(acp_iso3, year, rec, it_share, it_share_exeu, it_intensity,
           s_eu, gdp_acp, pop_acp, epa) |>
  group_by(rec) |>
  summarise(
    n_countries      = n_distinct(acp_iso3),
    n_cy             = n(),
    it_share_mean    = round(mean(it_share,      na.rm = TRUE), 4),
    it_share_sd      = round(sd(it_share,        na.rm = TRUE), 4),
    it_share_missing = round(100 * mean(is.na(it_share)), 1),
    it_exeu_mean     = round(mean(it_share_exeu, na.rm = TRUE), 4),
    s_eu_mean        = round(mean(s_eu,          na.rm = TRUE), 4),
    it_int_mean      = round(mean(it_intensity,  na.rm = TRUE), 3),
    gdp_acp_mean_mn  = round(mean(gdp_acp / 1e6, na.rm = TRUE), 1),
    pct_epa          = round(100 * mean(epa == 1L, na.rm = TRUE), 1),
    .groups = "drop"
  )

trade_stats <- panel |>
  filter(!is.na(rec)) |>
  group_by(rec) |>
  summarise(
    mean_bilateral_usd = round(mean(total_bilateral, na.rm = TRUE), 0),
    pct_zero_trade     = round(100 * mean(total_bilateral == 0), 1),
    .groups = "drop"
  )

sumstats_full <- left_join(sumstats, trade_stats, by = "rec")
print(sumstats_full, width = Inf)
write_csv(sumstats_full, F_AUX_SUMSTATS)

missing_covs <- panel |>
  distinct(acp_iso3, eu_iso3, year, ln_dist, gdp_acp, gdp_eu) |>
  filter(is.na(ln_dist) | is.na(gdp_acp) | is.na(gdp_eu)) |>
  count(acp_iso3, year, name = "n_eu_missing") |>
  arrange(desc(n_eu_missing))

if (nrow(missing_covs) > 0) {
  # Expected: SOM (no WDI), ERI (no WDI from 2012), TLS pre-2003, and every
  # country in 2021 because the WDI cache ends at 2020.
  message("Country-years with missing covariates (expected: SOM, ERI, TLS pre-2003, all 2021):")
  missing_covs |>
    group_by(acp_iso3) |>
    summarise(total_years_missing = n_distinct(year), .groups = "drop") |>
    arrange(desc(total_years_missing)) |>
    print(n = 15)
  write_csv(missing_covs, F_AUX_MISSING)
}

panel |>
  filter(!is.na(rec)) |>
  distinct(acp_iso3, year, rec, epa) |>
  group_by(rec) |>
  summarise(
    n_treated   = sum(epa == 1L, na.rm = TRUE),
    n_untreated = sum(epa == 0L, na.rm = TRUE),
    pct_treated = round(100 * mean(epa == 1L, na.rm = TRUE), 1),
    .groups = "drop"
  ) |>
  arrange(desc(pct_treated)) |>
  print()

# Contiguity is empty in this panel (no ACP country borders an EU member state
# in the CEPII coding used here). Retained as a switch so the formulas do not
# have to be edited by hand if that ever changes.
cont_tab       <- table(panel$contiguity)
pct_contig     <- if ("1" %in% names(cont_tab)) 100 * cont_tab[["1"]] / sum(cont_tab) else 0
USE_CONTIGUITY <- pct_contig >= 0.5
message(sprintf("Contiguity: %.2f%% of pairs - %s from all formulas.",
                pct_contig, if (USE_CONTIGUITY) "RETAINED" else "EXCLUDED"))


# =============================================================================
# 6. MODEL FORMULAS
# =============================================================================
# FE structure. An ACP-country x year effect would absorb it_share and epa
# outright (both vary only at that level), so the ACP side enters as a country
# effect. Common time shocks are handled by exporter_year = eu_iso3 x year,
# which spans a standalone year effect -- the previous version also listed
# `year`, which fixest absorbed silently while the output tables reported it as
# an active dimension.
ct <- if (USE_CONTIGUITY) " + contiguity" else ""
FE <- " | exporter_year + acp_iso3"
X  <- paste0("ln_dist", ct, " + lang + colonial + epa")

mk <- function(y, rhs) as.formula(paste0(y, " ~ ", X, " + ", rhs, FE))

f_baseline  <- as.formula(paste0("total_bilateral ~ ", X, FE))
f_main      <- mk("total_bilateral", "it_share")
f_intensity <- mk("total_bilateral", "it_intensity")
f_ols       <- mk("ln_trade",        "it_share")
f_ols_plus  <- mk("ln_trade_plus",   "it_share")
f_acp_exp   <- mk("ACP_to_EU",       "it_share")
f_eu_exp    <- mk("EU_to_ACP",       "it_share")

# Mechanical battery
f_exeu      <- mk("total_bilateral", "it_share_exeu")
f_fixeu     <- mk("total_bilateral", "it_share_fixeu")
f_logdirty  <- mk("total_bilateral", "ln_intra + ln_total")
f_logclean  <- mk("total_bilateral", "ln_intra + ln_noneu")
f_seuinter  <- mk("total_bilateral", "it_share + s_eu_dev + it_share:s_eu_dev")
f_acp_exeu  <- mk("ACP_to_EU",       "it_share_exeu")
f_eu_exeu   <- mk("EU_to_ACP",       "it_share_exeu")

# Income controls
f_gdp       <- mk("total_bilateral", "it_share + ln_gdp_acp + pop_acp_ln")
f_gdp_eu    <- mk("EU_to_ACP",       "it_share + ln_gdp_acp + pop_acp_ln")


# =============================================================================
# 7. MAIN ESTIMATION  ->  TABLE 1
# =============================================================================
# M1 is estimated on M2's sample so the two columns are comparable. Previously
# M1 ran on 48,181 observations against M2's 47,065, which made the "does adding
# IT Share change the gravity coefficients" comparison partly a sample effect.
est_sample <- panel |> filter(!is.na(it_share))
message(sprintf("Estimation sample (non-missing it_share): %s dyad-years.",
                format(nrow(est_sample), big.mark = ",")))

m1 <- fit_ppml(f_baseline, est_sample)
m2 <- fit_ppml(f_main,     panel)

if (nobs(m1) != nobs(m2))
  message(sprintf("  NOTE: nobs(m1) = %d vs nobs(m2) = %d. A small gap is ",
                  nobs(m1), nobs(m2)),
          "expected -- the two models drop different singleton fixed effects.")

# --- Variance-mean relationship (replaces the old Pearson statistic) --------
# A Park-type regression of the log squared response residual on the log fitted
# value. The slope identifies how the conditional variance scales with the mean:
#   slope ~ 1  -> Poisson variance, PPML is the efficient choice
#   slope ~ 2  -> Gamma-type variance, PPML remains CONSISTENT but not efficient
#                 (Santos Silva and Tenreyro 2006), and NB-PML is a useful check
# This is a statement about efficiency, not about consistency, and should be
# reported in the paper as such.
park_dat <- tibble(
  fit = fitted(m2),
  res = residuals(m2, type = "response")
) |>
  filter(fit > 0, res != 0) |>
  mutate(ly = log(res^2), lx = log(fit))
park_fit <- lm(ly ~ lx, data = park_dat)
message(sprintf(
  "Variance-mean (Park) slope: %.3f (SE %.3f). 1 = Poisson, 2 = Gamma. n = %d.",
  coef(park_fit)[["lx"]], sqrt(diag(vcov(park_fit)))[["lx"]], nrow(park_dat)
))

# --- NB-PML -----------------------------------------------------------------
# Estimated to confirm the variance assumption is not driving the result.
# fenegbin is the slow step and can fail to converge; nothing in the paper's
# argument depends on it, so a failure degrades gracefully.
m2_nb <- NULL
if (RUN_NEGBIN) {
  m2_nb <- tryCatch(
    fenegbin(f_main, data = panel, cluster = CLUSTER_MAIN),
    error = function(e) {
      warning("fenegbin failed: ", conditionMessage(e),
              ". NB-PML column will be omitted.", call. = FALSE)
      NULL
    }
  )
  if (!is.null(m2_nb))
    message(sprintf("NB-PML vs PPML - it_share: NB = %.4f (SE %.4f) | PPML = %.4f (SE %.4f)",
                    safe_coef(m2_nb, "it_share"), safe_se(m2_nb, "it_share"),
                    coef(m2)["it_share"], se(m2)["it_share"]))
} else {
  message("RUN_NEGBIN is FALSE - NB-PML column omitted from Table 7.")
}

# --- EPA moderation ---------------------------------------------------------

# Mean-centring IT Share makes the EPA main effect the NET EPA effect at the
# sample mean of IT Share, with its own standard error, without the delta
# method. Centred on the estimation sample, not the full panel.
it_mean_est <- mean(est_sample$it_share, na.rm = TRUE)
panel <- panel |> mutate(it_share_centered = it_share - it_mean_est)

f_inter_c <- mk("total_bilateral", "it_share_centered + epa:it_share_centered")
m3_centered <- fit_ppml(f_inter_c, panel)

message(sprintf(
  "Net EPA effect at mean IT Share (%.4f): %.4f (SE %.4f, t = %.2f)",
  it_mean_est,
  coef(m3_centered)["epa"], se(m3_centered)["epa"],
  coef(m3_centered)["epa"] / se(m3_centered)["epa"]
))

m4 <- fit_ppml(f_intensity, panel)   # IT Intensity - see Section 16 note
m5 <- feols(f_ols, data = panel |> filter(total_bilateral > 0),
            cluster = CLUSTER_MAIN)

etable(
  m1, m2, m3_centered, m5,
  title   = "ACP Intra-Regional Trade Integration and EU-ACP Bilateral Trade",
  headers = c("Baseline\nPPML","IT Share\nPPML (Main)",
              "Centred\ninteraction","IT Share\nOLS"),
  se.below = TRUE, depvar = FALSE, fitstat = ~n,
  notes = paste0("Standard errors clustered by ", CLUSTER_LABEL,
                 ". Column (1) is estimated on column (2)'s sample. Column (3) ",
                 "centres IT Share at its sample mean, so the EPA coefficient is ",
                 "the net EPA effect at mean integration."),
  file = F_T1_MAIN, replace = TRUE
)


# =============================================================================
# 8. INFERENCE: CLUSTERING LADDER  ->  not a numbered table; values folded
#    into Section 5.5 prose in the paper. Written to aux_ files, not table8_,
#    to avoid colliding with the real Table 8 (sample restrictions, Section 14).
# =============================================================================
# it_share does not vary across the 28 EU partners within an ACP country-year.
# Pair-clustering therefore treats 28 replications of the same regressor value
# as independent clusters and will understate the standard error on the one
# coefficient the paper turns on. The three levels below are reported together
# so the reader can see the cost of the choice rather than be told about it.
#
#   ~pair_id             2,184 clusters  (the previous default)
#   ~acp_iso3               78 clusters  (matches the level of variation)
#   ~acp_iso3 + eu_iso3   two-way        (also allows EU-partner correlation)
#
# The vcov is recomputed from the fitted model, so this costs nothing.
cluster_specs <- list(
  "Dyad (pair)"            = ~pair_id,
  "ACP country"            = ~acp_iso3,
  "ACP country x EU partner" = ~acp_iso3 + eu_iso3,
  "ACP country x year"     = ~acp_iso3 + year
)

cluster_tbl <- imap_dfr(cluster_specs, function(cl, lab) {
  s <- tryCatch(summary(m2, cluster = cl), error = function(e) NULL)
  if (is.null(s)) return(NULL)
  b  <- coef(s)[["it_share"]]
  sd <- se(s)[["it_share"]]
  tibble(cluster = lab, coef = b, se = sd, t = b / sd,
         ci_lo = b - 1.96 * sd, ci_hi = b + 1.96 * sd, sig = stars(b, sd))
}) |>
  mutate(across(c(coef, se, t, ci_lo, ci_hi), \(x) round(x, 4)))

message("Clustering ladder for the IT Share coefficient:")
print(cluster_tbl)
write_csv(cluster_tbl, F_AUX_CLUSTER_C)

writeLines(c(
  "\\begin{tabular}{lrrrl}",
  "\\midrule\\midrule",
  "Clustering level & Coefficient & Std.\\ error & $t$ & 95\\% CI \\\\",
  "\\midrule",
  sprintf("%-26s & %.3f & %.3f & %.2f & [%.3f, %.3f]%s \\\\",
          cluster_tbl$cluster, cluster_tbl$coef, cluster_tbl$se,
          cluster_tbl$t, cluster_tbl$ci_lo, cluster_tbl$ci_hi, cluster_tbl$sig),
  "\\midrule\\midrule",
  "\\multicolumn{5}{l}{\\emph{All rows are the same PPML fit (M2); only the variance estimator differs.}}\\\\",
  "\\multicolumn{5}{p{0.9\\linewidth}}{\\emph{IT Share is constant across EU partners within an ACP country-year, so dyad-level clustering treats 28 replications of one regressor value as independent.}}\\\\",
  "\\end{tabular}"
), F_AUX_CLUSTER)


# =============================================================================
# 9. DIRECTIONAL DECOMPOSITION  ->  TABLE 5
# =============================================================================
# NOTE FOR THE PAPER. Both directions now carry large negative coefficients, and
# the difference between them is small relative to its standard error. The
# earlier draft's claim -- effect concentrated in EU exports, absent in ACP
# exports -- is not supported by these estimates, and neither is the mirror
# image. Section 9 computes the difference and its t-statistic explicitly so the
# text can state what the data can and cannot distinguish.
#
# Note also that ACP exports are more EU-concentrated than ACP imports, so the
# mechanical channel in Section 11 is stronger on the export side. That alone
# predicts a larger ACP-to-EU coefficient. The ex-EU columns below are the check.
m_acp_exp <- fit_ppml(f_acp_exp, panel)
m_eu_exp  <- fit_ppml(f_eu_exp,  panel)
m_gdp_eu  <- fit_ppml(f_gdp_eu,  panel)

# ACP-country x year FEs are infeasible (they would absorb it_share), so ACP GDP
# and population enter directly to address the country-growth confounder.
m_acp_exeu <- fit_ppml(f_acp_exeu, panel)
m_eu_exeu  <- fit_ppml(f_eu_exeu,  panel)

b_acp <- coef(m_acp_exp)[["it_share"]]; s_acp <- se(m_acp_exp)[["it_share"]]
b_eu  <- coef(m_eu_exp)[["it_share"]];  s_eu_ <- se(m_eu_exp)[["it_share"]]

# The two models share a sample, so the estimates are positively correlated and
# the independent-SE difference below is CONSERVATIVE (it overstates the standard
# error of the difference). If it fails to reject, the correlated version would
# fail to reject too. That is the direction of error the paper wants.
diff_est <- b_acp - b_eu
diff_se  <- sqrt(s_acp^2 + s_eu_^2)
message(sprintf(
  "Directional difference (ACP->EU minus EU->ACP): %.4f, conservative SE %.4f, t = %.2f",
  diff_est, diff_se, diff_est / diff_se
))
message("  A |t| below 1.96 means the two directions cannot be distinguished, ",
        "and no asymmetry claim of any sign is supportable.")

message(sprintf(
  "Table 5 per-column N: bilateral %d | ACP->EU %d | EU->ACP %d | EU->ACP+GDP %d",
  nobs(m2), nobs(m_acp_exp), nobs(m_eu_exp), nobs(m_gdp_eu)
))
message(sprintf(
  "Directional ex-EU denominator: ACP->EU %.4f (SE %.4f) | EU->ACP %.4f (SE %.4f)",
  safe_coef(m_acp_exeu, "it_share_exeu"), safe_se(m_acp_exeu, "it_share_exeu"),
  safe_coef(m_eu_exeu,  "it_share_exeu"), safe_se(m_eu_exeu,  "it_share_exeu")
))

etable(
  m2, m_acp_exp, m_eu_exp, m_gdp_eu, m_acp_exeu, m_eu_exeu,
  title    = "IT Share Effect by Trade Direction",
  headers  = c("Total\nBilateral","ACP exports\nto EU","EU exports\nto ACP",
               "EU exports\n+ GDP/pop","ACP exports\n(ex-EU denom.)",
               "EU exports\n(ex-EU denom.)"),
  se.below = TRUE, depvar = FALSE, fitstat = ~n,
  notes = paste0("Standard errors clustered by ", CLUSTER_LABEL,
                 ". Column (4) loses observations to WDI coverage; ",
                 "N is reported per column."),
  file = F_T5_DIRECTION, replace = TRUE
)


# =============================================================================
# 10. MECHANICAL ENDOGENEITY BATTERY  ->  TABLE 3 (was Table 5)
# =============================================================================
# This is the section the paper turns on. The organising identity:
#
#     it_share      = intra_trade / total_trade
#     it_share_exeu = intra_trade / non_eu_trade
#     total_trade   = non_eu_trade + eu_trade
#
#  => it_share = it_share_exeu * (1 - s_eu)
#
# The baseline regressor contains a term that falls mechanically whenever the
# ACP country's EU trade rises, and the dependent variable is a component of EU
# trade. Everything below measures how much of the coefficient that accounts for.
#
# SCOPE, and the paper says this explicitly in Section 4.4: the decomposition
# below is exact for the LOG of the ex-EU share, because ln(it_share_exeu) =
# ln(intra) - ln(non-EU). The headline regressor is the LEVEL of the EU-inclusive
# share, and levels do not decompose additively into logs. The restriction test
# establishes how a ratio manufactures a coefficient from its components in a
# closely related specification; the bridge to the baseline is the identity above
# plus the direct component estimates. Do not let the script's comments claim the
# equivalence is exact for the baseline -- a gravity referee will catch it.
#
# The battery, in the order it is reported in Table 3:
#
#   (1) Baseline it_share                 -- contaminated
#   (2) it_share_exeu                     -- clean, but ~1/(1-s_eu) larger scale
#   (3) it_share_fixeu                    -- clean AND on the baseline scale
#   (4) ln(intra) + ln(total)             -- decomposition, contaminated
#   (5) ln(intra) + ln(non-EU)            -- decomposition, clean
#
# How to read it. Under an economic account, (3) sits close to (1) and ln(intra)
# is materially negative in (4) and (5). Under a mechanical account, (3)
# collapses toward zero and the denominator term carries the sign while
# ln(intra) is weak. The it_share x s_eu interaction is fitted in 10.1 and
# reported to the console in 10.5, but it is not tabulated: s_eu contains the
# dependent variable, and the interaction is estimated too imprecisely to
# discriminate between the two accounts. The period windows below are the
# cleaner version of the same idea, and they are descriptive too.
#
# The two blocks below (10.2/10.3) are NOT numbered tables in the paper.
# Both were revised twice in this same session -- first corrected from a
# wrong "stale, delete" call to "keep," then revised again once it became
# clear the underlying models feed Table 4 directly regardless of whether
# they're also rendered into a separate table, and once the user weighed in
# on where the unique content should live:
#   - aux_directional_clean.tex TRIMMED to its 4 genuinely unique columns
#     (EU-fixed and direction-matched-ex-EU-share, both by direction). The
#     other 4 fitted models it used to also render (m_logclean_acp/eu,
#     m_logclean_m/x) are still fitted below and still feed Table 4 via
#     restriction_tbl -- only the redundant second rendering was removed.
#   - aux_disjoint_decomposition.tex REMOVED entirely. Confirmed NOT stale
#     (columns matched aux_ratio_restrictions.csv exactly), but 3 of its 5
#     columns were pure re-renders of Table 4's Disjoint rows. Column (1)
#     (same-sample naive share) survives as a console message right where
#     its model is fit. Column (5) (China-share control) was relocated to
#     Section 10.3b, next to the other China/diversion-partner checks.
# -----------------------------------------------------------------------------

if (!"ln_extra" %in% names(panel))
  stop("ln_extra is missing from the panel. Add the extra_noneu / ln_extra ",
       "mutate to Section 3 before running this block.")

# Direction-matched shares exist only in the rebuilt panel. Guarded so this
# script runs against both vintages; the guard can come out once the rebuild in
# 01_build_panel.R has been adopted.
HAS_DIR_SHARES <- all(c("it_share_exeu_x","it_share_exeu_m") %in% names(panel))

# The side-matched log decomposition needs the raw components, not the shares.
# Same rebuild delivers both, so in practice these two flags move together --
# but they test different columns, and a guard should test what the code it
# protects actually uses.
HAS_DIR_COMPONENTS <- all(c("ln_intra_m","ln_noneu_m","ln_intra_x","ln_noneu_x")
                          %in% names(panel))


# --- 10.1 Pooled battery -----------------------------------------------------
m2_exeu    <- fit_ppml(f_exeu,     panel)
m2_fixeu   <- fit_ppml(f_fixeu,    panel)
m_logdirty <- fit_ppml(f_logdirty, panel)
m_logclean <- fit_ppml(f_logclean, panel)
m_seu      <- fit_ppml(f_seuinter, panel)

message(sprintf("Ex-EU denominator:  %+.4f (SE %.4f, t = %.2f)",
                coef(m2_exeu)[["it_share_exeu"]], se(m2_exeu)[["it_share_exeu"]],
                coef(m2_exeu)[["it_share_exeu"]] / se(m2_exeu)[["it_share_exeu"]]))
message(sprintf("EU component fixed: %+.4f (SE %.4f, t = %.2f)  <- directly comparable to baseline %+.4f",
                coef(m2_fixeu)[["it_share_fixeu"]], se(m2_fixeu)[["it_share_fixeu"]],
                coef(m2_fixeu)[["it_share_fixeu"]] / se(m2_fixeu)[["it_share_fixeu"]],
                coef(m2)[["it_share"]]))

# The surviving-share percentage is a ratio of two estimates, one of which is
# not significantly different from zero. It is a useful headline for the section
# and a bad number to defend on its own, so the interval is printed beside it.
fixeu_b  <- coef(m2_fixeu)[["it_share_fixeu"]]
fixeu_se <- se(m2_fixeu)[["it_share_fixeu"]]
message(sprintf("  Share of the baseline coefficient surviving: %.1f%%",
                100 * fixeu_b / coef(m2)[["it_share"]]))
message(sprintf(
  "  But the numerator's own 95%% interval is [%+.3f, %+.3f]%s -- the point ",
  fixeu_b - 1.96 * fixeu_se, fixeu_b + 1.96 * fixeu_se,
  if (abs(fixeu_b / fixeu_se) > 1.96) "" else ", which spans zero"))
message("  estimate does not by itself establish a zero effect. Report it as ",
        "corroboration, not as the finding.")


# --- 10.2 The ratio restriction ----------------------------------------------
# ln(it_share_exeu) = ln(intra) - ln(non-EU), so the ratio form imposes
# b_intra = -b_nonEU. Testing it says whether collapsing numerator and
# denominator into one share is innocuous or is concealing the fact that only
# the denominator moves.
ratio_restriction <- function(m, v1 = "ln_intra", v2 = "ln_noneu") {
  b <- coef(m)[c(v1, v2)]
  V <- vcov(m)[c(v1, v2), c(v1, v2)]
  s <- unname(sum(b))
  se_s <- sqrt(sum(V))          # Var(b1 + b2) = V11 + V22 + 2*V12
  list(sum = s, se = se_s, t = s / se_s)
}

# v1 is a parameter because the side-matched models in 10.4 use ln_intra_m /
# ln_intra_x rather than ln_intra. NOTE: v1 sits ahead of v2 in the signature,
# so every call passing a non-default denominator must name it -- see the three
# ln_extra calls in 10.3, which would otherwise bind "ln_extra" to v1.
#
# Returns a one-row tibble as well as printing. The restriction statistics are
# quoted directly in the paper ("rejected in all cells, t X to Y"), and until
# this change they existed only as console output: not in any file, not checked
# by Section 18, not reconstructible without a re-run. Every call is now
# captured and the collected rows are written in 10.6.
report_decomp <- function(m, label, v1 = "ln_intra", v2 = "ln_noneu",
                          spec = NA_character_) {
  rr <- ratio_restriction(m, v1, v2)
  message(sprintf(
    "  %-10s %s %+.4f (SE %.4f, t %+.2f) | %s %+.4f (SE %.4f, t %+.2f) | restriction sum %+.4f (SE %.4f, t %+.2f)",
    label,
    v1, coef(m)[[v1]], se(m)[[v1]], coef(m)[[v1]] / se(m)[[v1]],
    v2, coef(m)[[v2]], se(m)[[v2]], coef(m)[[v2]] / se(m)[[v2]],
    rr$sum, rr$se, rr$t))
  invisible(tibble(
    specification = if (is.na(spec)) "unlabelled" else spec,
    cell          = label,
    numerator     = v1,
    denominator   = v2,
    b_num         = coef(m)[[v1]],  se_num = se(m)[[v1]],
    b_den         = coef(m)[[v2]],  se_den = se(m)[[v2]],
    restr_sum     = rr$sum,
    restr_se      = rr$se,
    restr_t       = rr$t,
    rejected      = abs(rr$t) > 1.96,
    n             = nobs(m)
  ))
}

message("Clean log decomposition (dependent variable in the row label):")
rr_pooled <- report_decomp(m_logclean, "Bilateral", spec = "Overlapping (clean)")

# Section 19 reads these three names directly. rr_pooled is now a tibble rather
# than a list, so sum_se reads restr_se; b_i and b_n are unchanged.
b_i    <- coef(m_logclean)[["ln_intra"]]
b_n    <- coef(m_logclean)[["ln_noneu"]]
sum_se <- rr_pooled$restr_se

message(sprintf("  Restriction b_intra + b_nonEU = 0: %s",
                if (abs(rr_pooled$restr_t) > 1.96)
                  "REJECTED -- the share form is not innocuous." else
                    "not rejected -- the share form is defensible."))

# The contaminated counterpart, for the direction of the arithmetic channel.
# ln_total contains EU trade, so its coefficient is partly the dependent
# variable regressed on itself, and the gap against ln(non-EU) should open in
# the direction the mechanical account predicts. It is NOT a calibrated
# prediction: the gap and the mean EU share are the same order of magnitude but
# have differed by fifty percent or more across runs, and Section 4.4 of the
# paper presents this as directional evidence only. Do not restore any wording
# that claims the gap equals, approximates, or is "of the order of" mean s_eu.
gap_dirty <- coef(m_logdirty)[["ln_total"]] - coef(m_logclean)[["ln_noneu"]]
message(sprintf(
  "Contaminated decomposition: ln(intra) %+.4f (SE %.4f) | ln(total) %+.4f (SE %.4f).",
  coef(m_logdirty)[["ln_intra"]], se(m_logdirty)[["ln_intra"]],
  coef(m_logdirty)[["ln_total"]], se(m_logdirty)[["ln_total"]]))
message(sprintf(
  "  Denominator gap ln(total) - ln(non-EU) = %+.4f against mean s_eu = %.4f (%.0f%% apart). Directional only.",
  gap_dirty, mean(panel$s_eu, na.rm = TRUE),
  100 * abs(gap_dirty - mean(panel$s_eu, na.rm = TRUE)) / mean(panel$s_eu, na.rm = TRUE)))


# --- 10.3 Disjoint decomposition  -- feeds Table 4 (via rr_orth/_acp/_eu ----
# below, bound into restriction_tbl at Section 10.6); NOT rendered as its own
# table. An earlier version of this script rendered these same three models
# again as a standalone aux_disjoint_decomposition.tex, which was pure
# duplication of Table 4's Disjoint rows -- removed 2026-08-11. Nothing lost:
# report_decomp() below already prints full numbers to console regardless of
# whether a model also appears in a rendered table, and the numbers this
# fed are the same numbers Table 4 already publishes.
# ------------------------------------------------------------------------
# ln_intra and ln_noneu overlap: intra-regional trade is part of non-EU trade.
# The coefficient on ln_intra is therefore already a composition effect, but
# that is easier to assert than to see. Splitting non-EU trade into its regional
# and extra-regional halves makes the two regressors disjoint, so b_intra is
# unambiguously the effect of shifting a dollar of non-EU trade toward a
# regional partner and away from an extra-regional one. That is the
# stumbling-block experiment stated directly.
f_logorth     <- mk("total_bilateral", "ln_intra + ln_extra")
f_logorth_acp <- mk("ACP_to_EU",       "ln_intra + ln_extra")
f_logorth_eu  <- mk("EU_to_ACP",       "ln_intra + ln_extra")

m_logorth     <- fit_ppml(f_logorth,     panel)
m_logorth_acp <- fit_ppml(f_logorth_acp, panel)
m_logorth_eu  <- fit_ppml(f_logorth_eu,  panel)

message("Disjoint decomposition (regional vs extra-regional non-EU trade):")
rr_orth     <- report_decomp(m_logorth,     "Bilateral", v2 = "ln_extra",
                             spec = "Disjoint")
rr_orth_acp <- report_decomp(m_logorth_acp, "ACP->EU",   v2 = "ln_extra",
                             spec = "Disjoint")
rr_orth_eu  <- report_decomp(m_logorth_eu,  "EU->ACP",   v2 = "ln_extra",
                             spec = "Disjoint")

# The expansion elasticity -- b_intra in the disjoint specification -- is the
# paper's strongest positive result, so its interval is printed rather than
# reconstructed by hand at the conference.
b_exp  <- coef(m_logorth)[["ln_intra"]]
se_exp <- se(m_logorth)[["ln_intra"]]
message(sprintf(
  "  Pooled expansion elasticity: %+.4f (SE %.4f), 95%% CI [%+.3f, %+.3f]",
  b_exp, se_exp, b_exp - 1.96 * se_exp, b_exp + 1.96 * se_exp))
message(sprintf(
  "  Share form implied at the sample mean: %.4f x %.4f = %+.4f -- compare the sides of zero.",
  coef(m2)[["it_share"]], it_mean_est, coef(m2)[["it_share"]] * it_mean_est))

# Same-sample baseline. The log specifications drop country-years with zero
# intra-regional trade, overwhelmingly PIF. Re-estimating the share model on
# exactly those observations removes "it is the sample, not the specification"
# as an objection before a referee raises it. This was previously rendered as
# the disjoint table's column (1), "Share (same sample)" -- that table is
# gone (see note above), but the number is fully preserved right here.
log_sample   <- panel |> filter(!is.na(ln_intra), !is.na(ln_extra), !is.na(ln_noneu))
m2_logsample <- fit_ppml(f_main, log_sample)
message(sprintf(
  "Baseline on the log-spec sample: %+.4f (SE %.4f, n = %s) | full sample %+.4f (SE %.4f, n = %s)",
  coef(m2_logsample)[["it_share"]], se(m2_logsample)[["it_share"]],
  format(nobs(m2_logsample), big.mark = ","),
  coef(m2)[["it_share"]], se(m2)[["it_share"]],
  format(nobs(m2), big.mark = ",")))


# --- 10.3b DIVERSION CHECK: does integration move with or against other -----
#           major partners? (Added 2026-08-05, handoff-2 items 5+6 merged.)
# The disjoint decomposition above (10.3) just established that ln(intra) and
# ln(extra non-EU trade) are BOTH positive: in aggregate, regional integration
# does not crowd out non-EU trade generally. That is evidence against classic
# Vinerian diversion, but it is aggregated across every non-EU partner at
# once, and cannot say whether the positive aggregate is uniform or is
# masking an offsetting pattern with one specific partner. This reruns the
# SAME disjoint specification with China's and the US's bilateral trade
# substituted in as the dependent variable instead of EU trade -- a
# parallel-DV test, same epistemic status as the headline result
# (descriptive/associational), not a new identification claim.
#
# China only tells a diversion story if the US does NOT move the same way (or
# vice versa): if both move positively with integration, that reads as
# general growth, not targeted diversion from either. AGOA is the US's own
# preferential arrangement, structurally similar to the EU's EPAs but with
# different eligibility criteria and its own commodity/oil-concentration
# quirks for some countries -- a caveat for the text if the US result is used,
# not something modelled here.
#
# Needs its own collapsed panel. china_trade / us_trade vary only at
# acp_iso3 x year (built in 01_build_panel.R from raw BACI, with no
# EU-partner dimension at all), so running them as a DV inside the EU-ACP
# dyad-year panel with the usual exporter_year (eu_iso3 x year) FE would be
# wrong on two counts: the DV would be replicated identically across the 28
# EU-partner rows per country-year, and exporter_year would absorb
# EU-partner-year variation that has nothing to do with a China- or US-trade
# outcome. Collapsed to one row per acp_iso3-year, with acp_iso3 + year fixed
# effects replacing exporter_year + acp_iso3.
m_china_dv <- m_us_dv <- NULL
if (HAS_NEW_CONTROLS) {
  country_year <- panel |>
    filter(!is.na(ln_intra), !is.na(ln_extra)) |>
    distinct(acp_iso3, year, rec, china_trade, us_trade, ln_intra, ln_extra)
  
  f_china_dv <- as.formula("china_trade ~ ln_intra + ln_extra | acp_iso3 + year")
  f_us_dv    <- as.formula("us_trade    ~ ln_intra + ln_extra | acp_iso3 + year")
  
  m_china_dv <- tryCatch(fepois(f_china_dv, data = country_year, cluster = ~acp_iso3),
                         error = function(e) { warning("China parallel-DV failed: ", conditionMessage(e)); NULL })
  m_us_dv    <- tryCatch(fepois(f_us_dv,    data = country_year, cluster = ~acp_iso3),
                         error = function(e) { warning("US parallel-DV failed: ", conditionMessage(e)); NULL })
  
  report_dv <- function(m, label) {
    if (is.null(m)) return(invisible(NULL))
    message(sprintf(
      "%s ~ ln_intra: %+.4f (SE %.4f, t %+.2f)%s | ln_extra: %+.4f (SE %.4f, t %+.2f)%s (n=%d)",
      label,
      coef(m)[["ln_intra"]], se(m)[["ln_intra"]],
      coef(m)[["ln_intra"]] / se(m)[["ln_intra"]],
      stars(coef(m)[["ln_intra"]], se(m)[["ln_intra"]]),
      coef(m)[["ln_extra"]], se(m)[["ln_extra"]],
      coef(m)[["ln_extra"]] / se(m)[["ln_extra"]],
      stars(coef(m)[["ln_extra"]], se(m)[["ln_extra"]]),
      nobs(m)))
  }
  report_dv(m_china_dv, "China trade")
  report_dv(m_us_dv,    "US trade")
  
  # --- 10.3c China-share control (as opposed to 10.3b's parallel-DV test ----
  # above them). Relocated 2026-08-11 from Section 10.3, where it sat
  # awkwardly attached to the disjoint-decomposition table that has since
  # been removed as duplicative -- it belongs here thematically, alongside
  # the other China/diversion-partner checks, not there.
  # Different question from 10.3b: that asks "does China's OWN trade move
  # with or against integration" (China as DV); this asks "does the EU-side
  # expansion elasticity survive once China's rising trade share is
  # controlled for directly" (china_share as a covariate in the EU-trade
  # regression). Preempts the referee question the mechanical argument
  # invites once stated: "you cleaned the EU out of the denominator -- is
  # China doing something similar to your identification?"
  m_logorth_china <- NULL
  if (HAS_NEW_CONTROLS) {
    f_logorth_china  <- mk("total_bilateral", "ln_intra + ln_extra + china_share")
    m_logorth_china  <- fit_ppml(f_logorth_china, panel)
    message(sprintf(
      "Expansion elasticity with China share controlled: %+.4f (SE %.4f) | without: %+.4f (SE %.4f)",
      coef(m_logorth_china)[["ln_intra"]], se(m_logorth_china)[["ln_intra"]],
      b_exp, se_exp))
    message(sprintf("  china_share coefficient: %+.4f (SE %.4f, t %+.2f)",
                    coef(m_logorth_china)[["china_share"]],
                    se(m_logorth_china)[["china_share"]],
                    coef(m_logorth_china)[["china_share"]] / se(m_logorth_china)[["china_share"]]))
  }
  
  # --- 10.3d US-share control (added this session, for symmetry with 10.3c) -
  # Same question as 10.3c, substituting us_share for china_share: does the
  # expansion elasticity survive once the US's own trade share is controlled
  # for directly. Added purely for symmetry -- China's rising share is the
  # more obvious confound story a referee would raise unprompted, but there
  # was no principled reason to leave the US case untested once the pattern
  # existed to copy.
  m_logorth_us <- NULL
  if (HAS_NEW_CONTROLS) {
    f_logorth_us  <- mk("total_bilateral", "ln_intra + ln_extra + us_share")
    m_logorth_us  <- fit_ppml(f_logorth_us, panel)
    message(sprintf(
      "Expansion elasticity with US share controlled: %+.4f (SE %.4f) | without: %+.4f (SE %.4f)",
      coef(m_logorth_us)[["ln_intra"]], se(m_logorth_us)[["ln_intra"]],
      b_exp, se_exp))
    message(sprintf("  us_share coefficient: %+.4f (SE %.4f, t %+.2f)",
                    coef(m_logorth_us)[["us_share"]],
                    se(m_logorth_us)[["us_share"]],
                    coef(m_logorth_us)[["us_share"]] / se(m_logorth_us)[["us_share"]]))
  }
  
  dv_models <- list(m_china_dv, m_us_dv)
  dv_headers <- c("China trade", "US trade")
  dv_keep <- !vapply(dv_models, is.null, logical(1))
  
  if (any(dv_keep) || !is.null(m_logorth_china) || !is.null(m_logorth_us)) {
    diversion_tbl <- bind_rows(
      if (!is.null(m_china_dv)) tibble(
        partner = "China", term = c("ln_intra", "ln_extra"),
        coefficient = c(coef(m_china_dv)[["ln_intra"]], coef(m_china_dv)[["ln_extra"]]),
        std_error   = c(se(m_china_dv)[["ln_intra"]],   se(m_china_dv)[["ln_extra"]]),
        n = nobs(m_china_dv)),
      if (!is.null(m_us_dv)) tibble(
        partner = "US", term = c("ln_intra", "ln_extra"),
        coefficient = c(coef(m_us_dv)[["ln_intra"]], coef(m_us_dv)[["ln_extra"]]),
        std_error   = c(se(m_us_dv)[["ln_intra"]],   se(m_us_dv)[["ln_extra"]]),
        n = nobs(m_us_dv)),
      # China-share-as-covariate check (10.3c): a different question from the
      # two rows above -- not "does China's own trade move with integration"
      # but "does the EU-side expansion elasticity survive once China's
      # rising trade share is controlled for directly". Previously only
      # printed to console (message()), never written to a file -- added here
      # so the number has a durable, checkable source rather than being
      # carried by hand between paper drafts.
      if (!is.null(m_logorth_china)) tibble(
        partner = "EU (China-share control)",
        term = c("ln_intra", "ln_extra", "china_share"),
        coefficient = c(coef(m_logorth_china)[["ln_intra"]],
                        coef(m_logorth_china)[["ln_extra"]],
                        coef(m_logorth_china)[["china_share"]]),
        std_error   = c(se(m_logorth_china)[["ln_intra"]],
                        se(m_logorth_china)[["ln_extra"]],
                        se(m_logorth_china)[["china_share"]]),
        n = nobs(m_logorth_china)),
      # US-share-as-covariate check (10.3d): mirrors 10.3c for symmetry.
      if (!is.null(m_logorth_us)) tibble(
        partner = "EU (US-share control)",
        term = c("ln_intra", "ln_extra", "us_share"),
        coefficient = c(coef(m_logorth_us)[["ln_intra"]],
                        coef(m_logorth_us)[["ln_extra"]],
                        coef(m_logorth_us)[["us_share"]]),
        std_error   = c(se(m_logorth_us)[["ln_intra"]],
                        se(m_logorth_us)[["ln_extra"]],
                        se(m_logorth_us)[["us_share"]]),
        n = nobs(m_logorth_us))
    ) |>
      mutate(t = coefficient / std_error, sig = stars(coefficient, std_error),
             across(c(coefficient, std_error, t), \(x) round(x, 4)))
    write_csv(diversion_tbl, file.path(DIR_TAB, "aux_diversion_parallel_dv.csv"))
    
    et_models  <- c(unname(dv_models[dv_keep]),
                    if (!is.null(m_logorth_china)) list(m_logorth_china),
                    if (!is.null(m_logorth_us)) list(m_logorth_us))
    et_headers <- c(dv_headers[dv_keep],
                    if (!is.null(m_logorth_china)) "EU trade (China-share control)",
                    if (!is.null(m_logorth_us)) "EU trade (US-share control)")
    
    do.call(etable, c(
      et_models,
      list(
        headers  = et_headers,
        title    = "Diversion Check: Intra-REC Integration and Trade with Other Major Partners",
        se.below = TRUE, depvar = FALSE, fitstat = ~n,
        notes = paste0(
          "Columns 1-2: same disjoint specification as Table 4 (ln(Intra-REC ",
          "trade), ln(Extra-regional non-EU trade)), collapsed to one row per ",
          "ACP country-year with acp_iso3 + year fixed effects, China's or the ",
          "US's bilateral trade substituted as the dependent variable in place ",
          "of EU trade -- there is no EU-partner dimension for either. Both ",
          "coefficients positive alongside the positive EU-trade expansion ",
          "elasticity in Table 4 is consistent with general growth rather than ",
          "targeted diversion; a negative coefficient here alongside the ",
          "positive EU result would indicate partner-specific diversion. ",
          "Columns 3-4 ask the question from the other direction, on the ",
          "standard EU-partner x year / ACP-country panel: does the EU-side ",
          "expansion elasticity survive once China's, or the US's, own rising ",
          "trade share is controlled for directly, rather than examined as a ",
          "separate outcome. Standard errors clustered by ", CLUSTER_LABEL, "."),
        file = F_T9_DIVERSION, replace = TRUE
      )
    ))
  }
} else {
  message("China/US trade totals absent from the panel -- diversion check skipped.")
}


# --- 10.3c SHARE-VS-VALUE ILLUSTRATION (handoff-2 item 6) --------------------
# Tyler Sotomayor's memo (p.22) shows EU import SHARE falling for Rwanda and
# Burundi post-2009 while EU import VALUE rose -- a concrete, independently
# derived illustration of exactly the measurement problem this paper proves
# algebraically (it_share = it_share_exeu * (1 - s_eu)) and demonstrates via
# the frozen-denominator and disjoint-decomposition exercises above. This
# reproduces the same comparison at the REC level across the full sample
# window, purely descriptive -- no new regression, no new identification
# claim, a companion to Figure 2 (the mechanical-overlap diagram).
share_value_tbl <- panel |>
  filter(!is.na(rec), !is.na(s_eu)) |>
  distinct(acp_iso3, year, rec, s_eu, eu_trade) |>
  filter(year %in% range(panel$year)) |>
  mutate(period = if_else(year == min(panel$year), "start", "end")) |>
  group_by(rec, period) |>
  summarise(
    mean_s_eu        = mean(s_eu, na.rm = TRUE),
    mean_ln_eu_trade = mean(log(pmax(eu_trade, 1)), na.rm = TRUE),
    .groups = "drop"
  ) |>
  pivot_wider(names_from = period, values_from = c(mean_s_eu, mean_ln_eu_trade)) |>
  mutate(
    delta_share       = round(mean_s_eu_end - mean_s_eu_start, 4),
    delta_ln_value    = round(mean_ln_eu_trade_end - mean_ln_eu_trade_start, 4),
    share_direction   = if_else(delta_share > 0, "rising", "falling"),
    value_direction   = if_else(delta_ln_value > 0, "rising", "falling"),
    opposite_signs    = share_direction != value_direction
  ) |>
  select(rec, delta_share, share_direction, delta_ln_value, value_direction,
         opposite_signs)

message(sprintf("Share-vs-value illustration, %d-%d (REC means):",
                min(panel$year), max(panel$year)))
print(share_value_tbl)
if (any(share_value_tbl$opposite_signs)) {
  message(sprintf(
    "  %d of %d RECs show EU share and EU trade value moving in OPPOSITE ",
    sum(share_value_tbl$opposite_signs), nrow(share_value_tbl)),
    "directions -- the exact measurement problem this paper's mechanical ",
    "argument addresses, visible directly in the descriptive data.")
} else {
  message("  No REC shows share and value moving in opposite directions over ",
          "the full sample window -- the illustration is weaker at this ",
          "level of aggregation than at Tyler's country-pair level. Consider ",
          "running this at the acp_iso3 level, or around a REC-specific ",
          "milestone (an EPA date, or the corrected EAC accession year) ",
          "rather than the full-sample endpoints, before dropping the table.")
}
write_csv(share_value_tbl, file.path(DIR_TAB, "aux_share_vs_value.csv"))


# --- 10.4 Directional versions  ->  Table 10 as of this session (previously --
#     unnumbered and, on inspection, never actually cited anywhere in the
#     paper despite containing genuinely unique content -- promoted after
#     citing it in Section 5.3, where it complicates rather than confirms
#     the side-matched directional asymmetry). TRIMMED 2026-08-11 to its 4
#     genuinely unique columns (EU-fixed and direction-matched-ex-EU-share,
#     both by direction). The other 4 model fits below (m_logclean_acp/eu,
#     m_logclean_m/x) are KEPT -- Table 4 depends on them via
#     rr_clean_acp/eu and rr_side_m/x, bound into restriction_tbl at Section
#     10.6 -- but no longer rendered into this table, since doing so just
#     re-printed Table 4's own Overlapping/Side-matched rows a second
#     time. -----------------------
# The pooled results say the negative share coefficient lives in the
# denominator. This asks whether that holds direction by direction, and in
# particular whether the EU-export coefficient that survives the ex-EU
# denominator is a genuine intra-regional effect or the same scale relationship.
f_fixeu_acp    <- mk("ACP_to_EU", "it_share_fixeu")
f_fixeu_eu     <- mk("EU_to_ACP", "it_share_fixeu")
f_logclean_acp <- mk("ACP_to_EU", "ln_intra + ln_noneu")
f_logclean_eu  <- mk("EU_to_ACP", "ln_intra + ln_noneu")

m_fixeu_acp    <- fit_ppml(f_fixeu_acp,    panel)
m_fixeu_eu     <- fit_ppml(f_fixeu_eu,     panel)
m_logclean_acp <- fit_ppml(f_logclean_acp, panel)
m_logclean_eu  <- fit_ppml(f_logclean_eu,  panel)

message("Directional clean decomposition:")
rr_clean_acp <- report_decomp(m_logclean_acp, "ACP->EU",
                              spec = "Overlapping (clean)")
rr_clean_eu  <- report_decomp(m_logclean_eu,  "EU->ACP",
                              spec = "Overlapping (clean)")

message(sprintf(
  "Directional EU-component-fixed: ACP->EU %+.4f (SE %.4f, t %+.2f) | EU->ACP %+.4f (SE %.4f, t %+.2f)",
  coef(m_fixeu_acp)[["it_share_fixeu"]], se(m_fixeu_acp)[["it_share_fixeu"]],
  coef(m_fixeu_acp)[["it_share_fixeu"]] / se(m_fixeu_acp)[["it_share_fixeu"]],
  coef(m_fixeu_eu)[["it_share_fixeu"]],  se(m_fixeu_eu)[["it_share_fixeu"]],
  coef(m_fixeu_eu)[["it_share_fixeu"]] / se(m_fixeu_eu)[["it_share_fixeu"]]))

# Direction-matched denominators. ACP_to_EU is an ACP export, so its share
# should be built from non-EU exports; EU_to_ACP is an ACP import, so non-EU
# imports. The combined denominator attributes import-side variation to the
# export equation and vice versa.
m_exeu_x <- m_exeu_m <- NULL
if (HAS_DIR_SHARES) {
  m_exeu_x <- fit_ppml(mk("ACP_to_EU", "it_share_exeu_x"), panel)
  m_exeu_m <- fit_ppml(mk("EU_to_ACP", "it_share_exeu_m"), panel)
  message(sprintf(
    "Direction-matched ex-EU: ACP->EU (export denom.) %+.4f (SE %.4f, t %+.2f) | EU->ACP (import denom.) %+.4f (SE %.4f, t %+.2f)",
    coef(m_exeu_x)[["it_share_exeu_x"]], se(m_exeu_x)[["it_share_exeu_x"]],
    coef(m_exeu_x)[["it_share_exeu_x"]] / se(m_exeu_x)[["it_share_exeu_x"]],
    coef(m_exeu_m)[["it_share_exeu_m"]], se(m_exeu_m)[["it_share_exeu_m"]],
    coef(m_exeu_m)[["it_share_exeu_m"]] / se(m_exeu_m)[["it_share_exeu_m"]]))
} else {
  message("Direction-matched ex-EU shares absent from the panel - skipped. ",
          "Rebuild with 01_build_panel.R to enable (this unpublished diagnostic drops two columns).")
}

# The side-matched decomposition. This is the one that closes the import-side
# thread: the share form is rejected throughout the total-component
# decomposition, but the import-side share stays negative under every treatment,
# and only a decomposition built from import components can say whether that is
# an intra-regional effect or the same denominator arithmetic.
#
# The two readings. ln_intra_m at or above zero, or short of significance, means
# the import-side negative is carried by the denominator and the paper is a null
# throughout -- report the coefficient, state that it does not clear 5%, claim
# nothing from it. Materially negative AND significant is the other publishable
# outcome: a narrow finding, an order of magnitude below the pooled share
# coefficient, invisible in the share specification. Only the framing of the
# import-side subsection turns on which it is.
#
# Deliberately no numbers in this comment. The previous version quoted priors
# and a headline coefficient from the 1995 run and both went stale silently.
m_logclean_m <- m_logclean_x <- NULL
rr_side_m <- rr_side_x <- NULL
if (HAS_DIR_COMPONENTS) {
  m_logclean_m <- fit_ppml(mk("EU_to_ACP", "ln_intra_m + ln_noneu_m"), panel)
  m_logclean_x <- fit_ppml(mk("ACP_to_EU", "ln_intra_x + ln_noneu_x"), panel)
  message("Side-matched decomposition (own components):")
  rr_side_m <- report_decomp(m_logclean_m, "EU->ACP",
                             v1 = "ln_intra_m", v2 = "ln_noneu_m",
                             spec = "Side-matched")
  rr_side_x <- report_decomp(m_logclean_x, "ACP->EU",
                             v1 = "ln_intra_x", v2 = "ln_noneu_x",
                             spec = "Side-matched")
  b_im  <- coef(m_logclean_m)[["ln_intra_m"]]
  se_im <- se(m_logclean_m)[["ln_intra_m"]]
  message(sprintf(
    "  Import-side intra elasticity %+.4f (t %+.2f) -- %s at 5%%.",
    b_im, b_im / se_im,
    if (abs(b_im / se_im) > 1.96) "SIGNIFICANT: use the narrow-finding framing"
    else "not significant: report and claim nothing from it"))
} else {
  message("Side-matched components absent from the panel - skipped. ",
          "Rebuild with 01_build_panel.R to enable (this unpublished diagnostic drops two columns).")
}

t_dirclean_models  <- list(m_fixeu_acp, m_fixeu_eu, m_exeu_x, m_exeu_m)
t_dirclean_headers <- c("ACP exports\n(EU fixed)","EU exports\n(EU fixed)",
                        "ACP exports\n(direction-matched\nex-EU share)",
                        "EU exports\n(direction-matched\nex-EU share)")
t_dirclean_keep    <- !vapply(t_dirclean_models, is.null, logical(1))

do.call(etable, c(
  unname(t_dirclean_models[t_dirclean_keep]),
  list(
    headers  = t_dirclean_headers[t_dirclean_keep],
    title    = "Direction-Matched Robustness: EU-Component-Fixed and Direction-Matched Ex-EU Share",
    se.below = TRUE, depvar = FALSE, fitstat = ~n,
    notes = paste0(
      "Columns (1)-(2) hold the EU component of the denominator at each ",
      "country's own mean, so their coefficients are comparable in magnitude ",
      "to the pooled baseline. Columns (3)-(4), where present, use it_share_exeu_x/_m ",
      "-- an ex-EU share built ONLY from the matching direction's own trade flows ",
      "(export-side for column 3, import-side for column 4) -- a genuinely different, ",
      "more narrowly-matched construction from the pooled it_share_exeu used in ",
      "Table 5's ex-EU-denominator columns, despite the similar name. The Overlapping ",
      "and Side-matched log-decomposition versions of these same two directions are ",
      "Table 4's own rows and are not repeated here. In both constructions the ",
      "ACP-exports-to-EU direction stays statistically indistinguishable from zero ",
      "while the EU-exports-to-ACP direction retains a significant negative ",
      "coefficient -- an asymmetry in the opposite direction from Table 4's ",
      "side-matched result, discussed in Section 5.3. Standard errors clustered by ",
      CLUSTER_LABEL, "."),
    file = F_T10_DIRCLEAN, replace = TRUE
  )
))


# --- 10.5 Does the coefficient scale with the mechanical channel? ------------
# Two versions. The interaction uses within-sample variation in the EU trade
# share; the period windows use the secular decline in EU dependence as ACP
# trade diversified toward Asia. Both are diagnostics, not tests: s_eu contains
# the dependent variable, and three period estimates cannot support an inference
# about a trend. Report what they show and let Sections 10.2-10.4 carry the
# argument.
message(sprintf(
  "IT Share x EU trade share: main %+.4f (SE %.4f) | interaction %+.4f (SE %.4f, t %+.2f)",
  coef(m_seu)[["it_share"]], se(m_seu)[["it_share"]],
  coef(m_seu)[["it_share:s_eu_dev"]], se(m_seu)[["it_share:s_eu_dev"]],
  coef(m_seu)[["it_share:s_eu_dev"]] / se(m_seu)[["it_share:s_eu_dev"]]))

# Windows are derived from SAMPLE_START rather than hardcoded. The previous list
# began at 1995, so against a 2000-start panel the first window held four years
# against nine for the other two and printed as "1995-2003" -- a label naming a
# period the sample does not contain, headed for the paper. At SAMPLE_START =
# 2000 this yields 2000-2007, 2008-2014, 2015-2021.
N_PERIOD_WINDOWS <- 3L
PERIOD_WINDOWS <- {
  yrs <- SAMPLE_START:max(panel$year)
  if (length(yrs) < 2 * N_PERIOD_WINDOWS)
    stop("Sample spans ", length(yrs), " years -- too short to split into ",
         N_PERIOD_WINDOWS, " period windows.")
  grp <- cut(seq_along(yrs), N_PERIOD_WINDOWS, labels = FALSE)
  unname(lapply(split(yrs, grp), function(y) c(min(y), max(y))))
}

period_tbl <- map_dfr(PERIOD_WINDOWS, function(w) {
  d <- panel |> filter(year >= w[1], year <= w[2])
  if (nrow(d) == 0 || all(is.na(d$it_share))) return(NULL)
  m <- tryCatch(fit_ppml(f_main, d), error = function(e) NULL)
  if (is.null(m)) return(NULL)
  tibble(
    # Labelled from the years actually estimated on, not from the requested
    # window, so a window reaching past the panel cannot mislabel itself.
    window    = sprintf("%d-%d", min(d$year), max(d$year)),
    mean_s_eu = round(mean(d$s_eu, na.rm = TRUE), 4),
    coef      = round(coef(m)[["it_share"]], 4),
    se        = round(se(m)[["it_share"]], 4),
    n         = nobs(m),
    sig       = stars(coef(m)[["it_share"]], se(m)[["it_share"]])
  )
})

message("IT Share coefficient by period window, against mean EU trade share:")
print(period_tbl)
message("  Diagnostic only: the coefficient weakening as mean_s_eu falls is the ",
        "mechanical signature, but three points cannot establish a trend, and ",
        "the sequence has been non-monotone. State it as descriptive.")
write_csv(period_tbl, F_AUX_PERIODS)


# --- 10.6 Restriction summary  ->  AUX ---------------------------------------
# Every ratio-restriction test in one place. The paper quotes the range of
# t-statistics across cells and the count of rejections; both are computed here
# rather than read off the console, so a re-run cannot silently change a number
# that is already in the manuscript.
restriction_tbl <- bind_rows(
  rr_pooled, rr_clean_acp, rr_clean_eu,
  rr_orth, rr_orth_acp, rr_orth_eu,
  rr_side_m, rr_side_x
) |>
  mutate(across(c(b_num, se_num, b_den, se_den,
                  restr_sum, restr_se, restr_t), \(x) round(x, 4)))

message("Ratio-restriction tests, all cells:")
print(restriction_tbl |>
        select(specification, cell, numerator, b_num, denominator, b_den,
               restr_sum, restr_t, rejected),
      n = nrow(restriction_tbl))

message(sprintf(
  "  Rejected in %d of %d cells; |t| ranges %.2f to %.2f.",
  sum(restriction_tbl$rejected), nrow(restriction_tbl),
  min(abs(restriction_tbl$restr_t)), max(abs(restriction_tbl$restr_t))))
if (!all(restriction_tbl$rejected))
  message("  NOT all cells reject. The paper's blanket claim must be narrowed ",
          "to the cells that do, and the exceptions named.")

write_csv(restriction_tbl, F_AUX_RESTRICT)

# --- 10.6b LaTeX rendering of the same table ---------------------------------
# Added 2026-08-04. Previously this test existed only as a CSV plus console
# text -- the formatted version quoted in the paper had to be retyped by hand
# from those numbers every time the panel was rebuilt, which is exactly the
# kind of manual step that produces a drifted number nobody notices. This
# reproduces the same booktabs layout mechanically from restriction_tbl.
rt_tex <- restriction_tbl |>
  mutate(dag = if_else(rejected, "\\textsuperscript{\\dag}", ""))

tex_rows <- with(rt_tex, sprintf(
  "%-25s & %-9s & %+.3f & (%.3f) & %+.3f & (%.3f) & %+.3f & (%.3f) & %+.2f%s \\\\",
  specification, cell, b_num, se_num, b_den, se_den, restr_sum, restr_se,
  restr_t, dag
))

tex_out <- c(
  "\\begin{tabular}{llrrrrrrr}",
  "\\midrule\\midrule",
  "Specification & Cell & $\\beta_{\\text{num}}$ & (SE) & $\\beta_{\\text{den}}$ & (SE) & Sum & (SE) & $t$ \\\\",
  "\\midrule",
  tex_rows,
  "\\midrule\\midrule",
  sprintf(paste0(
    "\\multicolumn{9}{p{0.95\\linewidth}}{\\emph{Restriction ",
    "$\\beta_{\\text{num}} + \\beta_{\\text{den}} = 0$ is imposed by the ",
    "ratio's functional form. \\textsuperscript{\\dag}Rejected at 5\\%%. ",
    "Rejected in %d of %d cells; $|t|$ ranges %.2f to %.2f. Standard errors ",
    "clustered by ", CLUSTER_LABEL, ".}}\\\\"),
    sum(rt_tex$rejected), nrow(rt_tex),
    min(abs(rt_tex$restr_t)), max(abs(rt_tex$restr_t))),
  "\\end{tabular}"
)

writeLines(tex_out, F_T4_RESTRICTION)
message("Wrote ", F_T4_RESTRICTION, " (", nrow(rt_tex), " rows, ",
        sum(rt_tex$rejected), " rejected).")
if (!all(rt_tex$rejected))
  message("  NOT all rows rejected -- the .tex file's blanket dagger claim ",
          "would be wrong. Check before using this file as-is.")


# --- 10.7 Table 3 ------------------------------------------------------------
etable(
  m2, m2_exeu, m2_fixeu, m_logdirty, m_logclean,
  headers  = c("Baseline","Ex-EU\ndenominator","EU component\nfixed",
               "Log decomp.\n(total)","Log decomp.\n(non-EU)"),
  se.below = TRUE, depvar = FALSE, fitstat = ~n,
  notes = paste0(
    "Column (3) rescales the ex-EU share by each country's mean EU trade share, ",
    "so its coefficient is directly comparable in magnitude to column (1); ",
    "column (2)'s is not. Standard errors clustered by ", CLUSTER_LABEL, "."),
  file = F_T3_MECHANICAL, replace = TRUE
)

# The battery is plotted in Section 15 as part of fig_coef_stability, which puts
# the baseline and the EU-component-fixed estimate on one axis. The ex-EU and
# log-decomposition columns are deliberately left off that figure: their
# regressors are on different scales and a shared axis would mislead.


# =============================================================================
# 11. REC HETEROGENEITY  ->  TABLE 6
# =============================================================================
# Seven separate subsample regressions produced ln(Distance) coefficients of
# -18.86 (SADC) and +13.26 (PIF). Those are not credible gravity elasticities,
# and a referee who notices them will discount the IT Share coefficients in the
# same columns. The interaction model below holds the fixed-effect structure and
# the gravity controls common across blocs, so the seven IT Share slopes are
# estimated off a single well-identified model and are directly comparable to
# each other -- which also disposes of the earlier draft's caveat that subsample
# coefficients are not magnitude-comparable to the pooled estimate.
#
# rec is time-invariant within country (except MRT and TLS), so REC main effects
# are absorbed by the ACP-country fixed effect and only the slopes are needed.
for (r in REC_LEVELS) {
  panel[[paste0("it_", REC_TAGS[[r]])]] <-
    panel$it_share * as.numeric(panel$rec == r)
}
it_cols <- paste0("it_", REC_TAGS[REC_LEVELS])

# (A) Seven free slopes, for the table.
f_rec_free <- as.formula(paste0("total_bilateral ~ ", X, " + ",
                                paste(it_cols, collapse = " + "), FE))
m_rec_free <- fit_ppml(f_rec_free, panel)

# (B) Common slope plus six deviations, for the homogeneity test. ECOWAS is the
# reference simply because it is the largest bloc by country count.
REF_REC  <- "ECOWAS"
dev_recs <- setdiff(REC_LEVELS, REF_REC)
for (r in dev_recs) {
  panel[[paste0("dev_", REC_TAGS[[r]])]] <-
    panel$it_share * as.numeric(panel$rec == r)
}
dev_cols <- paste0("dev_", REC_TAGS[dev_recs])

f_rec_dev <- as.formula(paste0("total_bilateral ~ ", X, " + it_share + ",
                               paste(dev_cols, collapse = " + "), FE))
m_rec_dev <- fit_ppml(f_rec_dev, panel)

homog_test <- wald_bits(tryCatch(wald(m_rec_dev, keep = "^dev_", print = FALSE),
                                 error = function(e) NULL))
if (!is.na(homog_test$stat)) {
  message(sprintf(
    "Joint test of REC homogeneity (all deviations from %s = 0): F = %.2f, p = %.4f",
    REF_REC, homog_test$stat, homog_test$p
  ))
  message("  Rejection means the stumbling-block effect differs across blocs; ",
          "failure to reject licenses the pooled estimate.")
}

# PIF is the outlier throughout (mean IT share 0.040 with almost no variation,
# and a subsample coefficient near -31). The test is repeated without it so the
# paper can say whether bloc heterogeneity is a general finding or a PIF finding.
f_rec_dev_nopif <- as.formula(paste0(
  "total_bilateral ~ ", X, " + it_share + ",
  paste(setdiff(dev_cols, "dev_PIF"), collapse = " + "), FE
))
m_rec_dev_nopif <- tryCatch(
  fit_ppml(f_rec_dev_nopif, panel |> filter(rec != "PIF")),
  error = function(e) NULL
)
if (!is.null(m_rec_dev_nopif)) {
  ht2 <- wald_bits(tryCatch(wald(m_rec_dev_nopif, keep = "^dev_", print = FALSE),
                            error = function(e) NULL))
  if (!is.na(ht2$stat))
    message(sprintf("  Same test excluding PIF: F = %.2f, p = %.4f",
                    ht2$stat, ht2$p))
}

etable(
  m_rec_free, m_rec_dev,
  title    = "IT Share Effect by REC - Interaction Model",
  headers  = c("Free slopes by REC", paste0("Deviations from ", REF_REC)),
  se.below = TRUE, depvar = FALSE, fitstat = ~n,
  notes = paste0(
    "Single pooled model; REC main effects absorbed by the ACP-country fixed ",
    "effect. Coefficients are directly comparable across blocs and to the ",
    "pooled estimate in Table 1. Standard errors clustered by ", CLUSTER_LABEL, "."),
  file = F_T6_RECINTER, replace = TRUE
)

# --- 11.5 Does any currency union or export concentration explain a bloc's --
#           REC deviation? (Added 2026-08-04, post-conference; generalized
#           2026-08-05 from a Central-Africa-only peg test to all six unions
#           PLUS export concentration, fitted together.)
# The REC heterogeneity model above estimates a deviation term for each bloc
# relative to ECOWAS. CEMAC and Comoros are EUR pegs; CMA, ECCU and Pacific
# dollarization are not (rand, USD, NZD/AUD respectively) but are the only
# currency-union variation inside SADC, CARIFORUM and PIF and are tested on
# the same footing so the exercise is not selectively run only where a EUR
# mechanism is available. WAEMU is the one union with no REC deviation term
# to test against: it sits inside ECOWAS, the reference bloc (no dev_ECOWAS
# exists, by construction of the reference-category model), so its
# interaction is reported standalone -- it asks whether WAEMU members' slope
# differs from other ECOWAS members (Nigeria, Ghana, etc.), not whether it
# explains a deviation from them. export_hhi is reported standalone for the
# same structural reason: it is a continuous, economy-wide measure, not a
# REC-specific dummy, even though Central Africa's oil/commodity concentration
# is the case that motivated adding it (handoff item 2) -- reading its
# interaction alongside the before/after dev_CAF numbers below is still
# informative even without a formal per-REC test.
#
# All interactions are fitted in ONE combined model together with the REC
# deviation terms, not one at a time: currency unions are on nearly the same
# footing as REC identity (CEMAC-Central Africa, WAEMU-ECOWAS overlap almost
# completely), and export concentration is correlated with REC identity too
# (Central Africa's oil exporters are exactly why item 2 was prioritized), so
# fitting these one at a time would let each candidate explanation silently
# re-absorb variation another one already claims.
#
# This is diagnostic, not folded into Table 6, since it changes the
# specification Table 6 is built around; written to its own aux CSV so the
# numbers are available for the text without renumbering Table 6.
PEG_REC_MAP <- list(
  peg_cemac   = "dev_CAF",
  peg_comoros = "dev_ESA",
  peg_cma     = "dev_SADC",
  peg_eccu    = "dev_CARIFORUM",
  peg_pacific = "dev_PIF"
  # peg_waemu deliberately absent: ECOWAS is the reference bloc, no dev_ term
  # exists to test it against. Reported standalone below instead.
)

peg_test_tbl <- NULL
if (HAS_NEW_CONTROLS) {
  standalone_terms <- c("peg_waemu", "export_hhi")
  peg_interactions <- paste0("it_share:", c(names(PEG_REC_MAP), standalone_terms))
  f_rec_dev_peg <- as.formula(paste0(
    "total_bilateral ~ ", X, " + it_share + ",
    paste(dev_cols, collapse = " + "), " + ",
    paste(peg_interactions, collapse = " + "), FE
  ))
  m_rec_dev_peg <- tryCatch(fit_ppml(f_rec_dev_peg, panel), error = function(e) NULL)
  
  if (!is.null(m_rec_dev_peg)) {
    peg_rows <- list()
    
    for (peg in names(PEG_REC_MAP)) {
      dev_term <- PEG_REC_MAP[[peg]]
      int_term <- paste0("it_share:", peg)
      if (!(dev_term %in% names(coef(m_rec_dev)) &&
            int_term %in% names(coef(m_rec_dev_peg)))) {
        message(sprintf("  %s / %s not both estimable -- skipped.", peg, dev_term))
        next
      }
      b_before  <- coef(m_rec_dev)[[dev_term]];      se_before <- se(m_rec_dev)[[dev_term]]
      b_after   <- coef(m_rec_dev_peg)[[dev_term]];  se_after  <- se(m_rec_dev_peg)[[dev_term]]
      b_int     <- safe_coef(m_rec_dev_peg, int_term); se_int  <- safe_se(m_rec_dev_peg, int_term)
      # Two distinct senses of "shrinks", which can disagree: the point
      # estimate can move further from zero while its precision degrades
      # enough that its t-stat still falls (e.g. Comoros/dev_ESA: b grows
      # 1.635 -> 1.760 but t falls 1.27 -> 1.18, because SE grows faster).
      # Report both explicitly rather than collapsing to one flag, since the
      # paper's prose narrates the magnitude version ("reduces by X percent")
      # and a reader checking raw numbers against a t-stat-only flag would
      # reasonably read a case like Comoros as mislabeled.
      magnitude_shrinks <- abs(b_after) < abs(b_before)
      sig_shrinks        <- abs(b_after / se_after) < abs(b_before / se_before)
      
      message(sprintf(
        "%s: %s %+.4f (t %+.2f) before %s interaction | %+.4f (t %+.2f) after | %s %+.4f (t %+.2f) | magnitude %s, significance %s",
        peg, dev_term, b_before, b_before / se_before, peg,
        b_after, b_after / se_after, int_term, b_int, b_int / se_int,
        if (magnitude_shrinks) "shrinks" else "does NOT shrink",
        if (sig_shrinks) "shrinks (consistent with, not proof of, explaining part of the deviation)"
        else "does NOT shrink -- checked and rejected as an explanation, not confirmed"
      ))
      
      peg_rows[[peg]] <- tibble(
        peg = peg, rec_term = dev_term,
        dev_before = b_before, dev_before_se = se_before,
        dev_after  = b_after,  dev_after_se  = se_after,
        interaction = b_int,   interaction_se = se_int,
        magnitude_shrinks = magnitude_shrinks,
        sig_shrinks = sig_shrinks
      )
    }
    
    # Standalone terms: no REC deviation to compare against, either because
    # the union sits inside the reference bloc (peg_waemu) or because the
    # variable is continuous and economy-wide rather than REC-specific
    # (export_hhi).
    for (term in standalone_terms) {
      int_term <- paste0("it_share:", term)
      if (!(int_term %in% names(coef(m_rec_dev_peg)))) next
      b <- safe_coef(m_rec_dev_peg, int_term)
      s <- safe_se(m_rec_dev_peg, int_term)
      message(sprintf(
        "%s (standalone, no REC deviation to compare): %s %+.4f (SE %.4f, t %+.2f)%s",
        term, int_term, b, s, b / s, stars(b, s)))
      peg_rows[[term]] <- tibble(
        peg = term, rec_term = NA_character_,
        dev_before = NA_real_, dev_before_se = NA_real_,
        dev_after  = NA_real_, dev_after_se  = NA_real_,
        interaction = b, interaction_se = s,
        magnitude_shrinks = NA, sig_shrinks = NA
      )
    }
    
    if (length(peg_rows) > 0) {
      peg_test_tbl <- bind_rows(peg_rows) |>
        mutate(across(where(is.numeric), \(x) round(x, 4)))
      write_csv(peg_test_tbl, file.path(DIR_TAB, "aux_currency_peg_test.csv"))
      message(sprintf("Wrote aux_currency_peg_test.csv (%d candidate explanations tested).", nrow(peg_test_tbl)))
    }
  } else {
    message("Combined currency-peg / export-concentration interaction model ",
            "failed to fit -- diagnostic skipped.")
  }
}

# Subsample regressions, kept for the forest plot in Section 15. They are no
# longer written as a table: the implausible distance elasticities in several
# columns show these subsamples are weakly identified, and the visible width of
# their intervals makes that case better as a figure than as a column of
# numbers a reader might quote.
rec_models <- REC_LEVELS |>
  set_names() |>
  map(function(r) tryCatch(fit_ppml(f_main, panel |> filter(rec == r)),
                           error = function(e) NULL))
rec_keep <- !map_lgl(rec_models, is.null)

rec_coefs <- imap_dfr(rec_models[rec_keep], function(mod, rec_name) {
  if (!"it_share" %in% names(coef(mod))) return(NULL)
  tibble(rec = rec_name, source = "Subsample",
         estimate = coef(mod)[["it_share"]], se = se(mod)[["it_share"]])
})

inter_coefs <- tibble(
  rec      = REC_LEVELS,
  source   = "Interaction",
  estimate = map_dbl(it_cols, \(v) safe_coef(m_rec_free, v)),
  se       = map_dbl(it_cols, \(v) safe_se(m_rec_free, v))
)

rec_compare <- bind_rows(rec_coefs, inter_coefs) |>
  mutate(ci_lo = estimate - 1.96 * se,
         ci_hi = estimate + 1.96 * se,
         rec   = factor(rec, levels = rev(REC_LEVELS)))


# =============================================================================
# 12. MARGINAL EFFECTS  ->  TABLE 2
# =============================================================================
# An earlier version reported 100 * (exp(b * IT Share) - 1) at each REC mean --
# the effect of moving a bloc from ZERO intra-regional trade to its observed
# mean. Zero lies outside the observed support for every REC, and at a
# coefficient near -2.5 the extrapolation put SADC at roughly -55%, a number
# that invites exactly the reading this paper argues against. Those rows are
# gone. The contrasts below all stay inside the support: a one-standard-
# deviation increase, an interquartile move, and a p10-p90 move.

b_it <- coef(m2)[["it_share"]]
b_se <- se(m2)[["it_share"]]

it_sd  <- sd(est_sample$it_share, na.rm = TRUE)
it_q   <- quantile(panel$it_share, c(0.10, 0.25, 0.75, 0.90), na.rm = TRUE)
it_iqr <- it_q[["75%"]] - it_q[["25%"]]

rec_means <- panel |>
  filter(!is.na(it_share), !is.na(rec)) |>
  distinct(acp_iso3, year, rec, it_share) |>
  group_by(rec) |>
  summarise(mean_it = mean(it_share, na.rm = TRUE), .groups = "drop")

message("REC mean IT shares (Table 2 evaluation points):")
print(rec_means |> mutate(mean_it = round(mean_it, 4)))

contrast_tbl <- bind_rows(
  tibble(contrast = "+1 standard deviation",      delta = it_sd),
  tibble(contrast = "p25 to p75 (interquartile)", delta = it_iqr),
  tibble(contrast = "p10 to p90",                 delta = it_q[["90%"]] - it_q[["10%"]]),
  rec_means |> transmute(
    contrast = paste0("Pooled mean to ", rec, " mean"),
    delta    = mean_it - it_mean_est
  )
) |>
  mutate(
    pct   = round(pct_change(b_it, delta), 1),
    lo    = round(pct_change(b_it - 1.96 * b_se, delta), 1),
    hi    = round(pct_change(b_it + 1.96 * b_se, delta), 1),
    delta = round(delta, 4)
  ) |>
  # exp() is monotone but the CI bounds flip when delta is negative.
  mutate(ci_lo = pmin(lo, hi), ci_hi = pmax(lo, hi)) |>
  select(contrast, delta, pct, ci_lo, ci_hi)

marginal_tbl <- contrast_tbl
print(marginal_tbl, n = nrow(marginal_tbl))
write_csv(marginal_tbl, F_T2_MARGINAL_C)

writeLines(c(
  "\\begin{tabular}{lrrr}",
  "\\midrule\\midrule",
  "Contrast & $\\Delta$ IT Share & \\% change in trade & 95\\% CI \\\\",
  "\\midrule",
  sprintf("%-42s & %+.4f & %+.1f\\%% & [%.1f, %.1f] \\\\",
          contrast_tbl$contrast, contrast_tbl$delta,
          contrast_tbl$pct, contrast_tbl$ci_lo, contrast_tbl$ci_hi),
  "\\midrule\\midrule",
  sprintf("\\multicolumn{4}{l}{\\emph{PPML (M2) $\\hat{\\beta} = %.3f$, SE = %.3f, clustered by %s.}}\\\\",
          b_it, b_se, CLUSTER_LABEL),
  "\\multicolumn{4}{l}{\\emph{\\% change $= 100(\\exp(\\hat{\\beta}\\,\\Delta) - 1)$.}}\\\\",
  "\\multicolumn{4}{p{0.85\\linewidth}}{\\emph{All contrasts lie inside the observed support of IT Share.}}\\\\",
  "\\end{tabular}"
), F_T2_MARGINAL)
message("Marginal effects table saved: ", F_T2_MARGINAL)


# =============================================================================
# 13. ROBUSTNESS: ESTIMATORS AND MEASUREMENT  ->  TABLE 7
# =============================================================================
m5b   <- feols(f_ols_plus, data = panel, cluster = CLUSTER_MAIN)
m_gdp <- fit_ppml(f_gdp, panel)

message(sprintf("OLS log(1+trade): %.4f (SE %.4f)",
                coef(m5b)[["it_share"]], se(m5b)[["it_share"]]))
message(sprintf("Pooled + GDP/pop: %.4f (SE %.4f, n=%d) | baseline %.4f (SE %.4f, n=%d)",
                coef(m_gdp)[["it_share"]], se(m_gdp)[["it_share"]], nobs(m_gdp),
                coef(m2)[["it_share"]],    se(m2)[["it_share"]],    nobs(m2)))

# IT Intensity note for the paper: it_intensity = it_share / (REC share of world
# trade). The scaling factor varies at REC x year and there is no REC x year
# fixed effect, so this is NOT an independent measurement check -- it inherits
# the denominator problem in Section 10 intact and adds REC-size variation on
# top. Reported because the earlier draft reported it; the text should say what
# it does and does not add.
# Three guarded additions (2026-08-04, post-conference). Each is its own
# column rather than folded into one model, so each control's effect on the
# it_share coefficient is visible individually rather than confounded together.
m_hhi <- m_ehhi <- m_peg <- m_linder <- NULL
if (HAS_NEW_CONTROLS) {
  m_hhi <- tryCatch(fit_ppml(mk("total_bilateral", "it_share + eu_partner_hhi"), panel),
                    error = function(e) { warning("HHI column failed: ", conditionMessage(e)); NULL })
  m_ehhi <- tryCatch(fit_ppml(mk("total_bilateral", "it_share + export_hhi"), panel),
                     error = function(e) { warning("Export-HHI column failed: ", conditionMessage(e)); NULL })
  
  # The six granular flags (peg_cemac ... peg_pacific) are each static per
  # country. With acp_iso3 in the fixed-effect set, a naked main effect is
  # perfectly collinear with the country FE and fixest would silently drop
  # it -- entering "it_share + peg_cemac" here would produce a column that
  # LOOKS like a control but estimates nothing. Entered as interactions with
  # it_share instead: this asks whether the IT Share coefficient itself
  # differs for members of each union, the same design Section 11.5 uses
  # per-REC.
  m_peg <- tryCatch(fit_ppml(mk("total_bilateral",
                                paste("it_share",
                                      "it_share:peg_cemac", "it_share:peg_waemu",
                                      "it_share:peg_comoros", "it_share:peg_cma",
                                      "it_share:peg_eccu", "it_share:peg_pacific",
                                      sep = " + ")),
                             panel),
                    error = function(e) { warning("Currency-peg column failed: ", conditionMessage(e)); NULL })
  m_linder <- tryCatch(fit_ppml(mk("total_bilateral", "it_share + gdp_pc_gap"), panel),
                       error = function(e) { warning("Linder column failed: ", conditionMessage(e)); NULL })
  
  if (!is.null(m_peg)) {
    message("IT Share x currency-union interactions (Table 7):")
    for (v in c("it_share:peg_cemac","it_share:peg_waemu","it_share:peg_comoros",
                "it_share:peg_cma","it_share:peg_eccu","it_share:peg_pacific")) {
      b <- safe_coef(m_peg, v); s <- safe_se(m_peg, v)
      message(sprintf("  %-24s %+.4f (SE %.4f, t %+.2f)%s", v, b, s, b/s, stars(b, s)))
    }
  }
}

t6_models  <- list(m2, m2_nb, m5, m5b, m4, m_gdp, m_hhi, m_ehhi, m_peg, m_linder)
t6_headers <- c("Baseline PPML","NB-PML","OLS ln(trade)",
                "OLS ln(1+trade)","IT Intensity","+ ACP GDP/pop",
                "+ EU-partner HHI","+ Export HHI","+ Currency peg x IT","+ EU GDP p.c.")
t6_keep    <- !vapply(t6_models, is.null, logical(1))

do.call(etable, c(
  unname(t6_models[t6_keep]),
  list(
    headers  = t6_headers[t6_keep],
    title    = "Robustness: Alternative Estimators and Measurement",
    se.below = TRUE, depvar = FALSE, fitstat = ~n,
    notes = paste0(
      "IT Intensity rescales IT Share by the REC's share of world trade and ",
      "does not address the denominator problem in Table 3. Column (7), where ",
      "present, adds an EU-partner concentration index alongside IT Share. ",
      "Column (8) adds an HS-chapter export concentration index (Herfindahl), ",
      "testing whether commodity concentration rather than REC identity ",
      "explains bloc heterogeneity. Column (9) interacts IT Share with six ",
      "currency-union flags individually (CEMAC, WAEMU, Comoros: EUR pegs; ",
      "CMA, ECCU, Pacific dollarization: not EU-pegged) rather than entering ",
      "the flags as levels, which would be collinear with the ACP-country ",
      "fixed effect. Column (10) adds a Linder-type EU-ACP GDP-per-capita gap; ",
      "the EU-side level alone is not used as it would be collinear with the ",
      "exporter-year fixed effect. Standard errors clustered by ", CLUSTER_LABEL, "."),
    file = F_T7_ESTIMATORS, replace = TRUE
  )
))


# =============================================================================
# 14. ROBUSTNESS: SAMPLE RESTRICTIONS  ->  TABLE 8
# =============================================================================
# Reading note for the paper. The earlier draft argued that restricting the
# start year strengthened the coefficient, and read that as the pre-Cotonou
# years contributing noise. With the coverage correction in place the gradient
# runs the other way: later start years WEAKEN the estimate. Two explanations
# compete -- a genuine decline in the stumbling-block effect over time, and the
# mechanical account in Section 10, under which |beta| falls because the EU's
# share of ACP trade fell. The period table in Section 10 is what separates them.
#
# panel_full is the pre-SAMPLE_START snapshot from Section 2. The two start-year
# columns must come off it: `panel` has already been filtered to SAMPLE_START,
# so filtering it again to an earlier year is a no-op and silently reproduces
# the baseline. m_from07 is unaffected because 2007 > SAMPLE_START, but it is
# switched too so that all three columns are built the same way.
m_from07     <- fit_ppml(f_main, panel_full |> filter(year >= 2007))
m_alt_start  <- fit_ppml(f_main, panel_full |> filter(year >= ALT_SAMPLE_START))
m_no_zaf     <- fit_ppml(f_main, panel |> filter(acp_iso3 != "ZAF"))
m_no_nga     <- fit_ppml(f_main, panel |> filter(acp_iso3 != "NGA"))
m_no_som_eri <- fit_ppml(f_main, panel |> filter(!acp_iso3 %in% c("SOM","ERI")))
m_no_sacu    <- fit_ppml(f_main, panel |> filter(!acp_iso3 %in% SACU_ISO3))
m_excl_gbr   <- fit_ppml(f_main, panel |> filter(eu_iso3 != "GBR"))
m_africa     <- fit_ppml(f_main, panel |> filter(acp_region == "Africa"))

message(sprintf("Alternative sample %d-2021: %.4f (SE %.4f, n=%d)",
                ALT_SAMPLE_START, coef(m_alt_start)[["it_share"]],
                se(m_alt_start)[["it_share"]], nobs(m_alt_start)))

etable(
  m2, m_alt_start, m_from07, m_no_zaf, m_no_nga, m_no_som_eri,
  m_no_sacu, m_excl_gbr, m_africa, m2_logsample,
  headers  = c("Baseline", sprintf("From %d", ALT_SAMPLE_START),
               "From 2007","Excl. S.Africa","Excl. Nigeria",
               "Excl. SOM+ERI","Excl. SACU","Excl. GBR","Africa only",
               "Log-spec sample"),
  title    = "Robustness: Sample Restrictions",
  se.below = TRUE, depvar = FALSE, fitstat = ~n,
  notes = paste0(
    "Standard errors clustered by ", CLUSTER_LABEL, ". The 'Log-spec sample' ",
    "column restricts to the 39,659 observations with non-missing ",
    "ln(Intra-REC trade) and ln(Extra-regional non-EU trade) -- the same ",
    "restriction Table 4's log-decomposition rows require -- confirming the ",
    "headline coefficient is not an artifact of that restriction. m2_logsample ",
    "is fit earlier, in Section 10.3, on the same sample the log-decomposition ",
    "rows there use; reused here rather than refit."),
  file = F_T8_SAMPLE, replace = TRUE
)

# --- Systematic leave-one-bloc-out ------------------------------------------
# Replaces the ad hoc "Excl. CARIFORUM" and "Excl. PIF" columns. Answers the
# question those were gesturing at -- is any single bloc carrying the pooled
# result -- for all seven at once.
leaveout_models <- REC_LEVELS |>
  set_names() |>
  map(function(r) tryCatch(fit_ppml(f_main, panel |> filter(rec != r)),
                           error = function(e) NULL))
lo_keep <- !map_lgl(leaveout_models, is.null)

leaveout_tbl <- imap_dfr(leaveout_models[lo_keep], function(m, r) {
  tibble(dropped = r, coef = coef(m)[["it_share"]], se = se(m)[["it_share"]],
         n = nobs(m))
}) |>
  mutate(sig = stars(coef, se), across(c(coef, se), \(x) round(x, 4)))
message("Leave-one-REC-out:")
print(leaveout_tbl)

do.call(etable, c(
  unname(leaveout_models[lo_keep]),
  list(
    headers  = paste0("Excl. ", REC_LEVELS[lo_keep]),
    title    = "Robustness: Leave-One-REC-Out",
    se.below = TRUE, depvar = FALSE, fitstat = ~n,
    file     = F_AUX_LEAVEOUT, replace = TRUE
  )
))


# =============================================================================
# 15. FIGURES
# =============================================================================
gsave <- function(name, plot, ...) {
  if (SAVE_FIGS) ggsave(file.path(DIR_FIG, name), plot, ...)
}

p_it_dist <- panel |>
  filter(!is.na(rec), !is.na(it_share)) |>
  distinct(acp_iso3, year, rec, it_share) |>
  ggplot(aes(x = it_share, fill = rec)) +
  geom_histogram(bins = 40, alpha = 0.85) +
  facet_wrap(~rec, scales = "free_y", nrow = 3) +
  scale_fill_manual(values = REC_COLOURS) +
  labs(title = "Intra-REC Trade Share by Regional Grouping",
       x = "IT Share", y = "Count") +
  theme_minimal() + theme(legend.position = "none")
print(p_it_dist)
gsave("fig_it_share_distribution.png", p_it_dist, width = 12, height = 8)

p_it_time <- panel |>
  filter(!is.na(rec), !is.na(it_share)) |>
  distinct(acp_iso3, year, rec, it_share) |>
  group_by(rec, year) |>
  summarise(mean_it_share = mean(it_share, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(x = year, y = mean_it_share, colour = rec)) +
  geom_line(linewidth = 0.9) + geom_point(size = 1.5) +
  scale_x_continuous(
    breaks = unique(c(seq(SAMPLE_START, max(panel$year), 5), max(panel$year)))
  ) +
  scale_colour_manual(values = REC_COLOURS) +
  labs(title = "Mean Intra-REC Trade Share Over Time",
       # The caveat only means something when the panel contains years the
       # coverage rule blanks. With SAMPLE_START >= SADC_COVERAGE_START every
       # such year is gone already and the subtitle points at nothing.
       subtitle = if (SAMPLE_START < SADC_COVERAGE_START)
         sprintf("SADC begins in %d: BACI has no SACU records before then",
                 SADC_COVERAGE_START) else NULL,
       x = NULL, y = "IT Share", colour = "REC") +
  theme_minimal()
print(p_it_time)
gsave("fig_it_share_time_series.png", p_it_time, width = 10, height = 5)

# The EU share of ACP trade over time -- the figure the mechanical argument
# needs, and a useful descriptive in its own right.
p_eu_share <- panel |>
  filter(!is.na(s_eu), !is.na(rec)) |>
  distinct(acp_iso3, year, rec, s_eu) |>
  group_by(rec, year) |>
  summarise(mean_s_eu = mean(s_eu, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(x = year, y = mean_s_eu, colour = rec)) +
  geom_line(linewidth = 0.9) +
  scale_x_continuous(
    breaks = unique(c(seq(SAMPLE_START, max(panel$year), 5), max(panel$year)))
  ) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_colour_manual(values = REC_COLOURS) +
  labs(title = "EU Share of ACP Total Merchandise Trade",
       subtitle = "The size of the mechanical channel in the IT Share denominator",
       x = NULL, y = "EU share of total trade", colour = "REC") +
  theme_minimal()
print(p_eu_share)
gsave("fig_eu_trade_share.png", p_eu_share, width = 10, height = 5)

if (nrow(period_tbl) > 1) {
  p_period <- ggplot(period_tbl, aes(x = mean_s_eu, y = coef)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
    geom_errorbar(aes(ymin = coef - 1.96 * se, ymax = coef + 1.96 * se),
                  width = 0.004, colour = "steelblue") +
    geom_point(size = 3, colour = "steelblue") +
    geom_text(aes(label = window), vjust = -1.2, size = 3.2) +
    labs(title = "IT Share Coefficient Against EU Trade Dependence",
         subtitle = "Each point is a period subsample; a rising line is the mechanical signature",
         x = "Mean EU share of ACP total trade in window",
         y = "Coefficient on IT Share") +
    theme_minimal()
  print(p_period)
  gsave("fig_beta_vs_eu_share.png", p_period, width = 8, height = 5)
}

p_rec_forest <- ggplot(
  rec_compare |> filter(as.character(rec) != "PIF"),
  aes(x = estimate, y = rec, colour = source)
) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey50") +
  geom_errorbar(aes(xmin = ci_lo, xmax = ci_hi),
                width = 0.25, linewidth = 0.8, orientation = "y",
                position = position_dodge(width = 0.5)) +
  geom_point(size = 3, position = position_dodge(width = 0.5)) +
  scale_colour_manual(values = c("Interaction" = "#2E75B6",
                                 "Subsample"   = "grey55")) +
  labs(title = "Effect of IT Share on EU-ACP Trade by REC",
       subtitle = "Interaction model vs separate subsamples; PIF omitted (sparse)",
       x = "Coefficient on Intra-REC Trade Share", y = NULL, colour = NULL) +
  theme_minimal() + theme(legend.position = "bottom")
print(p_rec_forest)
gsave("fig_rec_coef_plot.png", p_rec_forest, width = 9, height = 5)

# A list, not a tribble: fixest fits are lists themselves and tribble would try
# to combine them into a column rather than store them.
stability_models <- list(
  "M2: Main PPML"        = m2,
  "NB-PML"               = m2_nb,
  "OLS ln(trade)"        = m5,
  "EU component fixed"   = m2_fixeu,
  "+ ACP GDP/pop"        = m_gdp,
  "From 2007"            = m_from07,
  "Excl. South Africa"   = m_no_zaf,
  "Excl. Nigeria"        = m_no_nga,
  "Excl. SACU"           = m_no_sacu,
  "Africa only"          = m_africa
)
stability_models[[sprintf("From %d", ALT_SAMPLE_START)]] <- m_alt_start

coef_data <- imap_dfr(stability_models, function(m, lab) {
  v <- if (lab == "EU component fixed") "it_share_fixeu" else "it_share"
  tibble(spec = lab, coef = safe_coef(m, v), se = safe_se(m, v))
}) |>
  filter(!is.na(coef)) |>
  mutate(ci_lo = coef - 1.96 * se, ci_hi = coef + 1.96 * se)

p_coef_stab <- ggplot(coef_data, aes(x = coef, y = reorder(spec, coef))) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "red") +
  geom_vline(xintercept = coef(m2)[["it_share"]], linetype = "dotted",
             colour = "grey50") +
  geom_errorbar(aes(xmin = ci_lo, xmax = ci_hi), width = 0.3, colour = "steelblue") +
  geom_point(size = 3, colour = "steelblue") +
  labs(title = "Coefficient Stability Across Specifications",
       subtitle = sprintf("Effect of IT Share on EU-ACP trade; 95%% CI; clustered by %s",
                          CLUSTER_LABEL),
       x = "Coefficient on IT Share", y = NULL) +
  theme_minimal()
print(p_coef_stab)
gsave("fig_coef_stability.png", p_coef_stab, width = 10, height = 6)

acp_max_dyads <- panel |> distinct(acp_iso3, eu_iso3, year) |>
  count(acp_iso3, name = "max_dyads")

p_zero <- panel |>
  filter(total_bilateral == 0) |>
  group_by(acp_iso3, rec) |>
  summarise(n_zero = n(), .groups = "drop") |>
  left_join(acp_max_dyads, by = "acp_iso3") |>
  mutate(pct_zero = round(100 * n_zero / max_dyads, 1)) |>
  ggplot(aes(x = reorder(acp_iso3, pct_zero), y = pct_zero, fill = rec)) +
  geom_bar(stat = "identity") + coord_flip() +
  scale_fill_manual(values = REC_COLOURS) +
  labs(title = "Percentage of Zero-Trade Dyads by ACP Country",
       x = NULL, y = "% Zero-Trade Pairs") +
  theme_minimal() +
  theme(legend.position = "bottom", legend.title = element_blank())
print(p_zero)
gsave("fig_zero_trade_distribution.png", p_zero, width = 10, height = 12)


# =============================================================================
# 16. ZERO-TRADE DIAGNOSTIC (OLS vs PPML sample difference)
# =============================================================================
# The it_share/OLS/PPML coefficient comparison itself is already reported in
# Table 7 (columns 1, 3-4) -- no separate CSV needed for that. This message is
# the one piece of that section that wasn't duplicated: how many zero-trade
# dyads PPML retains that OLS necessarily drops.
message(sprintf("Zero-trade pairs in PPML but not OLS: %d (%.1f%% of PPML sample).",
                nobs(m2) - nobs(m5), 100 * (nobs(m2) - nobs(m5)) / nobs(m2)))


# =============================================================================
# 17. CONSOLIDATED RESULTS
# =============================================================================
row_of <- function(type, label, model, var) {
  tibble(type = type, specification = label,
         coefficient = safe_coef(model, var),
         std_error   = safe_se(model, var),
         n           = safe_nobs(model),
         variable    = var)
}

# The gravity controls are archived from both Table 1 columns, so the "does
# adding IT Share move the controls" comparison survives outside the printed
# table. CONTROL_VARS tracks the X term in Section 6 and so picks up contiguity
# automatically whenever USE_CONTIGUITY is TRUE.
CONTROL_VARS <- c("ln_dist", if (USE_CONTIGUITY) "contiguity",
                  "lang", "colonial", "epa")

gravity_rows <- bind_rows(
  map_dfr(CONTROL_VARS, \(v) row_of("Gravity", "M1: Baseline PPML", m1, v)),
  map_dfr(CONTROL_VARS, \(v) row_of("Gravity", "M2: Main PPML",     m2, v))
)

# One row per ratio-restriction cell, carrying b_num + b_den and its standard
# error. The component coefficients are already archived in the Mechanical and
# Direction blocks; the restriction test itself is what is not otherwise
# recoverable from this file.
decomp_rows <- if (exists("restriction_tbl")) {
  restriction_tbl |>
    mutate(
      type          = "Restriction",
      specification = paste0(specification, ": ", cell),
      coefficient   = restr_sum,
      std_error     = restr_se,
      variable      = paste0(numerator, " + ", denominator)
    ) |>
    select(type, specification, coefficient, std_error, n, variable)
} else {
  message("  NOTE: restriction_tbl not found -- Section 10 did not complete. ",
          "The Restriction block is omitted from results_consolidated.")
  NULL
}

results_consolidated <- bind_rows(
  gravity_rows,
  
  row_of("Main",       "M2: Main PPML",                  m2,          "it_share"),
  row_of("Main",       "M3c: Net EPA at mean IT Share",  m3_centered, "epa"),
  row_of("Main",       "M5: OLS ln(trade)",              m5,          "it_share"),
  row_of("Main",       "M5b: OLS ln(1+trade)",           m5b,         "it_share"),
  row_of("Main",       "NB-PML",                         m2_nb,       "it_share"),
  row_of("Main",       "+ ACP GDP/pop",                  m_gdp,       "it_share"),
  
  row_of("Mechanical", "Ex-EU denominator",              m2_exeu,     "it_share_exeu"),
  row_of("Mechanical", "EU component fixed",             m2_fixeu,    "it_share_fixeu"),
  row_of("Mechanical", "Log decomp (total): ln(intra)",  m_logdirty,  "ln_intra"),
  row_of("Mechanical", "Log decomp (total): ln(total)",  m_logdirty,  "ln_total"),
  row_of("Mechanical", "Log decomp (clean): ln(intra)",  m_logclean,  "ln_intra"),
  row_of("Mechanical", "Log decomp (clean): ln(non-EU)", m_logclean,  "ln_noneu"),
  row_of("Mechanical", "IT Share x EU share",            m_seu,       "it_share:s_eu_dev"),
  row_of("Mechanical", "Disjoint: ln(intra)",            m_logorth,   "ln_intra"),
  row_of("Mechanical", "Disjoint: ln(extra non-EU)",     m_logorth,   "ln_extra"),
  row_of("Mechanical", "Baseline, log-spec sample",      m2_logsample, "it_share"),
  
  decomp_rows,
  
  row_of("Direction",  "D1: ACP exports to EU",          m_acp_exp,   "it_share"),
  row_of("Direction",  "D2: EU exports to ACP",          m_eu_exp,    "it_share"),
  row_of("Direction",  "D3: EU exports + GDP/pop",       m_gdp_eu,    "it_share"),
  row_of("Direction",  "D4: ACP exports, ex-EU denom",   m_acp_exeu,  "it_share_exeu"),
  row_of("Direction",  "D5: EU exports, ex-EU denom",    m_eu_exeu,   "it_share_exeu"),
  row_of("Direction",  "D6: ACP exports, EU fixed",      m_fixeu_acp, "it_share_fixeu"),
  row_of("Direction",  "D7: EU exports, EU fixed",       m_fixeu_eu,  "it_share_fixeu"),
  row_of("Direction",  "D8: ACP exports, ln(intra)",     m_logorth_acp, "ln_intra"),
  row_of("Direction",  "D9: EU exports, ln(intra)",      m_logorth_eu,  "ln_intra"),
  row_of("Direction",  "D10: ACP exports, export denom", m_exeu_x,      "it_share_exeu_x"),
  row_of("Direction",  "D11: EU exports, import denom",  m_exeu_m,      "it_share_exeu_m"),
  row_of("Direction",  "D12: EU exports, ln(intra imports)",  m_logclean_m, "ln_intra_m"),
  row_of("Direction",  "D13: ACP exports, ln(intra exports)", m_logclean_x, "ln_intra_x"),
  
  map2_dfr(it_cols, REC_LEVELS,
           \(v, r) row_of("REC (interaction)", r, m_rec_free, v)),
  
  row_of("Sample",     sprintf("From %d", ALT_SAMPLE_START), m_alt_start, "it_share"),
  row_of("Sample",     "From 2007",                      m_from07,    "it_share"),
  row_of("Sample",     "Excl. South Africa",             m_no_zaf,    "it_share"),
  row_of("Sample",     "Excl. Nigeria",                  m_no_nga,    "it_share"),
  row_of("Sample",     "Excl. SOM+ERI",                  m_no_som_eri, "it_share"),
  row_of("Sample",     "Excl. SACU",                     m_no_sacu,   "it_share"),
  row_of("Sample",     "Excl. GBR",                      m_excl_gbr,  "it_share"),
  row_of("Sample",     "Africa only",                    m_africa,    "it_share")
) |>
  mutate(
    t   = coefficient / std_error,
    sig = stars(coefficient, std_error),
    across(c(coefficient, std_error, t), \(x) round(x, 4))
  ) |>
  select(type, specification, variable, coefficient, std_error, t, sig, n)

print(results_consolidated, n = nrow(results_consolidated))
message(sprintf("Consolidated results: %d rows across %d blocks.",
                nrow(results_consolidated), n_distinct(results_consolidated$type)))
write_csv(results_consolidated, F_AUX_CONSOL)


# =============================================================================
# 18. OUTPUT VERIFICATION
# =============================================================================
# The completion message below fires whether or not anything was written. This
# block checks the filesystem instead: every expected file must exist, be
# non-trivial in size, and carry a modification time from THIS run.
outputs <- tibble(file = EXPECTED_OUTPUTS, exists = file.exists(EXPECTED_OUTPUTS)) |>
  mutate(
    size_kb = ifelse(exists, round(file.size(file) / 1024, 1), NA_real_),
    mtime   = as.POSIXct(ifelse(exists, file.mtime(file), NA), origin = "1970-01-01"),
    fresh   = exists & !is.na(mtime) & mtime >= RUN_START,
    status  = case_when(
      !exists       ~ "MISSING",
      !fresh        ~ "STALE (not written this run)",
      size_kb < 0.1 ~ "SUSPICIOUSLY SMALL",
      TRUE          ~ "ok"
    ),
    file = basename(file)
  )

print(outputs |> select(file, status, size_kb, mtime), n = nrow(outputs))

bad <- outputs |> filter(status != "ok")
if (nrow(bad) > 0) {
  warning(nrow(bad), " expected output(s) missing, stale, or suspiciously small. ",
          "Do NOT copy numbers into the paper until this is clean.", call. = FALSE)
} else {
  message("All ", nrow(outputs), " expected outputs written this run.")
}

message("Estimation and diagnostics finished in ",
        round(difftime(Sys.time(), RUN_START, units = "mins"), 1), " minutes.")
message("  Figures: ", DIR_FIG)
message("  Tables:  ", DIR_TAB)


# =============================================================================
# 19. NUMBERS TO CARRY INTO THE PAPER
# =============================================================================
message("\n================ NUMBERS FOR THE PAPER ================")

message(sprintf("Sample: %d-2021, N = %s, clustered by %s (%d clusters).",
                SAMPLE_START, format(nobs(m2), big.mark = ","), CLUSTER_LABEL,
                n_distinct(panel$acp_iso3)))

message("\n-- Headline --")
message(sprintf("  IT Share (M2):            %+.4f (SE %.4f)%s",
                coef(m2)[["it_share"]], se(m2)[["it_share"]],
                stars(coef(m2)[["it_share"]], se(m2)[["it_share"]])))
message(sprintf("  Same fit, dyad-clustered: %+.4f (SE %.4f) <- the previous paper's SE",
                coef(m2)[["it_share"]],
                safe_se(m2, "it_share", vcov = ~pair_id)))

message("\n-- Mechanical endogeneity (the section that decides the framing) --")
message(sprintf("  Ex-EU denominator:        %+.4f (SE %.4f)%s",
                safe_coef(m2_exeu, "it_share_exeu"), safe_se(m2_exeu, "it_share_exeu"),
                stars(safe_coef(m2_exeu, "it_share_exeu"), safe_se(m2_exeu, "it_share_exeu"))))
message(sprintf("  EU component fixed:       %+.4f (SE %.4f)%s   <- directly comparable to the headline",
                safe_coef(m2_fixeu, "it_share_fixeu"), safe_se(m2_fixeu, "it_share_fixeu"),
                stars(safe_coef(m2_fixeu, "it_share_fixeu"), safe_se(m2_fixeu, "it_share_fixeu"))))
message(sprintf("  ln(intra), clean decomp:  %+.4f (SE %.4f)%s   <- no mechanical link to any EU dyad",
                safe_coef(m_logclean, "ln_intra"), safe_se(m_logclean, "ln_intra"),
                stars(safe_coef(m_logclean, "ln_intra"), safe_se(m_logclean, "ln_intra"))))
message(sprintf("  ln(non-EU), clean decomp: %+.4f (SE %.4f)%s",
                safe_coef(m_logclean, "ln_noneu"), safe_se(m_logclean, "ln_noneu"),
                stars(safe_coef(m_logclean, "ln_noneu"), safe_se(m_logclean, "ln_noneu"))))
message(sprintf("  Ratio restriction sum:    %+.4f (SE %.4f, t = %.2f)",
                b_i + b_n, sum_se, (b_i + b_n) / sum_se))
message(sprintf("  Share form implied at mean:  %+.4f x %.4f = %+.4f   <- against the expansion CI",
                coef(m2)[["it_share"]], it_mean_est,
                coef(m2)[["it_share"]] * it_mean_est))
message(sprintf("  Mean EU share of ACP trade: %.4f", mean(panel$s_eu, na.rm = TRUE)))

message("\n-- Directional --")
message(sprintf("  ACP -> EU: %+.4f (SE %.4f) | EU -> ACP: %+.4f (SE %.4f)",
                b_acp, s_acp, b_eu, s_eu_))
message(sprintf("  Difference: %+.4f (conservative SE %.4f, t = %.2f) -- %s",
                diff_est, diff_se, diff_est / diff_se,
                if (abs(diff_est / diff_se) > 1.96)
                  "distinguishable" else "NOT distinguishable; make no asymmetry claim"))

message("\n-- EPA --")
message(sprintf("  Net EPA at mean IT Share: %+.4f (SE %.4f, t = %.2f)",
                coef(m3_centered)[["epa"]], se(m3_centered)[["epa"]],
                coef(m3_centered)[["epa"]] / se(m3_centered)[["epa"]]))

message("\n-- REC heterogeneity --")
if (!is.na(homog_test$stat))
  message(sprintf("  Homogeneity test: F = %.2f, p = %.4f", homog_test$stat, homog_test$p))
inter_coefs |>
  mutate(across(c(estimate, se), \(x) round(x, 3)),
         sig = stars(estimate, se)) |>
  select(rec, estimate, se, sig) |>
  print()

message("\n-- Sample-period decision --")
message(sprintf("  %d-2021 (headline): %+.4f (SE %.4f, n = %s)",
                SAMPLE_START, coef(m2)[["it_share"]], se(m2)[["it_share"]],
                format(nobs(m2), big.mark = ",")))
message(sprintf("  %d-2021 (alt):      %+.4f (SE %.4f, n = %s)",
                ALT_SAMPLE_START, coef(m_alt_start)[["it_share"]],
                se(m_alt_start)[["it_share"]], format(nobs(m_alt_start), big.mark = ",")))
message("  Adopting the alternative removes the bloc-specific NA rule from Section 4 ",
        "entirely, at the cost of the pre-Cotonou window.")

message("\n-- Table 2 evaluation points --")
message(sprintf("  Pooled mean IT Share %.4f | SD %.4f | IQR %.4f",
                it_mean_est, it_sd, it_iqr))

message("\n-- Still outstanding (not fixed here) --")
message("  * WDI cache ends 2020: every 2021 observation lacks GDP/pop, so the")
message("    GDP-control columns lose roughly 2,900 observations. Report the")
message("    restricted window in those table notes.")
message("  * MRT/TLS intra-REC pair asymmetry: FIX_TIMEVARYING_REC_PAIRS is FALSE")
message("    in script 01. Biases ECOWAS and PIF shares slightly downward, i.e.")
message("    against the finding, so current estimates are conservative.")
message("  * Side-matched decomposition: ln_intra_m / ln_intra_x are estimated")
message("    from import and export components respectively. Note that script 01")
message("    nets out every EU_ISO3 member in all years when building")
message("    non_eu_imports / non_eu_exports, while the panel retains GBR through")
message("    2020 -- a marginally wider EU definition than the reconstructed")
message("    ln_noneu. Immaterial, but state it if the import side matters.")
message("=======================================================\n")