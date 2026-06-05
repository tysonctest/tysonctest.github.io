*******************************************************
* 07_prepost_capflows.do
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
* 05_prepost_capflows.do
* Pre- vs post-1991 regressions with capital inflows (Table 3)
*******************************************************
use "data/final_analysis_dataset.dta", clear
tsset year

* If not already installed, run this ONCE from the Command window (not here):
*   ssc install estout, replace
*   ssc install moremata, replace

eststo clear

*******************************************************
* A. Pre-1991 (1960–1990)
*******************************************************

* Spec 1 – Pre-1991 baseline: core interaction only
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    if year <= 1990, vce(robust)
eststo pre_base

* Spec 2 – Pre-1991 with inflows:
* core interaction + German real rate + total inflows + saving
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_in psav_rate ///
    if year <= 1990, vce(robust)
eststo pre_inflows
*------------------------------------------------------------
* Table 3 (Pre/Post 1991): Column (4) Post-1991 + global & inflows
*------------------------------------------------------------
eststo post_inflows: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year>=1991, vce(robust)

* Marginal effects figure for the post-1991 open-economy specification

di "Zero crossing at old_dep_ratio = " -_b[deficit_pos] / _b[c.deficit_pos#c.old_dep_ratio]

margins, dydx(deficit_pos) at(old_dep_ratio=(15(2)27))

marginsplot, ///
    yline(0) ///
    title("Marginal effect of deficit across demography") ///
    xtitle("Old-age dependency ratio") ///
    ytitle("Effect of deficit (% GDP) on real 10y rate")

graph save "outputs/marginal_effect_deficit_by_aging_post1991.gph", replace
graph export "outputs/marginal_effect_deficit_by_aging_post1991.png", width(2400) replace

* Continue with table exports
*******************************************************
* C. Export all four specs to an RTF table
*******************************************************
esttab pre_base pre_inflows post_base post_inflows ///
    using "thesis_regressions_pre_post_1991_inflows.rtf", ///
    replace ///
    b(%9.3f) se(%9.3f) ///
    stats(N r2 ar2, labels("N" "R-squared" "Adj. R-squared")) ///
    label ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("Pre- vs Post-1991 specifications with capital inflows (no u_nat)")

*******************************************************
* End of 05_pre_post_1991_inflows.do
*******************************************************
