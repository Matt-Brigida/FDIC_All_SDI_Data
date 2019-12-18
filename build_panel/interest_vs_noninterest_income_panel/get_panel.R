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
## "Interest income: Foreign office loans","ILNFOR","Total interest and fee income on loans held in foreign offices, edge and agreement subsidiaries and IBF's.    "
## "Interest expense: Foreign office deposits","EDEPFOR","Total interest expense on deposits held in foreign offices, Edge and agreement subsidiaries and IBFs."

## total deposits
## "Total deposits","dep","The sum of all deposits including demand deposits, money market deposits, other savings deposits, time deposits and deposits in foreign offices."


## residential mortgage loans
## "1-4 family residential loans","lnreres","Total loans secured by 1-4 family residential properties (including revolving and open-end loans) held in domestic offices.<br>Note:Prior to 2004 the savings institutions that file a thrift financial report did not report the 1-4 family loans by the sub category first liens and second liens. The data is not available prior to this year.  Commercial banks began reporting that data in 1991"
## "Loans secured by 1-4 family first liens","LNRERSFM","Closed-end loans secured by first liens on 1-4 family residential properties and held in domestic offices.<br><br>Note:Prior to 2004 the savings institutions that file a thrift financial report did not report the 1-4 family loans by the sub category first liens and second liens. The data is not available prior to this year.  Commercial banks began reporting that data in 1991."
## "Loans secured by 1-4 family junior liens","LNRERSF2","Closed-end loans secured by junior liens on 1-4 family residential properties and held in domestic offices.<br><br>Note: Prior to 2004 the savings institutions that file a thrift financial report did not report the 1-4 family loans by the sub category first liens and second liens. The data is not available prior to this year.  Commercial banks began reporting that data in 1991."
## "Home equity loans","lnreloc","Open-end loans secured by 1-4 family residential properties extended as lines of credit in domestic offices (included in total 1-4 mortgage loans)."
## "Adjustable rate loans secured by 1-4 family residential (memoranda)","LNRERSF1","All other adjustable rate closed-end loans secured by 1-4family residential properties, secured by first liens, andheld in domestic offices Listed as memoranda only and is included in real estate 1-4 family-first liens. <br><p>This item is not available for <a href='definitions.asp?SystemForm=ID&HelpItem=tfrrpt'>TFR Reporters</a>."



## vector of variables-------
variables <- c("asset",# {{{
               "eq",
               "intinc",
               "eintexp",
               "nonii",
               "idothnii",
               "nonix",
               "epremagg",
	       "IDEOTH",
	       "idpretx",
	       "iglsec",
	       "itax",
	       "ibefxtr",
	       "extra",
	       "netinc",
	       "eqcdiv",
	       "ILNFOR",
	       "EDEPFOR",
               "dep",
               "lnreres",
               "LNRERSFM",
               "LNRERSF2",
               "lnreloc",
               "LNRERSF1"
               )# }}}



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
