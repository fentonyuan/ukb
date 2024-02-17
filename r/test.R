# library(grf)
# library(ggplot2)
#
# file_path <- "data/train_1.csv"
#
# data <- read.table(file_path, header = TRUE, sep = ",")
#
# data_columns = colnames(data)
#
# W = data$CASE
# Y = data$y
# # X =  data[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "ASARisk"))]
# X =  data[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "follow", "ASARisk", "ethnic", "sex", "age", "cholesterol", "HDLCcholesterol", "systolicBlood_pressure", "pressureMedication", "smoke", "diabetes", "ascvd"))]
# weight = data$weight
#
# cf <- causal_forest(X, Y, W, num.trees = 2100, seed = 100, sample.fraction = 0.1, honesty.fraction = 0.1, min.node.size = 6, mtry = 10, equalize.cluster.weights = TRUE)
#
# print(average_treatment_effect(cf, target.sample = "all"))