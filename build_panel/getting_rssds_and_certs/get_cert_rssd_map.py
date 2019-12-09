# Get all fed_rssd and births/deaths

import os
import pandas as pd

quarters = os.listdir("./merged_data/") 

# convert to int to sort

quarters = [int(x) for x in quarters]

quarters.sort()

# create a structure to hold the fed_rssd, like R's list()

fed_rssd = {}

for i in quarters:
    fed_rssd[i] = pd.read_csv("./merged_data/" + str(i) + "/bank_data.csv")['fed_rssd']

# get rdds and cert map----not working

fed_rssd_and_cert = {} # is a dict

for i in quarters:
    fed_rssd_and_cert[i] = pd.read_csv("./merged_data/" + str(i) + "/bank_data.csv")[['cert', 'fed_rssd']]

all_rssd_and_cert = []

for i in quarters:
    all_rssd_and_cert.append(pd.DataFrame.from_dict(fed_rssd_and_cert.get(i)))


pd.DataFrame.to_csv(all_rssd_and_cert, "./all_rssd_and_cert.csv")
