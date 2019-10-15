# Get all fed_rssd and births/deaths

import os
import pandas as pd

quarters = os.listdir("./merged_data/") 

## convert to int to sort

quarters = [int(x) for x in quarters]

quarters.sort()

## create a structure to hold the fed_rssd, like R's list()

fed_rssd = {}

for i in quarters:
    fed_rssd[i] = pd.read_csv("./merged_data/" + str(i) + "/bank_data.csv")['fed_rssd']


## get births/deaths

births = {}

for i in range(1, len(quarters)):
    this_quarter = list(fed_rssd.keys())[i]
    previous_quarter = list(fed_rssd.keys())[i - 1]
    births[this_quarter] = fed_rssd[this_quarter][~fed_rssd[this_quarter].isin(fed_rssd[previous_quarter])]


deaths = {}

for i in range(0, len(quarters[1:])):
    this_quarter = list(fed_rssd.keys())[i]
    previous_quarter = list(fed_rssd.keys())[i - 1]
    deaths[this_quarter] = fed_rssd[previous_quarter][~fed_rssd[previous_quarter].isin(fed_rssd[this_quarter])]


# get number of births/deaths by quarter
num_births = {}

for i in births.keys():
    num_births[i] = len(births[i])
    
num_deaths = {}

for i in deaths.keys():
    num_deaths[i] = len(deaths[i])
    
