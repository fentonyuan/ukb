library(pROC)
library(patchwork)

input_data <- read.table("data/result/result_7.csv", sep = ",", header = TRUE)
lm_data <- data.frame(y=input_data$y, x1 = input_data[, "ascvd"], x2= input_data[, "predictions"], id = input_data$id)

p1 <- plot.roc(lm_data$y, lm_data$x1, # data
percent=FALSE, # show all values in percent
# partial.auc=c(100, 90),
partial.auc.correct=TRUE, # define a partial AUC (pAUC)
print.auc=TRUE, #display pAUC value on the plot with following options:
# print.auc.pattern="Corrected pAUC (100-90%% SP):\n%.1f%%", print.auc.col="#1c61b6",
auc.polygon=TRUE, auc.polygon.col="#1c61b6", # show pAUC as a polygon
max.auc.polygon=TRUE, max.auc.polygon.col="#1c61b622", # also show the 100% polygon
main="ascvd")

p2 <- plot.roc(lm_data$y, lm_data$x2, # data
percent=FALSE, # show all values in percent
# partial.auc=c(100, 90),
partial.auc.correct=TRUE, # define a partial AUC (pAUC)
print.auc=TRUE, #display pAUC value on the plot with following options:
# print.auc.pattern="Corrected pAUC (100-90%% SP):\n%.1f%%", print.auc.col="#1c61b6",
auc.polygon=TRUE, auc.polygon.col="#1c61b6", # show pAUC as a polygon
max.auc.polygon=TRUE, max.auc.polygon.col="#1c61b622", # also show the 100% polygon
main="predictions")

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

  print(paste0(total_auc ,  "--------------------", as.numeric(pi["auc"])))
  total_auc <- total_auc + as.numeric(pi["auc"])
}
print(total_auc/10)