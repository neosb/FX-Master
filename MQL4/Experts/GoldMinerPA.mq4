//+------------------------------------------------------------------+
//|                                                    GoldMiner.mq4 |
//|                                       Copyright 2012, AlFa Corp. |
//|                                 mailto:alessio.fabiani@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, AlFa"
#property link      "mailto:alessio.fabiani@gmail.com"
//#property strict

#define EA_NAME "GoldMiner"
#define VER "1.1"

//+------------------------------------------------------------------+
#import "kernel32.dll"
int		GetTimeZoneInformation(int& TZInfoArray[]);
#import
//+------------------------------------------------------------------+

#define  SH_BUY   10
#define  SH_SELL  20

//extern string S = "########## SETTINGS ##########";

extern int Magic                             = 7691;

//extern string P = "#### Pairs ###";

//extern string PP = "# (comma \',\' separated) #";
extern string note1                          = "example: AUDUSD,EURAUD,EURCAD,EURCHF,EURGBP,EURUSD,GBPCHF,GBPUSD,NZDUSD,USDCAD,USDCHF";
extern string note2                          = "leave blank for auto-scan";
extern string PairsToBuy                     = "";
extern string PairsToSell                    = "";
extern string PairsToBuyOrSell               = "EURUSD";
extern string PairsToHedge                   = "";
//extern string D = "### Delay ###";
//extern string DS = "# (seconds) #";
extern bool EachTickMode                     = FALSE;
extern int OpenNewTradesDelay                = 3;
extern int SamePairDelayMinutes              = 0;
extern bool AllowMultiplePurchaseOfPair		= TRUE;

//extern string A = "### Action ###";
extern bool _BuyRandomPair                   = FALSE;
extern bool _SellRandomPair                  = FALSE;
extern bool _BuyOrSellPair                   = TRUE;

extern bool _BestSwapRandomPair              = FALSE;
extern bool _WorstSwapRandomPair             = FALSE;

extern bool _BuyPairNarrowSprd               = FALSE;
extern bool _SellPairNarrowSprd              = FALSE;
extern bool _BuyOrSellPairNarrowSprd         = FALSE;
extern bool _BestSwapPairNarrowSprd          = FALSE;
extern bool _WorstSwapPairNarrowSprd         = FALSE;

extern bool _BuyPairWideSprd                 = FALSE;
extern bool _SellPairWideSprd                = FALSE;
extern bool _BuyOrSellPairWideSprd           = FALSE;
extern bool _BestSwapPairWideSprd            = FALSE;
extern bool _WorstSwapPairWideSprd           = FALSE;

//extern string V = "### Volume ###";
extern double Lots                           = 0.03;
extern int Slippage                          = 2;
extern bool AutomaticLotSize                 = TRUE; //money management
extern bool AdjustLotSizeForPrice            = FALSE;
extern bool AdjustLotSizeForPipValue         = TRUE;
extern double VirtualBalance                 = 5000;

//extern string VV = "# (%) #";
extern double Risk                           = 20; //risk in percentage
extern double MaxSpread                      = 3.0;

//extern string PL = "### Profit / Loss ###";
//extern string TS = "# (PIPs) #";
extern double TakeProfitLevel                = 1200;
extern double StopLossLevel                  = 300;
extern double TakeProfitOverride             = 1250;
extern double StopLossOverride               = 320;
extern double TrailingStop                   = 20;
extern double TrailingStopOverride           = 22;
extern double TrailingStopAt                 = 60;
extern double TrailingStopOverrideAt         = 60;

//extern string L = "### Trading Limitations ###";
extern int MaximumNumberTrades               = 80;
//extern string E = "# (%) #";
extern double MinimumBalance                 = 200;
extern double MinimumEquity                  = 50;
extern double MinimumFreeMargin              = 10;
extern double MinimumMarginLevel             = 25;

extern int CloseAfterNumberOfHours           = 9;
extern bool HedgeLoss                        = TRUE;

//extern string T = "### Times ###";
//extern string DD = "# Days (M=1;T=2;W=3;T=4;F=5) #";
extern string MondayStart                    = "02:00";
extern string MondayStop                     = "24:00";
extern string TuesdayStart                   = "00:00";
extern string TuesdayStop                    = "24:00";
extern string WednesdayStart                 = "00:00";
extern string WednesdayStop                  = "24:00";
extern string ThursdayStart                  = "00:00";
extern string ThursdayStop                   = "24:00";
extern string FridayStart                    = "00:00";
extern string FridayStop                     = "24:00";
extern bool FridayCloseWins                  = TRUE;
extern string FridayCloseWinsTime            = "10:00";

extern bool DrawLines                        = FALSE;
extern bool PrintErrors                      = TRUE;
extern bool LogToFile                        = FALSE;

//+------------------------------------------------------------------+
//| internal variables                                               |
//+------------------------------------------------------------------+
string pair, symbol, characters[256],pairsToBuyArray[],pairsToSellArray[],pairsToBuyAndSellArray[],pairsToHedgeArray[],allPairsArray[],tmpArray[];

int p, size, oldSize, Pos, Total, Result, Error, Cnt, dd_mul, selectedOrderTicket, randSignal;
int actualPipDistance, stopLossOverrideDelta, stopPipDistance;

double pointvalue, stopLoss, stopLevel, takeProfit, stopLossOverride, takeProfitOverride, trailingStop, trailingStopOverride, trailingStopAt, trailingStopOverrideAt, chgFromOpen, profitPips, increments, SL, TP, level, latestSpread, spread, lastBarTime, timeUnit;
double orderProfit;

bool inited, TradeAllowed, selectedOrderModified, skipPair;

int ls_arr00[] = {32, 84, 114, 97, 100, 101, 114, 32, 69, 65, 32, 45, 32, 67, 111, 112, 121, 114, 105, 103, 104, 116, 32, 169, 32, 50, 48, 49, 50, 44, 32, 65, 108, 70, 97, 55, 57, 54, 49};

int Current;

//--------------------------------- PIVOTS ----
double Fhr_day_high=0;
double Fhr_day_low=0;
double Fhr_yesterday_high=0;
double Fhr_yesterday_open=0;
double Fhr_yesterday_low=0;
double Fhr_yesterday_close=0;
double Fhr_today_open=0;
double Fhr_today_high=0;
double Fhr_today_low=0;
double Fhr_P=0;
double Fhr_Q=0;
double Fhr_R1,Fhr_R2,Fhr_R3;
double Fhr_M0,Fhr_M1,Fhr_M2,Fhr_M3,Fhr_M4,Fhr_M5;
double Fhr_S1,Fhr_S2,Fhr_S3;
double Fhr_nQ=0;
double Fhr_nD=0;
double Fhr_D=0;
double Fhr_rates_d1[2][6];
double Fhr_ExtMapBuffer[];
//---------------------------------
double D_day_high=0;
double D_day_low=0;
double D_yesterday_high=0;
double D_yesterday_open=0;
double D_yesterday_low=0;
double D_yesterday_close=0;
double D_today_open=0;
double D_today_high=0;
double D_today_low=0;
double D_P=0;
double D_Q=0;
double D_R1,D_R2,D_R3;
double D_M0,D_M1,D_M2,D_M3,D_M4,D_M5;
double D_S1,D_S2,D_S3;
double D_nQ=0;
double D_nD=0;
double D_D=0;
double D_rates_d1[2][6];
double D_ExtMapBuffer[];
//---------------------------------
double nearest_support = 0;
double nearest_resistance = 0;
double nearest_daily_support = 0;
double nearest_daily_resistance = 0;

double farest_support = 0;
double farest_resistance = 0;
double farest_daily_support = 0;
double farest_daily_resistance = 0;
//---------------------------------

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//--- create timer
   EventSetTimer(60);
//---
   inited = false;
//----
   MathSrand(TimeLocal());

   for (int i = 0; i < 256; i++) characters[i] = CharToStr(i);
   Comment(
      EA_NAME +
      /* Trader EA - Copyright © 2012, AlFa7961 */
      chrToStr(ls_arr00) /*+ 
      "\nExpiration Date: " + 
      char[50] + char[48] + char[49] + char[50] + char[46] + char[49] + char[50] + 
      char[46] + char[51] + char[49] + char[32] + char[50] + char[51] + char[58] + 
      char[53] + char[57] + char[58] + char[48] + char[48]*/
   );

  string SymbolsList[];
  if(SymbolsList(SymbolsList, false) > 0)
  {
	 if(PrintErrors==TRUE) {Print("Scanning Majors Pairs...");}
	 int majors = 0;
	 for(int sym=0; sym<ArraySize(SymbolsList); sym++)
	 {
		if (StringFind(SymbolType(SymbolsList[sym]),"Majors")>=0||StringFind(SymbolType(SymbolsList[sym]),"Forex")>=0)
		{
		   if (IsTesting()&&SymbolsList[sym]!=Symbol())
		   {
			  if(PrintErrors==TRUE) {Print("Testing mode ... skipping " + SymbolsList[sym]);}
			  continue;
		   }

		   if(StringLen(PairsToBuy)==0 && StringLen(PairsToSell)==0 && StringLen(PairsToBuyOrSell)==0 && StringLen(PairsToHedge)==0 )
		   {
		      if(
				(StringFind(SymbolsList[sym],"AUD")>=0&&(StringFind(SymbolsList[sym],"EUR")>=0||StringFind(SymbolsList[sym],"USD")>=0)) ||
				(StringFind(SymbolsList[sym],"EUR")>=0&&(StringFind(SymbolsList[sym],"CAD")>=0||StringFind(SymbolsList[sym],"USD")>=0||StringFind(SymbolsList[sym],"CHF")>=0||StringFind(SymbolsList[sym],"GBP")>=0)) ||
				(StringFind(SymbolsList[sym],"GBP")>=0&&(StringFind(SymbolsList[sym],"USD")>=0||StringFind(SymbolsList[sym],"CHF")>=0||StringFind(SymbolsList[sym],"EUR")>=0)) ||
				(StringFind(SymbolsList[sym],"NZD")>=0&&(StringFind(SymbolsList[sym],"USD")>=0)) ||
				(StringFind(SymbolsList[sym],"USD")>=0&&(StringFind(SymbolsList[sym],"CAD")>=0||StringFind(SymbolsList[sym],"CHF")>=0||StringFind(SymbolsList[sym],"GBP")>=0||StringFind(SymbolsList[sym],"JPY")>=2))
			   )
			  {
			    if(PrintErrors==TRUE) {Print("Adding "+SymbolsList[sym]);}
			    if (majors>0)
			    {
				  PairsToBuy        =PairsToBuy+",";
				  PairsToSell       =PairsToSell+",";
				  PairsToBuyOrSell  =PairsToBuyOrSell+",";
				  PairsToHedge      =PairsToHedge+",";
			    }
			    PairsToBuy        =PairsToBuy+SymbolsList[sym];
			    PairsToSell       =PairsToSell+SymbolsList[sym];
			    PairsToBuyOrSell  =PairsToBuyOrSell+SymbolsList[sym];
			    PairsToHedge      =PairsToHedge+SymbolsList[sym];
			    majors++;
			  }
		   }
		}
		 if(StringLen(PairsToBuy)==0 && StringLen(PairsToSell)==0 && StringLen(PairsToBuyOrSell)==0 && StringLen(PairsToHedge)==0 )
		 {
			if(PrintErrors==TRUE) {Print("Scanning Other Pairs...");}
			int others = 0;
			for(sym=0; sym<ArraySize(SymbolsList); sym++)
			{
			   if (IsTesting()&&SymbolsList[sym]!=Symbol())
			   {
				  if(PrintErrors==TRUE) {Print("Testing mode ... skipping " + SymbolsList[sym]);}
				  continue;
			   }
			   if(
				(StringFind(SymbolsList[sym],"AUD")>=0&&(StringFind(SymbolsList[sym],"EUR")>=0||StringFind(SymbolsList[sym],"USD")>=0)) ||
				(StringFind(SymbolsList[sym],"EUR")>=0&&(StringFind(SymbolsList[sym],"CAD")>=0||StringFind(SymbolsList[sym],"USD")>=0||StringFind(SymbolsList[sym],"CHF")>=0||StringFind(SymbolsList[sym],"GBP")>=0)) ||
				(StringFind(SymbolsList[sym],"GBP")>=0&&(StringFind(SymbolsList[sym],"USD")>=0||StringFind(SymbolsList[sym],"CHF")>=0||StringFind(SymbolsList[sym],"EUR")>=0)) ||
				(StringFind(SymbolsList[sym],"NZD")>=0&&(StringFind(SymbolsList[sym],"USD")>=0)) ||
				(StringFind(SymbolsList[sym],"USD")>=0&&(StringFind(SymbolsList[sym],"CAD")>=0||StringFind(SymbolsList[sym],"CHF")>=0||StringFind(SymbolsList[sym],"GBP")>=0||StringFind(SymbolsList[sym],"JPY")>=2))
			   )
			   {
				   if(PrintErrors==TRUE) {Print("Adding "+SymbolsList[sym]);}
				   if (others>0)
				   {
					  PairsToBuy        =PairsToBuy+",";
					  PairsToSell       =PairsToSell+",";
					  PairsToBuyOrSell  =PairsToBuyOrSell+",";
					  PairsToHedge      =PairsToHedge+",";
				   }
				   PairsToBuy        =PairsToBuy+SymbolsList[sym];
				   PairsToSell       =PairsToSell+SymbolsList[sym];
				   PairsToBuyOrSell  =PairsToBuyOrSell+SymbolsList[sym];
				   PairsToHedge      =PairsToHedge+SymbolsList[sym];
				   others++;
			   }
			}
		 }		
	 }
  }

   if(StringLen(PairsToBuy)==0 && StringLen(PairsToSell)==0 && StringLen(PairsToBuyOrSell)==0 && StringLen(PairsToHedge)==0 )
   {
	 //Comment("ERROR -- EA_NAME Trader : Must specify some pairs");
	 Alert("ERROR -- "+EA_NAME+" Trader : Must specify some pairs");
	 return(-1);
   }

   // Date, until which the expert is allowed to work
   datetime LastAllowedDate = StrToTime(
      /* 2012.12.31 23:59:00 */
      characters[50] + characters[48] + characters[49] + characters[50] + characters[46] + characters[49] + characters[50] + 
      characters[46] + characters[51] + characters[49] + characters[32] + characters[50] + characters[51] + characters[58] + 
      characters[53] + characters[57] + characters[58] + characters[48] + characters[48]
   );
   
   string delim = ",";
   if(StringLen(PairsToBuy)>0)
   {
      size = 1+StringFindCount(PairsToBuy,delim);
      ArrayResize(pairsToBuyArray,size);
      StrToStringArray(PairsToBuy,pairsToBuyArray,delim);
      
      ArrayResize(allPairsArray,size);
      ArrayCopy(allPairsArray,pairsToBuyArray,0,0,WHOLE_ARRAY);
   }

   if(StringLen(PairsToSell)>0)
   {
      size = 1+StringFindCount(PairsToSell,delim);
      ArrayResize(pairsToSellArray,size);
      StrToStringArray(PairsToSell,pairsToSellArray,delim);

      oldSize = ArraySize(allPairsArray);
      ArrayResize(allPairsArray,oldSize+size);
      ArrayCopy(allPairsArray,pairsToSellArray,oldSize,0,WHOLE_ARRAY);
   }

   if(StringLen(PairsToBuyOrSell)>0)
   {
      size = 1+StringFindCount(PairsToBuyOrSell,delim);
      ArrayResize(pairsToBuyAndSellArray,size);
      StrToStringArray(PairsToBuyOrSell,pairsToBuyAndSellArray,delim);

      oldSize = ArraySize(allPairsArray);
      ArrayResize(allPairsArray,oldSize+size);
      ArrayCopy(allPairsArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
   }   

   if(StringLen(PairsToHedge)>0)
   {
      size = 1+StringFindCount(PairsToHedge,delim);
      ArrayResize(pairsToHedgeArray,size);
      StrToStringArray(PairsToHedge,pairsToHedgeArray,delim);

      oldSize = ArraySize(allPairsArray);
      ArrayResize(allPairsArray,oldSize+size);
      ArrayCopy(allPairsArray,pairsToHedgeArray,oldSize,0,WHOLE_ARRAY);      
   }
   
   GlobalVariablesDeleteAll();
   
   //+------------------------------------------------------------------+
   //| checking validity                                                |
   //+------------------------------------------------------------------+
   /*if (!IsDemo())
   {
      Comment("ERROR -- "+EA_NAME+" Trader : Not allowed to trade on live account");
      Alert("ERROR -- "+EA_NAME+" Trader : Not allowed to trade on live account");

      return(-1);
   }*/

   /*if (TimeCurrent() >= LastAllowedDate) 
   {
      Alert("ERROR -- "+EA_NAME+" Trader : Demo period has expired " + TimeToStr(LastAllowedDate,TIME_DATE|TIME_MINUTES));
      return(-1);
   }*/
   
   int control = 0;
   
   if (_BuyRandomPair == TRUE) control++;
   if (_SellRandomPair == TRUE) control++;
   if (_BuyOrSellPair == TRUE) control++;

   if (_BestSwapRandomPair == TRUE) control++;
   if (_WorstSwapRandomPair == TRUE) control++;

   if (_BuyPairNarrowSprd == TRUE) control++;
   if (_SellPairNarrowSprd == TRUE) control++;
   if (_BuyOrSellPairNarrowSprd == TRUE) control++;
   if (_BestSwapPairNarrowSprd == TRUE) control++;
   if (_WorstSwapPairNarrowSprd == TRUE) control++;

   if (_BuyPairWideSprd == TRUE) control++;
   if (_SellPairWideSprd == TRUE) control++;
   if (_BuyOrSellPairWideSprd == TRUE) control++;
   if (_BestSwapPairWideSprd == TRUE) control++;
   if (_WorstSwapPairWideSprd == TRUE) control++;

   if (EachTickMode) Current = 0; else Current = 1;
   
   if (control != 1)
   {
      Alert("ERROR -- "+EA_NAME+" Trader : Please select only 1 \'Action\' option");
      return(-1);
   }
   
//----
   inited = true;
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
//----
   Total = OrdersTotal();
   for (int i = Total-1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
      {
         if (OrderMagicNumber() == Magic)
         {
            Pos = OrderType();
            if ((Pos == OP_BUYSTOP) || (Pos == OP_SELLSTOP) || (Pos == OP_BUYLIMIT) || (Pos == OP_SELLLIMIT)) {Result = OrderDelete(OrderTicket(), CLR_NONE);}
            if (Result <= 0) {Error = GetLastError();}
            else Error = 0;
         }
      }
   }

   lastBarTime = TimeCurrent();

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
  
  if (inited == FALSE)
  {
      Comment("CRITICAL ERROR -- "+EA_NAME+" Trader : not correctly initialized. Please check input values or conditions!");
      return(-1);
  }

//----

   Cnt = 0;
   Total = OrdersTotal();
   
   /*if (Total == 0)
   {
      Print("DELETE ALL");
      GlobalVariablesDeleteAll();
   }*/
   RefreshRates();
   if (Total > 0)
   {
      // Initialize "GlobalVariables"
      for (int i = Total-1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
         {
            if (OrderMagicNumber() == Magic)
            {
               string var_id=StringConcatenate("MONKEY_ORDER_",DoubleToStr(OrderTicket(),0));
               bool orderPresent = GlobalVariableCheck(var_id);
            
               if (orderPresent == FALSE)
               {
                  if(PrintErrors==TRUE) Print("Setting: ", var_id, " to ", OrderClosePrice());
                  GlobalVariableSet(var_id,OrderClosePrice());
               }
            }
         }
      }
      
      // Clean UP "GlobalVariables"
      for (i = 0; i < GlobalVariablesTotal(); i++)
      {
         string var_name = GlobalVariableName(i);
         int monkeyIdIndex=StringFind(var_name, "MONKEY_ORDER_", 0);
         if (monkeyIdIndex>=0)
         {
            int order_id = StrToDouble(StringSubstr(var_name, StringLen("MONKEY_ORDER_")));
            
            //Print("Checking presence of Order ID#", order_id);
            
            if (OrderSelect(order_id, SELECT_BY_TICKET, MODE_TRADES)==FALSE)
            {
               GlobalVariableDel(var_name);
            }
         }
      }
   }

   timeUnit = ((TimeCurrent() - lastBarTime) /*/ 60*/);
   
   if (timeUnit >= OpenNewTradesDelay) {
      lastBarTime = TimeCurrent();

      if (LogToFile==TRUE)
      {
		    RefreshRates();
		    Total = OrdersTotal();
		    for (i = Total-1; i >= 0; i--)
		    {
		      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE)
		      {
		         if( (TimeCurrent()-OrderOpenTime())<=OpenNewTradesDelay )
		         {
		           //Alert("LOGGING ... TRADES");
		              pointvalue = MarketInfo(OrderSymbol(), MODE_POINT);
                    selectedOrderTicket = OrderTicket();
                    actualPipDistance = (OrderClosePrice()-OrderOpenPrice())/pointvalue;
                    Log(selectedOrderTicket, "OPENED", OrderSymbol(), actualPipDistance);
		         }
		      }
		    }

		    RefreshRates();
		    Total = OrdersHistoryTotal();
		    for (i = Total-1; i >= 0; i--)
		    {
		      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == TRUE)
		      {
		         if( (TimeCurrent()-OrderCloseTime())<=OpenNewTradesDelay )
		         {
		           //Alert("LOGGING ... HISTORY");
		              pointvalue = MarketInfo(OrderSymbol(), MODE_POINT);
                    selectedOrderTicket = OrderTicket();
                    actualPipDistance = (OrderClosePrice()-OrderOpenPrice())/pointvalue;
                    Log(selectedOrderTicket, "CLOSED", OrderSymbol(), actualPipDistance);
		         }
		      }
		    }
      }
      
      RefreshRates();
      Total = OrdersTotal();
      for (i = Total-1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
         {
            selectedOrderTicket = OrderTicket();
            if (OrderMagicNumber() == Magic)
            {
               actualPipDistance = 0;
               stopLossOverrideDelta = 0;
               stopPipDistance = 0;
               Pos = OrderType();
               if ((Pos == OP_BUY) || (Pos == OP_SELL))
               {
                  int barsLeftFromOpenTime = iBarShift(OrderSymbol(), PERIOD_H1, OrderOpenTime(), TRUE);
               
                  if (barsLeftFromOpenTime > 0 && CloseAfterNumberOfHours >0)
                  {
                     if(barsLeftFromOpenTime >= CloseAfterNumberOfHours)
                     {
                        if(PrintErrors) Print("Closing Order#",OrderTicket(), " due to expiration time: open time#", TimeToStr(OrderOpenTime(),TIME_DATE|TIME_MINUTES), " - now#", TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES), " - bars left from open#", barsLeftFromOpenTime);
                        if (Pos == OP_BUY)
                        {
                           if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                           {
                              continue;
                           }
                        }
                        else if (Pos == OP_SELL)
                        {
                           if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, CLR_NONE) == TRUE)
                           {
                              continue;
                           }
                        }
                     }
                  }

                  if (MarketInfo(OrderSymbol(), MODE_DIGITS) == 3 || MarketInfo(OrderSymbol(), MODE_DIGITS) == 5) dd_mul = 10;
                  else dd_mul = 1;

                  pointvalue              = /*dd_mul * */ MarketInfo(OrderSymbol(), MODE_POINT);
                  if (StringFind(OrderComment(),"BALANCE")>0)
                     stopLoss                = /*dd_mul * */ (StopLossLevel/2);
                  else
                     stopLoss                = /*dd_mul * */ StopLossLevel;
                  takeProfit              = /*dd_mul * */ TakeProfitLevel;
                  stopLossOverride        = /*dd_mul * */ StopLossOverride;
                  takeProfitOverride      = /*dd_mul * */ TakeProfitOverride;
                  trailingStop            = /*dd_mul * */ TrailingStop;
                  trailingStopOverride    = /*dd_mul * */ TrailingStopOverride;
                  trailingStopAt          = /*dd_mul * */ TrailingStopAt;
                  trailingStopOverrideAt  = /*dd_mul * */ TrailingStopOverrideAt;
                                    
                  if (Pos == OP_BUY)
                  {
                     stopLevel   = MarketInfo(OrderSymbol(), MODE_STOPLEVEL)+MarketInfo(OrderSymbol(), MODE_SPREAD);
                     if (OrderStopLoss() == 0 && StopLossLevel > 0)
                     {
                        SL = 0;
                        if (StringFind(OrderComment(),"BALANCE")>0)
                           stopLoss    = NormalizeDouble((StopLossLevel/2) * pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                        else
                           stopLoss    = NormalizeDouble(StopLossLevel * pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                        if(stopLoss > 0){SL = MarketInfo(OrderSymbol(), MODE_ASK)-stopLoss;}

                        if (SL > MarketInfo(OrderSymbol(), MODE_ASK)-stopLevel*pointvalue) {SL = MarketInfo(OrderSymbol(), MODE_ASK)-stopLevel*pointvalue;}

                        if (SL != 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE)
                        {
                           selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), SL, OrderTakeProfit(), 0, CLR_NONE);
                        }
                        else
                        {
                           selectedOrderModified = TRUE;
                        }

                        int ssllbb = 0;
                        while (selectedOrderModified == FALSE)
                        {
                           RefreshRates();
                           if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == FALSE) {selectedOrderModified = TRUE; break;}
                           
                           if(PrintErrors) Print("ERROR -- "+EA_NAME+" Trader SL("+SL+"): Modifying BUY order REASON# ", GetLastError());
                           //if (selectedOrderModified == FALSE && GetLastError() != 130) {selectedOrderModified = TRUE; break;}
                           Sleep(1000);
                           RefreshRates();
                           
                           ssllbb++;
                           if (StringFind(OrderComment(),"BALANCE")>0)
                              stopLoss    = NormalizeDouble((StopLossLevel/2)*pointvalue + stopLevel*pointvalue + ssllbb*dd_mul*pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                           else
                              stopLoss    = NormalizeDouble(StopLossLevel*pointvalue + stopLevel*pointvalue + ssllbb*dd_mul*pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                           if(stopLoss > 0){SL = MarketInfo(OrderSymbol(), MODE_ASK)-stopLoss;}

                           if(OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE) selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), SL, OrderTakeProfit(), 0, CLR_NONE);
                           else {selectedOrderModified = TRUE;}
                        }
                     }

                     if (OrderTakeProfit() == 0 && TakeProfitLevel > 0)
                     {
                        TP = 0;
                        takeProfit  = NormalizeDouble(TakeProfitLevel * pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                        if(takeProfit > 0){TP = MarketInfo(OrderSymbol(), MODE_BID)+takeProfit;}

                        if (TP < MarketInfo(OrderSymbol(), MODE_BID)+stopLevel*pointvalue) {TP = MarketInfo(OrderSymbol(), MODE_BID)+stopLevel*pointvalue;}

                        if (TP != 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE)
                        {
                           selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), OrderStopLoss(), TP, 0, CLR_NONE);
                        }
                        else
                        {
                           selectedOrderModified = TRUE;
                        }

                        int ttppbb = 0;
                        while (selectedOrderModified == FALSE)
                        {
                           RefreshRates();
                           if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == FALSE) {selectedOrderModified = TRUE; break;}
                           
                           if(PrintErrors) Print("ERROR -- "+EA_NAME+" Trader TP("+TP+") : Modifying BUY order REASON# ", GetLastError());
                           //if (selectedOrderModified == FALSE && GetLastError() != 130) {selectedOrderModified = TRUE; break;}
                           Sleep(1000);
                           RefreshRates();

                           ttppbb++;
                           takeProfit  = NormalizeDouble(TakeProfitLevel*pointvalue + stopLevel*pointvalue + ttppbb*dd_mul*pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                           if(takeProfit > 0){TP = MarketInfo(OrderSymbol(), MODE_BID)+takeProfit;}
                           if(OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE) selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), OrderStopLoss(), TP, 0, CLR_NONE);
                           else {selectedOrderModified = TRUE;}
                        }
                     }

                     selectedOrderTicket = OrderTicket();
                     actualPipDistance = (OrderClosePrice()-OrderOpenPrice())/pointvalue;
                                 //MathCeil( ( OrderProfit() - OrderCommission() ) / OrderLots() / MarketInfo( OrderSymbol(), MODE_TICKVALUE ) );
                                 //(MarketInfo(OrderSymbol(), MODE_BID) - OrderOpenPrice()) / pointvalue;
                     
                     /*if ((actualPipDistance < 0 && MathAbs(actualPipDistance) >= stopLoss) || (actualPipDistance > 0 && actualPipDistance >= takeProfit))
                     {
                        if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                        {
                           continue;
                        }
                     }*/
                     
                     /* ** takeProfitOverride ** */
                     RefreshRates();
                     if (takeProfitOverride > 0 && actualPipDistance > 0 && actualPipDistance >= takeProfitOverride)
                     {
                        if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                        {
                           var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                           GlobalVariableDel(var_id);
                           continue;
                        }
                     }
                                                               
                     /* ** trailingStop ** */
                     RefreshRates();                     
                     if (trailingStop > 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                     {
                        chgFromOpen = NormalizeDouble(OrderClosePrice() - OrderOpenPrice(), MarketInfo(OrderSymbol(),MODE_DIGITS))/pointvalue;
                        if (chgFromOpen>0 && chgFromOpen>trailingStopAt)
                        {
                           level = NormalizeDouble(OrderClosePrice() - trailingStop*pointvalue, MarketInfo(OrderSymbol(),MODE_DIGITS));
                           /*if (MathAbs(OrderClosePrice()-level)/pointvalue<MarketInfo(OrderSymbol(), MODE_STOPLEVEL)+MarketInfo(OrderSymbol(), MODE_SPREAD))
                              level = NormalizeDouble(OrderClosePrice() - (MarketInfo(OrderSymbol(), MODE_STOPLEVEL)+MarketInfo(OrderSymbol(), MODE_SPREAD))*pointvalue, MarketInfo(OrderSymbol(),MODE_DIGITS));*/
                              
                           if( OrderStopLoss()==0 || level > NormalizeDouble(OrderStopLoss(), MarketInfo(OrderSymbol(),MODE_DIGITS)) ) 
                           {
                              if(PrintErrors) Print("Updating BUY Order#",OrderTicket()," [",OrderSymbol(),"] TrailingStop from -> ",OrderStopLoss()," to -> ",level, " - distance: ",MathAbs(OrderStopLoss()-level)/pointvalue);

                              selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), level, OrderTakeProfit(), 0, CLR_NONE);
                           }
                        }
                     }

                     /* ** stopLossOverride AND trailingStopOverride ** */
                     RefreshRates();

                     /* ** stopLossOverride ** */
                     if (stopLossOverride > 0 && OrderStopLoss()<OrderOpenPrice())
                     {
                        if (actualPipDistance < 0 && MathAbs(actualPipDistance) >= stopLossOverride)
                        {
                           if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                           {
                              var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                              GlobalVariableDel(var_id);
                              continue;
                           }
                        }
                     }
                     
                     /* ** hedge loss ** */
                     RefreshRates();
                     if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                     {
                        if (HedgeLoss==TRUE)
                        {
                           if (OrderStopLoss() > 0 && OrderStopLoss() < OrderOpenPrice())
                           {
                              double stopLossDistance = (OrderOpenPrice()-OrderStopLoss())/pointvalue;
                              if (actualPipDistance < 0 && MathAbs(actualPipDistance) >= (stopLossDistance - (stopLossDistance/2)))
                              {
                                 symbol = OrderSymbol();
                                 if(OrderOnPairAndPosAlreadyPlaced(symbol,OP_SELL,OrderComment())==FALSE)
                                 {
                                    OpenOrderSell(symbol,TRUE);
                                 }
                              }
                           }
                           else if (TakeProfitLevel > 0)
                           {
                              if (actualPipDistance < 0 && MathAbs(actualPipDistance) >= (TakeProfitLevel/8))
                              {
                                 symbol = OrderSymbol();
                                 if(OrderOnPairAndPosAlreadyPlaced(symbol,OP_SELL,OrderComment())==FALSE)
                                 {
                                    OpenOrderSell(symbol,TRUE);
                                 }
                              }
                           }
                        }
                     }

                     RefreshRates();
                     if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                     {
                        orderProfit=OrderProfit()+OrderSwap()+OrderCommission();
                        
                        var_id=StringConcatenate("MONKEY_ORDER_",DoubleToStr(OrderTicket(),0));
                        
                        //Print("GlobalVariableCheck(MONKEY_ORDER_"+OrderTicket()+") ", GlobalVariableCheck(var_id));
                        //Print("GlobalVariableGet(MONKEY_ORDER_"+OrderTicket()+") ", GlobalVariableGet(var_id));
                        
                        if(GlobalVariableCheck(var_id)==TRUE)
                        {
                           double lastBUYOrderPrice=GlobalVariableGet(var_id);
                           
                           if(lastBUYOrderPrice==0||lastBUYOrderPrice==EMPTY_VALUE||OrderClosePrice()>lastBUYOrderPrice)
                           {  
                              //GlobalVariableDel(var_id);
                              GlobalVariableSet(var_id,OrderClosePrice());
                              lastBUYOrderPrice=OrderClosePrice();
                           }

                           /* ** stopLossOverride ** */
                           if (stopLossOverride > 0 && OrderStopLoss()>OrderOpenPrice())
                           {
                              actualPipDistance = (lastBUYOrderPrice-OrderClosePrice())/pointvalue;
                              stopLossOverrideDelta = stopLossOverride - stopLoss;
                              stopPipDistance = (OrderClosePrice()-OrderStopLoss())/pointvalue;
                              if (actualPipDistance>=stopPipDistance+stopLossOverrideDelta)
                              {
                                 if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                                 {
                                    var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                                    GlobalVariableDel(var_id);
                                    continue;
                                 }
                              }
                           }
                           
                           /* ** trailingStopOverride ** */
                           if (trailingStopOverride > 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                           {
                              chgFromOpen = NormalizeDouble(OrderClosePrice() - OrderOpenPrice(), MarketInfo(OrderSymbol(),MODE_DIGITS))/pointvalue;
                              if (chgFromOpen>0 && chgFromOpen>trailingStopOverrideAt)
                              {
                                 if(lastBUYOrderPrice-OrderOpenPrice()>trailingStopOverride&&lastBUYOrderPrice-NormalizeDouble(OrderClosePrice(), MarketInfo(OrderSymbol(), MODE_DIGITS))>trailingStopOverride*pointvalue)
                                 {
                                    if(PrintErrors) Print("Closing BUY Order#",OrderTicket()," [",OrderSymbol(),"] TrailingStopOverride from -> ",lastBUYOrderPrice," to -> ",NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), MarketInfo(OrderSymbol(), MODE_DIGITS)), " - distance: ",MathAbs(NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), MarketInfo(OrderSymbol(), MODE_DIGITS))-lastBUYOrderPrice)/pointvalue);
                                    OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), MarketInfo(OrderSymbol(), MODE_DIGITS)), Slippage, CLR_NONE);
                                 }
                              }
                           }
                        }
                        else
                        {
                           GlobalVariableSet(var_id,OrderClosePrice());
                        }
                     }
                     else
                     {
                        var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                        GlobalVariableDel(var_id);
                     }                     
                  }
                  else if (Pos == OP_SELL)
                  {
                     stopLevel   = MarketInfo(OrderSymbol(), MODE_STOPLEVEL)+MarketInfo(OrderSymbol(), MODE_SPREAD);
                     if (StopLossLevel > 0 && OrderStopLoss() == 0)
                     {
                        SL = 0;
                        if (StringFind(OrderComment(),"BALANCE")>0)
                           stopLoss    = NormalizeDouble((StopLossLevel/2) * pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                        else
                           stopLoss    = NormalizeDouble(StopLossLevel * pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                        if(stopLoss > 0){SL = MarketInfo(OrderSymbol(), MODE_ASK)+stopLoss;}

                        if (SL < MarketInfo(OrderSymbol(), MODE_ASK)+stopLevel*pointvalue) {SL = MarketInfo(OrderSymbol(), MODE_BID)+stopLevel*pointvalue;}

                        if (SL != 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE)
                        {
                           selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), SL, OrderTakeProfit(), 0, CLR_NONE);
                        }
                        else
                        {
                           selectedOrderModified = TRUE;
                        }
                        
                        int ssllss = 0;
                        while (selectedOrderModified == FALSE)
                        {
                           RefreshRates();
                           if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == FALSE) {selectedOrderModified = TRUE; break;}
                           
                           if(PrintErrors) Print("ERROR -- "+EA_NAME+" Trader SL("+SL+") : Modifying SELL order REASON# ", GetLastError());
                           //if (selectedOrderModified == FALSE && GetLastError() != 130) {selectedOrderModified = TRUE; break;}
                           Sleep(1000);
                           RefreshRates();
                           
                           ssllss++;
                           if (StringFind(OrderComment(),"BALANCE")>0)
                              stopLoss    = NormalizeDouble((StopLossLevel/2)*pointvalue + stopLevel*pointvalue + ssllss*dd_mul*pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                           else
                              stopLoss    = NormalizeDouble(StopLossLevel*pointvalue + stopLevel*pointvalue + ssllss*dd_mul*pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                           if(stopLoss > 0){SL = MarketInfo(OrderSymbol(), MODE_ASK)+stopLoss;}
                           if(OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE) selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), SL, OrderTakeProfit(), 0, CLR_NONE);
                           else {selectedOrderModified = TRUE;}
                        }
                     }

                     if (TakeProfitLevel > 0 && OrderTakeProfit() == 0)
                     {
                        TP = 0;
                        takeProfit  = NormalizeDouble(TakeProfitLevel * pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                        if(takeProfit > 0){TP = MarketInfo(OrderSymbol(), MODE_BID)-takeProfit;}

                        if (TP > MarketInfo(OrderSymbol(), MODE_BID)-stopLevel*pointvalue) {TP = MarketInfo(OrderSymbol(), MODE_ASK)-stopLevel*pointvalue;}

                        if (TP != 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE)
                        {
                           selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), OrderStopLoss(), TP, 0, CLR_NONE);
                        }
                        else
                        {
                           selectedOrderModified = TRUE;
                        }

                        int ttppss = 0;
                        while (selectedOrderModified == FALSE)
                        {
                           RefreshRates();
                           if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == FALSE) {selectedOrderModified = TRUE; break;}
                           
                           if(PrintErrors) Print("ERROR -- "+EA_NAME+" Trader TP("+TP+") : Modifying SELL order REASON# ", GetLastError());
                           //if (selectedOrderModified == FALSE && GetLastError() != 130) {selectedOrderModified = TRUE; break;}
                           Sleep(1000);
                           RefreshRates();

                           ttppss++;
                           takeProfit  = NormalizeDouble(TakeProfitLevel*pointvalue + stopLevel*pointvalue + ttppss*dd_mul*pointvalue, MarketInfo(OrderSymbol(), MODE_DIGITS));
                           if(takeProfit > 0){TP = MarketInfo(OrderSymbol(), MODE_BID)-takeProfit;}
                           if(OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES) == TRUE) selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), OrderStopLoss(), TP, 0, CLR_NONE);
                           else {selectedOrderModified = TRUE;}
                        }
                     }

                     selectedOrderTicket = OrderTicket();      
                     actualPipDistance = (OrderOpenPrice()-OrderClosePrice())/pointvalue;
                                 //MathCeil( ( OrderProfit() - OrderCommission() ) / OrderLots() / MarketInfo( OrderSymbol(), MODE_TICKVALUE ) );
                                 //(OrderOpenPrice() - MarketInfo(OrderSymbol(), MODE_ASK)) / pointvalue;
                     
                     /*if ((actualPipDistance < 0 && MathAbs(actualPipDistance) >= stopLoss) || (actualPipDistance > 0 && actualPipDistance >= takeProfit))
                     {
                        if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, CLR_NONE) == TRUE)
                        {
                           continue;
                        }
                     }*/
                     
                     /* ** takeProfitOverride ** */
                     RefreshRates();
                     if (takeProfitOverride > 0 && actualPipDistance > 0 && actualPipDistance >= takeProfitOverride)
                     {
                        if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, CLR_NONE) == TRUE)
                        {
                           var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                           GlobalVariableDel(var_id);
                           continue;
                        }
                     }
                     
                     /* ** trailingStop ** */
                     RefreshRates();
                     if (trailingStop > 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                     {
                        chgFromOpen = NormalizeDouble(OrderOpenPrice() - OrderClosePrice(), MarketInfo(OrderSymbol(),MODE_DIGITS))/pointvalue;
                        if (chgFromOpen>0 && chgFromOpen>trailingStopAt)
                        {
                           level = NormalizeDouble(OrderClosePrice() + trailingStop*pointvalue, MarketInfo(OrderSymbol(),MODE_DIGITS));
                           /*if (MathAbs(OrderClosePrice()-level)/pointvalue<MarketInfo(OrderSymbol(), MODE_STOPLEVEL)+MarketInfo(OrderSymbol(), MODE_SPREAD))
                              level = NormalizeDouble(OrderClosePrice() + (MarketInfo(OrderSymbol(), MODE_STOPLEVEL)+MarketInfo(OrderSymbol(), MODE_SPREAD))*pointvalue, MarketInfo(OrderSymbol(),MODE_DIGITS));*/
         
                           if( OrderStopLoss()==0 || level < NormalizeDouble(OrderStopLoss(), MarketInfo(OrderSymbol(),MODE_DIGITS)) ) 
                           {
                              if(PrintErrors) Print("Updating SELL Order#",OrderTicket()," [",OrderSymbol(),"] TrailingStop from -> ",OrderStopLoss()," to -> ",level, " - distance: ",MathAbs(OrderStopLoss()-level)/pointvalue);

                              selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), level, OrderTakeProfit(), 0, CLR_NONE);
                           }
                        }
                     }

                     
                     /* ** stopLossOverride AND takeProfitOverride ** */
                     RefreshRates();
                     
                     /* ** stopLossOverride ** */
                     if (stopLossOverride > 0 && actualPipDistance < 0 && MathAbs(actualPipDistance) >= stopLossOverride)
                     {
                        if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, CLR_NONE) == TRUE)
                        {
                           var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                           GlobalVariableDel(var_id);
                           continue;
                        }
                     }

                     /* ** hedge loss ** */
                     RefreshRates();
                     if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                     {
                        if (HedgeLoss==TRUE)
                        {
                           if (OrderStopLoss() > 0 && OrderStopLoss() > OrderOpenPrice())
                           {
                              stopLossDistance = (OrderStopLoss()-OrderOpenPrice())/pointvalue;
                              if (actualPipDistance < 0 && MathAbs(actualPipDistance) >= (stopLossDistance - (stopLossDistance/2)))
                              {
                                 symbol = OrderSymbol();
                                 if(OrderOnPairAndPosAlreadyPlaced(symbol,OP_BUY,OrderComment())==FALSE)
                                 {
                                    OpenOrderBuy(symbol,TRUE);
                                 }
                              }
                           }
                           else if (TakeProfitLevel > 0)
                           {
                              if (actualPipDistance < 0 && MathAbs(actualPipDistance) >= (TakeProfitLevel/8))
                              {
                                 symbol = OrderSymbol();
                                 if(OrderOnPairAndPosAlreadyPlaced(symbol,OP_BUY,OrderComment())==FALSE)
                                 {
                                    OpenOrderBuy(symbol,TRUE);
                                 }
                              }
                           }
                        }
                     }

                     RefreshRates();
                     if (OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                     {
                        orderProfit=OrderProfit()+OrderSwap()+OrderCommission();

                        var_id=StringConcatenate("MONKEY_ORDER_",DoubleToStr(OrderTicket(),0));
                        
                        //Print("GlobalVariableCheck(MONKEY_ORDER_"+OrderTicket()+") ", GlobalVariableCheck(var_id));
                        //Print("GlobalVariableGet(MONKEY_ORDER_"+OrderTicket()+") ", GlobalVariableGet(var_id));
                        
                        if(GlobalVariableCheck(var_id)==TRUE)
                        {
                           double lastSELLOrderPrice=GlobalVariableGet(var_id);
                           
                           if(lastSELLOrderPrice==0||lastSELLOrderPrice==EMPTY_VALUE||OrderClosePrice()<lastSELLOrderPrice)
                           {  
                              //GlobalVariableDel(var_id);
                              GlobalVariableSet(var_id,OrderClosePrice());
                              lastSELLOrderPrice=OrderClosePrice();
                           }

                           /* ** stopLossOverride ** */
                           if (stopLossOverride > 0 && OrderStopLoss()<OrderOpenPrice())
                           {
                              actualPipDistance = (OrderClosePrice()-lastSELLOrderPrice)/pointvalue;
                              stopLossOverrideDelta = stopLossOverride - stopLoss;
                              stopPipDistance = (OrderStopLoss()-OrderClosePrice())/pointvalue;
                              if (actualPipDistance>=stopPipDistance+stopLossOverrideDelta)
                              {
                                 if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                                 {
                                    var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                                    GlobalVariableDel(var_id);
                                    continue;
                                 }
                              }
                           }
                           
                           /* ** trailingStopOverride ** */
                           if (trailingStopOverride > 0 && OrderSelect(selectedOrderTicket, SELECT_BY_TICKET, MODE_TRADES)==TRUE)
                           {
                              chgFromOpen = NormalizeDouble(OrderOpenPrice() - OrderClosePrice(), MarketInfo(OrderSymbol(),MODE_DIGITS))/pointvalue;
                              if (chgFromOpen>0 && chgFromOpen>trailingStopOverrideAt)
                              {
                                 if(lastSELLOrderPrice-OrderOpenPrice()>trailingStopOverride&&NormalizeDouble(OrderClosePrice(), MarketInfo(OrderSymbol(), MODE_DIGITS))-lastSELLOrderPrice>trailingStopOverrideAt+trailingStopOverride*pointvalue)
                                 {
                                    if(PrintErrors) Print("Closing SELL Order#",OrderTicket()," [",OrderSymbol(),"] TrailingStopOverride from -> ",lastSELLOrderPrice," to -> ",NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), MarketInfo(OrderSymbol(), MODE_DIGITS)), " - distance: ",MathAbs(NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), MarketInfo(OrderSymbol(), MODE_DIGITS))-lastSELLOrderPrice)/pointvalue);
                                    OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), MarketInfo(OrderSymbol(), MODE_DIGITS)), Slippage, CLR_NONE);
                                 }
                              }
                           }
                        }
                        else
                        {
                           GlobalVariableSet(var_id,OrderClosePrice());
                        }
                     }
                     else
                     {
                        var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(selectedOrderTicket,0));
                        GlobalVariableDel(var_id);
                     }
                     
                  }
                  
                  //if(PrintErrors) Print(OrderSymbol(), " - actualPipDistance#", actualPipDistance, " - takeProfitOverride#", takeProfitOverride, " - stopLossOverride#", stopLossOverride);
               
                  Cnt++;
               }
            }
         }
      }
   }

   // expert trade limits
   TradeAllowed = TRUE;

   if ( MinimumBalance > 0 && AccountBalance() <= MinimumBalance)
   {
      if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Balance is lower than MinimumBalance#", MinimumBalance);
      TradeAllowed = FALSE;
   }

   if ( MinimumEquity > 0 && AccountEquity() <= MinimumEquity)
   {
      if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Equity is lower than MinimumEquity#", MinimumEquity);
      TradeAllowed = FALSE;
   }

   if ( MinimumFreeMargin > 0 && AccountFreeMargin() <= MinimumFreeMargin)
   {
      if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Free Margin is lower than MinimumFreeMargin#", MinimumFreeMargin);
      TradeAllowed = FALSE;
   }
   
   if ( MinimumMarginLevel > 0 && AccountMargin() > 0)
   {
      if ((AccountEquity()/AccountMargin())*100 <= MinimumMarginLevel)
      {
         if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Available Magin (%) is lower than ", MinimumMarginLevel);
         TradeAllowed = FALSE;
      }
   }

   //MondayStart / MondayStop
   if (DayOfWeek() == 1 && (CheckCurrentTimeBefore(MondayStart) == TRUE||CheckCurrentTimeAfter(MondayStop,MondayStart,1) == TRUE))
   {
      //if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Trades allowed only Monday between ",MondayStart," and ",MondayStop);
      TradeAllowed = FALSE;
   }
   
   //TuesdayStart / TuesdayStop
   if (DayOfWeek() == 2 && (CheckCurrentTimeBefore(TuesdayStart) == TRUE||CheckCurrentTimeAfter(TuesdayStop,TuesdayStart,2) == TRUE))
   {
      //if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Trades allowed only Tuesday between ",TuesdayStart," and ",TuesdayStop);
      TradeAllowed = FALSE;
   }

   //WednesdayStart / WednesdayStop
   if (DayOfWeek() == 3 && (CheckCurrentTimeBefore(WednesdayStart) == TRUE||CheckCurrentTimeAfter(WednesdayStop,WednesdayStart,3) == TRUE))
   {
      //if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Trades allowed only Wednesday between ",WednesdayStart," and ",WednesdayStop);
      TradeAllowed = FALSE;
   }

   //ThursdayStart / ThursdayStop
   if (DayOfWeek() == 4 && (CheckCurrentTimeBefore(ThursdayStart) == TRUE||CheckCurrentTimeAfter(ThursdayStop,ThursdayStart,4) == TRUE))
   {
      //if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Trades allowed only Thursday between ",ThursdayStart," and ",ThursdayStop);
      TradeAllowed = FALSE;
   }

   //FridayStart / FridayStop
   if (DayOfWeek() == 5 && (CheckCurrentTimeBefore(FridayStart) == TRUE||CheckCurrentTimeAfter(FridayStop,FridayStart,5) == TRUE))
   {
      //if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Trades allowed only FridayStart between ",FridayStart," and ",FridayStop);
      TradeAllowed = FALSE;
   }

   if (DayOfWeek() == 5 && FridayCloseWins == TRUE && CheckCurrentTimeAfter(FridayCloseWinsTime,FridayCloseWinsTime,5)==TRUE)
   {
      if(PrintErrors) Print("WARNING -- "+EA_NAME+" Trader : Closing all winning orders on Friday at ",FridayStart);
      CloseAllWinningOrders();
   }
  
   // randomly select pair to Buy
   ArrayResize(tmpArray,0);
   if (ArraySize(pairsToBuyAndSellArray) > 0)
   {
     size = ArraySize(pairsToBuyAndSellArray);
     oldSize = ArraySize(tmpArray);
     ArrayResize(tmpArray,oldSize+size);
     ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
   }

   p = (MathRand() % ArraySize(tmpArray));
   
   string pair = tmpArray[p];

   //-- Pivots, Support/Resistance and Price Alerts
   //get_pivots(symbol, timeframe);
   get_NearestAndFarestSR(pair, 0, (iLow(pair, 0, Current + 1)+iHigh(pair, 0, Current + 1))/2.0 );
   //---
   
  //------------------------------------------------------------------------------------------
   if (DrawLines)
   {
   //--- Draw Pivot lines on chart
      if(ObjectFind("Nearest_Support label") == 0) ObjectDelete("Nearest_Support label");
       ObjectCreate("Nearest_Support label", OBJ_TEXT, 0, Time[0], nearest_support);
       ObjectSetText("Nearest_Support label", "Nearest Support @ " +DoubleToStr((iLow(pair, 0, Current + 1)+iHigh(pair, 0, Current + 1))/2.0,4)+ " -> " +DoubleToStr(nearest_support,4), 8, "Arial", EMPTY);
      if(ObjectFind("Nearest_Support line") != 0)
      {
         ObjectCreate("Nearest_Support line", OBJ_HLINE, 0, Time[0], nearest_support);
         ObjectSet("Nearest_Support line", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("Nearest_Support line", OBJPROP_WIDTH,2);
         ObjectSet("Nearest_Support line", OBJPROP_COLOR, Blue);
      }
      else
      {
         ObjectMove("Nearest_Support line", 0, Time[40], nearest_support);
      }
   //-----
      if(ObjectFind("Nearest_Resistance label") == 0) ObjectDelete("Nearest_Resistance label");
       ObjectCreate("Nearest_Resistance label", OBJ_TEXT, 0, Time[0], nearest_resistance);
       ObjectSetText("Nearest_Resistance label", "Nearest Resistance @ " +DoubleToStr((iLow(pair, 0, Current + 1)+iHigh(pair, 0, Current + 1))/2.0,4)+ " -> " +DoubleToStr(nearest_resistance,4), 8, "Arial", EMPTY);
      if(ObjectFind("Nearest_Resistance line") != 0)
      {
         ObjectCreate("Nearest_Resistance line", OBJ_HLINE, 0, Time[0], nearest_resistance);
         ObjectSet("Nearest_Resistance line", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("Nearest_Resistance line", OBJPROP_WIDTH,2);
         ObjectSet("Nearest_Resistance line", OBJPROP_COLOR, Red);
      }
      else
      {
         ObjectMove("Nearest_Resistance line", 0, Time[40], nearest_resistance);
      }
   //-----
      if(ObjectFind("Nearest_Daily_Support label") == 0) ObjectDelete("Nearest_Daily_Support label");
       ObjectCreate("Nearest_Daily_Support label", OBJ_TEXT, 0, Time[0], nearest_daily_support);
       ObjectSetText("Nearest_Daily_Support label", "Nearest Daily Support @ " +DoubleToStr((iLow(pair, 0, Current + 1)+iHigh(pair, 0, Current + 1))/2.0,4)+ " -> " +DoubleToStr(nearest_daily_support,4), 8, "Arial", EMPTY);
      if(ObjectFind("Nearest_Daily_Support line") != 0)
      {
         ObjectCreate("Nearest_Daily_Support line", OBJ_HLINE, 0, Time[0], nearest_daily_support);
         ObjectSet("Nearest_Daily_Support line", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("Nearest_Daily_Support line", OBJPROP_WIDTH,2);
         ObjectSet("Nearest_Daily_Support line", OBJPROP_COLOR, LightBlue);
      }
      else
      {
         ObjectMove("Nearest_Daily_Support line", 0, Time[40], nearest_daily_support);
      }
   //-----
      if(ObjectFind("Nearest_Daily_Resistance label") == 0) ObjectDelete("Nearest_Daily_Resistance label");
       ObjectCreate("Nearest_Daily_Resistance label", OBJ_TEXT, 0, Time[0], nearest_daily_resistance);
       ObjectSetText("Nearest_Daily_Resistance label", "Nearest Daily Resistance @ " +DoubleToStr((iLow(pair, 0, Current + 1)+iHigh(pair, 0, Current + 1))/2.0,4)+ " -> " +DoubleToStr(nearest_daily_resistance,4), 8, "Arial", EMPTY);
      if(ObjectFind("Nearest_Daily_Resistance line") != 0)
      {
         ObjectCreate("Nearest_Daily_Resistance line", OBJ_HLINE, 0, Time[0], nearest_daily_resistance);
         ObjectSet("Nearest_Daily_Resistance line", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("Nearest_Daily_Resistance line", OBJPROP_WIDTH,2);
         ObjectSet("Nearest_Daily_Resistance line", OBJPROP_COLOR, LightPink);
      }
      else
      {
         ObjectMove("Nearest_Daily_Resistance line", 0, Time[40], nearest_daily_resistance);
      }
   //-----
      WindowRedraw();
   //-----
   }
  //------------------------------------------------------------------------------------------

   // expert open orders
   if (TradeAllowed == TRUE && Cnt < MaximumNumberTrades)
   {
      for (i = 0; i < (MaximumNumberTrades - Cnt); i++)
      {
         for (int t = 0; t < OpenNewTradesDelay; t++)
         {
            Sleep(1000);
         }

         while (!IsTradeAllowed()) Sleep(100);
         RefreshRates();

         bool actionDone = FALSE;
         
         // START: WHILE action done
         //while(actionDone == FALSE)
         //{
            pair = "";
            
			   //_BuyRandomPair
            actionDone = Action_BuyRandomPair();
			   if (actionDone == TRUE) {continue;}
			
			   //_SellRandomPair
			   actionDone = Action_SellRandomPair();
			   if (actionDone == TRUE) {continue;}

			   //_BuyOrSellRandomPair
			   actionDone = Action_BuyOrSellPair();
			   if (actionDone == TRUE) {continue;}
			
			   //_BestSwapRandomPair
			   actionDone = Action_BestSwapRandomPair();
			   if (actionDone == TRUE) {continue;}

			   //_WorstSwapRandomPair
			   actionDone = Action_WorstSwapRandomPair();
			   if (actionDone == TRUE) {continue;}

/* ----------------------------------------------------------------- */
// _NarrowSprd
/* ----------------------------------------------------------------- */
			   //_BuyPairNarrowSprd
			   actionDone = Action_BuyPairNarrowSprd();
			   if (actionDone == TRUE) {continue;}

			   //_SellPairNarrowSprd
			   actionDone = Action_SellPairNarrowSprd();
			   if (actionDone == TRUE) {continue;}

			   //_BuyOrSellPairNarrowSprd
			   actionDone = Action_BuyOrSellPairNarrowSprd();
			   if (actionDone == TRUE) {continue;}
            
			   //_BestSwapPairNarrowSprd
			   actionDone = Action_BestSwapPairNarrowSprd();
			   if (actionDone == TRUE) {continue;}

			   //_WorstSwapPairNarrowSprd
			   actionDone = Action_WorstSwapPairNarrowSprd();
			   if (actionDone == TRUE) {continue;}

/* ----------------------------------------------------------------- */
// _WideSprd
/* ----------------------------------------------------------------- */
			   //_BuyPairWideSprd
			   actionDone = Action_BuyPairWideSprd();
			   if (actionDone == TRUE) {continue;}

			   //_SellPairWideSprd
			   actionDone = Action_SellPairWideSprd();
			   if (actionDone == TRUE) {continue;}

			   //_BuyOrSellPairWideSprd
			   actionDone = Action_BuyOrSellPairWideSprd();
			   if (actionDone == TRUE) {continue;}
            
			   //_BestSwapPairWideSprd
			   actionDone = Action_BestSwapPairWideSprd();
			   if (actionDone == TRUE) {continue;}

			   //_WorstSwapPairWideSprd
			   actionDone = Action_WorstSwapPairWideSprd();
			   if (actionDone == TRUE) {continue;}
	      //}
	      
	      //if (actionDone == TRUE)
	      //{ break; }
      }
   }

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| ??????? ?????????? ?????? ????????? ????????                     |
//+------------------------------------------------------------------+
int SymbolsList(string &Symbols[], bool Selected)
{
   string SymbolsFileName;
   int Offset, SymbolsNumber;
   
   if(Selected) SymbolsFileName = "symbols.sel";
   else         SymbolsFileName = "symbols.raw";
   
// ????????? ???? ? ????????? ????????
 
   int hFile = FileOpenHistory(SymbolsFileName, FILE_BIN|FILE_READ);
   if(hFile < 0) return(-1);
 
// ?????????? ?????????? ????????, ?????????????????? ? ?????
 
   if(Selected) { SymbolsNumber = (FileSize(hFile) - 4) / 128; Offset = 116;  }
   else         { SymbolsNumber = FileSize(hFile) / 1936;      Offset = 1924; }
 
   ArrayResize(Symbols, SymbolsNumber);
 
// ????????? ??????? ?? ?????
 
   if(Selected) FileSeek(hFile, 4, SEEK_SET);
   
   for(int i = 0; i < SymbolsNumber; i++)
   {
      Symbols[i] = FileReadString(hFile, 12);
      FileSeek(hFile, Offset, SEEK_CUR);
   }
   
   FileClose(hFile);
   
// ?????????? ?????????? ????????? ????????????
 
   return(SymbolsNumber);
}
 
//+------------------------------------------------------------------+
//| ??????? ?????????? ?????????????? ???????? ???????               |
//+------------------------------------------------------------------+
string SymbolDescription(string SymbolName)
{
   string SymbolDescription = "";
   
// ????????? ???? ? ????????? ????????
 
   int hFile = FileOpenHistory("symbols.raw", FILE_BIN|FILE_READ);
   if(hFile < 0) return("");
 
// ?????????? ?????????? ????????, ?????????????????? ? ?????
 
   int SymbolsNumber = FileSize(hFile) / 1936;
 
// ???? ??????????? ??????? ? ?????
 
   for(int i = 0; i < SymbolsNumber; i++)
   {
      if(FileReadString(hFile, 12) == SymbolName)
      {
         SymbolDescription = FileReadString(hFile, 64);
         break;
      }
      FileSeek(hFile, 1924, SEEK_CUR);
   }
   
   FileClose(hFile);
   
   return(SymbolDescription);
}
 
//+------------------------------------------------------------------+
//| ??????? ?????????? ??? ???????????                               |
//+------------------------------------------------------------------+
string SymbolType(string SymbolName)
{
   int GroupNumber = -1;
   string SymbolGroup = "";
   
// ????????? ???? ? ????????? ????????
 
   int hFile = FileOpenHistory("symbols.raw", FILE_BIN|FILE_READ);
   if(hFile < 0) return("");
   
// ?????????? ?????????? ????????, ?????????????????? ? ?????
   
   int SymbolsNumber = FileSize(hFile) / 1936;
   
// ???? ?????? ? ?????
   
   for(int i = 0; i < SymbolsNumber; i++)
   {
      if(FileReadString(hFile, 12) == SymbolName)
      {
      // ?????????? ????? ??????
         
         FileSeek(hFile, 1936*i + 100, SEEK_SET);
         GroupNumber = FileReadInteger(hFile);
         
         break;
      }
      FileSeek(hFile, 1924, SEEK_CUR);
   }
   
   FileClose(hFile);
   
   if(GroupNumber < 0) return("");
   
// ????????? ???? ? ????????? ?????
   
   hFile = FileOpenHistory("symgroups.raw", FILE_BIN|FILE_READ);
   if(hFile < 0) return("");
   
   FileSeek(hFile, 80*GroupNumber, SEEK_SET);
   SymbolGroup = FileReadString(hFile, 16);
   
   FileClose(hFile);
   
   return(SymbolGroup);
}
//+------------------------------------------------------------------+
double LOT(string symbol)
{
    double MML;
    int mmul;
    if (MarketInfo(symbol, MODE_DIGITS) == 3 || MarketInfo(symbol, MODE_DIGITS) == 5) mmul = 10;
    else mmul = 1;

    // expert money management
    if (AutomaticLotSize==TRUE) {
      if (Risk < 0.1 || Risk > 100) {
          Comment("Invalid Risk Value.");
          return (0);
      } else {
          double new_rr = Risk;
          if ( AccountLeverage()>100)
          {
             new_rr = Risk/(AccountLeverage()/100);
          }
          double new_bal = AccountBalance();
          if (VirtualBalance>0)
          {
             new_bal  = VirtualBalance;
             int rr_mul = MathAbs(AccountFreeMargin()/VirtualBalance);
             new_rr   = new_rr + rr_mul;
          }
          MML = MathFloor( (new_bal * AccountLeverage() * new_rr * pointvalue * 100) / (MarketInfo(symbol,MODE_ASK) * MarketInfo(symbol, MODE_LOTSIZE) * MarketInfo(symbol, MODE_MINLOT)) ) * (MarketInfo(symbol, MODE_MINLOT));

          double MINLOT = MarketInfo(symbol,MODE_MINLOT);

          if (MML>MarketInfo(symbol,MODE_MAXLOT)) {MML = MarketInfo(symbol,MODE_MAXLOT); }
          if (MML<MINLOT) { MML = MINLOT; }
          if (MINLOT<0.1) { MML = NormalizeDouble(MML,2);} else {MML = NormalizeDouble(MML,1); }
       }
    }
    if (AutomaticLotSize == FALSE) {
        MML = Lots;
    }

   if (AdjustLotSizeForPrice==TRUE)
   {
      if (MarketInfo(symbol, MODE_BID) != 0)
      {
         MML = MML / MarketInfo(symbol, MODE_BID);
      }
   }
   else if (AdjustLotSizeForPipValue==TRUE)
   {
      if (MarketInfo(symbol, MODE_TICKVALUE) != 0)
      {
         MML = MML / MarketInfo(symbol, MODE_TICKVALUE);
      }
   }

   if (MML>MarketInfo(symbol,MODE_MAXLOT)) {MML = MarketInfo(symbol,MODE_MAXLOT); }
   if (MML<MINLOT) { MML = MINLOT; }
   if (MINLOT<0.1) { MML = NormalizeDouble(MML,2);} else {MML = NormalizeDouble(MML,1); }
    
   if(MarketInfo(symbol, MODE_LOTSTEP) == 0.01){return(NormalizeDouble(MML,2));}
   else if(MarketInfo(symbol, MODE_LOTSTEP) == 0.1){return(NormalizeDouble(MML,1));}
   else {
      double otherStep = MathMod(MML, MarketInfo(symbol, MODE_LOTSTEP));
      return(MML-otherStep);
   }
}
//---------------------------------------------------------------------------
bool CheckCurrentTimeAfter(string sTaim, string sTaimBefore, int ttDD)
{
   int HH=TimeHour(TimeCurrent());     // Hour
   int MM=TimeMinute(TimeCurrent());   // Minute
   int DD=TimeDayOfWeek(TimeCurrent());      // Day   

   datetime tt = StrToTime(sTaim);
   int ttHH=TimeHour(tt);     // Hour
   int ttMM=TimeMinute(tt);   // Minute
   
   datetime ttBefore = StrToTime(sTaimBefore);
   int ttHHBefore=TimeHour(ttBefore);     // Hour
   int ttMMBefore=TimeMinute(ttBefore);   // Minute
   
   bool later = FALSE;

   if (ttHH < ttHHBefore)
   {
      later = ((DD > ttDD)||(HH >= ttHH && MM >= ttMM));
   }
   else
   {
      if (ttDD == DD)
      {
         later = FALSE;
      }
      else if (ttDD < DD)
      {
         later = (HH >= ttHH && MM >= ttMM);
      }
   }
   
   return (later);
}
bool CheckCurrentTimeBefore(string sTaim)
{
   int HH=TimeHour(TimeCurrent());     // Hour
   int MM=TimeMinute(TimeCurrent());   // Minute
      
   datetime tt = StrToTime(sTaim);
   int ttHH=TimeHour(tt);     // Hour
   int ttMM=TimeMinute(tt);   // Minute
   
   return (HH <= ttHH && MM <= ttMM);
}
//+------------------------------------------------------------------+
int StringFindCount(string str, string str2)
//+------------------------------------------------------------------+
// Returns the number of occurrences of STR2 in STR
// Usage:   int x = StringFindCount("ABCDEFGHIJKABACABB","AB")   returns x = 3
{
  int c = 0;
  for (int i=0; i<StringLen(str); i++)
    if (StringSubstr(str,i,StringLen(str2)) == str2)  c++;
  return(c);
}
//+------------------------------------------------------------------+
int StrToStringArray(string str, string &a[], string delim=",", string init="")  {
//+------------------------------------------------------------------+
// Breaks down a single string into string array 'a' (elements delimited by 'delim')
  for (int i=0; i<ArraySize(a); i++)
    a[i] = init;
  if (str == "")  return(0);  
  int z1=-1, z2=0;
  if (StringRight(str,1) != delim)  str = str + delim;
  for (i=0; i<ArraySize(a); i++)  {
    z2 = StringFind(str,delim,z1+1);
    if (z2>z1+1)  a[i] = StringSubstr(str,z1+1,z2-z1-1);
    if (z2 >= StringLen(str)-1)   break;
    z1 = z2;
  }
  return(StringFindCount(str,delim));
}
//+------------------------------------------------------------------+
string StringTrim(string str)
//+------------------------------------------------------------------+
// Removes all spaces (leading, traing embedded) from a string
// Usage:    string x=StringUpper("The Quick Brown Fox")  returns x = "TheQuickBrownFox"
{
  string outstr = "";
  for(int i=0; i<StringLen(str); i++)  {
    if (StringSubstr(str,i,1) != " ")
      outstr = outstr + StringSubstr(str,i,1);
  }
  return(outstr);
}
//+------------------------------------------------------------------+
string StringRight(string str, int n=1)
//+------------------------------------------------------------------+
// Returns the rightmost N characters of STR, if N is positive
// Usage:    string x=StringRight("ABCDEFG",2)  returns x = "FG"
//
// Returns all but the leftmost N characters of STR, if N is negative
// Usage:    string x=StringRight("ABCDEFG",-2)  returns x = "CDEFG"
{
  if (n > 0)  return(StringSubstr(str,StringLen(str)-n,n));
  if (n < 0)  return(StringSubstr(str,-n,StringLen(str)-n));
  return("");
}
//+------------------------------------------------------------------+
string chrToStr(int arr[])
{
   string strOut = "";
   for (int cc = 0; cc < ArraySize(arr); cc++)
   {
      strOut = strOut + characters[arr[cc]];
   }
   return(strOut);
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
// expert select pair
//+------------------------------------------------------------------+
bool OrderOnPairAlreadyPlaced(string symbol)
	{
		bool res = FALSE;
		
		Total = OrdersTotal();
		for (int i = Total-1; i >= 0; i--)
		{
		  if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
		  {
			 if (OrderMagicNumber() == Magic)
			 {
				Pos = OrderType();
				if (OrderSymbol() == symbol && ((Pos == OP_BUY) || (Pos == OP_SELL)))
				{
					res = TRUE;
					return(res);
				}
			 }
		  }
		}
		
		return(res);
	}

bool OrderOnPairAndPosAlreadyPlaced(string symbol, int pos, string str)
	{
	   int ordersCnt = 0;
	   
		string orderComment;
		RefreshRates();
		Total = OrdersTotal();
		for (int i = Total-1; i >= 0; i--)
		{
		  if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
		  {
			 if (OrderMagicNumber() == Magic)
			 {
		      orderComment = OrderComment();
				Pos = OrderType();
				  if (OrderSymbol() == symbol)
				  {
				     if (IsTesting()==TRUE)
				     {
				        if ((Pos == pos)/*||(StringFind(orderComment,str)>=0)*/)
				        {
					        ordersCnt++;
				        }
				     }
				     else
				     {
				        if ((Pos == pos)/*&&(StringFind(orderComment,str)>=0)*/)
				        {
					        ordersCnt++;
				        }
				     }
				  }
			 }
		  }
		}

		return(ordersCnt>0);
	}

bool CloseAllWinningOrders()
	{
		bool res = FALSE;
		
		Total = OrdersTotal();
		for (int i = Total-1; i >= 0; i--)
		{
		  if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
		  {
			 if (OrderMagicNumber() == Magic)
			 {
				Pos = OrderType();
				double orderProfit = OrderProfit()+OrderSwap()+OrderCommission();
				if (orderProfit>=0&&(Pos == OP_BUY) || (Pos == OP_SELL))
				{
               if(PrintErrors) Print("Closing WINNING Order#",OrderTicket(), " due to expiration time: open time#", TimeToStr(OrderOpenTime(),TIME_DATE|TIME_MINUTES), " - now#", TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES));
               if (Pos == OP_BUY)
               {
                  if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, CLR_NONE) == TRUE)
                  {
                     res = TRUE;
                  }
                  else
                  {
                     res = FALSE;
                  }
               }
               else if (Pos == OP_SELL)
               {
                  if(OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, CLR_NONE) == TRUE)
                  {
                     res = TRUE;
                  }
                  else
                  {
                     res = FALSE;
                  }
               }
               
               if (res == FALSE && PrintErrors == TRUE) Print("ERROR Closing WINNING Order#",OrderTicket(), " due to expiration time: open time#", TimeToStr(OrderOpenTime(),TIME_DATE|TIME_MINUTES), " - now#", TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES));
				}
			 }
		  }
		}
		
		return(res);
	}

datetime getLatestClosedOrderWSamePair(string pair)
	{
	   datetime latestPairTime = NULL;
		
      Total = OrdersHistoryTotal();
      for (int i = Total-1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == TRUE) 
         {
            if (OrderMagicNumber() == Magic)
            {
               if (OrderSymbol() == pair)
               {
                  Pos = OrderType();
                  if ((Pos == OP_BUY) || (Pos == OP_SELL)) 
                  {
                     if (latestPairTime==NULL || latestPairTime<OrderCloseTime())
                     {
                        latestPairTime = OrderCloseTime();
                     }
                  }
               }
            }
         }
      }
		
		return(latestPairTime);
	}

bool getClosedOrderLastPeriod(string pair, int period, int pos, string strategy)
   {
	   datetime latestPairTime = 0;
		
		string orderComment;
      Total = OrdersHistoryTotal();
      for (int i = Total-1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) == TRUE) 
         {
            if (OrderMagicNumber() == Magic)
            {
               if (OrderSymbol() == pair)
               {
                  orderComment = OrderComment();
                  Pos = OrderType();
                  if (IsTesting()==TRUE)
                  {
                     if (((Pos == OP_BUY) || (Pos == OP_SELL)) && ((Pos == pos) && (StringFind(orderComment,strategy)>0)) )
                     {
                        if (latestPairTime==0 || latestPairTime<OrderCloseTime())
                        {
                           latestPairTime = OrderCloseTime();
                        }
                     }
                  }
                  else
                  {
                     if (((Pos == OP_BUY) || (Pos == OP_SELL)) && (Pos == pos) && (StringFind(orderComment,strategy)>0) )
                     {
                        if (latestPairTime==0 || latestPairTime<OrderCloseTime())
                        {
                           latestPairTime = OrderCloseTime();
                        }
                     }
                  }
               }
            }
         }
      }
		
		int bbClosedShift = iBarShift(pair,period,latestPairTime);
		if (bbClosedShift==1) return(TRUE);
		
		latestPairTime = 0;
		
      Total = OrdersTotal();
      for (i = Total-1; i >= 0; i--)
      {
         if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
         {
            if (OrderMagicNumber() == Magic)
            {
               if (OrderSymbol() == pair)
               {
                  orderComment = OrderComment();
                  Pos = OrderType();
                  if (IsTesting()==TRUE)
                  {
                     if (((Pos == OP_BUY) || (Pos == OP_SELL)) && ((Pos == pos) && (StringFind(orderComment,strategy)>0)) )
                     {
                        if (latestPairTime==0 || latestPairTime<OrderCloseTime())
                        {
                           latestPairTime = OrderCloseTime();
                        }
                     }
                  }
                  else
                  {
                     if (((Pos == OP_BUY) || (Pos == OP_SELL)) && (Pos == pos) && (StringFind(orderComment,strategy)>0) )
                     {
                        if (latestPairTime==0 || latestPairTime<OrderCloseTime())
                        {
                           latestPairTime = OrderCloseTime();
                        }
                     }
                  }
               }
            }
         }
      }

		int bbOpenedShift = iBarShift(pair,period,latestPairTime);
		if(bbOpenedShift==1) return(TRUE);
		
		return(FALSE);
   }

string getPairWLowestBuySwap(string pairsArray[])
	{
		string pairWLowestBuySwap;
		double minLastSwapLong = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapLong   = MarketInfo(pairsArray[pp], MODE_SWAPLONG);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (minLastSwapLong == 0 || swapLong <= minLastSwapLong))
		   {
			  minLastSwapLong = swapLong;
			  pairWLowestBuySwap = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWLowestBuySwap)>0)
		{
			return(pairWLowestBuySwap);
		}
		else
		{
			return("");
		}
		
		return(pairWLowestBuySwap);
	}
	
string getPairWLowestSellSwap(string pairsArray[])
	{
		string pairWLowestSellSwap;
		double minLastSwapShort = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapShort  = MarketInfo(pairsArray[pp], MODE_SWAPSHORT);
		   
		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (minLastSwapShort == 0 || swapShort <= minLastSwapShort))
		   {
			  minLastSwapShort = swapShort;
			  pairWLowestSellSwap = pairsArray[pp];
		   }
		}

		if (StringLen(pairWLowestSellSwap)>0)
		{
			return(pairWLowestSellSwap);
		}
		else
		{
			return("");
		}
		   
		return(pairWLowestSellSwap);
	}
	
string getPairWHighestBuySwap(string pairsArray[])
	{
		string pairWHighestBuySwap;
		double maxLastSwapLong = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapLong   = MarketInfo(pairsArray[pp], MODE_SWAPLONG);
		   
		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (maxLastSwapLong == 0 || swapLong >= maxLastSwapLong))
		   {
			  maxLastSwapLong = swapLong;
			  pairWHighestBuySwap = pairsArray[pp];
		   }
		}
		
		if (StringLen(pairWHighestBuySwap)>0)
		{
			return(pairWHighestBuySwap);
		}
		else
		{
			return("");
		}
		return(pairWHighestBuySwap);
	}
	
string getPairWHighestSellSwap(string pairsArray[])
	{
		string pairWHighestSellSwap;
		double maxLastSwapShort = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapShort  = MarketInfo(pairsArray[pp], MODE_SWAPSHORT);
		   
		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (maxLastSwapShort == 0 || swapShort >= maxLastSwapShort))
		   {
			  maxLastSwapShort = swapShort;
			  pairWHighestSellSwap = pairsArray[pp];
		   }
		}
		
		if (StringLen(pairWHighestSellSwap)>0)
		{
			return(pairWHighestSellSwap);
		}
		else
		{
			return("");
		}
		return(pairWHighestSellSwap);
	}

string getPairWLowestBuySwapNrowSpread(string pairsArray[])
	{
		string pairWLowestBuySwapNrowSpread;
		double minLastSwapLong = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapLong   = MarketInfo(pairsArray[pp], MODE_SWAPLONG);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (minLastSwapLong == 0 || swapLong <= minLastSwapLong) && (latestSpread == 0 || spread <= latestSpread))
		   {
			  minLastSwapLong = swapLong;
			  pairWLowestBuySwapNrowSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWLowestBuySwapNrowSpread)>0)
		{
			return(pairWLowestBuySwapNrowSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWLowestBuySwapNrowSpread);
	}

string getPairWLowstSellSwapNrowSpread(string pairsArray[])
	{
		string pairWLowestSellSwapNrowSpread;
		double minLastSwapShort = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapShort  = MarketInfo(pairsArray[pp], MODE_SWAPSHORT);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (minLastSwapShort == 0 || swapShort <= minLastSwapShort) && (latestSpread == 0 || spread <= latestSpread))
		   {
			  minLastSwapShort = swapShort;
			  pairWLowestSellSwapNrowSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWLowestSellSwapNrowSpread)>0)
		{
			return(pairWLowestSellSwapNrowSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWLowestSellSwapNrowSpread);
	}

string getPairWHighstBuySwapNrowSprd(string pairsArray[])
	{
		string pairWHighestBuySwapNrowSpread;
		double maxLastSwapLong = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapLong   = MarketInfo(pairsArray[pp], MODE_SWAPLONG);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (maxLastSwapLong == 0 || swapLong >= maxLastSwapLong) && (latestSpread == 0 || spread <= latestSpread))
		   {
			  maxLastSwapLong = swapLong;
			  pairWHighestBuySwapNrowSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWHighestBuySwapNrowSpread)>0)
		{
			return(pairWHighestBuySwapNrowSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWHighestBuySwapNrowSpread);
	}

string getPairWHighstSellSwapNrowSprd(string pairsArray[])
	{
		string pairWHighestSellSwapNrowSpread;
		double maxLastSwapShort = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapShort  = MarketInfo(pairsArray[pp], MODE_SWAPSHORT);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (maxLastSwapShort == 0 || swapShort >= maxLastSwapShort) && (latestSpread == 0 || spread <= latestSpread))
		   {
			  maxLastSwapShort = swapShort;
			  pairWHighestSellSwapNrowSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWHighestSellSwapNrowSpread)>0)
		{
			return(pairWHighestSellSwapNrowSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWHighestSellSwapNrowSpread);
	}

string getPairWLowestBuySwapWideSpread(string pairsArray[])
	{
		string pairWLowestBuySwapWideSpread;
		double minLastSwapLong = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapLong   = MarketInfo(pairsArray[pp], MODE_SWAPLONG);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (minLastSwapLong == 0 || swapLong <= minLastSwapLong) && (latestSpread == 0 || spread >= latestSpread))
		   {
			  minLastSwapLong = swapLong;
			  pairWLowestBuySwapWideSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWLowestBuySwapWideSpread)>0)
		{
			return(pairWLowestBuySwapWideSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWLowestBuySwapWideSpread);
	}

string getPairWLowstSellSwapWideSprd(string pairsArray[])
	{
		string pairWLowestSellSwapWideSpread;
		double minLastSwapShort = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapShort  = MarketInfo(pairsArray[pp], MODE_SWAPSHORT);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (minLastSwapShort == 0 || swapShort <= minLastSwapShort) && (latestSpread == 0 || spread >= latestSpread))
		   {
			  minLastSwapShort = swapShort;
			  pairWLowestSellSwapWideSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWLowestSellSwapWideSpread)>0)
		{
			return(pairWLowestSellSwapWideSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWLowestSellSwapWideSpread);
	}

string getPairWHighstBuySwapWideSprd(string pairsArray[])
	{
		string pairWHighestBuySwapWideSpread;
		double maxLastSwapLong = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapLong   = MarketInfo(pairsArray[pp], MODE_SWAPLONG);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (maxLastSwapLong == 0 || swapLong >= maxLastSwapLong) && (latestSpread == 0 || spread >= latestSpread))
		   {
			  maxLastSwapLong = swapLong;
			  pairWHighestBuySwapWideSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWHighestBuySwapWideSpread)>0)
		{
			return(pairWHighestBuySwapWideSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWHighestBuySwapWideSpread);
	}

string getPairWHighstSellSwapWideSprd(string pairsArray[])
	{
		string pairWHighestSellSwapWideSpread;
		double maxLastSwapShort = 0;
		latestSpread = 0;
		for (int pp = 0; pp < ArraySize(pairsArray); pp++)
		{
		   double swapShort  = MarketInfo(pairsArray[pp], MODE_SWAPSHORT);
		   spread = MarketInfo(pairsArray[pp], MODE_ASK) - MarketInfo(pairsArray[pp], MODE_BID);

		   skipPair = FALSE;
		   if (AllowMultiplePurchaseOfPair == FALSE)
		   {
				skipPair = OrderOnPairAlreadyPlaced(pairsArray[pp]);
		   }
		   if (skipPair == FALSE && (maxLastSwapShort == 0 || swapShort >= maxLastSwapShort) && (latestSpread == 0 || spread >= latestSpread))
		   {
			  maxLastSwapShort = swapShort;
			  pairWHighestSellSwapWideSpread = pairsArray[pp];			  
		   }
		}
		
		if (StringLen(pairWHighestSellSwapWideSpread)>0)
		{
			return(pairWHighestSellSwapWideSpread);
		}
		else
		{
			return("");
		}
		
		return(pairWHighestSellSwapWideSpread);
	}
	
//+------------------------------------------------------------------+
// Trade Actions
//+------------------------------------------------------------------+
bool Action_BuyRandomPair()
	{
		// START_Action : _BuyRandomPair
		if(_BuyRandomPair == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyRandomPair no pair found on pairsToBuyArray.");
				return(TRUE);
		   }
		   
		   // randomly select pair to Buy
		   ArrayResize(tmpArray,0);
		   if (ArraySize(pairsToBuyArray) > 0)
		   {
			  size = ArraySize(pairsToBuyArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyArray,oldSize,0,WHOLE_ARRAY);
		   }
		   /*if (ArraySize(pairsToBuyAndSellArray) > 0)
		   {
			  size = ArraySize(pairsToBuyAndSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
		   }*/
		   
	       p = (MathRand() % ArraySize(tmpArray));
	   
	       if (AllowMultiplePurchaseOfPair == FALSE)
		     {
			    if(OrderOnPairAlreadyPlaced(tmpArray[p]))
			    {
				    if(PrintErrors) Print("WARNING - "+EA_NAME+" Trader : Action_BuyRandomPair random pair ", tmpArray[p], " not allowed to trade. Orders already placed.");
				    return(TRUE);
			    }
		     }
		  
	       return(OpenOrderBuy(tmpArray[p]));
		}
		// END_Action : _BuyRandomPair
		return(FALSE);
	}
	
bool Action_SellRandomPair()
	{
		// START_Action : _SellRandomPair
		if(_SellRandomPair == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_SellRandomPair no pair found on pairsToSellArray.");
				return(TRUE);
		   }
		   
		   // randomly select pair to Sell
		   ArrayResize(tmpArray,0);
		   if (ArraySize(pairsToSellArray) > 0)
		   {
			  size = ArraySize(pairsToSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToSellArray,oldSize,0,WHOLE_ARRAY);
		   }
		   /*if (ArraySize(pairsToBuyAndSellArray) > 0)
		   {
			  size = ArraySize(pairsToBuyAndSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
		   }*/
   
	       p = (MathRand() % ArraySize(tmpArray));

	       if (AllowMultiplePurchaseOfPair == FALSE)
		     {
			    if(OrderOnPairAlreadyPlaced(tmpArray[p]))
			    {
				    if(PrintErrors) Print("WARNING - "+EA_NAME+" Trader : Action_SellRandomPair random pair ", tmpArray[p], " not allowed to trade. Orders already placed.");
				    return(TRUE);
			    }
		     }
	   
	       return(OpenOrderSell(tmpArray[p]));
		}
		// END_Action : _SellRandomPair	
		return(FALSE);
	}
	 
bool Action_BuyOrSellPair()
	{
		// START_Action : _BuyOrSellRandomPair
		if(_BuyOrSellPair == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellRandomPair no pair found on pairsToBuyOrSellArray.");
				return(TRUE);
		   }
		   
	       //randSignal = MathRand() % 2;
	       randSignal = 0;
	       
	       // Buy
	       if (randSignal == 0)
	       {
//------
	    /*
            //+------------------------------------------------------------------+
            //| Variable Begin                                                   |
            //+------------------------------------------------------------------+
            
            double Buy1_1 = iClose(pair, 0, Current + 1);
            double Buy1_2 = iHigh(pair, 0, Current + 2);
            double Buy2_1 = iClose(pair, 0, Current + 0);
            double Buy2_2 = iHigh(pair, 0, Current + 1);
            double Buy3_1 = iClose(pair, 0, Current + 0);
            double Buy3_2 = iHigh(pair, 0, Current + 2);
            
            //+------------------------------------------------------------------+
            //| Variable End                                                     |
            //+------------------------------------------------------------------+
            
            if(Buy1_1 <= Buy1_2 && Buy2_1 > Buy2_2 && Buy3_1 > Buy3_2) {
				    if(OrderOnPairAlreadyPlaced(pair) && AllowMultiplePurchaseOfPair == FALSE)
				    {
					    if(PrintErrors) Print("WARNING - "+EA_NAME+" Trader : Action_BuyOrSellRandomPair random pair ", pair, " not allowed to trade. Orders already placed.");
					    return(TRUE);
				    }
				    
				    
		         return(OpenOrderBuy(pair,true));
            }
       */

            //+------------------------------------------------------------------+
            //| Variable Begin                                                   |
            //+------------------------------------------------------------------+
            double Buy1_1 = iMA(pair, 0, 50, 0, MODE_EMA, PRICE_CLOSE, Current + 0);
            double Buy1_2 = iMACD(pair, 0, 8, 17, 9, PRICE_CLOSE, MODE_MAIN, Current + 0);
            double Buy2_1 = iRSI(pair, 0, 15, PRICE_CLOSE, Current + 0);
            double Buy2_2 = iOpen(pair, 0, Current + 0);
            double Buy3_1 = iClose(pair, 0, Current + 0);
            double Buy3_2 = MarketInfo(pair, MODE_BID);
                        
            double nearest_broken_pivot = EMPTY_VALUE;
            
            if (Buy2_2 < nearest_resistance && Buy3_1 > nearest_resistance) {
               nearest_broken_pivot = nearest_resistance;
            } else if (nearest_broken_pivot == EMPTY_VALUE && Buy2_2 < nearest_support && Buy3_1 > nearest_support) {
               nearest_broken_pivot = nearest_resistance;
            }
            
            /*if (nearest_broken_pivot == EMPTY_VALUE && Buy2_2 < nearest_daily_resistance && Buy3_1 > nearest_daily_resistance) {
               nearest_broken_pivot = nearest_resistance;
            }*/
            
            //+------------------------------------------------------------------+
            //| Variable End                                                     |
            //+------------------------------------------------------------------+

            if(
               //iClose(pair, 0, Current + 1) <= iHigh(pair, 0, Current + 2) && iClose(pair, 0, Current + 0) > iHigh(pair, 0, Current + 1) && iClose(pair, 0, Current + 0) > iHigh(pair, 0, Current + 2)
               //&&
               Buy3_2 > Buy1_1 && Buy1_2 > 0 && Buy2_1 > 50 && nearest_broken_pivot != EMPTY_VALUE && Buy3_2 > nearest_broken_pivot
              ) {
				    if(OrderOnPairAlreadyPlaced(pair) && AllowMultiplePurchaseOfPair == FALSE)
				    {
					    if(PrintErrors) Print("WARNING - "+EA_NAME+" Trader : Action_BuyOrSellRandomPair random pair ", pair, " not allowed to trade. Orders already placed.");
					    return(TRUE);
				    }
				    
		         return(OpenOrderBuy(pair,true));
            }
//------ 
	       }

          randSignal = 1;
	       // Sell
	       if (randSignal == 1)
	       {
//------
	    /*	   
            //+------------------------------------------------------------------+
            //| Variable Begin                                                   |
            //+------------------------------------------------------------------+
            
            double Sell1_1 = iClose(pair, 0, Current + 1);
            double Sell1_2 = iLow(pair, 0, Current + 2);
            double Sell2_1 = iClose(pair, 0, Current + 0);
            double Sell2_2 = iLow(pair, 0, Current + 1);
            double Sell3_1 = iClose(pair, 0, Current + 0);
            double Sell3_2 = iLow(pair, 0, Current + 2);
            
            //+------------------------------------------------------------------+
            //| Variable End                                                     |
            //+------------------------------------------------------------------+

            if(Sell1_1 >= Sell1_2 && Sell2_1 < Sell2_2 && Sell3_1 < Sell3_2)
            {
				    if(OrderOnPairAlreadyPlaced(pair) && AllowMultiplePurchaseOfPair == FALSE)
				    {
					    if(PrintErrors) Print("WARNING - "+EA_NAME+" Trader : Action_BuyOrSellRandomPair random pair ", pair, " not allowed to trade. Orders already placed.");
					    return(TRUE);
				    }
				    
				    return(OpenOrderSell(pair, true));
            }            
       */
            //+------------------------------------------------------------------+
            //| Variable Begin                                                   |
            //+------------------------------------------------------------------+
            double Sell1_1 = iMA(pair, 0, 50, 0, MODE_EMA, PRICE_CLOSE, Current + 0);
            double Sell1_2 = iMACD(pair, 0, 8, 17, 9, PRICE_CLOSE, MODE_MAIN, Current + 0);
            double Sell2_1 = iRSI(pair, 0, 15, PRICE_CLOSE, Current + 0);
            double Sell2_2 = iOpen(pair, 0, Current + 0);
            double Sell3_1 = iClose(pair, 0, Current + 0);
            double Sell3_2 = MarketInfo(pair, MODE_ASK);
            
            nearest_broken_pivot = EMPTY_VALUE;
            
            if (Sell2_2 > nearest_support && Sell3_1 < nearest_support) {
               nearest_broken_pivot = nearest_support;
            } else if (nearest_broken_pivot == EMPTY_VALUE && Sell2_2 > nearest_resistance && Sell3_1 < nearest_resistance) {
               nearest_broken_pivot = nearest_resistance;
            }
            
            /*if (nearest_broken_pivot == EMPTY_VALUE && Sell2_2 > nearest_daily_resistance && Sell3_1 < nearest_daily_resistance) {
               nearest_broken_pivot = nearest_resistance;
            }*/

            //+------------------------------------------------------------------+
            //| Variable End                                                     |
            //+------------------------------------------------------------------+

            if(
               //iClose(pair, 0, Current + 1) >= iLow(pair, 0, Current + 2) && iClose(pair, 0, Current + 0) < iLow(pair, 0, Current + 1) && iClose(pair, 0, Current + 0) < iLow(pair, 0, Current + 2)
               //&& 
               Sell3_2 < Sell1_1 && Sell1_2 < 0 && Sell2_1 < 50 && nearest_broken_pivot != EMPTY_VALUE && Sell3_2 < nearest_broken_pivot
              ) {
				    if(OrderOnPairAlreadyPlaced(pair) && AllowMultiplePurchaseOfPair == FALSE)
				    {
					    if(PrintErrors) Print("WARNING - "+EA_NAME+" Trader : Action_BuyOrSellRandomPair random pair ", pair, " not allowed to trade. Orders already placed.");
					    return(TRUE);
				    }
				    
				    return(OpenOrderSell(pair, true));
            }
	       }
//------ 
		}
		// END_Action : _BuyOrSellRandomPair
		return(FALSE);
	}

bool Action_BestSwapRandomPair()
	{
		// START_Action : _BestSwapRandomPair
		if(_BestSwapRandomPair == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapRandomPair no pair found on pairsToBuyOrSellArray.");
				return(TRUE);
		   }

		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			   pair = getPairWLowestBuySwap(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapRandomPair no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderBuy(pair));
		   }
		   // Sell
		   else if (randSignal == 1)
		   {
			   pair = getPairWLowestSellSwap(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapRandomPair no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderSell(pair));
		   }
		}
		// END_Action : _BestSwapRandomPair
		return(FALSE);
	}

bool Action_WorstSwapRandomPair()
	{
		// START_Action : _WorstSwapRandomPair
		if(_WorstSwapRandomPair == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapRandomPair no pair found on pairsToBuyOrSellArray.");
				return(TRUE);
		   }
		   
		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			   pair = getPairWHighestBuySwap(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapRandomPair no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderBuy(pair));
		   }
		   // Sell
		   else if (randSignal == 1)
		   {
			   pair = getPairWHighestSellSwap(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapRandomPair no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderSell(pair));
		   }
		}
		// END_Action : _WorstSwapRandomPair
		return(FALSE);
	}

/* -------------------------------------
 * _NarrowSpread
 * -------------------------------------*/
bool Action_BuyPairNarrowSprd()
	{
		// START_Action : _BuyPairNarrowSprd
		if(_BuyPairNarrowSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyPairNarrowSprd no pair found on pairsToBuyArray.");
				return(TRUE);
		   }
		   
		   // randomly select pair to Buy
		   ArrayResize(tmpArray,0);
		   if (ArraySize(pairsToBuyArray) > 0)
		   {
			  size = ArraySize(pairsToBuyArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyArray,oldSize,0,WHOLE_ARRAY);
		   }
		   /*if (ArraySize(pairsToBuyAndSellArray) > 0)
		   {
			  size = ArraySize(pairsToBuyAndSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
		   }*/
		   
		   latestSpread = 0;
		   pair = "";
		   for (int p = 0; p < ArraySize(tmpArray); p++)
		   {
		      skipPair = FALSE;
			  if (AllowMultiplePurchaseOfPair == FALSE)
			  {
				skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
			  }
			  spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
			  if (skipPair == FALSE && (latestSpread == 0 || spread <= latestSpread))
			  {
				 latestSpread = spread;
				 pair = tmpArray[p];
			  }
		   }
		   
		   if (StringLen(pair)>0)
		   {
				return(OpenOrderBuy(pair));
		   }
		   else
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyPairNarrowSprd no suitable pair found on pairsToBuyArray.");
				return(TRUE);
		   }
		}
		// END_Action : _BuyPairNarrowSprd
		return(FALSE);
	}

bool Action_SellPairNarrowSprd()
	{
		// START_Action : _SellPairNarrowSprd
		if(_SellPairNarrowSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_SellPairNarrowSprd no pair found on pairsToSellArray.");
				return(TRUE);
		   }
		   
		   // randomly select pair to Sell
		   ArrayResize(tmpArray,0);
		   if (ArraySize(pairsToSellArray) > 0)
		   {
			  size = ArraySize(pairsToSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToSellArray,oldSize,0,WHOLE_ARRAY);
		   }
		   /*if (ArraySize(pairsToBuyAndSellArray) > 0)
		   {
			  size = ArraySize(pairsToBuyAndSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
		   }*/

		   latestSpread = 0;
		   pair = "";
		   for (int p = 0; p < ArraySize(tmpArray); p++)
		   {
		      skipPair = FALSE;
			  if (AllowMultiplePurchaseOfPair == FALSE)
			  {
				skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
			  }
			  spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
			  if (skipPair == FALSE && (latestSpread == 0 || spread <= latestSpread))
			  {
				 latestSpread = spread;
				 pair = tmpArray[p];
			  }
		   }
		   
		   if (StringLen(pair)>0)
		   {
				return(OpenOrderSell(pair));
		   }
		   else
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_SellPairNarrowSprd no suitable pair found on pairsToSellArray.");
				return(TRUE);
		   }		   
		}
		// END_Action : _SellPairNarrowSprd
		return(FALSE);
	}

bool Action_BuyOrSellPairNarrowSprd()
	{
		// START_Action : _BuyOrSellPairNarrowSprd
		if(_BuyOrSellPairNarrowSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellPairNarrowSprd no pair found on pairsToBuyOrSellArray.");
				return(TRUE);
		   }
		   
		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			  // randomly select pair to Buy
			  ArrayResize(tmpArray,0);
			  if (ArraySize(pairsToBuyAndSellArray) > 0)
			  {
				 size = ArraySize(pairsToBuyAndSellArray);
				 oldSize = ArraySize(tmpArray);
				 ArrayResize(tmpArray,oldSize+size);
				 ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
			  }
		   
			  latestSpread = 0;
			  for (p = 0; p < ArraySize(tmpArray); p++)
			  {
				 skipPair = FALSE;
				 if (AllowMultiplePurchaseOfPair == FALSE)
				 {
					skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
				 }
				 spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
				 if (skipPair == FALSE && (latestSpread == 0 || spread <= latestSpread))
				 {
					latestSpread = spread;
					pair = tmpArray[p];
				 }
			  }
		   
			   if (StringLen(pair)>0)
			   {
				   return(OpenOrderBuy(pair));
			   }
			   else
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellPairNarrowSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
		   }

		   // Sell
		   else if (randSignal == 1)
		   {
			  // randomly select pair to Sell
			  ArrayResize(tmpArray,0);
			  if (ArraySize(pairsToBuyAndSellArray) > 0)
			  {
				 size = ArraySize(pairsToBuyAndSellArray);
				 oldSize = ArraySize(tmpArray);
				 ArrayResize(tmpArray,oldSize+size);
				 ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
			  }
		   
			  latestSpread = 0;
			  for (p = 0; p < ArraySize(tmpArray); p++)
			  {
				 skipPair = FALSE;
				 if (AllowMultiplePurchaseOfPair == FALSE)
				 {
					skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
				 }
				 spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
				 if (skipPair == FALSE && (latestSpread == 0 || spread <= latestSpread))
				 {
					latestSpread = spread;
					pair = tmpArray[p];
				 }
			  }
		   
			   if (StringLen(pair)>0)
			   {
				   return(OpenOrderSell(pair));
			   }
			   else
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellPairNarrowSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
		   }
		}
		// END_Action : _BuyOrSellPairNarrowSprd
		return(FALSE);
	}

bool Action_BestSwapPairNarrowSprd()
	{
		// START_Action : _BestSwapPairNarrowSprd
		if(_BestSwapPairNarrowSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapPairNarrowSprd no pair found on pairsToBuyOrSellArray.");
				return(TRUE);
		   }

		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			   pair = getPairWLowestBuySwapNrowSpread(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapPairNarrowSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderBuy(pair));
		   }
		   // Sell
		   else if (randSignal == 1)
		   {
			   pair = getPairWLowstSellSwapNrowSpread(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapPairNarrowSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderSell(pair));
		   }
		}
		// END_Action : _BestSwapPairNarrowSprd
		return(FALSE);
	}

bool Action_WorstSwapPairNarrowSprd()
	{
		// START_Action : _WorstSwapPairNarrowSprd
		if(_WorstSwapPairNarrowSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapPairNarrowSprd no pair found on pairsToBuyAndSellArray.");
				return(TRUE);
		   }
		   
		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			   pair = getPairWHighstBuySwapNrowSprd(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapPairNarrowSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderBuy(pair));
		   }
		   // Sell
		   else if (randSignal == 1)
		   {
			   pair = getPairWHighstSellSwapNrowSprd(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapPairNarrowSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderSell(pair));
		   }
		}
		// END_Action : _WorstSwapPairNarrowSprd
		return(FALSE);
	}

/* -------------------------------------
 * _WideSprd
 * -------------------------------------*/
bool Action_BuyPairWideSprd()
	{
		// START_Action : _BuyPairWideSprd
		if(_BuyPairWideSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyPairWideSprd no pair found on pairsToBuyArray.");
				return(TRUE);
		   }
		   
		   // randomly select pair to Buy
		   ArrayResize(tmpArray,0);
		   if (ArraySize(pairsToBuyArray) > 0)
		   {
			  size = ArraySize(pairsToBuyArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyArray,oldSize,0,WHOLE_ARRAY);
		   }
		   /*if (ArraySize(pairsToBuyAndSellArray) > 0)
		   {
			  size = ArraySize(pairsToBuyAndSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
		   }*/
		   
		   latestSpread = 0;
		   pair = "";
		   for (int p = 0; p < ArraySize(tmpArray); p++)
		   {
		      skipPair = FALSE;
			  if (AllowMultiplePurchaseOfPair == FALSE)
			  {
				skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
			  }
			  spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
			  if (skipPair == FALSE && (latestSpread == 0 || spread >= latestSpread))
			  {
				 latestSpread = spread;
				 pair = tmpArray[p];
			  }
		   }
		   
		   if (StringLen(pair)>0)
		   {
				return(OpenOrderBuy(pair));
		   }
		   else
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyPairWideSprd no suitable pair found on pairsToBuyArray.");
				return(TRUE);
		   }
		}
		// END_Action : _BuyPairWideSprd
		return(FALSE);
	}

bool Action_SellPairWideSprd()
	{
		// START_Action : _SellPairWideSprd
		if(_SellPairWideSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_SellPairWideSprd no pair found on pairsToSellArray.");
				return(TRUE);
		   }
		   
		   // randomly select pair to Sell
		   ArrayResize(tmpArray,0);
		   if (ArraySize(pairsToSellArray) > 0)
		   {
			  size = ArraySize(pairsToSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToSellArray,oldSize,0,WHOLE_ARRAY);
		   }
		   /*if (ArraySize(pairsToBuyAndSellArray) > 0)
		   {
			  size = ArraySize(pairsToBuyAndSellArray);
			  oldSize = ArraySize(tmpArray);
			  ArrayResize(tmpArray,oldSize+size);
			  ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
		   }*/

		   latestSpread = 0;
		   pair = "";
		   for (int p = 0; p < ArraySize(tmpArray); p++)
		   {
		      skipPair = FALSE;
			  if (AllowMultiplePurchaseOfPair == FALSE)
			  {
				skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
			  }
			  spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
			  if (skipPair == FALSE && (latestSpread == 0 || spread >= latestSpread))
			  {
				 latestSpread = spread;
				 pair = tmpArray[p];
			  }
		   }
		   
		   if (StringLen(pair)>0)
		   {
				return(OpenOrderSell(pair));
		   }
		   else
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_SellPairWideSprd no suitable pair found on pairsToSellArray.");
				return(TRUE);
		   }		   
		}
		// END_Action : _SellPairWideSprd
		return(FALSE);
	}

bool Action_BuyOrSellPairWideSprd()
	{
		// START_Action : _BuyOrSellPairWideSprd
		if(_BuyOrSellPairWideSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellPairWideSprd no pair found on pairsToBuyOrSellArray.");
				return(TRUE);
		   }
		   
		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			  // randomly select pair to Buy
			  ArrayResize(tmpArray,0);
			  if (ArraySize(pairsToBuyAndSellArray) > 0)
			  {
				 size = ArraySize(pairsToBuyAndSellArray);
				 oldSize = ArraySize(tmpArray);
				 ArrayResize(tmpArray,oldSize+size);
				 ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
			  }
		   
			  latestSpread = 0;
			  for (p = 0; p < ArraySize(tmpArray); p++)
			  {
				 skipPair = FALSE;
				 if (AllowMultiplePurchaseOfPair == FALSE)
				 {
					skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
				 }
				 spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
				 if (skipPair == FALSE && (latestSpread == 0 || spread >= latestSpread))
				 {
					latestSpread = spread;
					pair = tmpArray[p];
				 }
			  }
		   
			   if (StringLen(pair)>0)
			   {
				   return(OpenOrderBuy(pair));
			   }
			   else
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellPairWideSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
		   }

		   // Sell
		   else if (randSignal == 1)
		   {
			  // randomly select pair to Sell
			  ArrayResize(tmpArray,0);
			  if (ArraySize(pairsToBuyAndSellArray) > 0)
			  {
				 size = ArraySize(pairsToBuyAndSellArray);
				 oldSize = ArraySize(tmpArray);
				 ArrayResize(tmpArray,oldSize+size);
				 ArrayCopy(tmpArray,pairsToBuyAndSellArray,oldSize,0,WHOLE_ARRAY);
			  }
		   
			  latestSpread = 0;
			  for (p = 0; p < ArraySize(tmpArray); p++)
			  {
				 skipPair = FALSE;
				 if (AllowMultiplePurchaseOfPair == FALSE)
				 {
					skipPair = OrderOnPairAlreadyPlaced(tmpArray[p]);
				 }
				 spread = MarketInfo(tmpArray[p], MODE_ASK) - MarketInfo(tmpArray[p], MODE_BID);
				 if (skipPair == FALSE && (latestSpread == 0 || spread >= latestSpread))
				 {
					latestSpread = spread;
					pair = tmpArray[p];
				 }
			  }
		   
			   if (StringLen(pair)>0)
			   {
				   return(OpenOrderSell(pair));
			   }
			   else
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BuyOrSellPairWideSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
		   }
		}
		// END_Action : _BuyOrSellPairWideSprd
		return(FALSE);
	}

bool Action_BestSwapPairWideSprd()
	{
		// START_Action : _BestSwapPairWideSprd
		if(_BestSwapPairWideSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapPairWideSprd no pair found on pairsToBuyAndSellArray.");
				return(TRUE);
		   }

		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			   pair = getPairWLowestBuySwapWideSpread(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapPairWideSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderBuy(pair));
		   }
		   // Sell
		   else if (randSignal == 1)
		   {
			   pair = getPairWLowstSellSwapWideSprd(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_BestSwapPairWideSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderSell(pair));
		   }
		}
		// END_Action : _BestSwapPairWideSprd
		return(FALSE);
	}

bool Action_WorstSwapPairWideSprd()
	{
		// START_Action : _WorstSwapPairWideSprd
		if(_WorstSwapPairWideSprd == TRUE)
		{
		   // sanity check
		   if (ArraySize(pairsToBuyAndSellArray) == 0)
		   {
				if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapPairWideSprd no pair found on pairsToBuyAndSellArray.");
				return(TRUE);
		   }
		   
		   randSignal = MathRand() % 2;
		   
		   // Buy
		   if (randSignal == 0)
		   {
			   pair = getPairWHighstBuySwapWideSprd(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapPairWideSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderBuy(pair));
		   }
		   // Sell
		   else if (randSignal == 1)
		   {
			   pair = getPairWHighstSellSwapWideSprd(pairsToBuyAndSellArray);
			   
			   if(StringLen(pair)==0)
			   {
					if(PrintErrors) Print("ERROR - "+EA_NAME+" Trader : Action_WorstSwapPairWideSprd no suitable pair found on pairsToBuyAndSellArray.");
					return(TRUE);
			   }
			   return(OpenOrderSell(pair));
		   }
		}
		// END_Action : _WorstSwapPairWideSprd
		return(FALSE);
	}

//+------------------------------------------------------------------+
//+---                                                            ---+
//+--- ORDER LONG/SHORT ENTRIES                                   ---+
//+---                                                            ---+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool OpenOrderBuy(string symbol, bool forceOpen=FALSE)
{
   int cnt = 0;
   Total = OrdersTotal();
   for (int i = Total-1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
      {
         if (OrderMagicNumber() == Magic)
         {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {cnt++;}
         }
      }
   }

   if (cnt > MaximumNumberTrades) {return(TRUE);}

   string strategy = " - ";

   /* **
    * Scalping Strategies ENTRY Checks
    * **/
   bool LongEntrySignal = FALSE;
   
   if (forceOpen==TRUE) {if(forceOpen==TRUE){strategy="BALANCE";}LongEntrySignal=TRUE;}
   
   if (LongEntrySignal==FALSE) {return(TRUE);}
   GlobalVariableSet("EntrySignal",0);
   /* **
    * Scalping Strategies ENTRY Checks - END
    * **/
   
   // expert open orders
   if (MarketInfo(symbol, MODE_DIGITS) == 3 || MarketInfo(symbol, MODE_DIGITS) == 5) dd_mul = 10;
   else dd_mul = 1;
	//dd_mul = 1;
	
   // Param for 5-Digit or 4-Digit Broker   
   pointvalue = /*dd_mul **/ MarketInfo(symbol, MODE_POINT);

   if (i < (MaximumNumberTrades-Cnt))
   {
      SL = 0;
      TP = 0;
      stopLevel   = MarketInfo(symbol, MODE_STOPLEVEL)+MarketInfo(symbol, MODE_SPREAD);
      if(forceOpen==TRUE)
         stopLoss    = NormalizeDouble((StopLossLevel/2) * pointvalue, MarketInfo(symbol, MODE_DIGITS));
      else
         stopLoss    = NormalizeDouble(StopLossLevel * pointvalue, MarketInfo(symbol, MODE_DIGITS));
      takeProfit  = NormalizeDouble(TakeProfitLevel * pointvalue, MarketInfo(symbol, MODE_DIGITS));

      if(stopLoss > 0){SL = MarketInfo(symbol, MODE_ASK)-stopLoss;}
      if(takeProfit > 0){TP = MarketInfo(symbol, MODE_BID)+takeProfit;}
      
      //if (SL > MarketInfo(symbol, MODE_ASK)-stopLevel*dd_mul*pointvalue) {SL = MarketInfo(symbol, MODE_ASK)-stopLevel*dd_mul*pointvalue;}
      //if (TP < MarketInfo(symbol, MODE_BID)+stopLevel*dd_mul*pointvalue) {TP = MarketInfo(symbol, MODE_BID)+stopLevel*dd_mul*pointvalue;}

      datetime lastOrderTimeWSamePair = getLatestClosedOrderWSamePair(symbol);
      
      if (lastOrderTimeWSamePair!=NULL&&SamePairDelayMinutes>0&&(TimeCurrent()-lastOrderTimeWSamePair)/60<=SamePairDelayMinutes)
      {
         return(TRUE);
      }
      
      selectedOrderTicket = OrderSend(symbol, OP_BUY, LOT(symbol), MarketInfo(symbol, MODE_ASK), Slippage, 0, 0, EA_NAME+" - " + strategy, Magic, 0, CLR_NONE);
      if (selectedOrderTicket >= 0)
      {
         string var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(OrderTicket(),0));
         GlobalVariableSet(var_id,MarketInfo(symbol, MODE_ASK));

         selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), SL, TP, 0, CLR_NONE);
         if (selectedOrderModified == FALSE) {if(PrintErrors) Print("ERROR -- "+EA_NAME+" Trader : Modifying BUY order REASON# ", GetLastError());}
      }
   }
   
   return(TRUE);
}
//+------------------------------------------------------------------+
bool OpenOrderSell(string symbol, bool forceOpen=FALSE)
{
   int cnt = 0;
   Total = OrdersTotal();
   for (int i = Total-1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
      {
         if (OrderMagicNumber() == Magic)
         {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {cnt++;}
         }
      }
   }

   if (cnt >= MaximumNumberTrades) {return(TRUE);}

   string strategy = " - ";

   /* **
    * Scalping Strategies ENTRY Checks
    * **/
   bool ShortEntrySignal = FALSE;
   
   if (forceOpen==TRUE) {if(forceOpen==TRUE){strategy="BALANCE";}ShortEntrySignal=TRUE;}
   
   if (ShortEntrySignal==FALSE) {return(TRUE);}
   GlobalVariableSet("EntrySignal",0);
   /* **
    * Scalping Strategies ENTRY Checks - END
    * **/

   // expert open orders
   if (MarketInfo(symbol, MODE_DIGITS) == 3 || MarketInfo(symbol, MODE_DIGITS) == 5) dd_mul = 10;
   else dd_mul = 1;
	//dd_mul = 1;
	
   // Param for 5-Digit or 4-Digit Broker
   pointvalue = /*dd_mul **/ MarketInfo(symbol, MODE_POINT);

   if (i < (MaximumNumberTrades-Cnt))
   {
      SL = 0;
      TP = 0;
      stopLevel   = MarketInfo(symbol, MODE_STOPLEVEL)+MarketInfo(symbol, MODE_SPREAD);
      if(forceOpen==TRUE)
         stopLoss    = NormalizeDouble((StopLossLevel/2) * pointvalue, MarketInfo(symbol, MODE_DIGITS));
      else
         stopLoss    = NormalizeDouble(StopLossLevel * pointvalue, MarketInfo(symbol, MODE_DIGITS));
      takeProfit  = NormalizeDouble(TakeProfitLevel * pointvalue, MarketInfo(symbol, MODE_DIGITS));

      if(stopLoss > 0){SL = MarketInfo(symbol, MODE_BID)+stopLoss;}
      if(takeProfit > 0){TP = MarketInfo(symbol, MODE_ASK)-takeProfit;}
   
      //if (SL < MarketInfo(symbol, MODE_BID)+stopLevel*dd_mul*pointvalue) {SL = MarketInfo(symbol, MODE_BID)+stopLevel*dd_mul*pointvalue;}
      //if (TP > MarketInfo(symbol, MODE_ASK)-stopLevel*dd_mul*pointvalue) {TP = MarketInfo(symbol, MODE_ASK)-stopLevel*dd_mul*pointvalue;}

      datetime lastOrderTimeWSamePair = getLatestClosedOrderWSamePair(symbol);
      
      if (lastOrderTimeWSamePair!=NULL&&SamePairDelayMinutes>0&&(TimeCurrent()-lastOrderTimeWSamePair)/60<=SamePairDelayMinutes)
      {
         return(TRUE);
      }

      selectedOrderTicket = OrderSend(symbol, OP_SELL, LOT(symbol), MarketInfo(symbol, MODE_BID), Slippage, 0, 0, EA_NAME+" - " + strategy, Magic, 0, CLR_NONE);
      if (selectedOrderTicket >= 0)
      {
         string var_id = StringConcatenate("MONKEY_ORDER_",DoubleToStr(OrderTicket(),0));
         GlobalVariableSet(var_id,MarketInfo(symbol, MODE_BID));

         selectedOrderModified = OrderModify(selectedOrderTicket, OrderOpenPrice(), SL, TP, 0, CLR_NONE);
         if (selectedOrderModified == FALSE) {if(PrintErrors) Print("ERROR -- "+EA_NAME+" Trader : Modifying SELL order REASON# ", GetLastError());}
      }
   }
   
   return(TRUE);
}
//+------------------------------------------------------------------+
void Log(int ticket, string status, string symbol, int points)
{
   int handle,valueCnt,updatePos;
   string str,word,ticketToWrite,valueToWrite,values[];
   bool ticketFound=FALSE;
   handle=FileOpen(EA_NAME+"-"+VER+".log", FILE_CSV|FILE_READ, ";");
   if(FileSize(handle)>0)
   {
      while(!FileIsEnding(handle))
      {
         str=FileReadString(handle);
         ticketToWrite=StringConcatenate("#",ticket);
         for (int c=0; !FileIsLineEnding(handle) && c<9999; c++)  {
            if(str!="")
            {
               word=StringTrimLeft(StringTrimRight(str));
               if(c==0&&word==ticketToWrite)
               {
                  updatePos=FileTell(handle);
                  ticketFound=TRUE;
               }
               if(c>1)
               {
                  ArrayResize(values,c-1);
                  values[c-2]=word;
               }
            }
            str=FileReadString(handle);
         }
         
         ArrayResize(values,c-1);
         values[c-2]=str;
         
         //if(/*FileIsLineEnding(handle)*/ticketFound==TRUE)
            //break;
      }
   }
   FileClose(handle);
   
   str = TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
   if(ticketFound==FALSE)
   {
      handle=FileOpen(EA_NAME+"-"+VER+".log", FILE_CSV|FILE_WRITE|FILE_READ,";");
      //if(handle==-1)return(0);// if not exist
      FileSeek(handle, 0, SEEK_END);
      ticketToWrite=StringConcatenate("#",ticket);
      FileWrite(handle,ticketToWrite,str,status,symbol,points);
      FileFlush(handle);
      FileClose(handle);
   }
   else
   {
      handle=FileOpen(EA_NAME+"-"+VER+".log", FILE_CSV|FILE_WRITE|FILE_READ,";");
      //if(handle==-1)return(0);// if not exist
      //Alert("Updating #",ticket," at POS #",updatePos);
      valueToWrite = StringConcatenate("#",ticket,";",str);
      values[0]=status;
      for(valueCnt=0;valueCnt<ArraySize(values);valueCnt++)
      {
         valueToWrite = StringConcatenate(valueToWrite,";",values[valueCnt]);
      }
      //FileSeek(handle,updatePos-StringLen(valueToWrite)-3,SEEK_SET);
      FileSeek(handle, 0, SEEK_END);
      valueToWrite = StringConcatenate(valueToWrite,";",points);
      FileWrite(handle,valueToWrite);
      FileFlush(handle);
      FileClose(handle);
   }
   return(0);
}

//+------------------------------------------------------------------+
//+---                                                            ---+
//+--- Scalping Strategies                                        ---+
//+---                                                            ---+
//+------------------------------------------------------------------+

//+--------------------------------------------------------------------------------------------------------------+
//| MaxSpreadFilter.
//+--------------------------------------------------------------------------------------------------------------+
bool MaxSpreadFilter(string symbol) {
//+--------------------------------------------------------------------------------------------------------------+
   RefreshRates();
   int myDdMul = 1;
   if (MarketInfo(symbol, MODE_DIGITS) == 3 || MarketInfo(symbol, MODE_DIGITS) == 5) myDdMul = 10;
   else myDdMul = 1;
   double myPointValue = myDdMul * MarketInfo(symbol, MODE_POINT);
   double NDMaxSpread = MaxSpread * myPointValue;
   if (NormalizeDouble(MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID), MarketInfo(symbol, MODE_DIGITS)) > NDMaxSpread) return (TRUE);
   //---
   else return (FALSE);
}

//+------------------------------------------------------------------+
int RoundClosest(int n, int step)
{
	if(n > 0)	n += step/2;
	else			n -= step/2;
	return(n - n%step);
}

//+------------------------------------------------------------------+
//| H4 and Daily Support/Resistance and Pivot                        |
//+------------------------------------------------------------------+
void get_pivots(string symbol, int timeframe)
{
//----------------------------------------------------------------------------- Get new TimeFrame ---------------
   ArrayCopyRates(Fhr_rates_d1, symbol, timeframe);

   Fhr_yesterday_close = Fhr_rates_d1[1][4];
   Fhr_yesterday_open = Fhr_rates_d1[1][1];
   Fhr_today_open = Fhr_rates_d1[0][1];
   Fhr_yesterday_high = Fhr_rates_d1[1][3];
   Fhr_yesterday_low = Fhr_rates_d1[1][2];
   Fhr_day_high = Fhr_rates_d1[0][3];
   Fhr_day_low = Fhr_rates_d1[0][2];


//---- Calculate Pivots

   Fhr_D = (Fhr_day_high - Fhr_day_low);
   Fhr_Q = (Fhr_yesterday_high - Fhr_yesterday_low);
   Fhr_P = (Fhr_yesterday_high + Fhr_yesterday_low + Fhr_yesterday_close) / 3;
   Fhr_R1 = (2*Fhr_P)-Fhr_yesterday_low;
   Fhr_S1 = (2*Fhr_P)-Fhr_yesterday_high;
   Fhr_R2 = Fhr_P+(Fhr_yesterday_high - Fhr_yesterday_low);
   Fhr_S2 = Fhr_P-(Fhr_yesterday_high - Fhr_yesterday_low);


   Fhr_R3 = (2*Fhr_P)+(Fhr_yesterday_high-(2*Fhr_yesterday_low));
   Fhr_M5 = (Fhr_R2+Fhr_R3)/2;
   // Fhr_R2 = Fhr_P-Fhr_S1+Fhr_R1;
   Fhr_M4 = (Fhr_R1+Fhr_R2)/2;
   // Fhr_R1 = (2*Fhr_P)-Fhr_yesterday_low;
   Fhr_M3 = (Fhr_P+Fhr_R1)/2;
   // Fhr_P = (Fhr_yesterday_high + Fhr_yesterday_low + Fhr_yesterday_close)/3;
   Fhr_M2 = (Fhr_P+Fhr_S1)/2;
   // Fhr_S1 = (2*Fhr_P)-Fhr_yesterday_high;
   Fhr_M1 = (Fhr_S1+Fhr_S2)/2;
   // Fhr_S2 = Fhr_P-Fhr_R1+Fhr_S1;
   Fhr_S3 = (2*Fhr_P)-((2* Fhr_yesterday_high)-Fhr_yesterday_low);
   Fhr_M0 = (Fhr_S2+Fhr_S3)/2;

   if (Fhr_Q > 5)
   {
      Fhr_nQ = Fhr_Q;
   }
   else
   {
     Fhr_nQ = Fhr_Q*10000;
   }

   if (Fhr_D > 5)
   {
       Fhr_nD = Fhr_D;
   }
   else
   {
      Fhr_nD = Fhr_D*10000;
   }
//----------------------------------------------------------------------------- Get DAY ---------------
   ArrayCopyRates(D_rates_d1, symbol, 1440);

   D_yesterday_close = D_rates_d1[1][4];
   D_yesterday_open = D_rates_d1[1][1];
   D_today_open = D_rates_d1[0][1];
   D_yesterday_high = D_rates_d1[1][3];
   D_yesterday_low = D_rates_d1[1][2];
   D_day_high = D_rates_d1[0][3];
   D_day_low = D_rates_d1[0][2];


//---- Calculate Pivots

   D_D = (D_day_high - D_day_low);
   D_Q = (D_yesterday_high - D_yesterday_low);
   D_P = (D_yesterday_high + D_yesterday_low + D_yesterday_close) / 3;
   D_R1 = (2*D_P)-D_yesterday_low;
   D_S1 = (2*D_P)-D_yesterday_high;
   D_R2 = D_P+(D_yesterday_high - D_yesterday_low);
   D_S2 = D_P-(D_yesterday_high - D_yesterday_low);


   D_R3 = (2*D_P)+(D_yesterday_high-(2*D_yesterday_low));
   D_M5 = (D_R2+D_R3)/2;
   // D_R2 = D_P-D_S1+D_R1;
   D_M4 = (D_R1+D_R2)/2;
   // D_R1 = (2*D_P)-D_yesterday_low;
   D_M3 = (D_P+D_R1)/2;
   // D_P = (D_yesterday_high + D_yesterday_low + D_yesterday_close)/3;
   D_M2 = (D_P+D_S1)/2;
   // D_S1 = (2*D_P)-D_yesterday_high;
   D_M1 = (D_S1+D_S2)/2;
   // D_S2 = D_P-D_R1+D_S1;
   D_S3 = (2*D_P)-((2* D_yesterday_high)-D_yesterday_low);

   D_M0 = (D_S2+D_S3)/2;

   if (D_Q > 5)
   {
      D_nQ = D_Q;
   }
   else
   {
     D_nQ = D_Q*10000;
   }

   if (D_D > 5)
   {
       D_nD = D_D;
   }
   else
   {
      D_nD = D_D*10000;
   }
}

//--------------------------------------------------------------------- +
void get_NearestAndFarestSR(string symbol, int timeframe, double price)
{
   //-- Pivots, Support/Resistance and Price Alerts
   get_pivots(symbol, timeframe);
   //---

   MqlRates RatesBar[];
   ArraySetAsSeries(RatesBar,true);
   if(CopyRates(symbol,timeframe,0,20,RatesBar)==20)
   {
      double high     = RatesBar[0].high;
      double point    = MarketInfo(symbol,MODE_POINT);
      int    digits   = MarketInfo(symbol,MODE_DIGITS);
      double ask      = MarketInfo(symbol,MODE_ASK);
      double bid      = MarketInfo(symbol,MODE_BID);
      double low      = RatesBar[0].low;
      int    power    = MathPow(10,digits-1);
      double pipRange = (high-low)*power;
      double bidRatio = (pipRange > 0 ? ((bid-low)/pipRange*power)*100 : 0);
             pipRange = (pipRange != 0 ? pipRange : 0.001);
      //-Fhr
      if( price >= Fhr_R3 )
      {
         nearest_resistance = D_R3;
         nearest_support = Fhr_R3;

         farest_resistance = D_R3 + sqConvertToRealPips(symbol, pipRange);
         farest_support = Fhr_R1;
      }
      else if( price < Fhr_R3 && price >= Fhr_R2 )
      {
         nearest_resistance = Fhr_R3;
         nearest_support = Fhr_R2;

         farest_resistance = D_R3;
         farest_support = Fhr_S1;
      }
      else if( price < Fhr_R2 && price >= Fhr_R1 )
      {
         nearest_resistance = Fhr_R2;
         nearest_support = Fhr_R1;

         farest_resistance = Fhr_R3;
         farest_support = Fhr_S1;
      }
      else if( price < Fhr_R1 && price >= Fhr_S1 )
      {
         nearest_resistance = Fhr_R1;
         nearest_support = Fhr_S1;

         farest_resistance = Fhr_R3;
         farest_support = Fhr_S3;
      }
      else if( price < Fhr_S1 && price >= Fhr_S2 )
      {
         nearest_resistance = Fhr_S1;
         nearest_support = Fhr_S2;

         farest_resistance = Fhr_R3;
         farest_support = Fhr_S3;
      }
      else if( price < Fhr_S2 && price >= Fhr_S3 )
      {
         nearest_resistance = Fhr_S2;
         nearest_support = Fhr_S3;

         farest_resistance = Fhr_S1;
         farest_support = D_S3;
      }
      else
      {
         nearest_resistance = Fhr_S3;
         nearest_support = D_S3;

         farest_resistance = Fhr_S1;
         farest_support = D_S3 - sqConvertToRealPips(symbol, pipRange);
      }
      //-D
      if( price >= D_R3 )
      {
         nearest_daily_resistance = D_R3 + sqConvertToRealPips(symbol, pipRange);
         nearest_daily_support = D_R3;

         farest_daily_resistance = D_R3 + sqConvertToRealPips(symbol, pipRange);
         farest_daily_support = D_R1;
      }
      else if( price < D_R3 && price >= D_R2 )
      {
         nearest_daily_resistance = D_R3;
         nearest_daily_support = D_R2;

         farest_daily_resistance = D_R3 + sqConvertToRealPips(symbol, pipRange);
         farest_daily_support = D_S1;
      }
      else if( price < D_R2 && price >= D_R1 )
      {
         nearest_daily_resistance = D_R2;
         nearest_daily_support = D_R1;

         farest_daily_resistance = D_R3;
         farest_daily_support = D_S1;
      }
      else if( price < D_R1 && price >= D_S1 )
      {
         nearest_daily_resistance = D_R1;
         nearest_daily_support = D_S1;

         farest_daily_resistance = D_R3;
         farest_daily_support = D_S3;
      }
      else if( price < D_S1 && price >= D_S2 )
      {
         nearest_daily_resistance = D_S1;
         nearest_daily_support = D_S2;

         farest_daily_resistance = D_R1;
         farest_daily_support = D_S3;
      }
      else if( price < D_S2 && price >= D_S3 )
      {
         nearest_daily_resistance = D_S2;
         nearest_daily_support = D_S3;

         farest_daily_resistance = D_R1;
         farest_daily_support = D_S3 - sqConvertToRealPips(symbol, pipRange);
      }
      else
      {
         nearest_daily_resistance = D_S3;
         nearest_daily_support = D_S3 - sqConvertToRealPips(symbol, pipRange);

         farest_daily_resistance = D_R1;
         farest_daily_support = D_S3 - sqConvertToRealPips(symbol, 2*pipRange);
      }
   }
}

//----------------------------------------------------------------------------
double sqGetPointPow(string symbol) {
   double realDigits = MarketInfo(symbol,MODE_DIGITS);
   if(realDigits > 0 && realDigits != 2 && realDigits != 4) {
      realDigits -= 1;
   }

   double gPointPow = MathPow(10, realDigits);
   return(gPointPow);
}
double sqGetPointCoef(string symbol) {
   double gPointCoef = 1/sqGetPointPow(symbol);
   return(gPointCoef);
}
//----------------------------------------------------------------------------
double sqConvertToRealPips(string symbol, int value) {
   return(sqGetPointCoef(symbol) * value);
}

//----------------------------------------------------------------------------

double sqConvertToPips(string symbol, double value) {
   return(sqGetPointPow(symbol) * value);
}

//----------------------------------------------------------------------------