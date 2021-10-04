import csv
import pandas as pd
from sklearn.tree import DecisionTreeRegressor
from pandas import Series, DataFrame

#loading my train dataset into python
train = pd.read_csv('train_6_DRKMP_2.csv')
test = pd.read_csv('test_6_DRKMP_2.csv')

#factors that will predict the price
desired_factors = ['x','R']

#set my model to DecisionTree
model = DecisionTreeRegressor()

#set prediction data to factors that will predict, and set target to SalePrice
train_data = train[desired_factors]
test_data = test[desired_factors]
target = train.SalePrice()

#fitting model with prediction data and telling it my target
model.fit(train_data, target)

model.predict(test_data.head())