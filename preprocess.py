import math

import pandas as pd
import matplotlib.pyplot as plt

random_state = 100

def y_2_label(y_str):
    if y_str == "Yes":
        return 1.0
    else:
        return 0.0

def row_2_ignore(mach):
    if mach == math.nan or pd.isna(mach):
        return 1
    else:
        return 0
    pass

def calc_sample_item_weight(row, positive_weight):
    if row["y"] == 1:
        return positive_weight
    else:
        return 1

def calc_sample_weight(data):
    positive_num = data[data["y"] == 1].shape[0]
    negative_num = data[data["y"] == 0].shape[0]

    positive_weight = negative_num * 1.0 / positive_num
    data["weight"] = data.apply(lambda row : calc_sample_item_weight(row, positive_weight), axis=1)

    return data

def preprocess():

    maches_path = "./data/maches_1.csv"
    maches = pd.read_csv(maches_path)
    maches["ignore"] = maches.apply(lambda row:row_2_ignore(row["CONTROL_MATCH_1"]), axis=1)
    maches = maches[maches["ignore"] == 0]

    data_path = "./data/final_1_risk.csv"
    data = pd.read_csv(data_path)

    # data["y"] = data.apply(lambda row: y_2_label(row["y"]), axis=1)

    #存在NA的情况 不能直接合并
    ids = set(maches["CASE_ID"]).union(maches["CONTROL_MATCH_1"])

    data = data[data["OPTUM_LAB_ID"].isin(ids)]

    data = data.drop(columns = ["OPTUM_LAB_ID"])

    data = calc_sample_weight(data)

    illegal_index = data[data["ascvd"] == -1].index
    data = data.drop(index=illegal_index)

    data.to_csv("./data/train_1.csv", index=False)

def x_2_label(x_str:int):
    if x_str >= 1000:
        return 1
    else:
        return 0


if __name__ == '__main__':
    preprocess()
    #visual()