# Business Forecasting in R - Code Files

Cleaned R scripts for the DSCI-430 Applied Business Analytics forecasting assignments.

## Contents

- `01_first_sales_dataset_forecasting.R` - first quarterly sales/costs forecasting workflow.
- `02_second_sales_dataset_forecasting.R` - second quarterly forecasting workflow with expanded diagnostics, ADF/KPSS tests, Box-Cox transformations, and eight-quarter forecasts.
- `03_third_sales_dataset_profit_forecasting.R` - final forecasting workflow including sales, fixed costs, labor costs, material costs, and computed profit.

## Data note

The raw class CSV datasets are not included in this public portfolio package. To run the scripts, place the required CSV files in a local `data/` folder:

```text
data/Tyson_11_29_07.csv
data/Tyson_04_12_11.csv
data/Tyson_06_18_08.csv
```

## R packages

The scripts use standard forecasting and diagnostics packages, including:

```r
forecast
fpp2
ggplot2
tseries
```

## Portfolio purpose

These scripts document the analytical workflow behind the project. They were cleaned for public review by replacing local machine paths with relative paths and adding documentation notes.
