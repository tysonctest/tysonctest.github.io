/**********************************************************************
04_export_tables.do
Purpose: Export compact results tables from stored models.
**********************************************************************/

version 18

* Requires estimates stored by 03_fixed_effects_regressions.do.
capture which esttab
if _rc {
    di as text "esttab not installed. Install with: ssc install estout"
    exit
}

esttab gsp_pc private_gsp_pc using "outputs/public_finance_fixed_effects_results.rtf", ///
    replace se star(* 0.05 ** 0.01 *** 0.001) ///
    title("Fixed-Effects Regression Results") ///
    mtitles("GSP per capita" "Private GSP per capita") ///
    stats(N r2, labels("N" "R-squared"))
