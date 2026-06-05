# Honors Thesis Stata Code

Cleaned Stata code for Tyson Test's undergraduate honors thesis:

**Does Demographic Aging and Financial Globalization Moderate Crowding Out? Federal Deficits and U.S. Long-Term Real Interest Rates**

## Contents

- `run_all.do` - master script that runs the cleaned workflow in order.
- `01_build_analysis_dataset.do` - imports the master Excel workbook, cleans variable names, creates sign-adjusted variables, creates the deficit-aging interaction term, and saves the final analysis dataset.
- `02_descriptives.do` - summary statistics and basic time-series plots.
- `03_regressions_main.do` - main specifications, VIF checks, Newey-West regressions, and marginal effects.
- `04_regressions_alternate.do` - alternate specifications requested during the thesis process.
- `05_regressions_one_change_at_a_time.do` - one-change-at-a-time robustness checks.
- `06_export_tables.do` - table-export workflow for regression and VIF outputs.
- `07_prepost_capflows.do` - pre-/post-1991 models and marginal-effects figure export.

## Data note

The raw data workbook is not included in this public portfolio package. To run the full workflow, place the workbook at:

```text
data/one_spreadsheet_to_rule_them_all.xlsx
```

The scripts use relative paths and write generated tables/figures to:

```text
outputs/
```

## Stata requirements

The scripts were written for Stata and use standard regression/time-series commands. Some export sections use `esttab`/`estout`; if not installed, run this once in Stata:

```stata
ssc install estout, replace
ssc install moremata, replace
```

## Portfolio purpose

These files are intended to document the analytical workflow behind the thesis. They were cleaned for public review by removing local machine paths and replacing them with relative paths.
