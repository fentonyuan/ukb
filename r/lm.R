library("stats")
library("ggplot2")

input_data <- read.table("data/result/result_7.csv", sep = ",", header = TRUE)

x_label <- "ASARisk"

lm_data <- data.frame(y=input_data$predictions, x = input_data[, x_label], id = input_data$id)

xintercept <- 5
yintercept <- 0

first_area_points <- subset(lm_data, x >= xintercept & y>= yintercept)
left_points <- lm_data[-which(lm_data$id %in% first_area_points$id), ]

pearson.cor <- format(cor.test(first_area_points$x, first_area_points$y)$estimate, digits = 3)
pearson.p <- format(cor.test(first_area_points$x, first_area_points$y)$p.value, digits = 3)

spearson.cor <- format(cor.test(first_area_points$x, first_area_points$y, method="spearman")$estimate, digits = 3)
spearson.p <- format(cor.test(first_area_points$x, first_area_points$y, method="spearman")$p.value, digits = 3)

spearson.text = paste("ρ=", spearson.cor, ",", "p-value = ", spearson.p)
pearson.text = paste("r=", pearson.cor, ",", "p-value = ", pearson.p)

ggplot(lm_data, aes(x=x, y= y)) +
geom_point(alpha = 0.25, data = first_area_points, colour = "red") +
geom_smooth(method = "lm", se=FALSE, data = first_area_points) +
geom_point(alpha = 0.25, data = left_points, colour = "black") +
  xlab(x_label) + ylab("predictions") +
  xlim(0, 50) +
  geom_vline(xintercept = xintercept, linetype="dashed", colour = "#FF1111") +
  geom_hline(yintercept = yintercept, linetype="dashed", colour = "#FF1111") +
  annotate(geom = "text", x= 40, y= 0.025, label=spearson.text, size= 5) +
  annotate(geom = "text", x= 40, y= 0.02, label=pearson.text, size= 5)
