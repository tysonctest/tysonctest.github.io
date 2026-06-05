*******************************************************
* 02_descriptives.do
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

use "data/final_analysis_dataset.dta", clear
*------------------------------------------------------------
* Basic summary of key variables (with intuitive signs)
*------------------------------------------------------------
summarize year real_rate_us deficit_pos old_dep_ratio nf_total_in psav_rate

* Where does the sample start for the core variables?
summarize year if !missing(real_rate_us)
summarize year if !missing(deficit_pos)
summarize year if !missing(old_dep_ratio)

* Missing-pattern overview for core regression vars
misstable summarize real_rate_us deficit_pos old_dep_ratio nf_total_in
*------------------------------------------------------------
* Quick time-series plots
*------------------------------------------------------------
tsline real_rate_us, ///
    title("U.S. real 10y rate")

tsline deficit_pos, ///
    title("Federal deficit (% of GDP, positive = deficit)")

tsline old_dep_ratio, ///
    title("Old-age dependency ratio")

tsline nf_total_in, ///
    title("Net capital inflows (% of GDP, >0 = inflow)")
