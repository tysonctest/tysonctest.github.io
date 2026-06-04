# Business Forecasting in R: Sales, Costs, and Profit

**Project type:** Applied business analytics / time-series forecasting
**Tools:** R, forecast package, time-series diagnostics, CSV business data
**Status:** Completed DSCI-430 Applied Business Analytics capstone assignments
**My role:** Individual analyst

[← Back to Projects](../projects.html)

## Summary

This project used R to forecast quarterly business performance across multiple operating series, including sales, fixed costs, labor costs, material costs, and profit. The project included exploratory time-series analysis, seasonality diagnostics, Box-Cox transformations, stationarity testing, differencing, residual diagnostics, train/test validation, and final eight-quarter forecasts.

## Problem / Research Question

How can historical quarterly business data be used to forecast future sales, costs, and profitability, and which forecasting methods produce the most reliable out-of-sample predictions?

## Data and Methods

The project analyzed quarterly business time series using R. Each series was inspected visually, tested for seasonality and stationarity, evaluated for possible variance-stabilizing transformations, and modeled using several competing forecasting methods.

Methods included:

* Quarterly time-series construction
* Exploratory time-series plots
* Seasonal and subseries plots
* Box-Cox transformation testing
* ADF and KPSS stationarity tests
* Regular and seasonal differencing checks
* ACF and residual diagnostics
* Ljung-Box tests for autocorrelation
* Train/test model evaluation
* Forecast accuracy comparison using MASE, RMSE, MAE, and MAPE
* Eight-quarter business forecasts

Models considered included naïve, seasonal naïve, random walk with drift, ETS, Holt-Winters, Auto ARIMA, TSLM, and STLF.

## Key Findings

The final forecasting work showed that no single model was best across all business series. Some series were better modeled by simple benchmark or random-walk approaches, while others required methods that captured seasonality or changing levels. In the final dataset, the forecasts suggested declining sales, declining material costs, declining profit, stable fixed costs, and flat labor costs over the next eight quarters.

## Why This Project Matters

This project demonstrates a full applied forecasting workflow: preparing data, diagnosing time-series structure, comparing candidate models, validating results out of sample, and translating forecasts into a business interpretation. It shows the ability to move beyond code output and explain what the forecast implies for business planning.

## Skills Demonstrated

* R programming
* Time-series forecasting
* Forecast accuracy evaluation
* Stationarity testing
* Residual diagnostics
* Business interpretation of model results
* Data visualization
* Technical report writing
* Code review preparation

## Artifacts

Artifacts coming soon:

* Third sales dataset analysis report
* Cleaned R scripts
* Forecast charts
* Final eight-quarter forecast table
* Selected diagnostic plots
