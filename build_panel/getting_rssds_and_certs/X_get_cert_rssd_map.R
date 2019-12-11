library(xts)
library(readr)

quarters <- list.dirs("../../merged_data/", full.names = FALSE, recursive = FALSE)

fed_rssds_certs <- list()

for (q in quarters){
    tmp_data <- read_csv(paste0("../../merged_data/", q, "/bank_data.csv"))
    fed_rssds_certs[[q]] <- data.frame(cbind(tmp_data$cert, tmp_data$fed_rssd))
}

## not working-----
## Get all fed_rssds that have ever existed--------
all_fed_rssds_certs <- data.frame()

for(i in names(fed_rssds_certs)){rbind(fed_rssds_certs[i])}

unique(lapply(fed_rssds_certs, cbind))

saveRDS(all_fed_rssds_certs, "all_fed_rssds.rds")
