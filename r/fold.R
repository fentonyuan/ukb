library("pROC")
library("grf")
library("caret")
library("stats")

set.seed(100)
file_path <- "data/train_1.csv"

data <- read.table(file_path, header = TRUE, sep = ",")
data_columns = colnames(data)

folds <- createFolds(data$id, k=10)

for(i in 1 : 10){
  data_test <- data[unlist(folds[i]), ]
  data_train <- data[-unlist(folds[i]), ]

  W = data_train$CASE
  Y = data_train$y
  X =  data_train[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "follow", "ASARisk", "ethnic", "sex", "age", "cholesterol", "HDLCcholesterol", "systolicBlood_pressure", "pressureMedication", "smoke", "diabetes", "IMD", "met", "privateHealthCare"))]
  # X =  data_train[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "follow", "ASARisk", "ascvd" , "IMD", "met", "privateHealthCare"))]

  # weight = data_train$weight
  cf <- causal_forest(X, Y, W, num.trees = 2100, seed = 100, sample.fraction = 0.1, honesty.fraction = 0.1, min.node.size = 5)
  # cf <- causal_forest(X, Y, W, num.trees = 4000, seed = 100, sample.fraction = 0.1, honesty.fraction = 0.1, min.node.size = 6, equalize.cluster.weights = TRUE)

  # print(paste(i, "th forest", "-----------------------------------------------", sep = ""))
  # print(test_calibration(cf))
  # print("***********************************************")

  X =  data_test[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "follow", "ASARisk", "ethnic", "sex", "age", "cholesterol", "HDLCcholesterol", "systolicBlood_pressure", "pressureMedication", "smoke", "diabetes", "IMD", "met", "privateHealthCare"))]
  # X =  data_test[, -which(data_columns %in% c("CASE", "y", "y_IS", "id", "x", "weight", "follow", "ASARisk", "ascvd" , "IMD", "met", "privateHealthCare"))]

  casual_forest_result <- predict(cf, X)
  data_test[, "predictions"] <- casual_forest_result
  save_path <- paste0("./data/result/result_", i, ".csv")
  write.csv(data_test, save_path, row.names = F, quote = F, fileEncoding="utf-8")
}

print("-------------------开始计算roc指标------------------")
total_auc <- 0
for(i in 1 : 10){
  file_path <- paste0("data/result/result_", i, ".csv")

  input_item_data <- read.table(file_path, sep = ",", header = TRUE)
  lm_data <- data.frame(y=input_item_data$y, x1 = input_item_data[, "predictions"], id = input_item_data$id)

  pi <- plot.roc(lm_data$y, lm_data$x1, # data
  percent=FALSE, # show all values in percent
  # partial.auc=c(100, 90),
  partial.auc.correct=TRUE, # define a partial AUC (pAUC)
  print.auc=TRUE, #display pAUC value on the plot with following options:
  # print.auc.pattern="Corrected pAUC (100-90%% SP):\n%.1f%%", print.auc.col="#1c61b6",
  auc.polygon=TRUE, auc.polygon.col="#1c61b6", # show pAUC as a polygon
  max.auc.polygon=TRUE, max.auc.polygon.col="#1c61b622", # also show the 100% polygon
  main="predictions")

  # print(paste0(total_auc ,  "--------------------", as.numeric(pi["auc"])))
  total_auc <- total_auc + as.numeric(pi["auc"])
}
print(total_auc/10)

print("-------------------开始计算线性相关系数指标------------------")
total.pearson.cor <- 0
total.spearson.cor <- 0
for(i in 1 : 10){
  file_path <- paste0("data/result/result_", i, ".csv")

  input_item_data <- read.table(file_path, sep = ",", header = TRUE)

  x_label <- "ascvd"

  lm_data <- data.frame(y=input_item_data$predictions, x = input_item_data[, x_label], id = input_item_data$id)

  xintercept <- 5
  yintercept <- 0

  first_area_points <- subset(lm_data, x >= xintercept & y>= yintercept)

  pearson.cor <- format(cor.test(first_area_points$x, first_area_points$y)$estimate, digits = 3)
  spearson.cor <- format(cor.test(first_area_points$x, first_area_points$y, method="spearman")$estimate, digits = 3)

  # print(paste0(total.pearson.cor ,  ",", total.spearson.cor, "----------------------", pearson.cor, ",", spearson.cor))
  total.pearson.cor <- total.pearson.cor + as.numeric(pearson.cor)
  total.spearson.cor <- total.spearson.cor + as.numeric(pearson.cor)
}

print(total.pearson.cor/10)
print(total.spearson.cor/10)
