library("survival")
library("survminer")
library("rms")
file_path <- "./data/train_1.csv"

data <- read.table(file_path, header = TRUE, sep = ",")
data <- na.omit(data)

#设定数据环境
dd<-datadist(data)
options(datadist='dd')

res.cox <- cph(formula = Surv(data$follow, data$y) ~ rcs(x, 3), x=TRUE, y=TRUE, data = data, weights = data$weights)

Pre0 <-rms::Predict(res.cox,x,fun=exp,type="predictions",ref.zero=TRUE,conf.int = 0.95,digits=2)
ggplot(Pre0)
