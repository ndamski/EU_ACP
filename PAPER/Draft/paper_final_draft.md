# Does Regional Integration Divert Trade from Europe? A Ratio-Regressor Critique of EU–ACP Gravity Estimates

## Abstract

Gravity models routinely measure regional integration as a share of total trade and read a negative coefficient as evidence of trade diversion. This paper shows the share form imposes a restriction on the regression, decisively rejected in the EU–ACP setting. Using PPML on a 2000–2021 panel of 78 ACP countries and the EU, the share attracts a large, precisely estimated negative coefficient, −2.287. Holding the EU's trade share fixed, rather than letting it move with the regressor, attenuates the arithmetic link, collapsing the coefficient to −0.289, statistically indistinguishable from zero. Estimated directly rather than as a ratio, intra-regional trade's own coefficient is positive and significant, +0.133, not evidence of diversion, and consistent with expansion. A parallel check using China's and the United States' bilateral trade as the outcome shows the same pattern. The denominator contains the dependent variable, and no specification severing that link recovers a negative effect in the pooled sample, though one directional split does, in a share-form construction that only partially removes the mechanical link.

## 1. Introduction

Since the Cotonou Partnership Agreement in 2000, the European Union has pursued two goals at once. It has deepened preferential trade ties with African, Caribbean, and Pacific countries and has also pushed those countries to strengthen their own regional economic communities. By 2021, Economic Partnership Agreements, the reciprocal free trade arrangements the EU negotiates with ACP regional blocs rather than individual countries, had been applied at least in part in six of the seven ACP regions, together covering most ACP countries and hundreds of billions of dollars in annual trade. Over the same period, intra-REC trade shares rose across most ACP blocs, as regional integration strengthened through tariff cuts, common external tariffs, and corridor infrastructure. If growing intra-bloc trade displaces demand for European goods rather than expanding overall import demand, the EU's investment in EPA negotiations works against its own trade goals.

The literature on preferential trade agreements has long debated whether regional blocs are building blocks or stumbling blocks toward broader liberalization. Most empirical work looks at North–North or North–South agreements. Whether South–South integration crowds out or complements a concurrent deal with a major Northern partner is a different question, and one that has received less attention than North–North or North–South analyses. This paper sets out to answer it, using EU–ACP trade as the setting. The standard way of asking the question turned out not to answer it at all.

Measured the conventional way, as the share of an ACP country's total trade conducted within its own bloc, regional integration carries a large coefficient of −2.287 (SE 0.604). It is significant at the one percent level under every clustering scheme tested, stable across estimators, and survives dropping any single bloc, country, or time window. This result looks like strong evidence of a stumbling block, but the share used to produce it is a ratio, and its denominator, total trade, contains bilateral EU trade with that country, the same magnitude the dependent variable measures, as one of its components. Because of that overlap, part of the coefficient is mechanical rather than economic, and this paper's contribution is to show that this standard measure's coefficient is so contaminated by the ratio's own arithmetic that a negative estimate cannot be interpreted as evidence of diversion, regardless of what the actual relationship between regional integration and EU trade turns out to be.

An alternative specification that holds each country's own average EU-trade share fixed, instead of letting it move with the regressor, attenuates the arithmetic link and the coefficient falls from −2.287 to −0.289, a residual bias a Monte Carlo exercise under a true null puts at around −0.04 at the sample's actual EU-share level (Supporting Information, Table S.2). A further specification that estimates intra-regional trade's own coefficient directly, with no ratio at all, turns the coefficient positive, at +0.133. These are distinct tests rather than successive corrections to a single model: the first keeps the ratio form and changes what its denominator holds fixed, while the second abandons the ratio altogether. That both moves point away from the naive share coefficient, using two different corrections, is the paper's central empirical fact.

Section 5 pursues this further. Estimating the ratio's components freely, rather than folding them into a share, rejects the restriction outright. Matching each direction of trade to its own components shows that an apparent asymmetry in the naive share form was itself a byproduct of the ratio, not a real directional difference. A check entirely outside the EU relationship substitutes China's and the United States' bilateral trade for the EU's as the outcome, and separately adds each partner's trade share as a covariate in the EU regression, and both versions show the same null. Any gravity specification that regresses trade on an intra-regional share risks the same arithmetic. The size of that risk depends on how large a share of a country's total trade is conducted with whichever partner serves as the dependent variable. Pooled across all country-years, the EU accounts for roughly one-fifth of that trade on average, though the share runs from 0.074 for PIF to 0.339 for Central Africa across blocs (Section 4.2).

Section 2 covers institutional background, Section 3 reviews the literature, and Section 4 describes the data, derives the restriction, and sets out the estimating strategy. Sections 5 and 6 present results and conclusions.

## 2. Institutional Background

### The Cotonou Partnership Agreement

The Cotonou Partnership Agreement, signed in June 2000 and applied in 2003, superseded the Lomé Conventions that had governed EU–ACP relations since 1975. Under Lomé, ACP countries received non-reciprocal preferential access to European markets, an arrangement that conflicted with the WTO's non-discrimination rules and was permitted only through temporary waivers. Cotonou's central innovation was to commit the parties to negotiating Economic Partnership Agreements, reciprocal free trade arrangements with ACP regional groupings, to replace the Lomé preferences, which nonetheless remained in force until 2008 and, for many countries, until an EPA was concluded.

The EU chose to negotiate at the REC level. By requiring ACP blocs to negotiate multilaterally, the EU tied the terms of market access to the depth of each region's internal cohesion, so the relationship between intra-REC integration and EU–ACP trade reflects institutional design as much as economics. The reciprocity requirement added a further asymmetry, since ACP countries were now required to open their own markets to EU goods, something they had never had to do under Lomé, and that burden fell unevenly across blocs.

### ACP Regional Groupings and EPA Status

The ACP group is organized here into the seven Regional Economic Communities as they appear in EPA negotiations, rather than by the overlapping memberships many ACP countries hold. Five of the seven are African. Membership is time-varying for eight countries whose REC affiliation changed within the sample window (MRT, TLS, BDI, RWA, COD, KEN, UGA, TZA). Table 0 reports each REC's full membership across the 2000–2021 sample, with transitions documented in the footnote and in full in the Supporting Information. Somalia is part of the 78-country ACP universe used throughout but is assigned to no REC in any year (see footnote).

**Table 0. ACP Regional Economic Communities: membership and EPA status**

| REC | Members (n) | Key members | EPA status |
|---|---|---|---|
| ECOWAS | 16 | Nigeria, Ghana, Côte d'Ivoire, Senegal | Bilateral only: Côte d'Ivoire, Ghana (2016) |
| Central Africa | 8 | Cameroon, Gabon, DRC | Cameroon only (Aug 2014) |
| SADC | 9 | South Africa, Botswana, Mozambique | 6 applied (Oct 2016†); Angola, DRC untreated |
| EAC | 5 | Kenya, Tanzania, Uganda | Signed Sep 2016, never applied |
| ESA | 14 | Mauritius, Madagascar, Zimbabwe | 4 signed, applied May 2012; Comoros added (Feb 2019) |
| CARIFORUM | 15 | Jamaica, Trinidad and Tobago, Dominican Republic | 14 of 15 (Dec 2008); Haiti signed, never applied |
| PIF | 15 | Papua New Guinea, Fiji | PNG, Fiji only (Dec 2009 / Jul 2014) |

Counts include countries whose REC affiliation is time-varying within the 2000–2021 sample (ECOWAS/Mauritania, SADC/Central Africa/ESA's shared transitions for the DRC, Kenya, Uganda, and Tanzania, PIF/Timor-Leste); full transition-by-transition detail and sourcing is in Supporting Information S.2. Somalia is part of the 78-country ACP universe but assigned to no REC in any year, since it never signed or ratified Cotonou (S.2). † SADC's EPA entered provisional application 10 October 2016 for Botswana, Lesotho, Eswatini, Namibia, and South Africa; Mozambique followed on 4 February 2018, confirmed directly against EUR-Lex's summary text and corroborated by a Council document.

**Figure 1. ACP Regional Economic Communities, African blocs**

Shows the five African RECs (ECOWAS, Central Africa, SADC, EAC, ESA) by current-day membership; each country is mapped to its latest coded REC rather than its time-varying panel affiliation, since a membership map is a point-in-time picture. CARIFORUM and PIF are omitted here and reported in tabular form in Table 0. Country boundaries from Natural Earth (rnaturalearth).

The resulting treatment intensity varies sharply across blocs: 59 percent of CARIFORUM country-years carry an in-force EPA, against 21 percent for SADC, 17 percent for ESA, 6 percent for PIF, 5 percent for Central Africa, 4 percent for ECOWAS, and none for the EAC. These shares are computed over the panel's actual country-years rather than static bloc membership, so they reflect the provisional-application dates in the footnote above rather than a simple count of EPA-negotiating members. Integration itself varies just as sharply, and independently of EPA status: bloc-mean IT shares (Section 4.2) run from 0.333 for SADC and 0.150 for CARIFORUM down to 0.043 for ESA, so a bloc's depth of internal integration is not simply a proxy for how far its EPA has progressed.

## 3. Literature Review

Preferential trade agreements have long been debated as either building blocks or stumbling blocks toward broader liberalization. The empirical record on ACP trade and EPA implementation offers a second, more specific literature, reviewed below, that this paper also draws on.

### Building Blocks or Stumbling Blocks?

Bhagwati (1993) stated the building-block/stumbling-block tension most sharply, and his formulation set the terms of a debate that persists today. Baldwin and Venables (1995) then gave the debate its systematic theoretical treatment, and their survey of regional integration's welfare effects remains the standard reference for weighing trade creation against diversion in customs unions and common markets. In the building-block view, regional integration reduces transaction costs, aligns regulatory environments, and creates larger markets that raise total trade with all partners including outsiders. The stumbling-block view holds the opposite: regional preferences redirect trade toward bloc partners and away from more efficient outside suppliers, so deeper regional integration comes at non-members' expense rather than raising trade overall. Part of the building-block case rests on efficiency gains from specialization, not reduced trade costs alone, and Baldwin and Venables's welfare survey treats this specialization channel alongside trade creation and diversion, rather than as a separate story.

The empirical record leans toward the building-block view. Freund and Ornelas (2010) offer the most comprehensive review and reach a cautious endorsement: regional agreements tend to be building blocks, neither systematically erecting new barriers to non-members nor derailing multilateral progress. Baier and Bergstrand (2007) show that FTAs approximately double members' bilateral trade over time once endogeneity is addressed, though that estimate alone cannot separate trade creation from trade diversion, since it speaks only to trade among members. Baier, Yotov, and Zylkin (2019) find that this aggregate picture conceals substantial heterogeneity, with deep agreements generating larger gains than shallow ones.

The WTO's own track record has faced similar scrutiny. Rose (2004) found that formal WTO membership had no detectable effect on bilateral trade. Frankel, Stein, and Wei (1995) argued that South–South trading blocs are structurally more prone to trade diversion than North–North counterparts. Agreements between developed economies integrate partners with modest efficiency gaps and substantial complementarity, so reorientation toward bloc partners tends to expand rather than displace efficient sourcing. South–South arrangements integrate economies at comparable and often limited development levels, where preferential partners are rarely more efficient than global alternatives.

Urata and Okabe (2014), using a product-level gravity design across 67 countries and 20 product categories, find that RTAs among developing countries generate more trade diversion than RTAs among developed ones. They trace the pattern to the higher external tariffs developing-country blocs tend to retain against non-members. Frankel, Stein, and Wei's prediction, and Urata and Okabe's evidence for it, together form the natural prior for the ACP setting, part of why a large negative share coefficient is easy to accept without scrutiny.

### ACP Trade and EPA Studies

The gravity literature on ACP trade is fragmented, mirroring the institutional diversity of the grouping. Carrère (2004) found positive intra-bloc effects from African regional agreements alongside significant diversion from extra-African partners. Afesorgbor (2017) examines the trade effects of African regional agreements and reaches broadly compatible conclusions about the coexistence of creation and diversion. Nguyen (2019) tests for aggregate diversion across regional agreements without separating the North–South and South–South channels.

On the EPA side specifically, Rodrik (2018) argues that modern trade agreements reach into regulatory harmonization and domestic policy commitments that developing-country institutions are often ill-equipped to deliver. Combined with the reciprocity requirement under Cotonou, this mismatch calls into question whether EPAs generate the trade gains their design assumes. Stender et al. (2021) confirm this skepticism empirically, finding no general increase in total EU–ACP trade following EPA implementation. The net-null EPA result reported in Section 5.4 below is consistent with theirs. That section also finds a directional pattern their aggregate specification would not have detected: EPAs show no net effect on total trade, but a significant negative effect specifically on EU exports to ACP markets, a detail that would be invisible in a specification that pools both directions without allowing for directional heterogeneity.

The studies surveyed here do not ask how the depth of South–South integration reshapes the terms of a concurrent preferential relationship with a major Northern partner. Several building-block studies examine members' own trade and treat outsiders as secondary, though Carrère (2004) is an exception in quantifying extra-African diversion directly. Most ACP gravity work keeps the North–South and South–South channels apart rather than joining them, with Nguyen (2019) a partial exception in testing aggregate diversion without separating the two. This paper takes up that combination, along with a second, more consequential gap in how the share-form measure itself has been used: such measures are common throughout the literature, but the arithmetic relationship between the measure and the dependent variable is rarely examined. That omission affects every strand relying on a share-form integration regressor, including the building-block question at the center of this paper.

## 4. Data and Methodology

### 4.1 Data Sources and Panel Construction

The analysis uses a directed bilateral trade panel pairing 78 ACP countries against EU-27 member states plus the United Kingdom, with exports and imports entered as separate directional flows. The United Kingdom is included as an EU partner through 2020, its last year under the EU's common commercial policy, and excluded thereafter. EU-27 membership is otherwise held fixed at this composition throughout. Thirteen countries that joined the EU during the sample window, ten in 2004, two in 2007, and Croatia in 2013, are included as EU partners for their pre-accession years as well, so no country enters or exits the EU-partner set mid-panel except the United Kingdom. Any partner-year-specific shift common across ACP countries around these accession dates, or around the UK's 2020 exit, is absorbed by the EU-partner by year fixed effects. A break that hit some ACP destinations differently than others (say, commodity exporters versus manufacturers) would not be absorbed.

Bilateral trade flow data come from the BACI database (Gaulier and Zignago, 2010; HS92 V202601), which reconciles differences between reported exports and reported imports to produce a single harmonized value per country pair and year. Distance, common official language, and colonial history come from the CEPII Gravity dataset (Conte, Cotterlaz, and Mayer, 2022; V202211), while GDP and population come from the World Bank's World Development Indicators (WDI). Cook Islands and Niue, absent from the standard WDI country set, are sourced instead from Pacific Community statistical publications. EPA status is coded from the year of provisional application, verified against notices published in the Official Journal of the European Union.

The reported sample runs from 2000 to 2021 and contains 41,258 directed dyad-years. The raw panel extends back to 1995, and extending the estimation window to match adds a further 4,473 observations. A BACI coverage gap affecting SACU and SADC before 2000 sets the baseline at the shorter window, and the full 1995–2021 window is reported instead as a robustness check in Section 5.5. The endpoint reflects 2021 as the last year of the Cotonou framework, before the Samoa Agreement took provisional effect in January 2024, and it is also the limit of the CEPII Gravity release used here.

REC membership is time-varying for eight countries whose EPA-negotiating configuration changed within the sample window. Mauritania moves from ECOWAS to unaffiliated status in 2001, Timor-Leste moves from unaffiliated status to PIF in 2003, Burundi and Rwanda move from unaffiliated status to the EAC in 2007, Kenya, Uganda, and Tanzania move from an ESA- or SADC-track configuration into the EAC track in 2007, and the DRC carries three affiliations across the panel, moving from SADC to ESA to Central Africa. Somalia is assigned to no REC in any year (see Table 0 footnote). None of this affects the 2000–2021 baseline's country universe, but it does affect which REC each of these countries' trade is coded against, and this is documented fully in the Supporting Information (S.2) and summarized in Table 0's footnote.

### 4.2 Key Variables

The central explanatory variable is the intra-REC trade share, the IT share, this paper's proxy for a bloc's depth of economic integration. For each ACP country in each year, it measures the fraction of that country's total merchandise trade, exports plus imports, conducted with other members of the same Regional Economic Community. The coefficient of interest is identified from within-country changes in that share, observed simultaneously across all EU trading partners. Bloc means run from 0.333 for SADC, the most integrated bloc on this measure and an average driven largely by South Africa's weight as the region's dominant trading partner, down through CARIFORUM (0.150), ECOWAS (0.140), and the EAC (0.140), to Central Africa (0.059) and PIF (0.045), and finally 0.043 for ESA, which ranks last on this measure.

A legal or institutional measure of integration depth was not a workable alternative here. The seven RECs are built on fundamentally different legal frameworks, from Central Africa's CEMAC monetary union to PIF's non-binding forum arrangement, and EPA coverage alone ranges from CARIFORUM's near-complete signatory list to the EAC's zero (Table 0). Any score built to bridge these differences would be endogenous to the same negotiating history that produces EPA status. A composite index spanning several integration channels, such as the Bayesian state-space measure Rayp and Standaert (2017) build for OECD country pairs from goods, services, FDI, and migration flows, faces a coverage problem instead. The non-merchandise series it requires are not available consistently across the ACP panel's 2000–2021 window. The IT share avoids both problems, asking only what fraction of trade a country conducts with its own bloc. Section 4.3 develops an alternative construction on each side of the denominator, and Section 5.5 introduces a third, rescaled by the REC's share of world trade.

The second key variable is EPA status. The EPA indicator takes the value one from the year an agreement is provisionally applied and zero otherwise. Countries that signed an agreement but never brought it into force, including all five EAC members and Haiti, are treated as non-EPA throughout.

### Gravity Specification

The estimating framework is the structural gravity model originating with Tinbergen (1962) and formalized by Anderson and van Wincoop (2003). In its structural form, bilateral trade between two economies rises with their combined output and falls as the cost of trading between them, such as distance, increases, measured relative to how costly trade is with all other potential partners rather than in isolation. The baseline equation is estimated by Poisson pseudo-maximum likelihood, following Santos Silva and Tenreyro (2006), who show PPML is preferred over log-linear OLS when trade data contain zeros and heteroskedasticity, both present in this panel. The specification is:

$$X_{ijt} = \exp\left(\beta_1 \ln d_{ij} + \beta_2 \text{Lang}_{ij} + \beta_3 \text{Colony}_{ij} + \beta_4 \text{EPA}_{ijt} + \beta_5 \text{IT Share}_{it} + \mu_{jt} + \eta_i\right) \varepsilon_{ijt}$$

where $X_{ijt}$ is the bilateral flow, $d_{ij}$ is distance, $\text{Lang}_{ij}$ and $\text{Colony}_{ij}$ are indicators for common official language and colonial tie, $\mu_{jt}$ are EU-partner by year fixed effects, and $\eta_i$ are ACP-country fixed effects. The EU-partner-year fixed effects absorb the EU-side multilateral resistance term, while the ACP-country fixed effects absorb only time-invariant exporter heterogeneity. The time-varying ACP-side multilateral resistance term is not separately controlled here, following the practical trade-off Head and Mayer (2014) and Baier, Bergstrand, and Feng (2014) describe for gravity models with endogenous trade agreements. A time-varying ACP-specific shock, a commodity boom or an infrastructure investment, would raise both intra-regional and EU-bound trade simultaneously, biasing the disjoint specification's positive coefficients upward; this works against the paper's stumbling-block finding, since it would inflate an expansion estimate that is already modest in magnitude, rather than manufacture one where none exists. A separate year effect is not included because $\mu_{jt}$ spans it.

The estimator follows Santos Silva and Tenreyro (2006), who show that log-linearized OLS produces biased elasticity estimates under heteroskedasticity; this paper's critique operates within that framework rather than reopening the choice of estimator. All models are estimated with the fixest package in R (Bergé, 2018). Standard errors are clustered by ACP country throughout unless otherwise noted. Section 5.1 reports the sensitivity of the headline result to the choice of clustering level.

### 4.3 The IT Share Form as a Testable Restriction

The IT share is built as a ratio, and writing it into the regression as one variable rather than two forces a restriction on the model. This section states that restriction and tests it. The underlying problem, a regression coefficient distorted when a regressor and an outcome share a common component, was first identified seven decades ago (Kuh and Meyer, 1955), and the gravity-trade version of it follows below.

Write $I_{it}$ for country $i$'s intra-regional trade in year $t$, $T_{it}$ for its total merchandise trade, $E_{it}$ for its trade with the EU, and $N_{it} = T_{it} - E_{it}$ for its trade with the rest of the world. The IT share and its ex-EU counterpart are

$$\text{IT}_{it} = \frac{I_{it}}{T_{it}}, \qquad \text{IT}^{\text{exEU}}_{it} = \frac{I_{it}}{N_{it}}$$

and, writing $s^{EU}_{it} = E_{it}/T_{it}$ for the EU's share of the country's trade, the two are related by an identity:

$$\text{IT}_{it} = \text{IT}^{\text{exEU}}_{it} \cdot (1 - s^{EU}_{it}) \tag{1}$$

Equation (1) shows where the mechanical link comes from. The baseline regressor includes the factor $(1 - s^{EU}_{it})$, which falls mechanically whenever the country's EU trade rises, and the dependent variable in every specification is a component of that same EU trade, since $E_{it}$ is the sum of the bilateral flows across the EU partners. Part of any negative coefficient on $\text{IT}_{it}$ is therefore arithmetic rather than economic. As in the Introduction, the EU absorbs roughly one-fifth of ACP merchandise trade over the sample on average (pooled across country-years), rising to 0.339 for Central Africa and 0.316 for ECOWAS and falling to 0.074 for PIF, so the channel is large enough to matter for every bloc in the sample.

Removing the EU from the denominator addresses the arithmetic but creates a scaling problem. Since the ex-EU share is larger than the IT share by a factor of $1/(1-s^{EU}_{it})$, the two coefficients are not directly comparable in magnitude. A third measure holds the EU component of the denominator at each country's own average EU dependence rather than removing it entirely. Because that average does not vary over time, the mechanical channel is attenuated much as it is under full removal, though the denominator still contains total trade, itself a function of EU trade, so some residual dependence likely remains:

$$\text{IT}^{\text{fixEU}}_{it} = \frac{I_{it}}{I_{it} + N_{it} + \bar{s}^{EU}_i \cdot T_{it}} \tag{2}$$

This construction removes time variation in the denominator's EU component, attenuating the mechanical channel, while leaving time variation in intra-regional trade and non-EU trade untouched. Because equation (2) differs from the IT share only in replacing $s^{EU}_{it}$ with its time-invariant average $\bar{s}^{EU}_i$, the two regressors are directly comparable in magnitude.

Beyond the denominator's contents, the ratio form itself creates a further problem. Taking logs,

$$\ln \text{IT}^{\text{exEU}}_{it} = \ln I_{it} - \ln N_{it} \tag{3a}$$

so entering the share as a single regressor is equivalent to entering numerator and denominator separately under the constraint

$$\beta_{\ln I} + \beta_{\ln N} = 0 \tag{3}$$

Equation (3) forces a one percent rise in intra-regional trade and a one percent rise in non-EU trade to move EU–ACP trade by equal and opposite amounts. This is an assumption the ratio form makes silently, not a prediction the stumbling-block hypothesis makes on its own terms. That hypothesis concerns composition, whether trade redirected toward regional partners displaces trade with the EU, which depends on how the numerator moves relative to the denominator, not on the two carrying equal and opposite coefficients. Estimating the numerator and denominator freely and checking whether $\beta_{\ln I}+\beta_{\ln N}$ equals zero tests equation (3) directly. Section 5.2 reports that test across three pairings. This restriction is tested within the same PPML specification used throughout, with $\ln I$ and $\ln N$ entered as regressors on trade in levels.

**Separating the components.** Section 5.2 tests the restriction in equation (3) using three pairings of the ratio's components. Each pairing holds a different term fixed, which changes what the test actually shows.

One pairing regresses on $\ln I$ and $\ln N$ together, holding total non-EU trade fixed. Because $N = I + X$, where $X$ is extra-regional non-EU trade, raising $I$ at constant $N$ mechanically pushes $X$ down. This overlapping specification isolates reallocation within non-EU trade, a dollar moving from an extra-regional partner to a regional one, but it does not directly identify the EU-displacement composition shift described by the stumbling-block hypothesis; the paper treats it as a secondary descriptive check.

The second pairing holds the opposite term fixed. This pairing regresses on $\ln I$ and $\ln X$ instead, holding extra-regional trade fixed, so raising $I$ raises total non-EU trade rather than reallocating it. This disjoint pairing isolates expansion, a country trading more with its neighbors without trading less with anyone else. The disjoint pairing is the cleaner test of the restriction, since $I$ and $X$ share no component and the coefficient on $\ln I$ has an unambiguous partial-effect interpretation. The overlapping pairing is not a substitute for it: because $N$ contains $I$, its coefficient on $\ln I$ reflects reallocation only insofar as holding $N$ fixed is itself a meaningful economic comparison, which the paper treats as a secondary, descriptive check rather than the primary evidence. Intra-REC trade $I$ rising by 1% forces extra-regional trade $X$ down by $I/X$% when $N$ is held fixed (the overlapping case), and forces total non-EU trade $N$ up by $I/N$% when $X$ is held fixed instead (the disjoint case).

The third pairing answers whether exports and imports should be pooled, or each matched to its own direction of trade. The first two pairings pool ACP exports to the EU with EU exports to ACP, using each country's total, bidirectional, intra-regional and non-EU trade as regressors for both directions at once. A directional trade shock, one that raises what a country sends its region without changing what it receives, is not separately identified by that pooled approach, since it forces the same coefficient onto both directions of EU trade even though the shock affects them differently. The side-matched pairing corrects this by regressing EU exports to ACP markets on ACP intra-regional and non-EU imports, and ACP exports to the EU on ACP intra-regional and non-EU exports, so the regressor and the outcome always describe the same physical flow. The side-matched pairing applies the same logic separately to exports and imports, rather than to total non-EU trade.

All three pairings are reported in Section 5.2. They answer different questions and should not be conflated.

## 5. Results

Section 5.1 reports the naive share coefficient: large and stable across estimators, sample exclusions, and clustering choices, though its magnitude shifts with the sample window in the direction Section 5.5 explains. Sections 5.2 and 5.3 then show why that coefficient cannot be read as evidence of trade diversion. Readers who want the paper's conclusion before working through the mechanics can find it in the Introduction.

### 5.1 The Pooled Estimate

Table 1 presents the core specifications. Column (1) is the PPML baseline without the integration measure, estimated on column (2)'s sample so the two are comparable. The distance elasticity sits within the range surveyed by Head and Mayer (2014), and the language and colonial-tie coefficients carry the expected positive signs.

**Table 1. Main results**

| | (1) Baseline | (2) IT Share (Main) | (3) Centered interaction | (4) IT Share OLS |
|---|---|---|---|---|
| ln(Distance) | −1.620 (0.996) | −1.628 (0.995) | −1.628 (0.994) | −1.025*** (0.329) |
| Common Language | 0.886*** (0.216) | 0.886*** (0.216) | 0.885*** (0.216) | 0.575*** (0.123) |
| Colonial Tie | 0.344* (0.200) | 0.344* (0.200) | 0.344* (0.200) | 1.093*** (0.177) |
| EPA (=1 in force) | −0.023 (0.066) | −0.046 (0.067) | −0.051 (0.063) | −0.177** (0.079) |
| IT Share | | −2.287*** (0.604) | | −1.673*** (0.458) |
| IT Share (centered) | | | −2.332*** (0.624) | |
| EPA × IT Share (centered) | | | −0.552 (0.416) | |
| EU-partner × year FE | Yes | Yes | Yes | Yes |
| ACP-country FE | Yes | Yes | Yes | Yes |
| Observations | 41,258 | 41,258 | 41,258 | 38,559 |

Dependent variable: bilateral trade flow, columns (1)–(3), estimated by PPML; ln(trade), column (4), estimated by OLS. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10. Column (1) is estimated on column (2)'s sample. Column (3) centers IT Share at its sample mean, so the EPA coefficient there is the net EPA effect at mean integration.

Adding the IT share in column (2) returns a coefficient of −2.287, with a standard error of 0.604, significant at the one percent level across 41,258 directed dyad-years. A one-standard-deviation increase in the integration share (SD = 0.128) corresponds to 25.5 percent less bilateral trade [−36.0, −13.2], a stumbling-block effect of considerable size taken at face value. Further contrasts are reported in Table 2 (Supporting Information).

The estimate holds across alternative estimators, sample exclusions, and clustering choices. Negative binomial PML gives −2.284 (SE 0.531), while OLS on logged trade, which drops zero-trade dyads, gives −1.673 (SE 0.458), and OLS on log(1 + trade), which retains them, gives −1.516 (SE 0.421). The coefficient is similarly insensitive to which countries are excluded: dropping South Africa gives −2.150, dropping Nigeria gives −1.927, dropping the SACU members gives −1.954, dropping the United Kingdom gives −2.042, and restricting to the African subsample alone gives −2.164. Somalia and Eritrea are already absent from the estimating sample, Somalia for lack of any REC assignment and Eritrea for a missing-GDP gap, so their omission is not itself a robustness check. The result is also robust to clustering choice, staying significant at the one percent level whether standard errors are clustered on the dyad (SE 0.410), the ACP country (0.604), ACP country and EU partner (0.560), or ACP country and year (0.658).

This result is robust in every conventional sense, and no reasonable choice of estimator, exclusion, or clustering moves it, though Section 5.5 shows the magnitude is not independent of the sample period. That stability does not resolve the question this section opened with, since a coefficient can be estimated with complete confidence and still reflect the ratio's arithmetic rather than the underlying economics.

### 5.2 The Share Form Is Rejected

Section 4.3 sets out three ways to test the share form. The overlapping specification holds total non-EU trade fixed, testing reallocation. The disjoint specification holds only extra-regional trade fixed, testing expansion. The side-matched specification matches each direction's flow to its own components. All three separate the intra-regional and non-EU terms that the share form forces together. Table 3 reports what happens to the coefficient itself under these different constructions, and Table 4 reports the formal test of the restriction they imply.

**Table 3. Alternative constructions of the integration measure**

| | (1) Baseline | (2) Ex-EU denom. | (3) EU component fixed | (4) Denom. = total trade | (5) Denom. = non-EU trade |
|---|---|---|---|---|---|
| IT Share | −2.287*** (0.604) | | | | |
| IT Share (ex-EU denom.) | | −0.258 (0.477) | | | |
| IT Share (EU component fixed) | | | −0.289 (0.661) | | |
| ln(Intra-REC trade) | | | | +0.015 (0.048) | +0.099* (0.053) |
| ln(Total trade) | | | | +0.688*** (0.075) | |
| ln(Non-EU trade) | | | | | +0.349*** (0.066) |
| Observations | 41,258 | 41,258 | 41,258 | 40,898 | 40,898 |

Dependent variable: bilateral trade flow, PPML. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \* p<0.10. Columns (1)–(3) keep the share form but change what the denominator contains; column (3) rescales the ex-EU share by each country's mean EU trade share, putting it on the same scale as column (1), which column (2) is not. Columns (4)–(5) leave the share form entirely and estimate the two components freely. Column (5) is the same regression as Table 4's "Overlapping: Bilateral" row, reported here again for direct comparison with columns (1)–(4). Columns (4)–(5) drop 360 country-years with zero intra-regional or zero non-EU trade in a given year, since log() is undefined at zero; the same specifications re-estimated with an inverse hyperbolic sine transform, which retains zeros, are reported in Supporting Information S.5.

Columns (2) and (3) hold the EU out of the denominator in two different ways. Removing the EU from the denominator entirely gives −0.258. Holding the EU's share at each country's own average gives −0.289. Neither construction depends on the other for its result, so the two corroborate each other.

Columns (4) and (5) show why. Column (4) keeps the EU trade that the dependent variable is drawn from inside the denominator, the exact comparison columns (1)–(3) were built to avoid, and its denominator coefficient is large and significant at +0.688 while the intra-regional coefficient collapses to an insignificant +0.015. Column (5) removes the EU from the denominator instead, and the intra-regional coefficient recovers to a significant +0.099, with the non-EU denominator coefficient at +0.349. The same mechanism produces both results: when the denominator contains the dependent variable, its coefficient absorbs the correlation and the intra-regional coefficient shrinks toward zero or reverses sign.

Both specifications are also re-estimated with the inverse hyperbolic sine transformation in place of the log, retaining the full sample rather than dropping the 360 zero-trade country-years. The result does not confirm these log-transform coefficients: under IHS, the intra-REC coefficient is close to zero and not statistically distinguishable from it in either specification (asinh_intra = −0.000, SE 0.011, in the clean/overlapping form; +0.008, SE 0.012, in the disjoint form), in contrast to the significant positive coefficients reported above under the log transform. The ratio restriction is still rejected in both IHS specifications, by a wide margin, but that rejection is now carried almost entirely by the denominator term, not by a robust positive numerator effect. This is reported as a genuine finding rather than smoothed over: the positive intra-REC result above is sensitive to functional form once zero-trade country-years are retained, and should not be read as confirmed independent of that choice (Supporting Information, Table S.3).

Table 4 turns column (5) into a formal test. Because the share form's log identity forces the intra-regional and non-EU terms to carry equal and opposite coefficients, estimating the two terms freely and checking whether their sum equals zero tests that restriction directly.

**Table 4. Test of the ratio restriction, $\beta_{\ln I} + \beta_{\ln N} = 0$**

| Specification | Cell | $\beta_{\ln I}$ | $\beta_{\ln N}$ | Sum | $t$ |
|---|---|---|---|---|---|
| Overlapping | Bilateral | +0.099 (0.053) | +0.349 (0.064) | +0.448 (0.081) | 5.52 |
| Overlapping | ACP → EU | +0.156 (0.075) | +0.229 (0.092) | +0.385 (0.104) | 3.69 |
| Overlapping | EU → ACP | +0.056 (0.043) | +0.427 (0.059) | +0.483 (0.072) | 6.72 |
| Disjoint | Bilateral | +0.133 (0.053) | +0.286 (0.062) | +0.419 (0.081) | 5.19 |
| Disjoint | ACP → EU | +0.191 (0.075) | +0.145 (0.092) | +0.335 (0.104) | 3.23 |
| Disjoint | EU → ACP | +0.085 (0.042) | +0.391 (0.051) | +0.477 (0.070) | 6.82 |
| Side-matched | EU → ACP | −0.029 (0.024) | +0.567 (0.063) | +0.537 (0.054) | 9.92 |
| Side-matched | ACP → EU | +0.147 (0.043) | +0.044 (0.066) | +0.191 (0.070) | 2.74 |

PPML with EU-partner by year and ACP-country fixed effects, n ≈ 40,722–40,898 depending on cell. Standard errors clustered by ACP country. The "Overlapping: Bilateral" row repeats Table 3, column (5).

The restriction fails in every cell. The overlapping bilateral sum is +0.448 (SE 0.081, t = 5.52), and the disjoint bilateral sum is +0.419 (SE 0.081, t = 5.19), with every directional and side-matched cell rejecting as well, t-statistics ranging from 2.74 to 9.92. All numerator coefficients are positive except the side-matched EU→ACP cell, where the numerator itself is negative (−0.029, SE 0.024); even there the restriction fails, since the sum with the non-EU term is +0.537, far from zero. Where both terms in a pairing are positive, an equal-and-opposite constraint cannot hold at all without one coefficient in the underlying share specification being pushed negative, and that forced negative coefficient is where the share form's large negative estimate actually comes from.

The share specification, differentiated at the sample mean IT share of roughly 0.12, implies an elasticity of bilateral trade with respect to the IT share of approximately −2.287 × 0.12 ≈ −0.27. Because a change in intra-regional trade also moves the denominator, the implied partial elasticity with respect to intra-regional trade itself, holding other denominator components fixed, is −2.287 × 0.12 × (1 − 0.12) ≈ −0.24. The directly estimated expansion elasticity is +0.133. The two estimates disagree on both sign and magnitude.

### 5.3 Splitting by Direction

In the naive share form, both trade directions return a negative coefficient of similar size, ACP exports to the EU at −2.509 (SE 0.962) and EU exports to ACP markets at −2.016 (SE 0.454), reported in full in Table 5 (Supporting Information). Neither direction can be distinguished from the other on this evidence, since splitting the share form by direction leaves the same denominator problem sitting in both halves of the data.

The positive evidence comes from a different construction, already reported in Table 4. Section 4.3's side-matched pairing regresses each direction's flow on its own directional components rather than on the pooled share, and the two directions diverge sharply. ACP exports to Europe carry a positive and significant coefficient on intra-regional exports, +0.147 (SE 0.043, "Side-matched: ACP → EU"), while EU exports to ACP markets show no comparable relationship with intra-regional imports, −0.029 (SE 0.024, "Side-matched: EU → ACP"). Matched correctly to direction, then, the only surviving link between intra-regional trade and EU trade runs from ACP intra-regional exports to ACP exports toward Europe, consistent with regional production networks feeding exports toward the EU market rather than competing with them. This pairing's other cell delivers the sharpest rejection of the restriction anywhere in Table 4: intra-regional and non-EU imports sum to +0.537 (SE 0.054), t = 9.92.

A share-form robustness check on the same two directions (Table 10, Supporting Information) tells a different story. Holding the EU component of the denominator fixed, ACP exports to the EU stay indistinguishable from zero at +1.212 (SE 0.969), while EU exports to ACP markets carry a significant negative coefficient of −1.554 (SE 0.429). A second construction, built from each direction's own ex-EU trade flows only, reproduces the same split: ACP exports insignificant at +0.359 (SE 0.349), EU exports significant at −1.180 (SE 0.261). Both constructions keep the share form's ratio structure rather than estimating components directly, so unlike the side-matched rows above, they still inherit the denominator problem documented in Section 5.2, and the asymmetry runs the opposite way from before: there, the ACP-exports direction carried the detectable positive relationship, while here it is the EU-exports direction that stays significant.

Taken together, these four directional checks, side-matched components, the EU-fixed share, and the direction-matched ex-EU share, all point to the same conclusion about the pooled result: the naive pooled share form in Table 5 overstates diversion in both directions. They do not settle, however, which direction, if either, carries a genuine residual relationship once the ratio's mechanics are addressed. This paper treats that directional asymmetry as an open question, unlike the pooled null, which the evidence above resolves.

### 5.4 Regional Groupings and Economic Partnership Agreements

The pooled result could still conceal meaningful structure by REC or by EPA status. Both were tested, and neither changes the paper's conclusion or warrants development beyond a direct report of the result.

**By REC.** Table 6 reports integration slopes by bloc from a single interaction model, holding the fixed-effect structure and gravity controls constant across groupings. These slopes use the same naive share measure Section 5.2 shows is entangled with the denominator, so they should be read as a map of which blocs are most exposed to the ratio's arithmetic, in rough proportion to each bloc's EU trade share, rather than as a ranking of true diversion. Four of seven blocs are individually significant: ECOWAS at −3.342 (SE 0.529), SADC at −3.439 (SE 1.130), CARIFORUM at −2.536 (SE 1.029), and PIF at −26.31 (SE 12.93) on a bloc whose mean integration share is thin and whose within-country variation is limited. PIF's zero-trade rate is the main driver of its large standard errors throughout. Central Africa (+1.823, SE 2.214), the EAC (−0.245, SE 0.931), and ESA (−1.712, SE 1.168) are not statistically distinguishable from zero. The EAC's standard error (0.931) is well within the range of the other precisely estimated blocs, and its mean IT share (0.140) is in line with ECOWAS's (0.140) and CARIFORUM's (0.150). A thin, poorly measured bloc would show a standard error an order of magnitude larger, the way PIF's does; the EAC's null is a normally powered estimate, not a symptom of missing data.

**Table 6. REC heterogeneity in the integration slope**

| | (1) Free slopes by REC | (2) Deviations from ECOWAS |
|---|---|---|
| IT Share × ECOWAS | −3.342*** (0.529) | |
| IT Share × Central Africa | +1.823 (2.214) | |
| IT Share × SADC | −3.439*** (1.130) | |
| IT Share × EAC | −0.245 (0.931) | |
| IT Share × ESA | −1.712 (1.168) | |
| IT Share × CARIFORUM | −2.536** (1.029) | |
| IT Share × PIF | −26.31** (12.93) | |
| IT Share (ECOWAS baseline) | | −3.342*** (0.529) |
| dev_CAF | | +5.166** (2.267) |
| dev_SADC | | −0.097 (1.170) |
| dev_EAC | | +3.098*** (0.952) |
| dev_ESA | | +1.630 (1.291) |
| dev_CARIFORUM | | +0.806 (1.109) |
| dev_PIF | | −22.96* (12.93) |
| Observations | 41,258 | 41,258 |

Columns under "Free slopes by REC" report each bloc's own IT Share coefficient; columns under "Deviations from ECOWAS" report the difference from ECOWAS's coefficient. The two are not comparable cell-by-cell. Single pooled model; REC main effects absorbed by the ACP-country fixed effect. Gravity controls (distance, common language, colonial tie) and EPA status included in both columns; coefficients directly comparable across blocs and to the pooled estimate in Table 1. Column (2) reparametrizes column (1) with ECOWAS as the reference bloc, so each "dev_" coefficient is that bloc's slope relative to ECOWAS's, not relative to zero. Standard errors clustered by ACP country in parentheses. \*\*\* p<0.01, \*\* p<0.05, \* p<0.10.

Table 6's second column reparametrizes the same model with ECOWAS as the reference bloc, chosen for its size as the largest bloc by country count rather than for any substantive weight of its own. Each REC's coefficient in that column reads as a deviation from ECOWAS's slope rather than an absolute effect, the standard way to test jointly whether the seven blocs' slopes differ from one another. Central Africa's deviation is significant under this parameterization (+5.166, SE 2.267) even though its absolute slope in column (1) is not, and PIF's deviation is significant at the ten percent level (−22.96, SE 12.93). Both blocs share a currency feature that could explain the gap: Central Africa's members include the CEMAC franc zone, and PIF includes several economies that peg to or use the US, Australian, or New Zealand dollar outright. The EAC's deviation is also significant (+3.098, SE 0.952), but unlike Central Africa's and PIF's it has no obvious currency-arrangement explanation, since the EAC operates no common currency in this sample, and is better read as evidence that the pooled slope masks real cross-bloc heterogeneity rather than as a case awaiting the same kind of explanation. A joint test that all six deviations from ECOWAS equal zero rejects homogeneity (F = 3.04, p = 0.010), and continues to reject with PIF excluded (F = 3.00, p = 0.017), so the rejection is not solely a PIF artifact.

Interacting IT Share with each bloc's currency arrangement confirms this for Central Africa and PIF. The CEMAC franc-zone interaction, significant at the one percent level, shrinks Central Africa's ECOWAS-relative deviation by 95 percent, to +0.249 (SE 1.011), no longer distinguishable from zero. The Pacific dollarization interaction, significant at the ten percent level, shrinks PIF's deviation by a similar 88 percent, to −2.710 (SE 6.074), also no longer significant.

The same test on three further arrangements, the Comoros franc peg within ESA, the CMA rand peg within SADC, and the ECCU dollar peg within CARIFORUM, finds no comparable shrinkage. All three deviations were already statistically indistinguishable from zero in column (2), so there is nothing significant for a currency interaction to close, and none of the three interactions reaches significance. WAEMU, nested inside ECOWAS with no deviation term of its own, is tested the same way and comes back null as well.

Central Africa's and PIF's departures from the pooled pattern are explained by their currency arrangements. The EAC's is not, and the other three pegged blocs remain an open question as well, since Comoros in particular is identified off a single country and the tests there lack the power to confirm or rule out the same mechanism. The pooled pattern is robust to excluding most individual blocs, remaining significant at the one percent level in five of seven cases and ranging from −1.918 (SADC excluded) to −2.935 (Central Africa excluded), but it depends materially on ECOWAS: excluding that bloc alone reduces the coefficient to −1.356 (SE 0.839, t = −1.62), no longer statistically significant. ECOWAS's large mean IT share (0.140) and substantial weight in the pooled sample make it an outsized contributor to the naive coefficient, a pattern consistent with the same denominator-overlap mechanism Section 5.2 describes rather than an idiosyncratic ECOWAS-specific effect.

**EPA status.** At the sample mean level of integration, EPA status carries no detectable net effect on bilateral trade. Column (3) of Table 1 centers IT Share at its sample mean, so the EPA coefficient there gives the net EPA effect at that mean: −0.051 (SE 0.063), indistinguishable from zero, and the EPA-by-integration interaction is likewise insignificant at −0.552 (SE 0.416). This matches Stender et al. (2021), who also find no general increase in EU–ACP trade following EPA implementation.

Splitting the EPA coefficient by direction of trade shows a significant negative effect specifically in the EU-exports-to-ACP equation, −0.126 (SE 0.061, Table 5, column 3), with no corresponding effect on the ACP-exports-to-EU side. An in-force EPA is associated with ACP countries buying roughly twelve percent less from the EU, with no change in what they sell to it. That estimate is descriptive rather than causal, since EPA timing is not randomly assigned across countries. Testing whether the pattern holds up causally would require a staggered difference-in-differences design keyed to each country's EPA date, a design this paper does not implement.

### 5.5 Robustness Checks

**Confound Controls.** The naive coefficient is also robust to a battery of confound controls and alternative specifications (Table 7), reported here for completeness rather than as evidence bearing on the paper's argument, since Sections 5.2–5.3 already show that robustness of this kind does not resolve the arithmetic problem. Controlling for ACP market size (GDP and population), income similarity (a Linder-type EU–ACP GDP-per-capita gap, testing whether countries with comparable income levels simply trade more), and trade concentration (an EU-partner Herfindahl index and an HS-chapter export Herfindahl index, testing whether a few dominant partners or product categories rather than REC identity drive the result) leaves the coefficient between −1.77 and −3.16 throughout. ACP GDP enters positively and significantly, consistent with its role as a market-size control, and the EU-partner concentration index is significant at the ten percent level. ACP population and the export concentration index are not distinguishable from zero. The Linder gap enters negatively, as the income-similarity hypothesis predicts.

Interacting IT Share directly with each of six currency-union flags, rather than entering them as levels which would be collinear with the ACP-country fixed effect, raises the coefficient to −3.159 (SE 0.765, not directly comparable to the baseline since six additional interaction terms reallocate variance). Two of the six, CEMAC and CMA, are themselves significant and positive, consistent with the currency-channel finding in Section 5.4 though not a confirmation of it at this level of granularity. IT Intensity, which rescales the integration share by the REC's share of world trade, returns a small but significant −0.007 (SE 0.003). Like the naive share itself, it does not address the denominator problem, since it inherits Section 4.3's arithmetic intact.

**Sample Restrictions.** The full-sample coefficient is stable under alternative start and end years, though subperiod estimates vary systematically with the EU trade share (Table 8). Restricting the start year to 2007, the point at which Burundi, Rwanda, Kenya, Uganda, and Tanzania all shift EPA-negotiating configuration into the EAC track (Section 4.1), weakens the estimate to −1.754 (SE 0.519) but leaves it significant. Extending back to 1995 strengthens it to −2.555 (SE 0.639) on 45,731 observations, though this reintroduces the SACU coverage gap discussed in Section 4.1. Splitting the sample by period shows why the coefficient moves with the window: −2.656 (SE 0.723) for 2000–2007, −2.002 (SE 0.713) for 2008–2014, and +0.114 (SE 0.797), not significantly different from zero, for 2015–2021, falling in step with the EU's mean trade share, which drops from 0.267 to 0.168 over the same span, the direction the arithmetic account in Section 4.3 predicts even if not its exact magnitude. Clustering choice does not affect significance, as already reported in Section 5.1.

**Share and Value Trends.** A simpler comparison tells the same story as the formal tests above. Within every REC for which the comparison can be computed, the EU's trade share has fallen since 2000 while the logged value of EU–ACP trade has risen over the same period: ECOWAS (share down 21 percentage points, value up 162 percent), Central Africa (down 24 points, up 168 percent), SADC (down 17 points, up 155 percent), ESA (down 22 points, up 62 percent), CARIFORUM (down 9 points, up 12 percent), and PIF (down 4 points, up 156 percent). The EAC's comparison cannot be computed on this design, since the EAC did not exist as a negotiating configuration at the sample's 1995 start year for any of its five members (Section 4.1); the comparison requires a REC label at both endpoints of the window, and the EAC has one only from 2007.

A falling share alongside a rising value is exactly the pattern the paper's arithmetic account predicts: a growing denominator mechanically pulls the ratio down even as the numerator, absolute EU–ACP trade, continues to grow. This holds without exception across every bloc where the underlying trade values support the comparison.

**Diversion to Non-EU Partners.** A different kind of check tests whether regional integration diverts trade from major non-EU partners specifically, using two complementary constructions (Table 9): substituting China's and the United States' bilateral trade with ACP countries for EU trade as the outcome, and adding each partner's trade share as a covariate in the EU regression itself. The first finds no evidence of diversion: China's intra-REC coefficient is −0.045 (SE 0.038, n = 1,609) and the United States' is +0.035 (SE 0.085, n = 1,631), neither distinguishable from zero. Both partners' extra-regional coefficients, by contrast, are strongly positive (+0.950 and +0.901, both p < 0.01), though this comparison is not as clean as the intra-REC one: the extra-regional aggregate is built from all non-EU, non-intra-REC trade, which includes each partner's own bilateral flow with the ACP country, so part of this coefficient likely reflects the same kind of overlap the paper's main critique addresses rather than general trade growth alone. The intra-REC null result is unaffected, since intra-regional trade by construction excludes both partners' bilateral flows.

The second approach controls for each partner's rising trade share directly rather than treating it as a separate outcome. Adding China's trade share as a covariate in the EU disjoint-bilateral regression (n = 40,898) leaves the expansion elasticity intact at +0.117 (SE 0.053, against +0.133 without the control), with China's own share entering negatively (−0.836, SE 0.465). Adding the US's trade share instead gives an almost identical result, +0.119 (SE 0.051), with the US's own share entering negatively as well, −1.735 (SE 0.436, p < 0.01). If the partner trade shares are constructed analogously to the IT share, with denominators that contain the dependent variable, a negative coefficient on either is mechanically expected rather than informative, so these two coefficients are not treated as independent evidence. Combined with the EU-side expansion elasticity in Section 5.2, the stable intra-REC coefficients (+0.117 to +0.119, against +0.133 without either control) provide a further line of evidence for general trade growth rather than targeted diversion.

## 6. Conclusion

Regional integration in the ACP setting looks like a stumbling block only because the standard way of measuring it recycles the dependent variable it is meant to explain. The intra-REC trade share carries a coefficient of −2.287 (SE 0.604), unmoved by any of the checks in Section 5.1, but the share's denominator, total trade, contains the EU trade the model is built to explain. Holding the EU's contribution to that denominator fixed instead of letting it move with the regressor removes the coefficient's statistical significance, down to −0.289 (SE 0.661). Estimating the ratio's numerator and denominator as separate terms confirms the mechanism directly. The equal-and-opposite restriction the share form imposes is rejected in every specification tested, and the numerator coefficient is positive throughout.

Intra-regional exports are associated with higher ACP exports to the EU, a positive and significant relationship of +0.147, while the same relationship estimated on the import side is a statistical zero. This is associational rather than causal: ACP-country fixed effects cannot be interacted with year without absorbing the regressor, so a shock that raises both regional and EU-bound trade together would produce the same pattern. That asymmetry is nonetheless consistent with regional production feeding exports outward toward European markets rather than displacing them. The same pattern holds outside the EU relationship: substituting China's or the United States' bilateral trade for the EU's as the outcome produces no evidence of diversion toward either partner, and the EU-side relationship itself is unchanged once each partner's own rising trade share is added directly as a control.

The naive coefficient's variation across RECs is sharpest in Central Africa and the Pacific Islands Forum, and shrinks by 95 and 88 percent respectively once each bloc's currency arrangement, the CEMAC franc peg in one case and Pacific dollarization in the other, is entered directly. The EAC also deviates significantly from the pooled pattern, without a currency explanation; the seven blocs' slopes are not homogeneous, a joint test rejects equal slopes across RECs, and this is now reported directly rather than treated as a detail the pooled estimate can absorb without comment. EPA implementation shows no net effect on total EU–ACP trade, consistent with earlier work on the same question. Splitting the coefficient by direction shows a real asymmetry, however. EU exports to ACP markets fall by roughly twelve percent under an in-force agreement, while ACP exports to the EU show no corresponding change. Confirming that pattern causally would require a staggered difference-in-differences design keyed to each country's own EPA date, the extension Section 5.4 sketches but does not implement here.

Splitting the results by direction uncovers one asymmetry that this paper does not resolve. Matching each direction's trade flow to its own components finds a positive, significant relationship on the ACP-exports side and a null on the EU-exports side. Holding the EU's denominator share fixed instead reverses that pattern, finding the EU-exports side significant and the ACP-exports side null. Both corrected constructions agree that the naive pooled coefficient is mechanically inflated, but they disagree about whether a directional residual remains. This paper treats that split as a question for further work rather than forcing a resolution the evidence does not support.

Any gravity specification that regresses bilateral trade on an intra-regional share imposes the same restriction, regardless of the bloc or reference partner involved. This is an algebraic property of the ratio, not a finding specific to EU-ACP trade. Whether the resulting bias is large enough to matter in other settings is an empirical question this paper does not test directly. The bias scales with the outside partner's share of the country's total trade, roughly one-fifth on average across country-years in this sample (Section 4.3). Estimating the ratio's components separately costs one additional regression, and checking whether their coefficients sum to zero takes only a few lines of algebra, well within reach of any study using this kind of measure. Share-form diversion estimates reported without that check may be measuring the same arithmetic rather than an actual change in trade flows, though confirming this in other blocs or partner relationships would require applying the test to their data directly.

A null result does not prove the absence of an effect, since the component estimates here are small and their confidence intervals admit modest effects in either direction. As noted above, the identification here is associational rather than causal; instrumenting integration depth with tariff-liberalization episodes or corridor-infrastructure investment remains the most direct route to a causal reading.

Each country here is assigned to a single REC based on its EPA-negotiating track, the same logic Cotonou itself uses. Many ACP countries hold overlapping memberships in practice, though, and a coding that recognized simultaneous memberships would assign trade differently, potentially shifting results for the blocs where dual membership is most common. This paper does not attempt to settle which REC-assignment convention is correct. The sample also closes in 2021, before the African Continental Free Trade Area had materially altered intra-African flows. AfCFTA will raise intra-regional shares substantially for ECOWAS and ESA members in particular, and any study of its trade effects will run into the same measurement problem documented here, on a larger denominator.

Overlapping commitments across AfCFTA, the EPAs, and individual REC frameworks create the kind of fragmented trade governance Bhagwati (1993) warned against, and whether deepening African regionalism comes at Europe's expense is an important question for policymakers on both continents, not just for the estimates in this paper. Langan and Price (2025) document the resulting tension in EU–Africa trade diplomacy directly, through interviews with African officials weighing deeper continental integration against existing EPA commitments. Stack (2024) finds that African free trade and partial-scope agreements raise extra-African exports rather than displacing them, a pattern consistent with the absence of evidence of diversion this paper documents in the pooled sample for the EU specifically. The share-form coefficients most often cited as evidence of displacement, in the ACP literature and elsewhere, do not establish it. Settling the question, as AfCFTA advances, will require specifications that keep the outcome out of the regressor.

## Supporting Information

Additional supporting information may be found in the online version of this article: data provenance for the BACI coverage gap and REC-accession timing corrections (S.1–S.2), tables reported only in summary or by cross-reference in the body (S.3), a Monte Carlo validation exercise (S.4), and an inverse-hyperbolic-sine robustness check (S.5).

## References

Afesorgbor, S.K. (2017). Revisiting the effect of regional integration on African trade: Evidence from meta-analysis and gravity model. *Journal of International Trade & Economic Development*, 26(2), 133–153. https://doi.org/10.1080/09638199.2016.1219381

Anderson, J.E. and van Wincoop, E. (2003). Gravity with gravitas: A solution to the border puzzle. *American Economic Review*, 93(1), 170–192. https://doi.org/10.1257/000282803321455214

Baier, S.L. and Bergstrand, J.H. (2007). Do free trade agreements actually increase members' international trade? *Journal of International Economics*, 71(1), 72–95. https://doi.org/10.1016/j.jinteco.2006.02.005

Baier, S.L., Bergstrand, J.H., and Feng, M. (2014). Economic integration agreements and the margins of international trade. *Journal of International Economics*, 93(2), 339–350. https://doi.org/10.1016/j.jinteco.2014.03.005

Baier, S.L., Yotov, Y.V., and Zylkin, T. (2019). On the widely differing effects of free trade agreements: Lessons from twenty years of trade integration. *Journal of International Economics*, 116, 206–226. https://doi.org/10.1016/j.jinteco.2018.11.002

Baldwin, R. and Venables, A.J. (1995). Regional economic integration. In G.M. Grossman and K. Rogoff (Eds.), *Handbook of International Economics, Volume 3* (pp. 1597–1644). North-Holland. https://doi.org/10.1016/S1573-4404(05)80011-5

Bergé, L. (2018). Efficient estimation of maximum likelihood models with multiple fixed-effects: the R package FENmlm. *CREA Discussion Papers*, 13. University of Luxembourg. [No DOI — working paper]

Bhagwati, J. (1993). Regionalism and multilateralism: An overview. In J. de Melo and A. Panagariya (Eds.), *New Dimensions in Regional Integration* (pp. 22–51). Cambridge University Press. https://doi.org/10.1017/CBO9780511628511.004

Carrère, C. (2004). African regional agreements: Impact on trade with or without currency unions. *Journal of African Economies*, 13(2), 199–239. https://doi.org/10.1093/jae/ejh010

Conte, M., Cotterlaz, P., and Mayer, T. (2022). The CEPII Gravity database. *CEPII Working Paper No. 2022-05*. Centre d'Études Prospectives et d'Informations Internationales, Paris. [Data version: V202211.] [No DOI — working paper]

European Union (various years). Official Journal of the European Union: Economic Partnership Agreement provisional application notices. Publications Office of the European Union, Luxembourg. https://eur-lex.europa.eu [No DOI — institutional source]

Frankel, J., Stein, E., and Wei, S.J. (1995). Trading blocs and the Americas: The natural, the unnatural, and the super-natural. *Journal of Development Economics*, 47(1), 61–95. https://doi.org/10.1016/0304-3878(95)00005-4

Freund, C. and Ornelas, E. (2010). Regional trade agreements. *Annual Review of Economics*, 2, 139–166. https://doi.org/10.1146/annurev.economics.102308.124455

Gaulier, G. and Zignago, S. (2010). BACI: International trade database at the product level. *CEPII Working Paper No. 2010-23*. Centre d'Études Prospectives et d'Informations Internationales, Paris. [Data version: HS92 V202601.] [No DOI — working paper]

Head, K. and Mayer, T. (2014). Gravity equations: Workhorse, toolkit, and cookbook. *Handbook of International Economics*, 4, 131–195. https://doi.org/10.1016/B978-0-444-54314-1.00003-3

Kuh, E. and Meyer, J.R. (1955). Correlation and regression estimates when the data are ratios. *Econometrica*, 23(4), 400–416. https://doi.org/10.2307/1905347

Langan, M. and Price, S. (2025). The frustrations of free trade and the Africa–European Union Samoa Agreement. *Journal of Developing Societies*, 41(1), 7–34. https://doi.org/10.1177/0169796X241304455

Nguyen, D.B. (2019). A new examination of the impacts of regional trade agreements on international trade patterns. *Journal of Economic Integration*, 34(2), 236–279. https://doi.org/10.11130/JEI.2019.34.2.236

Pacific Community (SPC) (various years). Pacific Data Hub — National Minimum Development Indicators. Statistics for Development Division, Noumea, New Caledonia. https://pacificdata.org [No DOI — data source]

Rayp, G. and Standaert, S. (2017). Measuring actual economic integration: A Bayesian state-space approach. In *Indicator-Based Monitoring of Regional Economic Integration* (pp. 341–360). Springer. https://doi.org/10.1007/978-3-319-50860-3_16

Rodrik, D. (2018). What do trade agreements really do? *Journal of Economic Perspectives*, 32(2), 73–90. https://doi.org/10.1257/jep.32.2.73

Rose, A.K. (2004). Do we really know that the WTO increases trade? *American Economic Review*, 94(1), 98–114. https://doi.org/10.1257/000282804322970724

Santos Silva, J.M.C. and Tenreyro, S. (2006). The log of gravity. *Review of Economics and Statistics*, 88(4), 641–658. https://doi.org/10.1162/rest.88.4.641

Stack, M.M., Amissah, E.B., and Bliss, M. (2024). African economic integration and trade. *The World Economy*, 47(5), 2122–2146. https://doi.org/10.1111/twec.13538

Stender, F., Berger, A., Brandi, C., and Schwab, J. (2021). The trade effects of the economic partnership agreements between the European Union and the African, Caribbean and Pacific group of states: Early empirical insights from panel data. *JCMS: Journal of Common Market Studies*, 59(6), 1495–1515. https://doi.org/10.1111/jcms.13201

Tinbergen, J. (1962). *Shaping the World Economy: Suggestions for an International Economic Policy*. Twentieth Century Fund. [No DOI — book]

Urata, S. and Okabe, M. (2014). Trade creation and diversion effects of regional trade agreements: A product-level analysis. *The World Economy*, 37(2), 267–289. https://doi.org/10.1111/twec.12099

World Bank (2024). World Development Indicators. The World Bank Group, Washington, DC. https://databank.worldbank.org/source/world-development-indicators [No DOI — data source]
