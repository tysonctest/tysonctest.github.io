/**********************************************************************
01_setup_and_panel.do
Purpose: Load the merged state-year panel and declare panel structure.
**********************************************************************/

version 18
clear

* Raw data are not included in this public portfolio package.
* Place the merged analysis dataset here before running:
use "data/public_finance_panel.dta", clear

* Project sample window
keep if inrange(year, 2000, 2020)

* Ensure a numeric state identifier exists.
capture confirm variable state_n
if _rc {
    encode state, gen(state_n)
}

* Declare panel structure.
xtset state_n year

* Recreate per-capita outcomes if needed.
capture confirm variable percapitagsp
if _rc {
    gen percapitagsp = totalgsp / statepop
}

capture confirm variable percapitaprivategsp
if _rc {
    gen percapitaprivategsp = privategsp / statepop
}

save "outputs/public_finance_panel_clean.dta", replace
