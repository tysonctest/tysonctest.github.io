*******************************************************
* 04_regressions_alternate.do
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
* 03b_regressions_alternate.do
* Tyson Test - alternate regressions requested by chair
*
* Purpose:
*   1. Re-run pre- and post-1991 models without interaction
*   2. Re-run post-1991 model without Germany proxy
*   3. Add recession dummy
*   4. Add 1-year lag and optional 2-year lag checks
*   5. Export clean, labeled tables for review
*******************************************************

use "data/final_analysis_dataset.dta", clear

*------------------------------------------------------
* Set time variable
*------------------------------------------------------
tsset year

*------------------------------------------------------
* Recession dummy for annual data
* = 1 if any part of the calendar year was in NBER recession
*------------------------------------------------------
capture drop recession
gen recession = inlist(year, 1960,1961,1970,1974,1975,1980,1981,1982,1990,1991,2001,2008,2009,2020)

*******************************************************
* A. OLD MODEL (pre-1991) WITHOUT INTERACTION
*    Analog to pre_inflows, but no interaction term
*******************************************************
reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)

*******************************************************
* B. NEW MODEL (post-1991) WITHOUT INTERACTION
*    Analog to post_inflows, but no interaction term
*******************************************************
reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

*******************************************************
* C. NEW MODEL (post-1991) WITHOUT GERMANY PROXY
*    Drop real_rate_ger
*******************************************************
reg real_rate_us deficit_pos old_dep_ratio ///
    nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

*******************************************************
* D. OLD MODEL + RECESSION DUMMY
*******************************************************
reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year <= 1990, vce(robust)

*******************************************************
* E. NEW MODEL + RECESSION DUMMY
*******************************************************
reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

*******************************************************
* F. NEW MODEL WITHOUT GERMANY + RECESSION DUMMY
*******************************************************
reg real_rate_us deficit_pos old_dep_ratio ///
    nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

*******************************************************
* G. OLD MODEL + RECESSION DUMMY + 1-YEAR LAG
*******************************************************
reg real_rate_us L1.deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year <= 1990, vce(robust)

*******************************************************
* H. NEW MODEL + RECESSION DUMMY + 1-YEAR LAG
*******************************************************
reg real_rate_us L1.deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

*******************************************************
* I. NEW MODEL WITHOUT GERMANY + RECESSION DUMMY + 1-YEAR LAG
*******************************************************
reg real_rate_us L1.deficit_pos old_dep_ratio ///
    nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

*******************************************************
* J. OPTIONAL: 2-YEAR LAG VERSIONS
*    Keep in log for reference; not exported by default
*******************************************************
reg real_rate_us L2.deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year <= 1990, vce(robust)

reg real_rate_us L2.deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

reg real_rate_us L2.deficit_pos old_dep_ratio ///
    nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

*******************************************************
* K. EXPORT TABLES OF ALTERNATE REGRESSIONS
*******************************************************

cap which esttab
if _rc ssc install estout

eststo clear

*------------------------------------------------------
* Re-run and store selected models for export
*------------------------------------------------------

eststo A_old_nointer: reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)
estadd local subsamp "1960-1990"
estadd local germany "Yes"
estadd local recdum  "No"
estadd local lagdef  "No"

eststo B_new_nointer: reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)
estadd local subsamp "1991-2023"
estadd local germany "Yes"
estadd local recdum  "No"
estadd local lagdef  "No"

eststo C_new_noger: reg real_rate_us deficit_pos old_dep_ratio ///
    nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)
estadd local subsamp "1991-2023"
estadd local germany "No"
estadd local recdum  "No"
estadd local lagdef  "No"

eststo D_old_rec: reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year <= 1990, vce(robust)
estadd local subsamp "1960-1990"
estadd local germany "Yes"
estadd local recdum  "Yes"
estadd local lagdef  "No"

eststo E_new_rec: reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)
estadd local subsamp "1991-2023"
estadd local germany "Yes"
estadd local recdum  "Yes"
estadd local lagdef  "No"

eststo H_new_rec_l1: reg real_rate_us L1.deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)
estadd local subsamp "1991-2023"
estadd local germany "Yes"
estadd local recdum  "Yes"
estadd local lagdef  "L1"

eststo I_new_noger_l1: reg real_rate_us L1.deficit_pos old_dep_ratio ///
    nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)
estadd local subsamp "1991-2023"
estadd local germany "No"
estadd local recdum  "Yes"
estadd local lagdef  "L1"

*------------------------------------------------------
* TABLE 1: No interaction + recession checks (RTF)
*------------------------------------------------------
esttab A_old_nointer B_new_nointer C_new_noger D_old_rec E_new_rec ///
    using "alternate_regression_results_table1.rtf", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Pre-1991" ///
            "Post-1991" ///
            "Post-1991, no Germany" ///
            "Pre-1991 + recession" ///
            "Post-1991 + recession") ///
    nonumbers ///
    title("Alternate Regressions: No Interaction and Recession Checks") ///
    label ///
    stats(subsamp germany recdum lagdef N r2, ///
          labels("Sample" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        deficit_pos    "Federal deficit (% GDP)" ///
        old_dep_ratio  "Old-age dependency ratio" ///
        real_rate_ger  "German real long-term rate" ///
        nf_total_gdp   "Net foreign inflows (% GDP)" ///
        psav_rate      "Private saving rate" ///
        recession      "Recession dummy" ///
        _cons          "Constant" ///
    ) ///
    drop(_cons) ///
    compress

*------------------------------------------------------
* TABLE 2: Lagged deficit checks (RTF)
*------------------------------------------------------
esttab H_new_rec_l1 I_new_noger_l1 ///
    using "alternate_regression_results_table2.rtf", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Post-1991 + recession + L1" ///
            "Post-1991, no Germany + recession + L1") ///
    nonumbers ///
    title("Alternate Regressions: One-Year Lag of Deficit") ///
    label ///
    stats(subsamp germany recdum lagdef N r2, ///
          labels("Sample" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        L1.deficit_pos "Federal deficit (% GDP), 1-year lag" ///
        old_dep_ratio  "Old-age dependency ratio" ///
        real_rate_ger  "German real long-term rate" ///
        nf_total_gdp   "Net foreign inflows (% GDP)" ///
        psav_rate      "Private saving rate" ///
        recession      "Recession dummy" ///
        _cons          "Constant" ///
    ) ///
    drop(_cons) ///
    compress

*------------------------------------------------------
* TABLE 1: CSV export
*------------------------------------------------------
esttab A_old_nointer B_new_nointer C_new_noger D_old_rec E_new_rec ///
    using "alternate_regression_results_table1.csv", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Pre-1991" ///
            "Post-1991" ///
            "Post-1991, no Germany" ///
            "Pre-1991 + recession" ///
            "Post-1991 + recession") ///
    nonumbers ///
    label ///
    stats(subsamp germany recdum lagdef N r2, ///
          labels("Sample" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        deficit_pos    "Federal deficit (% GDP)" ///
        old_dep_ratio  "Old-age dependency ratio" ///
        real_rate_ger  "German real long-term rate" ///
        nf_total_gdp   "Net foreign inflows (% GDP)" ///
        psav_rate      "Private saving rate" ///
        recession      "Recession dummy" ///
        _cons          "Constant" ///
    ) ///
    drop(_cons) ///
    plain ///
    compress

*------------------------------------------------------
* TABLE 2: CSV export
*------------------------------------------------------
esttab H_new_rec_l1 I_new_noger_l1 ///
    using "alternate_regression_results_table2.csv", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Post-1991 + recession + L1" ///
            "Post-1991, no Germany + recession + L1") ///
    nonumbers ///
    label ///
    stats(subsamp germany recdum lagdef N r2, ///
          labels("Sample" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        L1.deficit_pos "Federal deficit (% GDP), 1-year lag" ///
        old_dep_ratio  "Old-age dependency ratio" ///
        real_rate_ger  "German real long-term rate" ///
        nf_total_gdp   "Net foreign inflows (% GDP)" ///
        psav_rate      "Private saving rate" ///
        recession      "Recession dummy" ///
        _cons          "Constant" ///
    ) ///
    drop(_cons) ///
    plain ///
    compress

display "Alternate regression tables exported to:"
display " - alternate_regression_results_table1.rtf"
display " - alternate_regression_results_table2.rtf"
display " - alternate_regression_results_table1.csv"
display " - alternate_regression_results_table2.csv"
