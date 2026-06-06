/**********************************************************************
Public Finance Econometrics Project - Master Script
Tyson Test | ECON-421 | Missouri Valley Economics Association, Fall 2024
**********************************************************************/

version 18
clear all
set more off

* Run this file from the project root.
* Expected data path: data/public_finance_panel.dta

capture mkdir outputs

do "assets/code/public-finance-econometrics/01_setup_and_panel.do"
do "assets/code/public-finance-econometrics/02_summary_statistics.do"
do "assets/code/public-finance-econometrics/03_fixed_effects_regressions.do"
do "assets/code/public-finance-econometrics/04_export_tables.do"
