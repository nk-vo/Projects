#Removed all the existing objects
rm(list = ls())
#Setting the working directory
setwd("D:/Ediwsor_Project - Bike_Rental_Count/")
getwd()

#Load the dataset
bike_data = read.csv("day.csv",header=TRUE)

###################################### Exploratory Data Analysis ##################################################

# 1. Understanding the data values of every column of the dataset
str(bike_data)

# 2. Viewing the type of the dataset
class(bike_data)

# 3.Understanding the data distribution of the dataset
summary(bike_data)

# 4. Dimensions of the dataset
dim(bike_data)

# From the above data analysis, we have understood that the data columns -- 'season', 'yr', 'mnth', 'holiday', 'weekday', 'workingday' and 'weathersit' belong to categorical type values.
# Thus, we need to change the data types of the columns to suitable types

bike_data$season=as.factor(bike_data$season)
bike_data$yr=as.factor(bike_data$yr)
bike_data$mnth=as.factor(bike_data$mnth)
bike_data$holiday=as.factor(bike_data$holiday)
bike_data$weekday=as.factor(bike_data$weekday)
bike_data$workingday=as.factor(bike_data$workingday)
bike_data$weathersit=as.factor(bike_data$weathersit)
bike_data$dteday = as.Date(bike_data$dteday,format="%Y-%m-%d")

str(bike_data)

#Now we will check the effect of certain variables on the dependent variable(cnt) and decide whether to restore or drop those data columns

#Extracting the day values from the date and storing into a new column - 'day'
bike_data$day=format(bike_data$dteday,"%d")
unique(bike_data$day)

#Using plot() function to visualize and depict the relationship between the data column 'day' and dependent variable 'cnt'

plot(bike_data$day,bike_data$cnt)

library(ggplot2)          
ggplot(bike_data, aes(instant, cnt)) + geom_point() + scale_x_continuous("Instant")+ scale_y_continuous("Count")

#Insights from the above data distribution
#1. From the above visualization, it is pretty clear that the data columns 'day' and 'instant' do not contribute to the dependent variable 'cnt' and happen to have NO relationship between them. Thus, we can drop the data columns 'day' and 'instant' from the dataset.
#2. Further, the data column 'dteday' represents information about the 'day', 'month' and 'year'. But, the data columns 'mnth' and 'yr' are separately present in the data set to give information about the same. Thus, it makes us applicable to drop the data column 'dteday'.
#3. The data variables 'casual' and 'registered' is actually combined to form the data variable 'cnt' which is also the dependent variable of the dataset. Thus, it makes us applicable to drop the data columns 'casual' and 'registered'.

#Dropping the above mentioned data columns from the dataset
bike_data=subset(bike_data,select = -c(instant,day,dteday,casual,registered))
str(bike_data)
dim(bike_data)

#############################Missing Value Analysis#########################################
sum(is.na(bike_data))
summary(is.na(bike_data))
#From the above result, it is clear that the dataset contains NO Missing Values.

##############################Outlier Analysis -- DETECTION###########################

# 1. Outliers in the data values exists only in continuous/numeric form of data variables. Thus, we need to store all the numeric and categorical independent variables into a separate array structure.
numeric_col = c('temp','atemp','hum','windspeed')
categorical_col = c("season","yr","mnth","holiday","weekday","workingday","weathersit")

# 2. Using BoxPlot to detect the presence of outliers in the numeric/continuous data columns.
boxplot(bike_data[,c('temp','atemp','hum','windspeed')])

# From the above visualization, it is clear that the data variables 'hum' and 'windspeed' contains outliers in the data values.
#OUTLIER ANALYSIS -- Removal of Outliers
# 1. From the boxplot, we have identified the presence of outliers. That is, the data values that are present above the upper quartile and below the lower quartile can be considered as the outlier data values.
# 2. Now, we will replace the outlier data values with NULL.

for (x in c('hum','windspeed'))
{
  value = bike_data[,x][bike_data[,x] %in% boxplot.stats(bike_data[,x])$out]
  bike_data[,x][bike_data[,x] %in% value] = NA
} 

#Checking whether the outliers in the above defined columns are replaced by NULL or not
sum(is.na(bike_data$hum))
sum(is.na(bike_data$windspeed))
as.data.frame(colSums(is.na(bike_data)))
#Removing the null values
library(tidyr)
bike_data = drop_na(bike_data)
as.data.frame(colSums(is.na(bike_data)))

#########DATA VISUALIZATION -- Numeric variables of the dataset##################

#1. Scatter Plot of hum v/s cnt
ggplot(bike_data, aes(hum, cnt)) + geom_point() + scale_x_continuous("Humidity")+ scale_y_continuous("Count")

#2. Scatter PLot of windspeed v/s cnt
ggplot(bike_data, aes(windspeed, cnt)) + geom_point() + scale_x_continuous("Windspeed")+ scale_y_continuous("Count")

#3. Scatter Plot of temp v/s cnt
ggplot(bike_data, aes(temp, cnt)) + geom_point() + scale_x_continuous("Temp")+ scale_y_continuous("Count")

#4. Scatter Plot of atemp v/s cnt
ggplot(bike_data, aes(atemp, cnt)) + geom_point() + scale_x_continuous("Atemp")+ scale_y_continuous("Count")

##From the above data visualization, it is clear that the data variables 'temp' and 'atemp' are related to each other. 
#Further, the data is free from outliers.

#############DATA VISUALIZATION -- Categorical Variables of the dataset###########
library(gplots)
#1. Bar Plot of season v/s cnt
ggplot(bike_data, aes(x = season, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count per Season", x = "Seasons", y = "cnt")
#2. Bar Plot of yr v/s cnt
ggplot(bike_data, aes(x = yr, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count per Year", x = "Year", y = "cnt")
#3. Bar Plot of holiday v/s cnt
ggplot(bike_data, aes(x = holiday, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count v/s Holiday", x = "Holiday", y = "cnt")
#4. Bar Plot of weekday v/s cnt
ggplot(bike_data, aes(x = weekday, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count v/s Weekday", x = "Weekday", y = "cnt")
#5. Bar Plot of workingday v/s cnt
ggplot(bike_data, aes(x = workingday, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count per Workingday", x = "Workingday", y = "cnt")
#6. Bar Plot of Weathersit v/s cnt
ggplot(bike_data, aes(x = weathersit, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count per Weathersit", x = "Weathersit", y = "cnt")
#7. Bar Plot of month v/s cnt
ggplot(bike_data, aes(x = mnth, y = cnt))+
  geom_bar(stat = "identity",fill = "purple")+
  labs(title = "Bike Rental count per month", x = "Month", y = "cnt")

# Insights from the above data visualization:
# 1. Season 2,3 and 4 have observed a high count as compared to Season 1.
# 2. Season 3 ahs the highest count of Bikes on Rent and Season 1 has the lowest count of Bikes on Rent.
# 3. Year 1 is observed to have high count of Bikes on rent that in year 0
# 4. On a holiday, the bike rental count is less as compared to a non-holiday
# 5. The count of Bikes on Rent is the high between the weekdays 2-5, with weekday = 5 having the Highest count and weekday = 0 having the lowest count
# 6. The count of Bikes on Rent is the highest on a workingday(neither a weekend nor a holiday)
# 7. The weather Type 1 i.e. weathersit = 1, has the highest count of bikes on rent
# 8. The month values between 3-10 has considerably a good count of bikes on rent. Moreover, the month = 8 has the highest count of Bikes on Rent

###################DATA VISUALIZATION -- Multiple columns together###########################
# 1. Scatter Plot of holiday and Workingday with cnt
ggplot(bike_data,aes(holiday,cnt)) + 
  geom_point(aes(color=workingday),alpha=0.5) +
  labs(title = "Holiday and Workingday v/s Count", x = "Temperature", y = "Count")
#From the above plot, we can say that the bike rental count is the highest when the day is not a holiday(holiday = 0) and when the day is a workingday(not a weekend or a holiday i.e. workingday=1)
 
# 2. Scatter Plot of Season and Workingday with cnt
ggplot(bike_data,aes(season,cnt)) + 
  geom_point(aes(color=workingday),alpha=1) +
  labs(title = "Holiday and Workingday v/s Count", x = "Season", y = "Count")
#From the above plot, we can say that the bike rental count is the high when the season is 2 or 3 or 4 and when the day is a workingday(not a weekend or a holiday i.e. workingday=1)

# 3, Scatter Plot of Season and weathersit with cnt
ggplot(bike_data,aes(season,cnt)) + 
  geom_point(aes(color=weathersit),alpha=1) +
  labs(title = "Season and Weathersit v/s Count", x = "Season", y = "Count")
#From the above plot, we can say that the bike rental count is the high when the season is 2 or 3 or 4 and when the weather type is 1

# 4. Scatter Plot of Weathersit and workingday with cnt
ggplot(bike_data,aes(weathersit,cnt)) + 
  geom_point(aes(color=workingday),alpha=1) +
  labs(title = "Weathersit and Workingday v/s Count", x = "Weathersit", y = "Count")
#From the above plot, we can say that the overall bike rental count is the maximum when the weathersit is of type 1, and when it is a workingday(workingday=1)

# 5. Scatter Plot of Season and yr with cnt
ggplot(bike_data,aes(season,cnt)) + 
  geom_point(aes(color=yr),alpha=1) +
  labs(title = "Season and Year v/s Count", x = "Season", y = "Count")
#From the above plot, we can say that the overall bike rental count is the maximum for the season 2,3,4, and for the year = 1

# 6. Scatter Plot of Season and mnth with cnt
ggplot(bike_data,aes(season,cnt)) + 
  geom_point(aes(color=mnth),alpha=1) +
  labs(title = "Season and Month v/s Count", x = "Season", y = "Count")
#From the above plot, we can say that the overall bike rental count is the maximum for the season 2,3,4, and for the months between 3-10

####################################FEATURE SELECTION from the Continuous independent variables#############################
print(numeric_col) # Numeric/Continuous data variables of the dataset

library(corrgram)
corrgram(bike_data[,numeric_col],order=FALSE,upper.panel = panel.pie,
         text.panel = panel.txt,
         main= "Correlation Analysis Plot of the Continuous Independent Variables")
#From the above correlation analysis plot, it is clear that the numeric variables 'temp' and 'atemp' are highly co-related to each other i.e. they serve or depict the same information.
#Thus, it makes us applicable to drop any one of those data variables.
#So, we drop the 'atemp' variable from the dataset.
bike_data = subset(bike_data,select = -c(atemp))
str(bike_data)

####################################FEATURE SELECTION -- Selecting features from Categorical independent variables################################
print(categorical_col)
for(x in categorical_col)
{
  print(x)
  anova_test = aov(cnt ~ bike_data[,x],bike_data)
  print(summary(anova_test))
}
  
#From the ANOVA Test analysis, it is clear that the variables ['holiday','workingday'and 'weekday'] have p-values > 0.05. 
#Thus, we drop these data variables.
bike_data = subset(bike_data, select=-c(weekday,workingday))
str(bike_data)

#################################FEATURE SCALING##########################################################
#Before applying feature scaling techniques, we need to check whether the data is normalized or not. 
#If the data is found to be normalized, we do not apply any scaling to it.
#If the data is found to be skewed i.e. not in a normalized form, then we apply scaling technique to scale the data.

##Techniques to check for Normalization of the dataset
#1. qqnorm plot
#2. Histogram
#3. Skewness Test

#Applying Q-Q Plot on Continuous Variables to perform Normalization check

qqnorm(bike_data$temp)
qqnorm(bike_data$hum)
qqnorm(bike_data$windspeed)

#Applying Histogram Plot on Continuous Variables to perform Normalization check
hist(bike_data$temp)
hist(bike_data$hum)
hist(bike_data$windspeed)

#Applying Skewness Test on Continuous Variables to perform Normalization check
library(e1071)    
numeric_col_updated = c('temp','hum','windspeed')
for(x in numeric_col_updated)
{
  print(x)
  skew_test = skewness(bike_data[,x])
  print(skew_test)
}

#From the above Skewness Test, Q-Q Plot and Histogram Plot of all the Continuous Variables, it is clear that the data is NORMALLY DISTRIBUTED.
#Hence, we need not apply any scaling technique.

#So, after data pre-processing, the following insights canbe drawn from the data:
#1. The dataset contains 8 data variables (7 indepedent variables and 1 dependent variable).
#2. The dependent variable(cnt) is a continuous variable.
#3. Thus, it is a REGRESSION type of Business Problem Statement.

#######################SAMPLING OF DATA -- Splitting of Data columns into Training and Test dataset###########################
categorical_col_updated = c('season','yr','mnth','weathersit','holiday')
library(dummies)
bike = bike_data
bike = dummy.data.frame(bike,categorical_col_updated)
dim(bike)
#Separating the depenedent and independent data variables into two dataframes.
library(caret)
set.seed(101)
split_val = createDataPartition(bike$cnt, p = 0.80, list = FALSE) 
train_data = bike[split_val,]
test_data = bike[-split_val,]
##############################MODELLING OF DATA USING MACHINE LEARNING ALGORITHMS##############################
#Defining error metrics to check the error rate and accuracy of the Regression ML algorithms

#1. MEAN ABSOLUTE PERCENTAGE ERROR (MAPE)
MAPE = function(y_actual,y_predict){
  mean(abs((y_actual-y_predict)/y_actual))*100
}

#2. R SQUARE error metric -- Coefficient of Determination
RSQUARE = function(y_actual,y_predict){
  cor(y_actual,y_predict)^2
}

##MODEL 1: LINEAR REGRESSION
linear_model = lm(cnt~., train_data) #Building the Linear Regression Model on our dataset
summary(linear_model)
linear_predict=predict(linear_model,test_data[-27]) #Predictions on Testing data
LR_MAPE = MAPE(test_data[,27],linear_predict) # Using MAPE error metrics to check for the error rate and accuracy level
LR_R = RSQUARE(test_data[,27],linear_predict) # Using R-SQUARE error metrics to check for the error rate and accuracy level
Accuracy_Linear = 100 - LR_MAPE
print("MAPE: ")
print(LR_MAPE)
print("R-Square: ")
print(LR_R)
print('Accuracy of Linear Regression: ')
print(Accuracy_Linear)

##MODEL 2: DECISION TREES
library(rpart)
DT_model =rpart(cnt~., train_data, method = "anova" , minsplit=5)
DT_predict = predict(DT_model,test_data[-27])
DT_MAPE = MAPE(test_data[,27],DT_predict)
DT_R = RSQUARE(test_data[,27],DT_predict)
Accuracy_DT = 100 - DT_MAPE
print("MAPE: ")
print(DT_MAPE)
print("R-Square: ")
print(DT_R)
print('Accuracy of Decision Tree: ')
print(Accuracy_DT)

##MODEL 3: RANDOM FOREST
library(randomForest)
set.seed(123)
RF_model = randomForest(cnt~., train_data, ntree = 300, importance = TRUE)
RF_predict=predict(RF_model,test_data[-27])
RF_MAPE = MAPE(test_data[,27],RF_predict)
RF_R = RSQUARE(test_data[,27],RF_predict)
Accuracy_RF = 100 - RF_MAPE
print("MAPE: ")
print(RF_MAPE)
print("R-Square: ")
print(RF_R)
print('Accuracy of Random Forest: ')
print(Accuracy_RF)

##MODEL 4: KNN 
KNN_model = FNN::knn.reg(train = train_data, test = test_data, y = train_data[,27], k = 3)
KNN_predict=ceiling(KNN_model$pred[1:27]) #Predicted values
KNN_MAPE = MAPE(test_data[,27],KNN_predict)
Accuracy_KNN = 100 - KNN_MAPE
print("MAPE: ")
print(KNN_MAPE)
print('Accuracy of KNN: ')
print(Accuracy_KNN)

##MODEL 5: XBoosted Tree
library(xgboost)
train_matrix = as.matrix(sapply(train_data[-27],as.numeric))
test_matrix = as.matrix(sapply(test_data[-27],as.numeric))

xgboost_model = xgboost(data = train_matrix,label = train_data$cnt, nrounds = 15,verbose = FALSE)
summary(xgboost_model)
xgboost_predict = predict(xgboost_model,test_matrix)
xgboost_MAPE = MAPE(test_data[,27],xgboost_predict)
xgboost_R = RSQUARE(test_data[,27],xgboost_predict)
Accuracy_xgboost = 100 - xgboost_MAPE
print("MAPE: ")
print(xgboost_MAPE)
print("R-Square: ")
print(xgboost_R)
print('Accuracy of XGBOOST: ')
print(Accuracy_xgboost)

Bike_res = data.frame('Actual_count' = test_data[,27], 'Predicted_count' = RF_predict )
write.csv(Bike_res,"BIKE_RESULT_R.csv",row.names=FALSE)
