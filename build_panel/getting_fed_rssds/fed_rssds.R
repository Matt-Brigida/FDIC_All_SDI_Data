library(xts)
library(readr)

quarters <- list.dirs("../../merged_data/", full.names = FALSE, recursive = FALSE)

fed_rssds <- list()

for (q in quarters){
    tmp_data <- read_csv(paste0("../../merged_data/", q, "/bank_data.csv"))
    fed_rssds[[q]] <- tmp_data$fed_rssd
    }

### births
births <- list()

for (i in 2:length(quarters)){
    births[[quarters[i]]] <- fed_rssds[[i]][!(fed_rssds[[i]] %in% fed_rssds[[i - 1]])]
}

### deaths
deaths <- list()

for (i in 1:(length(quarters) - 1)){
    deaths[[quarters[i + 1]]] <- fed_rssds[[i]][!(fed_rssds[[i]] %in% fed_rssds[[i + 1]])]
}

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

plot.xts(plot_data)

cumulative_net_gain <- as.xts(cumsum(net_gain), order.by = quarter_date[-1])

plot.xts(cumulative_net_gain)
