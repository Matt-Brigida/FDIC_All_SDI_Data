### Fetch data from FDIC and merge all files------

import pandas as pd 

PD_NA = pd.read_csv("./raw_data/All_Reports_20190331_- PD & NA Loans Wholly or Partially US Gvmt Guaranteed.csv")

## game plan:  take all repetitive data and put into one file.  then on read for each table remove all the repetitive data except fed_rssd and merge

## drop column we dont want
PD_NA1 = PD_NA.drop(['cert', 'docket', 'rssdhcr','name', 'city', 'stalp', 'zip', 'repdte','rundate','bkclass','address','namehcr'], axis=1)

PD_NA1