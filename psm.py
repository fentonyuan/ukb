# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 15:17:10 2023

@author: ws
"""

import os
import pandas as pd
import MyPsMatch as MyPsMatch

file_path = "./data/final_1.csv"


def generate_formular():
    data = pd.read_csv(file_path)

    columns = list(data.columns)
    columns.remove("CASE")
    columns.remove("x")
    columns.remove("y")
    columns.remove("id")
    columns.remove("ASARisk")
    columns.remove("follow")
    columns.remove("OPTUM_LAB_ID")

    formular = "CASE ~ "
    for item in columns:
        formular = formular + item + " + "
    print(formular)
    return

def execute_psm():
    data = pd.read_csv(file_path)

    # formula = "CASE ~ age + sex + ethnic + privateHealthCare + IMD + bmi + met + smoke + alcohol + cholesterolMedication + pressureMedication + fordiabetesMedication + diastolicBloodPressure + systolicBlood_pressure + cholesterol + hba1c + HDLCcholesterol + LDLDirect + triglycerides + eGFR + diabetes"
    formula = "CASE ~ privateHealthCare + IMD + bmi + met + alcohol + cholesterolMedication + fordiabetesMedication + diastolicBloodPressure + hba1c + LDLDirect + triglycerides + eGFR"
    k = 1

    m = MyPsMatch.MyPsMatch(file_path, formula, k)
    m.prepare_data()

    print(data[data["CASE"] == 1].shape)
    print(data[data["CASE"] == 0].shape)
    m.match(caliper=0.1, replace=False)

    m.evaluate()

    data = m.matched_data
    data.to_csv(os.path.join("./data", "mache_data_1.csv"), index=False)

    maches = pd.DataFrame(m.matches)
    maches.to_csv(os.path.join("./data", "maches_1.csv"), index=False)
    return

if __name__ == "__main__":
    execute_psm()
