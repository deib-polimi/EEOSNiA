import scipy.io
import json 
import numpy as np
import csv



mat = scipy.io.loadmat('./Data/data2.mat')

NUM_APPS = 140

data = mat["data"]

output = {"apps" : []}

apps = output["apps"]

with open('datetimes.csv', newline='') as csvfile:
    csvreader = csv.reader(csvfile)
    header = next(csvreader)  # Skip the header row
    for i in range(140):
        print(i)
        app = {}
        app["id"] = i+1
        app["name"] = data[i][1][0]
        app["url"] = data[i][5][0].split(".git")[0]
        app["begin_date"] = data[i][2][0]
        app["end_date"] = data[i][3][0]
        commits = []
        app["commits"] = commits
        commit_data = data[i][9][0]
        size = np.shape(data[i][9][0])
        commit_dates = next(csvreader)[1:]
        for j in range(size[0]):    
            commit = {}
            commit["index"] = j+1
            commit["date"] = commit_dates[j]
            commit["tag"] = commit_data["tag"][j][0]
            commit["url"] = app["url"] + "/commit/" + commit["tag"]
            try:
                obj = commit_data["languagePercentagesCloc"][j]["Objective_C"][0][0]["code"][0][0][0][0]
            except:
                obj = 0     
            try:
                swift = commit_data["languagePercentagesCloc"][j]["Swift"][0][0]["code"][0][0][0][0]
            except:
               swift = 0    
            try:
                all = obj/1000 + swift/1000
                if not all:
                    all = 1
                commit["obj%"] = f"{obj/1000/all*100:.3f}%"
                commit["swift%"] = f"{swift/1000/all*100:.3f}%"
            except:
                pass
                
            commits.append(commit)
        apps.append(app)

with open("dataset-v1.json", 'w') as f:
    json.dump(output, f, indent=4)  

