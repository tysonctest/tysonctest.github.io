# Third sales dataset forecasting exercise with profit forecasts
# Cleaned portfolio version
# Original coursework: DSCI-430 Applied Business Analytics
# Data note: raw class datasets are not included in this public portfolio package.
# To run this script, place the relevant CSV in a local data/ folder.

#load the packages
#we need to check if a package is already installed
#if the answer is no, then install it
if(!require(forecast))install.packages("forecast");library(forecast)
if(!require(ggplot2))install.packages("ggplot2");library(ggplot2)
if(!require(tseries))install.packages("tseries");library(tseries)

#now, read in the csv file
#pulls in the csv data and stores it in an object called sales_data
sales_data<-read.csv("data/Tyson_06_18_08.csv")
#head prints the first 6 rows of the data so I can verify if the file is imported correctly
head(sales_data)
#str shows the structure of the data: variable names, data types, preview of values
#this ensures that sales, fixed, labor, and materials are numeric
str(sales_data)

#create the profit column, which is sales minus expenses
sales_data$Profit<-sales_data$Sales-sales_data$Fixed-sales_data$Labor-sales_data$Material
#print the first few rows again again so I can make sure the new profit column was created correctly
head(sales_data)

#convert each variable into a quarterly time series
#the dataset has 40 observations, or 10 year of quarterly data
#frequency=4 tells R that the data is quarterly 
#start=c(1,1) means Year 1, Quarter 1
sales_ts<-ts(sales_data$Sales,start=c(1,1),frequency=4)
fixed_ts<-ts(sales_data$Fixed,start=c(1,1),frequency=4)
labor_ts<-ts(sales_data$Labor,start=c(1,1),frequency=4)
material_ts<-ts(sales_data$Material,start=c(1,1),frequency=4)
profit_ts<-ts(sales_data$Profit,start=c(1,1),frequency=4)
h<-8 #hold out the last 8 quarters as the test set

#sales
cat("\n============================================================\n")
cat("SALES\n")
cat("============================================================\n")
#exploratory data analysis
#plot the full sales time series
autoplot(sales_ts)+ggtitle("Sales Time Series")+xlab("Quarter")+ylab("Sales")
#print summary stats for sales
summary(sales_ts)
#check for seasonality
#the seasonal plot helps me see whether the same quarter tends to behave similarly across years
ggseasonplot(sales_ts)+ggtitle("Sales Seasonal Plot")
#the subseries plot helps me compare the quarters more directly
ggsubseriesplot(sales_ts)+ggtitle("Sales Subseries Plot")
#nsdiffs checks whether seasonal differencing is suggested
nsdiffs(sales_ts)
#split the time series into training and test data
#the training set is used to fit the models
#the test set is used to evaluate out-of-sample forecast accuracy
#h=8 means I am holding out the last 8 quarters for testing
sales_train<-head(sales_ts,length(sales_ts)-h)#take the total number of observations, and subtract the 8 observations I want to reserve for the test set
sales_test<-tail(sales_ts,h)#take the last 8 observations 
#check whether a variance-stabilizing transformation is needed
#if lambda is close to 1, the original scale is usually fine
#if lambda is farther from 1, a Box-Cox transformation may help stabilize the variance
sales_lambda<-BoxCox.lambda(sales_train)
sales_lambda
#sales data is not close to 1, so use the transformation
sales_for_test<-BoxCox(sales_train,lambda=sales_lambda)
#use both ADF and KPSS to check stationarity
#ADF tests for evidence in favor of stationarity
#KPSS tests for evidence against stationarity
#using both gives a more complete picture than relying on only one test
adf.test(sales_for_test)
kpss.test(sales_for_test)
#check how many regular differences are needed
#I only difference when ndiffs() suggests it is necessary so that I avoid over differencing
sales_d<-ndiffs(sales_for_test)
sales_d
#sales_d=1 means that the transformed sales series is still not stable enough in level
# I need to difference the series once
sales_diff<-diff(sales_for_test,difference=sales_d)
#retest stationarity after differencing
adf.test(sales_diff)
kpss.test(sales_diff)
#check residuals, acf, and Ljung-Box
checkresiduals(sales_diff)

#fit the forecasting models on the training data
#use lambda so the back transformation is handled automatically
sales_naive<-naive(sales_train,h=h,lambda=sales_lambda)
sales_snaive<-snaive(sales_train,h=h,lambda=sales_lambda)
sales_rwf<-rwf(sales_train,h=h,drift=TRUE,lambda=sales_lambda) #random walk forecast: take the most recent value, and then keep moving forward with the average change over time
sales_ets_fit<-ets(sales_train,lambda=sales_lambda)
sales_ets_fc<-forecast(sales_ets_fit,h=h)
sales_arima_fit<-auto.arima(sales_train,lambda=sales_lambda)
sales_arima_fc<-forecast(sales_arima_fit,h=h)
#use accuracy() to calculate training-set and test-set forecast errors
#the training-set metrics show in-sample fit
#the test-set metrics are more important here because they show out-of-sample forecasting performance
sales_naive_train_acc<-accuracy(sales_naive)
sales_naive_test_acc<-accuracy(sales_naive,sales_test)
sales_snaive_train_acc<-accuracy(sales_snaive)
sales_snaive_test_acc<-accuracy(sales_snaive,sales_test)
sales_rwf_train_acc<-accuracy(sales_rwf)
sales_rwf_test_acc<-accuracy(sales_rwf,sales_test)
sales_ets_train_acc<-accuracy(sales_ets_fc)
sales_ets_test_acc<-accuracy(sales_ets_fc,sales_test)
sales_arima_train_acc<-accuracy(sales_arima_fc)
sales_arima_test_acc<-accuracy(sales_arima_fc,sales_test)
#display outputs
sales_naive_train_acc
sales_naive_test_acc
sales_snaive_train_acc
sales_snaive_test_acc
sales_rwf_train_acc
sales_rwf_test_acc
sales_ets_train_acc
sales_ets_test_acc
sales_arima_train_acc
sales_arima_test_acc
#make a small table that compares the forecast models
#first column lists the model names
#second column lists each model's test-set MASE value
sales_compare<-data.frame(
  Model=c("Naive","SNaive","RWF_Drift","ETS","AutoARIMA"),
  Test_MASE=c(
    #pull the test-set MASE from the naive model accuracy table
    sales_naive_test_acc["Test set","MASE"],
    #pull the test-set MASE from the seasonal naive model accuracy table
    sales_snaive_test_acc["Test set","MASE"],
    #pull the test-set MASE from the random walk with drift model accuracy table
    sales_rwf_test_acc["Test set","MASE"],
    #pull the test-set MASE from the ETS model accuracy table
    sales_ets_test_acc["Test set","MASE"],
    #pull the test-set MASE from the auto ARIMA model accuracy table
    sales_arima_test_acc["Test set","MASE"]))
#output the comparison table so I can see all five MASE values together
sales_compare
#which.min finds the row number of the smallest value in the Test_MASE column
#sales_compare$Model uses the row number to pull out the matching model name
#this stores the name of the best model in sales_best_model
sales_best_model<-sales_compare$Model[which.min(sales_compare$Test_MASE)]
sales_best_model #output what the best model is

#fixed
cat("\n============================================================\n")
cat("FIXED\n")
cat("============================================================\n")
#exploratory data analysis
#plot the full fixed time series
autoplot(fixed_ts)+ggtitle("Fixed Time Series")+xlab("Quarter")+ylab("Fixed")
#print summary stats for fixed time series
summary(fixed_ts)
#check for seasonality 
ggseasonplot(fixed_ts)+ggtitle("Fixed Seasonal Plot")
ggsubseriesplot(fixed_ts)+ggtitle("Fixed Subseries Plot")
nsdiffs(fixed_ts)
#train/test split
fixed_train<-head(fixed_ts,length(fixed_ts)-h)
fixed_test<-tail(fixed_ts,h)
#check if a transformation is needed
fixed_lambda<-BoxCox.lambda(fixed_train);fixed_lambda
#fixed data is nowhere close to 1, so I should use the transformation
fixed_for_test<-BoxCox(fixed_train,lambda=fixed_lambda)
#test stationarity on the transformed fixed series 
adf.test(fixed_for_test);kpss.test(fixed_for_test)
#check how many regular differences are needed
fixed_d<-ndiffs(fixed_for_test)
fixed_d
#no regular differencing is suggested for fixed, so check residuals on the transformed series
checkresiduals(fixed_for_test)
#fit the forecasting models on the training data
fixed_naive<-naive(fixed_train,h=h,lambda=fixed_lambda)
fixed_snaive<-snaive(fixed_train,h=h,lambda=fixed_lambda)
fixed_rwf<-rwf(fixed_train,h=h,drift=TRUE,lambda=fixed_lambda)
fixed_ets_fit<-ets(fixed_train,lambda=fixed_lambda)
fixed_ets_fc<-forecast(fixed_ets_fit,h=h)
fixed_arima_fit<-auto.arima(fixed_train,lambda=fixed_lambda)
fixed_arima_fc<-forecast(fixed_arima_fit,h=h)
#training and test accuracy for each model
fixed_naive_train_acc<-accuracy(fixed_naive)
fixed_naive_test_acc<-accuracy(fixed_naive,fixed_test)
fixed_snaive_train_acc<-accuracy(fixed_snaive)
fixed_snaive_test_acc<-accuracy(fixed_snaive,fixed_test)
fixed_rwf_train_acc<-accuracy(fixed_rwf)
fixed_rwf_test_acc<-accuracy(fixed_rwf,fixed_test)
fixed_ets_train_acc<-accuracy(fixed_ets_fc)
fixed_ets_test_acc<-accuracy(fixed_ets_fc,fixed_test)
fixed_arima_train_acc<-accuracy(fixed_arima_fc)
fixed_arima_test_acc<-accuracy(fixed_arima_fc,fixed_test)
#display the outputs
fixed_naive_train_acc
fixed_naive_test_acc
fixed_snaive_train_acc
fixed_snaive_test_acc
fixed_rwf_train_acc
fixed_rwf_test_acc
fixed_ets_train_acc
fixed_ets_test_acc
fixed_arima_train_acc
fixed_arima_test_acc
#make a small table that compares the forecast models for Fixed
#the first column lists the names of the five models
#the second column lists each model's test-set MASE value
fixed_compare<-data.frame(
  Model=c("Naive","SNaive","RWF_Drift","ETS","AutoARIMA"),
  Test_MASE=c(
    #pull the test-set MASE from the naive model accuracy table
    fixed_naive_test_acc["Test set","MASE"],
    #pull the test-set MASE from the seasonal naive model accuracy table
    fixed_snaive_test_acc["Test set","MASE"],
    #pull the test-set MASE from the random walk with drift model accuracy table
    fixed_rwf_test_acc["Test set","MASE"],
    #pull the test-set MASE from the ETS model accuracy table
    fixed_ets_test_acc["Test set","MASE"],
    #pull the test-set MASE from the auto ARIMA model accuracy table
    fixed_arima_test_acc["Test set","MASE"]));fixed_compare #output comparison table so I can see all 5 MASE values together
#which.min finds the row number of the smallest value in the Test_MASE column
#fixed_compare$Model[...] then uses that row number to pull out the matching model name
#this stores the name of the best Fixed model in fixed_best_model
fixed_best_model<-fixed_compare$Model[which.min(fixed_compare$Test_MASE)]
#show the name of the best Fixed model
fixed_best_model

#labor
cat("\n============================================================\n")
cat("LABOR\n")
cat("============================================================\n")
#exploratory data analysis - plot the full labor time series 
autoplot(labor_ts)+ggtitle("Labor Time Series")+xlab("Quarter")+ylab("Labor")
summary(labor_ts) #print labor summary stats
#check for seasonality
ggseasonplot(labor_ts)+ggtitle("Labor Seasonplot")+xlab("Quarter")+ylab("Labor")
ggsubseriesplot(labor_ts)+ggtitle("Labor Subseries Plot")
nsdiffs(labor_ts)
#train/test split
labor_train<-head(labor_ts,length(labor_ts)-h)
labor_test<-tail(labor_ts,h)
#check whether a variance-stabilizing transformation is needed
#if lambda is close to 1, the original scale is usually fine
#if lambda is farther from 1, a Box-Cox transformation may help stabilize the variance
labor_lambda<-BoxCox.lambda(labor_train)
labor_lambda
#labor lambda is close to 1, so no transformation is needed here
#use both ADF and KPSS to check stationarity
#ADF tests for evidence in favor of stationarity
#KPSS tests for evidence against stationarity
#using both gives a more complete picture than relying on only one test
adf.test(labor_train);kpss.test(labor_train)
#check for how many regular differences are needed
labor_d<-ndiffs(labor_train);labor_d
#given that ndiffs=1, one regular differencing is called for
labor_diff<-diff(labor_train,difference=labor_d)
#retest stationarity after differencing
adf.test(labor_diff);kpss.test(labor_diff)
#check residuals, acf, and Ljung-Box
checkresiduals(labor_diff)
#ADF p-value of 0.01 -> strong evidence of stationarity
#KPSS p-value of 0.1 -> no evidence of stationariity after differencing
#Ljung-Box p-value of 0.005811 -> significant autocorrelation left in the differenced series
#fit the forecasting models on the training data
labor_naive<-naive(labor_train,h=h)
labor_snaive<-snaive(labor_train,h=h)
labor_rwf<-rwf(labor_train,h=h,drift=TRUE)
labor_ets_fit<-ets(labor_train)
labor_ets_fc<-forecast(labor_ets_fit,h=h)
labor_arima_fit<-auto.arima(labor_train)
labor_arima_fc<-forecast(labor_arima_fit,h=h)
#training and test accuracy for each model
labor_naive_train_acc<-accuracy(labor_naive)
labor_naive_test_acc<-accuracy(labor_naive,labor_test)
labor_snaive_train_acc<-accuracy(labor_snaive)
labor_snaive_test_acc<-accuracy(labor_snaive,labor_test)
labor_rwf_train_acc<-accuracy(labor_rwf)
labor_rwf_test_acc<-accuracy(labor_rwf,labor_test)
labor_ets_train_acc<-accuracy(labor_ets_fc)
labor_ets_test_acc<-accuracy(labor_ets_fc,labor_test)
labor_arima_train_acc<-accuracy(labor_arima_fc)
labor_arima_test_acc<-accuracy(labor_arima_fc,labor_test)
#display the outputs
labor_naive_train_acc
labor_naive_test_acc
labor_snaive_train_acc
labor_snaive_test_acc
labor_rwf_train_acc
labor_rwf_test_acc
labor_ets_train_acc
labor_ets_test_acc
labor_arima_train_acc
labor_arima_test_acc
#make a small table of test-set MASE values for the five Labor models
labor_compare<-data.frame(
  Model=c("Naive","SNaive","RWF_Drift","ETS","AutoARIMA"),
  Test_MASE=c(
    labor_naive_test_acc["Test set","MASE"],   #naive test-set MASE
    labor_snaive_test_acc["Test set","MASE"],  #seasonal naive test-set MASE
    labor_rwf_test_acc["Test set","MASE"],     #random walk with drift test-set MASE
    labor_ets_test_acc["Test set","MASE"],     #ETS test-set MASE
    labor_arima_test_acc["Test set","MASE"]))  #auto ARIMA test-set MASE
#print the comparison table
labor_compare
#find the model with the smallest test-set MASE
labor_best_model<-labor_compare$Model[which.min(labor_compare$Test_MASE)]
#print the best Labor model
labor_best_model
#the displayed test-set MASE values were tied, so R selected the first min, what was naive
#Because naive is also the simplest model, it is a reasonable choice in a tie

#material
cat("\n============================================================\n")
cat("MATERIAL\n")
cat("============================================================\n")
#exploratory data analysis - plot the full material time series
autoplot(material_ts)+ggtitle("Material Time Series")+xlab("Quarter")+ylab("Material")
summary(material_ts)#print summary stats for materials
#check for seasonality
ggseasonplot(material_ts)+ggtitle("Material Seasonal Plot")
ggsubseriesplot(material_ts)+ggtitle("Material Subseries Plot")
nsdiffs(material_ts)
#train/test split
material_train<-head(material_ts,length(material_ts)-h)
material_test<-tail(material_ts,h)
#check if a transformation is needed 
material_lambda<-BoxCox.lambda(material_train);material_lambda
#nsdiffs=0 shows that no sign that seasonal differencing is needed
#material lambda is not close enough to 1, so use the transformation
material_for_test<-BoxCox(material_train,lambda=material_lambda)
#use both ADF and KPSS to check stationarity
#ADF tests for evidence in favor of stationarity
#KPSS tests for evidence against stationarity
#using both gives a more complete picture than relying on only one test
adf.test(material_for_test);kpss.test(material_for_test)
#check how many regular differences are needed 
material_d<-ndiffs(material_for_test);material_d
#material needs one regular difference
material_diff<-diff(material_for_test,differences=material_d)
#reset stationarity after differencing
adf.test(material_diff);kpss.test(material_diff)
#check residuals, acf, and lujung-box
checkresiduals(material_diff)
#fit the forecasting models on the training data, using lambda makes sure that the backtransformation is automatically handeled
material_naive<-naive(material_train,h=h,lambda=material_lambda)
material_snaive<-snaive(material_train,h=h,lambda=material_lambda)
material_rwf<-rwf(material_train,h=h,drift=TRUE,lambda=material_lambda)
material_ets_fit<-ets(material_train,lambda=material_lambda)
material_ets_fc<-forecast(material_ets_fit,h=h)
material_arima_fit<-auto.arima(material_train,lambda=material_lambda)
material_arima_fc<-forecast(material_arima_fit,h=h)
#training and test accuracy for each model
material_naive_train_acc<-accuracy(material_naive)
material_naive_test_acc<-accuracy(material_naive,material_test)
material_snaive_train_acc<-accuracy(material_snaive)
material_snaive_test_acc<-accuracy(material_snaive,material_test)
material_rwf_train_acc<-accuracy(material_rwf)
material_rwf_test_acc<-accuracy(material_rwf,material_test)
material_ets_train_acc<-accuracy(material_ets_fc)
material_ets_test_acc<-accuracy(material_ets_fc,material_test)
material_arima_train_acc<-accuracy(material_arima_fc)
material_arima_test_acc<-accuracy(material_arima_fc,material_test)
#display the outputs
material_naive_train_acc
material_naive_test_acc
material_snaive_train_acc
material_snaive_test_acc
material_rwf_train_acc
material_rwf_test_acc
material_ets_train_acc
material_ets_test_acc
material_arima_train_acc
material_arima_test_acc
#make a small table of test-set MASE values for the five Material models
material_compare<-data.frame(
  Model=c("Naive","SNaive","RWF_Drift","ETS","AutoARIMA"),
  Test_MASE=c(
    material_naive_test_acc["Test set","MASE"],   #naive test-set MASE
    material_snaive_test_acc["Test set","MASE"],  #seasonal naive test-set MASE
    material_rwf_test_acc["Test set","MASE"],     #random walk with drift test-set MASE
    material_ets_test_acc["Test set","MASE"],     #ETS test-set MASE
    material_arima_test_acc["Test set","MASE"]))   #auto ARIMA test-set MASE
#print the comparison table
material_compare
#find the model with the smallest test-set MASE
material_best_model<-material_compare$Model[which.min(material_compare$Test_MASE)]
#print the best Material model
material_best_model

#profit
cat("\n============================================================\n")
cat("PROFIT\n")
cat("============================================================\n")
#exploratory data analysis - plot the full series 
autoplot(profit_ts)+ggtitle("Profit Time Series")+xlab("Quarter")+ylab("Profit")
summary(profit_ts)#print summary stats for profit
#check for seasonality
ggseasonplot(profit_ts)+ggtitle("Profit Seasonal Plot")
ggsubseriesplot(profit_ts)+ggtitle("Profit Subseries Plot")
nsdiffs(profit_ts)
#train/test split
profit_train<-head(profit_ts,length(profit_ts)-h)
profit_test<-tail(profit_ts,h)
#check if a transformation is needed
profit_lambda<-BoxCox.lambda(profit_train)
profit_lambda
#transforming is called for (.308) but seasonal differencing (0) isn't
#profit lambda is not close enough to 1, so use the transformation
profit_for_test<-BoxCox(profit_train,lambda=profit_lambda)
#test stationarity on the transformed profit series
adf.test(profit_for_test)
kpss.test(profit_for_test)
#check how many regular differences are needed
profit_d<-ndiffs(profit_for_test)
profit_d
#ndiffs=1, so profit needs 1 regular difference 
profit_diff<-diff(profit_for_test,differences=profit_d)
#use both ADF and KPSS to check stationarity
#ADF tests for evidence in favor of stationarity
#KPSS tests for evidence against stationarity
#using both gives a more complete picture than relying on only one test
adf.test(profit_diff);kpss.test(profit_diff)
#check residuals, acf, and Ljung-Box
checkresiduals(profit_diff)
#ADF p-value of 0.01 -> strong evidence against stationarity after differencing
#KPSS p-value of 0.1 -> no evidence of stationarity after differncing
#Ljung-Box p-value of 0.05868 -> not significant at 5%, so this is acceptable
#fit the forecasting models on the training data
#use lambda so the backtransformation is handled automatically
profit_naive<-naive(profit_train,h=h,lambda=profit_lambda)
profit_snaive<-snaive(profit_train,h=h,lambda=profit_lambda)
profit_rwf<-rwf(profit_train,h=h,drift=TRUE,lambda=profit_lambda)
profit_ets_fit<-ets(profit_train,lambda=profit_lambda)
profit_ets_fc<-forecast(profit_ets_fit,h=h)
profit_arima_fit<-auto.arima(profit_train,lambda=profit_lambda)
profit_arima_fc<-forecast(profit_arima_fit,h=h)
#training and test accuracy for each model
profit_naive_train_acc<-accuracy(profit_naive)
profit_naive_test_acc<-accuracy(profit_naive,profit_test)
profit_snaive_train_acc<-accuracy(profit_snaive)
profit_snaive_test_acc<-accuracy(profit_snaive,profit_test)
profit_rwf_train_acc<-accuracy(profit_rwf)
profit_rwf_test_acc<-accuracy(profit_rwf,profit_test)
profit_ets_train_acc<-accuracy(profit_ets_fc)
profit_ets_test_acc<-accuracy(profit_ets_fc,profit_test)
profit_arima_train_acc<-accuracy(profit_arima_fc)
profit_arima_test_acc<-accuracy(profit_arima_fc,profit_test)
#display the outputs
profit_naive_train_acc
profit_naive_test_acc
profit_snaive_train_acc
profit_snaive_test_acc
profit_rwf_train_acc
profit_rwf_test_acc
profit_ets_train_acc
profit_ets_test_acc
profit_arima_train_acc
profit_arima_test_acc
#make a small table of test-set MASE values for the five Profit models
profit_compare<-data.frame(
  Model=c("Naive","SNaive","RWF_Drift","ETS","AutoARIMA"),
  Test_MASE=c(
    profit_naive_test_acc["Test set","MASE"],   #naive test-set MASE
    profit_snaive_test_acc["Test set","MASE"],  #seasonal naive test-set MASE
    profit_rwf_test_acc["Test set","MASE"],     #random walk with drift test-set MASE
    profit_ets_test_acc["Test set","MASE"],     #ETS test-set MASE
    profit_arima_test_acc["Test set","MASE"])) #auto ARIMA test-set MASE
#print the comparison table
profit_compare
#find the model with the smallest test-set MASE
profit_best_model<-profit_compare$Model[which.min(profit_compare$Test_MASE)]
#print the best Profit model
profit_best_model

#Final Forecast Code Section 
#for the final forecast, use the full time series rather than the train set
#once the best model has been selected, refitting on the full series lets the model use all available information before forecasting the next 8 quarters
#estimate lambda values again using the full series rather than variables that need transformation
sales_final_lambda<-BoxCox.lambda(sales_ts)
fixed_final_lambda<-BoxCox.lambda(fixed_ts)
material_final_lambda<-BoxCox.lambda(material_ts)
profit_final_lambda<-BoxCox.lambda(profit_ts)
#labor did not need a transformation, so no labor lambda is needed

#sales final model - random walk with drift
#fit the final sales model on the full sales series
sales_final_fc<-rwf(sales_ts,h=8,drift=TRUE,lambda=sales_final_lambda)
#plot the final sales forecast
autoplot(sales_final_fc)+ggtitle("Sales Final 8 Quarter Forecast")+xlab("Quarter")+ylab("Sales")
#print the 8 forecast values for sales with commas in-between them
cat("Sales forecast:\n")
cat(paste(round(as.numeric(sales_final_fc$mean),2),collapse=", ")) #collapse=", " tells R to print all the forecast values in one line with commas between them
cat("\n\n")

#fixed final model - ets 
#fit the final ETS model on the full fixed series
fixed_final_fit<-ets(fixed_ts,lambda=fixed_final_lambda)
fixed_final_fc<-forecast(fixed_final_fit,h=8)
#plot the final fixed forecast
autoplot(fixed_final_fc)+ggtitle("Fixed Final 8 Quarter Forecast")+xlab("Quarter")+ylab("Fixed")
#print the 8 forecast values for fixed with commas in between them
cat("Fixed forecast:\n")
cat(paste(round(as.numeric(fixed_final_fc$mean),2),collapse=", "))
cat("\n\n")

#labor final model - naive
#fit the final naive model on the full labor series
labor_final_fc<-naive(labor_ts,h=8)
#plot the final labor cost forecast
autoplot(labor_final_fc)+ggtitle("Labor Final 8 Quarter Forecast")+xlab("Quarter")+ylab("Labor")
#print the 8 forecast values for labor with commas in between them
cat("Labor forecast:\n")
cat(paste(round(as.numeric(labor_final_fc$mean),2),collapse=", "))
cat("\n\n")

#material final model - random walk with drift
#fit the final material model on the full material series
material_final_fc<-rwf(material_ts,h=8,drift=TRUE,lambda=material_final_lambda)
#plot the final material forecast
autoplot(material_final_fc)+ggtitle("Material Final 8 Quarter Forecast")+xlab("Quarter")+ylab("Material")
#print the 8 forecast values for material with commas between them
cat("Material forecast:\n")
cat(paste(round(as.numeric(material_final_fc$mean),2),collapse=", "))
cat("\n\n")

#profit final model
#fit the final profit model on the full profit series
profit_final_fc<-rwf(profit_ts,h=8,drift=TRUE,lambda=profit_final_lambda)
#plot the final profit forecast
autoplot(profit_final_fc)+ggtitle("Profit Final 8 Quarter Forecast")+xlab("Quarter")+ylab("Profit")
#print the 8 forecast values for profit with commas between them
cat("Profit forecast:\n")
cat(paste(round(as.numeric(profit_final_fc$mean),2),collapse=", "))
cat("\n\n")
#make one final table that holds all of the 8-quarter forecasts together
#this makes the final results easier to read and easier to copy into the analysis document
#this creates a data frame, which is basically a table in R
final_forecast_table<-data.frame(
  
  #the first column labels how far ahead each forecast is
  #1 means 1 quarter ahead, 2 means 2 quarters ahead, and so on until 8
  Quarter_Ahead=1:8,
  
  #this column stores the 8 forecasted Sales values
  #sales_final_fc$mean pulls out the forecast means
  #as.numeric turns them into plain numeric values
  #round(...,2) rounds each value to 2 decimal places
  Sales=round(as.numeric(sales_final_fc$mean),2),
  
  #this column stores the 8 forecasted Fixed values
  #the same process is used here: pull out the mean forecasts, convert to numeric, round to 2 decimals
  Fixed=round(as.numeric(fixed_final_fc$mean),2),
  
  #this column stores the 8 forecasted Labor values
  #again, pull out the forecast means, convert to numeric, and round
  Labor=round(as.numeric(labor_final_fc$mean),2),
  
  #this column stores the 8 forecasted Material values
  #same idea as the earlier columns
  Material=round(as.numeric(material_final_fc$mean),2),
  
  #this column stores the 8 forecasted Profit values
  #this gives me all five forecast series in one combined table
  Profit=round(as.numeric(profit_final_fc$mean),2))
#print the completed forecast table so I can see it in R
final_forecast_table
#export the forecast table to a csv file
#this lets me open it in Excel or copy it more easily into Word
#row.names=FALSE keeps R from adding an extra numbered column on the left
write.csv(final_forecast_table,"C:/R-Stuff for DSCI 430/CSV files/third_sales_final_forecasts.csv",row.names=FALSE)