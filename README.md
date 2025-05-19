🏎️ AutoMPG-Analysis
🔍 Statistical analysis and fuel efficiency prediction (mpg) using linear regression and GAM models on the classic Auto dataset from StatLib (1983).

📊 Dataset
The analysis is based on the Auto.csv dataset, available as part of the resources for the book:

James, G., Witten, D., Hastie, T., and Tibshirani, R. (2013).
An Introduction to Statistical Learning with Applications in R, 2nd Edition.
Springer-Verlag, New York.
Available at: https://www.statlearning.com

🔗 Dataset Source
📚 This dataset comes from the StatLib library, maintained by Carnegie Mellon University, and was originally featured in the 1983 ASA Exposition.

📥 You can download the .csv file directly from the Resources section of the ISLR book website:
🌐 https://www.statlearning.com

📄 Dataset Description
🚗 Observations: 392 vehicles
📊 Features: 9 variables

🔠 Variable	📝 Description
mpg	📈 Miles per gallon (fuel efficiency)
cylinders	🔧 Number of cylinders (4–8)
displacement	📦 Engine displacement (cubic inches)
horsepower	🐎 Engine horsepower
weight	⚖️ Vehicle weight (lbs)
acceleration	🏁 Time to accelerate from 0 to 60 mph (seconds)
year	📆 Model year (e.g. 70 = 1970)
origin	🌍 Car origin: 1 = 🇺🇸 US, 2 = 🇪🇺 Europe, 3 = 🇯🇵 Japan
name	🏷️ Vehicle name (e.g. “chevrolet chevelle malibu”)

ℹ️ Note: The original dataset included 397 entries.
🧹 The ISLR2 version removes 5 rows due to missing horsepower values.
🔧 In this project, we handle missing values manually during data preprocessing.


📦 Block 1: Data Import & Library Setup
All necessary libraries for data manipulation, visualization, and modeling are loaded, including dplyr, ggplot2, mgcv, and leaps. The dataset Auto.csv is imported with missing values explicitly defined as "?". This sets up a clean and consistent foundation for the entire analysis.

🧼 Block 2: Data Inspection & Cleaning
Initial data checks are performed to examine variable classes and detect missing values. Variables are recast to their appropriate types (e.g., horsepower as numeric, origin as factor). Missing values in horsepower are imputed using group-wise means by cylinders and origin. Outliers in horsepower are identified, and a boxplot is generated to visualize the distribution after imputation.

📊 Block 3: Exploring Fuel Efficiency
We dive into the distribution of mpg with a clean boxplot and spot a few wild outliers. Basic stats give us a sense of spread. The data is then split into training and testing sets — time to get predictive. Oh, and we also check if cars from Europe, Japan, or the US sip or guzzle more fuel.



