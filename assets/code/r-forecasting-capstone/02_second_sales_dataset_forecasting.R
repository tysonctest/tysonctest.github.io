# Second sales dataset forecasting exercise
# Cleaned portfolio version
# Original coursework: DSCI-430 Applied Business Analytics
# Data note: raw class datasets are not included in this public portfolio package.
# To run this script, place the relevant CSV in a local data/ folder.

#second sales dataset
#packages
if(!require(forecast))install.packages("forecast");library(forecast)
if(!require(fpp2))install.packages("fpp2");library(fpp2)
if(!require(ggplot2))install.packages("ggplot2");library("ggplot2")
#I need tseries in order to test for ADF and KPSS later
if(!require(tseries))install.packages("tseries");library(tseries)

#load and prepare Tyson data
tyson_data<-read.csv("data/Tyson_04_12_11.csv")
start_yr<-2007
start_qtr<-1

names(tyson_data)
head(tyson_data)
str(tyson_data)
summary(tyson_data)

tyson_sales<-ts(tyson_data$Sales,start=c(start_yr,start_qtr),frequency=4)
tyson_fixed<-ts(tyson_data$Fixed,start=c(start_yr,start_qtr),frequency=4)
tyson_labor<-ts(tyson_data$Labor,start=c(start_yr,start_qtr),frequency=4)
tyson_material<-ts(tyson_data$Material,start=c(start_yr,start_qtr),frequency=4)

#Forecast Horizon: because data is quarterly, we forecast 4 future quarters 
#we hold out the last 4 quarters on a test set
h<-4
final_h<-8

#length of each series
n<-length(tyson_sales)

#sales series 
#exploratory data analysis for sales
autoplot(tyson_sales)+ggtitle("Sales-Time Series Plot")+xlab("Year")+ylab("Sales")
ggseasonplot(tyson_sales)+ggtitle("Sales-Seasonal Plot")+xlab("Quarter")+ylab("Sales")
ggsubseriesplot(tyson_sales)+ggtitle("Sales-Subseries Plot")+xlab("Quarter")+ylab("Sales")

#fixed costs exploratory data analysis
autoplot(tyson_fixed)+ggtitle("Fixed Costs-Time Series Plot")+xlab("Year")+ylab("Fixed Costs")
ggseasonplot(tyson_fixed)+ggtitle("Fixed Costs-Seasonal Plot")+xlab("Quarter")+ylab("Fixed Costs")
ggsubseriesplot(tyson_fixed)+ggtitle("Fixed Costs-Subseries Plot")+xlab("Quarter")+ylab("Fixed Costs")

#labor costs exploratory data analysis
autoplot(tyson_labor)+ggtitle("Labor Costs-Time Series Plot")+xlab("Year")+ylab("Labor Costs")
ggseasonplot(tyson_labor)+ggtitle("Labor Costs-Seasonal Plot")+xlab("Quarter")+ylab("Labor Costs")
ggsubseriesplot(tyson_labor)+ggtitle("Labor Costs-Subseries Plot")+xlab("Quarter")+ylab("Labor Costs")

#material costs exploratory data analysis
autoplot(tyson_material)+ggtitle("Material Costs-Time Series Plot")+xlab("Year")+ylab("Material Costs")
ggseasonplot(tyson_material)+ggtitle("Material Costs-Seasonal Plot")+xlab("Quarter")+ylab("Material Costs")
ggsubseriesplot(tyson_material)+ggtitle("Material Costs-Subseries Plot")+xlab("Quarter")+ylab("Material Costs")
# transformations, stationarity, and differencing diagnostics
# ---------------- SALES ----------------
sales_lambda<-BoxCox.lambda(tyson_sales)
cat("Sales Box-Cox lambda:", round(sales_lambda, 4), "\n")
cat("Sales ndiffs:", ndiffs(tyson_sales), "\n")
cat("Sales nsdiffs:", nsdiffs(tyson_sales), "\n\n")

adf.test(tyson_sales)
kpss.test(tyson_sales)

sales_diff<-diff(tyson_sales)
autoplot(sales_diff)+ggtitle("Sales-First Difference")+xlab("Year")+ylab("Differenced Sales")

adf.test(sales_diff)
kpss.test(sales_diff)

# ---------------- FIXED COSTS ----------------
fixed_lambda<-BoxCox.lambda(tyson_fixed)
cat("Fixed Costs Box-Cox lambda:", round(fixed_lambda, 4), "\n")
cat("Fixed Costs ndiffs:", ndiffs(tyson_fixed), "\n")
cat("Fixed Costs nsdiffs:", nsdiffs(tyson_fixed), "\n\n")

adf.test(tyson_fixed)
kpss.test(tyson_fixed)

fixed_sdiff<-diff(tyson_fixed,lag=4)
autoplot(fixed_sdiff)+ggtitle("Fixed Costs-Seasonal Difference w/lag=4")+xlab("Year")+ylab("Seasonally Differenced Fixed Costs")

adf.test(fixed_sdiff)
kpss.test(fixed_sdiff)

# ---------------- LABOR COSTS ----------------
labor_lambda<-BoxCox.lambda(tyson_labor)
cat("Labor Costs Box-Cox lambda:", round(labor_lambda, 4), "\n")
cat("Labor Costs ndiffs:", ndiffs(tyson_labor), "\n")
cat("Labor Costs nsdiffs:", nsdiffs(tyson_labor), "\n\n")

adf.test(tyson_labor)
kpss.test(tyson_labor)

labor_diff<-diff(tyson_labor)
autoplot(labor_diff)+ggtitle("Labor Costs-First Difference")+xlab("Year")+ylab("Differenced Labor Costs")

adf.test(labor_diff)
kpss.test(labor_diff)

# ---------------- MATERIAL COSTS ----------------
material_lambda<-BoxCox.lambda(tyson_material)
cat("Material Costs Box-Cox lambda:", round(material_lambda, 4), "\n")
cat("Material Costs ndiffs:", ndiffs(tyson_material), "\n")
cat("Material Costs nsdiffs:", nsdiffs(tyson_material), "\n\n")

adf.test(tyson_material)
kpss.test(tyson_material)

material_diff<-diff(tyson_material)
autoplot(material_diff)+ggtitle("Material Costs-First Difference")+xlab("Year")+ylab("Differenced Material Costs")

adf.test(material_diff)
kpss.test(material_diff)
#sales train/test split
#training set=all but the last 4 quarters 
#test set=last 4 quarters 
sales_train<-window(tyson_sales,end=time(tyson_sales)[n-h])
sales_test<-window(tyson_sales,start=time(tyson_sales)[n-h+1])

#Sales model fits
sales_naive<-naive(sales_train,h=h,lambda=sales_lambda,biasadj=TRUE)
sales_snaive<-snaive(sales_train,h=h,lambda=sales_lambda,biasadj=TRUE)
sales_ets_fit<-ets(sales_train,lambda=sales_lambda,biasadj=TRUE)
sales_ets_fc<-forecast(sales_ets_fit,h=h)
sales_hw<-hw(sales_train,h=h,lambda=sales_lambda,biasadj=TRUE)
sales_arima_fit<-auto.arima(sales_train,lambda=sales_lambda,biasadj=TRUE)
sales_arima_fc<-forecast(sales_arima_fit,h=h)
sales_tslm_fit<-tslm(sales_train~trend+season)
sales_tslm_fc<-forecast(sales_tslm_fit,h=h)
sales_stlf<-stlf(sales_train,h=h,lambda=sales_lambda)

#sales residuals checks
checkresiduals(sales_naive)
checkresiduals(sales_snaive)
checkresiduals(sales_ets_fit)
checkresiduals(sales_hw)
checkresiduals(sales_arima_fit)
checkresiduals(sales_tslm_fit)
checkresiduals(sales_stlf)

#sales accuracy tables
sales_acc_naive<-round(accuracy(sales_naive,sales_test),4)
sales_acc_snaive<-round(accuracy(sales_snaive,sales_test),4)
sales_acc_ets<-round(accuracy(sales_ets_fc,sales_test),4)
sales_acc_hw<-round(accuracy(sales_hw,sales_test),4)
sales_acc_arima<-round(accuracy(sales_arima_fc,sales_test),4)
sales_acc_tslm<-round(accuracy(sales_tslm_fc,sales_test),4)
sales_acc_stlf<-round(accuracy(sales_stlf,sales_test),4)

#print the outputs
print(sales_acc_naive);print(sales_acc_snaive);print(sales_acc_ets);print(sales_acc_hw);print(sales_acc_arima);print(sales_acc_tslm);print(sales_acc_stlf)

#choose the superior model (the one with the lowest test set mase)
sales_mase<-c(naive=sales_acc_naive["Test set","MASE"],snaive=sales_acc_snaive["Test set","MASE"],
              ets=sales_acc_ets["Test set","MASE"],hw=sales_acc_hw["Test set","MASE"],
              auto.arima=sales_acc_arima["Test set","MASE"],tslm=sales_acc_tslm["Test set","MASE"],
              stlf=sales_acc_stlf["Test set","MASE"]);print(sales_mase)

sales_best<-names(which.min(sales_mase));print(sales_best)
#fixed costs train/test split
fixed_train<-window(tyson_fixed,end=time(tyson_fixed)[n-h])
fixed_test<-window(tyson_fixed,start=time(tyson_fixed)[n-h+1])
#fixed costs model fits
fixed_naive<-naive(fixed_train,h=h,lambda=fixed_lambda,biasadj=TRUE)
fixed_snaive<-snaive(fixed_train,h=h,lambda=fixed_lambda,biasadj=TRUE)
fixed_ets_fit<-ets(fixed_train,lambda=fixed_lambda,biasadj=TRUE)
fixed_ets_fc<-forecast(fixed_ets_fit,h=h)
fixed_hw<-hw(fixed_train,h=h,lambda=fixed_lambda,biasadj=TRUE)
fixed_arima_fit<-auto.arima(fixed_train,lambda=fixed_lambda,biasadj=TRUE)
fixed_arima_fc<-forecast(fixed_arima_fit,h=h)
fixed_tslm_fit<-tslm(fixed_train~trend+season)
fixed_tslm_fc<-forecast(fixed_tslm_fit,h=h)
fixed_stlf<-stlf(fixed_train,h=h,lambda=fixed_lambda)

#fixed cost residual checks
checkresiduals(fixed_naive);checkresiduals(fixed_snaive);checkresiduals(fixed_ets_fit);checkresiduals(fixed_hw)
checkresiduals(fixed_arima_fit);checkresiduals(fixed_tslm_fit);checkresiduals(fixed_stlf)

#fixed costs accuracy tables
fixed_acc_naive<-round(accuracy(fixed_naive,fixed_test),4)
fixed_acc_snaive<-round(accuracy(fixed_snaive,fixed_test),4)
fixed_acc_ets<-round(accuracy(fixed_ets_fc,fixed_test),4)
fixed_acc_hw<-round(accuracy(fixed_hw,fixed_test),4)
fixed_acc_arima<-round(accuracy(fixed_arima_fc,fixed_test),4)
fixed_acc_tslm<-round(accuracy(fixed_tslm_fc,fixed_test),4)
fixed_acc_stlf<-round(accuracy(fixed_stlf,fixed_test),4)

#print the outputs
print(fixed_acc_naive);print(fixed_acc_snaive);print(fixed_acc_ets);print(fixed_acc_hw);print(fixed_acc_arima);print(fixed_acc_tslm);print(fixed_acc_stlf)

#choose the superior model (the one with the lowest test set mase)
fixed_mase<-c(naive=fixed_acc_naive["Test set","MASE"],snaive=fixed_acc_snaive["Test set","MASE"],
              ets=fixed_acc_ets["Test set","MASE"],hw=fixed_acc_hw["Test set","MASE"],
              auto.arima=fixed_acc_arima["Test set","MASE"],tslm=fixed_acc_tslm["Test set","MASE"],
              stlf=fixed_acc_stlf["Test set","MASE"]);print(fixed_mase)

fixed_best<-names(which.min(fixed_mase))
print(fixed_best)

#labor costs train/test split
labor_train<-window(tyson_labor,end=time(tyson_labor)[n-h])
labor_test<-window(tyson_labor,start=time(tyson_labor)[n-h+1])

#labor costs model fits
labor_naive<-naive(labor_train,h=h,lambda=labor_lambda,biasadj=TRUE)
labor_snaive<-snaive(labor_train,h=h,lambda=labor_lambda,biasadj=TRUE)
labor_ets_fit<-ets(labor_train,lambda=labor_lambda,biasadj=TRUE)
labor_ets_fc<-forecast(labor_ets_fit,h=h)
labor_hw<-hw(labor_train,h=h,lambda=labor_lambda,biasadj=TRUE)
labor_arima_fit<-auto.arima(labor_train,lambda=labor_lambda,biasadj=TRUE)
labor_arima_fc<-forecast(labor_arima_fit,h=h)
labor_tslm_fit<-tslm(labor_train~trend+season)
labor_tslm_fc<-forecast(labor_tslm_fit,h=h)
labor_stlf<-stlf(labor_train,h=h,lambda=labor_lambda)

#labor cost residual checks
checkresiduals(labor_naive);checkresiduals(labor_snaive);checkresiduals(labor_ets_fit);checkresiduals(labor_hw)
checkresiduals(labor_arima_fit);checkresiduals(labor_tslm_fit);checkresiduals(labor_stlf)

#labor costs accuracy tables
labor_acc_naive<-round(accuracy(labor_naive,labor_test),4)
labor_acc_snaive<-round(accuracy(labor_snaive,labor_test),4)
labor_acc_ets<-round(accuracy(labor_ets_fc,labor_test),4)
labor_acc_hw<-round(accuracy(labor_hw,labor_test),4)
labor_acc_arima<-round(accuracy(labor_arima_fc,labor_test),4)
labor_acc_tslm<-round(accuracy(labor_tslm_fc,labor_test),4)
labor_acc_stlf<-round(accuracy(labor_stlf,labor_test),4)

#print the outputs
print(labor_acc_naive);print(labor_acc_snaive);print(labor_acc_ets);print(labor_acc_hw);print(labor_acc_arima);print(labor_acc_tslm);print(labor_acc_stlf)

#choose the superior model (the one with the lowest test set mase)
labor_mase<-c(naive=labor_acc_naive["Test set","MASE"],snaive=labor_acc_snaive["Test set","MASE"],
              ets=labor_acc_ets["Test set","MASE"],hw=labor_acc_hw["Test set","MASE"],
              auto.arima=labor_acc_arima["Test set","MASE"],tslm=labor_acc_tslm["Test set","MASE"],
              stlf=labor_acc_stlf["Test set","MASE"]);print(labor_mase)

labor_best<-names(which.min(labor_mase))
print(labor_best)
#material costs train/test split
material_train<-window(tyson_material,end=time(tyson_material)[n-h])
material_test<-window(tyson_material,start=time(tyson_material)[n-h+1])

#material costs model fits
material_naive<-naive(material_train,h=h,lambda=material_lambda,biasadj=TRUE)
material_snaive<-snaive(material_train,h=h,lambda=material_lambda,biasadj=TRUE)
material_ets_fit<-ets(material_train,lambda=material_lambda,biasadj=TRUE)
material_ets_fc<-forecast(material_ets_fit,h=h)
material_hw<-hw(material_train,h=h,lambda=material_lambda,biasadj=TRUE)
material_arima_fit<-auto.arima(material_train,lambda=material_lambda,biasadj=TRUE)
material_arima_fc<-forecast(material_arima_fit,h=h)
material_tslm_fit<-tslm(material_train~trend+season)
material_tslm_fc<-forecast(material_tslm_fit,h=h)
material_stlf<-stlf(material_train,h=h,lambda=material_lambda)

#summaries
summary(material_ets_fit);summary(material_arima_fit);summary(material_tslm_fit)

#residual checks
checkresiduals(material_naive)
checkresiduals(material_snaive)
checkresiduals(material_ets_fit)
checkresiduals(material_hw)
checkresiduals(material_arima_fit)
checkresiduals(material_tslm_fit)
checkresiduals(material_stlf)

#accuracy tables
material_acc_naive<-round(accuracy(material_naive,material_test),4)
material_acc_snaive<-round(accuracy(material_snaive,material_test),4)
material_acc_ets<-round(accuracy(material_ets_fc,material_test),4)
material_acc_hw<-round(accuracy(material_hw,material_test),4)
material_acc_arima<-round(accuracy(material_arima_fc,material_test),4)
material_acc_tslm<-round(accuracy(material_tslm_fc,material_test),4)
material_acc_stlf<-round(accuracy(material_stlf,material_test),4)

#print the tables
print(material_acc_naive)
print(material_acc_snaive)
print(material_acc_ets)
print(material_acc_hw)
print(material_acc_arima)
print(material_acc_tslm)
print(material_acc_stlf)

#choose best model by lowest test-set MASE
material_mase<-c(naive=material_acc_naive["Test set","MASE"],
                 snaive=material_acc_snaive["Test set","MASE"],
                 ets=material_acc_ets["Test set","MASE"],
                 hw=material_acc_hw["Test set","MASE"],
                 auto.arima=material_acc_arima["Test set","MASE"],
                 tslm=material_acc_tslm["Test set","MASE"],
                 stlf=material_acc_stlf["Test set","MASE"]);print(material_mase)

material_best<-names(which.min(material_mase))
print(material_best)
# final forecasts on full series using best model for each set

# Sales: naive
sales_final_fc<-naive(tyson_sales,h=final_h,level=c(80,95),lambda=sales_lambda,biasadj=TRUE)
autoplot(sales_final_fc)+ggtitle("Sales-Final Forecast Using Naive")+xlab("Year")+ylab("Sales")
print(sales_final_fc)

# Fixed Costs: hw
fixed_final_fc<-hw(tyson_fixed,h=final_h,level=c(80,95),lambda=fixed_lambda,biasadj=TRUE)
autoplot(fixed_final_fc)+ggtitle("Fixed Costs-Final Forecast Using Holt-Winters")+xlab("Year")+ylab("Fixed Costs")
print(fixed_final_fc)

# Labor Costs: stlf
labor_final_fc<-stlf(tyson_labor,h=final_h,level=c(80,95),lambda=labor_lambda)
autoplot(labor_final_fc)+ggtitle("Labor Costs-Final Forecast Using STLF")+xlab("Year")+ylab("Labor Costs")
print(labor_final_fc)

# Material Costs: stlf
material_final_fc<-stlf(tyson_material,h=final_h,level=c(80,95),lambda=material_lambda)
autoplot(material_final_fc)+ggtitle("Material Costs-Final Forecast Using STLF")+xlab("Year")+ylab("Material Costs")
print(material_final_fc)

# summary table of best models
best_models<-data.frame(
  Series=c("Sales","Fixed Costs","Labor Costs","Material Costs"),
  Best_Model=c("naive","hw","stlf","stlf"))
print(best_models)

# 8-quarter forecast tables
sales_table<-data.frame(
  Series="Sales",
  Quarter=paste(floor(time(sales_final_fc$mean)),"Q",cycle(sales_final_fc$mean),sep=""),
  Forecast=round(as.numeric(sales_final_fc$mean),4))

fixed_table<-data.frame(
  Series="Fixed Costs",
  Quarter=paste(floor(time(fixed_final_fc$mean)),"Q",cycle(fixed_final_fc$mean),sep=""),
  Forecast=round(as.numeric(fixed_final_fc$mean),4))

labor_table<-data.frame(
  Series="Labor Costs",
  Quarter=paste(floor(time(labor_final_fc$mean)),"Q",cycle(labor_final_fc$mean),sep=""),
  Forecast=round(as.numeric(labor_final_fc$mean),4))

material_table<-data.frame(
  Series="Material Costs",
  Quarter=paste(floor(time(material_final_fc$mean)),"Q",cycle(material_final_fc$mean),sep=""),
  Forecast=round(as.numeric(material_final_fc$mean),4))

final_forecast_table<-rbind(sales_table,fixed_table,labor_table,material_table)
print(final_forecast_table)