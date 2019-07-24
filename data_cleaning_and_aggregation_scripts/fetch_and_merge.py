#!/usr/bin/python

### Fetch data from FDIC and merge all files------

import pandas as pd
import os
import sys
import urllib.request
import glob
import zipfile

quarter = sys.argv[1]

## remove all files from ./raw_data/ and download quarter into folder, extract zip, and remove readme file and zip folder-------

### remove all files in ./raw_data/
files_to_delete = glob.glob("./raw_data/*")
for ff in files_to_delete:
    os.remove(ff)


### download zip for quarter
urllib.request.urlretrieve("https://www5.fdic.gov/sdi/Resource/AllReps/All_Reports_"+ quarter +".zip", "./raw_data/" + quarter + "data.zip")

### unzip
with zipfile.ZipFile("./raw_data/" + quarter + "data.zip","r") as zip_ref:
    zip_ref.extractall("./raw_data")

### remove zip file and readme
os.remove("./raw_data/" + quarter + "data.zip")
os.remove("./raw_data/All_Reports_" + quarter + "_readme.htm")

### make new merged data file---
os.mkdir("./merged_data/"+ quarter +"/")

## Plan: get list of IDRSSDs from one file and then use loop to merge in the rest of the files.

PD_NA = pd.read_csv("./raw_data/All_Reports_"+ quarter +"_- PD & NA Loans Wholly or Partially US Gvmt Guaranteed.csv")

## drop column we dont want

columns_to_drop = ['inst.webaddr', 'cbsa_metro', 'mutual', 'cert', 'docket', 'rssdhcr','name', 'city', 'stalp', 'zip', 'repdte','rundate','bkclass','address','namehcr', 'county','cbsa_metro_name','estymd', 'offdom', 'offfor', 'stmult', 'specgrp', 'subchaps', 'insdate', 'effdate', 'parcert', 'trust', 'regagnt', 'insagnt1', 'fdicdbs', 'fdicsupv', 'fldoff', 'fed', 'occdist', 'otsregnm', 'offoa', 'cb']

columns_to_drop_plus_fed_rssd = ['fed_rssd', 'inst.webaddr', 'cbsa_metro', 'mutual', 'cert', 'docket', 'rssdhcr','name', 'city', 'stalp', 'zip', 'repdte','rundate','bkclass','address','namehcr', 'county','cbsa_metro_name','estymd', 'offdom', 'offfor', 'stmult', 'specgrp', 'subchaps', 'insdate', 'effdate', 'parcert', 'trust', 'regagnt', 'insagnt1', 'fdicdbs', 'fdicsupv', 'fldoff', 'fed', 'occdist', 'otsregnm', 'offoa', 'cb']

### need to fix the below to put the fed_rssd in the bank data table
bank_data = pd.DataFrame(PD_NA[columns_to_drop_plus_fed_rssd])

data = pd.DataFrame(PD_NA['fed_rssd'])

## game plan:  take all repetitive data and put into one file.  then on read for each table remove all the repetitive data except fed_rssd and merge

### read new data and merge--------

## list files in directory (will also list subdirs but there are none).
ff = os.listdir("./raw_data/")

for i in ff:
    temp = pd.read_csv("./raw_data/" + i)
    temp = temp.drop(columns_to_drop, axis=1, errors='ignore')
    cols_to_merge = temp.columns.difference(data.columns)
    cols_to_merge = cols_to_merge.insert(0, 'fed_rssd')
    data = pd.merge(data, temp[cols_to_merge], on='fed_rssd')

data.to_csv("./merged_data/"+ quarter +"/merged_data.csv")

bank_data.to_csv("./merged_data/"+ quarter +"/bank_data.csv")
