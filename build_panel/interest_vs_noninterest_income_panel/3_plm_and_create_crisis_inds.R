### create the final panel-------

library(plm)

data <- readRDS("./panel_denovo.rds")

panel <- pdata.frame(data, index = c("rssd", "quarter"), drop.index=FALSE, row.names=TRUE)

## create fin crisis and post crisis inds
# fin crisis
for(i in 1:dim(panel)[1]){
  if((as.numeric(as.character(panel$quarter[i])) > 20081231) & (as.numeric(as.character(panel$quarter[i])) < 20120101)){
    panel$fin_crisis_ind[i] <-  1
  } else {
    panel$fin_crisis_ind[i] <-  0
  }
}

# post crisis
for(i in 1:dim(panel)[1]){
  if((as.numeric(as.character(panel$quarter[i])) > 20111231) & (as.numeric(as.character(panel$quarter[i])) < 20160101)){
    panel$post_crisis_ind[i] <-  1
  } else {
    panel$post_crisis_ind[i] <-  0
  }
}

saveRDS(object = panel, file = "full_panel.rds")


