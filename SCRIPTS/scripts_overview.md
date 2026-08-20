# Scripts overview (reference notes)

Context notes for `SCRIPTS/`, written against the finalized `PAPER/Draft/paper_final_draft.docx` and `PAPER/Draft/supporting_information.docx`, now the source-of-truth manuscript. Kept here so a future session doesn't have to re-derive the mapping between scripts, outputs, and paper tables by reading 4,300+ lines of R again.

## Pipeline

1. **`01_build_panel.r`** (~1,600 lines) — builds `DATA/eu_acp_panel.{csv,rds}` from raw BACI/CEPII/WDI/Pacific Community sources. Handles REC membership (incl. the 8 time-varying countries), EPA date coding, currency-union flags, HHI concentration indices. Heavily guarded: provenance-stamped caches (`read_cache`/`write_cache`), a "paste guard" (`stage()`/`STAGES_REQUIRED`) that blocks writing a panel if any build stage didn't complete, an overwrite guard (`OVERWRITE_PANEL <- FALSE`) forcing rebuilds to a new filename and a diff (`compare_panels()`, end of file) before adoption.
2. **`02_estimate_gravity.r`** (~2,650 lines) — all estimation. Main PPML spec around line 840 (`fepois`, FE = `exporter_year + acp_iso3`, clustered `~acp_iso3`; `FE`/`X` formula pieces defined ~line 802). Produces every numbered table (`table1_main_results.tex` … `table10_...tex`) and the `aux_*.csv/tex` supporting tables, including the inverse-hyperbolic-sine robustness check (`aux_ihs_robustness.csv/.tex`, ~line 1283 onward: `asinh_intra`/`asinh_noneu`/`asinh_extra` built to retain the zero-trade country-years the log-spec drops, feeding SI Table S.3). `EXPECTED_OUTPUTS` (~line 128) plus a Section 18 verification step confirm every output file was actually rewritten in the run.
3. **`03_monte_carlo_null.R`** (65 lines) — standalone simulation, not part of the numbered pipeline and not sourced by the other two scripts. Simulates panel data across a grid of average EU trade shares (`eu_share_grid`, 0.05–0.50, 200 replications each, seed 20260818) in which intra-regional and non-EU trade are generated independently of EU trade by construction, a true null with neither diversion nor expansion built in. Fits the naive share, EU-fixed-share, and disjoint specifications on each simulated panel and reports the mean coefficient and false-rejection rate at each EU-share grid point, feeding SI Table S.2 (§S.4). Writes `OUTPUT/tables/aux_monte_carlo_null_dgp.csv` — this path was previously wrong (the script wrote to the repo root and/or `SCRIPTS/` via a bare relative filename with no working-directory assumption made explicit); it now writes to `OUTPUT/tables/` explicitly, consistent with where `01_build_panel.r` and `02_estimate_gravity.r` write their outputs (`DIR_TAB <- file.path(DIR_OUT, "tables")` in both). The two stray misplaced copies (`SCRIPTS/aux_monte_carlo_null_dgp.csv`, `./aux_monte_carlo_null_dgp.csv`) have been deleted as orphaned outputs of the old path.
4. **`EAC_diagnostic.R`** (17 lines) — one-off ground-truth check, not part of the pipeline and produces no file output (prints a ratio to console). Computes Kenya's actual 2019 intra-EAC trade share directly from raw BACI (`DATA/cache/baci_raw_cache.rds`), bypassing the panel-construction pipeline entirely. This is the script that produced the 8.7% figure cited in SI §S.2 as the ground truth the pre-fix panel's reported 0% was checked against.
5. **`fig_bloc_map.R`** (67 lines) — REC membership map (Africa panel only; Caribbean/Pacific dropped due to an antimeridian rendering bug in `rnaturalearth`, per its own comment). Depends on objects (`REC_MEMBERSHIP_STATIC`, `REC_COLOURS`, etc.) sourced from the other two scripts rather than being self-contained.

## Table/figure → paper section map

Table numbering follows the finalized docx: Table 0 (REC membership) and Table 1 (main results) are in the body; Tables 3, 4, and 6 are also reported in full in the body (§5.2, §5.4); Tables 2, 5, 7, 8, 9, and 10 are reported only in the Supporting Information (S.3), with the body cross-referencing them by number. Tables S.1–S.3 are SI-only (S.2, S.4, S.5).

| Output | Paper location |
|---|---|
| `table1_main_results.tex` | Table 1 (§5.1) |
| `table3_mechanical_endogeneity.tex` | Table 3 (§5.2) |
| `aux_ratio_restrictions.csv` | Table 4 (§5.2) |
| `table5_direction_results.tex` | Table 5 (SI Table 5, §5.3) |
| `table6_rec_interactions.tex` | Table 6 (§5.4) |
| `aux_currency_peg_test.csv` | Currency-peg interaction results (§5.4) |
| `table7_robustness_estimators.tex` | Table 7 (SI Table 7, §5.5) |
| `table8_robustness_sample.tex` / `aux_beta_by_period.csv` | Table 8 + period split (SI Table 8, §5.5) |
| `table9_diversion_check.tex` / `aux_diversion_parallel_dv.csv` | Table 9 (SI Table 9, §5.5) |
| `table10_directional_construction.tex` | Table 10 (SI Table 10, §5.3) |
| `aux_ihs_robustness.csv/.tex` | SI Table S.3 (§5.2, §6, SI §S.5) |
| `aux_monte_carlo_null_dgp.csv` (`03_monte_carlo_null.R`) | SI Table S.2 (§1, SI §S.4) |
| `aux_leave_one_rec_out.tex` | REC exclusion robustness (§5.4) |
| `aux_rec_it_share_summary.csv` | Bloc-mean IT shares (§4.2, Table 0 footnote context) |
| `aux_eu_trade_share.csv` | EU share of ACP trade (§4.3, Fig. `fig_eu_trade_share`) |
| `aux_summary_statistics.csv` | Panel summary stats by REC |
| `aux_cluster_sensitivity.csv` | Clustering-choice robustness (§5.1) |
| `aux_share_vs_value.csv` | Share/value trend comparison (§5.5) |
| `aux_missing_covariates.csv` | Confound-control battery (§5.5) |

Every spot-checked number (Table 1, Table 3, Table 4/`aux_ratio_restrictions.csv`, Table 5, Table 6/`aux_currency_peg_test.csv`, Table 7, Table 8, Table 9, Table 10, `aux_ihs_robustness.csv`) was checked directly against its `OUTPUT/tables/` source file and matches the paper text exactly, with two exceptions found and corrected during this documentation pass rather than in the docx itself (the docx is the source of truth for prose and structure, but these two table cells in it are stale): Table 6's `dev_EAC` cell reads −3.098 in the docx but the source output (`table6_rec_interactions.tex`) gives `3.098$^{***}$`, matching the surrounding body text and the arithmetic (dev_EAC = coef_EAC − coef_ECOWAS = −0.245 − (−3.342) = +3.098); and Table 3's EU-component-fixed coefficient reads −0.294 (SE 0.716) in the docx table but the source output (`table3_mechanical_endogeneity.tex`) gives −0.2889 (0.6612) → −0.289 (0.661), matching the abstract/Introduction/Conclusion's consistent citation of that number elsewhere in the same docx (the docx's ex-EU-denominator SE, 0.510, is likewise stale against the source's 0.4773 → 0.477). `PAPER/Draft/paper_final_draft.md` uses the source-output values for both cells; the docx itself should be corrected at the source before submission.

## Known issues found while auditing

All items from the first audit pass are resolved: `PROJ_ROOT` in both scripts now matches this repo; the `FIX_TIMEVARYING_REC_PAIRS` asymmetry (Mauritania's and Timor-Leste's intra-REC trade counting toward their own numerator but not their partners', conservative in direction) is disclosed in SI §S.2; and `fig_bloc_map.R`'s legend now blanks `rec` to `NA` outside the five African RECs before plotting, so it no longer carries CARIFORUM/PIF swatches with nothing under them.

The SADC/SACU pre-2000 coverage-gap history (donor-pool imputation tried and rejected, tested with gap zeros left in, settled on NA-drop) is disclosed in both code comments (`02_estimate_gravity.r`, Section 2) and paper SI §S.1 — consistent between the two, nothing outstanding.

Both scripts also had a fair amount of session-changelog comment bloat (dated "added this session" / incident-dated narration with no forward-looking function) trimmed out, keeping the substantive reasoning behind each design choice in place. A second pass found and removed six spots where this had crept back in: `01_build_panel.r` lines 14, 831, 1091, 1317, 1508 and `fig_bloc_map.R` line 22.

`CMA_ISO3` (`01_build_panel.r`) and `SACU_ISO3` (`02_estimate_gravity.r`) are similar-but-different country sets (rand-peg currency union vs. customs union, overlapping on LSO/NAM/SWZ but not BWA/ZAF) that could easily be assumed interchangeable — each now carries a one-line comment cross-referencing the other.

Three genuine duplication spots were consolidated after a static safety check (no R interpreter available in this environment, so verified by tracing every downstream reference by hand rather than by running the code):
- `01_build_panel.r`'s eight near-identical partner-total aggregations (total/non-EU/China/US, exports/imports) now go through a `build_partner_totals()` helper.
- `01_build_panel.r`'s two BACI annual-file readers (Section 5's main load, Section 5.5's HS-chapter reload) now share a `read_baci_annual_file()` helper for the file-path/existence-check/read step only -- the two sections still perform fully independent reads, since Section 5.5's comment block explains why there is no cached object to reuse.
- `02_estimate_gravity.r`'s China/US diversion-check block (parallel-DV fitting, share-control fitting, and the table-row assembly feeding `aux_diversion_parallel_dv.csv`) now goes through `fit_parallel_dv()`/`fit_share_control()`/`dv_rows()`/`share_rows()` helpers instead of four near-duplicated blocks.

None of the above were numeric-accuracy problems — every reported coefficient checks out against its source table. They were reproducibility/disclosure/cleanliness gaps, not correctness bugs.
