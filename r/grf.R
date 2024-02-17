library(grf)

file_path <- "data/train_1.csv"

data <- read.table(file_path, header = TRUE, sep = ",")

data_columns = colnames(data)

W = data$CASE
Y = data$y
# X =  data[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "ASARisk"))]
X =  data[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "follow", "ASARisk", "ethnic", "sex", "age", "cholesterol", "HDLCcholesterol", "systolicBlood_pressure", "pressureMedication", "smoke", "diabetes", "ascvd"))]
weight = data$weight

cf <- causal_forest(X, Y, W, num.trees = 2100, seed = 100, sample.fraction = 0.1, honesty.fraction = 0.1, min.node.size = 6, mtry = 10, equalize.cluster.weights = TRUE)

#casual-forest vs risk
casual_forest_result <- predict(cf, X)
data[, "predictions"] <- casual_forest_result
write.csv(data, "data/train_1_risk.csv", row.names = F, quote = F, fileEncoding="utf-8")

var_importance <- variable_importance(cf)
ranked.vars <- order(var_importance, decreasing = TRUE)
colnames(X)[ranked.vars[1:10]]

#hist(Y)
#best_linear_projection(cf, X[ranked.vars[1:5]])