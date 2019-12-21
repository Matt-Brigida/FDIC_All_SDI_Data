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

## derivatives
## "Derivatives","obsdir","Represents the sum of the following: interest-rate contracts (as defined as the notional value of interest-rate swap, futures, forward and option contracts), foreign-exchange-rate contracts, commodity contracts and equity contracts (defined similarly to interest-rate contracts).  Futures and forward contracts are contracts in which the buyer agrees to purchase and the seller agrees to sell, at a specified future date, a specific quantity of underlying at a specified price or yield. These contracts exist for a variety of underlyings, including traditional agricultural or physical commodities, as well as currencies and interest rates. Futures contracts are standardized and are traded on organized exchanges which set limits on counterparty credit exposure. Forward contracts do not have standardized terms and are traded over the counter.  Option contracts are contracts in which the buyer acquires the right to buy from or sell to another party some specified amount of underlying at a stated price (strike price) during a period or on a specified future date, in return for compensation (such as a fee or premium). The seller is obligated to purchase or sell the underlying at the discretion of the buyer of the contract. Swaps are obligations between two parties to exchange a series of cash flows at periodic intervals (settlement dates) for a specified period. The cash flows of a swap are either fixed or determined for each settlement date by multiplying the quantity of the underlying instrument (notional principal) by specified reference rates or prices. Except for currency swaps, the notional principal is used to calculate each payment but is not exchanged.  This item is not available for TFR Reporters."

## "Performance and Condition Ratios" contains lots of variables, many of which are scaled
## cost of funds and yield on assets-----
## "Yield on earning assets","intincy","Total interest income (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=ernast5'> average earning assets</a>."
## "Cost of funding earning assets","intexpy","Annualized total interest expense on deposits and other borrowed money as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=ernast5'> average earning assets</a> on a consolidated basis."
## "Net interest margin","nimy","Total interest income less total interest expense (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=ernast5'> average earning assets</a>."
## "Noninterest income to average assets","noniiay","Income derived from bank services and sources other than interest bearing assets (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=asset5'> average total assets</a>."
## "Noninterest expense to average assets","nonixay","Salaries and employee benefits, expenses of premises and fixed assets, and other noninterest expenses (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=asset5'> average total assets</a>."
## "Loan and lease loss provision to assets","ELNATRY","The annualized provision for loans and lease losses as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=asset5'> average total assets</a> on a consolidated basis."
## "Net operating income to assets","noijy","Net operating income (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=asset5'> average total assets</a>."
## "Return on assets (ROA)","roa","Net income after taxes and extraordinary items (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=asset5'> average total assets</a>."
## "Pretax return on assets","roaptx","Annualized pre-tax net income as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=asset5'> average total assets</a>.<P>Note: Includes extraordinary items and other adjustments, net of taxes."
## "Return on Equity (ROE)","roe","Annualized net income as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=eq5'> average total equity</a> on a consolidated basis.     Note: If retained earnings are  negative, the ratio is shown as NA."
## "Net charge-offs to loans","ntlnlsr","Gross loan and lease financing receivable charge-offs, less gross recoveries, (annualized) as a percent of <a href='definitions.asp?SystemForm=ID&HelpItem=lnlsgr5'> average total loans and lease financing receivables</a>."
## "Credit loss provision to net charge-offs","elnantr","Provision for possible credit and allocated transfer risk as a percent of net charge-offs. If the denominator is less than or equal to zero, then ratio is shown as 'NA.'"
## "Earnings coverage of net charge-offs (x)","iderncvr","Income before income taxes and extraordinary items and other adjustments, plus provisions for loan and lease losses and allocated transfer risk reserve, plus gains (losses) on securities not held in trading accounts (annualized) divided by net loan and lease charge-offs (annualized). This is a number of times ratio (x) not a percentage ratio (%). * if the denominator is less than or equal to zero, then ratio is shown as 'n/a. ris definition = iderncvr = chfla / ntlnlsa "
## "Efficiency ratio","eeffr","Noninterest expense less amortization of intangible assets as a percent of net interest income plus noninterest income. This ratio measures the proportion of net operating revenues that are absorbed by overhead expenses, so that a lower value indicates greater efficiency."
## "Assets per employee ($millions)","astempm","Total assets in millions of dollars as a percent of the number of full-time equivalent employees."
## "Earning assets to total assets ratio","ERNASTR","Interest earning assets as a percent of total assets."
## "Loss allowance to loans","lnatresr","Allowance for loan and lease losses as a percent of total loan and lease financing receivables, excluding unearned income."
## "Loan loss allowance to noncurrent loans","lnresncr","Allowance for loan and lease losses as a percent of noncurrent loans and leases."
## "Noncurrent assets plus other real estate owned to assets","nperfv","Noncurrent assets as a percent of total assets.     Noncurrent assets are defined as assets that are past due 90 days or more plus assets placed in nonaccrual status plus other real estate owned (excluding direct and indirect investments in real estate)."
## "Noncurrent loans to loans","nclnlsr","Total noncurrent loans and leases, Loans and leases 90 days or more past due plus loans in nonaccrual status,  as a percent of gross loans and leases."
## "Net loans and leases to total assets","LNLSNTV","Loan and lease financing receivables, net of unearnedincome, allowances, and reserves, as a percent of totalassets."
## "Net loans and leases to deposits","lnlsdepr","Loans and lease financing receivables net of unearned income, allowances and reserves as a percent of total deposits."
## "Net loans and leases to core deposits","idlncorr","Loan and lease financing receivables, net of allowances and reserves, as a percent of core deposits. The core deposit definition was changed in March 2011. core deposits held in domestic offices now includes: total domestic office deposits minus time deposits of more than $250,000 held in domestic offices and brokered deposits of $250,000 or less held in domestic offices. Prior to the March 2010, core deposits were calculated as total domestic office deposits minus time deposits of $100,000 or more held in domestic offices. RIS definition: IDLNCORR = (LNLSNET / COREDEP) *100 "
## "Total domestic deposits to total assets","DEPDASTR","Total domestic office deposits as a percent of total assets."
## "Equity capital to assets","eqv","Total equity capital as a percent of total assets."

### Capital Ratios-----
## "Core capital (leverage) ratio","rbc1aaj","Tier 1 (core) capital as a percent of average total assets minus ineligible intangibles. <BR><P>Tier 1 (core) capital includes: common equity plus noncumulative perpetual preferred stock plus minority interests in consolidated subsidiaries less goodwill and other ineligible intangible assets. The amount of eligible intangibles (including mortgage servicing rights) included in core capital is limited in accordance with supervisory capital regulations. Average total assets used in this computation are an average of daily or weekly figures for the quarter.<br><br> As of March 2015, all institutions began reporting the amended CALL schedule RC-R Part I and Part II which incorporates risk-based capital rules based on the Basel III framework and section 939A of the Dodd-Frank Act.  Some designated institutions began reporting based on the updated requirements as of March 2014. (See: FDIC Financial Institutions Letter FIL-24-2012)"
## "Tier 1 risk-based capital ratio","rbc1rwaj","Tier 1 (core) capital as a percent of risk-weighted assets as defined by the appropriate <a href='HelpItemForm.asp?SystemForm=ID&HelpItem=regagnt'>federal regulator</a> for prompt corrective action during that time period.<br><br> As of March 2015, all institutions began reporting the amended CALL schedule RC-R Part I and Part II which incorporates risk-based capital rules based on the Basel III framework and section 939A of the Dodd-Frank Act.  Some designated institutions began reporting based on the updated requirements as of March 2014. (See: FDIC Financial Institutions Letter FIL-24-2012)"
## "Total risk-based capital ratio","rbcrwaj","Total risk based capital as a percent of risk-weighted assets as defined by the appropriate <a href='HelpItemForm.asp?SystemForm=ID&HelpItem=regagnt'>federal regulator</a> for prompt corrective action during that time period.<br><br> As of March 2015, all institutions began reporting the amended CALL schedule RC-R Part I and Part II which incorporates risk-based capital rules based on the Basel III framework and section 939A of the Dodd-Frank Act.  Some designated institutions began reporting based on the updated requirements as of March 2014. (See: FDIC Financial Institutions Letter FIL-24-2012)"
## "Common equity tier 1 capital ratio","RBCT1CER","The ratio of common equity tier 1 capital to risk-weighted assets. common equity tier 1 capital includes common stock instruments and related surplus, retained earnings, accumulated other comprehensive income (AOCI), and limited amounts of common equity tier 1 minority interest, minus applicable regulatory adjustments and deductions. Items that are fully deducted from common equity tier 1 capital include goodwill, other intangible assets (excluding mortgage servicing assets) and certain deferred tax assets;items that are subject to limits in common equity tier 1 capital include mortgage servicing assets, eligible deferred tax assets, and certain significant investments. As of March 2015, all institutions began reporting the amended CALL schedule RC-R Part I and Part II which incorporates risk-based capital rules based on the Basel III framework and section 939A of the Dodd-Frank Act. Some designated institutions began reporting based on the updated requirements as of March 2014. (See: FDIC Financial Institutions Letter FIL-24-2012) Available beginning March 2014."

## not included-----
## "19.","Cash dividends to net income (ytd only)*","iddivnir","Total of all cash dividends declared (year-to-date, annualized) as a percent of net income (year-to-date, annualized). * this ratio is not available on a quarterly basis. if the denominator is less than or equal to zero, then ratio is shown as 'N/A.' RIS definition = IDDIVNIR = (EQCDIVA / NETINCA) *100"
##"34.","Average total assets","asset5","Year-to-date average of the total assets represented on the balance sheet. Used as the denominator for year-to-date income as a percent of average assets. The number of quarterly values used in the calculation depends on the date of the data. year-to-date averages: march reporting period - (december assets + march assets) / 2 june reporting period - (december assets + march assets + june assets) / 3 September reporting period - (December assets + March assets + June assets + September assets) / 4 December reporting period - (Previous December assets + March assets + June assets + September assets + December assets) / 5 Quarterly averages: All reporting periods  (Previous quarter assets + current quarter assets) / 2 "
##"35.","Average earning assets","ernast5","The average of all loans and other investments that earn interest or dividends. Averages are calculated as follows: Year-to-date averages: March reporting period - (December earning assets + March earning assets) / 2 June reporting period - (December earning assets + March earning assets + June earning assets) / 3 September reporting period - (December earning assets + March earning assets + June earning assets + September earning assets) / 4 December reporting period - (Previous December earning assets + March earning assets + June earning assets + September earning assets + December earning assets) / 5 Quarterly averages: All reporting periods  (Previous quarter earning assets + current quarter earning assets) / 2 "
##"36.","Average equity","eq5","The average of total equity capital (includes preferred and common stock, surplus and undivided profits). Averages are calculated as follows: Year-to-date averages: March reporting period - (December equity + March equity) / 2 June reporting period - (December equity + March equity + June equity) / 3 September reporting period - (December equity + March equity + June equity + September equity) / 4 December reporting period - (Previous December equity + March equity + June equity + September equity + December equity) / 5 Quarterly averages: All reporting periods  (Previous quarter equity + current quarter equity) / 2 "
##"37.","Average total loans","LNLSGR5","The average of total loans and lease financing receivables, net of unearned income. Averages are calculated as follows: Year-to-date averages: March reporting period - (December total loans + March total loans) / 2 June reporting period - (December total loans + March total loans + June total loans) / 3 September reporting period - (December total loans + March total loans + June total loans + September total loans) / 4 December reporting period - (Previous December total loans + March total loans + June total loans + September total loans + December total loans) / 5 Quarterly averages: All reporting periods  (Previous quarter total loans + current quarter total loans) / 2 "




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
               "LNRERSF1",
               "obsdir",
               "intincy",
               "intexpy",
               "nimy",
               "noniiay",
               "nonixay",
               "ELNATRY",
               "noijy",
               "roa",
               "roaptx",
               "roe",
               "ntlnlsr",
               "elnantr",
               "iderncvr",
               "eeffr",
               "astempm",
               "ERNASTR",
               "lnatresr",
               "lnresncr",
               "nperfv",
               "nclnlsr",
               "LNLSNTV",
               "lnlsdepr",
               "idlncorr",
               "DEPDASTR",
               "eqv",
               "rbc1aaj",
               "rbc1rwaj",
               "rbcrwaj",
               "RBCT1CER"
               )# }}}



for (i in quarters){
    tmp_data <- fread(paste0("../../merged_data/", i, "/merged_data.csv"))
    for (j in rssds$rssd){
        if (j %in% tmp_data$fed_rssd){
            ## tmp_asset <- tmp_data[tmp_data$fed_rssd == j, ]$asset
            tmp_vector <- c()
            for (w in 1:length(variables)){
                ## assign(paste0("tmp", w), eval(parse(text = paste0("tmp_data[tmp_data$fed_rssd == j, ]$", variables[w]))))
                tmp_vector <- c(tmp_vector, eval(parse(text = paste0("tmp_data[tmp_data$fed_rssd == j, ]$", variables[w]))))
                ## eval(parse(text = paste0("tmp", w))))
                }
            panel <- rbind(panel, list(i, j, tmp_vector), use.names=FALSE)
        }
    }
}

names(panel) <- c("quarter", "rssd", "total_assets")

saveRDS(panel, "./panel_just_assets.rds")
