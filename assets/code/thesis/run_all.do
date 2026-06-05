*******************************************************
* run_all.do
* Tyson Test - Honors thesis portfolio code
*
* This master file runs the cleaned thesis workflow in order.
* To execute fully, place the raw data workbook at:
*   data/one_spreadsheet_to_rule_them_all.xlsx
*
* Raw data are not included in the public portfolio.
*******************************************************
clear all
set more off

global PROJECT_ROOT "."
cd "$PROJECT_ROOT"
capture mkdir "data"
capture mkdir "outputs"

* Build final analysis dataset
run "01_build_analysis_dataset.do"

* Descriptives and plots
run "02_descriptives.do"

* Main regressions and marginal effects
run "03_regressions_main.do"

* Alternate and robustness checks
run "04_regressions_alternate.do"
run "05_regressions_one_change_at_a_time.do"

* Table and figure exports
run "06_export_tables.do"
run "07_prepost_capflows.do"
