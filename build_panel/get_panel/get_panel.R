library(data.table)

## get quarters
quarters <- list.dirs("../../merged_data/", full.names = FALSE)[-1]

## get rssds
rssds <- data.table::fread("../getting_fed_rssds/all_fed_rssds.csv")

## construct panel
panel <- data.table()

for (i in quarters){
    tmp_data <- fread(paste0("../../merged_data/", i, "/merged_data.csv"))
    for (j in rssds$rssd){
        if (j %in% tmp_data$fed_rssd){
            tmp_assets <- tmp_data[tmp_data$fed_rssd == j, ]$asset
            panel <- rbind(panel, list(i, j, tmp_assets), use.names=FALSE)
        }
    }
}

names(panel) <- c("quarter", "rssd", "total_assets")

saveRDS(panel, "./panel_just_assets.rds")
