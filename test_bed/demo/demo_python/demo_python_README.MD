## Overview
1. Extract a list of 3000 or more tickers of interest in TDA
2. Partition the list and feed into TDApi where it run a loop in each ticker, create a table if not exists and store the quote in the database
3. Perform mathematical calculation on those stocks depending on the pattern (day trading), and compile the list of alerted ticker in a table
4. Scrap the news from those the list of those tickers on each site, going back X pages. Extract the ticker info from the news, catagorize the ticker with bad|good news and store in the database
5. Run separate scan for those tickers upon news and perform mathematical calculation to alert.

6. Show file TDA_Get_Auth_Refresh_Tokens - Obtain refresh Token and access Token
7. Show file TDApi - Get quote with a user credential. Create table for each ticker in the database containing quotes for the ticker
8. Show NewsScanner - Scan news for each pr site out of a lot of noise. Extract the source pr, url, summary, news creation timestamp, catagorize them (bad|good), ... , store those list in the database
10. Show example with prnewswire 
10. Show CodeBackup/StockScanner - scan ticket in the past 30m , It will perform mathematical operation, scan news to determine if a stock is worth buying / selling
11. Was working on automated trading but afraid of loss.