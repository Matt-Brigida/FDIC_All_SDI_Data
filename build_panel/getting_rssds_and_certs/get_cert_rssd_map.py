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
    fed_rssd_and_cert[i] = pd.DataFrame(pd.read_csv("./merged_data/" + str(i) + "/bank_data.csv")[['cert', 'fed_rssd']])

    
df = pd.DataFrame()
for i in quarters:
    df_new = fed_rssd_and_cert.get(i)
    df = df.append(df_new, ignore_index=True)

all_rssd_and_cert = df.drop_duplicates()

pd.DataFrame.to_csv(all_rssd_and_cert, "./build_panel/getting_rssds_and_certs/all_rssd_and_cert.csv", index=False)
