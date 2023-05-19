## Overview
1. Extract a list of 3000 or more tickers of interest in TDA
2. Partition the list and feed into TDApi where it run a loop in each ticker, create a table if not exists and store the quote in the database
3. Perform mathematical calculation on those stocks depending on the pattern (day trading), and compile the list of alerted ticker in a table
4. Scrap the news from those the list of those tickers on each site, going back X pages. Extract the ticker info from the news, catagorize the ticker with bad|good news and store in the database
5. Run separate scan for those tickers upon news and perform mathematical calculation to alert.

## Files to show
6. Show file TDA_Get_Auth_Refresh_Tokens - Obtain refresh Token and access Token
7. Show file TDApi - Get quote with a user credential. Create table for each ticker in the database containing quotes for the ticker
8. Show ipython.html file

Quote similar to the below:
{'NIO': {'assetType': 'EQUITY', 'assetMainType': 'EQUITY', 'cusip': '62914V106', 'assetSubType': 'ADR', 'symbol': 'NIO', 'description': 'NIO Inc. American depositary shares, each  representing one Class A ordinary sha', 'bidPrice': 12.95, 'bidSize': 17500, 'bidId': 'N', 'askPrice': 12.96, 'askSize': 3600, 'askId': 'T', 'lastPrice': 12.9574, 'lastSize': 100, 'lastId': 'D', 'openPrice': 13.18, 'highPrice': 13.18, 'lowPrice': 12.54, 'bidTick': ' ', 'closePrice': 13.36, 'netChange': -0.4026, 'totalVolume': 42536768, 'quoteTimeInLong': 1597421846063, 'tradeTimeInLong': 1597421844985, 'mark': 12.9574, 'exchange': 'n', 'exchangeName': 'NYSE', 'marginable': True, 'shortable': True, 'volatility': 0.0309, 'digits': 2, '52WkHigh': 16.44, '52WkLow': 1.19, 'nAV': 0.0, 'peRatio': 0.0, 'divAmount': 0.0, 'divYield': 0.0, 'divDate': '', 'securityStatus': 'Normal', 'regularMarketLastPrice': 12.9574, 'regularMarketLastSize': 1, 'regularMarketNetChange': -0.4026, 'regularMarketTradeTimeInLong': 1597421844985, 'netPercentChangeInDouble': -3.0135, 'markChangeInDouble': -0.4026, 'markPercentChangeInDouble': -3.0135, 'regularMarketPercentChangeInDouble': -3.0135, 'delayed': False}, 'HX': {'assetType': 'EQUITY', 'assetMainType': 'EQUITY', 'cusip': '428295109', 'assetSubType': 'ADR', 'symbol': 'HX', 'description': 'Hexindai Inc. - American Depositary Shares Status Alert: Deficient', 'bidPrice': 1.27, 'bidSize': 9300, 'bidId': 'P', 'askPrice': 1.28, 'askSize': 9000, 'askId': 'P', 'lastPrice': 1.275, 'lastSize': 100, 'lastId': 'D', 'openPrice': 1.42, 'highPrice': 1.6, 'lowPrice': 1.25, 'bidTick': ' ', 'closePrice': 2.48, 'netChange': -1.205, 'totalVolume': 9798915, 'quoteTimeInLong': 1597421800091, 'tradeTimeInLong': 1597421843094, 'mark': 1.275, 'exchange': 'q', 'exchangeName': 'NASD', 'marginable': False, 'shortable': False, 'volatility': 0.3065, 'digits': 4, '52WkHigh': 2.5, '52WkLow': 0.2548, 'nAV': 0.0, 'peRatio': 0.0, 'divAmount': 0.0, 'divYield': 0.0, 'divDate': '', 'securityStatus': 'Normal', 'regularMarketLastPrice': 1.275, 'regularMarketLastSize': 1, 'regularMarketNetChange': -1.205, 'regularMarketTradeTimeInLong': 1597421843094, 'netPercentChangeInDouble': -48.5887, 'markChangeInDouble': -1.205, 'markPercentChangeInDouble': -48.5887, 'regularMarketPercentChangeInDouble': -48.5887, 'delayed': False}}


1. Show NewsScanner - Scan news for each pr site out of a lot of noise. Extract the source pr, url, summary, news creation timestamp, catagorize them (bad|good), ... , store those list in the database
2.  Show example with prnewswire 
3.  Show CodeBackup/StockScanner - scan ticket in the past 30m , It will perform mathematical operation, scan news to determine if a stock is worth buying / selling
4.  Was working on automated trading but afraid of loss.