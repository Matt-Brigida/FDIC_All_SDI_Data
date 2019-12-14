library(data.table)

## get quarters
quarters <- list.dirs("../../merged_data/", full.names = FALSE)[-1]

## get rssds
rssds <- data.table::fread("../getting_fed_rssds/all_fed_rssds.csv")

## construct panel
panel <- data.table()


## Variabels for panel:
## asset: Total Assets
## eq, "Total bank equity capital (includes preferred and common stock, surplus and undivided profits)."
## "Total interest income","intinc","Sum of income on loans and leases, plus investment income, interest on interest bearing bank balances, interest on federal funds sold and interest on trading account assets earned by the institution."
## "Total interest expense","eintexp","Total interest expense"
## "Total noninterest income","nonii","Income from fiduciary activities, plus service charges on deposit accounts in domestic offices, plus trading gains (losses) and fees from foreign exchange transactions, plus other foreign transaction gains (losses), plus other gains (losses) and fees from trading assets and liabilities."
## "Additional Noninterest Income","idothnii","Includes the following noninterest income: investment banking, advisory, brokerage, and underwriting;Venture capital revenue;Net Servicing fees;Net securitization income;Insurance commission fees and income;Net gains (losses) on sales of loans;Net gains (losses) on sales of real estate owned;Net gains (losses) on sales of other assets (excluding securities);and Other noninterest income. RIS definition = IDOTHNII = NONII - SUM(IFIDUC, ISERCHG, IGLTRAD)"
## "Total noninterest expense","nonix","Salaries and employee benefits, expenses of premises and fixed assets (net of rental income), and other noninterest expenses."
## "Premises and equipment expense","epremagg","Expenses of bank premises and fixed assets, net of rental income. Excludes salaries and employee benefits and mortgage interest."
## "Additional noninterest expense","IDEOTH","This includes all other operating expenses of the institution. These may consist of net (gains) or losses on OREO, loans sales, fixed assets sales, amortization of intangible assets, or other itemized expenses. Beginning in June 1996, this does not include losses on asset sales for TFR reporters. Such gains (losses) are included net in noninterest income.<BR><BR>RIS definition: <BR>YR - IDEOTH = EOTHNINT + EAMINTAN (>2000) or IDEOTH=EOTHNINT<BR>QTR - IDOTHNIQ = NONIIQ - SUM(IFIDUCQ, ISERCHGQ, IGLTRDQ)"
## "Pre-tax net operating income","idpretx","Net income (loss) before income taxes and extraordinary items and other adjustments minus gains (losses) on securities not held in trading accounts.<BR><BR>RIS definition:<BR>YR - IDPRETX = SUM(IBEFTAX, -IGLSEC)<BR>QTR - IDPRETXQ = SUM(IBEFTXQ, -IGLSECQ)"
## "Securities gains (losses)","iglsec","Realized gains (losses) on held-to-maturity and available-for-sale securities, before adjustments for income taxes. Thrift Financial Reporters also include gains (losses) on the sale of other assets held for sale."
## "Applicable income taxes","itax","Applicable federal, state and local, and foreign income taxes."
## "Income before extraordinary items","ibefxtr","Income (loss) before security transactions, extraordinary items and other adjustments.  "
## "Extraordinary gains, net","extra","Extraordinary items and other adjustments, net of income taxes."
## "Net income","netinc","Net interest income plus total noninterest income plus realized gains (losses) on securities and extraordinary items, less total noninterest expense, loan loss provisions and income taxes."
## "Cash dividends","eqcdiv","Cash dividends paid on common and preferred stock."










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
