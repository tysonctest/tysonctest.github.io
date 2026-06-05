*******************************************************
* 03_regressions_main.do
* Tyson Test - Honors thesis portfolio code
* Purpose: cleaned, relative-path version for portfolio review.
* Note: raw data are not included in the public portfolio.
*******************************************************
clear all
set more off

*******************************************************
* Portfolio version notes
* Set this to the folder containing the data/ and outputs/ folders.
* If running from the repository root, the default below is sufficient.
*******************************************************
global PROJECT_ROOT "."
cd "$PROJECT_ROOT"
capture mkdir "outputs"

*******************************************************
* 03_regressions.do
* Tyson Test - Honors Thesis regressions + VIFs
*******************************************************
use "data/final_analysis_dataset.dta", clear
*------------------------------------------------------
* Helper: remind Stata of time dimension (optional)
*------------------------------------------------------
tsset year
*******************************************************
* A. SPEC (1): Baseline interaction, full sample
*    real_rate_us on deficit_pos, old_dep_ratio, interaction
*******************************************************
* OLS with robust SEs
reg real_rate_us c.deficit_pos##c.old_dep_ratio, vce(robust)

* VIF for Spec (1)
estat vif

* Newey-West with 3 lags (no VIF here)
newey real_rate_us c.deficit_pos##c.old_dep_ratio, lag(3)

* Marginal effects of a 1-ppt increase in the deficit
margins, dydx(deficit_pos) at(old_dep_ratio = (15(2)27))

marginsplot, ///
    ytitle("Effect of deficit (% GDP) on real 10y rate") ///
    xtitle("Old-age dependency ratio") ///
    title("Marginal effect of deficit across demography")

* graph export "outputs/mfx_deficit_by_olddep_spec1.png", replace
*******************************************************
* B. SPEC (2): Baseline + basic macro controls
*    Add term_spread, u_nat, psav_rate
*******************************************************
* OLS with robust SEs
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate, vce(robust)

* VIF for Spec (2)
estat vif

* Newey-West
newey real_rate_us c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate, lag(3)
*******************************************************
* C. SPEC (3): Spec B – modern era with capital flows
*    Core interaction + global rate + cyclical u + inflows + saving
*    Sample automatically restricted by nf_total_in
*******************************************************
* OLS with robust SEs
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_cyc nf_total_in psav_rate, vce(robust)

* VIF for Spec (3)
estat vif

* Newey-West
newey real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_cyc nf_total_in psav_rate, lag(3)
*******************************************************
* D. SPEC (4): Committee spec with yellow vars
*    Core interaction + real_rate_ger + u_act + psav_rate + receipts_gdp
*******************************************************
* OLS with robust SEs
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_act psav_rate receipts_gdp, vce(robust)

* VIF for Spec (4)
estat vif

* Newey-West
newey real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_act psav_rate receipts_gdp, lag(3)
*******************************************************
* E. SPEC (5): Kitchen-sink model (no red vars bs_gdp, mand_gdp)
*    Very saturated spec to show multicollinearity
*******************************************************
* OLS with robust SEs
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    receipts_gdp real_rate_ger ///
    nf_equity_in nf_debt_in nf_total_in ///
    omo_gdp us_invest_gdp us_debt_gdp ///
    discr_gdp netint_gdp ///
    psav_rate u_nat u_act u_cyc ///
    term_spread baa_spread mcap_gdp eq_risk_prem, vce(robust)

* VIF for kitchen-sink spec
estat vif

* Newey-West
newey real_rate_us c.deficit_pos##c.old_dep_ratio ///
    receipts_gdp real_rate_ger ///
    nf_equity_in nf_debt_in nf_total_in ///
    omo_gdp us_invest_gdp us_debt_gdp ///
    discr_gdp netint_gdp ///
    psav_rate u_nat u_act u_cyc ///
    term_spread baa_spread mcap_gdp eq_risk_prem, lag(3)
*******************************************************
* F. Subsample robustness: pre- vs post-1991
*    Matches Table 3 (baseline vs + global & inflows)
*    Also generates the marginal-effects figure for Column (4).
*******************************************************
* Store estimates so esttab/eststo can export Table 3
cap which esttab
if _rc {
    di as error "esttab/eststo not found. Install with: ssc install estout"
}

eststo clear

display "=================================================="
display "Pre-1991 sample: 1960–1990"

* (1) Pre-1991: baseline
eststo pre_base: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    if year <= 1990, vce(robust)

* (2) Pre-1991: + global & inflows
eststo pre_inflows: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)
display "=================================================="
display "Post-1990 sample: 1991–2023"
* Pre-1991 (1960–1990) baseline interaction: robust SEs + marginal effects plot
preserve
keep if inrange(year, 1960, 1990)

* Baseline regression (robust/Huber–White SEs)
reg real_rate_us c.deficit_pos##c.old_dep_ratio, vce(robust)

* Choose a sensible OADR grid based on the pre-1991 distribution (avoid extremes)
quietly summarize old_dep_ratio, detail
local lo = floor(r(p10))
local hi = ceil(r(p90))

* Marginal effect of a 1-pp increase in deficit_pos evaluated across OADR
margins, dydx(deficit_pos) at(old_dep_ratio = (`lo'(1)`hi'))

marginsplot, ///
    yline(0, lpattern(dash)) ///
    ytitle("Effect of deficit (% GDP) on real 10y rate") ///
    xtitle("Old-age dependency ratio") ///
    title("Marginal effect of deficit across demography (pre-1991)") ///
    name(mfx_pre1991, replace)

graph export "outputs/mfx_deficit_by_olddep_pre1991.png", width(2400) replace
restore
* (3) Post-1991: baseline
eststo post_base: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    if year >= 1991, vce(robust)

* (4) Post-1991: + global & inflows
eststo post_inflows: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

* ===== Marginal-effects figure for Table 3, Column (4) =====
di "Zero crossing at old_dep_ratio = " -_b[deficit_pos] / _b[c.deficit_pos#c.old_dep_ratio]

margins, dydx(deficit_pos) at(old_dep_ratio=(15(2)27))

marginsplot, ///
    yline(0) ///
    title("Marginal effect of deficit across demography") ///
    xtitle("Old-age dependency ratio") ///
    ytitle("Effect of deficit (% GDP) on real 10y rate")

graph save "outputs/marginal_effect_deficit_by_aging_post1991.gph", replace
graph export "outputs/marginal_effect_deficit_by_aging_post1991.png", width(2400) replace

* Export Table 3 to RTF (Word-friendly)
esttab pre_base pre_inflows post_base post_inflows ///
    using "thesis_regressions_pre_post_1991_inflows.rtf", ///
    replace ///
    b(%9.3f) se(%9.3f) ///
    stats(N r2 ar2, labels("N" "R-squared" "Adj. R-squared")) ///
    label ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("Pre- vs Post-1991 specifications with capital inflows")
*******************************************************
* End of 03_regressions.do
*******************************************************
