# Does Regional Integration Divert Trade from Europe? A Ratio-Regressor Critique of EU--ACP Gravity Estimates

## Abstract

Gravity models routinely measure regional integration as a share of total trade and read a negative coefficient as evidence of trade diversion. This paper shows the share form is not a neutral normalization but a testable restriction, decisively rejected in the EU--ACP setting. Using PPML on a 2000--2021 panel of 78 ACP countries and the EU, the share attracts a large, precisely estimated negative coefficient, −2.482. Holding the EU\'s trade share fixed, rather than letting it move with the regressor, removes the arithmetic link and collapses the coefficient to −0.294, statistically indistinguishable from zero. Estimated directly rather than as a ratio, intra-regional trade\'s own coefficient is positive and significant, +0.133, evidence of expansion rather than diversion. A parallel check using China\'s and the United States\' bilateral trade as the outcome shows the same pattern. The denominator contains the dependent variable, and no specification severing that link recovers a negative effect.

## 1. Introduction

Since the Cotonou Partnership Agreement in 2000, the European Union has pursued two goals at once. It has deepened preferential trade ties with African, Caribbean, and Pacific countries and has also pushed those countries to strengthen their own regional economic communities. By 2021, Economic Partnership Agreements, the reciprocal free trade arrangements the EU negotiates with ACP regional blocs rather than individual countries, had been applied at least in part in six of the seven ACP regions, together covering most ACP countries and hundreds of billions of dollars in annual trade. Over the same period, intra-REC trade shares rose across most ACP blocs, as regional integration strengthened through tariff cuts, common external tariffs, and corridor infrastructure. If growing intra-bloc trade displaces demand for European goods rather than expanding overall import demand, the EU\'s investment in EPA negotiations works against its own trade goals.

The literature on preferential trade agreements has long debated whether regional blocs are building blocks or stumbling blocks toward broader liberalization. Most empirical work looks at North--North or North--South agreements. Whether South--South integration crowds out or complements a concurrent deal with a major Northern partner is a different question, and one the literature has barely touched. This paper set out to answer it, using EU--ACP trade as the setting. The standard way of asking the question turned out not to answer it at all.

Measured the conventional way, as the share of an ACP country\'s total trade conducted within its own bloc, regional integration carries a large coefficient of −2.482 (SE 0.651). It is significant at the one percent level under every clustering scheme tested, stable across estimators, and survives dropping any single bloc, country, or time window. This result looks like strong evidence of a stumbling block, but the share used to produce it is a ratio, and its denominator, total trade, contains the dependent variable, the very EU trade the model is trying to explain. Because of that overlap, part of the coefficient is mechanical rather than economic, and this paper\'s contribution is to show that this standard measure of integration cannot detect true diversion at all, regardless of what the actual relationship between regional integration and EU trade turns out to be.

Two complementary checks address this. Holding each country\'s own average EU-trade share fixed, instead of letting it move with the regressor, removes the arithmetic link on its own (coefficient falls from −2.482 to −0.294). Estimating intra-regional trade\'s own coefficient directly, with no ratio at all, removes the ratio altogether (coefficient positive at +0.133). Together, these two results move the coefficient from large and negative, to statistically indistinguishable from zero, to small and positive, depending only on how the arithmetic link to EU trade is handled. That sequence of results is the paper\'s central empirical fact.

Three further checks confirm this, detailed in Section 5. Estimating the ratio\'s components freely, rather than folding them into a share, rejects the restriction outright. Matching each direction of trade to its own components shows that an apparent asymmetry in the naive share form was itself a byproduct of the ratio, not a real directional difference. A check entirely outside the EU relationship substitutes China\'s and the United States\' bilateral trade for the EU\'s as the outcome, and separately adds each partner\'s trade share as a covariate in the EU regression, and both versions show the same null. Any gravity specification that regresses trade on an intra-regional share risks the same arithmetic. The size of that risk depends on how large a share of a country\'s total trade is conducted with whichever partner serves as the dependent variable, a share that averages roughly one-fifth for the EU across this sample.

Section 2 covers institutional background, Section 3 reviews the literature, and Section 4 describes the data, derives the restriction, and sets out the estimating strategy. Sections 5 and 6 present results and conclusions.

## 2. Institutional Background

### The Cotonou Partnership Agreement

The Cotonou Partnership Agreement, signed in June 2000 and entering into force in 2003, superseded the Lomé Conventions that had governed EU--ACP relations since 1975. Under Lomé, ACP countries received non-reciprocal preferential access to European markets, an arrangement the WTO eventually ruled incompatible with its non-discrimination obligations. Cotonou\'s central innovation was to replace these one-sided preferences with Economic Partnership Agreements: reciprocal free trade arrangements negotiated between the EU and ACP regional groupings rather than individual countries.

The EU chose to negotiate at the REC level. By requiring ACP blocs to unite for negotiations, the EU tied the terms of market access to the depth of each region\'s internal cohesion, so the relationship between intra-REC integration and EU--ACP trade reflects institutional design as much as economics. The reciprocity requirement added a further asymmetry, since ACP countries were now required to open their own markets to EU goods, something they had never had to do under Lomé, and that burden fell unevenly across blocs.

### ACP Regional Groupings and EPA Status

The ACP group is organized here into the seven Regional Economic Communities as they appear in EPA negotiations, rather than by the overlapping memberships many ACP countries hold. Five of the seven are African. Membership is time-varying for eight countries whose REC affiliation changed within the sample window (MRT, TLS, BDI, RWA, COD, KEN, UGA, TZA). Table 0 reports each REC\'s full membership across the 2000--2021 sample, with transitions documented in the footnote and in full in the Supporting Information. Somalia is part of the 78-country ACP universe used throughout but is assigned to no REC in any year (see footnote).

**Table 0. ACP Regional Economic Communities: membership and EPA status**

  ---------------------------------------------------------------------------------------------------------------------------------------------
  REC               Members (*n*)     Key members                                        EPA status
  ----------------- ----------------- -------------------------------------------------- ------------------------------------------------------
  ECOWAS            16                Nigeria, Ghana, Côte d\'Ivoire, Senegal            Bilateral only: Côte d\'Ivoire, Ghana (2016)

  Central Africa    8                 Cameroon, Gabon, DRC                               Cameroon only (Aug 2014)

  SADC              9                 South Africa, Botswana, Mozambique                 6 applied (Oct 2016† ); Angola, DRC untreated

  EAC               5                 Kenya, Tanzania, Uganda                            Signed Sep 2016, never applied

  ESA               14                Mauritius, Madagascar, Zimbabwe                    4 signed, applied May 2012; Comoros added (Feb 2019)

  CARIFORUM         15                Jamaica, Trinidad and Tobago, Dominican Republic   14 of 15 (Dec 2008); Haiti signed, never applied

  PIF               15                Papua New Guinea, Fiji                             PNG, Fiji only (Dec 2009 / Jul 2014)
  ---------------------------------------------------------------------------------------------------------------------------------------------

*Counts include countries whose REC affiliation is time-varying within the 2000--2021 sample (ECOWAS/Mauritania, SADC/Central Africa/ESA\'s shared transitions for the DRC, Kenya, Uganda, and Tanzania, PIF/Timor-Leste); full transition-by-transition detail and sourcing is in Supporting Information S.2. Somalia is part of the 78-country ACP universe but assigned to no REC in any year, since it never signed or ratified Cotonou (S.2). † SADC\'s EPA entered provisional application 10 October 2016 for Botswana, Lesotho, Eswatini, Namibia, and South Africa; Mozambique followed on 4 February 2018, confirmed directly against EUR-Lex\'s summary text and corroborated by a Council document.*

The resulting treatment intensity varies sharply across blocs: 59 percent of CARIFORUM country-years carry an in-force EPA, against 21 percent for SADC, 17 percent for ESA, 6 percent for PIF, 5 percent for Central Africa, 4 percent for ECOWAS, and none for the EAC. Integration itself varies just as sharply, and independently of EPA status: bloc-mean IT shares (Section 4.2) run from 0.333 for SADC and 0.150 for CARIFORUM down to 0.005 for the EAC, so a bloc\'s depth of internal integration is not simply a proxy for how far its EPA has progressed.

## 3. Literature Review

Preferential trade agreements have long been debated as either building blocks or stumbling blocks toward broader liberalization. The empirical record on ACP trade and EPA implementation offers a second, more specific literature this paper also draws on.

### Building Blocks or Stumbling Blocks?

Bhagwati (1993) stated the building-block/stumbling-block tension most sharply, and his formulation set the terms of a debate that persists today. Baldwin and Venables (1995) then gave the debate its systematic theoretical treatment, and their survey of regional integration\'s welfare effects remains the standard reference for weighing trade creation against diversion in customs unions and common markets. In the building-block view, regional integration reduces transaction costs, aligns regulatory environments, and creates larger markets that raise total trade with all partners including outsiders. The stumbling-block view holds the opposite: regional preferences redirect trade toward bloc partners and away from more efficient outside suppliers, so deeper regional integration comes at non-members\' expense rather than raising trade overall. Part of the building-block case rests on efficiency gains from specialization, not reduced trade costs alone, and Baldwin and Venables\'s welfare survey treats this specialization channel alongside trade creation and diversion, rather than as a separate story.

The empirical record leans toward the building-block view. Freund and Ornelas (2010) offer the most comprehensive review and reach a cautious endorsement: regional agreements tend to be building blocks, neither systematically erecting new barriers to non-members nor derailing multilateral progress. Baier and Bergstrand (2007) strengthen this reading, showing that FTAs approximately double members\' bilateral trade over time once endogeneity is addressed. Baier, Yotov, and Zylkin (2019) find that this aggregate picture conceals substantial heterogeneity, with deep agreements generating larger gains than shallow ones.

The WTO\'s own track record has faced similar scrutiny. Rose (2004) found that formal WTO membership had no detectable effect on bilateral trade. Frankel, Stein, and Wei (1995) argued that South--South trading blocs are structurally more prone to trade diversion than North--North counterparts. Agreements between developed economies integrate partners with modest efficiency gaps and substantial complementarity, so reorientation toward bloc partners tends to expand rather than displace efficient sourcing. South--South arrangements integrate economies at comparable and often limited development levels, where preferential partners are rarely more efficient than global alternatives.

Urata and Okabe (2014), using a product-level gravity design across 67 countries and 20 product categories, find that RTAs among developing countries generate more trade diversion than RTAs among developed ones. They trace the pattern to the higher external tariffs developing-country blocs tend to retain against non-members. Frankel, Stein, and Wei\'s prediction, and Urata and Okabe\'s evidence for it, together form the natural prior for the ACP setting, part of why a large negative share coefficient is easy to accept without scrutiny.

### ACP Trade and EPA Studies

The gravity literature on ACP trade is fragmented, mirroring the institutional diversity of the grouping. Carrère (2004) found positive intra-bloc effects from African regional agreements alongside significant diversion from extra-African partners. Afesorgbor (2017) examines the trade effects of African regional agreements and reaches broadly compatible conclusions about the coexistence of creation and diversion. Nguyen (2019) tests for aggregate diversion across regional agreements without separating the North--South and South--South channels.

On the EPA side specifically, Rodrik (2018) argues that modern trade agreements reach into regulatory harmonization and domestic policy commitments that developing-country institutions are often ill-equipped to deliver. Combined with the reciprocity requirement under Cotonou, this mismatch calls into question whether EPAs generate the trade gains their design assumes. Stender et al. (2021) confirm this skepticism empirically, finding no general increase in total EU--ACP trade following EPA implementation. The net-null EPA result reported in Section 5.4 below is consistent with theirs. That section also finds a directional pattern their aggregate specification would not have detected: EPAs show no net effect on total trade, but a significant negative effect specifically on EU exports to ACP markets, a detail invisible to any specification that pools both directions of trade together.

None of this work asks how the depth of South--South integration reshapes the terms of a concurrent preferential relationship with a major Northern partner. Building-block studies focus on members\' own trade and treat outsiders as secondary. ACP gravity work keeps the North--South and South--South channels apart rather than joining them, and EPA studies weigh preferential access without asking how far regional integration has already gone. This paper takes up that combination, along with a second, more consequential gap in how the share-form measure itself has been used: such measures are common throughout the literature, but the arithmetic relationship between the measure and the dependent variable is rarely examined. That omission affects every strand relying on a share-form integration regressor, including the building-block question at the center of this paper.

## 4. Data and Methodology

### Data Sources and Panel Construction

The analysis uses a directed bilateral trade panel pairing 78 ACP countries against EU-27 member states plus the United Kingdom, with exports and imports entered as separate directional flows. The United Kingdom is included as an EU partner through 2020, its last year under the EU\'s common commercial policy, and excluded thereafter. EU-27 membership is otherwise held fixed at this composition throughout. Thirteen countries that joined the EU during the sample window, ten in 2004, two in 2007, and Croatia in 2013, are included as EU partners for their pre-accession years as well, so no country enters or exits the EU-partner set mid-panel except the United Kingdom. Any structural break in trade around these accession dates, or around the UK\'s 2020 exit, is absorbed by the EU-partner by year fixed effects.

Bilateral trade flow data come from the BACI database (Gaulier and Zignago, 2010; HS92 V202601), which reconciles differences between reported exports and reported imports to produce a single harmonized value per country pair and year. Distance, common official language, and colonial history come from the CEPII Gravity dataset (Conte, Cotterlaz, and Mayer, 2022; V202211), while GDP and population come from the World Bank\'s World Development Indicators (WDI). Cook Islands and Niue, absent from the standard WDI country set, are sourced instead from Pacific Community statistical publications. EPA status is coded from the year of provisional application, verified against notices published in the Official Journal of the European Union.

The reported sample runs from 2000 to 2021 and contains 41,258 directed dyad-years. The raw panel extends back to 1995, and extending the estimation window to match adds a further 4,473 observations. A BACI coverage gap affecting SACU and SADC before 2000 sets the baseline at the shorter window, and the full 1995--2021 window is reported instead as a robustness check in Section 5.5. The endpoint reflects 2021 as the last year of the Cotonou framework, before the Samoa Agreement took provisional effect in January 2024, and it is also the limit of the CEPII Gravity release used here.

REC membership is time-varying for eight countries whose EPA-negotiating configuration changed within the sample window. Mauritania moves from ECOWAS to unaffiliated status in 2001, Timor-Leste moves from unaffiliated status to PIF in 2003, Burundi and Rwanda move from unaffiliated status to the EAC in 2007, Kenya, Uganda, and Tanzania move from an ESA- or SADC-track configuration into the EAC in 2007, and the DRC carries three affiliations across the panel, moving from SADC to ESA to Central Africa. Somalia is assigned to no REC in any year (see Table 0 footnote). None of this affects the 2000--2021 baseline\'s country universe, but it does affect which REC each of these countries\' trade is coded against, and this is documented fully in the Supporting Information (S.2) and summarized in Table 0\'s footnote.

### Key Variables

The central explanatory variable is the intra-REC trade share, the IT share, this paper\'s proxy for a bloc\'s depth of economic integration. For each ACP country in each year, it measures the fraction of that country\'s total merchandise trade, exports plus imports, conducted with other members of the same Regional Economic Community. The coefficient of interest is identified from within-country changes in that share, observed simultaneously across all EU trading partners. Bloc means run from 0.333 for SADC, the most integrated bloc on this measure and an average driven largely by South Africa\'s weight as the region\'s dominant trading partner, down through CARIFORUM (0.150), ECOWAS (0.140), Central Africa (0.059), PIF (0.045), and ESA (0.043), to 0.005 for the EAC, the least integrated.

A legal or institutional measure of integration depth was not a workable alternative here. The seven RECs are built on fundamentally different legal frameworks, from Central Africa\'s CEMAC monetary union to PIF\'s non-binding forum arrangement, and EPA coverage alone ranges from CARIFORUM\'s near-complete signatory list to the EAC\'s zero (Table 0). Any score built to bridge these differences would be endogenous to the same negotiating history that produces EPA status. A composite index spanning several integration channels, such as the Bayesian state-space measure Rayp and Standaert (2017) build for OECD country pairs from goods, services, FDI, and migration flows, faces a coverage problem instead. The non-merchandise series it requires are not available consistently across the ACP panel\'s 2000--2021 window. The IT share avoids both problems, asking only what fraction of trade a country conducts with its own bloc. Two alternative constructions appear in Section 4.4, and a third, rescaled by the REC\'s share of world trade, is introduced in Section 5.5.

The second key variable is EPA status. The EPA indicator takes the value one from the year an agreement is provisionally applied and zero otherwise. Countries that signed an agreement but never brought it into force, including all five EAC members and Haiti, are treated as non-EPA throughout.

### Gravity Specification

The estimating framework is the structural gravity model originating with Tinbergen (1962) and formalized by Anderson and van Wincoop (2003). In its structural form, bilateral trade between two economies rises with their combined output and falls as the cost of trading between them, such as distance, increases, measured relative to how costly trade is with all other potential partners rather than in isolation. The baseline equation is estimated by Poisson pseudo-maximum likelihood, following Santos Silva and Tenreyro (2006), who show PPML is preferred over log-linear OLS when trade data contain zeros and heteroskedasticity, both present in this panel. The specification is:

$$X_{ijt} = \exp\left(\beta_1 \ln d_{ij} + \beta_2 \text{Lang}_{ij} + \beta_3 \text{Colony}_{ij} + \beta \, \text{IT}_{it} + \gamma \, \text{EPA}_{it} + \mu_{jt} + \eta_i\right)\varepsilon_{ijt}$$

where $X_{ijt}$ is the bilateral flow, $d_{ij}$ is distance, $\text{Lang}$ and $\text{Colony}$ are indicators for common official language and colonial tie, $\mu_{jt}$ are EU-partner by year fixed effects, and $\eta_i$ are ACP-country fixed effects. These fixed effects absorb the multilateral resistance terms Anderson and van Wincoop's derivation requires, without needing to estimate them directly, following the fixed-effects identification strategy Head and Mayer (2014) and Baier, Bergstrand, and Feng (2014) set out for gravity models with endogenous trade agreements. A separate year effect is not included because $\mu_{jt}$ spans it. All models are estimated with the fixest package in R (Bergé, 2018). Standard errors are clustered by ACP country throughout unless otherwise noted. Section 5.1 reports the sensitivity of the headline result to the choice of clustering level.

### The IT Share Form as a Testable Restriction

The IT share is built as a ratio, and writing it into the regression as one variable rather than two forces a restriction on the model. This section states that restriction and tests it. The underlying problem, a regression coefficient distorted when a regressor and an outcome share a common component, was first identified seven decades ago (Kuh and Meyer, 1955), and the gravity-trade version of it follows below.

Write $I_{ct}$ for country $c$'s intra-regional trade in year $t$, $T_{ct}$ for its total merchandise trade, $E_{ct}$ for its trade with the EU, and $N_{ct} = T_{ct} - E_{ct}$ for its trade with the rest of the world. The IT share and its ex-EU counterpart are

$$\text{IT}_{ct} = \frac{I_{ct}}{T_{ct}}, \qquad \text{IT}^{\text{ex-EU}}_{ct} = \frac{I_{ct}}{N_{ct}}$$

and, writing $s^{EU}_{ct} = E_{ct}/T_{ct}$ for the EU's share of the country's trade, the two are related by an identity:

$$\text{IT}_{ct} = \text{IT}^{\text{ex-EU}}_{ct}\left(1 - s^{EU}_{ct}\right) \qquad (1)$$

Equation (1) shows where the mechanical link comes from. The baseline regressor includes a term, $s^{EU}_{ct}$, that falls mechanically whenever the country's EU trade rises, and the dependent variable in every specification is a component of that same EU trade, since $E_{ct}$ is the sum of the bilateral flows across the EU partners. Part of any negative coefficient on $\text{IT}_{ct}$ is therefore arithmetic rather than economic. The EU absorbs roughly one-fifth of ACP merchandise trade over the sample on average, rising to 0.339 for Central Africa and 0.316 for ECOWAS and falling to 0.074 for PIF, so the channel is large enough to matter for every bloc in the sample.

Removing the EU from the denominator addresses the arithmetic but creates a scaling problem. Since the ex-EU share is larger than the IT share by a factor of $1/(1 - s^{EU})$, the two coefficients are not directly comparable in magnitude. A third measure holds the EU component of the denominator at each country's own average EU dependence rather than removing it entirely. Because that average does not vary over time, the mechanical channel disappears just as it does under full removal, but the resulting measure stays on the same scale as the original IT share:

$$\text{IT}^{\text{fix-EU}}_{ct} = \text{IT}^{\text{ex-EU}}_{ct}\left(1 - \bar{s}^{EU}_{c}\right), \qquad \bar{s}^{EU}_{c} = \frac{1}{T}\sum_t s^{EU}_{ct} \qquad (2)$$

This construction removes time variation in the denominator's EU component, the mechanical channel, while leaving time variation in intra-regional trade and non-EU trade untouched. Because equation (2) differs from the IT share only in replacing $s^{EU}_{ct}$ with its time-invariant average $\bar{s}^{EU}_{c}$, the two regressors are directly comparable in magnitude.

Beyond the denominator\'s contents, the ratio form itself creates a further problem. Taking logs,

$$\ln \text{IT}^{\text{ex-EU}}_{ct} = \ln I_{ct} - \ln N_{ct}$$

so entering the share as a single regressor is equivalent to entering numerator and denominator separately under the constraint

$$\beta_{I} = -\beta_{N} \qquad (3)$$

Equation (3) forces a one percent rise in intra-regional trade and a one percent rise in non-EU trade to move EU–ACP trade by equal and opposite amounts. This is an assumption the ratio form makes silently, not a prediction the stumbling-block hypothesis makes on its own terms. That hypothesis concerns composition, whether trade redirected toward regional partners displaces trade with the EU, which depends on how the numerator moves relative to the denominator, not on the two carrying equal and opposite coefficients. Estimating the numerator and denominator freely and checking whether $\beta_I + \beta_N$ equals zero tests equation (3) directly. Section 5.2 reports that test across three pairings.

**Separating the components**

Section 5.2 tests the restriction in equation (3) using three pairings of the ratio\'s components. Each pairing holds a different term fixed, which changes what the test actually shows.

One pairing regresses on $\ln I$ and $\ln N$ together, holding *total* non-EU trade fixed. Because $N = I + X$, where $X$ is extra-regional non-EU trade, raising $I$ at constant $N$ mechanically pushes $X$ down. This overlapping specification isolates reallocation, a dollar of non-EU trade moving from an extra-regional partner to a regional one, the composition shift the stumbling-block hypothesis is actually about.

The second pairing holds the opposite term fixed. Regressing on $\ln I$ and $\ln X$ instead, holding *extra-regional* trade fixed, so raising $I$ raises total non-EU trade rather than reallocating it. This disjoint pairing isolates expansion, a country trading more with its neighbors without trading less with anyone else. Overlapping is the more direct test of the stumbling-block hypothesis, while disjoint is the more conservative one, and the two need not agree.

The third pairing answers whether exports and imports should be pooled, or each matched to its own direction of trade. The first two pairings pool ACP exports to the EU with EU exports to ACP, using each country\'s total, bidirectional, intra-regional and non-EU trade as regressors for both directions at once. A directional trade shock, one that raises what a country sends its region without changing what it receives, is invisible to that pooled approach. The side-matched pairing corrects this by regressing EU exports to ACP markets on ACP intra-regional and non-EU imports, and ACP exports to the EU on ACP intra-regional and non-EU exports, so the regressor and the outcome always describe the same physical flow.

All three pairings are reported in Section 5.2. They answer different questions and should not be conflated.

## 5. Results

Section 5.1 reports the naive share coefficient: large, robust to every standard check. Sections 5.2 and 5.3 then show why that coefficient cannot be read as evidence of trade diversion. Readers who want the paper\'s conclusion before working through the mechanics can find it in the Introduction.

### 5.1 The Pooled Estimate

Table 1 presents the core specifications. Column (1) is the PPML baseline without the integration measure, estimated on column (2)\'s sample so the two are comparable. The distance elasticity sits within the range surveyed by Head and Mayer (2014), and the language and colonial-tie coefficients carry the expected positive signs.

**Table 1. Main results**

  -----------------------------------------------------------------------------------------------------------------------------
                              \(1\) Baseline        \(2\) IT Share (Main)   \(3\) Centered interaction   \(4\) IT Share OLS
  --------------------------- --------------------- ----------------------- ---------------------------- ----------------------
  ln(Distance)                −1.620 (0.996)        −1.626 (0.995)          −1.626 (0.994)               −1.023\*\*\* (0.329)

  Common Language             0.886\*\*\* (0.216)   0.885\*\*\* (0.216)     0.885\*\*\* (0.216)          0.575\*\*\* (0.123)

  Colonial Tie                0.344\* (0.200)       0.344\* (0.200)         0.345\* (0.200)              1.093\*\*\* (0.177)

  EPA (=1 in force)           −0.023 (0.066)        −0.043 (0.066)          −0.045 (0.063)               −0.173\*\* (0.079)

  IT Share                                          −2.482\*\*\* (0.651)                                 −1.871\*\*\* (0.456)

  IT Share (centered)                                                       −2.534\*\*\* (0.675)         

  EPA × IT Share (centered)                                                 −0.564 (0.417)               

  EU-partner × year FE        Yes                   Yes                     Yes                          Yes

  ACP-country FE              Yes                   Yes                     Yes                          Yes

  Observations                41,258                41,258                  41,258                       38,559
  -----------------------------------------------------------------------------------------------------------------------------

*Dependent variable: bilateral trade flow, columns (1)--(3), estimated by PPML; ln(trade), column (4), estimated by OLS. Standard errors clustered by ACP country in parentheses. \*\*\* p\<0.01, \*\* p\<0.05, \* p\<0.10. Column (1) is estimated on column (2)\'s sample. Column (3) centers IT Share at its sample mean, so the EPA coefficient there is the net EPA effect at mean integration.*

Adding the IT share in column (2) returns a coefficient of −2.482, with a standard error of 0.651, significant at the one percent level across 41,258 directed dyad-years. A one-standard-deviation increase in the integration share corresponds to 27.6 percent less bilateral trade \[−38.6, −14.5\], a stumbling-block effect of considerable size taken at face value. Further contrasts are reported in Table 2 (Supporting Information).

The estimate holds across alternative estimators, sample exclusions, and clustering choices. Negative binomial PML gives −2.449 (SE 0.543), while OLS on logged trade, which drops zero-trade dyads, gives −1.871 (SE 0.456), and OLS on log(1 + trade), which retains them, gives −1.635 (SE 0.418). The coefficient is similarly insensitive to which countries are excluded: dropping South Africa gives −2.262, dropping Nigeria gives −2.163, and dropping Somalia and Eritrea jointly leaves it essentially unchanged at −2.482, Somalia for lack of any REC assignment and Eritrea for a missing-GDP gap that keeps it out of estimation regardless. Dropping the SACU members gives −2.019, dropping the United Kingdom gives −2.223, and restricting to the African subsample alone gives −2.373. The result is also robust to clustering choice, staying significant at the one percent level whether standard errors are clustered on the dyad (SE 0.452), the ACP country (0.651), ACP country and EU partner (0.601), or ACP country and year (0.705).

This result is robust in every conventional sense, and no reasonable specification choice moves it. That stability does not resolve the question this section opened with, since a coefficient can be estimated with complete confidence and still reflect the ratio\'s arithmetic rather than the underlying economics.

### 5.2 The Share Form Is Rejected

Section 4.3 sets out three ways to test the share form. The overlapping specification holds total non-EU trade fixed, testing reallocation. The disjoint specification holds only extra-regional trade fixed, testing expansion. The side-matched specification matches each direction\'s flow to its own components. All three separate the intra-regional and non-EU terms that the share form forces together. Table 3 reports what happens to the coefficient itself under these different constructions, and Table 4 reports the formal test of the restriction they imply.

**Table 3. Alternative constructions of the integration measure**

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                  \(1\) Baseline         \(2\) Ex-EU denom.   \(3\) EU component fixed   \(4\) Denom. = total trade   \(5\) Denom. = non-EU trade
  ------------------------------- ---------------------- -------------------- -------------------------- ---------------------------- -----------------------------
  IT Share                        −2.482\*\*\* (0.651)                                                                                

  IT Share (ex-EU denom.)                                −0.263 (0.510)                                                               

  IT Share (EU component fixed)                                               −0.294 (0.716)                                          

  ln(Intra-REC trade)                                                                                    +0.017 (0.048)               +0.100\* (0.053)

  ln(Total trade)                                                                                        +0.697\*\*\* (0.077)         

  ln(Non-EU trade)                                                                                                                    +0.355\*\*\* (0.066)

  Observations                    41,258                 41,258               41,258                     39,659                       39,659
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------

*Dependent variable: bilateral trade flow, PPML. Standard errors clustered by ACP country in parentheses. \*\*\* p\<0.01, \* p\<0.10. Columns (1)--(3) keep the share form but change what the denominator contains; column (3) rescales the ex-EU share by each country\'s mean EU trade share, putting it on the same scale as column (1), which column (2) is not. Columns (4)--(5) leave the share form entirely and estimate the two components freely. Column (5) is the same regression as Table 4\'s \"Overlapping: Bilateral\" row, reported here again for direct comparison with columns (1)--(4).*

Columns (2) and (3) hold the EU out of the denominator in two different ways. Removing the EU from the denominator entirely gives −0.263. Holding the EU\'s share at each country\'s own average gives −0.294. Neither construction depends on the other for its result, so the two corroborate each other.

Columns (4) and (5) show why. Column (4) keeps the EU trade that the dependent variable is drawn from inside the denominator, the exact comparison columns (1)--(3) were built to avoid, and its denominator coefficient is large and significant at +0.697 while the intra-regional coefficient collapses to an insignificant +0.017. Column (5) removes the EU from the denominator instead, and the intra-regional coefficient recovers to a significant +0.100, with the non-EU denominator coefficient at +0.355. The same mechanism produces both results: when the denominator contains the dependent variable, its coefficient absorbs the correlation and the intra-regional coefficient shrinks toward zero or reverses sign.

Table 4 turns column (5) into a formal test. Because the share form\'s log identity forces the intra-regional and non-EU terms to carry equal and opposite coefficients, estimating the two terms freely and checking whether their sum equals zero tests that restriction directly.

**Table 4. Test of the ratio restriction, $\beta_{\text{num}} + \beta_{\text{den}} = 0$**

  ----------------------------------------------------------------------------------------------------------------
  Specification   Cell        $\beta_{\text{num}}$   $\beta_{\text{den}}$   Sum              *t*
  --------------- ----------- --------------------------- --------------------------- ---------------- -----------
  Overlapping     Bilateral   +0.100 (0.053)              +0.355 (0.066)              +0.455 (0.083)   5.49

  Overlapping     ACP → EU    +0.156 (0.076)              +0.231 (0.094)              +0.388 (0.107)   3.63

  Overlapping     EU → ACP    +0.057 (0.042)              +0.435 (0.059)              +0.493 (0.072)   6.83

  Disjoint        Bilateral   +0.133 (0.053)              +0.291 (0.063)              +0.425 (0.082)   5.16

  Disjoint        ACP → EU    +0.191 (0.076)              +0.146 (0.094)              +0.337 (0.106)   3.16

  Disjoint        EU → ACP    +0.087 (0.042)              +0.399 (0.052)              +0.486 (0.070)   6.94

  Side-matched    EU → ACP    −0.028 (0.024)              +0.572 (0.063)              +0.544 (0.055)   9.90

  Side-matched    ACP → EU    +0.148 (0.043)              +0.040 (0.068)              +0.188 (0.071)   2.65
  ----------------------------------------------------------------------------------------------------------------

*PPML with EU-partner by year and ACP-country fixed effects, n = 39,483 to 39,659 depending on cell. Standard errors clustered by ACP country. The \"Overlapping: Bilateral\" row repeats Table 3, column (5).*

The restriction fails in every cell. The overlapping bilateral sum is +0.455 (SE 0.083, t = 5.49), and the disjoint bilateral sum is +0.425 (SE 0.082, t = 5.16), with every directional and side-matched cell rejecting as well, t-statistics ranging from 2.65 to 9.90. Every numerator coefficient in the table is positive, and an equal-and-opposite constraint cannot hold when both coefficients are positive. To satisfy the restriction anyway, the estimation pushes one coefficient negative, and that forced negative coefficient is where the share form\'s large negative estimate actually comes from.

The share specification, differentiated at the sample mean IT share of roughly 0.12, implies an elasticity of bilateral trade with respect to intra-regional trade of approximately −2.482 × 0.12 ≈ −0.30. The directly estimated expansion elasticity is +0.133. The two estimates disagree on both sign and magnitude.

### 5.3 Splitting by Direction

In the naive share form, both trade directions return a negative coefficient of similar size, ACP exports to the EU at −2.616 (SE 1.019) and EU exports to ACP markets at −2.258 (SE 0.482), reported in full in Table 5 (Supporting Information). Neither direction can be distinguished from the other on this evidence, since splitting the share form by direction leaves the same denominator problem sitting in both halves of the data.

The positive evidence comes from a different construction, already reported in Table 4. Section 4.3\'s side-matched pairing regresses each direction\'s flow on its own directional components rather than on the pooled share, and the two directions diverge sharply. ACP exports to Europe carry a positive and significant coefficient on intra-regional exports, +0.148 (SE 0.043, \"Side-matched: ACP → EU\"), while EU exports to ACP markets show no comparable relationship with intra-regional imports, −0.028 (SE 0.024, \"Side-matched: EU → ACP\"). Matched correctly to direction, then, the only surviving link between intra-regional trade and EU trade runs from ACP intra-regional exports to ACP exports toward Europe, consistent with regional production networks feeding exports toward the EU market rather than competing with them. This pairing\'s other cell delivers the sharpest rejection of the restriction anywhere in Table 4: non-EU imports enter the EU-exports equation at +0.572, t = 9.90.

A share-form robustness check on the same two directions (Table 10, Supporting Information) tells a different story. Holding the EU component of the denominator fixed, ACP exports to the EU stay indistinguishable from zero at +1.362 (SE 1.009), while EU exports to ACP markets carry a significant negative coefficient of −1.738 (SE 0.462). A second construction, built from each direction\'s own ex-EU trade flows only, reproduces the same split: ACP exports insignificant at +0.471 (SE 0.374), EU exports significant at −1.252 (SE 0.268). Both constructions keep the share form\'s ratio structure rather than estimating components directly, so unlike the side-matched rows above, they still inherit the denominator problem documented in Section 5.2, and the asymmetry runs the opposite way from before: there, the ACP-exports direction carried the detectable positive relationship, while here it is the EU-exports direction that stays significant.

Taken together, these four directional checks, side-matched components, the EU-fixed share, and the direction-matched ex-EU share, all point to the same conclusion about the pooled result: the naive pooled share form in Table 5 overstates diversion in both directions. They do not settle, however, which direction, if either, carries a genuine residual relationship once the ratio\'s mechanics are addressed. This paper treats that directional asymmetry as an open question, unlike the pooled null, which the evidence above resolves.

### 5.4 Regional Groupings and Economic Partnership Agreements

Two further checks ask whether the pooled result conceals meaningful structure: does the effect vary systematically by REC, and does it vary with EPA status? Both were tested, and neither changes the paper\'s conclusion or warrants development beyond a direct report of the result.

**By REC.** Table 6 reports integration slopes by bloc from a single interaction model, holding the fixed-effect structure and gravity controls constant across groupings. These slopes use the same naive share measure Section 5.2 shows is entangled with the denominator, so they should be read as a map of which blocs are most exposed to the ratio\'s arithmetic, in rough proportion to each bloc\'s EU trade share, rather than as a ranking of true diversion. Four of seven blocs are individually significant: ECOWAS at −3.345 (SE 0.530), SADC at −3.439 (SE 1.131), CARIFORUM at −2.538 (SE 1.029), and PIF at −26.30 (SE 12.93) on a bloc whose mean integration share is thin and whose within-country variation is limited. Central Africa (+1.827, SE 2.211), the EAC (−12.60, SE 12.69), and ESA (−1.711, SE 1.167) are not statistically distinguishable from zero.

**Table 6. REC heterogeneity in the integration slope**

  --------------------------------------------------------------------------------------
                               \(1\) Free slopes by REC   \(2\) Deviations from ECOWAS
  ---------------------------- -------------------------- ------------------------------
  IT Share × ECOWAS            −3.345\*\*\* (0.530)       

  IT Share × Central Africa    +1.827 (2.211)             

  IT Share × SADC              −3.439\*\*\* (1.131)       

  IT Share × EAC               −12.60 (12.69)             

  IT Share × ESA               −1.711 (1.167)             

  IT Share × CARIFORUM         −2.538\*\* (1.029)         

  IT Share × PIF               −26.30\*\* (12.93)         

  IT Share (ECOWAS baseline)                              −3.345\*\*\* (0.530)

  dev_CAF                                                 +5.172\*\* (2.264)

  dev_SADC                                                −0.094 (1.173)

  dev_EAC                                                 −9.255 (12.66)

  dev_ESA                                                 +1.635 (1.290)

  dev_CARIFORUM                                           +0.807 (1.109)

  dev_PIF                                                 −22.96\* (12.93)

  Observations                 41,258                     41,258
  --------------------------------------------------------------------------------------

*Single pooled model; REC main effects absorbed by the ACP-country fixed effect. Gravity controls (distance, common language, colonial tie) and EPA status included in both columns; coefficients directly comparable across blocs and to the pooled estimate in Table 1. Column (2) reparametrizes column (1) with ECOWAS as the reference bloc, so each \"dev\_\" coefficient is that bloc\'s slope relative to ECOWAS\'s, not relative to zero. The two columns answer different questions, discussed further below. Standard errors clustered by ACP country in parentheses. \*\*\* p\<0.01, \*\* p\<0.05, \* p\<0.10.*

Table 6\'s second column reparametrizes the same model with ECOWAS as the reference bloc, chosen for its size as the largest bloc by country count rather than for any substantive weight of its own. Each REC\'s coefficient in that column reads as a deviation from ECOWAS\'s slope rather than an absolute effect, the standard way to test jointly whether the seven blocs\' slopes differ from one another. Central Africa\'s deviation is significant under this parameterization (+5.172, SE 2.264) even though its absolute slope in column (1) is not, and PIF\'s deviation is significant at the ten percent level (−22.96, SE 12.93). Both blocs share a currency feature that could explain the gap: Central Africa\'s members include the CEMAC franc zone, and PIF includes several economies that peg to or use the US, Australian, or New Zealand dollar outright.

Interacting IT Share with each bloc\'s currency arrangement confirms this for Central Africa and PIF. The CEMAC franc-zone interaction, significant at the one percent level, shrinks Central Africa\'s ECOWAS-relative deviation by 95 percent, to +0.256 (SE 1.01), no longer distinguishable from zero. The Pacific dollarization interaction, significant at the ten percent level, shrinks PIF\'s deviation by a similar 88 percent, to −2.70 (SE 6.07), also no longer significant.

The same test on three further arrangements, the Comoros franc peg within ESA, the CMA rand peg within SADC, and the ECCU dollar peg within CARIFORUM, finds no comparable shrinkage. All three deviations were already statistically indistinguishable from zero in column (2), so there is nothing significant for a currency interaction to close, and none of the three interactions reaches significance. WAEMU, nested inside ECOWAS with no deviation term of its own, is tested the same way and comes back null as well.

Central Africa\'s and PIF\'s departures from the pooled pattern are explained by their currency arrangements. The other three pegged blocs remain an open question, since Comoros in particular is identified off a single country and the tests there lack the power to confirm or rule out the same mechanism. The pooled pattern itself does not depend on single bloc\'s inclusion: dropping each REC in turn from the pooled regression leaves the coefficient significant at the one percent level in six of seven cases, ranging from −2.026 (SADC excluded) to −3.277 (Central Africa excluded), with only ECOWAS\'s exclusion weakening it to significance at the ten percent level (−1.690, SE 0.978).

**EPA status.** At the sample mean level of integration, EPA status carries no detectable net effect on bilateral trade. Column (3) of Table 1 centers IT Share at its sample mean, so the EPA coefficient there gives the net EPA effect at that mean: −0.045 (SE 0.063), indistinguishable from zero, and the EPA-by-integration interaction is likewise insignificant at −0.564 (SE 0.417). This matches Stender et al. (2021), who also find no general increase in EU--ACP trade following EPA implementation.

Splitting the EPA coefficient by direction of trade shows a significant negative effect specifically in the EU-exports-to-ACP equation, −0.123 (SE 0.060, Table 5, column 3), with no corresponding effect on the ACP-exports-to-EU side. An in-force EPA is associated with ACP countries buying roughly twelve percent less from the EU, with no change in what they sell to it. That estimate is descriptive rather than causal, since EPA timing is not randomly assigned across countries. Testing whether the pattern holds up causally would require a staggered difference-in-differences design keyed to each country\'s EPA date, a design this paper does not implement.

### 5.5 Robustness Checks

**Confound Controls.** The naive coefficient is also robust to a battery of confound controls and alternative specifications (Table 7), reported here for completeness rather than as evidence bearing on the paper\'s argument, since Sections 5.2--5.3 already show that robustness of this kind does not resolve the arithmetic problem. Controlling for ACP market size (GDP and population), income similarity (a Linder-type EU--ACP GDP-per-capita gap, testing whether countries with comparable income levels simply trade more), and trade concentration (an EU-partner Herfindahl index and an HS-chapter export Herfindahl index, testing whether a few dominant partners or product categories rather than REC identity drive the result) leaves the coefficient between −1.80 and −2.42 throughout, with none of the added controls itself significant except the Linder gap, which enters negatively as the hypothesis predicts.

Interacting IT Share directly with each of six currency-union flags, rather than entering them as levels which would be collinear with the ACP-country fixed effect, raises the coefficient to −3.847 (SE 0.771, not directly comparable to the baseline since six additional interaction terms reallocate variance). Two of the six, CEMAC and CMA, are themselves significant and positive, consistent with the currency-channel finding in Section 5.4 though not a confirmation of it at this level of granularity. IT Intensity, which rescales the integration share by the REC\'s share of world trade, returns a small but significant −0.011 (SE 0.006). Like the naive share itself, it does not address the denominator problem, since it inherits Section 4.3\'s arithmetic intact.

**Sample Restrictions.** The result is similarly insensitive to sample construction (Table 8). Restricting the start year to 2007, the point at which Burundi, Rwanda, Kenya, Uganda, and Tanzania all shift REC affiliation into the EAC (Section 4.1), weakens the estimate to −1.751 (SE 0.529) but leaves it significant. Extending back to 1995 strengthens it to −2.741 (SE 0.675) on 45,731 observations, though this reintroduces the SACU coverage gap discussed in Section 4.1. Splitting the sample by period shows why the coefficient moves with the window: −2.930 (SE 0.729) for 2000--2007, −2.037 (SE 0.722) for 2008--2014, and +0.107 (SE 0.827), not significantly different from zero, for 2015--2021, falling in step with the EU\'s mean trade share, which drops from 0.267 to 0.168 over the same span, the direction the arithmetic account in Section 4.3 predicts even if not its exact magnitude. Clustering choice does not affect significance, as already reported in Section 5.1.

**Share and Value Trends.** A simpler comparison tells the same story as the formal tests above. Within every REC for which the comparison can be computed, the EU\'s trade share has fallen since 2000 while the logged value of EU--ACP trade has risen over the same period: ECOWAS (share down 21 percentage points, value up 162 percent), Central Africa (down 24 points, up 168 percent), SADC (down 17 points, up 155 percent), ESA (down 22 points, up 62 percent), CARIFORUM (down 9 points, up 12 percent), and PIF (down 4 points, up 156 percent). The EAC\'s comparison could not be computed reliably, consistent with its very low mean IT share noted in Section 4.3.

A falling share alongside a rising value is exactly the pattern the paper\'s arithmetic account predicts: a growing denominator mechanically pulls the ratio down even as the numerator, absolute EU--ACP trade, continues to grow. This holds without exception across every bloc where the underlying trade values support the comparison.

**Diversion to Non-EU Partners**.

A different kind of check tests whether regional integration diverts trade from major non-EU partners specifically, using two complementary constructions (Table 9): substituting China\'s and the United States\' bilateral trade with ACP countries for EU trade as the outcome, and adding each partner\'s trade share as a covariate in the EU regression itself. The first finds no evidence of diversion: China\'s intra-REC coefficient is −0.047 (SE 0.039, n = 1,564) and the United States\' is +0.035 (SE 0.086, n = 1,586), neither distinguishable from zero. Both partners\' extra-regional coefficients, by contrast, are strongly positive (+0.953 and +0.896, both p \< 0.01). That kind of partner-specific diversion would show up as a negative, significant slope on intra-REC trade. Instead the pattern is null for both, alongside general trade growth.

The second approach controls for each partner\'s rising trade share directly rather than treating it as a separate outcome. Adding China\'s trade share as a covariate in the EU disjoint-bilateral regression (log-spec sample, n = 39,659) leaves the expansion elasticity intact at +0.118 (SE 0.053, against +0.133 without the control), with China\'s own share entering negatively (−0.845, SE 0.471, Table 9, rows 5--7). Adding the US\'s trade share instead gives an almost identical result, +0.119 (SE 0.051), with the US\'s own share entering negatively as well, −1.732 (SE 0.440, p \< 0.01, Table 9, rows 8--10). Combined with the EU-side expansion elasticity in Section 5.2, these results form a third independent line of evidence for general trade growth rather than targeted diversion.

## 6. Conclusion

Regional integration in the ACP setting looks like a stumbling block only because the standard way of measuring it recycles the dependent variable it is meant to explain. The intra-REC trade share carries a coefficient of −2.482, precisely estimated and unmoved by any of the checks in Section 5.1, but the share\'s denominator, total trade, contains the EU trade the model is built to explain. Holding the EU\'s contribution to that denominator fixed instead of letting it move with the regressor removes the coefficient\'s negative sign entirely, down to −0.294 (SE 0.716). Estimating the ratio\'s numerator and denominator as separate terms confirms the mechanism directly. The equal-and-opposite restriction the share form imposes is rejected in every specification tested, and the numerator coefficient is positive throughout.

Intra-regional exports raise ACP exports to the EU, a positive and significant relationship of +0.148, while the same relationship estimated on the import side is a statistical zero. That asymmetry is consistent with regional production feeding exports outward toward European markets rather than displacing them. The same pattern holds outside the EU relationship. Substituting China\'s or the United States\' bilateral trade for the EU\'s as the outcome turns up no evidence of diversion toward either partner, and the EU-side relationship itself is unchanged once each partner\'s own rising trade share is added directly as a control.

The naive coefficient\'s variation across RECs is sharpest in Central Africa and the Pacific Islands Forum, and shrinks by 95 and 88 percent respectively once each bloc\'s currency arrangement, the CEMAC franc peg in one case and Pacific dollarization in the other, is entered directly. EPA implementation shows no net effect on total EU--ACP trade, consistent with earlier work on the same question. Splitting the coefficient by direction shows a real asymmetry, however. EU exports to ACP markets fall by roughly twelve percent under an in-force agreement, while ACP exports to the EU show no corresponding change. Confirming that pattern causally would require a staggered difference-in-differences design keyed to each country\'s own EPA date, the extension Section 5.4 sketches but does not implement here.

Splitting the results by direction uncovers one asymmetry that this paper cannot yet resolve. Matching each direction\'s trade flow to its own components finds a positive, significant relationship on the ACP-exports side and a null on the EU-exports side. Holding the EU\'s denominator share fixed instead reverses that pattern, finding the EU-exports side significant and the ACP-exports side null. Both corrected constructions treat the naive pooled coefficient as spurious. Where they part is on which direction, if either, still carries a residual relationship once the ratio\'s mechanics are addressed. This paper treats that split as a question for further work rather than forcing a resolution the evidence does not support.

Any gravity specification that regresses bilateral trade on an intra-regional share carries the same identity, regardless of the bloc or reference partner involved. The resulting bias scales with the outside partner\'s share of the country\'s total trade, roughly one-fifth on average in this sample. Estimating the ratio\'s components separately costs one additional regression, and checking whether their coefficients sum to zero takes only a few lines of algebra, well within reach of any study using this kind of measure. Share-form diversion estimates reported without that check may simply be measuring the same arithmetic rather than a genuine trade effect.

A null result does not prove the absence of an effect, since the component estimates here are small and their confidence intervals admit modest effects in either direction. The identification is also associational rather than causal. ACP-country by year fixed effects would absorb the regressor of interest entirely, so country-specific growth is controlled only by entering GDP and population directly. Instrumenting integration depth with tariff-liberalization episodes or corridor-infrastructure investment remains the most direct route to a causal reading.

Each country here is assigned to a single REC based on its EPA-negotiating track, the same logic Cotonou itself uses. Many ACP countries hold overlapping memberships in practice, though, and a coding that recognized simultaneous memberships would assign trade differently, potentially shifting results for the blocs where dual membership is most common. This paper does not attempt to settle which REC-assignment convention is correct. The sample also closes in 2021, before the African Continental Free Trade Area had materially altered intra-African flows. AfCFTA will raise intra-regional shares substantially for ECOWAS and ESA members in particular, and any study of its trade effects will run into the same measurement problem documented here, on a larger denominator.

Overlapping commitments across AfCFTA, the EPAs, and individual REC frameworks create the kind of fragmented trade governance Bhagwati (1993) warned against, and whether deepening African regionalism comes at Europe\'s expense is a live question for policymakers on both continents, not just for the estimates in this paper. Langan and Price (2025) document the resulting tension in EU--Africa trade diplomacy directly, through interviews with African officials weighing deeper continental integration against existing EPA commitments. Stack (2024) finds that African free trade and partial-scope agreements raise extra-African exports rather than displacing them, a pattern consistent with the absence of diversion this paper documents for the EU specifically. The share-form coefficients most often cited as evidence of displacement, in the ACP literature and elsewhere, do not establish it. Settling the question, as AfCFTA advances, will require specifications that keep the outcome out of the regressor.

## Supporting Information

Additional supporting information may be found online: data provenance for the BACI coverage gap and REC-accession timing corrections (S.1--S.2), and Tables 2, 5, 7, 8, and 9 in full (S.3).

## References

Afesorgbor, S.K. (2017). Revisiting the effect of regional integration on African trade: Evidence from meta-analysis and gravity model. *Journal of International Trade & Economic Development*, 26(2), 133--153. https://doi.org/10.1080/09638199.2016.1219381

Anderson, J.E. and van Wincoop, E. (2003). Gravity with gravitas: A solution to the border puzzle. *American Economic Review*, 93(1), 170--192. https://doi.org/10.1257/000282803321455214

Baier, S.L. and Bergstrand, J.H. (2007). Do free trade agreements actually increase members' international trade? *Journal of International Economics*, 71(1), 72--95. https://doi.org/10.1016/j.jinteco.2006.02.005

Baier, S.L., Bergstrand, J.H., and Feng, M. (2014). Economic integration agreements and the margins of international trade. *Journal of International Economics*, 93(2), 339--350. https://doi.org/10.1016/j.jinteco.2014.03.005

Baier, S.L., Yotov, Y.V., and Zylkin, T. (2019). On the widely differing effects of free trade agreements: Lessons from twenty years of trade integration. *Journal of International Economics*, 116, 206--226. https://doi.org/10.1016/j.jinteco.2018.11.002

Baldwin, R. and Venables, A.J. (1995). Regional economic integration. In G.M. Grossman and K. Rogoff (Eds.), *Handbook of International Economics*, Volume 3 (pp. 1597--1644). North-Holland. https://doi.org/10.1016/S1573-4404(05)80011-5

Bergé, L. (2018). Efficient estimation of maximum likelihood models with multiple fixed-effects: the R package FENmlm. CREA Discussion Papers, 13. University of Luxembourg. [No DOI — working paper]

Bhagwati, J. (1993). Regionalism and multilateralism: An overview. In J. de Melo and A. Panagariya (Eds.), *New Dimensions in Regional Integration* (pp. 22--51). Cambridge University Press. https://doi.org/10.1017/CBO9780511628511.004

Carrère, C. (2004). African regional agreements: Impact on trade with or without currency unions. *Journal of African Economies*, 13(2), 199--239. https://doi.org/10.1093/jae/ejh010

Conte, M., Cotterlaz, P., and Mayer, T. (2022). The CEPII Gravity database. CEPII Working Paper No. 2022-05. Centre d'Études Prospectives et d'Informations Internationales, Paris. [Data version: V202211.] [No DOI — working paper]

European Union (various years). *Official Journal of the European Union*: Economic Partnership Agreement provisional application notices. Publications Office of the European Union, Luxembourg. https://eur-lex.europa.eu [No DOI — institutional source]

Frankel, J., Stein, E., and Wei, S.J. (1995). Trading blocs and the Americas: The natural, the unnatural, and the super-natural. *Journal of Development Economics*, 47(1), 61--95. https://doi.org/10.1016/0304-3878(95)00005-4

Freund, C. and Ornelas, E. (2010). Regional trade agreements. *Annual Review of Economics*, 2, 139--166. https://doi.org/10.1146/annurev.economics.102308.124455

Gaulier, G. and Zignago, S. (2010). BACI: International trade database at the product level. CEPII Working Paper No. 2010-23. Centre d'Études Prospectives et d'Informations Internationales, Paris. [Data version: HS92 V202601.] [No DOI — working paper]

Head, K. and Mayer, T. (2014). Gravity equations: Workhorse, toolkit, and cookbook. *Handbook of International Economics*, 4, 131--195. https://doi.org/10.1016/B978-0-444-54314-1.00003-3

Kuh, E. and Meyer, J.R. (1955). Correlation and regression estimates when the data are ratios. *Econometrica*, 23(4), 400--416. https://doi.org/10.2307/1905347

Langan, M. and Price, S. (2025). The frustrations of free trade and the Africa--European Union Samoa Agreement. *Journal of Developing Societies*, 41(1), 7--34. https://doi.org/10.1177/0169796X241304455

Nguyen, D.B. (2019). A new examination of the impacts of regional trade agreements on international trade patterns. *Journal of Economic Integration*, 34(2), 236--279. https://doi.org/10.11130/JEI.2019.34.2.236

Pacific Community (SPC) (various years). Pacific Data Hub --- National Minimum Development Indicators. Statistics for Development Division, Noumea, New Caledonia. https://pacificdata.org [No DOI — data source]

Rayp, G. and Standaert, S. (2017). Measuring actual economic integration: A Bayesian state-space approach. In *Indicator-Based Monitoring of Regional Economic Integration* (pp. 341--360). Springer. https://doi.org/10.1007/978-3-319-50860-3_16

Rodrik, D. (2018). What do trade agreements really do? *Journal of Economic Perspectives*, 32(2), 73--90. https://doi.org/10.1257/jep.32.2.73

Rose, A.K. (2004). Do we really know that the WTO increases trade? *American Economic Review*, 94(1), 98--114. https://doi.org/10.1257/000282804322970724

Santos Silva, J.M.C. and Tenreyro, S. (2006). The log of gravity. *Review of Economics and Statistics*, 88(4), 641--658. https://doi.org/10.1162/rest.88.4.641

Stack, M.M., Amissah, E.B., and Bliss, M. (2024). African economic integration and trade. *The World Economy*, 47(5), 2122--2146. https://doi.org/10.1111/twec.13538

Stender, F., Berger, A., Brandi, C., and Schwab, J. (2021). The trade effects of the economic partnership agreements between the European Union and the African, Caribbean and Pacific group of states: Early empirical insights from panel data. *JCMS: Journal of Common Market Studies*, 59(6), 1495--1515. https://doi.org/10.1111/jcms.13201

Tinbergen, J. (1962). *Shaping the World Economy: Suggestions for an International Economic Policy*. Twentieth Century Fund. [No DOI — book]

Urata, S. and Okabe, M. (2014). Trade creation and diversion effects of regional trade agreements: A product-level analysis. *The World Economy*, 37(2), 267--289. https://doi.org/10.1111/twec.12099

World Bank (2024). World Development Indicators. The World Bank Group, Washington, DC. https://databank.worldbank.org/source/world-development-indicators [No DOI — data source]
