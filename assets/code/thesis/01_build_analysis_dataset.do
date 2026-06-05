*******************************************************
* 01_build_analysis_dataset.do
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

*------------------------------------------------------------
* Import master Excel file
*------------------------------------------------------------
import excel using "data/one_spreadsheet_to_rule_them_all.xlsx", firstrow clear
*------------------------------------------------------------
* Clean variable names
*------------------------------------------------------------
rename Year                  year
rename usa_real_rate         real_rate_us
rename budget_defici*        deficit_gdp
rename old_age_depen*        old_dep_ratio
rename federal_recei*        receipts_gdp
rename germany_real_*        real_rate_ger
rename net_flows_equ*        nf_equity_gdp
rename net_flows_deb*        nf_debt_gdp
rename net_flows_tot*        nf_total_gdp
rename open_market_o*        omo_gdp
rename balance_sheet*        bs_gdp
rename us_investment*        us_invest_gdp
rename us_public_deb*        us_debt_gdp
rename mandatory_gdp         mand_gdp
rename discretionar*         discr_gdp
rename net_interest_*        netint_gdp
rename personal_savi*        psav_rate
rename natural_unemp*        u_nat
rename actual_unempl*        u_act
rename cyclical_unem*        u_cyc
rename term_spread           term_spread
rename baa_risk_free*        baa_spread
rename market_cap_gdp        mcap_gdp
rename equity_risk_p*        eq_risk_prem
*------------------------------------------------------------
* Sign fixes for interpretation
*------------------------------------------------------------
* 1) Deficit: positive = larger deficit
gen deficit_pos = -deficit_gdp
label var deficit_pos "Federal budget deficit (% of GDP, positive = deficit)"
* 2) Capital flows: positive = net inflow to the U.S.
gen nf_equity_in = -nf_equity_gdp
label var nf_equity_in "Net equity capital inflow (% of GDP, >0 = inflow)"
gen nf_debt_in   = -nf_debt_gdp
label var nf_debt_in "Net debt capital inflow (% of GDP, >0 = inflow)"
gen nf_total_in  = -nf_total_gdp
label var nf_total_in "Total net capital inflow (% of GDP, >0 = inflow)"
*------------------------------------------------------------
* Clean, committee-ready variable labels
*------------------------------------------------------------
label var year          "Year"

label var real_rate_us  "U.S. real 10y rate"

label var deficit_gdp   "Deficit (% GDP, + = deficit)"   // original sign
label var deficit_pos   "Deficit (% GDP, + = deficit)"   // main regressor

label var old_dep_ratio "Old-age dependency ratio"

label var receipts_gdp  "Federal receipts (% of GDP)"

label var real_rate_ger "German real 10y rate"

label var nf_equity_gdp "Net equity flows (% GDP, + = outflow)"
label var nf_debt_gdp   "Net debt flows (% GDP, + = outflow)"
label var nf_total_gdp  "Net total flows (% GDP, + = outflow)"

label var nf_equity_in  "Net equity capital inflow (% GDP)"
label var nf_debt_in    "Net debt capital inflow (% GDP)"
label var nf_total_in   "Total net capital inflow (% GDP)"

label var omo_gdp       "Open market operations (% of GDP)"
label var bs_gdp        "Fed balance sheet (% of GDP)"

label var us_invest_gdp "Private investment (% of GDP)"
label var us_debt_gdp   "Federal debt (% of GDP)"

label var mand_gdp      "Mandatory spending (% of GDP)"
label var discr_gdp     "Discretionary spending (% of GDP)"
label var netint_gdp    "Net interest (% of GDP)"

label var psav_rate     "Personal saving rate (%)"

label var u_nat         "Natural unemployment rate (%)"
label var u_act         "Unemployment rate (%)"
label var u_cyc         "Cyclical unemployment (%)"

label var term_spread   "Term spread (10y–3m, pp)"
label var baa_spread    "BAA–Treasury spread (pp)"

label var mcap_gdp      "Equity market cap (% of GDP)"
label var eq_risk_prem  "Equity risk premium (pp)"
*------------------------------------------------------------
* Interaction term
*------------------------------------------------------------
* Preferred interaction using deficit_pos (positive = deficit)
gen deficitposXold = deficit_pos * old_dep_ratio
label var deficitposXold "Deficit × old-age dependency"
*------------------------------------------------------------
* Define regression sample: require key vars
*------------------------------------------------------------
keep if !missing(real_rate_us, deficit_pos, old_dep_ratio)
*------------------------------------------------------------
* Declare time-series structure and save
*------------------------------------------------------------
tsset year
save "data/final_analysis_dataset.dta", replace
