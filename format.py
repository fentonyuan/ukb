
import pandas as pd
import math
import numpy as np

def str_2_index(name:str):
    if len(name) == 1:
        return ord(name[0]) - ord('A') + 1
    else:
        return 26 * (ord(name[0]) - ord('A') + 1) + ord(name[-1]) - ord('A') + 1

def sex_2_label(sex:str):
    if sex == 'Male':
        return 1
    elif sex == "Female":
        return 2
    elif math.isnan(sex):
        return 0
    else:
        assert(False)
        return 0


def ethnic_2_label(ethnic: str):
    if isinstance(ethnic, str):
        ethnic = ethnic.lower()

    if ethnic == "african":
        return 1
    elif ethnic == "white":
        return 2
    elif ethnic == "asian":
        return 3
    elif ethnic == "other ethnic group":
        return 4
    elif ethnic == "mix":
        return 5
    else:
        print(ethnic)
        assert (False)
        return 0


# 抽烟情况
def smoke_2_label(value):
    if value == "Current":
        return 2
    elif value == "Previous":
        return 1
    elif value == "Never":
        return 0
    elif value == "Prefer not to answer":
        return 0
    elif np.isnan(value):
        return 0

    assert (False)
    return 0

#盐分摄入
def salt_2_label(value):
    if value == "Always":
        return 4
    elif  value == "Usually":
        return 3
    elif value == "Do not know" or value == "No" or value == "Prefer not to answer":
        return 0
    elif value == "Sometimes":
        return 2
    elif value == "Never/rarely":
        return 1
    elif math.isnan(value):
        return 0
    assert(False)
    return 0


# 酒精摄入
def alohol_2_label(value):
    if value == "Current":
        return 2
    elif value == "Previous":
        return 1
    elif value == "Never":
        return 0
    elif value == "Prefer not to answer":
        return 0
    elif np.isnan(value):
        return 0

    assert (False)
    return 0

def private_healthcare_2_label(value:str):
    if value == "No, never":
        return 0
    elif value == "Yes, sometimes":
        return 1
    elif value == "Yes, most of the time":
        return 2
    elif value == "Yes, all of the time":
        return 3
    else:
        assert(False)
        return 0

def binary_2_label(value:str):
    if value == "Yes":
        return 1
    elif value == "No":
        return 0
    else:
        assert(False)
        return 0

def met_2_label(value:str):
    if value == "low":
        return 0
    elif value == "moderate":
        return 1
    elif value == "high":
        return 2
    else:
        assert(False)
        return 0
def tokenize(data):
    data["Sex"] = data.apply(lambda row: sex_2_label(row["Sex"]), axis=1)
    data["Ethnic background | Instance 0"] = data.apply(lambda row:ethnic_2_label(row["Ethnic background | Instance 0"]), axis=1)
    data["Private healthcare | Instance 2"] = data.apply(lambda row: private_healthcare_2_label(row["Private healthcare | Instance 2"]), axis=1)
    data["MET_IPAQ activity group"] = data.apply(lambda row: met_2_label(row["MET_IPAQ activity group"]), axis=1)
    data["Smoking status | Instance 3"] = data.apply(lambda row: smoke_2_label(row["Smoking status | Instance 3"]), axis=1)
    data["Salt added to food | Instance 3"] = data.apply(lambda row: salt_2_label(row["Salt added to food | Instance 3"]), axis=1)
    data["Alcohol drinker status | Instance 3"] = data.apply(lambda row: alohol_2_label(row["Alcohol drinker status | Instance 3"]), axis=1)
    #data["Cardiovascular illnesses of parents"] = data.apply(lambda row: binary_2_label(row["Cardiovascular illnesses of parents"]), axis=1)
    data["Stroke diagnosed by doctor"] = data.apply(lambda row: binary_2_label(row["Stroke diagnosed by doctor"]), axis=1)
    data["Heart attack diagnosed by doctor"] = data.apply(lambda row: binary_2_label(row["Heart attack diagnosed by doctor"]), axis=1)
    data["High blood pressure diagnosed by doctor"] = data.apply(lambda row: binary_2_label(row["High blood pressure diagnosed by doctor"]), axis=1)
    # data["Diabetes diagnosed by doctor | Instance 3"] = data.apply(lambda row: binary_2_label(row["Diabetes diagnosed by doctor | Instance 3"]), axis=1)
    data["Medication for cholesterol"] = data.apply(lambda row: binary_2_label(row["Medication for cholesterol"]), axis=1)
    data["Medication for blood pressure"] = data.apply(lambda row: binary_2_label(row["Medication for blood pressure"]), axis=1)
    data["Medication fordiabetes"] = data.apply(lambda row: binary_2_label(row["Medication fordiabetes"]), axis=1)

    # data["Outcome_Stroke"] = data.apply(lambda row:binary_2_label(row["Outcome_Stroke"]), axis=1)
    delete_index = data[data["Outcome_IS"] == "Deleted"].index
    data = data.drop(index=delete_index)
    data["Outcome_IS"] = data.apply(lambda row:binary_2_label(row["Outcome_IS"]), axis=1)
    return data


def psm_format(data):
    data["CASE"] = data.apply(lambda row : 1 if row["x"] >= 1000 else 0, axis = 1)
    data["OPTUM_LAB_ID"] = data.index

    data = data[data["x"] >= 500][data["x"] <= 1500]
    return data

def format(data):
    result = pd.DataFrame({
        "id" : data["Participant ID"],
        "x" : data["Maximum carotid IMT (intima-medial thickness)"],
        "y" : data["Outcome_IS"],
        # "y_IS" :data["Outcome_IS"],
        "age" : data["Age at recruitment"],
        "sex" : data["Sex"],
        "ethnic" : data["Ethnic background | Instance 0"],
        "privateHealthCare" : data["Private healthcare | Instance 2"],
        "IMD" : data["Index of Multiple Deprivation (England)"],
        "bmi" : data["Body mass index (BMI)"],
        # "water": data["Water intake"],
        "met" : data["MET_IPAQ activity group"],
        # "sleep" : data["Sleep duration"],
        "smoke" : data["Smoking status | Instance 3"],
        # "salt" : data["Salt added to food | Instance 3"],
        "alcohol" : data["Alcohol drinker status | Instance 3"],
        # "cardiovascular" : data["Cardiovascular illnesses of parents"],
        # "strokeDiagnosed" : data["Stroke diagnosed by doctor"],
        # "heartAttack" : data["Heart attack diagnosed by doctor"],
        # "highBlood" : data["High blood pressure diagnosed by doctor"],
        "diabetes" : data["Diabetes diag0sed by doctor"],
        "cholesterolMedication" : data["Medication for cholesterol"],
        "pressureMedication" : data["Medication for blood pressure"],
        "fordiabetesMedication" : data["Medication fordiabetes"],
        "diastolicBloodPressure" : data["Diastolic blood pressure"],
        "systolicBlood_pressure" : data["Systolic blood pressure"],
        # "apolipoproteinB" : data["Apolipoprotein B"],
        # "apolipoproteinA" : data["Apolipoprotein A"],
        "cholesterol" : data["Cholesterol"],
        "hba1c" : data["Glycated haemoglobin (HbA1c)"],
        "HDLCcholesterol" : data["HDL cholesterol"],
        "LDLDirect" : data["LDL direct"],
        "triglycerides" : data["Triglycerides"],
        "eGFR" : data["eGFR"],
        "ASARisk" : data["ASA stroke risk"],
        "follow": data["Follow-up years"]
    })

    result = psm_format(result)
    return result

if __name__ == "__main__":
    data = pd.read_csv("./data/1_data_participant_TotalStroke_final.csv")
    data = tokenize(data)
    data = format(data)

    output_path = "./data/final_1.csv"
    data.to_csv(output_path, index=False)
