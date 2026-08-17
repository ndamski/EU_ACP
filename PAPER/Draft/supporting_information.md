# Supporting Information

*For "Does Regional Integration Divert Trade from Europe? A Ratio-Regressor Critique of EU–ACP Gravity Estimates."*

*This document collects material referenced in the main text that is not required to follow the paper's argument: additional detail on two data-construction decisions (S.1–S.2), and six tables reported only in summary or by cross-reference in the body (S.3). It is filed as online supporting material rather than as an in-text appendix, following the same convention used in Stender et al. (2021), whose comparable tables were filed the same way. Supporting Information of this kind is not counted against the journal's word limit for the article itself.*

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

Mauritania (ECOWAS 1995–2000 only) and Timor-Leste (PIF from 2003) round out the eight time-varying countries. These corrections are reflected in Table 0 and in every REC-interaction coefficient reported in Section 5.4.

## S.3 Online Appendix Tables

The following six tables are referenced by number in the main text and reported here in full, to keep the article within the journal's word limit. (Tables 3, 4, and 6 are reported in full in the main text, Sections 5.2 and 5.4, and are not repeated here.) All numbers below are drawn from the current project pipeline (n = 41,258 baseline throughout).

**Table 2. Magnitude of the pooled estimate**

| Contrast | Δ IT Share | % change in trade | 95% CI |
|---|---|---|---|
| +1 standard deviation | +0.130 | −27.6% | [−38.6, −14.5] |
| p25 to p75 (interquartile) | +0.139 | −29.2% | [−40.7, −15.4] |
| p10 to p90 | +0.255 | −46.9% | [−61.6, −26.5] |
| Pooled mean to ECOWAS mean | +0.027 | −6.5% | [−9.7, −3.2] |
| Pooled mean to Central Africa mean | −0.055 | +14.5% | [6.8, 22.7] |
| Pooled mean to SADC mean | +0.220 | −42.0% | [−56.2, −23.3] |
| Pooled mean to EAC mean | −0.108 | +30.8% | [13.9, 50.2] |
| Pooled mean to ESA mean | −0.070 | +18.9% | [8.8, 30.0] |
| Pooled mean to CARIFORUM mean | +0.037 | −8.8% | [−13.0, −4.4] |
| Pooled mean to PIF mean | −0.068 | +18.5% | [8.6, 29.3] |

*PPML baseline (Table 1, column 2): β̂ = −2.482, SE = 0.651, clustered by ACP country. % change = 100(exp(β̂·Δ) − 1). All contrasts lie inside the observed support of IT Share; none should be read as independent evidence beyond the headline coefficient, since all are monotone transformations of it.*

**Table 5. Naive IT share and EPA effects by trade direction**

| | (1) Total bilateral | (2) ACP exports to EU | (3) EU exports to ACP | (4) EU exports + GDP/pop | (5) ACP exports (ex-EU denom.) | (6) EU exports (ex-EU denom.) |
|---|---|---|---|---|---|---|
| IT Share | −2.482*** (0.651) | −2.616** (1.019) | −2.258*** (0.482) | −1.775*** (0.596) | | |
| IT Share (ex-EU denom.) | | | | | 0.890 (0.740) | −1.298*** (0.326) |
| EPA (=1 in force) | −0.044 (0.066) | 0.038 (0.116) | −0.123** (0.060) | −0.099 (0.065) | 0.094 (0.106) | −0.125** (0.059) |
| Observations | 41,258 | 41,258 | 41,258 | 38,955 | 41,258 | 41,258 |

*PPML with EU-partner by year and ACP-country fixed effects, gravity controls (distance, common language, colonial tie) included in every column. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05. Column (4) adds ACP GDP and population and loses observations to WDI coverage. Columns (5)–(6) use the pooled ex-EU share, the same construction as Table 3's ex-EU-denominator column, split here by direction of trade rather than built separately for each direction. For a share built only from each direction's own trade flows, see Table 10. The naive IT Share coefficients in columns (2)–(3) are discussed in Section 5.3; the directional EPA asymmetry in column (3) versus column (2) is discussed in Section 5.4.*

**Table 7. Robustness to estimator and measurement choice**

| | PPML | NB-PML | OLS ln(trade) | OLS ln(1+trade) | IT Intensity | +GDP/pop | +EU HHI | +Export HHI | +Currency peg | +GDP p.c. gap |
|---|---|---|---|---|---|---|---|---|---|---|
| IT Share | −2.482*** (0.651) | −2.449*** (0.544) | −1.871*** (0.456) | −1.635*** (0.419) | | −1.799*** (0.662) | −2.422*** (0.648) | −2.365*** (0.701) | −3.847*** (0.771) | −2.070*** (0.699) |
| IT Intensity | | | | | −0.011** (0.006) | | | | | |
| Observations | 41,258 | 41,258 | 38,559 | 41,258 | 41,258 | 38,955 | 41,258 | 41,258 | 41,258 | 38,955 |

*Dependent variable: bilateral trade flow, PPML unless noted (columns 3–4 OLS). Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. IT Intensity rescales IT Share by the REC's share of world trade and does not address the denominator problem in Table 3; it is reported alongside the other robustness checks rather than as an independent test. Column "+Currency peg" interacts IT Share with six currency-union flags individually (CEMAC, WAEMU, Comoros: EUR pegs; CMA, ECCU, Pacific dollarization: not EU-pegged); its own IT Share coefficient is not comparable to the other columns' since adding six interaction terms reallocates variance across them. Two of the six individual peg interactions clear the 5% threshold: CEMAC at +7.316 (SE 2.193) and CMA at +2.337 (SE 0.852); Pacific dollarization is marginal at −41.20 (SE 21.11, p<0.10). Column "+GDP p.c. gap" adds a Linder-type EU–ACP GDP-per-capita gap, which itself enters at −0.438 (SE 0.159).*

**Table 8. Robustness to sample restriction**

| | Baseline | From 1995 | From 2007 | Excl. S. Africa | Excl. Nigeria | Excl. SOM+ERI | Excl. SACU | Excl. GBR | Africa only | Log-spec sample |
|---|---|---|---|---|---|---|---|---|---|---|
| IT Share | −2.482*** (0.651) | −2.741*** (0.675) | −1.751*** (0.529) | −2.262*** (0.624) | −2.163*** (0.594) | −2.482*** (0.652) | −2.019*** (0.702) | −2.223*** (0.632) | −2.373*** (0.732) | −2.495*** (0.650) |
| Observations | 41,258 | 45,731 | 31,388 | 40,710 | 40,710 | 40,710 | 38,518 | 39,684 | 24,863 | 39,659 |

*Dependent variable: bilateral trade flow, PPML. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. The "From 1995" column reintroduces the SACU coverage gap discussed in S.1. The "Log-spec sample" column restricts to the 39,659 observations with non-missing ln(Intra-REC trade) and ln(Extra-regional non-EU trade), the same restriction Table 4's log-decomposition rows require. This confirms the headline coefficient does not depend on that restriction. Period-subsample estimates: 2000–2007, −2.930 (SE 0.729, n = 11,922); 2008–2014, −2.037 (SE 0.722, n = 14,516); 2015–2021, +0.107 (SE 0.827, not significant, n = 14,820), reported in full in Section 5.5.*

**Table 9. Diversion check: China and US as substitute outcome, and China's and US's trade share as a covariate**

| Partner / check | Term | Coefficient | SE | n | t |
|---|---|---|---|---|---|
| China (outcome) | ln(Intra-REC trade) | −0.047 | 0.039 | 1,564 | −1.19 |
| China (outcome) | ln(Extra-regional non-EU trade) | +0.953*** | 0.142 | 1,564 | 6.73 |
| United States (outcome) | ln(Intra-REC trade) | +0.035 | 0.086 | 1,586 | 0.40 |
| United States (outcome) | ln(Extra-regional non-EU trade) | +0.896*** | 0.118 | 1,586 | 7.59 |
| EU trade (China-share control) | ln(Intra-REC trade) | +0.118** | 0.053 | 39,659 | 2.23 |
| EU trade (China-share control) | ln(Extra-regional non-EU trade) | +0.303*** | 0.063 | 39,659 | 4.82 |
| EU trade (China-share control) | China trade share | −0.845* | 0.471 | 39,659 | −1.80 |
| EU trade (US-share control) | ln(Intra-REC trade) | +0.119** | 0.051 | 39,659 | 2.33 |
| EU trade (US-share control) | ln(Extra-regional non-EU trade) | +0.391*** | 0.079 | 39,659 | 4.95 |
| EU trade (US-share control) | US trade share | −1.732*** | 0.440 | 39,659 | −3.94 |

*Rows 1–4: disjoint decomposition (Section 4.3, construction "N = I + X") reapplied to a country-year panel with China's or the United States' bilateral trade with each ACP country substituted as the dependent variable in place of EU trade. Standard errors clustered by ACP country. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. Gravity controls and ACP-country fixed effects included; a partner-year fixed effect replaces the EU-partner × year effect used elsewhere, since China and the US are each a single partner. Sample sizes (1,564/1,586) are lower than the pre-REC-fix version (1,652/1,674), consistent with Somalia's and others' removal from REC-based observations. Rows 5–10 ask the question from the other direction, on the standard EU-partner × year / ACP-country panel, restricted to the 39,659-observation log-spec sample (the same restriction Table 3's log-decomposition columns and Table 4's log-decomposition rows require): does the EU-side expansion elasticity (Table 4's Disjoint Bilateral row, ln(Intra-REC trade) = +0.133, SE 0.053) survive once China's, or the US's, own rising trade share enters directly as a covariate rather than being examined as a separate outcome. It does in both cases, at +0.118 (SE 0.053) with China's trade share controlled and +0.119 (SE 0.051) with the US's, with each partner's own trade share entering negatively. China's share is at −0.845 (SE 0.471, p<0.10), the US's at −1.732 (SE 0.440, p<0.01), a larger effect with a tighter standard error.*

**Table 10. Direction-matched robustness: holding the EU component fixed, and a direction-matched ex-EU share**

| | (1) ACP exports (EU fixed) | (2) EU exports (EU fixed) | (3) ACP exports (direction-matched ex-EU share) | (4) EU exports (direction-matched ex-EU share) |
|---|---|---|---|---|
| IT Share (EU component fixed) | 1.362 (1.009) | −1.738*** (0.462) | | |
| IT Share (ex-EU, export-matched) | | | 0.471 (0.374) | |
| IT Share (ex-EU, import-matched) | | | | −1.252*** (0.268) |
| Observations | 41,258 | 41,258 | 41,258 | 41,258 |

*PPML, EU-partner × year and ACP-country fixed effects, standard errors clustered by ACP country in parentheses. \*\*\* p<0.01. Columns (1)–(2) hold the EU component of the denominator at each country's own mean, comparable in magnitude to Table 3's pooled baseline. Columns (3)–(4) use an ex-EU share built only from the matching direction's own trade flows (export-side for column 3, import-side for column 4; `it_share_exeu_x` and `it_share_exeu_m` in the replication code, respectively). This is a different, more narrowly matched construction from the pooled ex-EU share used in Table 5's ex-EU-denominator columns, despite the similar name. The Overlapping and Side-matched log-decomposition versions of these same two directions are Table 4's own rows and are not repeated here. In both constructions, the ACP-exports-to-EU direction stays statistically indistinguishable from zero while the EU-exports-to-ACP direction retains a significant negative coefficient. This is an asymmetry in the opposite direction from Table 4's side-matched result, discussed in Section 5.3.*
