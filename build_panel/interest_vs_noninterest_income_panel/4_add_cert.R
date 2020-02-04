### add certs to panel so we can add an indicator for bank failure

library(readr)

data <- readRDS("./full_panel.rds")

certs <- read_csv("../getting_rssds_and_certs/all_rssd_and_cert.csv")

names(certs)[2] <- "rssd"

data_and_certs <- merge(data, certs, by = "rssd", all.x = TRUE)

## read in failure data------

## library(reticulate)

## source_python("./read_pickle.py")

## latest_data <- read_pickle_file("../../../1_FDIC_bank_failure_data/data/latest_data.pkl")
latest_failure_data <- read_csv("../../../1_FDIC_bank_failure_data/data/latest_data.csv")

previous_failure_data <- read_csv("../../../1_FDIC_bank_failure_data/data/previous_data.csv")

library(tibble)

previous <- tibble(previous_failure_data$CERT, previous_failure_data$FAILDATE)
names(previous) <- c("cert", "fail_date")

latest <- tibble(latest_failure_data$CERT, latest_failure_data$`Closing Date`)
names(latest) <- c("cert", "fail_date")

fail_data <- rbind(previous, latest)
fail_data <- fail_data[complete.cases(fail_data), ]

data_all <- merge(data_and_certs, fail_data, by = "cert", all.x = TRUE)

## create a failed indicator-----

data_all$fail_indicator <- ifelse(is.na(data_all$fail_date), 0 , 1)

## Time to failure

data_all$fail_date <- as.Date(data_all$fail_date, format = "%Y-%m-%d")

data_all$quarter <- as.character(data_all$quarter)
data_all$quarter <- as.Date(data_all$quarter, format = "%Y%m%d")

data_all$days_to_failure <- data_all$fail_date - data_all$quarter

saveRDS(data_all, "full_panel_with_failure_data.rds")
