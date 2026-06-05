*******************************************************
* 06_export_tables.do
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
* 04_export_tables.do
* Tyson Test - Honors Thesis
*
* - Re-runs core regressions for export
* - Exports regression tables via esttab (RTF)
* - Exports VIFs for each main spec to Excel
*******************************************************
* Load the final analysis dataset created earlier in thesis_master.do
use "data/final_analysis_dataset.dta", clear

tsset year

* estout / esttab (only need to install once from the Command window)
*   ssc install estout, replace
*   ssc install moremata, replace
*------------------------------------------------------
* 1. Helper program: build VIF matrix after a regression
*
*   - Call immediately after a regress command:
*       reg ...
*       make_vif_matrix
*
*   - Returns r(A): matrix with rownames = variables + Mean_VIF,
*     colnames = VIF and Tolerance (1/VIF)
*------------------------------------------------------
capture program drop make_vif_matrix
program define make_vif_matrix, rclass
    // Assumes a regress command has just been run
    estat vif

    // Number of coefficients (including constant)
    local rank = e(rank)
    // Number of regressors (excluding constant)
    local k    = `rank' - 1
    local kp1  = `k' + 1

    // Matrix: k + 1 rows (variables + Mean_VIF), 2 columns (VIF, Tolerance)
    matrix A = J(`kp1', 2, .)

    // Build rows
    local rownames
    scalar sumv = 0

    forvalues i = 1/`k' {
        scalar v = r(vif_`i')
        matrix A[`i',1] = v          // VIF
        matrix A[`i',2] = 1/v        // Tolerance (1/VIF)

        local rownames "`rownames' `r(name_`i')'"
        scalar sumv = sumv + v
    }

    // Mean VIF row
    scalar meanv = sumv / `k'
    matrix A[`kp1',1] = meanv
    matrix A[`kp1',2] = .
    local rownames "`rownames' Mean_VIF"

    // Attach names
    matrix rownames A = `rownames'
    matrix colnames A = VIF Tolerance

    // Return matrix in r()
    return matrix A = A
end
*******************************************************
* PART 1: MAIN FULL-SAMPLE SPECIFICATIONS (Specs 1–4)
*******************************************************
eststo clear

*-----------------------------
* Spec (1): baseline interaction
*-----------------------------
eststo spec1: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio, vce(robust)

*-----------------------------
* Spec (2): + basic macro controls
*-----------------------------
eststo spec2: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate, vce(robust)

*-----------------------------
* Spec (3): modern spec with global rate,
*           cyclical u, inflows, saving
*-----------------------------
eststo spec3: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_cyc nf_total_in psav_rate, vce(robust)

*-----------------------------
* Spec (4): Committee spec with "yellow" vars
*-----------------------------
eststo spec4: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_act psav_rate receipts_gdp, vce(robust)

*-----------------------------
* Export main specs (1–4) as RTF
*-----------------------------
esttab spec1 spec2 spec3 spec4 using "outputs/thesis_regressions_main.rtf", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    b(3) se(3) ///
    label ///
    alignment(r) ///
    compress nogaps ///
    mtitles("(1)" "(2)" "(3)" "(4)") ///
    title("Determinants of U.S. 10-year real rate – main specifications")
*******************************************************
* PART 2: "Kitchen-sink" model
*         (for documenting multicollinearity)
*******************************************************
eststo clear

eststo full: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    receipts_gdp real_rate_ger ///
    nf_equity_in nf_debt_in nf_total_in ///
    omo_gdp us_invest_gdp us_debt_gdp ///
    discr_gdp netint_gdp ///
    psav_rate u_nat u_act u_cyc ///
    term_spread baa_spread mcap_gdp eq_risk_prem, vce(robust)

* Export kitchen-sink spec as RTF
esttab full using "outputs/thesis_regressions_kitchen_sink.rtf", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    b(3) se(3) ///
    label ///
    alignment(r) ///
    compress nogaps ///
    title("Determinants of U.S. 10-year real rate – saturated specification")
*******************************************************
* PART 3: Pre- vs post-1991 robustness (two eras)
*******************************************************
eststo clear

* Pre-1991 (1960–1990), simple
eststo pre1: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    if year <= 1990, vce(robust)

* Pre-1991, + controls
eststo pre2: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate ///
    if year <= 1990, vce(robust)

* Post-1990 (1991–2023), simple
eststo post1: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    if year >= 1991, vce(robust)

* Post-1990, + controls
eststo post2: reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate ///
    if year >= 1991, vce(robust)

* Export pre/post comparison as RTF
esttab pre1 pre2 post1 post2 using "outputs/thesis_regressions_pre_post_1991.rtf", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    b(3) se(3) ///
    label ///
    alignment(r) ///
    compress nogaps ///
    mtitles("Pre (1)" "Pre (2)" "Post (1)" "Post (2)") ///
    title("Pre- vs post-1991 regressions")
*******************************************************
* PART 4: Export VIFs for main specs + full + pre/post
*******************************************************
* New Excel workbook for all VIF tables
putexcel set "outputs/thesis_vif_tables.xlsx", replace

*-----------------------------
* VIFs – Spec (1): baseline
*-----------------------------
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Spec1_baseline") modify
putexcel A1 = "VIFs – Spec (1): baseline interaction", bold
putexcel A3 = matrix(r(A)), names
*-----------------------------
* VIFs – Spec (2): + term_spread, u_nat, psav_rate
*-----------------------------
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Spec2_macro") modify
putexcel A1 = "VIFs – Spec (2): + term_spread, u_nat, psav_rate", bold
putexcel A3 = matrix(r(A)), names
*-----------------------------
* VIFs – Spec (3): + real_rate_ger, u_cyc, nf_total_in, psav_rate
*-----------------------------
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_cyc nf_total_in psav_rate, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Spec3_modern") modify
putexcel A1 = "VIFs – Spec (3): + real_rate_ger, u_cyc, nf_total_in, psav_rate", bold
putexcel A3 = matrix(r(A)), names
*-----------------------------
* VIFs – Spec (4): committee spec
*-----------------------------
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    real_rate_ger u_act psav_rate receipts_gdp, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Spec4_committee") modify
putexcel A1 = "VIFs – Spec (4): committee spec (real_rate_ger, u_act, psav_rate, receipts_gdp)", bold
putexcel A3 = matrix(r(A)), names
*-----------------------------
* VIFs – Kitchen-sink full model
*-----------------------------
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    receipts_gdp real_rate_ger ///
    nf_equity_in nf_debt_in nf_total_in ///
    omo_gdp us_invest_gdp us_debt_gdp ///
    discr_gdp netint_gdp ///
    psav_rate u_nat u_act u_cyc ///
    term_spread baa_spread mcap_gdp eq_risk_prem, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Full_kitchen_sink") modify
putexcel A1 = "VIFs – Kitchen-sink model (all covariates)", bold
putexcel A3 = matrix(r(A)), names
*-----------------------------
* VIFs – Pre- vs Post-1991 splits
*-----------------------------

* Pre-1991, simple
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    if year <= 1990, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Pre1991_simple") modify
putexcel A1 = "VIFs – Pre-1991 (≤1990), simple spec", bold
putexcel A3 = matrix(r(A)), names

* Pre-1991, + controls
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate ///
    if year <= 1990, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Pre1991_controls") modify
putexcel A1 = "VIFs – Pre-1991 (≤1990), + term_spread, u_nat, psav_rate", bold
putexcel A3 = matrix(r(A)), names

* Post-1990, simple
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    if year >= 1991, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Post1990_simple") modify
putexcel A1 = "VIFs – Post-1990 (≥1991), simple spec", bold
putexcel A3 = matrix(r(A)), names

* Post-1990, + controls
reg real_rate_us ///
    c.deficit_pos##c.old_dep_ratio ///
    term_spread u_nat psav_rate ///
    if year >= 1991, vce(robust)
make_vif_matrix
putexcel set "outputs/thesis_vif_tables.xlsx", sheet("Post1990_controls") modify
putexcel A1 = "VIFs – Post-1990 (≥1991), + term_spread, u_nat, psav_rate", bold
putexcel A3 = matrix(r(A)), names

display "--------------------------------------------------"
display "VIF tables written to thesis_vif_tables.xlsx"
display "Sheets: Spec1_baseline, Spec2_macro, Spec3_modern,"
display "        Spec4_committee, Full_kitchen_sink,"
display "        Pre1991_*, Post1990_*"
display "--------------------------------------------------"
*******************************************************
* End of 04_export_tables.do
*******************************************************
