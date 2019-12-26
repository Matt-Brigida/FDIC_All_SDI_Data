### Create the de novo indicator -------

library(data.table)

### read in panel and births -------

panel <- readRDS("./panel.rds")

panel$theindex_panel <- paste0(panel$quarter, "_", panel$rssd)

births <- readRDS("../getting_fed_rssds/births.rds")

### Create indicators -------

born <- 0

for(i in 1:length(names(births))){
    for(j in 1:length(births[i][[1]])){
     born <- c(born, paste0(names(births)[i], "_", births[i][[1]][j]))
    }
}

### need to change date in born from mmddyyyy to yyyymmdd -------

date1 <- gsub("_.*$", "", born)
idrssds1 <- gsub("^.*_", "", born)
mm <- substr(date1, start = 1, stop = 2)
dd <- substr(date1, start = 3, stop = 4)
yyyy <- substr(date1, start = 5, stop = 8)
date2 <- paste0(yyyy, mm, dd)

born2 <- paste0(date2, "_", idrssds1)

## born vector contains some trash but this won't match any index values so fine ------

born_vector <- 0

the_index_character <- as.character(panel$theindex_panel)

for(i in 1:length(the_index_character)){
                born_vector[i] <- ifelse(the_index_character[i] %in% born, 1, 0)
               }

### now we need to create the de novo indicator, mark the first 4 years (16 quarters)

### De novo

panel$born_vector <- born_vector

## now sort the data first on IDRSSD and then on quarter

panel <- panel[with(panel, order(rssd, quarter)), ]

counter <- 0
de_novo <- 0

for(i in 2:length(panel$born_vector)){
    if(panel$born_vector[i] == 1){
        de_novo[i] <- 1
    } else {
        if((de_novo[i - 1] == 1) & (panel$rssd[i] == panel$rssd[i - 1]) & (counter < 17)){
            de_novo[i] <- 1
            counter <- counter + 1
        } else {
            de_novo[i] <- 0
            counter <- 0
        }
    }
}

panel$de_novo <- de_novo

saveRDS(panel, file = "panel_denovo.rds")
