### Fetch data from FDIC and merge all files------

import pandas as pd
import os

## Plan: get list of IDRSSDs from one file and then use loop to merge in the rest of the files.

PD_NA = pd.read_csv("./raw_data/All_Reports_20190331_- PD & NA Loans Wholly or Partially US Gvmt Guaranteed.csv")

data = pd.DataFrame(PD_NA['fed_rssd'])

# FRNLL = pd.read_csv("./raw_data/All_Reports_20190331_1-4 Family Residential Net Loans and Leases.csv")

## game plan:  take all repetitive data and put into one file.  then on read for each table remove all the repetitive data except fed_rssd and merge

## drop column we dont want

columns_to_drop = ['cbsa_metro', 'mutual', 'cert', 'docket', 'rssdhcr','name', 'city', 'stalp', 'zip', 'repdte','rundate','bkclass','address','namehcr', 'county','cbsa_metro_name','estymd', 'offdom', 'offfor', 'stmult', 'specgrp', 'subchaps', 'insdate', 'effdate', 'parcert', 'trust', 'regagnt', 'insagnt1', 'fdicdbs', 'fdicsupv', 'fldoff', 'fed', 'occdist', 'otsregnm', 'offoa', 'cb']

# PD_NA = PD_NA.drop(columns_to_drop, axis=1)
# FRNLL = FRNLL.drop(columns_to_drop, axis=1)

# data = pd.merge(PD_NA, FRNLL, on='fed_rssd')

### read new data and merge--------

## list files in directory (will also list subdirs but there are none).
ff = os.listdir("./raw_data/")

for i in ff:
    temp = pd.read_csv("./raw_data/" + i)
    temp = temp.drop(columns_to_drop, axis=1)
    data = pd.merge(data, temp, on='fed_rssd')

data.to_csv("./merged_data/merged_data_20190331.csv")
