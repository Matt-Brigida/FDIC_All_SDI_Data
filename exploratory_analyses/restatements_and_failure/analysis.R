library(plm)

panel <- readRDS("../../build_panel/interest_vs_noninterest_income_panel/full_panel_with_failure_data.rds")

### all firms-----

all_firm_id_and_fail <- panel[, c("rssd", "fail_indicator")]

all_rssd_and_if_failed <- unique(all_firm_id_and_fail)

## percent of firms which have failed---------

sum(all_rssd_and_if_failed$fail_indicator) / dim(all_rssd_and_if_failed)[1]
### 0.04371156

### restaters-------

restated_and_fail_ind <- subset(panel, eqcrest != 0)

restated_firm_id_and_fail <- restated_and_fail_ind[, c("rssd", "fail_indicator")]

restated_rssd_and_if_failed <- unique(restated_firm_id_and_fail)

## percent of firms which have failed---------

sum(restated_rssd_and_if_failed$fail_indicator) / dim(restated_rssd_and_if_failed)[1]
### 0.05264807


### only negative restaters-------

neg_restated_and_fail_ind <- subset(panel, eqcrest < 0)

neg_restated_firm_id_and_fail <- neg_restated_and_fail_ind[, c("rssd", "fail_indicator")]

neg_restated_rssd_and_if_failed <- unique(neg_restated_firm_id_and_fail)

## percent of firms which have failed---------

sum(neg_restated_rssd_and_if_failed$fail_indicator) / dim(neg_restated_rssd_and_if_failed)[1]
### 0.05609327


### t-tests-----

t.test(all_rssd_and_if_failed$fail_indicator, restated_rssd_and_if_failed$fail_indicator)

## 	Welch Two Sample t-test

## data:  all_rssd_and_if_failed$fail_indicator and restated_rssd_and_if_failed$fail_indicator
## t = -2.7796, df = 10730, p-value = 0.005453
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.015238670 -0.002634347
## sample estimates:
##  mean of x  mean of y 
## 0.04371156 0.05264807 


t.test(all_rssd_and_if_failed$fail_indicator, neg_restated_rssd_and_if_failed$fail_indicator)
## 	Welch Two Sample t-test

## data:  all_rssd_and_if_failed$fail_indicator and neg_restated_rssd_and_if_failed$fail_indicator
## t = -3.2893, df = 6639.2, p-value = 0.00101
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.01976092 -0.00500249
## sample estimates:
##  mean of x  mean of y 
## 0.04371156 0.05609327 
