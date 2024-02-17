library("survival")
library("survminer")

file_path <- "./data/train_1.csv"

data <- read.table(file_path, header = TRUE, sep = ",")

data <- na.omit(data)

res.cox <- coxph(formula = Surv(data$follow, data$y) ~ age +sex+ethnic+privateHealthCare + bmi + smoke + alcohol + diabetes + cholesterolMedication + pressureMedication + diastolicBloodPressure  + systolicBlood_pressure + hba1c + HDLCcholesterol + LDLDirect + triglycerides + eGFR + ascvd, x=TRUE, y=TRUE, data = data, weights = data$weights)

# temp <- cox.zph(res.cox)
#
# result <- res.cox[[17]]
# data[, "cox"] <- result[, 1]
#
# write.csv(data, "data/final_1_risk_1.csv", row.names = F, quote = F, fileEncoding="utf-8")

fit <- survfit(res.cox)
ggsurvplot(fit, data = data)


