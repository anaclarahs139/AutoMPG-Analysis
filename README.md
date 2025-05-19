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


🔽 1. Data Import & Library Setup 📦
Description: We begin by loading all necessary R libraries for data wrangling, visualization, and modeling. The dataset is imported from .csv with missing values handled explicitly.

🧰 Key steps:

Load core packages: dplyr, ggplot2, mgcv, leaps, etc.

Import Auto.csv and flag "?" as NA.

📂 Output: A raw but structured DataFrame ready for cleaning and transformation.



🧼 2. Data Inspection & Cleaning 🔍
Description: We inspect variable classes, recast types where needed, and handle missing values in horsepower using group-wise mean imputation. We also identify and visualize outliers.

🛠️ Key steps:

Fix data types (e.g., origin → factor, horsepower → numeric)

Impute missing horsepower by cylinders & origin

Generate boxplot of horsepower after cleaning

📎 Insight: Missing values are smartly filled based on mechanical similarity. Outliers still sneak through — but we catch them.



📊 3. Exploratory Analysis of MPG
Description: We explore the distribution of mpg and compare fuel efficiency by region of origin (US, Europe, Japan). The dataset is then split into training and test subsets for modeling.

🔧 Key steps:

Boxplot & summary of mpg

Identify mpg outliers

Train-test split (75/25)

Visualize mpg by car origin

🧠 Insight: Japanese cars generally achieve higher mpg, as expected. Time to let the models speak.



🔗 4. Correlation & Variable Relationships 📈
Description: We calculate a correlation matrix of all numeric variables and visualize it using a color gradient. A custom upper-triangle scatter matrix shows nuanced relationships between variables.

📊 Visualizations:

Heatmap of correlation coefficients

Colored scatterplots by model year (e.g., mpg vs. weight, horsepower, etc.)

💡 Insight: Weight and displacement are highly correlated — these big players drag mpg down. Year brings salvation.



🧪 5. Baseline Linear Regression Modeling
Description: A multiple linear regression model is trained using weight, horsepower, year, and more. Predictions are made on the test set and compared to actual values.

🔍 Key metrics:

Predictions with 95% prediction intervals

Plot: actual vs. predicted mpg

Summary of residuals and model stats

🎯 Insight: Not perfect, but decent. Linear regression gives a baseline idea of how physical specs impact efficiency.



📏 6. Model Performance Evaluation
Description: We compute standard performance metrics (MSE, RMSE, MAE, R²) for both training and test sets to evaluate model generalization.

📊 Metrics calculated:

Mean Squared Error (MSE)

Root Mean Squared Error (RMSE)

Mean Absolute Error (MAE)

R-squared (R²)

🧠 Insight: Some overfitting is visible — the model performs better on training data than unseen test data.



🛠️ 7. Polynomial & Interaction Modeling
Description: We improve the linear model by introducing polynomial terms and interaction effects. This allows us to capture non-linear dependencies and mixed-variable impacts.

🔧 Upgrades include:

poly(weight, 2), poly(displacement, 2)

Interactions: horsepower * year, weight * cylinders

📉 Insight: The enhanced model reduces error and boosts R², but complexity increases. It's a trade-off — more flexibility, less interpretability.



🧮 8. Feature Selection via Subset Regression
Description: We apply exhaustive subset selection to find the optimal number of predictors using regsubsets(). Models are evaluated by Adjusted R².

📈 Visualization:

Line plot of Adjusted R² vs. number of predictors

🎯 Insight: A 4–5 variable model often offers the best balance between simplicity and performance. More isn’t always better.



🌱 9. Nonlinear Trends with LOESS
Description: Before jumping into GAMs, we visualize the true shape of mpg relationships using LOESS smoothing. Each numeric predictor is plotted against mpg to capture subtle curves.

🧩 Key features:

Smooth curves highlight nonlinear patterns

Visual cue for feature transformations

💡 Insight: mpg rises nonlinearly with year, drops sharply with weight. Time to call in the GAMs.



🔥 10. Generalized Additive Modeling (GAM)
Description: Using mgcv::gam(), we fit a flexible nonlinear model that lets each variable tell its own story. Spline terms (s(...)) are used to capture smooth trends.

📊 Evaluation:

Actual vs. predicted mpg plots

Performance metrics (MSE, RMSE, R², MAE) for both train and test sets

🏁 Insight: GAM delivers strong, interpretable performance. It handles curvature naturally and provides the best generalization of all tested models.


🧠 Final Takeaway:
This project shows how regression models — from linear baselines to nonlinear GAMs — can effectively decode the hidden patterns behind fuel efficiency. Combining visual exploration, feature selection, and flexible modeling makes for an insightful and powerful analysis.


