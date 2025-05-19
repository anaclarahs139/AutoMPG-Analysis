library(car)
library(corrplot)
library(dplyr)
library(writexl)
library(GGally)
library(leaps)
library(mgcv)
library(ggplot2)
library(gridExtra)
library(mgcv)

# === 1.Импортирайте данните, като укажете изрично, че липсващите стойности са означени с “?”.
file_path = "C:/Users/Sergey Filipov/Desktop/Проект ML/Данни и скрипт/Auto.csv"
df= read.csv(file_path, na.strings="?")


# === 2. Технически анализ на данните

# === 2.1 Проверка на класовете на колоните
sapply(df, class)  # Показва класа на всяка променлива

# Проверка за липсващи стойности по колони
colSums(is.na(df))

# === 2.2 Корекции на класовете на променливите, ако са необходими
# horsepower трябва да е числова променлива
if (class(df$horsepower) != "numeric") {df$horsepower = as.numeric(df$horsepower)}

# cylinders трябва да е фактор (според документацията, но зависи от анализа)
if (class(df$cylinders) != "factor") {df$cylinders = as.factor(df$cylinders)}

# weight и displacement трябва да са числови
if (class(df$weight) != "numeric") {df$weight = as.numeric(df$weight)}

if (class(df$displacement) != "numeric") {df$displacement = as.numeric(df$displacement)}

# origin трябва да е фактор (според документацията)
if (class(df$origin) != "factor") {df$origin = as.factor(df$origin)}

# year трябва да е числово
if (class(df$year) != "numeric") {df$year = as.numeric(df$year)}

# === 2.3. Проверка за коректност на преобразуванията
sapply(df, class)

# Създаване на помощна таблица с всички редове, които имат липсващи стойности
missing_data_df = df[!complete.cases(df), ]

# Преглед на помощната таблица
head(missing_data_df)
# write_xlsx(missing_data_df, "C:/Users/Sergey Filipov/Desktop/missing_data_df.xlsx")

# Запълване на липсващите стойности със средната стойност за сходни коли
df <- df %>%
  group_by(cylinders, origin) %>%
  mutate(horsepower = ifelse(is.na(horsepower), mean(horsepower, na.rm = TRUE), horsepower))

# Проверка дали всички липсващи стойности са попълнени
sum(is.na(df$horsepower))  # Трябва да е 0
boxplot(df$horsepower, main = "Horsepower Distribution After Imputation", col = "red")

summary(df$horsepower)

# Откриване на нетипичните стойности за horsepower
outliers_hp <- boxplot.stats(df$horsepower)$out
cat("Открити нетипични стойности за мощността на двигателя:", outliers_hp, "\n")
colSums(is.na(df))

# === Бокс-диаграма за характеристиката mpg и описателни статистики
boxplot(df$mpg, main = "Boxplot на разхода на гориво (mpg)", ylab = "Miles per gallon", col = "lightblue")

# Пресмятане на описателните статистики за mpg
summary_mpg <- summary(df$mpg)
print(summary_mpg)

# === Проверка за нетипични стойности (outliers)
# Нетипичните стойности са извън границите на бокс-диаграмата
outliers <- boxplot.stats(df$mpg)$out
cat("Открити нетипични стойности на разхода на гориво:", outliers, "\n")

set.seed(123)  # Фиксиране на произволния генератор за възпроизводимост
sample_index <- sample(1:nrow(df), size = 0.75 * nrow(df))  # Вземаме 75% от данните за оценка

train_set <- df[sample_index, ]  # Множество за оценка (training)
test_set <- df[-sample_index, ]  # Множество за валидиране (testing)

# Проверка на размерите
cat("Размер на множество за оценка:", nrow(train_set), "\n")
cat("Размер на множество за валидиране:", nrow(test_set), "\n")

# Създаване на бокс-диаграма
levels(df$origin) <- c("Америка", "Европа", "Япония")
boxplot(df$mpg ~ df$origin, 
        col = "blue", 
        xlab = "Origin", 
        ylab = "mpg", 
        main = "Boxplot на разхода на гориво по произход на автомобилите")

# === Изчисляване на корелационната матрица
df_temp <- df
df_temp$cylinders <- as.numeric(df_temp$cylinders)
correlation_matrix <- cor(df_temp[, sapply(df_temp, is.numeric)], use = "complete.obs")

# Визуализация на корелационната матрица
corrplot(correlation_matrix, method = "color", type = "upper", tl.col = "black", 
         tl.srt = 45, col = colorRampPalette(c("red", "white", "blue"))(200),
         addCoef.col = "black",  # Показване на числата в матрицата
         number.cex = 0.7)       # Размер на числата


# Задаване на цветове в зависимост от година на производство
color_palette <- colorRampPalette(c("blue", "green", "orange", "red"))(length(unique(df$year)))

# Функция за горната част на диагонала с цветове
upper_panel_color <- function(x, y, ...) {
  points(x, y, col = color_palette[df$year - min(df$year) + 1], pch = 16, ...)
  panel.smooth(x, y, col.smooth = "black", ...)
}

# Изпълнение на функцията pairs с горна част на диагонала и включена `cylinders`
pairs(df[, c("mpg", "weight", "displacement", "horsepower", "year", "cylinders")], 
      upper.panel = upper_panel_color,  # Показваме само горната част с цветове
      lower.panel = NULL,  # Скриваме долната част на диагонала
      main = "Цветна оптимизирана диаграма: само горната част на диагонала")


# ==== Регресионен анализ ====

# Построяване на модела с основните значими променливи върху множеството за оценка (train_set)
regression_model <- lm(mpg ~ weight + displacement + horsepower + year + cylinders, data = train_set)

# Прогноза върху тестовото множество с доверителен интервал от 95%
predicted_mpg_test_with_ci <- predict(regression_model, newdata = test_set, interval = "prediction", level = 0.95)

# Визуализация на действителни vs. прогнозни стойности върху тестовото множество
plot(test_set$mpg, predicted_mpg_test_with_ci[, "fit"], main = "Действителни vs. Прогнозни стойности на mpg (Тестово множество)", 
     xlab = "Действителни стойности на mpg", ylab = "Прогнозни стойности на mpg", col = "blue", pch = 16)
abline(0, 1, col = "red")  # Линия на перфектна прогноза


# Създаване на data frame за графиката
prediction_df <- data.frame(Actual = test_set$mpg,  Predicted = predicted_mpg_test_with_ci[, "fit"],
  Lower_CI = predicted_mpg_test_with_ci[, "lwr"],
  Upper_CI = predicted_mpg_test_with_ci[, "upr"])

# Визуализация с ggplot2
ggplot(prediction_df, aes(x = Actual, y = Predicted)) +
  geom_point(color = "blue", size = 2) +  # Точки за действителни vs прогнозни стойности
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +  # Линия на перфектна прогноза
  geom_ribbon(aes(ymin = Lower_CI, ymax = Upper_CI), fill = "lightgray", alpha = 0.5) +  # Ленти за доверителния интервал
  labs(title = "Действителни vs Прогнозни стойности с доверителен интервал (95%)",
    x = "Действителни стойности на mpg", y = "Прогнозни стойности на mpg") +  theme_minimal()

# Построяване на модела с основните значими променливи върху обучаващото множество (train_set)
regression_model <- lm(mpg ~ weight + displacement + horsepower + year + cylinders, data = train_set)

# Резюме на модела върху обучаващото множество
summary(regression_model)

# Функции за изчисляване на метриките
calculate_metrics <- function(actual, predicted) {
  mse <- mean((actual - predicted)^2)
  rmse <- sqrt(mse)
  mae <- mean(abs(actual - predicted))
  rss <- sum((actual - predicted)^2)  # Residual Sum of Squares
  tss <- sum((actual - mean(actual))^2)  # Total Sum of Squares
  r_squared <- 1 - (rss / tss)
  return(list(MSE = mse, RMSE = rmse, MAE = mae, R2 = r_squared))
}

# Прогнози върху обучаващото множество
predicted_mpg_train <- predict(regression_model, newdata = train_set)

# Действителни стойности за обучаващото множество
actual_mpg_train <- train_set$mpg

# Изчисляване на метриките за обучаващото множество
train_metrics <- calculate_metrics(actual_mpg_train, predicted_mpg_train)

# Извеждане на резултатите за обучаващото множество
cat("Метрики за обучаващото множество (train_set):\n")
cat("Средна квадратична грешка (MSE):", train_metrics$MSE, "\n")
cat("R-квадрат (R²):", train_metrics$R2, "\n")
cat("Корен от средна квадратична грешка (RMSE):", train_metrics$RMSE, "\n")
cat("Средна абсолютна грешка (MAE):", train_metrics$MAE, "\n\n")

# Прогнози върху тестовото множество
predicted_mpg_test <- predict(regression_model, newdata = test_set)

# Действителни стойности за тестовото множество
actual_mpg_test <- test_set$mpg

# Изчисляване на метриките за тестовото множество
test_metrics <- calculate_metrics(actual_mpg_test, predicted_mpg_test)

# Извеждане на резултатите за тестовото множество
cat("Метрики за тестовото множество (test_set):\n")
cat("Средна квадратична грешка (MSE):", test_metrics$MSE, "\n")
cat("R-квадрат (R²):", test_metrics$R2, "\n")
cat("Корен от средна квадратична грешка (RMSE):", test_metrics$RMSE, "\n")
cat("Средна абсолютна грешка (MAE):", test_metrics$MAE, "\n")



# === Оптимизация на регресионния анализ === 

# Полиномиални и интеракционни термини
regression_model_improved <- lm(mpg ~ poly(weight, 2) + poly(displacement, 2) +
                                  horsepower * year + cylinders + weight * cylinders, data = train_set)

# Резюме на подобрения модел
summary(regression_model_improved)

# Прогнози върху обучаващото множество
predicted_mpg_train_improved <- predict(regression_model_improved, newdata = train_set)

# Изчисляване на метриките за обучаващото множество с подобрения модел
train_metrics_improved <- calculate_metrics(actual_mpg_train, predicted_mpg_train_improved)

cat("Метрики за подобрения модел върху обучаващото множество (train_set):\n")
cat("Средна квадратична грешка (MSE):", train_metrics_improved$MSE, "\n")
cat("R-квадрат (R²):", train_metrics_improved$R2, "\n")
cat("Корен от средна квадратична грешка (RMSE):", train_metrics_improved$RMSE, "\n")
cat("Средна абсолютна грешка (MAE):", train_metrics_improved$MAE, "\n\n")

# Прогнози върху тестовото множество
predicted_mpg_test_improved <- predict(regression_model_improved, newdata = test_set)

# Изчисляване на метриките за тестовото множество с подобрения модел
test_metrics_improved <- calculate_metrics(actual_mpg_test, predicted_mpg_test_improved)

cat("Метрики за подобрения модел върху тестовото множество (test_set):\n")
cat("Средна квадратична грешка (MSE):", test_metrics_improved$MSE, "\n")
cat("R-квадрат (R²):", test_metrics_improved$R2, "\n")
cat("Корен от средна квадратична грешка (RMSE):", test_metrics_improved$RMSE, "\n")
cat("Средна абсолютна грешка (MAE):", test_metrics_improved$MAE, "\n")


# Изпълнение на автоматичния подбор на променливи с регресия по подмножества
if (!require(leaps)) install.packages("leaps")
best_subset <- regsubsets(mpg ~ weight + displacement + horsepower + cylinders + acceleration + year + origin, 
                          data = train_set, nbest = 1)  # nbest = 1 връща най-добрия модел за всяка размерност
# Обобщение на резултатите
summary_best_subset <- summary(best_subset)

# Показване на метриките за всеки модел
print(summary_best_subset)

# Визуализация на резултатите: Брой променливи срещу стойността на Adjusted R-squared
plot(summary_best_subset$adjr2, type = "b", pch = 19, col = "red", 
     xlab = "Брой на предсказващите променливи", ylab = "Adjusted R-squared",
     main = "Избор на оптимален брой променливи")


# ==== НЕЛИНЕЙНИ ЗАВИСИМОСТИИИИИ =====
# Зареждане на необходимите пакети
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(gridExtra)) install.packages("gridExtra")

# Списък с числовите променливи (без mpg)
numeric_vars <- names(df)[sapply(df, is.numeric) & names(df) != "mpg"]


plot_list <- list() # Създаване на списък с графики

# Цикъл за създаване на графики и добавянето им в списък
for (var in numeric_vars) {
  p <- ggplot(df, aes(x = .data[[var]], y = mpg)) +
    geom_point(color = "blue", alpha = 0.6) +
    geom_smooth(method = "loess", color = "green", se = TRUE) +  # Нелинеен модел с изглаждане
    labs(title = paste("Нелинейна връзка между mpg и", var),
         x = var, y = "mpg") +
    theme_minimal()
  
  # Добавяне на графиката в списъка
  plot_list[[length(plot_list) + 1]] <- p
}

# Изобразяване на всички графики в една обща подредба
do.call(grid.arrange, c(plot_list, ncol = 2))


# Създаване на обобщен адитивен модел (GAM)
gam_model <- gam(mpg ~ s(weight) + s(displacement) + s(horsepower) + s(year) + cylinders, data = train_set)


# Преглед на резюмето на модела
summary(gam_model)
# Обобщен адитивен модел. Прогноза върху тестовото множество
predicted_gam <- predict(gam_model, newdata = test_set)

# Визуализация на действителни vs. прогнозни стойности на mpg
plot(test_set$mpg, predicted_gam, 
     main = "Действителни vs. Прогнозни стойности на mpg (GAM модел)", 
     xlab = "Действителни стойности на mpg", 
     ylab = "Прогнозни стойности на mpg", 
     col = "darkblue", pch = 16)
abline(0, 1, col = "red")  # Линия на перфектна прогноза



# Прогнозиране върху тестовото множество
predicted_test_gam <- predict(gam_model, newdata = test_set)

# Прогнозиране върху обучаващото множество
predicted_train_gam <- predict(gam_model, newdata = train_set)

# Функция за изчисляване на MSE
mse <- function(actual, predicted) {
  mean((actual - predicted)^2)
}

# Функция за изчисляване на R^2
r_squared <- function(actual, predicted) {
  1 - sum((actual - predicted)^2) / sum((actual - mean(actual))^2)
}

# Функция за изчисляване на RMSE
rmse <- function(actual, predicted) {
  sqrt(mse(actual, predicted))
}

# Функция за изчисляване на MAE
mae <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

# Изчисляване на метриките за GAM модела върху тестовото множество
mse_test_gam <- mse(test_set$mpg, predicted_test_gam)
r2_test_gam <- r_squared(test_set$mpg, predicted_test_gam)
rmse_test_gam <- rmse(test_set$mpg, predicted_test_gam)
mae_test_gam <- mae(test_set$mpg, predicted_test_gam)

# Изчисляване на метриките за GAM модела върху обучаващото множество
mse_train_gam <- mse(train_set$mpg, predicted_train_gam)
r2_train_gam <- r_squared(train_set$mpg, predicted_train_gam)
rmse_train_gam <- rmse(train_set$mpg, predicted_train_gam)
mae_train_gam <- mae(train_set$mpg, predicted_train_gam)

# Показване на резултатите
cat("Модел\t\tМножество\tMSE\t\tR^2\t\tRMSE\t\tMAE\n")
cat("GAM модел\tТестово\t\t", round(mse_test_gam, 4), "\t", round(r2_test_gam, 4), "\t", round(rmse_test_gam, 4), "\t", round(mae_test_gam, 4), "\n")
cat("GAM модел\tОбучаващо\t", round(mse_train_gam, 4), "\t", round(r2_train_gam, 4), "\t", round(rmse_train_gam, 4), "\t", round(mae_train_gam, 4), "\n")

