# =============================================================================
# EU-ACP GRAVITY PANEL: DATA PIPELINE                          [SCRIPT 01 of 02]
# =============================================================================
# Constructs a bilateral trade panel: 78 ACP countries x EU-27+UK x 1995-2021.
#
# Noah Damski, University of Florida
# "Regional Integration as a Stumbling Block: Gravity Evidence from EU-ACP Trade"
#
# -----------------------------------------------------------------------------
# WHAT CHANGED IN THIS VERSION (2026-08-04) AND WHY
# -----------------------------------------------------------------------------
# (1) SHARE-BOUNDS CHECK NOW ENFORCED. `bad_share` (Section 6) was computed
#     but never inspected -- a silent no-op sitting where the comment above it
#     promises a guard against [0,1] violations. It now stops the script if
#     any row fails, which is the one check capable of catching double-
#     counting if FIX_TIMEVARYING_REC_PAIRS is ever switched on.
#
# (2) SECTION 13 COMMENT CORRECTED. It described a SACU donor-pool imputation
#     step in 02_estimate_gravity.R that no longer exists (deleted per that
#     script's own changelog item 6) and quoted a post-imputation SADC mean
#     (0.2713) that predates both the coverage-rule rewrite and the confirmed
#     current figure (0.324, from aux_summary_statistics.csv on the 2000-2021
#     run). The comment now describes what Section 13 actually computes.
#
# (3) FOUR NEW COUNTRY-YEAR / COUNTRY-LEVEL VARIABLES, added for the post-
#     conference robustness round (see session handoff 2026-08-04):
#       - china_trade / china_exports / china_imports (Section 6): mirrors
#         the non-EU trade construction, filtered to CHN, so script 02 can
#         build a china_share control the same way it builds s_eu. Tests
#         whether the "clean" non-EU denominator is itself contaminated by a
#         rising third-party partner.
#       - eu_partner_hhi (new Section 7.5): Herfindahl index of an ACP
#         country's EU-side trade across the 28 EU partners, built from
#         eu_acp_grid. No new data.
#       - eur_peg / other_currency_union (new Section 3.5): static country
#         flags for currency-union membership. NOTE: the handoff's proposed
#         single "euro- or rand-pegged" dummy pooled two different pegs into
#         one variable. CEMAC and WAEMU are EUR pegs (the theoretically
#         relevant mechanism: reduced exchange-rate risk with EU trade
#         specifically). The Common Monetary Area is a RAND peg and the ECCU
#         is a USD peg -- neither reduces exchange-rate risk with the EU, so
#         pooling them with CEMAC/WAEMU would muddy exactly the mechanism the
#         variable is meant to isolate. Split into eur_peg (CEMAC + WAEMU) and
#         other_currency_union (CMA + ECCU, retained for completeness, not
#         expected to bear on the EU-trade mechanism).
#       - gdp_pc_eu (Section 11): EU-partner GDP per capita, a Linder-type
#         control, derived from gdp_eu / pop_eu already in hand from WDI.
#
#     NOT implemented this round (see session handoff for full detail on why):
#       - HS-chapter export-concentration HHI (handoff items 2-3): requires
#         re-aggregating BACI at HS-chapter level, which Section 5 currently
#         collapses away, plus an EU MFN tariff schedule not sourced yet.
#       - 2022-2024 refresh (item 7): requires annual BACI files and a fresh
#         WDI pull not present in this environment.
#       - EPA staggered-DiD (item 8): a new package (`did`) and an estimator
#         redesign, not a control addition; belongs in 02 as its own
#         deliberate step, not folded into this pass.
# -----------------------------------------------------------------------------
#
# RUN WITH source(), NEVER BY PASTING INTO THE CONSOLE.
#   source(file.path(PROJ_ROOT, "SCRIPTS", "01_build_panel.R"), echo = TRUE)
# source() halts at the first error. Pasting continues past errors all the way
# to the final write, which is how a serialized function ended up in
# eu_acp_panel.rds on 2026-07-23. Section 14 blocks that specific failure three
# separate ways now, but source() remains the actual fix.
# -----------------------------------------------------------------------------
#
# Panel ends in 2021: CEPII Gravity V202211 covers through 2021; extending to
# 2022 would silently drop the entire 2022 cross-section from estimation. The
# endpoint is also institutionally justified (last year of Cotonou proper,
# before Samoa Agreement provisional effect in January 2024).
#
# Data sources:
#   BACI HS92 V202601        - trade flows, annual files 1995-2021
#   CEPII Gravity V202211    - distance, language, colonial tie, contiguity
#   World Bank WDI           - GDP, population (COK/NIU patched manually)
#
# All three are cached as .rds under DATA/cache/. With the caches present this
# script runs end to end with no raw source files on disk. Caches are stamped
# with provenance attributes (Section 1) so a cache built from a different BACI
# vintage cannot silently pass as the current one.
#
# EU partner set:
#   EU-27 (static composition) + GBR (1995-2020 only; excluded post-transition).
#   Pre-accession flows for enlargement cohorts included throughout; level
#   shifts absorbed by the EU-partner x year fixed effects in estimation.
#   Naming: the EU-side effect is built from eu_iso3 x year and stored in the
#   column exporter_year for historical reasons. The EU country is the exporter
#   in the EU_to_ACP models and the importer in the ACP_to_EU models, so output
#   tables label it "EU-partner x year".
#
# EPA treatment:
#   Provisional-application dates verified against EUR-Lex primary sources.
#   epa = 0 for countries that signed but never applied, or never signed:
#     EAC (BDI/KEN/RWA/TZA/UGA) - EU-EAC EPA never provisionally applied
#     HTI                        - signed Dec 2009, never applied
#     MWI, ZMB                   - never signed the ESA EPA
#     WSM                        - applied 31 Dec 2018, excluded (near-zero EU trade)
#     SLB                        - applied 17 May 2020, excluded (near-zero EU trade)
#     TLS                        - indicated intent to accede; not applied in sample
#     DJI, ERI, ETH, SDN, AGO, COD - never signed
#
# REC membership:
#   MRT - ECOWAS 1995-2000; unaffiliated 2001 onward (2017 associate != member)
#   TLS - rec = NA pre-Cotonou accession (1995-2002); PIF from 2003
#   SSD - excluded; severe data gaps throughout civil conflict (2013-2018);
#          joined EAC March 2016 but bilateral trade coverage is insufficient
#
# Integration measures (constructed in Section 6):
#   it_share      - intra-REC trade / total merchandise trade (exports + imports)
#   it_share_exeu - intra-REC trade / total non-EU trade; severs the mechanical
#                   link between the IT share denominator and the dependent
#                   variable, addressing the primary endogeneity concern
#   it_intensity  - it_share scaled by the REC's share of world trade
#
# Missing covariates:
#   SOM/ERI GDP gaps: rows retained with gdp_acp = NA.
#   PPML handles these via conditioning on trade flows; OLS drops them.
#   SADC/SACU IT Share gaps: imputed in 02_estimate_gravity.R.
# =============================================================================

set.seed(42)

library(tidyverse)
library(WDI)


# =============================================================================
# 0. CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# 0.1 Paths - single root, everything else derived.
#     Project tree:
#       EU_ACP_Trade_Paper/
#       |- SCRIPTS/    01_build_panel.R, 02_estimate_gravity.R
#       |- DATA/       eu_acp_panel.rds/.csv
#       |   |- raw/    BACI_HS92_V202601/, Gravity_rds_V202211/
#       |   +- cache/  baci_raw_cache.rds, wdi_gdp_pop_cache.rds,
#       |              gravity_structural_cache.rds
#       |- OUTPUT/
#       |   |- figures/
#       |   +- tables/
#       |- PAPER/      Word drafts - NOT touched by these scripts
#       +- RESEARCH/   Obsidian notes - NOT touched by these scripts
# -----------------------------------------------------------------------------
PROJ_ROOT <- "C:/Users/ndams/Documents/EU_ACP_Trade_Paper"

if (!dir.exists(PROJ_ROOT))
  stop("PROJ_ROOT does not exist: ", PROJ_ROOT, "\n",
       "  Fix the path before running. Left unchecked, dir.create() below ",
       "would happily scaffold an entire project tree in the wrong place.")

DIR_SCRIPTS <- file.path(PROJ_ROOT, "SCRIPTS")
DIR_DATA    <- file.path(PROJ_ROOT, "DATA")
DIR_RAW     <- file.path(DIR_DATA,  "raw")
DIR_CACHE   <- file.path(DIR_DATA,  "cache")
DIR_OUT     <- file.path(PROJ_ROOT, "OUTPUT")
DIR_FIG     <- file.path(DIR_OUT,   "figures")
DIR_TAB     <- file.path(DIR_OUT,   "tables")

# PAPER/ and RESEARCH/ are deliberately absent from this list. Nothing in the
# pipeline writes to them.
for (d in c(DIR_SCRIPTS, DIR_DATA, DIR_RAW, DIR_CACHE, DIR_OUT, DIR_FIG, DIR_TAB))
  dir.create(d, recursive = TRUE, showWarnings = FALSE)

# -----------------------------------------------------------------------------
# 0.2 Source vintages - used in filenames AND recorded on the caches.
#     If you download a new BACI release, change BACI_VERSION here. The cache
#     provenance check in Section 5 will then refuse the old cache rather than
#     mixing vintages, which is the one silent failure mode that would change
#     every coefficient in the paper without throwing an error.
# -----------------------------------------------------------------------------
BACI_VERSION    <- "V202601"
GRAVITY_VERSION <- "V202211"

YEARS <- 1995:2021

BACI_DIR     <- file.path(DIR_RAW, paste0("BACI_HS92_", BACI_VERSION))
BACI_CODES   <- file.path(BACI_DIR, paste0("country_codes_", BACI_VERSION, ".csv"))
GRAVITY_FILE <- file.path(DIR_RAW, paste0("Gravity_rds_", GRAVITY_VERSION),
                          paste0("Gravity_", GRAVITY_VERSION, ".rds"))

CACHE_BACI    <- file.path(DIR_CACHE, "baci_raw_cache.rds")
CACHE_WDI     <- file.path(DIR_CACHE, "wdi_gdp_pop_cache.rds")
CACHE_GRAVITY <- file.path(DIR_CACHE, "gravity_structural_cache.rds")

PANEL_RDS <- file.path(DIR_DATA, "eu_acp_panel.rds")
PANEL_CSV <- file.path(DIR_DATA, "eu_acp_panel.csv")

# Written to OUTPUT/tables/ by this script. Prefixed "aux_" because it is a
# supporting descriptive table, not one of the numbered tables in the paper.
OUT_REC_SUMMARY <- file.path(DIR_TAB, "aux_rec_it_share_summary.csv")

# -----------------------------------------------------------------------------
# 0.3 Behaviour flags
# -----------------------------------------------------------------------------

# Refuse to clobber an existing panel. The current panel is the only source of
# the paper's numbers; a rebuild must go to a new filename and be diffed against
# it (Section 15) before adoption. Set TRUE only after that diff passes.
OVERWRITE_PANEL <- FALSE

# MRT/TLS intra-REC pair asymmetry.
#
#   FALSE (default, LEGACY): reproduces the panel the paper's numbers come from.
#     Mauritania's trade with ECOWAS partners counts toward ITS intra-REC total,
#     but the other members' trade WITH Mauritania (1995-2000) never enters
#     THEIR numerators, because rec_pairs_static does not contain MRT. Same
#     structure for TLS/PIF from 2003. This biases intra-REC shares slightly
#     downward for ECOWAS and PIF -- i.e. AGAINST the stumbling-block finding,
#     so legacy estimates are conservative with respect to this bug.
#
#   TRUE (CORRECTED): credits both sides of every time-varying pair. Effect is
#     small but nonzero; it will move ECOWAS and PIF coefficients. Do not enable
#     before the conference. When you do, rebuild to a new filename and report
#     the delta rather than silently substituting.
#
# Contrary to the earlier handoff note, this fix does NOT require the raw BACI
# CSVs. Section 6 consumes `baci`, which loads from CACHE_BACI; the annual CSVs
# are only read when that cache is being built.
FIX_TIMEVARYING_REC_PAIRS <- FALSE

# -----------------------------------------------------------------------------
# 0.4 Paste guard
#     Each stage reports in on completion. Section 14 refuses to write the panel
#     unless every stage did. If the script is pasted and an early stage errors,
#     the write is blocked instead of serializing whatever `acp_panel` resolves
#     to at that moment.
# -----------------------------------------------------------------------------
.STAGES_DONE <- character(0)
stage <- function(name) {
  .STAGES_DONE <<- union(.STAGES_DONE, name)
  message(sprintf("  [stage complete] %s", name))
}
STAGES_REQUIRED <- c("membership", "currency_union", "epa_dates", "baci",
                     "it_share", "bilateral", "eu_partner_hhi", "export_hhi",
                     "gravity", "wdi", "epa_panel", "panel", "validation")

if ("package:fixest" %in% search())
  warning("fixest is attached in this session. It exports a function named ",
          "panel(). This script uses `acp_panel` throughout to avoid the ",
          "collision, but a fresh R session is still safer.", call. = FALSE)

message("Project root:  ", PROJ_ROOT)
message("BACI vintage:  ", BACI_VERSION, " | Gravity vintage: ", GRAVITY_VERSION)
message("Years:         ", min(YEARS), "-", max(YEARS))
message("MRT/TLS fix:   ", if (FIX_TIMEVARYING_REC_PAIRS) "ON (CORRECTED)" else "OFF (legacy)")


# =============================================================================
# 1. CACHE PROVENANCE HELPERS
# =============================================================================
# Every cache carries the vintage, year range, and build timestamp it was made
# under. read_cache() refuses a cache whose stamp disagrees with the current
# configuration, so a stale or foreign cache fails loudly instead of quietly
# producing a panel that looks fine and is wrong.

write_cache <- function(obj, path, ...) {
  attr(obj, "provenance") <- list(
    built   = Sys.time(),
    baci    = BACI_VERSION,
    gravity = GRAVITY_VERSION,
    years   = range(YEARS),
    ...
  )
  saveRDS(obj, path)
  message("  Cached: ", path)
  invisible(obj)
}

read_cache <- function(path, expect = list()) {
  obj  <- readRDS(path)
  prov <- attr(obj, "provenance")
  if (is.null(prov)) {
    message("  NOTE: ", basename(path), " predates provenance stamping. ",
            "Assuming it matches the current configuration. Re-cache when ",
            "convenient to clear this notice.")
    return(obj)
  }
  for (k in names(expect)) {
    if (!identical(prov[[k]], expect[[k]]))
      stop("Cache vintage mismatch in ", basename(path), ".\n",
           "  Field '", k, "': cache has ",
           paste(format(prov[[k]]), collapse = "-"),
           ", script expects ", paste(format(expect[[k]]), collapse = "-"), ".\n",
           "  Delete the cache and rebuild from source, or revert the script ",
           "configuration. Do NOT proceed -- mixing vintages changes every ",
           "coefficient without raising an error.")
  }
  message("  Loaded cache: ", basename(path),
          " (built ", format(prov$built, "%Y-%m-%d"), ")")
  obj
}


# =============================================================================
# 2. EU MEMBERSHIP
# =============================================================================
EU_ISO3 <- c(
  "AUT","BEL","BGR","HRV","CYP","CZE","DNK","EST","FIN","FRA","DEU","GRC",
  "HUN","IRL","ITA","LVA","LTU","LUX","MLT","NLD","POL","PRT","ROU","SVK",
  "SVN","ESP","SWE","GBR"
)

EU_ENLARGEMENT <- tribble(
  ~eu_iso3, ~eu_entry_year,
  "CYP", 2004L, "CZE", 2004L, "EST", 2004L, "HUN", 2004L,
  "LVA", 2004L, "LTU", 2004L, "MLT", 2004L, "POL", 2004L,
  "SVK", 2004L, "SVN", 2004L, "BGR", 2007L, "ROU", 2007L,
  "HRV", 2013L
)

# GBR active through 2020 (Brexit transition end); 2021 excluded
EU_EXIT <- tribble(
  ~eu_iso3, ~eu_exit_year,
  "GBR", 2020L
)


# =============================================================================
# 3. REC MEMBERSHIP - 78 Cotonou ACP countries
# =============================================================================
REC_MEMBERSHIP_STATIC <- tribble(
  ~iso3, ~rec,
  
  # ECOWAS - 15 permanent members (MRT time-varying; see below)
  "BEN","ECOWAS", "BFA","ECOWAS", "CPV","ECOWAS", "CIV","ECOWAS",
  "GHA","ECOWAS", "GIN","ECOWAS", "GNB","ECOWAS", "LBR","ECOWAS",
  "MLI","ECOWAS", "NER","ECOWAS", "NGA","ECOWAS", "SEN","ECOWAS",
  "SLE","ECOWAS", "GMB","ECOWAS", "TGO","ECOWAS",
  
  # Central Africa EPA group - CEMAC-6 plus STP (all ECCAS members;
  # STP is not part of CEMAC monetary union but participates in the EPA group)
  "CMR","Central Africa", "CAF","Central Africa", "TCD","Central Africa",
  "COG","Central Africa", "GAB","Central Africa", "GNQ","Central Africa",
  "STP","Central Africa",
  
  # SADC - 7 static members in this panel: the six EPA signatories plus AGO,
  # a SADC member that never signed (epa = 0). COD is time-varying -- see
  # COD_REC below -- and is NOT listed here.
  "AGO","SADC", "BWA","SADC", "SWZ","SADC",
  "LSO","SADC", "MOZ","SADC", "NAM","SADC", "ZAF","SADC",
  
  # EAC - EU-EAC EPA signed Sep 2016 but never provisionally applied; epa = 0.
  # KEN/UGA/TZA removed 2026-08 and made time-varying (see KEN_UGA_REC and
  # TZA_REC below) -- they did not negotiate as a unified EAC bloc until
  # 2007. Before that, Kenya and Uganda negotiated under the ESA
  # configuration and Tanzania under SADC (WTO Trade Policy Review of the
  # EAC, pre-2007; corroborated by academic EAC-EPA history). Coding them as
  # static EAC for the full panel misattributed their pre-2007 REC.
  # BDI/RWA time-varying, see BDI_RWA_REC below (acceded 2007).
  
  # ESA EPA group - 11 countries in the ESA EPA negotiating track (12 before
  # SOM's removal, see above).
  # EAC members (KEN/UGA/RWA/TZA/BDI) are also COMESA members but assigned to
  # EAC above (or, for RWA/BDI, in BDI_RWA_REC below) following their EPA
  # negotiating track. "ESA" is the correct label throughout; COMESA is the
  # institution, not the EPA negotiating group. If "COMESA" ever reappears in
  # REC_LEVELS, script 02's factor() call silently turns every ESA row into NA.
  # SOM removed 2026-08 -- confirmed absent from the ESA EPA negotiating
  # group in every primary/institutional source checked (EU trade policy
  # page, tralac, ECDPM, EUR-Lex glossary). Somalia never signed or ratified
  # Cotonou or its revisions (no functioning government to do so since the
  # early 1990s); its ACP relationship has been maintained through ad hoc
  # EDF arrangements rather than treaty accession (Oxford Public
  # International Law, Lome/Cotonou reference). See SOM_REC below.
  "COM","ESA", "DJI","ESA", "ERI","ESA", "ETH","ESA",
  "MDG","ESA", "MWI","ESA", "MUS","ESA",
  "SYC","ESA", "SDN","ESA", "ZMB","ESA", "ZWE","ESA",
  
  # CARIFORUM - HTI signed Dec 2009 but never applied; epa = 0
  "ATG","CARIFORUM", "BHS","CARIFORUM", "BRB","CARIFORUM", "BLZ","CARIFORUM",
  "DMA","CARIFORUM", "DOM","CARIFORUM", "GRD","CARIFORUM", "GUY","CARIFORUM",
  "HTI","CARIFORUM", "JAM","CARIFORUM", "KNA","CARIFORUM", "LCA","CARIFORUM",
  "SUR","CARIFORUM", "TTO","CARIFORUM", "VCT","CARIFORUM",
  
  # PIF - 14 static Pacific ACP states (TLS time-varying; see below)
  # WSM (applied 31 Dec 2018) and SLB (applied 17 May 2020) retain epa = 0
  # due to near-zero bilateral EU trade volumes throughout the sample.
  # TLS indicated intent to accede to the EU-Pacific EPA but did not do so
  # within the sample period; epa = 0 throughout.
  "COK","PIF", "FJI","PIF", "KIR","PIF", "MHL","PIF", "FSM","PIF",
  "NRU","PIF", "NIU","PIF", "PLW","PIF", "PNG","PIF", "WSM","PIF",
  "SLB","PIF", "TON","PIF", "TUV","PIF", "VUT","PIF"
)

# BDI/RWA acceded to the EAC in 2007 (formally 18 June 2007, effective 1 July
# 2007); the customs union CET applied from 1 July 2009. 2007 used as the
# cutoff -- accession, not CET implementation, is the more defensible "this
# country IS a member" boundary; CET phase-in is a treatment-intensity
# question, not a membership one, and using 2009 would understate REC
# membership for two full years. Document this choice if the paper reports
# it. Before accession: NA (not listed under any other REC in this table --
# they were not, in fact, affiliated with a different bloc's EPA negotiating
# track during this window, so NA rather than a fabricated affiliation).
BDI_RWA_REC <- bind_rows(
  tibble(iso3 = c("BDI","RWA"), year = list(1995:2006)) |> unnest(year) |>
    mutate(rec = NA_character_),
  tibble(iso3 = c("BDI","RWA"), year = list(2007:max(YEARS))) |> unnest(year) |>
    mutate(rec = "EAC")
)

# COD (DRC) -- REVISED 2026-08 (second pass). Original EPA-track-only
# version blanked 1998-2002 to NA, discarding COD's unambiguous
# institutional SADC membership (acceded 8 Sept 1998, 17th SADC Summit;
# SADC's own member-state page) during years when it had no competing
# affiliation to create a tiebreak problem. Unlike the EAC-vs-ESA/SADC
# ambiguity that motivates EPA-track logic elsewhere in this table, COD had
# exactly one clear regional home 1998-2002, so there is no reason to
# discard it. Restored: NA 1995-1997 (not yet a SADC member at all), SADC
# 1998-2002 (institutional, unambiguous), then EPA-track logic takes over
# once a negotiating configuration exists: ESA 2003-2004, Central Africa
# 2005-max(YEARS) (switch documented in ECDPM regional EPA brief;
# corroborated by EEAS's current framing of DRC as part of "the Central
# Africa configuration (CEMAC + DRC + Sao Tome)").
#
# CONFIRMED 2026-08-11: the two-year ESA window (2003-2004) is kept as its
# own regime rather than collapsed into the surrounding SADC period.
# Reasoning: (1) consistency -- every other ambiguous multi-year transition
# in this table (KEN/UGA's 2003-2006 negotiating window, TZA's SADC->EAC
# switch, TLS's accession) is handled the same way, as a short,
# independently-sourced transitional category rather than folded into
# whichever neighboring bloc is administratively convenient; treating COD
# as the one exception would be inconsistent with no offsetting benefit.
# (2) negligible empirical footprint either way -- COD's 2003-2004 ESA
# window contributes 2 of ESA's 252 total country-years (< 1%,
# aux_summary_statistics.csv), so this choice does not materially affect
# ESA's aggregate statistics or the REC-interaction coefficient regardless
# of which way it's coded. Table 0's ESA=14 count and footnote assume this
# choice; if it is ever revisited, the defensible simplification remains
# SADC 1998-2004, "Central Africa" 2005-max(YEARS) -- comment out the ESA
# line below and extend the SADC range to do this.
COD_REC <- bind_rows(
  tibble(iso3 = "COD", year = 1995:1997,       rec = NA_character_),
  tibble(iso3 = "COD", year = 1998:2002,       rec = "SADC"),
  tibble(iso3 = "COD", year = 2003:2004,       rec = "ESA"),
  tibble(iso3 = "COD", year = 2005:max(YEARS), rec = "Central Africa")
)

# SOM (Somalia) -- unchanged from first pass. Never part of the ESA EPA
# negotiating group (confirmed against EU trade policy page, tralac,
# ECDPM, EUR-Lex glossary) and never signed/ratified Cotonou or its
# revisions. Unlike COD/TZA below, Somalia has no unambiguous single-bloc
# institutional fallback to restore -- state collapse in the early 1990s is
# precisely why it is a special case at all. Coded NA throughout rather
# than dropped from ACP_ISO3: Somalia has maintained a de facto ACP
# relationship via ad hoc EDF arrangements despite the absence of formal
# treaty accession (Oxford Public International Law reference on the
# Lome/Cotonou Conventions). If this framing changes, dropping SOM from
# ACP_ISO3 entirely is the alternative -- flag with Noah before doing so,
# since it changes the 78-country universe referenced throughout Section 3.
SOM_REC <- tibble(iso3 = "SOM", year = 1995:max(YEARS), rec = NA_character_)

# KEN/UGA -- unchanged from first pass. Unlike COD and TZA, there is no
# defensible single-REC institutional fallback for 1995-2002: EAC only
# re-entered force July 2000 as a bare treaty (customs union not until
# 2005, common market 2010) and COMESA is deliberately excluded as a REC
# label elsewhere in this script (see the ESA-block comment above --
# "COMESA" as a label silently turns rows to NA via factor() in script 02).
# ESA-track from formal EPA-negotiation launch (Sept 2002 start; ESA
# configuration established March 2003) through 2006; EAC-track from 2007
# (WTO Trade Policy Review of the pre-2007 EAC region: "Kenya and Uganda
# are participating in the EPA negotiations as members of the Eastern and
# Southern Africa (ESA) region while Tanzania is participating under
# SADC").
KEN_UGA_REC <- bind_rows(
  tibble(iso3 = c("KEN","UGA"), year = list(1995:2002)) |> unnest(year) |>
    mutate(rec = NA_character_),
  tibble(iso3 = c("KEN","UGA"), year = list(2003:2006)) |> unnest(year) |>
    mutate(rec = "ESA"),
  tibble(iso3 = c("KEN","UGA"), year = list(2007:max(YEARS))) |> unnest(year) |>
    mutate(rec = "EAC")
)

# TZA -- REVISED 2026-08 (second pass). Original version blanked 1995-2002
# to NA and used SADC only from 2003. This discarded a real fact: Tanzania
# has been a continuous SADC member since SADC's 1992 founding (SADCC
# predecessor from 1980) -- well before this panel's 1995 start -- and
# there is no competing single-bloc claim to create a tiebreak problem for
# this period the way there is for KEN/UGA. Corroborating detail: Tanzania
# withdrew from COMESA in 2000 specifically BECAUSE it already held both
# SADC and EAC memberships simultaneously and judged a third redundant
# (Tanzanian parliamentary record, allAfrica.com; Daily News Tanzania) --
# direct evidence its SADC affiliation was live and uncontested throughout.
# This also matches the documented EPA-negotiating track directly: "Tanzania
# negotiated an EPA together with the SADC-minus EPA group" before joining
# EAC-EPA in 2007 (academic EAC-EPA history) -- so SADC throughout
# 1995-2006 is correct on BOTH the institutional and EPA-track reading, no
# conflict to resolve. EAC-track from 2007.
TZA_REC <- bind_rows(
  tibble(iso3 = "TZA", year = 1995:2006,       rec = "SADC"),
  tibble(iso3 = "TZA", year = 2007:max(YEARS), rec = "EAC")
)

# MRT withdrew from ECOWAS December 2000; 2017 associate agreement != full member
MRT_REC <- bind_rows(
  tibble(iso3 = "MRT", year = 1995:2000,       rec = "ECOWAS"),
  tibble(iso3 = "MRT", year = 2001:max(YEARS), rec = NA_character_)
)

# TLS gained independence May 2002; Cotonou accession 2003; PIF from 2003.
# Confirmed directly against EUR-Lex: ACP-EC Council of Ministers Decision
# No 1/2003, done in Brussels 16 May 2003, approving TLS's accession to the
# Cotonou Agreement. 2002 is not a defensible alternative -- resolves the
# earlier open question about which of two script versions built prior
# panels.
TLS_REC <- bind_rows(
  tibble(iso3 = "TLS", year = 1995:2002,       rec = NA_character_),
  tibble(iso3 = "TLS", year = 2003:max(YEARS), rec = "PIF")
)

# SOM, KEN, TZA, UGA added explicitly -- no longer captured via
# REC_MEMBERSHIP_STATIC$iso3 now that they're time-varying (see above).
ACP_ISO3   <- c(unique(REC_MEMBERSHIP_STATIC$iso3), "MRT", "TLS", "BDI", "RWA", "COD",
                "SOM", "KEN", "TZA", "UGA")
REC_LEVELS <- c("ECOWAS","Central Africa","SADC","EAC","ESA","CARIFORUM","PIF")

stopifnot(length(ACP_ISO3) == 78, !anyDuplicated(ACP_ISO3))
# NOTE: the 78-country count includes Somalia, whose ACP relationship was
# never formalized through Cotonou signature/ratification -- see SOM_REC
# above. "78 Cotonou signatories" is therefore not a fully accurate
# description of this universe; message below reflects that.
message("ACP universe: 78 countries (Somalia's inclusion reflects a de facto ",
        "EDF relationship, not Cotonou signature -- see SOM_REC comment).")

REC_LOOKUP <- REC_MEMBERSHIP_STATIC |>
  mutate(year = list(YEARS)) |>
  unnest(year) |>
  bind_rows(MRT_REC     |> filter(year %in% YEARS)) |>
  bind_rows(TLS_REC     |> filter(year %in% YEARS)) |>
  bind_rows(BDI_RWA_REC |> filter(year %in% YEARS)) |>
  bind_rows(COD_REC     |> filter(year %in% YEARS)) |>
  bind_rows(SOM_REC     |> filter(year %in% YEARS)) |>
  bind_rows(KEN_UGA_REC |> filter(year %in% YEARS)) |>
  bind_rows(TZA_REC     |> filter(year %in% YEARS))

stopifnot(!anyDuplicated(REC_LOOKUP[, c("iso3", "year")]))
# REC_LEVELS check moved here (was against REC_MEMBERSHIP_STATIC alone,
# which no longer contains "EAC" now that its members are time-varying).
stopifnot(setequal(unique(na.omit(REC_LOOKUP$rec)), REC_LEVELS))
stage("membership")


# =============================================================================
# 3.5 CURRENCY UNION MEMBERSHIP (added 2026-08, post-conference; expanded
#     2026-08-05 to cover Comoros and Pacific dollarization, and to grant each
#     union its own dummy instead of pooling into eur_peg/other_currency_union)
# =============================================================================
# Static country flags -- all unions below predate 1995 for every member
# listed, so this is a country-level flag, not a country-year variable,
# matching the treatment of EPA_DATES and REC_MEMBERSHIP_STATIC elsewhere in
# this script.
#
# Motivation (session handoff item 6): a euro peg is a direct, mechanical
# reduction in exchange-rate risk with EU trade specifically, independent of
# intra-REC integration, and was flagged as the strongest single candidate
# for explaining rather than merely flagging the Central Africa outlier in
# the REC heterogeneity results. Testing that meant not stopping at CEMAC:
#
#   - CEMAC and WAEMU: the CFA franc, pegged to the EUR. WAEMU sits almost
#     entirely inside ECOWAS, CEMAC almost entirely inside Central Africa, so
#     a single pooled eur_peg dummy could not separate "the peg matters" from
#     "Central Africa/ECOWAS membership matters." Given their own dummy each.
#   - Comoros: the Comorian franc, ALSO pegged to the EUR (guaranteed by
#     France, the same mechanism as the CFA francs), and previously missing
#     entirely from this table -- an oversight, not a deliberate exclusion.
#     Comoros sits in "ESA" here (see Section 3), so peg_comoros is the only
#     EUR peg with a shot at explaining anything in ESA rather than Central
#     Africa or ECOWAS.
#   - The Common Monetary Area (CMA): pegged to the ZAR, not the EUR. An
#     intra-regional (SADC) mechanism, not an EU one.
#   - The ECCU: the Eastern Caribbean dollar, pegged to the USD, not the EUR.
#     An intra-CARIFORUM mechanism, not an EU one.
#   - Pacific dollarization: Cook Islands and Niue use the NZD as their
#     actual currency (full adoption, not merely a peg); Kiribati and Tuvalu
#     use the AUD the same way. Also previously missing. Neither currency is
#     the EUR, so this is "other," like CMA/ECCU, not "eur_peg" -- but it is
#     the only currency-union variation available inside PIF.
#
# Each union gets its own dummy so its marginal effect is estimable on its
# own rather than pooled with unions that operate through a different
# currency and a different partner. eur_peg / other_currency_union are still
# built below as convenience sums of the granular flags, for anywhere a
# pooled EUR-vs-not distinction is still useful, but Section 11.5 in script
# 02 now tests the granular dummies against their own REC's deviation term
# directly rather than testing the pooled sums.
CEMAC_ISO3   <- c("CMR","CAF","TCD","COG","GAB","GNQ")   # STP is NOT in CEMAC
WAEMU_ISO3   <- c("BEN","BFA","CIV","GNB","MLI","NER","SEN","TGO")
COMOROS_ISO3 <- c("COM")                                  # Comorian franc, EUR peg
CMA_ISO3     <- c("LSO","NAM","SWZ")                      # rand peg, not ZAF itself
ECCU_ISO3    <- c("ATG","DMA","GRD","KNA","LCA","VCT")    # East Caribbean dollar, USD peg
PACIFIC_DOLLAR_ISO3 <- c("COK","NIU","KIR","TUV")         # NZD (COK/NIU) or AUD (KIR/TUV)

EUR_PEG_ISO3   <- c(CEMAC_ISO3, WAEMU_ISO3, COMOROS_ISO3)
OTHER_PEG_ISO3 <- c(CMA_ISO3, ECCU_ISO3, PACIFIC_DOLLAR_ISO3)

stopifnot(all(c(EUR_PEG_ISO3, OTHER_PEG_ISO3) %in% ACP_ISO3))
stopifnot(!anyDuplicated(c(EUR_PEG_ISO3, OTHER_PEG_ISO3)))

CURRENCY_UNION_LOOKUP <- tibble(iso3 = ACP_ISO3) |>
  mutate(
    peg_cemac    = as.integer(iso3 %in% CEMAC_ISO3),
    peg_waemu    = as.integer(iso3 %in% WAEMU_ISO3),
    peg_comoros  = as.integer(iso3 %in% COMOROS_ISO3),
    peg_cma      = as.integer(iso3 %in% CMA_ISO3),
    peg_eccu     = as.integer(iso3 %in% ECCU_ISO3),
    peg_pacific  = as.integer(iso3 %in% PACIFIC_DOLLAR_ISO3),
    eur_peg              = as.integer(iso3 %in% EUR_PEG_ISO3),
    other_currency_union = as.integer(iso3 %in% OTHER_PEG_ISO3)
  )

message(sprintf(
  "Currency union flags: CEMAC %d, WAEMU %d, Comoros %d, CMA %d, ECCU %d, Pacific-dollar %d (%d EUR-peg total, %d other total).",
  sum(CURRENCY_UNION_LOOKUP$peg_cemac),   sum(CURRENCY_UNION_LOOKUP$peg_waemu),
  sum(CURRENCY_UNION_LOOKUP$peg_comoros), sum(CURRENCY_UNION_LOOKUP$peg_cma),
  sum(CURRENCY_UNION_LOOKUP$peg_eccu),    sum(CURRENCY_UNION_LOOKUP$peg_pacific),
  sum(CURRENCY_UNION_LOOKUP$eur_peg),     sum(CURRENCY_UNION_LOOKUP$other_currency_union)
))
stage("currency_union")


# =============================================================================
# 4. EPA DATES - provisional-application dates verified against EUR-Lex
# =============================================================================
EPA_DATES <- tribble(
  ~iso3, ~epa_date,
  
  "CMR", as.Date("2014-08-04"),
  
  "CIV", as.Date("2016-09-03"),
  "GHA", as.Date("2016-12-15"),
  
  "MDG", as.Date("2012-05-14"),
  "MUS", as.Date("2012-05-14"),
  "SYC", as.Date("2012-05-14"),
  "ZWE", as.Date("2012-05-14"),
  "COM", as.Date("2019-02-07"),
  
  "BWA", as.Date("2016-10-10"),
  "LSO", as.Date("2016-10-10"),
  "NAM", as.Date("2016-10-10"),
  "SWZ", as.Date("2016-10-10"),
  "ZAF", as.Date("2016-10-10"),
  "MOZ", as.Date("2018-02-04"),
  
  "ATG", as.Date("2008-12-29"), "BHS", as.Date("2008-12-29"),
  "BRB", as.Date("2008-12-29"), "BLZ", as.Date("2008-12-29"),
  "DMA", as.Date("2008-12-29"), "DOM", as.Date("2008-12-29"),
  "GRD", as.Date("2008-12-29"), "GUY", as.Date("2008-12-29"),
  "JAM", as.Date("2008-12-29"), "KNA", as.Date("2008-12-29"),
  "LCA", as.Date("2008-12-29"), "VCT", as.Date("2008-12-29"),
  "SUR", as.Date("2008-12-29"), "TTO", as.Date("2008-12-29"),
  
  "PNG", as.Date("2009-12-20"),
  "FJI", as.Date("2014-07-28")
)

stopifnot(all(EPA_DATES$iso3 %in% ACP_ISO3))
stopifnot(!anyDuplicated(EPA_DATES$iso3))
stopifnot(all(as.integer(format(EPA_DATES$epa_date, "%Y")) %in% YEARS))
message("EPA date checks passed (", nrow(EPA_DATES), " signatories).")
stage("epa_dates")


# =============================================================================
# 5. BACI TRADE FLOWS
# =============================================================================
if (file.exists(CACHE_BACI)) {
  baci <- read_cache(CACHE_BACI, expect = list(baci  = BACI_VERSION,
                                               years = range(YEARS)))
} else {
  if (!dir.exists(BACI_DIR))
    stop("BACI cache absent and source directory missing.\n",
         "  Expected annual CSVs in: ", BACI_DIR, "\n",
         "  Expected cache:          ", CACHE_BACI)
  
  # Confirm the files on disk are the vintage this script is configured for.
  found <- list.files(BACI_DIR, pattern = "^BACI_HS92_Y\\d{4}_V\\d+\\.csv$")
  if (!length(found))
    stop("No BACI annual files matching BACI_HS92_Y####_V*.csv in ", BACI_DIR)
  found_versions <- unique(sub("^.*_(V\\d+)\\.csv$", "\\1", found))
  if (!identical(found_versions, BACI_VERSION))
    stop("BACI vintage mismatch. Files on disk: ",
         paste(found_versions, collapse = ", "),
         "; script configured for ", BACI_VERSION, ".\n",
         "  Rebuilding against a different vintage restates historical trade ",
         "values and changes every coefficient in the paper. Set BACI_VERSION ",
         "deliberately, rebuild to a new panel filename, and diff.")
  
  extra <- setdiff(as.integer(sub("^BACI_HS92_Y(\\d{4}).*$", "\\1", found)), YEARS)
  if (length(extra))
    message("  NOTE: ", length(extra), " annual file(s) outside YEARS present ",
            "and ignored (", paste(range(extra), collapse = "-"), ").")
  
  if (!file.exists(BACI_CODES))
    stop("BACI country code file missing: ", BACI_CODES)
  
  baci_cc <- read_csv(BACI_CODES, col_types = cols(.default = "c")) |>
    select(numeric_code = country_code, iso3 = country_iso3)
  
  message("Loading BACI (", min(YEARS), "-", max(YEARS), ") from annual files...")
  baci_raw <- map_dfr(YEARS, function(yr) {
    f <- file.path(BACI_DIR, paste0("BACI_HS92_Y", yr, "_", BACI_VERSION, ".csv"))
    if (!file.exists(f)) stop("Missing required annual file: ", f)
    read_csv(f, col_types = cols(t = "i", i = "c", j = "c",
                                 k = "c", v = "d", q = "d")) |>
      select(t, i, j, v) |>
      group_by(t, i, j) |>
      summarise(v = sum(v, na.rm = TRUE), .groups = "drop")
  })
  
  baci <- baci_raw |>
    left_join(baci_cc, by = c("i" = "numeric_code")) |> rename(iso3_exp = iso3) |>
    left_join(baci_cc, by = c("j" = "numeric_code")) |> rename(iso3_imp = iso3) |>
    filter(!is.na(iso3_exp), !is.na(iso3_imp)) |>
    rename(year = t, trade_value = v) |>
    select(year, iso3_exp, iso3_imp, trade_value)
  
  write_cache(baci, CACHE_BACI, n_rows = nrow(baci))
}

stopifnot(all(c("year","iso3_exp","iso3_imp","trade_value") %in% names(baci)))
if (!all(YEARS %in% unique(baci$year)))
  stop("BACI covers ", paste(range(baci$year), collapse = "-"),
       " but YEARS requires ", paste(range(YEARS), collapse = "-"), ".")

message("BACI: ", format(nrow(baci), big.mark = ","), " country-pair-year obs")
stage("baci")


# =============================================================================
# 5.5 EXPORT CONCENTRATION (HS-CHAPTER HHI) -- handoff item 2, added 2026-08-05
# =============================================================================
# A Herfindahl index over each ACP country's exports by HS chapter (the first
# two digits of the HS6 product code), by year. Tests whether bloc
# heterogeneity (notably the Central Africa outlier in Table 4, and the
# inconclusive currency-peg result in Section 11.5) is a commodity-
# concentration story rather than, or in addition to, a REC-identity story: a
# one-good exporter has less flexibility to reallocate trade toward or away
# from any partner than a diversified one.
#
# THIS IS A SEPARATE READ OF THE RAW ANNUAL FILES, NOT A REUSE OF `baci`
# ABOVE. Section 5's aggregation drops the product code (`k`) before caching,
# so if CACHE_BACI already exists on disk, `baci_raw` (which briefly held `k`)
# was never even created in this run -- there is nothing to salvage product
# detail from. This block re-reads the same annual CSVs independently, with
# its own cache and its own provenance stamp, so a stale HHI cache can be
# detected separately from a stale main BACI cache.
#
# Cost warning: this reads full product-level detail (~200 countries x every
# HS6 code x year) rather than the already-collapsed country-pair totals, so
# it is the slowest single step in this script if the cache does not exist
# yet. Expect minutes, not seconds, on a first run.
CACHE_HHI <- file.path(DIR_CACHE, "export_hhi_cache.rds")

if (file.exists(CACHE_HHI)) {
  export_hhi <- read_cache(CACHE_HHI, expect = list(baci  = BACI_VERSION,
                                                    years = range(YEARS)))
} else {
  if (!dir.exists(BACI_DIR))
    stop("BACI source directory missing, needed for HS-chapter aggregation: ",
         BACI_DIR)
  if (!file.exists(BACI_CODES))
    stop("BACI country code file missing: ", BACI_CODES)
  
  baci_cc_hhi <- read_csv(BACI_CODES, col_types = cols(.default = "c")) |>
    select(numeric_code = country_code, iso3 = country_iso3)
  
  message("Loading BACI with HS-chapter detail (", min(YEARS), "-", max(YEARS),
          ") -- this re-reads the raw files and is slow...")
  baci_hs <- map_dfr(YEARS, function(yr) {
    f <- file.path(BACI_DIR, paste0("BACI_HS92_Y", yr, "_", BACI_VERSION, ".csv"))
    if (!file.exists(f)) stop("Missing required annual file: ", f)
    read_csv(f, col_types = cols(t = "i", i = "c", j = "c",
                                 k = "c", v = "d", q = "d")) |>
      mutate(hs_chapter = substr(k, 1, 2)) |>
      select(t, i, hs_chapter, v) |>
      group_by(t, i, hs_chapter) |>
      summarise(v = sum(v, na.rm = TRUE), .groups = "drop")
  })
  
  export_hhi <- baci_hs |>
    left_join(baci_cc_hhi, by = c("i" = "numeric_code")) |>
    filter(iso3 %in% ACP_ISO3) |>
    rename(year = t) |>
    group_by(iso3, year) |>
    mutate(country_total = sum(v, na.rm = TRUE)) |>
    ungroup() |>
    mutate(chapter_share = if_else(country_total > 0, v / country_total, NA_real_)) |>
    group_by(iso3, year) |>
    summarise(
      export_hhi = if_else(all(is.na(chapter_share)), NA_real_,
                           sum(chapter_share^2, na.rm = TRUE)),
      n_chapters = sum(!is.na(chapter_share) & chapter_share > 0),
      .groups = "drop"
    ) |>
    select(iso3, year, export_hhi, n_chapters)
  
  write_cache(export_hhi, CACHE_HHI, n_rows = nrow(export_hhi))
}

stopifnot(!anyDuplicated(export_hhi[, c("iso3","year")]))
bad_ehhi <- export_hhi |> filter(!is.na(export_hhi),
                                 export_hhi <= 0 | export_hhi > 1)
if (nrow(bad_ehhi) > 0) {
  print(head(bad_ehhi, 10))
  stop(nrow(bad_ehhi), " export_hhi value(s) outside the valid range 0 to 1. Check the ",
       "chapter_share construction -- an HHI of exactly 0 is impossible for ",
       "any country with positive exports.")
}
message(sprintf(
  "Export concentration HHI: %d country-years, mean %.4f (min %.4f = most diversified, max %.4f = single-chapter exporter).",
  nrow(export_hhi), mean(export_hhi$export_hhi, na.rm = TRUE),
  min(export_hhi$export_hhi, na.rm = TRUE), max(export_hhi$export_hhi, na.rm = TRUE)
))
stage("export_hhi")


# =============================================================================
# 6. INTRA-REC TRADE SHARE AND INTENSITY
# =============================================================================
message("Computing intra-REC trade share...")

# relationship = "many-to-many" is correct and expected: this is a self-join on
# rec to enumerate all within-bloc country pairs.
rec_pairs_static <- REC_MEMBERSHIP_STATIC |>
  inner_join(REC_MEMBERSHIP_STATIC, by = "rec", suffix = c("_i", "_j"),
             relationship = "many-to-many") |>
  filter(iso3_i != iso3_j) |>
  select(iso3_reporter = iso3_i, iso3_partner = iso3_j)

ecowas_members <- REC_MEMBERSHIP_STATIC |> filter(rec == "ECOWAS") |> pull(iso3)
rec_pairs_mrt <- bind_rows(
  expand_grid(year = 1995:2000, iso3_reporter = "MRT",          iso3_partner = ecowas_members),
  expand_grid(year = 1995:2000, iso3_reporter = ecowas_members, iso3_partner = "MRT")
)

pif_members_static <- REC_MEMBERSHIP_STATIC |> filter(rec == "PIF") |> pull(iso3)
rec_pairs_tls <- bind_rows(
  expand_grid(year = 2003:max(YEARS), iso3_reporter = "TLS",              iso3_partner = pif_members_static),
  expand_grid(year = 2003:max(YEARS), iso3_reporter = pif_members_static, iso3_partner = "TLS")
)

# BDI and RWA acceded to the EAC together in 2007 (see BDI_RWA_REC, Section 3).
# Unlike MRT/TLS, this is TWO countries joining simultaneously, so pairs are
# needed both against the pre-existing static EAC members AND between BDI and
# RWA themselves -- both are EAC members from 2007, so BDI-RWA trade is
# intra-REC trade too, not just BDI/RWA-vs-KEN/TZA/UGA trade.
eac_members_static <- REC_MEMBERSHIP_STATIC |> filter(rec == "EAC") |> pull(iso3)
rec_pairs_bdirwa <- bind_rows(
  expand_grid(year = 2007:max(YEARS), iso3_reporter = c("BDI","RWA"), iso3_partner = eac_members_static),
  expand_grid(year = 2007:max(YEARS), iso3_reporter = eac_members_static, iso3_partner = c("BDI","RWA")),
  expand_grid(year = 2007:max(YEARS), iso3_reporter = "BDI", iso3_partner = "RWA"),
  expand_grid(year = 2007:max(YEARS), iso3_reporter = "RWA", iso3_partner = "BDI")
)

# COD acceded to SADC in 1998 (see COD_REC, Section 3) -- a single new member
# joining an existing bloc, same shape as MRT joining ECOWAS above.
sadc_members_static <- REC_MEMBERSHIP_STATIC |> filter(rec == "SADC") |> pull(iso3)
rec_pairs_cod <- bind_rows(
  expand_grid(year = 1998:max(YEARS), iso3_reporter = "COD",               iso3_partner = sadc_members_static),
  expand_grid(year = 1998:max(YEARS), iso3_reporter = sadc_members_static, iso3_partner = "COD")
)

# --- Denominators -----------------------------------------------------------
acp_total_exports <- baci |>
  filter(iso3_exp %in% ACP_ISO3) |>
  group_by(year, iso3 = iso3_exp) |>
  summarise(total_exports = sum(trade_value, na.rm = TRUE), .groups = "drop")

acp_total_imports <- baci |>
  filter(iso3_imp %in% ACP_ISO3) |>
  group_by(year, iso3 = iso3_imp) |>
  summarise(total_imports = sum(trade_value, na.rm = TRUE), .groups = "drop")

# Non-EU trade totals (denominator of it_share_exeu).
# Excluding EU partners from the denominator severs the mechanical link between
# the IT share and the EU-ACP bilateral dependent variable: a simultaneous
# contraction in EU bilateral flows can no longer mechanically inflate the
# denominator and bias the IT share upward.
acp_non_eu_exports <- baci |>
  filter(iso3_exp %in% ACP_ISO3, !iso3_imp %in% EU_ISO3) |>
  group_by(year, iso3 = iso3_exp) |>
  summarise(non_eu_exports = sum(trade_value, na.rm = TRUE), .groups = "drop")

acp_non_eu_imports <- baci |>
  filter(iso3_imp %in% ACP_ISO3, !iso3_exp %in% EU_ISO3) |>
  group_by(year, iso3 = iso3_imp) |>
  summarise(non_eu_imports = sum(trade_value, na.rm = TRUE), .groups = "drop")

# China trade totals (added 2026-08, post-conference). Mirrors the non-EU
# construction above but filtered TO China as counterparty rather than
# excluding the EU. Purpose: script 02 builds china_share = china_trade /
# total_trade the same way it builds s_eu, to test whether the "clean"
# non-EU denominator in the mechanical-endogeneity battery is itself moving
# because of a rising third-party partner rather than being genuinely inert.
# This is a preemptive robustness check, not a headline variable -- it never
# enters the baseline formula in script 02's Section 6.
acp_china_exports <- baci |>
  filter(iso3_exp %in% ACP_ISO3, iso3_imp == "CHN") |>
  group_by(year, iso3 = iso3_exp) |>
  summarise(china_exports = sum(trade_value, na.rm = TRUE), .groups = "drop")

acp_china_imports <- baci |>
  filter(iso3_imp %in% ACP_ISO3, iso3_exp == "CHN") |>
  group_by(year, iso3 = iso3_imp) |>
  summarise(china_imports = sum(trade_value, na.rm = TRUE), .groups = "drop")

# US trade totals (added 2026-08-05, for the diversion parallel-DV check --
# handoff item 5/6). Same construction as china_exports/imports above, filtered
# to USA instead of CHN. Purpose is different from china_share in script 02:
# china_share is a CONTROL on the EU-trade model (does China contaminate the
# denominator); us_trade/china_trade here are candidate DEPENDENT variables in
# their own right, for a parallel-DV test of whether intra-REC integration
# moves with or against a partner other than the EU (diversion vs general
# growth). The US is also a useful methodological parallel: AGOA is a US
# preferential arrangement playing a structurally similar role to the EU's
# EPAs, though it works through different eligibility criteria and has its
# own commodity/oil concentration quirks for some countries -- worth a
# footnote in the paper if the US parallel-DV result is used.
acp_us_exports <- baci |>
  filter(iso3_exp %in% ACP_ISO3, iso3_imp == "USA") |>
  group_by(year, iso3 = iso3_exp) |>
  summarise(us_exports = sum(trade_value, na.rm = TRUE), .groups = "drop")

acp_us_imports <- baci |>
  filter(iso3_imp %in% ACP_ISO3, iso3_exp == "USA") |>
  group_by(year, iso3 = iso3_imp) |>
  summarise(us_imports = sum(trade_value, na.rm = TRUE), .groups = "drop")

# --- Numerators: static pairs -----------------------------------------------
intra_exp_static <- baci |>
  inner_join(rec_pairs_static,
             by = c("iso3_exp" = "iso3_reporter", "iso3_imp" = "iso3_partner")) |>
  group_by(year, iso3 = iso3_exp) |>
  summarise(intra_exports = sum(trade_value, na.rm = TRUE), .groups = "drop")

intra_imp_static <- baci |>
  inner_join(rec_pairs_static,
             by = c("iso3_imp" = "iso3_reporter", "iso3_exp" = "iso3_partner")) |>
  group_by(year, iso3 = iso3_imp) |>
  summarise(intra_imports = sum(trade_value, na.rm = TRUE), .groups = "drop")

# --- Numerators: time-varying pairs (MRT, TLS, BDI/RWA, COD) ----------------
# With FIX_TIMEVARYING_REC_PAIRS = FALSE the focal filters apply, so only the
# acceding countries' own numerators are credited (legacy behaviour). With
# TRUE the filters are dropped and the counterpart members also receive
# credit. `focal` accepts a vector so BDI and RWA -- who acceded together --
# can be filtered as one group rather than requiring two separate calls that
# would double-count the BDI-RWA pair itself.
build_tv_intra <- function(pairs, focal) {
  exp_tbl <- baci |>
    inner_join(pairs, by = c("year",
                             "iso3_exp" = "iso3_reporter",
                             "iso3_imp" = "iso3_partner"))
  imp_tbl <- baci |>
    inner_join(pairs, by = c("year",
                             "iso3_imp" = "iso3_reporter",
                             "iso3_exp" = "iso3_partner"))
  
  if (!FIX_TIMEVARYING_REC_PAIRS) {
    exp_tbl <- exp_tbl |> filter(iso3_exp %in% focal)
    imp_tbl <- imp_tbl |> filter(iso3_imp %in% focal)
  }
  
  list(
    exports = exp_tbl |>
      group_by(year, iso3 = iso3_exp) |>
      summarise(intra_exports = sum(trade_value, na.rm = TRUE), .groups = "drop"),
    imports = imp_tbl |>
      group_by(year, iso3 = iso3_imp) |>
      summarise(intra_imports = sum(trade_value, na.rm = TRUE), .groups = "drop")
  )
}

tv_mrt    <- build_tv_intra(rec_pairs_mrt,    "MRT")
tv_tls    <- build_tv_intra(rec_pairs_tls,    "TLS")
tv_bdirwa <- build_tv_intra(rec_pairs_bdirwa, c("BDI","RWA"))
tv_cod    <- build_tv_intra(rec_pairs_cod,    "COD")

# The re-aggregation below is a no-op in legacy mode (each time-varying country
# appears only in its own table). Under the fix, static-bloc members appear in
# BOTH the static and time-varying tables; without this collapse the
# downstream left_join would silently duplicate country-years.
intra_exp_all <- bind_rows(intra_exp_static, tv_mrt$exports, tv_tls$exports,
                           tv_bdirwa$exports, tv_cod$exports) |>
  group_by(iso3, year) |>
  summarise(intra_exports = sum(intra_exports, na.rm = TRUE), .groups = "drop")

intra_imp_all <- bind_rows(intra_imp_static, tv_mrt$imports, tv_tls$imports,
                           tv_bdirwa$imports, tv_cod$imports) |>
  group_by(iso3, year) |>
  summarise(intra_imports = sum(intra_imports, na.rm = TRUE), .groups = "drop")

stopifnot(!anyDuplicated(intra_exp_all[, c("iso3","year")]),
          !anyDuplicated(intra_imp_all[, c("iso3","year")]))

world_totals <- baci |>
  group_by(year) |>
  summarise(world_trade = sum(trade_value, na.rm = TRUE), .groups = "drop")

acp_years <- expand_grid(iso3 = ACP_ISO3, year = YEARS)

intra_rec_share <- acp_years |>
  left_join(acp_total_exports,  by = c("iso3", "year")) |>
  left_join(acp_total_imports,  by = c("iso3", "year")) |>
  left_join(acp_non_eu_exports, by = c("iso3", "year")) |>
  left_join(acp_non_eu_imports, by = c("iso3", "year")) |>
  left_join(acp_china_exports,  by = c("iso3", "year")) |>
  left_join(acp_china_imports,  by = c("iso3", "year")) |>
  left_join(acp_us_exports,     by = c("iso3", "year")) |>
  left_join(acp_us_imports,     by = c("iso3", "year")) |>
  left_join(intra_exp_all,      by = c("iso3", "year")) |>
  left_join(intra_imp_all,      by = c("iso3", "year")) |>
  left_join(REC_LOOKUP,         by = c("iso3", "year")) |>
  mutate(
    across(
      c(total_exports, total_imports,
        non_eu_exports, non_eu_imports,
        china_exports,  china_imports,
        us_exports,     us_imports,
        intra_exports,  intra_imports),
      ~replace_na(.x, 0)
    ),
    total_trade  = total_exports + total_imports,
    non_eu_trade = non_eu_exports + non_eu_imports,
    china_trade  = china_exports  + china_imports,
    us_trade     = us_exports     + us_imports,
    intra_trade  = intra_exports  + intra_imports,
    # Standard IT share: intra-REC / total trade (includes EU in denominator)
    it_share      = if_else(!is.na(rec) & total_trade > 0,
                            intra_trade / total_trade,  NA_real_),
    # EU-excluded IT share: intra-REC / non-EU trade (severs mechanical link).
    # it_share_exeu >= it_share for any country with positive EU trade, so
    # coefficients are not directly comparable in magnitude across the two.
    it_share_exeu = if_else(!is.na(rec) & non_eu_trade > 0,
                            intra_trade / non_eu_trade, NA_real_),
    # Direction-specific ex-EU shares. The ACP_to_EU dependent variable is an
    # ACP export, so its denominator should be non-EU exports; EU_to_ACP is an
    # ACP import, so non-EU imports. The combined denominator mixes the two and
    # attributes import-side variation to the export equation.
    it_share_exeu_x = if_else(!is.na(rec) & non_eu_exports > 0,
                              intra_exports / non_eu_exports, NA_real_),
    it_share_exeu_m = if_else(!is.na(rec) & non_eu_imports > 0,
                              intra_imports / non_eu_imports, NA_real_)
  )

stopifnot(nrow(intra_rec_share) == length(ACP_ISO3) * length(YEARS))

rec_totals <- intra_rec_share |>
  filter(!is.na(rec)) |>
  group_by(rec, year) |>
  summarise(rec_total_trade = sum(total_trade, na.rm = TRUE), .groups = "drop")

intra_rec_share <- intra_rec_share |>
  left_join(world_totals, by = "year") |>
  left_join(rec_totals,   by = c("rec", "year")) |>
  mutate(
    rec_world_share = if_else(world_trade > 0, rec_total_trade / world_trade, NA_real_),
    it_intensity    = if_else(!is.na(rec_world_share) & rec_world_share > 0,
                              it_share / rec_world_share, NA_real_),
    rec             = factor(rec, levels = REC_LEVELS)
  ) |>
  select(iso3, year, rec, it_share, it_share_exeu, it_intensity,
         it_share_exeu_x, it_share_exeu_m,
         total_trade, intra_trade,
         total_exports, total_imports,
         non_eu_exports, non_eu_imports,
         intra_exports, intra_imports,
         china_trade, china_exports, china_imports,
         us_trade, us_exports, us_imports)

# Sanity bounds: a share outside [0, 1] means the numerator/denominator pairing
# has broken, which the fix flag is capable of doing if it ever double-counts.
bad_share <- intra_rec_share |>
  filter((!is.na(it_share)        & (it_share        < 0 | it_share        > 1)) |
           (!is.na(it_share_exeu_x) & (it_share_exeu_x < 0 | it_share_exeu_x > 1)) |
           (!is.na(it_share_exeu_m) & (it_share_exeu_m < 0 | it_share_exeu_m > 1)))

if (nrow(bad_share) > 0) {
  bad_share |>
    select(iso3, year, rec, it_share, it_share_exeu_x, it_share_exeu_m) |>
    head(20) |> print()
  stop(nrow(bad_share), " country-year(s) have a share outside [0, 1]. ",
       "This was previously computed and silently discarded -- it is now ",
       "enforced. Most likely cause: FIX_TIMEVARYING_REC_PAIRS = TRUE double-",
       "crediting a numerator, or a denominator join gone wrong. Do not ",
       "proceed until resolved.")
}
message("Share bounds check passed: 0 rows outside [0, 1].")
message("IT share computed: ", nrow(intra_rec_share), " ACP country-years")

# Diagnostic: confirm it_share_exeu >= it_share (expected wherever EU trade > 0)
exeu_check <- intra_rec_share |>
  filter(!is.na(it_share), !is.na(it_share_exeu)) |>
  summarise(
    n_exeu_larger  = sum(it_share_exeu > it_share),
    n_exeu_equal   = sum(it_share_exeu == it_share),
    n_exeu_smaller = sum(it_share_exeu < it_share),
    mean_ratio     = round(mean(it_share_exeu / it_share, na.rm = TRUE), 3)
  )
message(sprintf(
  "  it_share_exeu: %d larger (expected), %d equal, %d smaller (should be 0), mean ratio = %.3f",
  exeu_check$n_exeu_larger, exeu_check$n_exeu_equal,
  exeu_check$n_exeu_smaller, exeu_check$mean_ratio
))
stage("it_share")


# =============================================================================
# 7. EU-ACP BILATERAL TRADE
# =============================================================================
message("Extracting EU-ACP bilateral flows...")

eu_acp_trade <- baci |>
  filter(
    (iso3_exp %in% EU_ISO3  & iso3_imp %in% ACP_ISO3) |
      (iso3_exp %in% ACP_ISO3 & iso3_imp %in% EU_ISO3)
  ) |>
  mutate(
    eu_iso3   = if_else(iso3_exp %in% EU_ISO3,  iso3_exp, iso3_imp),
    acp_iso3  = if_else(iso3_exp %in% ACP_ISO3, iso3_exp, iso3_imp),
    direction = if_else(iso3_exp %in% EU_ISO3, "EU_to_ACP", "ACP_to_EU")
  ) |>
  group_by(year, eu_iso3, acp_iso3, direction) |>
  summarise(trade_value = sum(trade_value, na.rm = TRUE), .groups = "drop")

eu_acp_wide <- eu_acp_trade |>
  pivot_wider(names_from = direction, values_from = trade_value, values_fill = 0) |>
  mutate(total_bilateral = EU_to_ACP + ACP_to_EU)

# Dyad grid applies both enlargement (entry) and Brexit (exit) constraints
dyad_grid <- expand_grid(year = YEARS, eu_iso3 = EU_ISO3, acp_iso3 = ACP_ISO3) |>
  left_join(EU_ENLARGEMENT, by = "eu_iso3") |>
  left_join(EU_EXIT,        by = "eu_iso3") |>
  filter(is.na(eu_entry_year) | year >= eu_entry_year) |>
  filter(is.na(eu_exit_year)  | year <= eu_exit_year)  |>
  select(-eu_entry_year, -eu_exit_year)

# Named eu_acp_grid, not eu_acp_panel, so no object in this script is a
# near-miss for fixest::panel().
eu_acp_grid <- dyad_grid |>
  left_join(eu_acp_wide, by = c("year", "eu_iso3", "acp_iso3")) |>
  mutate(across(c(EU_to_ACP, ACP_to_EU, total_bilateral), ~replace_na(.x, 0)))

message("EU-ACP dyad-year grid: ", format(nrow(eu_acp_grid), big.mark = ","), " obs")
stage("bilateral")


# =============================================================================
# 7.5 EU-PARTNER CONCENTRATION (added 2026-08, post-conference)
# =============================================================================
# Herfindahl index of an ACP country's EU-side trade across the 28 EU
# partners, by year. Built entirely from eu_acp_grid above -- no new data.
# A country trading overwhelmingly with one or two EU members (e.g. a former
# colony trading mainly with the old colonial power) sits at a different
# point on this measure than one with a diversified EU-partner base, which
# connects naturally to the existing `colonial` gravity control.
#
# Undefined (NA) when an ACP country's total EU trade is zero in that year --
# a share of zero has no meaningful concentration.
eu_partner_hhi <- eu_acp_grid |>
  group_by(acp_iso3, year) |>
  mutate(acp_eu_total = sum(total_bilateral, na.rm = TRUE)) |>
  ungroup() |>
  mutate(partner_share = if_else(acp_eu_total > 0,
                                 total_bilateral / acp_eu_total, NA_real_)) |>
  group_by(iso3 = acp_iso3, year) |>
  summarise(
    eu_partner_hhi = if_else(all(is.na(partner_share)), NA_real_,
                             sum(partner_share^2, na.rm = TRUE)),
    .groups = "drop"
  )

stopifnot(!anyDuplicated(eu_partner_hhi[, c("iso3","year")]))
bad_hhi <- eu_partner_hhi |> filter(!is.na(eu_partner_hhi),
                                    eu_partner_hhi < 1/28 - 1e-9 | eu_partner_hhi > 1 + 1e-9)
if (nrow(bad_hhi) > 0) {
  print(head(bad_hhi, 10))
  stop(nrow(bad_hhi), " eu_partner_hhi value(s) outside the valid range ",
       "[1/28, 1]. Check the partner_share construction.")
}
message(sprintf("EU-partner HHI: %d country-years, %d with zero EU trade (NA).",
                nrow(eu_partner_hhi), sum(is.na(eu_partner_hhi$eu_partner_hhi))))
stage("eu_partner_hhi")


# =============================================================================
# 8. CEPII GRAVITY - structural variables
# =============================================================================
# Gravity_V202211.rds is a large download and is not always on disk; the derived
# structural table is small and is all the panel needs.
#
# To seed the cache from an existing panel (NO CEPII download required):
#   p <- readRDS(PANEL_RDS)
#   saveRDS(dplyr::distinct(p, eu_iso3, acp_iso3, year,
#                           distance, lang, contiguity, colonial),
#           CACHE_GRAVITY)
# The gravity variables are time-invariant, so a seeded cache is exact, not an
# approximation. It carries no provenance attribute; read_cache() notes that and
# proceeds.
# =============================================================================
if (file.exists(CACHE_GRAVITY)) {
  gravity_structural <- read_cache(CACHE_GRAVITY,
                                   expect = list(gravity = GRAVITY_VERSION))
} else {
  if (!file.exists(GRAVITY_FILE))
    stop("CEPII gravity missing and no cache present.\n",
         "  Expected source: ", GRAVITY_FILE, "\n",
         "  Expected cache:  ", CACHE_GRAVITY, "\n",
         "  Seed the cache from the existing panel (see comment above) or ",
         "re-download Gravity_", GRAVITY_VERSION, " from CEPII.")
  
  message("Loading CEPII gravity from source...")
  gravity_full <- readRDS(GRAVITY_FILE)
  
  gravity_structural <- gravity_full |>
    select(iso3_o, iso3_d, year, distcap, comlang_off, contig, col_dep_ever) |>
    mutate(
      across(distcap, as.numeric),
      across(c(comlang_off, contig, col_dep_ever), as.integer)
    ) |>
    rename(
      eu_iso3    = iso3_o,  acp_iso3 = iso3_d,
      distance   = distcap, lang     = comlang_off,
      contiguity = contig,  colonial = col_dep_ever
    ) |>
    filter(eu_iso3 %in% EU_ISO3, acp_iso3 %in% ACP_ISO3, year %in% YEARS) |>
    group_by(eu_iso3, acp_iso3, year) |>
    arrange(desc(!is.na(distance))) |>
    slice(1) |>
    ungroup()
  
  write_cache(gravity_structural, CACHE_GRAVITY, n_rows = nrow(gravity_structural))
}

stopifnot(!anyDuplicated(gravity_structural[, c("eu_iso3","acp_iso3","year")]))
message("Gravity structural: ", format(nrow(gravity_structural), big.mark = ","), " records")
stage("gravity")


# =============================================================================
# 9. GDP AND POPULATION - WDI (COK/NIU manual patches; CEPII fallback)
#    CEPII GDP/pop covers only through 2020; WDI is the primary source.
# =============================================================================
cok_gdp_pc <- c(6500,6527,6080,5471,6070,6307,6893,8107,11093,12916,
                13164,13480,14628,14108,13085,14184,15581,16952,16427,18221,
                17320,17878,20274,21855,22121,18116,18500)
cok_pop    <- c(19200,19200,19100,18900,18700,18600,18027,18200,18500,18900,
                19200,19342,19400,19400,19300,17800,17459,17600,17500,17400,
                17500,17434,17500,17500,17500,17500,17450)
stopifnot(length(cok_gdp_pc) == length(YEARS), length(cok_pop) == length(YEARS))
cok_data <- tibble(iso3 = "COK", year = YEARS,
                   gdp_wdi = cok_gdp_pc * cok_pop, pop_wdi = cok_pop)

niu_gdp_pc <- c(2900,3100,3300,3100,3000,2800,3100,3400,3900,4800,
                5800,6100,7200,8100,8000,8500,10200,11200,12300,13500,
                13500,14500,15200,16200,16800,14900,15500)
niu_pop    <- c(2500,2300,2200,2100,2000,1900,1800,1700,1650,1600,
                1580,1560,1530,1520,1510,1500,1490,1480,1470,1470,
                1620,1620,1620,1620,1620,1620,1620)
stopifnot(length(niu_gdp_pc) == length(YEARS), length(niu_pop) == length(YEARS))
niu_data <- tibble(iso3 = "NIU", year = YEARS,
                   gdp_wdi = niu_gdp_pc * niu_pop, pop_wdi = niu_pop)

download_wdi <- function(cache_path, max_retries = 3) {
  for (attempt in seq_len(max_retries)) {
    result <- tryCatch({
      message("WDI download attempt ", attempt, "/", max_retries, "...")
      old_opts <- options(timeout = 300)
      on.exit(options(old_opts), add = TRUE)
      
      wdi_raw <- WDI(
        country   = "all",
        indicator = c(gdp_wdi = "NY.GDP.MKTP.CD", pop_wdi = "SP.POP.TOTL"),
        start     = min(YEARS),
        end       = max(YEARS),
        extra     = TRUE
      )
      
      wdi_clean <- wdi_raw |>
        filter(region != "Aggregates", !is.na(iso3c)) |>
        select(iso3 = iso3c, year, gdp_wdi, pop_wdi)
      
      bind_rows(wdi_clean, cok_data, niu_data) |>
        distinct(iso3, year, .keep_all = TRUE)
    }, error = function(e) {
      message("  Attempt ", attempt, " failed: ", conditionMessage(e))
      NULL
    })
    
    if (!is.null(result)) {
      write_cache(result, cache_path, n_rows = nrow(result))
      return(result)
    }
    if (attempt < max_retries) Sys.sleep(5)
  }
  NULL
}

if (file.exists(CACHE_WDI)) {
  wdi_all <- read_cache(CACHE_WDI, expect = list(years = range(YEARS)))
} else {
  wdi_all <- download_wdi(CACHE_WDI)
}

if (is.null(wdi_all)) {
  # The CEPII fallback needs gravity_full, which does not exist when Section 8
  # was served from cache. Fail loudly rather than with a confusing
  # "object 'gravity_full' not found".
  if (!exists("gravity_full"))
    stop("WDI unavailable and CEPII gravity was loaded from cache, so the ",
         "GDP/population fallback cannot run.\n",
         "  Restore ", CACHE_WDI, " or re-run with Gravity_", GRAVITY_VERSION,
         ".rds present.")
  
  warning("WDI download failed. Falling back to CEPII GDP/pop (through 2020 only).")
  gravity_gdp_pop <- gravity_full |>
    select(iso3_o, iso3_d, year, gdp_o, gdp_d, pop_o, pop_d) |>
    mutate(across(c(gdp_o, gdp_d, pop_o, pop_d), as.numeric)) |>
    filter(iso3_o %in% EU_ISO3, iso3_d %in% ACP_ISO3, year %in% YEARS) |>
    rename(eu_iso3 = iso3_o, acp_iso3 = iso3_d) |>
    group_by(eu_iso3, acp_iso3, year) |>
    slice(1) |>
    ungroup()
  
  eu_gdp  <- gravity_gdp_pop |>
    select(iso3 = eu_iso3,  year, gdp_wdi = gdp_o, pop_wdi = pop_o) |>
    distinct(iso3, year, .keep_all = TRUE)
  acp_gdp <- gravity_gdp_pop |>
    select(iso3 = acp_iso3, year, gdp_wdi = gdp_d, pop_wdi = pop_d) |>
    distinct(iso3, year, .keep_all = TRUE)
  
  wdi_all <- bind_rows(eu_gdp, acp_gdp) |>
    distinct(iso3, year, .keep_all = TRUE) |>
    mutate(across(c(gdp_wdi, pop_wdi), as.numeric))
}

wdi_all <- wdi_all |> distinct(iso3, year, .keep_all = TRUE)

wdi_acp_coverage <- wdi_all |>
  filter(iso3 %in% ACP_ISO3) |>
  group_by(iso3) |>
  summarise(n_gdp = sum(!is.na(gdp_wdi)), .groups = "drop") |>
  filter(n_gdp < length(YEARS))

if (nrow(wdi_acp_coverage) > 0) {
  message("ACP countries with incomplete GDP coverage (expected: SOM, ERI, TLS pre-2003):")
  print(wdi_acp_coverage)
}
stage("wdi")


# =============================================================================
# 10. EPA TREATMENT
# =============================================================================
epa_treatment <- expand_grid(acp_iso3 = ACP_ISO3, year = YEARS) |>
  left_join(EPA_DATES |> rename(acp_iso3 = iso3), by = "acp_iso3") |>
  mutate(
    epa       = if_else(!is.na(epa_date) &
                          year >= as.integer(format(epa_date, "%Y")), 1L, 0L),
    epa_years = if_else(epa == 1L,
                        year - as.integer(format(epa_date, "%Y")), NA_integer_)
  ) |>
  select(acp_iso3, year, epa, epa_years)

stopifnot(!anyDuplicated(epa_treatment[, c("acp_iso3","year")]))
stage("epa_panel")


# =============================================================================
# 11. BUILD FINAL PANEL
# =============================================================================
# The object is named `acp_panel`, NOT `panel`. fixest exports a function called
# panel(); when that package is attached, an unassigned `panel` resolves to the
# function and saveRDS() will happily serialize it to a 1.5 KB .rds that looks
# like a valid file. That is exactly what happened on 2026-07-23.
message("Building final panel...")

acp_panel <- eu_acp_grid |>
  left_join(gravity_structural,
            by = c("eu_iso3", "acp_iso3", "year")) |>
  left_join(wdi_all |> rename(acp_iso3 = iso3, gdp_acp = gdp_wdi, pop_acp = pop_wdi),
            by = c("acp_iso3", "year")) |>
  left_join(wdi_all |> rename(eu_iso3  = iso3, gdp_eu  = gdp_wdi, pop_eu  = pop_wdi),
            by = c("eu_iso3", "year")) |>
  left_join(epa_treatment,
            by = c("acp_iso3", "year")) |>
  left_join(intra_rec_share |> rename(acp_iso3 = iso3),
            by = c("acp_iso3", "year")) |>
  left_join(eu_partner_hhi  |> rename(acp_iso3 = iso3),
            by = c("acp_iso3", "year")) |>
  left_join(export_hhi |> select(-any_of("n_chapters")) |> rename(acp_iso3 = iso3),
            by = c("acp_iso3", "year")) |>
  left_join(CURRENCY_UNION_LOOKUP |> rename(acp_iso3 = iso3),
            by = "acp_iso3") |>
  mutate(
    pair_id         = paste(eu_iso3, acp_iso3, sep = "_"),
    ln_trade        = if_else(total_bilateral > 0, log(total_bilateral), NA_real_),
    ln_gdp_eu       = log(gdp_eu),
    ln_gdp_acp      = log(gdp_acp),
    ln_dist         = log(distance),
    # Linder-type control (handoff item 5): total market size (ln_gdp_eu)
    # already exists; this adds income LEVEL, which market size does not
    # capture. No new WDI pull -- pop_eu is already in hand.
    gdp_pc_eu       = gdp_eu / pop_eu,
    exporter_year   = paste(eu_iso3,  year, sep = "_"),
    importer_year   = paste(acp_iso3, year, sep = "_"),
    tls_pre_cotonou = (acp_iso3 == "TLS" & year < 2003)
  )
# NOTE: log(population) is deliberately NOT created here. Script 02 builds it as
# pop_acp_ln in its own mutate and references that name in DICT and in the
# f_gdp / f_gdp_eu formulas. Two identically-valued columns under different
# names is exactly the kind of thing that goes wrong six months later.

message("Panel: ", format(nrow(acp_panel), big.mark = ","), " obs | ",
        n_distinct(acp_panel$pair_id), " dyads | ",
        n_distinct(acp_panel$acp_iso3), " ACP | ",
        round(100 * mean(acp_panel$total_bilateral == 0), 1), "% zero trade")
stage("panel")


# =============================================================================
# 12. VALIDATION
# =============================================================================
stopifnot(is.data.frame(acp_panel))
stopifnot(n_distinct(acp_panel$acp_iso3) == 78)
stopifnot(n_distinct(acp_panel$eu_iso3)  == 28)   # script 02 requires exactly 28

if (any(acp_panel$eu_iso3 == "GBR" & acp_panel$year == 2021))
  stop("GBR x 2021 rows present - check EU_EXIT filter in dyad_grid.")
if (!any(acp_panel$eu_iso3 == "GBR"))
  stop("GBR absent - the panel must include the UK for 1995-2020.")

# "ESA" must survive as a label; if it ever becomes "COMESA", script 02's
# factor(rec, levels = REC_LEVELS) turns every ESA row into NA without error.
if (!"ESA" %in% levels(acp_panel$rec))
  stop("'ESA' missing from rec levels. Check REC_LEVELS for a COMESA regression.")

stopifnot(acp_panel |> filter(rec == "EAC")                                    |> pull(epa) |> max() == 0)
stopifnot(acp_panel |> filter(acp_iso3 == "HTI")                               |> pull(epa) |> max() == 0)
stopifnot(acp_panel |> filter(acp_iso3 %in% c("MWI","ZMB","WSM","SLB","TLS"))  |> pull(epa) |> max() == 0)
message("EPA integrity checks passed.")

# Confirm the BDI/RWA/COD accession fix actually bound. This is exactly the
# kind of thing that could silently fail: a typo in the spell-table year
# range, or a join that drops the NA rows instead of keeping them, would put
# these countries back to their old (wrong) full-window static labels without
# any error -- the panel would just look like nothing changed.
bad_eac_early <- acp_panel |>
  filter(acp_iso3 %in% c("BDI","RWA"), year < 2007, rec == "EAC") |> nrow()
bad_sadc_early <- acp_panel |>
  filter(acp_iso3 == "COD", year < 1998, rec == "SADC") |> nrow()
if (bad_eac_early > 0 || bad_sadc_early > 0)
  stop("BDI/RWA/COD accession fix did not bind: ", bad_eac_early,
       " pre-2007 BDI/RWA rows still labeled EAC, ", bad_sadc_early,
       " pre-1998 COD rows still labeled SADC.")
if (!any(acp_panel$acp_iso3 %in% c("BDI","RWA") & acp_panel$year >= 2007 & acp_panel$rec == "EAC"))
  stop("BDI/RWA never show as EAC from 2007 onward -- check BDI_RWA_REC.")
if (!any(acp_panel$acp_iso3 == "COD" & acp_panel$year >= 1998 & acp_panel$rec == "SADC"))
  stop("COD never shows as SADC from 1998 onward -- check COD_REC.")
message("BDI/RWA/COD accession-year fix confirmed: correctly unaffiliated ",
        "before accession, correctly labeled from their accession year.")

dup_check <- acp_panel |> count(eu_iso3, acp_iso3, year) |> filter(n > 1)
if (nrow(dup_check) > 0)
  stop("DUPLICATES IN FINAL PANEL: ", nrow(dup_check),
       " eu x acp x year combinations.")
message("No duplicates confirmed.")

# Mirrors required_cols in script 02 Section 1, plus the columns 02 derives from.
# total_trade and intra_trade were always in the panel but were never listed
# here; script 02 now hard-requires them for the mechanical-endogeneity battery,
# so the guard is extended to cover them.
REQUIRED_PANEL_COLS <- c(
  "eu_iso3","acp_iso3","year","rec","pair_id",
  "EU_to_ACP","ACP_to_EU","total_bilateral","ln_trade",
  "it_share","it_share_exeu","it_intensity",
  "it_share_exeu_x","it_share_exeu_m",
  "total_trade","intra_trade",
  "total_exports","total_imports",
  "non_eu_exports","non_eu_imports",
  "intra_exports","intra_imports",
  "china_trade","china_exports","china_imports",
  "us_trade","us_exports","us_imports",
  "eu_partner_hhi","export_hhi",
  "peg_cemac","peg_waemu","peg_comoros","peg_cma","peg_eccu","peg_pacific",
  "eur_peg","other_currency_union",
  "distance","ln_dist","lang","contiguity","colonial",
  "gdp_acp","gdp_eu","pop_acp","pop_eu","ln_gdp_acp","ln_gdp_eu","gdp_pc_eu",
  "epa","epa_years","exporter_year","importer_year"
)

missing_cols <- setdiff(REQUIRED_PANEL_COLS, names(acp_panel))
if (length(missing_cols))
  stop("Panel missing required columns: ", paste(missing_cols, collapse = ", "))

acp_panel |>
  summarise(
    pct_miss_it      = round(100 * mean(is.na(it_share)),      1),
    pct_miss_it_exeu = round(100 * mean(is.na(it_share_exeu)), 1),
    pct_miss_gdp     = round(100 * mean(is.na(gdp_acp)),       1),
    pct_miss_dist    = round(100 * mean(is.na(distance)),      1),
    pct_zero         = round(100 * mean(total_bilateral == 0), 1),
    n                = n()
  ) |>
  print()

stage("validation")


# =============================================================================
# 13. SUMMARY STATISTICS BY REC
#     mean_it here is the RAW observed SADC mean -- computed on this script's
#     output before script 02's SADC pre-2000 coverage rule (its Section 2)
#     sets those dyad-years to NA. It is therefore a different quantity from
#     the SADC mean in aux_summary_statistics.csv, which script 02 computes
#     AFTER that rule and which is what Table 2 and all paper text use
#     (confirmed 0.324 on the 2000-2021 run dated 2026-07-28).
#
#     There is no donor-pool imputation anywhere in the pipeline any more --
#     that apparatus was deleted from 02_estimate_gravity.R (see that script's
#     changelog item 6). Do not reintroduce a reference to an "imputed" SADC
#     mean; the current treatment is an explicit NA rule, not a fill.
# =============================================================================
rec_summary <- acp_panel |>
  filter(!is.na(it_share), !is.na(rec)) |>
  distinct(acp_iso3, year, rec, it_share, it_share_exeu) |>
  group_by(rec) |>
  summarise(
    n_countries  = n_distinct(acp_iso3),
    n_cy         = n(),
    mean_it      = round(mean(it_share,      na.rm = TRUE), 4),
    sd_it        = round(sd(it_share,        na.rm = TRUE), 4),
    mean_it_exeu = round(mean(it_share_exeu, na.rm = TRUE), 4),
    sd_it_exeu   = round(sd(it_share_exeu,   na.rm = TRUE), 4),
    .groups      = "drop"
  ) |>
  arrange(desc(mean_it))

print(rec_summary)
write_csv(rec_summary, OUT_REC_SUMMARY)
message("Wrote: ", OUT_REC_SUMMARY)


# =============================================================================
# 14. SAVE - three independent guards
# =============================================================================
# (a) Paste guard: every stage must have reported in.
missing_stages <- setdiff(STAGES_REQUIRED, .STAGES_DONE)
if (length(missing_stages))
  stop("Refusing to write. Stages that never completed: ",
       paste(missing_stages, collapse = ", "), ".\n",
       "  This almost always means the script was pasted rather than sourced ",
       "and execution continued past an error. Restart R and use source().")

# (b) Object guard: the thing being written must be the panel, not a function.
stopifnot(
  is.data.frame(acp_panel),
  nrow(acp_panel) > 40000,
  all(REQUIRED_PANEL_COLS %in% names(acp_panel))
)

# (c) Overwrite guard: never silently replace the panel the paper cites.
# Uses a flag rather than stop(), because stop() only halts execution under
# source(). When the script is pasted, execution continues past the error and
# the writes below fire anyway -- which is exactly what happened on 2026-07-24.
SAFE_TO_WRITE <- TRUE
if (file.exists(PANEL_RDS) && !OVERWRITE_PANEL) {
  SAFE_TO_WRITE <- FALSE
  message("\n*** REFUSING TO WRITE ***\n",
          "  A panel already exists at: ", PANEL_RDS, "\n",
          "  OVERWRITE_PANEL is FALSE, so nothing was written.\n",
          "  To verify a rebuild: point PANEL_RDS/PANEL_CSV at ",
          "eu_acp_panel_rebuild.rds/.csv, re-run, then use compare_panels().")
}

if (SAFE_TO_WRITE) {
  attr(acp_panel, "provenance") <- list(
    built       = Sys.time(),
    baci        = BACI_VERSION,
    gravity     = GRAVITY_VERSION,
    years       = range(YEARS),
    mrt_tls_fix = FIX_TIMEVARYING_REC_PAIRS,
    n_obs       = nrow(acp_panel)
  )
  
  message("Saving panel...")
  saveRDS(acp_panel, PANEL_RDS)
  write_csv(acp_panel, PANEL_CSV)
  message("Done. Panel saved to:\n  ", PANEL_RDS, "\n  ", PANEL_CSV)
}

message("\nBACK UP OFF-LAPTOP:")
for (f in c(PANEL_RDS, PANEL_CSV, CACHE_BACI, CACHE_WDI, CACHE_GRAVITY))
  message("  ", f, if (file.exists(f)) "" else "   [MISSING]")


# =============================================================================
# 15. REBUILD VERIFICATION (post-conference)
# =============================================================================
# Never adopt a rebuild without diffing it against the panel the paper's numbers
# come from. Usage:
#
#   ref <- readRDS(file.path(DIR_DATA, "eu_acp_panel.rds"))
#   new <- readRDS(file.path(DIR_DATA, "eu_acp_panel_rebuild.rds"))
#   compare_panels(ref, new)
#
# Pay particular attention to TLS 2002 (the PIF-from-2002-vs-2003 discrepancy)
# and to ECOWAS/PIF it_share if FIX_TIMEVARYING_REC_PAIRS was enabled.
# =============================================================================
compare_panels <- function(ref, new,
                           keys = c("eu_iso3","acp_iso3","year"),
                           tol  = 1e-10) {
  message("Rows: ref = ", nrow(ref), " | new = ", nrow(new))
  
  common_cols <- intersect(names(ref), names(new))
  message("Cols: ref-only = ",
          paste(setdiff(names(ref), names(new)), collapse = ", "),
          " | new-only = ",
          paste(setdiff(names(new), names(ref)), collapse = ", "))
  
  joined <- inner_join(
    ref |> select(all_of(common_cols)),
    new |> select(all_of(common_cols)),
    by = keys, suffix = c("_ref", "_new")
  )
  message("Matched on keys: ", nrow(joined))
  
  check <- setdiff(common_cols, keys)
  out <- map_dfr(check, function(v) {
    a <- joined[[paste0(v, "_ref")]]
    b <- joined[[paste0(v, "_new")]]
    if (is.numeric(a) && is.numeric(b)) {
      # Relative, not absolute. Trade values run to ~1e8, so an absolute
      # tolerance of 1e-9 flags CSV round-trip noise at the last bit of a
      # double as if it were a data difference.
      d <- abs(a - b) / pmax(abs(a), abs(b), 1)
      tibble(column = v,
             n_diff = sum(d > tol, na.rm = TRUE) + sum(xor(is.na(a), is.na(b))),
             max_rel_diff = suppressWarnings(max(d, na.rm = TRUE)))
    } else {
      tibble(column = v,
             n_diff = sum(as.character(a) != as.character(b), na.rm = TRUE) +
               sum(xor(is.na(a), is.na(b))),
             max_rel_diff = NA_real_)
    }
  }) |>
    arrange(desc(n_diff))
  
  print(out, n = nrow(out))
  if (all(out$n_diff == 0))
    message("IDENTICAL on all shared columns. Rebuild is safe to adopt.")
  else
    message("DIFFERENCES FOUND. Do not adopt until each is explained.")
  invisible(out)
}