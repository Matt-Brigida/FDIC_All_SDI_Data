library(xts)
library(readr)

quarters <- list.dirs("../../merged_data/", full.names = FALSE, recursive = FALSE)

fed_rssds <- list()

for (q in quarters){
    tmp_data <- read_csv(paste0("../../merged_data/", q, "/bank_data.csv"))
    fed_rssds[[q]] <- tmp_data$fed_rssd
}

## Get all fed_rssds that have ever existed--------
all_fed_rssds <- unique(unlist(fed_rssds))

saveRDS(all_fed_rssds, "all_fed_rssds.rds")

## column name in dataframe MUST be rssd, TODO fix------
write_csv(data.frame(all_fed_rssds), "all_fed_rssds.csv")


length(all_fed_rssds)
#  16568

### births
births <- list()

for (i in 2:length(quarters)){
    births[[quarters[i]]] <- fed_rssds[[i]][!(fed_rssds[[i]] %in% fed_rssds[[i - 1]])]
}

saveRDS(births, "births.rds")

### deaths
deaths <- list()

for (i in 1:(length(quarters) - 1)){
    deaths[[quarters[i + 1]]] <- fed_rssds[[i]][!(fed_rssds[[i]] %in% fed_rssds[[i + 1]])]
}

saveRDS(deaths, "deaths.rds")

## Alternative method to get all fed_rssds, get all in first quarter and add all births-------
alt_all_fed_rssds <- unique(c(read_csv("../../merged_data/19921231/bank_data.csv")$fed_rssd, unlist(births)))

length(alt_all_fed_rssds)
# 16568
# matches

## Vizualizations

### number births

num_births <- unlist(lapply(births, length))

### number deaths

num_deaths <- unlist(lapply(deaths, length))

### birth - death

net_gain <- num_births - num_deaths

### Plot

quarter_date <- as.Date(quarters, "%Y%m%d")

plot_data <- as.xts(cbind(num_births, num_deaths, net_gain), order.by = quarter_date[-1])
plot_data <- plot_data[index(plot_data) != "2012-03-31", ]

names(plot_data) <- c("Births", "Deaths", "Net_Gain")

plot(plot_data, main="Births, Deaths, and Total Change", col=c(3,2,4), auto.legend=TRUE)
legend("bottomleft", legend = c("Births", "Deaths", "Total Change"), col=c(3,2,4), lty=1, cex=.65)

autoplot.zoo(plot_data)

## births/death plot---make better
pdf("births_deaths.pdf")
plot(plot_data, main="Births (green), Deaths (red), and Total Change (blue)", col=c(3,2,4), auto.legend=TRUE, citation="by Matt Brigida")
dev.off()



cumulative_net_gain <- as.xts(cumsum(net_gain), order.by = quarter_date[-1])

pdf("cum_change_in_num_banks.pdf")
plot.xts(cumulative_net_gain, main="Change in the Number of US Banks")
dev.off()

## num banks first quarter
first_quarter <- read_csv("../../merged_data/19921231/bank_data.csv")
first_quarter_num_banks <- length(first_quarter$fed_rssd)
## 13973

## num banks last quarter
last_quarter <- read_csv("../../merged_data/20201231/bank_data.csv")
last_quarter_num_banks <- length(last_quarter$fed_rssd)
## 5125

last_quarter_num_banks/first_quarter_num_banks - 1
## -0.6332212

pdf("total_num_banks.pdf")
plot.xts(first_quarter_num_banks + cumulative_net_gain, main="Total Number of US Banks")
dev.off()
