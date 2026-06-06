# Public Finance Econometrics Stata Code

Cleaned Stata workflow for Tyson Test's ECON-421 public finance/econometrics project:

**State Fiscal and Regulatory Policy Effects on Economic Performance**

Presented at the Missouri Valley Economics Association (MVEA), Kansas City, Fall 2024.

## Contents

- `run_all.do` - master script that runs the cleaned workflow in order.
- `01_setup_and_panel.do` - loads the merged public-finance panel dataset, applies the sample window, creates panel identifiers if needed, and declares the panel structure.
- `02_summary_statistics.do` - produces summary statistics for the key outcomes and policy variables.
- `03_fixed_effects_regressions.do` - runs the two main fixed-effects regressions reported in the project.
- `04_export_tables.do` - exports a compact regression table and summary-statistics table if the required Stata packages are installed.

## Data note

Raw class datasets are not included in this public portfolio package. To run the scripts, place the merged analysis dataset at:

```stata
data/public_finance_panel.dta
```

The expected dataset includes state-year observations from 2000-2020 and variables from Cato Institute Freedom in the 50 States, BEA gross state product data, and Census population estimates.

## Portfolio purpose

These files document the analytical workflow behind the project while avoiding local machine paths, scratch commands, and raw class-data redistribution.
