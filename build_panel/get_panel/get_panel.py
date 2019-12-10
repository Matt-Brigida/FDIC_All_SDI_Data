import os
import pandas as pd

quarters = os.listdir("./merged_data/") 

# convert to int to sort

quarters = [int(x) for x in quarters]

quarters.sort()

# get all rssds

rssds = pd.read_csv("./build_panel/getting_fed_rssds/all_fed_rssds.csv")

# create a dataframe to hold data

total_assets = pd.DataFrame(columns=['quarter','rssd','total_assets'])

# I can use this to get all data for the panel.  remove the row selection from data and have a tmp for each data point
for i in quarters:
        data = pd.read_csv("./merged_data/" + str(i) + "/merged_data.csv")[['fed_rssd','asset']]
        for j in rssds.rssd:
            if j in data['fed_rssd'].values:
                tmp_assets = int(data[data.fed_rssd == j]['asset'])
                total_assets.loc[-1] = [i, j, tmp_assets]  # adding a row
                total_assets.index = total_assets.index + 1  # shifting index
                total_assets = total_assets.sort_index()  # sorting by index


# the above method is too slow----probably because shifting and sorting the index is inefficient.  Rewriting in R with data.table.
