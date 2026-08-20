# Supporting Information

*For "Does Regional Integration Divert Trade from Europe? A Ratio-Regressor Critique of EU–ACP Gravity Estimates."*

*This document collects material referenced in the main text that is not required to follow the paper's argument: additional detail on two data-construction decisions (S.1–S.2), six tables reported only in summary or by cross-reference in the body (S.3), a Monte Carlo validation exercise (S.4), and an inverse-hyperbolic-sine robustness check (S.5). It is filed as online supporting material rather than as an in-text appendix, following the same convention used in Stender et al. (2021), whose comparable tables were filed the same way. Supporting Information of this kind is not counted against the journal's word limit for the article itself.*

---

## S.1 A Coverage Gap in BACI, 1995–1999

BACI contains no records for the five SACU countries before 2000, because Comtrade reported the customs union under a single code until then. The consequence extends beyond SACU: because SACU members are absent, the intra-SADC trade of Angola, the DRC, and Mozambique also reads exactly zero for 1995–1999. Every SADC member therefore shows an intra-regional share of exactly zero across those five years, while the other six groupings are continuous across the 1999–2000 boundary. Those zeros are missing data, not observed absence of integration, and leaving them in has a large effect on the pooled coefficient, since it hands the highest-integration bloc five years of artificial zeros.

Imputation from other SADC members was considered and rejected. Four of the five potential donor countries carried a different bloc's integration share, so the procedure would substitute an intra-ESA measure for an intra-SADC one. Restricting the donor pool to countries that actually carry SADC membership does not solve the problem: no such donor has positive intra-bloc trade in those years either, since they too traded with the absent SACU five. Zero cells of this kind are not imputable.

The treatment adopted instead is to drop the affected years from the reported sample entirely. Within a 1995–2021 window, 18.5 percent of SADC country-year observations on the integration measure would be missing as a result. That is why 2000, not 1995, is adopted as the baseline start year, with the wider window reported only as a robustness column (Table 8, column 2).

## S.2 REC-Accession Timing

REC membership is time-varying for eight countries in this panel, reflecting the negotiating configuration each country actually belonged to at each point in time rather than its current-day institutional affiliation. Two of these countries carry a pre-2000 NA period that only shows up in the 1995-start robustness check (Section 5.5); their actual REC transitions fall inside the 2000–2021 baseline itself. Burundi and Rwanda acceded to the EAC on 1 July 2007, coded NA before that date both within the baseline and further back into the 1995 extension. The DRC's SADC membership dates from the 17th SADC Summit in September 1998, before the baseline window opens, though its later transitions (below) fall inside it.

The remaining transitions fall inside the 2000–2021 baseline sample:

- **The DRC** carries three REC affiliations across the sample: SADC (2000–2002, its unambiguous institutional home at the time), ESA (2003–2004, the EPA-negotiating configuration it joined next), and Central Africa (2005 onward, following the switch documented in ECDPM's regional EPA brief and corroborated by the EEAS's current framing of the DRC as part of "the Central Africa configuration").
- **Kenya and Uganda** are coded NA 1995–2002 (EAC only re-entered force as a bare treaty in July 2000, with no defensible single-REC fallback before then), ESA 2003–2006 (the configuration both countries negotiated their EPA under, per the WTO's Trade Policy Review of the pre-2007 EAC region), and EAC from 2007.
- **Tanzania** is coded SADC 1995–2006, a continuous, uncontested affiliation dating to SADC's 1992 founding and corroborated by Tanzania's 2000 withdrawal from COMESA specifically because it already held both SADC and EAC memberships and judged a third redundant. It is coded EAC from 2007.
- **Somalia** is coded NA throughout the entire panel (1995–2021). Unlike the DRC, Kenya, Uganda, or Tanzania, Somalia has no unambiguous single-bloc institutional fallback to restore, since state collapse in the early 1990s is why it is a special case at all. Somalia never signed or ratified Cotonou or any of its revisions and was never part of the ESA EPA negotiating group, confirmed against the EU's own trade policy pages, tralac, ECDPM, and the EUR-Lex glossary. Its ACP relationship has instead been maintained through ad hoc EDF arrangements rather than treaty accession, which is why it remains part of the 78-country ACP universe referenced throughout the paper despite contributing no observations to any REC-based regressor.

Mauritania (ECOWAS 1995–2000 only) and Timor-Leste (PIF from 2003) round out the eight time-varying countries.

Trade with fellow bloc members during their affiliated years counts toward their own intra-REC numerator, but not toward the other members' numerators for trade with them, in the panel used throughout this paper. This asymmetry biases ECOWAS's and PIF's IT shares slightly downward, working against the stumbling-block finding, and its effect is small given the short affiliation windows involved.

A separate construction error, distinct from the accession-timing detail above, was found and corrected during review. The pipeline built each REC's intra-bloc trade pairs from a table of countries with a single, time-invariant REC assignment; because all five EAC members are time-varying with no such invariant core, that table contained no EAC entries at all, so Kenya, Uganda, and Tanzania's mutual trade was never credited as intra-EAC for any year, and Burundi and Rwanda were credited only for trade with each other after 2007. Kenya's actual 2019 intra-EAC trade share, computed directly from raw BACI records, is 8.7 percent; the panel reported exactly zero. The fix rebuilds each EAC member's intra-bloc pairs from the same time-varying membership table used elsewhere in the panel rather than the invariant-core table, which does not apply to this bloc. Re-verified against raw BACI after the fix: all five EAC members match to four decimal places, and a representative country from every other REC, including CARIFORUM as a negative control with no time-varying members, is unchanged from its pre-fix value. The EAC's mean IT share moves from 0.005 to 0.140 as a result, no longer the panel's outlier; every figure in the main text and in this document reflects the corrected panel.

**Table S.1. REC-transition timeline for the eight time-varying countries**

| Country | Years | REC assignment |
|---|---|---|
| Burundi & Rwanda | 1995–2006 | Unaffiliated (NA) |
| | 2007–2021 | EAC |
| DRC | 1995–1997 | Unaffiliated (NA) |
| | 1998–2002 | SADC |
| | 2003–2004 | ESA |
| | 2005–2021 | Central Africa |
| Kenya & Uganda | 1995–2002 | Unaffiliated (NA) |
| | 2003–2006 | ESA |
| | 2007–2021 | EAC |
| Tanzania | 1995–2006 | SADC |
| | 2007–2021 | EAC |
| Mauritania | 1995–2000 | ECOWAS |
| | 2001–2021 | Unaffiliated (NA) |
| Timor-Leste | 1995–2002 | Unaffiliated (NA) |
| | 2003–2021 | PIF |

*Dates as coded in the replication panel (BDI_RWA_REC, COD_REC, KEN_UGA_REC, TZA_REC, MRT_REC, and TLS_REC in the construction script). "Unaffiliated (NA)" years contribute no observation to any REC-based regressor. Somalia, the eighth time-varying case discussed above, is omitted from this table since it is coded NA throughout the full 1995–2021 span and so has no transition to date.*

## S.3 Online Appendix Tables

The following six tables are referenced by number in the main text and reported here in full, to keep the article within the journal's word limit. (Tables 3, 4, and 6 are reported in full in the main text, Sections 5.2 and 5.4, and are not repeated here.) All numbers below are drawn from the current project pipeline (n = 41,258 baseline throughout).

**Table 2. Magnitude of the pooled estimate**

| Contrast | Δ IT Share | % change in trade | 95% CI |
|---|---|---|---|
| +1 standard deviation | +0.128 | −25.5% | [−36.0, −13.2] |
| p25 to p75 (interquartile) | +0.141 | −27.6% | [−38.8, −14.4] |
| p10 to p90 | +0.253 | −43.9% | [−58.4, −24.3] |
| Pooled mean to ECOWAS mean | +0.020 | −4.6% | [−6.8, −2.2] |
| Pooled mean to Central Africa mean | −0.061 | +15.0% | [7.0, 23.7] |
| Pooled mean to SADC mean | +0.213 | −38.5% | [−52.2, −20.9] |
| Pooled mean to EAC mean | +0.020 | −4.5% | [−6.7, −2.2] |
| Pooled mean to ESA mean | −0.077 | +19.1% | [8.8, 30.4] |
| Pooled mean to CARIFORUM mean | +0.030 | −6.7% | [−10.0, −3.3] |
| Pooled mean to PIF mean | −0.075 | +18.7% | [8.6, 29.8] |

*PPML baseline (Table 1, column 2): β̂ = −2.287, SE = 0.604, clustered by ACP country. % change = 100(exp(β̂·Δ) − 1). All contrasts lie inside the observed support of IT Share; none should be read as independent evidence beyond the headline coefficient, since all are monotone transformations of it.*

**Table 5. Naive IT share and EPA effects by trade direction**

| | (1) Total bilateral | (2) ACP exports to EU | (3) EU exports to ACP | (4) EU exports + GDP/pop | (5) ACP exports (ex-EU denom.) | (6) EU exports (ex-EU denom.) |
|---|---|---|---|---|---|---|
| IT Share | −2.287*** (0.604) | −2.509** (0.962) | −2.016*** (0.454) | −1.747*** (0.498) | | |
| IT Share (ex-EU denom.) | | | | | 0.803 (0.714) | −1.182*** (0.307) |
| EPA (=1 in force) | −0.046 (0.067) | 0.035 (0.116) | −0.126** (0.061) | −0.092 (0.063) | 0.093 (0.107) | −0.126** (0.059) |
| Observations | 41,258 | 41,258 | 41,258 | 40,432 | 41,258 | 41,258 |

*PPML with EU-partner by year and ACP-country fixed effects, gravity controls (distance, common language, colonial tie) included in every column. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05. Column (4) adds ACP GDP and population and loses observations to WDI coverage. Columns (5)–(6) use the pooled ex-EU share, the same construction as Table 3's ex-EU-denominator column, split here by direction of trade rather than built separately for each direction. For a share built only from each direction's own trade flows, see Table 10. The naive IT Share coefficients in columns (2)–(3) are discussed in Section 5.3; the directional EPA asymmetry in column (3) versus column (2) is discussed in Section 5.4.*

**Table 7. Robustness to estimator and measurement choice**

| | PPML | NB-PML | OLS ln(trade) | OLS ln(1+trade) | IT Intensity | +GDP/pop | +EU HHI | +Export HHI | +Currency peg | +GDP p.c. gap |
|---|---|---|---|---|---|---|---|---|---|---|
| IT Share | −2.287*** (0.604) | −2.284*** (0.531) | −1.673*** (0.458) | −1.516*** (0.421) | | −1.768*** (0.567) | −2.236*** (0.596) | −2.170*** (0.643) | −3.159*** (0.765) | −1.940*** (0.584) |
| IT Intensity | | | | | −0.0072** (0.0033) | | | | | |
| Observations | 41,258 | 41,258 | 38,559 | 41,258 | 41,258 | 40,432 | 41,258 | 41,258 | 41,258 | 40,432 |

*Dependent variable: bilateral trade flow, PPML unless noted (columns 3–4 OLS). Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. IT Intensity rescales IT Share by the REC's share of world trade and does not address the denominator problem in Table 3; it is reported alongside the other robustness checks rather than as an independent test. Column "+Currency peg" interacts IT Share with six currency-union flags individually (CEMAC, WAEMU, Comoros: EUR pegs; CMA, ECCU, Pacific dollarization: not EU-pegged); its own IT Share coefficient is not comparable to the other columns' since adding six interaction terms reallocates variance across them. Two of the six individual peg interactions clear the 5% threshold: CEMAC at +6.593 (SE 2.158) and CMA at +1.679 (SE 0.841); Pacific dollarization is significant at −41.92 (SE 21.12, p<0.05). Column "+GDP p.c. gap" adds a Linder-type EU–ACP GDP-per-capita gap, which itself enters at −0.454 (SE 0.154).*

**Table 8. Robustness to sample restriction**

| | Baseline | From 1995 | From 2007 | Excl. S. Africa | Excl. Nigeria | Excl. SOM+ERI | Excl. SACU | Excl. GBR | Africa only | Log-spec sample |
|---|---|---|---|---|---|---|---|---|---|---|
| IT Share | −2.287*** (0.604) | −2.555*** (0.639) | −1.754*** (0.519) | −2.150*** (0.564) | −1.927*** (0.540) | −2.287*** (0.605) | −1.954*** (0.626) | −2.042*** (0.580) | −2.164*** (0.662) | −2.468*** (0.643) |
| Observations | 41,258 | 45,731 | 31,388 | 40,710 | 40,710 | 40,710 | 38,518 | 39,684 | 24,863 | 40,898 |

*Dependent variable: bilateral trade flow, PPML. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. The "From 1995" column reintroduces the SACU coverage gap discussed in S.1. The "Log-spec sample" column restricts to the 40,898 observations with non-missing ln(Intra-REC trade) and ln(Extra-regional non-EU trade), the same restriction Table 4's log-decomposition rows require. This confirms the headline coefficient does not depend on that restriction. Period-subsample estimates: 2000–2007, −2.656 (SE 0.723, n = 11,922); 2008–2014, −2.002 (SE 0.713, n = 14,516); 2015–2021, +0.114 (SE 0.797, not significant, n = 14,820), reported in full in Section 5.5.*

**Table 9. Diversion check: China and US as substitute outcome, and China's and US's trade share as a covariate**

| Partner / check | Term | Coefficient | SE | n | t |
|---|---|---|---|---|---|
| China (outcome) | ln(Intra-REC trade) | −0.045 | 0.038 | 1,609 | −1.19 |
| China (outcome) | ln(Extra-regional non-EU trade) | +0.950*** | 0.141 | 1,609 | 6.76 |
| United States (outcome) | ln(Intra-REC trade) | +0.035 | 0.085 | 1,631 | 0.41 |
| United States (outcome) | ln(Extra-regional non-EU trade) | +0.901*** | 0.119 | 1,631 | 7.59 |
| EU trade (China-share control) | ln(Intra-REC trade) | +0.117** | 0.053 | 40,898 | 2.21 |
| EU trade (China-share control) | ln(Extra-regional non-EU trade) | +0.297*** | 0.061 | 40,898 | 4.85 |
| EU trade (China-share control) | China trade share | −0.836* | 0.465 | 40,898 | −1.80 |
| EU trade (US-share control) | ln(Intra-REC trade) | +0.119** | 0.051 | 40,898 | 2.34 |
| EU trade (US-share control) | ln(Extra-regional non-EU trade) | +0.388*** | 0.078 | 40,898 | 4.96 |
| EU trade (US-share control) | US trade share | −1.735*** | 0.436 | 40,898 | −3.98 |

*Rows 1–4: disjoint decomposition (Section 4.3, construction "N = I + X") reapplied to a country-year panel with China's or the United States' bilateral trade with each ACP country substituted as the dependent variable in place of EU trade. Standard errors clustered by ACP country. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. Gravity controls and ACP-country fixed effects included; a partner-year fixed effect replaces the EU-partner × year effect used elsewhere, since China and the US are each a single partner. Rows 5–10 ask the question from the other direction, on the standard EU-partner × year / ACP-country panel, restricted to the 40,898-observation log-spec sample (the same restriction Table 3's log-decomposition columns and Table 4's log-decomposition rows require): does the EU-side expansion elasticity (Table 4's Disjoint Bilateral row, ln(Intra-REC trade) = +0.133, SE 0.053) survive once China's, or the US's, own rising trade share enters directly as a covariate rather than being examined as a separate outcome. It does in both cases, at +0.117 (SE 0.053) with China's trade share controlled and +0.119 (SE 0.051) with the US's, with each partner's own trade share entering negatively. China's share is at −0.836 (SE 0.465, p<0.10), the US's at −1.735 (SE 0.436, p<0.01), a larger effect with a tighter standard error.*

**Table 10. Direction-matched robustness: holding the EU component fixed, and a direction-matched ex-EU share**

| | (1) ACP exports (EU fixed) | (2) EU exports (EU fixed) | (3) ACP exports (direction-matched ex-EU share) | (4) EU exports (direction-matched ex-EU share) |
|---|---|---|---|---|
| IT Share (EU component fixed) | 1.212 (0.969) | −1.554*** (0.429) | | |
| IT Share (ex-EU, export-matched) | | | 0.359 (0.349) | |
| IT Share (ex-EU, import-matched) | | | | −1.180*** (0.261) |
| Observations | 41,258 | 41,258 | 41,258 | 41,258 |

*PPML, EU-partner × year and ACP-country fixed effects, standard errors clustered by ACP country in parentheses. \*\*\* p<0.01. Columns (1)–(2) hold the EU component of the denominator at each country's own mean, comparable in magnitude to Table 3's pooled baseline. Columns (3)–(4) use an ex-EU share built only from the matching direction's own trade flows (export-side for column 3, import-side for column 4; `it_share_exeu_x` and `it_share_exeu_m` in the replication code, respectively). This is a different, more narrowly matched construction from the pooled ex-EU share used in Table 5's ex-EU-denominator columns, despite the similar name. The Overlapping and Side-matched log-decomposition versions of these same two directions are Table 4's own rows and are not repeated here. In both constructions, the ACP-exports-to-EU direction stays statistically indistinguishable from zero while the EU-exports-to-ACP direction retains a significant negative coefficient. This is an asymmetry in the opposite direction from Table 4's side-matched result, discussed in Section 5.3.*

## S.4 Monte Carlo Simulation Under a True Null

To evaluate whether the naive share coefficient's negative sign is a mechanical artifact rather than evidence of diversion, panel data were simulated in which intra-regional and non-EU trade are generated independently of EU trade by construction, a true null with neither diversion nor expansion built in. The exercise is repeated across a grid of average EU trade shares to test whether the mechanical bias scales with the EU's share of total trade, as Section 4.3 predicts algebraically. Table S.2 reports the results.

**Table S.2. Monte Carlo simulation under a true null DGP**

| EU trade share (mean) | Naive: mean β | Naive: % false reject | Fixed-share: mean β | Fixed-share: % false reject | Disjoint: mean β | Disjoint: % significant |
|---|---|---|---|---|---|---|
| 0.05 | −0.368 | 32.5% | −0.010 | 4.5% | +0.0044 | 10.0% |
| 0.10 | −0.446 | 72.5% | −0.037 | 8.0% | −0.0013 | 9.0% |
| 0.20 | −0.545 | 98.5% | −0.042 | 10.5% | −0.0004 | 12.5% |
| 0.30 | −0.695 | 100.0% | −0.083 | 26.0% | −0.0006 | 23.5% |
| 0.40 | −0.890 | 100.0% | −0.158 | 49.0% | −0.0011 | 26.5% |
| 0.50 | −1.137 | 100.0% | −0.263 | 80.5% | +0.0008 | 29.0% |

*78 simulated countries × 21 years, 200 replications per EU-share grid point (seed 20260818). intra_trade and non_eu_trade are drawn independently of eu_trade (country and year fixed effects, Poisson-distributed counts); eu_share_mean sets the grid point for the average EU trade share in the DGP. "Naive" and "Fixed-share" report the coefficient on it_share and it_share_fixeu, respectively, from a PPML regression of eu_trade on the share with country and year fixed effects; "% false reject" is the share of the 200 replications in which the estimated coefficient is negative and significant at the 5% level, a false "trade diversion" finding under a DGP with no diversion by construction. "Disjoint" reports the coefficient on log(intra-regional trade) from a PPML regression of eu_trade on log(intra_trade) and log(non_eu_trade) (the disjoint decomposition, Section 4.3); "% significant" is the share of replications significant at the 5% level in either direction.*

## S.5 Inverse-Hyperbolic-Sine Robustness Check

The disjoint and clean-overlap component specifications in Tables 3 and 4 use log-transformed regressors, which drop the 360 country-years (about 1 percent of the sample) with zero intra-regional or non-EU trade in a given year, a much smaller share than before the EAC intra-REC pair-construction fix (S.2), which had left most of the EAC's 75 country-years reading as zero-trade rather than the small positive values BACI actually records. Table S.3 reports both specifications re-estimated with the inverse hyperbolic sine transformation, asinh(x) = ln(x + sqrt(x² + 1)), which is defined at zero and so retains the full sample. The result does not confirm the log-transform coefficients: under IHS, the intra-REC coefficient is close to zero and not statistically distinguishable from it in either specification (asinh_intra = −0.000, SE 0.011, t = −0.02 in the clean/overlapping form; +0.008, SE 0.012, t = 0.67 in the disjoint form), in contrast to the significant positive coefficients Tables 3 and 4 report under the log transform. The ratio restriction is still rejected in both specifications, by a wide margin, but that rejection is now carried almost entirely by the denominator term (asinh_noneu / asinh_extra), not by a robust positive numerator effect. This is reported as a genuine, honest finding rather than smoothed over: the positive intra-REC result is sensitive to functional form once zero-trade country-years are retained, and should not be read as confirmed under IHS.

**Table S.3. Inverse-hyperbolic-sine robustness check**

| Specification (IHS) | β intra | (SE) | β den | (SE) | Sum | (SE) | t | n |
|---|---|---|---|---|---|---|---|---|
| Overlapping (clean, IHS) | −0.000 | (0.011) | +0.401 | (0.069) | +0.401 | (0.072) | +5.58 | 42,714 |
| Disjoint (IHS) | +0.008 | (0.012) | +0.336 | (0.065) | +0.344 | (0.068) | +5.05 | 42,714 |

*Inverse-hyperbolic-sine robustness check: asinh(x) replaces log(x), retaining zero-trade country-years the log specifications drop. Standard errors clustered by ACP country. β_intra is not statistically distinguishable from zero in either specification; the restriction rejection is carried by the denominator (asinh_noneu / asinh_extra) coefficient. Compare against Table 3's log-decomposition (non-EU) column and Table 4's Disjoint / Bilateral row, both of which report a significant positive intra-REC coefficient under the log transform.*
