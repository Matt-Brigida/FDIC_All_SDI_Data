## accouting income restatement: eqcrest
## see if there are enough restatements to motivate an analysis

library(data.table)

data <- fread("../../merged_data/20190930/merged_data.csv")

plot(density(data$eqcrest, na.rm = TRUE))

summary(data$eqcrest)

## % of banks with restatements

dim(subset(data, eqcrest != 0))[1] / dim(subset(data, eqcrest == 0))[1] 

## looks like enough
