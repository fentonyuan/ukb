library("CVrisk")


file_path <- "data/final_1.csv"
data <- read.table(file_path, header = TRUE, sep = ",")

data[, "ascvd"] <- 0

rows = nrow(data)
for (i in 1 : rows){
  #race
  race <- data[i, "ethnic"]

  if(race == 2){
    race <- "white"
  }else if(race == 1){
    race <- "aa"
  }else{
    race <- "other"
  }

  gender <- data[i, "sex"]
  if(gender == 1){
    gender <- "male"
  }else{
    gender <- "female"
  }

  age <- data[i, "age"]
  totchol <- data[i, "cholesterol"] * 38.66
  hdl <- data[i, "HDLCcholesterol"] * 38.66

  sbp <- data[i, "systolicBlood_pressure"]
  bp_med <- data[i, "pressureMedication"]
  smoker <- data[i, "smoke"]
  diabetes <- data[i, "diabetes"]

  risk <- ascvd_10y_accaha(race = race, gender = gender, age = age, totchol = totchol, hdl=hdl, sbp = sbp, bp_med = bp_med, smoker = smoker, diabetes = diabetes)

  data[i, "ascvd"] <- risk
}

write.csv(data, "data/final_1_risk.csv", row.names = F, quote = F, fileEncoding="utf-8")

