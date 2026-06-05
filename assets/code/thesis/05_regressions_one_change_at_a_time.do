*******************************************************
* 05_regressions_one_change_at_a_time.do
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
* 03c_regressions_one_change_at_a_time.do
* Tyson Test - one-change-at-a-time robustness checks
*
* Purpose:
*   For each subsample, start from the original model and
*   change only one thing at a time:
*     1. Baseline original model
*     2. Drop interaction only
*     3. Drop Germany only
*     4. Add recession dummy only
*     5. Use 1-year lag of deficit only
*
* Subsamples:
*   - Pre-1991  = year <= 1990
*   - Post-1990 = year >= 1991
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

*------------------------------------------------------
* 1-year lag of deficit
*------------------------------------------------------
capture drop l1_deficit_pos
gen l1_deficit_pos = L1.deficit_pos

*******************************************************
* A. DISPLAY REGRESSIONS IN LOG
*******************************************************

*------------------------------------------------------
* PRE-1991 BASELINE (original model)
*------------------------------------------------------
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)

* PRE-1991: drop interaction only
reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)

* PRE-1991: drop Germany only
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)

* PRE-1991: add recession dummy only
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year <= 1990, vce(robust)

* PRE-1991: use 1-year lag of deficit only
reg real_rate_us c.l1_deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)

*------------------------------------------------------
* POST-1990 BASELINE (original model)
*------------------------------------------------------
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

* POST-1990: drop interaction only
reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

* POST-1990: drop Germany only
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

* POST-1990: add recession dummy only
reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)

* POST-1990: use 1-year lag of deficit only
reg real_rate_us c.l1_deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)

*******************************************************
* B. EXPORT TABLES
*******************************************************

cap which esttab
if _rc ssc install estout

eststo clear

*------------------------------------------------------
* STORE PRE-1991 MODELS
*------------------------------------------------------
eststo pre_base: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)
estadd local interact "Yes"
estadd local germany  "Yes"
estadd local recdum   "No"
estadd local lagdef   "No"
estadd local change   "Baseline"

eststo pre_noint: reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)
estadd local interact "No"
estadd local germany  "Yes"
estadd local recdum   "No"
estadd local lagdef   "No"
estadd local change   "Drop interaction"

eststo pre_noger: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)
estadd local interact "Yes"
estadd local germany  "No"
estadd local recdum   "No"
estadd local lagdef   "No"
estadd local change   "Drop Germany"

eststo pre_rec: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year <= 1990, vce(robust)
estadd local interact "Yes"
estadd local germany  "Yes"
estadd local recdum   "Yes"
estadd local lagdef   "No"
estadd local change   "Add recession"

eststo pre_l1: reg real_rate_us c.l1_deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year <= 1990, vce(robust)
estadd local interact "Yes"
estadd local germany  "Yes"
estadd local recdum   "No"
estadd local lagdef   "L1"
estadd local change   "Lag deficit 1 year"

*------------------------------------------------------
* STORE POST-1990 MODELS
*------------------------------------------------------
eststo post_base: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)
estadd local interact "Yes"
estadd local germany  "Yes"
estadd local recdum   "No"
estadd local lagdef   "No"
estadd local change   "Baseline"

eststo post_noint: reg real_rate_us deficit_pos old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)
estadd local interact "No"
estadd local germany  "Yes"
estadd local recdum   "No"
estadd local lagdef   "No"
estadd local change   "Drop interaction"

eststo post_noger: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)
estadd local interact "Yes"
estadd local germany  "No"
estadd local recdum   "No"
estadd local lagdef   "No"
estadd local change   "Drop Germany"

eststo post_rec: reg real_rate_us c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate recession ///
    if year >= 1991, vce(robust)
estadd local interact "Yes"
estadd local germany  "Yes"
estadd local recdum   "Yes"
estadd local lagdef   "No"
estadd local change   "Add recession"

eststo post_l1: reg real_rate_us c.l1_deficit_pos##c.old_dep_ratio ///
    real_rate_ger nf_total_gdp psav_rate ///
    if year >= 1991, vce(robust)
estadd local interact "Yes"
estadd local germany  "Yes"
estadd local recdum   "No"
estadd local lagdef   "L1"
estadd local change   "Lag deficit 1 year"

*------------------------------------------------------
* PRE-1991 TABLE (RTF)
*------------------------------------------------------
esttab pre_base pre_noint pre_noger pre_rec pre_l1 ///
    using "one_change_pre1991.rtf", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Baseline" "No interaction" "No Germany" "+ Recession" "L1 deficit") ///
    nonumbers ///
    title("Pre-1991 Regressions: One Change at a Time") ///
    label ///
    stats(change interact germany recdum lagdef N r2, ///
          labels("Column change" "Interaction term" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        deficit_pos                           "Federal deficit (% GDP)" ///
        old_dep_ratio                         "Old-age dependency ratio" ///
        c.deficit_pos#c.old_dep_ratio         "Deficit × old-age dependency" ///
        l1_deficit_pos                        "Federal deficit (% GDP), 1-year lag" ///
        c.l1_deficit_pos#c.old_dep_ratio      "L1 deficit × old-age dependency" ///
        real_rate_ger                         "German real long-term rate" ///
        nf_total_gdp                          "Net foreign inflows (% GDP)" ///
        psav_rate                             "Private saving rate" ///
        recession                             "Recession dummy" ///
        _cons                                 "Constant" ///
    ) ///
    drop(_cons) ///
    compress

*------------------------------------------------------
* POST-1990 TABLE (RTF)
*------------------------------------------------------
esttab post_base post_noint post_noger post_rec post_l1 ///
    using "one_change_post1990.rtf", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Baseline" "No interaction" "No Germany" "+ Recession" "L1 deficit") ///
    nonumbers ///
    title("Post-1990 Regressions: One Change at a Time") ///
    label ///
    stats(change interact germany recdum lagdef N r2, ///
          labels("Column change" "Interaction term" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        deficit_pos                           "Federal deficit (% GDP)" ///
        old_dep_ratio                         "Old-age dependency ratio" ///
        c.deficit_pos#c.old_dep_ratio         "Deficit × old-age dependency" ///
        l1_deficit_pos                        "Federal deficit (% GDP), 1-year lag" ///
        c.l1_deficit_pos#c.old_dep_ratio      "L1 deficit × old-age dependency" ///
        real_rate_ger                         "German real long-term rate" ///
        nf_total_gdp                          "Net foreign inflows (% GDP)" ///
        psav_rate                             "Private saving rate" ///
        recession                             "Recession dummy" ///
        _cons                                 "Constant" ///
    ) ///
    drop(_cons) ///
    compress

*------------------------------------------------------
* PRE-1991 TABLE (CSV)
*------------------------------------------------------
esttab pre_base pre_noint pre_noger pre_rec pre_l1 ///
    using "one_change_pre1991.csv", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Baseline" "No interaction" "No Germany" "+ Recession" "L1 deficit") ///
    nonumbers ///
    label ///
    stats(change interact germany recdum lagdef N r2, ///
          labels("Column change" "Interaction term" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        deficit_pos                           "Federal deficit (% GDP)" ///
        old_dep_ratio                         "Old-age dependency ratio" ///
        c.deficit_pos#c.old_dep_ratio         "Deficit × old-age dependency" ///
        l1_deficit_pos                        "Federal deficit (% GDP), 1-year lag" ///
        c.l1_deficit_pos#c.old_dep_ratio      "L1 deficit × old-age dependency" ///
        real_rate_ger                         "German real long-term rate" ///
        nf_total_gdp                          "Net foreign inflows (% GDP)" ///
        psav_rate                             "Private saving rate" ///
        recession                             "Recession dummy" ///
        _cons                                 "Constant" ///
    ) ///
    drop(_cons) ///
    plain ///
    compress

*------------------------------------------------------
* POST-1990 TABLE (CSV)
*------------------------------------------------------
esttab post_base post_noint post_noger post_rec post_l1 ///
    using "one_change_post1990.csv", replace ///
    b(%9.2f) se(%9.2f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Baseline" "No interaction" "No Germany" "+ Recession" "L1 deficit") ///
    nonumbers ///
    label ///
    stats(change interact germany recdum lagdef N r2, ///
          labels("Column change" "Interaction term" "Germany control" "Recession dummy" "Deficit lag" "Observations" "R-squared")) ///
    varlabels( ///
        deficit_pos                           "Federal deficit (% GDP)" ///
        old_dep_ratio                         "Old-age dependency ratio" ///
        c.deficit_pos#c.old_dep_ratio         "Deficit × old-age dependency" ///
        l1_deficit_pos                        "Federal deficit (% GDP), 1-year lag" ///
        c.l1_deficit_pos#c.old_dep_ratio      "L1 deficit × old-age dependency" ///
        real_rate_ger                         "German real long-term rate" ///
        nf_total_gdp                          "Net foreign inflows (% GDP)" ///
        psav_rate                             "Private saving rate" ///
        recession                             "Recession dummy" ///
        _cons                                 "Constant" ///
    ) ///
    drop(_cons) ///
    plain ///
    compress

display "One-change-at-a-time tables exported to:"
display " - one_change_pre1991.rtf"
display " - one_change_post1990.rtf"
display " - one_change_pre1991.csv"
display " - one_change_post1990.csv"
