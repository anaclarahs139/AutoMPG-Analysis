🏎️ AutoMPG-Analysis
🔍 Statistical analysis and fuel efficiency prediction (mpg) using linear regression and GAM models on the classic Auto dataset from StatLib (1983).

📊 Dataset
The analysis is based on the Auto.csv dataset, available as part of the resources for the book:

James, G., Witten, D., Hastie, T., and Tibshirani, R. (2013).
An Introduction to Statistical Learning with Applications in R, 2nd Edition.
Springer-Verlag, New York.
Available at: https://www.statlearning.com

🔗 Dataset Source
This dataset originates from the StatLib library maintained at Carnegie Mellon University and was featured in the 1983 American Statistical Association Exposition.

Direct access: You can download the data in .csv format from the Resources section at https://www.statlearning.com.

📄 Dataset Description
Observations: 392 vehicles

Variables:

mpg: Miles per gallon (fuel efficiency)

cylinders: Number of cylinders (4–8)

displacement: Engine displacement (cubic inches)

horsepower: Engine horsepower

weight: Vehicle weight (lbs)

acceleration: Time to accelerate from 0 to 60 mph (sec)

year: Model year (modulo 100)

origin: Car origin (1 = US, 2 = Europe, 3 = Japan)

name: Vehicle name

ℹ️ Note: The original dataset had 397 observations. 5 entries with missing horsepower values were removed in the ISLR2 version. In this analysis, we handle missing values explicitly (see section "Data Preprocessing").

