//==================================================================================================
// 2012-07-09 by Capella at http://www.worldwide-invest.org
// - Added ECN-function. If true, then OrderSend does not send SL & TP but a OrderModify command  
//   follows that sends the SL and TP.
// - Translated text from Russian to English
//==================================================================================================
//
//+------------------------------------------------------------------+
//|                                                      4indis_Plus |
//|                                       mod by Monty666 2012-07-22 |
//+------------------------------------------------------------------+
// - added RSI signal H1, 70, 30 - 2012-07-22
// - added Time & Newsfilter - 2012-07-22
// - added max Spread - 2012-07-22
// - added optimized settings from momods - 2012-07-22
// - added comments

#property copyright "Copyright © 2012, dj_ermoloff@mail.ru."
#property link      "Советник на заказ dj_ermoloff@mail.ru"

extern bool ECN = TRUE;
extern string s0 = "Settings for indicators";
extern int MA_Period = 105;
extern int Slippage_MA = 25;
extern string s01 = "------------------------";
extern int Williams_Period = 21;
extern int Level_High = 5;
extern int Level_Low = 95;
extern string s02 = "------------------------";
extern int ATR_Period = 22;
extern int Level_ATR_Stop = 2;
extern string s03 = "------------------------";
extern int CCI_Period = 16;
extern int Level_CCI_High = 90;
extern int Level_CCI_Low = -95;
extern string s04 = "------------------------";
extern double RSIParamBuy = 70;
extern double RSIParamSell = 30;
//----------------------------------------------
extern string s1 = "Settings for Stoploss & TakeProfit";
extern int StopLoss = 40;
extern int TakeProfit = 10;
extern string s2 = "Setting for closing of orders";
extern string s21 = "Closure of Williams.";
extern int Close_Williams = 1;
extern int Williams_Close_Buy = 80;
extern int Williams_Close_Sell = 40;
extern int Only_Profit = 2;
extern string s22 = "Closure of CCI";
extern int Close_CCI = 0;
extern int CCI_Close_Buy = 20;
extern int CCI_Close_Sell = -70;
string gs_unused_216 = "Closure of ATR";
int gi_224 = 0;
int gi_228 = 6;
string gs_unused_232 = "Closure of МА";
int gi_240 = 0;
int gi_244 = 0;
extern string s4 = "Breakeven. If 0 - do not use";
extern int Paritet = 0;
extern int Pips = 3;
extern string s5 = "Trailing stop. 0 - Off, 1 - standard, 2 - shadows";
extern int TraillingType = 0;
extern int TraillingStop = 22;
extern int TraillingStep = 2;
extern int TraillingBar = 5;
extern string s6 = "Settings for order";
extern double Lot = 0.0;
extern double MM = 10.0;
extern int slippage = 0;
extern double MaxSpread    = 2.0;
extern int    TimeControl  = 0;
extern string TimeZone = "Adjust TimeZone";
extern int    ServerTimeZone = 1;
extern string TradingTimes   = "Time & Newsfilter";
extern int    HourStartGMT   = 8;
extern int    HourStopGMT    = 21;
extern bool AvoidNews        = TRUE;
extern int MinimumImpact     = 3;
extern int MinsBeforeNews    = 5;
extern int MinsAfterNews     = 30;
extern string DontTradeFriday = "FridayFinalHour";
extern bool   UseFridayFinalTradeTime = TRUE;
extern int    FridayFinalHourGMT = 20;
extern int MagicNumber = 7654238;
extern string comment = "4Indicators";

int gi_328;
int g_error_332;
double g_price_336;
double g_price_344;
double g_price_352;
double gd_360;
double gd_368;
double g_iclose_376;
double g_iatr_384;
double g_iwpr_392;
double g_icci_400;
double g_ima_408;
int g_datetime_416;
int g_datetime_420;

//+------------------------------------------------------------------+
//| TradeSession                                                     |
//+------------------------------------------------------------------+
bool TradeSession() {
   int Hour_Start_Trade;
   int Hour_Stop_Trade;
   Hour_Start_Trade = HourStartGMT + ServerTimeZone;
   Hour_Stop_Trade = HourStopGMT + ServerTimeZone;
   if (Hour_Start_Trade < 0)Hour_Start_Trade = Hour_Start_Trade + 24;
   if (Hour_Start_Trade >= 24)Hour_Start_Trade = Hour_Start_Trade - 24;
   if (Hour_Stop_Trade > 24)Hour_Stop_Trade = Hour_Stop_Trade - 24;
   if (Hour_Stop_Trade <= 0)Hour_Stop_Trade = Hour_Stop_Trade + 24;
   if ((UseFridayFinalTradeTime && (Hour()>=FridayFinalHourGMT + ServerTimeZone) && DayOfWeek()==5)||DayOfWeek()==0)return (FALSE); // Friday Control
   if((TimeControl(Hour_Start_Trade,Hour_Stop_Trade)!=1 && TimeControl==1 && Hour_Start_Trade<Hour_Stop_Trade)
        || (TimeControl(Hour_Stop_Trade,Hour_Start_Trade)!=0 && TimeControl==1 && Hour_Start_Trade>Hour_Stop_Trade)
          ||TimeControl==0)return (TRUE); // "Trading Time";
    return (FALSE); // "Non-Trading Time";
}

int TimeControl(int StartHour, int EndHour)
{
   if (Hour()>=StartHour &&  Hour()< EndHour)
      { 
      return(0);
      }
return(1);
}
//+------------------------------------------------------------------+
//| Calculate digits                                                    |
//+------------------------------------------------------------------+

int init() {
   if (MarketInfo(Symbol(), MODE_DIGITS) == 5.0 || MarketInfo(Symbol(), MODE_DIGITS) == 3.0) gi_328 = 10;
   else gi_328 = 1;
   return (0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   return (0);
}
//+------------------------------------------------------------------+
//| MaxSpread                                                        |
//+------------------------------------------------------------------+
bool Mspread() {
   double Spread = Ask-Bid;
   if(Spread <= MaxSpread * gi_328 * Point)return (TRUE);
    return (FALSE); // "Non-Trading Time";
}  
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() 
{
//+------------------------------------------------------------------+
//| newsfilter                                                       |
//+------------------------------------------------------------------+
bool ContinueTrading=true;
   if(AvoidNews && !IsTesting())
   {
   static int PrevMinute=-1;  
   
   int MinSinceNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,1,0);
   int MinToNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,1,1);
         
   int ImpactSinceNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,2,0);
   int ImpactToNews=iCustom(NULL,0,"FFCal",true,true,false,true,true,2,1);

   if(Minute()!=PrevMinute)
   {
   PrevMinute=Minute();
   if((MinToNews<=MinsBeforeNews &&  ImpactToNews>=MinimumImpact) || (MinSinceNews<=MinsAfterNews && ImpactSinceNews>=MinimumImpact))ContinueTrading=false;
   }
}
//+------------------------------------------------------------------+
//| signals, close & open orders                                     |
//+------------------------------------------------------------------+
// rsi mod by monty ---------------------------------------------
	int sign1;
	double ld_40 = iRSI(NULL, PERIOD_H1, RSIParamBuy, PRICE_CLOSE, 0);
	double ld_48 = iRSI(NULL, PERIOD_H1, RSIParamSell, PRICE_CLOSE, 0);
	if (ld_40 > 50.0) sign1=1;
	if (ld_48 < 50.0) sign1=-1;
//--------------------------------------------------------------------   
   
   int datetime_0 = 0;
   int ticket;
   for (int pos_4 = 0; pos_4 < OrdersTotal(); pos_4++) 
	{
      if (OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES) == TRUE) 
		{
         if (OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) 
			{
            tral();
            if (OrderType() == OP_BUY) {
               datetime_0 = OrderOpenTime();
               if (close_signal(0, OrderOpenPrice())) OrderClose(OrderTicket(), OrderLots(), Bid, slippage, Blue);
            }
            if (OrderType() == OP_SELL) {
               datetime_0 = OrderOpenTime();
               if (close_signal(1, OrderOpenPrice())) OrderClose(OrderTicket(), OrderLots(), Ask, slippage, Blue);
            }
         }
      }
   }
   if (g_datetime_420 != iTime(Symbol(), 0, 0)) 
	{
      g_iclose_376 = iClose(NULL, 0, 1);
      g_ima_408 = iMA(NULL, 0, MA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
      g_iwpr_392 = iWPR(NULL, 0, Williams_Period, 1);
      g_iatr_384 = iATR(NULL, 0, ATR_Period, 1);
      g_icci_400 = iCCI(NULL, 0, CCI_Period, PRICE_TYPICAL, 1);
      g_datetime_420 = iTime(Symbol(), 0, 0);
   }
   if (g_datetime_416 != iTime(Symbol(), 0, 0) && datetime_0 == 0) 
	{
      if (g_iclose_376 > g_ima_408 + Slippage_MA * gi_328 * Point && g_iwpr_392 < (-1 * Level_Low) && g_icci_400 < Level_CCI_Low && g_iatr_384 > Level_ATR_Stop * gi_328 * Point) 
		{
         g_price_336 = NormalizeDouble(Ask, Digits);
         g_price_344 = NormalizeDouble(g_price_336 - StopLoss * gi_328 * Point, Digits);
         g_price_352 = NormalizeDouble(g_price_336 + TakeProfit * gi_328 * Point, Digits);			
			if (!ECN) // Normal mode (No ECN - orders are sent with SL and TP directly
			{
				if(sign1==1 && TradeSession() && ContinueTrading && Mspread()) OrderSend(Symbol(), OP_BUY, lot_mm(), g_price_336, slippage, g_price_344, g_price_352, comment, MagicNumber, 0, Green);
				g_error_332 = GetLastError();
				if (g_error_332 != 0/* NO_ERROR */) 
					Print("Error ", g_error_332);
				else 	
					g_datetime_416 = iTime(Symbol(), 0, 0);
			}
			else // ECN mode, OrderSend does not send SL and TP, but a following OrderModify command take care of this
			{
				if(sign1==1 && TradeSession() && ContinueTrading && Mspread()) ticket = OrderSend(Symbol(), OP_BUY, lot_mm(), g_price_336, slippage, 0, 0, comment, MagicNumber, 0, Green);
				g_error_332 = GetLastError();
				if (g_error_332 != 0/* NO_ERROR */) 
					Print("Error ", g_error_332);
				else if (OrderSelect(ticket, SELECT_BY_TICKET)) 
				{				
					g_datetime_416 = iTime(Symbol(), 0, 0);
					OrderModify(OrderTicket(),OrderOpenPrice(), g_price_344, g_price_352, 0, CLR_NONE);
				}
			}			
      }
      if (g_iclose_376 < g_ima_408 - Slippage_MA * gi_328 * Point && g_iwpr_392 > (-1 * Level_High) && g_icci_400 > Level_CCI_High && g_iatr_384 > Level_ATR_Stop * gi_328 * Point) 
		{
         g_price_336 = NormalizeDouble(Bid, Digits);
         g_price_344 = NormalizeDouble(g_price_336 + StopLoss * gi_328 * Point, Digits);
         g_price_352 = NormalizeDouble(g_price_336 - TakeProfit * gi_328 * Point, Digits);
			if (!ECN) // Normal mode (No ECN - orders are sent with SL and TP directly	
			{
				if(sign1==-1 && TradeSession() && ContinueTrading && Mspread()) OrderSend(Symbol(), OP_SELL, lot_mm(), g_price_336, slippage, g_price_344, g_price_352, comment, MagicNumber, 0, Red);
				g_error_332 = GetLastError();
				if (g_error_332 != 0/* NO_ERROR */) 
					Print("Error ", g_error_332);
				else g_datetime_416 = iTime(Symbol(), 0, 0);
			} 
			else // ECN mode, OrderSend does not send SL and TP, but a following OrderModify command take care of this
			{
				if(sign1==-1 && TradeSession() && ContinueTrading && Mspread()) ticket = OrderSend(Symbol(), OP_SELL, lot_mm(), g_price_336, slippage, 0, 0, comment, MagicNumber, 0, Red);
				g_error_332 = GetLastError();
				if (g_error_332 != 0/* NO_ERROR */) 
					Print("Error ", g_error_332);
				else if (OrderSelect(ticket, SELECT_BY_TICKET)) 
				{				
					g_datetime_416 = iTime(Symbol(), 0, 0);
					OrderModify(OrderTicket(),OrderOpenPrice(), g_price_344, g_price_352, 0, CLR_NONE);
				}			
			}
      }
   }
   return (0);
}
//+------------------------------------------------------------------+
//| trailing functions                                               |
//+------------------------------------------------------------------+
void tral() {
   if (OrderType() == OP_BUY) {
      if (Paritet != 0 && OrderOpenPrice() + Paritet * gi_328 * Point < Bid && NormalizeDouble(OrderOpenPrice() + Pips * gi_328 * Point, Digits) > NormalizeDouble(OrderStopLoss(),
         Digits) && Bid - (OrderOpenPrice() + Pips * gi_328 * Point) > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + Pips * gi_328 * Point, Digits), OrderTakeProfit(), 0, Yellow);
      if (TraillingType != 0) {
         if (TraillingType == 1) {
            gd_360 = Bid - (TraillingStop + TraillingStep) * gi_328 * Point;
            gd_368 = Bid - TraillingStop * gi_328 * Point;
         }
         if (TraillingType == 2) {
            gd_360 = Low[iLowest(Symbol(), 0, MODE_LOW, TraillingBar, 1)];
            gd_368 = Low[iLowest(Symbol(), 0, MODE_LOW, TraillingBar, 1)];
         }
         if (NormalizeDouble(gd_360, Digits) > NormalizeDouble(OrderStopLoss(), Digits) && NormalizeDouble(OrderOpenPrice(), Digits) <= NormalizeDouble(gd_368, Digits) && Bid - gd_368 > MarketInfo(Symbol(),
            MODE_STOPLEVEL) * Point) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(gd_368, Digits), OrderTakeProfit(), 0, Yellow);
      }
   }
   if (OrderType() == OP_SELL) {
      if (Paritet != 0 && OrderOpenPrice() - Paritet * gi_328 * Point > Ask && NormalizeDouble(OrderOpenPrice() - Pips * gi_328 * Point, Digits) < NormalizeDouble(OrderStopLoss(),
         Digits) && OrderOpenPrice() - Pips * gi_328 * Point - Ask > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - Pips * gi_328 * Point, Digits), OrderTakeProfit(), 0, Yellow);
      if (TraillingType != 0) {
         if (TraillingType == 1) {
            gd_360 = Ask + (TraillingStop + TraillingStep) * gi_328 * Point;
            gd_368 = Ask + TraillingStop * gi_328 * Point;
         }
         if (TraillingType == 2) {
            gd_360 = High[iHighest(Symbol(), 0, MODE_HIGH, TraillingBar, 1)];
            gd_368 = High[iHighest(Symbol(), 0, MODE_HIGH, TraillingBar, 1)];
         }
         if (NormalizeDouble(gd_360, Digits) < NormalizeDouble(OrderStopLoss(), Digits) && NormalizeDouble(OrderOpenPrice(), Digits) >= NormalizeDouble(gd_368, Digits) && gd_368 - Ask > MarketInfo(Symbol(),
            MODE_STOPLEVEL) * Point) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(gd_368, Digits), OrderTakeProfit(), 0, Yellow);
      }
   }
}
//+------------------------------------------------------------------+
//| close by signal                                                  |
//+------------------------------------------------------------------+   
int close_signal(int ai_0, double ad_4) {
   if (ai_0 == 0) {
      if (Close_Williams > 0 && (-1.0 * g_iwpr_392) < Williams_Close_Buy && Only_Profit < 0 || Bid > ad_4 + Only_Profit * gi_328 * Point) return (1);
      if (Close_CCI > 0 && g_icci_400 > CCI_Close_Buy) return (1);
      if (gi_224 > 0 && g_iatr_384 < gi_228 * gi_328 * Point) return (1);
      if (gi_240 == 1 && iClose(NULL, 0, 1) < g_ima_408) return (1);
      if (gi_244 == 1 && g_ima_408 < iMA(NULL, 0, MA_Period, 0, MODE_SMMA, PRICE_CLOSE, 2)) return (1);
   }
   if (ai_0 == 1) {
      if (Close_Williams > 0 && (-1.0 * g_iwpr_392) > Williams_Close_Sell && Only_Profit < 0 || Ask < ad_4 - Only_Profit * gi_328 * Point) return (1);
      if (Close_CCI > 0 && g_icci_400 < CCI_Close_Sell) return (1);
      if (gi_224 > 0 && g_iatr_384 < gi_228 * gi_328 * Point) return (1);
      if (gi_240 == 1 && iClose(NULL, 0, 1) > g_ima_408) return (1);
      if (gi_244 == 1 && g_ima_408 > iMA(NULL, 0, MA_Period, 0, MODE_SMMA, PRICE_CLOSE, 2)) return (1);
   }
   return (0);
}

double lot_mm() {
   double ld_0 = Lot;
   if (Lot == 0.0) ld_0 = AccountBalance() / 100000.0 * MM;
   return (norm_l(ld_0));
}

double norm_l(double ad_0) {
   ad_0 = MathRound(ad_0 / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
   if (ad_0 > MarketInfo(Symbol(), MODE_MAXLOT)) ad_0 = MarketInfo(Symbol(), MODE_MAXLOT);
   if (ad_0 < MarketInfo(Symbol(), MODE_MINLOT)) ad_0 = MarketInfo(Symbol(), MODE_MINLOT);
   return (ad_0);
}
