//+------------------------------------------------------------------+
//|                                                      Charles.mq4 |
//|                                       Copyright 2012, AlFa Corp. |
//|                                      alessio.fabiani @ gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, AlFa"
#property link      "alessio.fabiani @ gmail.com"

//#include <sqlite.mqh>
#include <stderror.mqh>
#include <stdlib.mqh>
#include <hash.mqh>
#include <orders.mqh>

#define VER "Blade"

#define DECIMAL_CONVERSION 10

extern int MAGICMA           = 3937;   //[MAGICMA] - Magic (deve essere unico)
extern double xFactor        = 1.55;   //[xFactor] - Fattore mux degli hedge
extern bool ProTrend         = true;   //[ProTrend] - Laterale segue il Trend o Reverse
extern bool UltraShock       = true;  //[UltraShock] - Abilita la modalità griglia aggressiva
extern double UltraShockDistance= 3;   //[UltraShockDistance] - Distanza in pips della maglia
extern double UltraShockDistMux = 2;   //[UltraShockDistMux] - Moltiplicatore della distanza in pips
extern double UltraShockSLPerc  = 50;  //[UltraShockSLPerc] - % StopLoss alla quale iniziare a compensare
extern int UltraMaxOrders    = 10;     //[UltraMaxOrders] - Massimo numero di ordini a mercato
extern double DDShield       = 20;     //[DDShield] - Massimo DD in a row
/*extern*/ int FreezeMinutes = PERIOD_D1;
/*extern*/ double FreezeLossPerc = 5;
extern double Lots           = 0.1;    //[Lots] - Lotto fisso se LotPercent = 0
extern int LotDigits         = 2;      //[LotDigits] - Cifre decimali del Lotto
extern double LotPercent     = 10.0;   //[LotPercent] - Lotto variabile in base al Balance
extern bool LotStepEnable    = true;   //[LotStepEnable] - Aumenta il lotto a Step (usa Lots se LotPercent = 0)
extern double LotStepValue   = 0.01;   //[LotStepValue] - Il valore del singolo step da aumentare
extern double LotStepFrom    = 500;   //[LotStepFrom] - Balance di riferimento
extern double LotStepEvery   = 100;   //[LotStepEvery] - Step monetario di Aumento/Decremento del Balance
extern int Leverage          = 200;    //[Leverage] - Leverage fissa del lotto
/*extern*/ int BreakEvenAtPips   = 20;     //[BreakEvenAtPips] - Pips positivi per entrare in BE
/*extern*/ int BreakEvenInPips   = 5;      //[BreakEvenInPips] - Pips di BE > 0
/*extern*/ int TrailingStop      = 40;     //[TrailingStop] - Dynamic StopLoss degli Ordini
extern int StopLoss          = 25;     //[StopLoss] - Hard StopLoss degli Ordini
/*extern*/ int TakeProfit = 0;
extern int Slippage          = 2;      //[Slippage] - Massimo Slippage degli Ordini
/*extern*/ int MAPeriod          = 14;     //[MAPeriod] - Periodi per la Media Mobile
/*extern*/ int MA_Type           = 0;      //[MA_Type] - 0=SMA, 1=EMA, 2=SMMA, 3=LWMA
/*extern*/ int PrevMAShift       = 5;      //[PrevMAShift] - Numero di Barre indietro
/*extern*/ int CurMAShift        = 0;      //[CurMAShift] - Numero di Barra corrente
/*extern*/ int MA_AppliedPrice   = 0;      //[MA_AppliedPrice] - Prezzo applicazione media: 0=close
/*extern*/ string  p0            = " 0 = close";
/*extern*/ string  p1            = " 1 = open";
/*extern*/ string  p2            = " 2 = high";
/*extern*/ string  p3            = " 3 = low";
/*extern*/ string  p4            = " 4 = median(high+low)/2";
/*extern*/ string  p5            = " 5 = typical(high+low+close)/3";
/*extern*/ string  p6            = " 6 = weighted(high+low+close+close)/4";
/*extern*/ double sogliaMinima_velocita=3; //[sogliaMinima_velocita] - Soglia Minima di Velocità
/*extern*/ string smin0          = " misura in pip della minima velocità di soglia, cioè della minima variazione di pip, che si deve avere su due punti della media mobile";
/*extern*/ string smin1          = " perché si consideri il mercato corrente in trend e non in laterale.";
/*extern*/ double sogliaMinima_accelerazione=5; //[sogliaMinima_accelerazione] - Soglia Minima di Accelerazione
/*extern*/ string smin2          = " misura in pip della minima variazione di velocità che la media mobile deve avere su due punti della media mobile";
/*extern*/ string smin3          = " perché si consideri che il mercato sta dimnostrando una forza di accelerazione in grado di far partire un trend";
/*extern*/ bool regressione_R1   = true;   //[regressione_R1] - Se false, la retta di regressione R1 non viene visualizzata
/*extern*/ int tfInMinuti_R1     = 60;     //[tfInMinuti_R1] - Timeframe in minuti della retta di regressione R1
/*extern*/ int PeriodRegr_R1     = 3;      //[PeriodRegr_R1] - Numero di barre della retta di regressione R1
/*extern*/ double pipLimite_R1   = 8;      //[pipLimite_R1] - Pip di trend della retta di regressione R1
/*extern*/ bool regressione_R2   = true;   //[regressione_R2] - Se false, la retta di regressione R2 non viene visualizzata
/*extern*/ int tfInMinuti_R2     = 30;     //[tfInMinuti_R2] - Timeframe in minuti della retta di regressione R2
/*extern*/ int PeriodRegr_R2     = 5;      //[PeriodRegr_R2] - Numero di barre della retta di regressione R2
/*extern*/ double pipLimite_R2   = 8;      //[pipLimite_R2] - Pip di trend della retta di regressione R2
/*extern*/ bool regressione_R3   = true;   //[regressione_R3] - Se false, la retta di regressione R3 non viene visualizzata
/*extern*/ int tfInMinuti_R3     = 15;     //[tfInMinuti_R3] - Timeframe in minuti della retta di regressione R3
/*extern*/ int PeriodRegr_R3     = 8;      //[PeriodRegr_R3] - Numero di barre della retta di regressione R3
/*extern*/ double pipLimite_R3   = 8;      //[pipLimite_R3] - Pip di trend della retta di regressione R3
/*extern*/ bool regressione_R4   = false;  //[regressione_R4] - Se false, la retta di regressione R4 non viene visualizzata
/*extern*/ int tfInMinuti_R4     = 5;      //[tfInMinuti_R4] - Timeframe in minuti della retta di regressione R4
/*extern*/ int PeriodRegr_R4     = 30;     //[PeriodRegr_R4] - Numero di barre della retta di regressione R4
/*extern*/ double pipLimite_R4   = 8;      //[pipLimite_R4] - Pip di trend della retta di regressione R4
/*extern*/ int applied_price     = 0;      //[applied_price] - 0 = Close price; 1 = Open price
//---- input parameters
/*extern*/ int Viscosity         = 14;     //[Viscosity] - Volatility Viscosity
/*extern*/ int Sedimentation     = 50;     //[Sedimentation] - Volatility Sedimentation
/*extern*/ double Threshold_level= 1.1;    //[Threshold_level] - Volatility Threshold
/*extern*/ bool lag_supressor    = true;   //[lag_supressor] - Volatility Lag Suppressor
/*extern*/ bool AllOrders        = false;  //[AllOrders] - Gestisce TUTTI gli Ordini (anche manuali)
/*extern*/ bool LogToFile        = false;  //[LogToFile] - Scrive Log anche su file
/*extern*/ double ATR_Slow_Period = 60;
/*extern*/ double ATR_Fast_Period = 1;
/*extern*/ int MinutesToSleep = PERIOD_H4;
/*extern*/ int LittleSpikeMultiplier = 3;
/*extern*/ int BigSpikeMultiplier = 5;

//---------------------------------------------------------------------------

#define TREND_LATERALE 0
#define TREND_LATERALE_RIBASSO 1
#define TREND_LATERALE_RIALZO 2

#define TREND_CRESCENTE_ACC_NEGATIVA 4
#define TREND_DECRESCENTE_ACC_POSITIVA 5

#define TREND_CRESCENTE_POCO_FORTE 6
#define TREND_DECRESCENTE_POCO_FORTE 7

#define TREND_CRESCENTE_FORTE 8
#define TREND_DECRESCENTE_FORTE 9

//---------------------------------------------------------------------------
 
int PendingBuy, PendingSell, Buys, Sells, i, Spread, STOPLEVEL;
double BuyLots, SellLots, PendingBuyLots, PendingSellLots;
double Focus, Profit, LastProfit, MaxProfit;
double stoploss,takeprofit;
double LotsValue, Denominator;
double MaxPrice,MinPrice,MaxOpenPrice,MinOpenPrice;
bool isInGain=false, blockConditionHit=false, frozen=false, spikeAlert=false, unlockOrdersPlaced=false; 
int LastOrderTicket = -1, UnlockingOrderTicket = -1;
int FirstOrderTicket = -1;

double trailingStop, trailingProfit;
//double stopLoss, takeProfit;

datetime lastBarTime, lastFreezeTime, lastSpikeAlertTime, currentBarTime;
bool sessionReset = true;
bool sessionTrading = true;
bool stopTrading = false;
bool volatility = false;
double lag_s_K=0.5;
//----
double pp;
int pd;
double cf;
//---
int iWPR_Filter_OpenLong_a;
int iWPR_Filter_OpenLong_b;
int iWPR_Filter_OpenShort_a;
int iWPR_Filter_OpenShort_b;
//---
int iWPR_Filter_CloseLong;
int iWPR_Filter_CloseShort;
//---

//---- buffers
double thresholdBuffer[];
double vol_m[];
double vol_t[];
double ind_c[];
double pivots[];
double soglie[];
double regression_line[];           // array dei valori della retta di regressione 

int trend,trend_RL,trend_RL_Threshold,trend_R1,trend_R2,trend_R3,trend_R4;

int TradeSeries;
double StartingBalance;
//----

//+------------------------------------------------------------------+
//| Init function                                                    |
//+------------------------------------------------------------------+
void init()
{
   STOPLEVEL = MarketInfo(Symbol(),MODE_STOPLEVEL);
   Spread   = MarketInfo(Symbol(),MODE_SPREAD);
   if (Digits == 3 || Digits == 5)   {
      StopLoss       *=    DECIMAL_CONVERSION;
      Spread         *=    DECIMAL_CONVERSION;
      STOPLEVEL      *=    DECIMAL_CONVERSION;
   }

   //---
   if (Digits < 4) {
      pp = 0.01;
      pd = 2;
      cf = 0.009;
   } else {
      pp = 0.0001;
      pd = 4;
      cf = 0.00009;
   }
   //----
   TradeSeries = rand();
   StartingBalance = AccountBalance();
   //----
   if(LogToFile){startFile();}
   if(AccountBalance()<1000){Denominator=400;}
   else{Denominator=200;}
   //----
   getNearestAndFarestSR(Symbol(),Period(),Bid,pivots);
   //----
   trend = adjustTrend(trend);
   //----   
   lastBarTime = TimeCurrent();
   currentBarTime = TimeCurrent();
   //----
   sqVolatility(Symbol(),PERIOD_H1);
   volatility = true;//!sqVolatility(Symbol(),PERIOD_H1);
   //----
   //--- Параметры на открытие
   
   iWPR_Filter_OpenLong_a = iWPR_Filter_Open_a;
   iWPR_Filter_OpenLong_b = iWPR_Filter_Open_b;
   iWPR_Filter_OpenShort_a = -100 - iWPR_Filter_Open_a;
   iWPR_Filter_OpenShort_b = -100 - iWPR_Filter_Open_b;

   //--- Параметры на закрытие
   
   iWPR_Filter_CloseLong = iWPR_Filter_Close;
   iWPR_Filter_CloseShort = -100 - iWPR_Filter_Close;
   if (iWPR_Close_Period<=0) iWPR_Close_Period=iWPR_Period;

   //---
}

//----
bool TryToOpenFurtherPendings = true;
//----

//+------------------------------------------------------------------+
//| Start function                                                   |
//+------------------------------------------------------------------+
void start()
{
//-----------------------------------
//--- BLOCKING CONDITION
   if( !frozen && blockConditionHit && (TimeCurrent() - lastFreezeTime) >= FreezeMinutes*60 )
   {
      Log("[LOSS CONDITION] - Freezing ... if [blockConditionHit] AND [",(TimeCurrent() - lastFreezeTime)," >= ",FreezeMinutes*60);
      Log("[LOSS CONDITION] - Freezing for ",IntegerToString(FreezeMinutes)," minutes...");
      DeleteAllPendingOrders();
      frozen = true;
      lastFreezeTime=TimeCurrent();
   }

   if( frozen )
   {
      if( (TimeCurrent() - lastFreezeTime) >= FreezeMinutes*60 ) 
      {
         Log("[LOSS CONDITION] - DeFreeze after ",IntegerToString(FreezeMinutes)," minutes...");
         blockConditionHit = false;
         frozen = false;
      }
      else
      {
         return;
      }
   }
//-----------------------------------
//--- SPIKE ALERT
   bool spikeDetected = false;
   
   //---
   double ATRfast = iATR(Symbol(), PERIOD_M15, ATR_Fast_Period, 0);
   double ATRslow = iATR(Symbol(), PERIOD_M15, ATR_Slow_Period, 0);   
   if ( ATRfast >= (BigSpikeMultiplier *  ATRslow) ) spikeDetected = true;
   //---
   ATRfast = iATR(Symbol(), PERIOD_M30, ATR_Fast_Period, 0);
   ATRslow = iATR(Symbol(), PERIOD_M30, ATR_Slow_Period, 0);   
   if ( ATRfast >= (BigSpikeMultiplier *  ATRslow) ) spikeDetected = true;
   //---
   ATRfast = iATR(Symbol(), PERIOD_H1, ATR_Fast_Period, 0);
   ATRslow = iATR(Symbol(), PERIOD_H1, ATR_Slow_Period, 0);   
   if ( ATRfast >= (BigSpikeMultiplier *  ATRslow) ) spikeDetected = true;
   //---
   
   if( !spikeAlert && spikeDetected && (TimeCurrent() - lastSpikeAlertTime) >= MinutesToSleep*60)
   {
      Alert("Spike on " + Symbol() + "!");
      Log("[SPIKE ALERT] - (Fast = " + ATRfast + ", Slow = " + ATRslow + ") - Sleep for "+MinutesToSleep+" minutes ...");
      DeleteAllPendingOrders();
      spikeAlert = true;
      lastSpikeAlertTime = TimeCurrent();
   }

   if( spikeAlert )
   {
      if( (TimeCurrent() - lastSpikeAlertTime) >= MinutesToSleep*60 ) 
      {
         Log("[SPIKE ALERT] - Wake up after ",IntegerToString(MinutesToSleep)," minutes...");
         spikeAlert = false;
      }
      else
      {
         return;
      }
   }
//-----------------------------------   
   // Cleanup
   DeleteAllInvalidOrders();

   double TodayProfit = sqGetProfitToday(Symbol(),MAGICMA);
   double TodayLossPerc = TodayProfit*100/AccountBalance();
   
   // Market Sessions
   sessionTrading = true;
   //----
   Count();
   //-- UltraShock
   bool ultraShock = false;
   if(UltraShock && (Sells+Buys)>0) ultraShock = true;
   //---
   LotsValue = LOT();
   
   int Delta=10;        //Order price shift (in points) from High/Low price
   int LastDay=0;

   double LotsHedgeValue;
       //int mux = (MathAbs(Sells+Buys) > 0 ? MathAbs(Sells+Buys) : 1); //1+(Sells+Buys);
       //if(UltraShock) mux = 1;
       int mux = 1;
       double marketLot = (Sells+Buys == 0 ? LotsValue : sqGetMarketLot(Symbol(),MAGICMA));
              marketLot = (marketLot < 0 ? LotsValue : marketLot);

       LotsHedgeValue = (marketLot*xFactor*mux);
       LotsHedgeValue = NormalizeDouble(LotsHedgeValue, 2);
       if(LotsHedgeValue < MarketInfo(Symbol(), MODE_MINLOT))
       {
          LotsHedgeValue = NormalizeDouble(MarketInfo(Symbol(), MODE_MINLOT)*xFactor, LotDigits);
       }
       if(LotsHedgeValue > MarketInfo(Symbol(), MODE_MAXLOT))
       {
          LotsHedgeValue = NormalizeDouble(MarketInfo(Symbol(), MODE_MAXLOT), LotDigits);
       }

   double lot = NormalizeDouble((Sells+Buys == 0 ? LotsValue : LotsHedgeValue),LotDigits);
   //---
   
   // 2 Minutes Bar
   if( (TimeCurrent() - currentBarTime) >= 2 * 60 ) 
   {
      //----
         getNearestAndFarestSR(Symbol(),PERIOD_H1,Bid,pivots);
      //----
         trend = adjustTrend(trend);
      //----   
         currentBarTime = TimeCurrent();
      //----
   
      //-- Volatility
      if( (TimeCurrent() - lastBarTime) >= PERIOD_M1 * 60 )
      {
//-------------------------------
         volatility = true;//!sqVolatility(Symbol(),PERIOD_H1);
         lastBarTime = TimeCurrent();         
        
         if (!volatility) {
            DeleteAllPendingOrders();
            TryToOpenFurtherPendings = false;
            //----
         }
         
         if ( AccountFreeMargin()>0 && sessionTrading && !stopTrading )
         {
            Count();
      
         //-- SYSTEM CORE
         //----
            getNearestAndFarestSR(Symbol(),PERIOD_H1,Bid,pivots);
         //----
            // --- Orders Management
            Count();
         //-----------------------------------------
            if(
               TryToOpenFurtherPendings && volatility /*&& Month() != 12*/ && 
               !((DayOfWeek()==5 && Hour()>=7) || DayOfWeek()==6 || DayOfWeek()==0 || (DayOfWeek()==1 && Hour()<=3)) &&
               !(is_market_session_open(20,23))
              )
            {
            //-------------------------------------------------------------------------
               int ProfitablePositionToday = sqGetProfitablePositionToday(Symbol(),MAGICMA);
               int macdSignal = 0;
               int macdDatetime = iTime(Symbol(), PERIOD_H1, 0);
               int macdShift = iBarShift(Symbol(), PERIOD_H1, macdDatetime - 60 * PERIOD_H1, FALSE);
               
               if (iMACD(Symbol(), PERIOD_H1, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, macdShift) > iMACD(Symbol(), PERIOD_H1, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, macdShift)) macdSignal = 2;
               else macdSignal = 1;
               
               double sma0_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,0);
               double sma0_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,0);
               double sma3_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,3);
               double sma3_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,3);
               
               //0 - MODE_MAIN, 1 - MODE_PLUSDI, 2 - MODE_MINUSDI
               double adx0_14 = iADX(Symbol(),PERIOD_H1,14,PRICE_HIGH,MODE_MAIN,0);
               double adx1_14 = iADX(Symbol(),PERIOD_H1,14,PRICE_HIGH,MODE_MAIN,1);
               
               // 0 - MODE_MAIN, 1 - MODE_UPPER, 2 - MODE_LOWER
               double bb0L_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,0);
               double bb1L_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,1);
               double bb2L_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,2);
               double bb3L_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_LOWER,3);

               double bb0M_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,0);
               double bb1M_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,1);
               double bb2M_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,2);
               double bb3M_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_MAIN,3);

               double bb0U_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,0);
               double bb1U_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,1);
               double bb2U_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,2);
               double bb3U_20 = iBands(Symbol(),PERIOD_H1,20,2,0,PRICE_CLOSE,MODE_UPPER,3);               
            //-------------------------------------------------------------------------
               if( Buys+Sells==0 )
               {
                  //-----------------------------
                  //--- Bollinger Bands
                  //-----------------------------
                  /*
                   * double high  = High[i];
                   * double low   = Low[i];
                   * double open  = Open[i];
                   * double close = Close[i];
                   */
                  //---
                  Count();
                  //---
                  if(
                     Buys+Sells<=UltraMaxOrders && 
                     adx1_14 > 40 && 
                     (MathAbs(adx0_14 - 40)<0.5 || adx0_14<40 ) ) 
                  {
                     if( 
                        //regressionTrend() == TREND_LATERALE &&
                        //AccountBalance() >= StartingBalance &&
                        sma0_200 > sma0_50 && sma3_200 > sma3_50 && 
                        (Open[1]>bb1U_20 && Close[1]<bb1U_20) || (Open[2]>bb2U_20 && Close[2]<bb2U_20) || (Open[3]>bb3U_20 && Close[3]<bb3U_20) &&
                        macdSignal == 1
                       )
                     {
                        // SELL
                        stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);

                     }
                     else if( 
                        //regressionTrend() == TREND_LATERALE &&
                        //AccountBalance() >= StartingBalance &&
                        sma0_200 < sma0_50 && sma3_200 < sma3_50 &&
                        (Open[1]<bb1L_20 && Close[1]>bb1L_20) || (Open[2]<bb2L_20 && Close[2]>bb2L_20) || (Open[3]<bb3L_20 && Close[3]>bb3L_20) &&
                        macdSignal == 2
                       )
                     {
                        // BUY
                        stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                     }
                  }
                  else if(
                     Buys+Sells<=UltraMaxOrders && 
                     adx1_14 < 20  && 
                     (MathAbs(adx0_14 - 20)<0.5 || adx0_14>20) ) 
                  {
                     if( 
                        //regressionTrend() == TREND_LATERALE &&
                        //AccountBalance() >= StartingBalance &&
                        sma0_200 > sma0_50 && sma3_200 > sma3_50 && 
                        (Open[1]>bb1M_20 && Close[1]<bb1M_20) || (Open[2]>bb2M_20 && Close[2]<bb2M_20) || (Open[3]>bb3M_20 && Close[3]<bb3M_20) &&
                        macdSignal == 1
                       )
                     {
                        // SELL
                        stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                     }
                     else if( 
                        //regressionTrend() == TREND_LATERALE &&  
                        //AccountBalance() >= StartingBalance &&  
                        sma0_200 < sma0_50 && sma3_200 < sma3_50 &&
                        (Open[1]<bb1M_20 && Close[1]>bb1M_20) || (Open[2]<bb2M_20 && Close[2]>bb2M_20) || (Open[3]<bb3M_20 && Close[3]>bb3M_20) &&
                        macdSignal == 2
                       )
                     {
                        // BUY
                        stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                     }
                  }
                  //--------------------------
                  //--- W-Street Signals
                  //--------------------------
                  //---
                  Count();
                  //---
                   if ( 
                     Buys+Sells<=UltraMaxOrders && (
                     OpenLongSignal() ||
                     (
                        iLow(Symbol(),PERIOD_H1,1)>iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,1) && 
                        iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,0)>iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,0) && 
                        iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,0)>iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,0) &&
                        iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,0)>iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,1)&&iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,1)>iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,2) &&
                        iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,0)>iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,1)&&iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,1)>iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,2) &&
                        iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,0)>iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,1)&&iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,1)>iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,2) &&
                        iMA(Symbol(),PERIOD_H1,14,0,MODE_EMA,PRICE_MEDIAN,0)>iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,0)
                     )
                  ) )
                  {
                     if(ProTrend)
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                     }
                     else
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                     }
                  }
                  else if ( 
                    Buys+Sells<=UltraMaxOrders && (
                    OpenShortSignal() ||
                    (
                        iHigh(Symbol(),PERIOD_H1,1)<iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,1) && 
                        iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,0)<iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,0) && 
                        iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,0)<iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,0) &&
                        iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,0)<iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,1)&&iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,1)<iMA(Symbol(),PERIOD_H1,600,0,MODE_EMA,PRICE_MEDIAN,2) &&
                        iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,0)<iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,1)&&iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,1)<iMA(Symbol(),PERIOD_H1,200,0,MODE_EMA,PRICE_MEDIAN,2) &&
                        iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,0)<iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,1)&&iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,1)<iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,2) &&
                        iMA(Symbol(),PERIOD_H1,14,0,MODE_EMA,PRICE_MEDIAN,0)<iMA(Symbol(),PERIOD_H1,75,0,MODE_EMA,PRICE_MEDIAN,0)
                    )
                  ) )
                  {
                     if(ProTrend)
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                     }
                     else
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                     }
                  }
                  //--------------------------
                  //--- Regressione Lineare
                  //--------------------------
                  //---
                  Count();
                  //---
                  if ( 
                       Buys+Sells<=UltraMaxOrders && 
                       regressionTrend() == TREND_CRESCENTE_FORTE && 
                       //AccountBalance() >= StartingBalance &&
                       sma0_200 < sma0_50 && sma3_200 < sma3_50 && 
                       iRSI(Symbol(), PERIOD_H1, 14, PRICE_CLOSE, 1) < 70.0 &&
                       macdSignal == 2) 
                  {
                     if(ProTrend)
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                     }
                     else
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                     }
                  } else if ( 
                       Buys+Sells<=UltraMaxOrders && 
                       regressionTrend() == TREND_DECRESCENTE_FORTE && 
                       //AccountBalance() >= StartingBalance &&
                       sma0_200 > sma0_50 && sma3_200 > sma3_50 && 
                       iHigh(Symbol(), PERIOD_H1, 1) > iLow(Symbol(), PERIOD_H1, 2) &&
                       macdSignal == 1 ) 
                  {
                     if(ProTrend)
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                     }
                     else
                     {
                        stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                        takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                        LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                     }
                  }
               }
            }
         //-----------------------------------------
         }
      }
//-------------------------------
   }
   //----
   Count();
   //----
   
   //---------------------------------------------------------------------------------------------------------------------------------
   //----------------------------------------- ULTR SHOCK and RECOVERY ---------------------------------------------------------------
   //---------------------------------------------------------------------------------------------------------------------------------

   if(UltraShock)
   {
/*
      switch(trend)
      {
         case TREND_CRESCENTE_FORTE:
            if (regressionTrend() == TREND_CRESCENTE_FORTE)
               UltraShockRecoveryGridUP(lot);
            break;
   
         case TREND_DECRESCENTE_FORTE:
            if (regressionTrend() == TREND_DECRESCENTE_FORTE)
               UltraShockRecoveryGridDOWN(lot);
            break;
   
         default:
            UltraShockRecoveryGrid(lot);
            break;
      }
*/

      //UltraShockRecoveryGridUP(lot);
      //UltraShockRecoveryGridDOWN(lot);

      UltraShockRecoveryGrid(lot);

   }
   
   //---------------------------------------------------------------------------------------------------------------------------------
   //---------------------------------------------------------------------------------------------------------------------------------
   //---------------------------------------------------------------------------------------------------------------------------------

   CheckForClose();
}
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

void UltraShockRecoveryGrid(double lot)
{
   Count();
      
   RefreshRates();
   
   int mux = (UltraShockDistMux == 0 ? 1 : ((Sells+Buys) <= 1 ? 1 : (Sells+Buys)*UltraShockDistMux) );
   
   int div = 1;
   if (Digits == 3 || Digits == 5)
   {
     div *= DECIMAL_CONVERSION;
   }
   
   double DDFromStart                = (AccountEquity()-StartingBalance)*100/StartingBalance;
   double MarketPipDistance          = sqGetMarketPipDistance(Symbol(),MAGICMA);
   double MaxMarketStopLossThreshold = (/*(StopLoss/div)-*/((StopLoss/div)*(UltraShockSLPerc/100)));
   
//----
   double MaxMarketPipDistance       = sqGetMaxMarketPipDistance(Symbol(),MAGICMA);
   	    MaxMarketPipDistance       = (MaxMarketPipDistance == EMPTY_VALUE ? 0 : MaxMarketPipDistance);

   int orderType = OrderType();
   int orderTicket = OrderTicket();
//----
   if(
      (Profit < 0 && UltraShock ) &&
      (
         (Sells+Buys > 1 && MaxMarketPipDistance != 0 && MaxMarketPipDistance <= -MaxMarketStopLossThreshold) ||
         (Sells+Buys == 1 && sqGetOrderPipDistance(Symbol(),OrderTicket()) <= -mux*UltraShockDistance) 
      )
     )
   {
//--------------------
      bool canOpenBallanceOrders = false;
      int orderWinType = sqGetMarketWinPosition(Symbol(),MAGICMA);
      int profitablePositionToday = sqGetProfitablePositionToday(Symbol(),MAGICMA);
//--------------------
      if(OrderSelect(orderTicket,SELECT_BY_TICKET,MODE_TRADES))
      {
         if( MarketPipDistance <= -mux*UltraShockDistance && Sells+Buys <= UltraMaxOrders )
         {
            canOpenBallanceOrders = true;         
         }
         
         if( Sells+Buys >= UltraMaxOrders && 
             //orderWinType >= 0 && orderWinType != orderType &&
             MaxMarketPipDistance <= -MaxMarketStopLossThreshold )
         {
            canOpenBallanceOrders = sqClosePositionAtMarket(OrderLots(),Slippage);
         }
         
         if (canOpenBallanceOrders) 
         {
   
            Count();
         
            RefreshRates();
   
   //--------------------
            double sma0_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,0);
            double sma0_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,0);
            double sma3_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,3);
            double sma3_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,3);
   //--------------------
            switch(trend)
            {
               case TREND_DECRESCENTE_FORTE:
                  if ( regressionTrend() == TREND_DECRESCENTE_FORTE ) 
                  {
                     stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                     takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                     LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                  }
                  
                  break;
                  
               case TREND_CRESCENTE_FORTE:
                  if ( regressionTrend() == TREND_CRESCENTE_FORTE )
                  {
                     stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                     takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                     LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                  }
                  
                  break;
                      
               default:
                     if( orderWinType == OP_SELL || profitablePositionToday == OP_SELL || 
                         (orderType == OP_BUY && 
                          regressionTrend() == TREND_LATERALE
                          //sma0_200 > sma0_50 && sma3_200 > sma3_50 
                         ) )
                     {
                        if(ProTrend)
                        {
                           stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                           takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                           LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                        }
                        else
                        {
                           stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                           takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                           LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                        }
                     }
                     else if( orderWinType == OP_BUY || profitablePositionToday == OP_BUY || 
                             (orderType == OP_SELL && 
                              regressionTrend() == TREND_LATERALE
                              //sma0_200 < sma0_50 && sma3_200 < sma3_50
                             ) )
                     {
                        if(ProTrend)
                        {
                           stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
                           takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
                           LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
                        }
                        else
                        {
                           stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
                           takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
                           LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
                        }
                     }
                  break;
            }
   //--------------------
         }
      }
   }
}

//---------------------------------------------------------------------------

void UltraShockRecoveryGridUP(double lot)
{
   Count();
   
   RefreshRates();
//--------------------
   int mux = (UltraShockDistMux == 0 ? 1 : ((Sells+Buys) <= 1 ? 1 : (Sells+Buys)*UltraShockDistMux) );
   
   int div = 1;
   if (Digits == 3 || Digits == 5)
   {
     div *= DECIMAL_CONVERSION;
   }
//--------------------
   double MaxMarketStopLossThreshold = (/*(StopLoss/div)-*/((StopLoss/div)*(UltraShockSLPerc/100)));
//--------------------
   double sma0_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,0);
   double sma0_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,0);
   double sma3_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,3);
   double sma3_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,3);
//--------------------
   bool canOpenBallanceOrders = false;
   int orderWinType = sqGetMarketWinPosition(Symbol(),MAGICMA);
   int profitablePositionToday = sqGetProfitablePositionToday(Symbol(),MAGICMA);
//--------------------
   int lastOrderTicket = -1;
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (OrderSelect(cc, SELECT_BY_POS) && OrderSymbol() == Symbol()) {
         if(OrderType() == OP_BUY && OrderMagicNumber() == MAGICMA) {
            lastOrderTicket = OrderTicket();
            break;
         }
      }
   }
//--------------------
   if (lastOrderTicket >= 0)
   {
      double OrderPipDistance = sqGetOrderPipDistance(Symbol(),lastOrderTicket);
      if(//sma0_200 < sma0_50 && sma3_200 < sma3_50 &&
         OrderPipDistance >= mux*UltraShockDistance && OrderPipDistance <= 2*mux*UltraShockDistance && 
         Sells+Buys <= UltraMaxOrders && OrderType() == OP_BUY && (orderWinType == OP_BUY || profitablePositionToday == OP_BUY) )
      {
         stoploss   = (StopLoss == 0 ? 0 : Bid-(StopLoss)*Point-Spread*Point-STOPLEVEL*Point);
         takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
         LastOrderTicket=OpenOrder(lot, OP_BUY, stoploss, takeprofit);
      }
   }
}

//---------------------------------------------------------------------------

void UltraShockRecoveryGridDOWN(double lot)
{
   Count();
   
   RefreshRates();
//--------------------
   int mux = (UltraShockDistMux == 0 ? 1 : ((Sells+Buys) <= 1 ? 1 : (Sells+Buys)*UltraShockDistMux) );
   
   int div = 1;
   if (Digits == 3 || Digits == 5)
   {
     div *= DECIMAL_CONVERSION;
   }
//--------------------
   double MaxMarketStopLossThreshold = (/*(StopLoss/div)-*/((StopLoss/div)*(UltraShockSLPerc/100)));
//--------------------
   double sma0_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,0);
   double sma0_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,0);
   double sma3_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,3);
   double sma3_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,3);
//--------------------
   bool canOpenBallanceOrders = false;
   int orderWinType = sqGetMarketWinPosition(Symbol(),MAGICMA);
   int profitablePositionToday = sqGetProfitablePositionToday(Symbol(),MAGICMA);
//--------------------
   int lastOrderTicket = -1;
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (OrderSelect(cc, SELECT_BY_POS) && OrderSymbol() == Symbol()) {
         if(OrderType() == OP_SELL && OrderMagicNumber() == MAGICMA) {
            lastOrderTicket = OrderTicket();
            break;
         }
      }
   }
//--------------------
   if (lastOrderTicket >= 0)
   {
      double OrderPipDistance = sqGetOrderPipDistance(Symbol(),lastOrderTicket);
      if(//sma0_200 > sma0_50 && sma3_200 > sma3_50 &&
         OrderPipDistance >= mux*UltraShockDistance && OrderPipDistance <= 2*mux*UltraShockDistance && 
         Sells+Buys <= UltraMaxOrders && OrderType() == OP_SELL && (orderWinType == OP_SELL || profitablePositionToday == OP_SELL) )
      {
         stoploss   = (StopLoss == 0 ? 0 : Ask+(StopLoss)*Point+Spread*Point+STOPLEVEL*Point);
         takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
         LastOrderTicket=OpenOrder(lot, OP_SELL, stoploss, takeprofit);
      }
   }
}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
int getTrend(int period, double& soglie[])
{
   if(CurMAShift >= PrevMAShift)
   {
      Alert("Errore: CurMAShift deve essere minore di PrevMAShift");
      PrevMAShift = 1;
      CurMAShift = 0;      
   }
   
   int MA_Mode;
   switch (MA_Type)
     {
      case 1:  /*strMAType="EMA"; */ MA_Mode=MODE_EMA; break;
      case 2:  /*strMAType="SMMA";*/ MA_Mode=MODE_SMMA; break;
      case 3:  /*strMAType="LWMA";*/ MA_Mode=MODE_LWMA; break;
      default: /*strMAType="SMA"; */ MA_Mode=MODE_SMA; break;
     }

   int MA_Shift;
   switch(period)
      {
         case PERIOD_M15:  MA_Shift = PrevMAShift * 4; break;
         case PERIOD_M30:  MA_Shift = PrevMAShift * 2; break;
         default:          MA_Shift = PrevMAShift; break;
      }

   double Poin;
   if(Digits == 3 || Digits == 5)   Poin = Point*10;
   else Poin = Point;
   
   double VelocitaBuffer[];
   double AccelerazioneBuffer[];
   ArrayResize(VelocitaBuffer,2*MA_Shift+1);
   ArrayResize(AccelerazioneBuffer,2*MA_Shift+1);
   ArrayInitialize(VelocitaBuffer,0);
   ArrayInitialize(AccelerazioneBuffer,0);
   
   ArrayResize(soglie,3);
   ArrayInitialize(soglie,EMPTY_VALUE);
   
   for(int mm=MA_Shift;mm>=0;mm--)
   {
      double MACur=iMA(Symbol(),period,MAPeriod,0,MA_Mode,MA_AppliedPrice,mm+CurMAShift);
      double MAPrev=iMA(Symbol(),period,MAPeriod,0,MA_Mode,MA_AppliedPrice,mm+MA_Shift);
      
      VelocitaBuffer[mm] = (MACur-MAPrev)/Poin;
      AccelerazioneBuffer[mm] = VelocitaBuffer[mm+CurMAShift] - VelocitaBuffer[mm+MA_Shift];

      //if ( AccelerazioneBuffer[mm]>sogliaMinima_accelerazione )    AccelerUpSoglia[mm]=AccelerazioneBuffer[mm];
      //if ( AccelerazioneBuffer[mm]<-sogliaMinima_accelerazione )   AccelerDownSoglia[mm]=AccelerazioneBuffer[mm];
   }

   double MACur=iMA(Symbol(),period,MAPeriod,0,MA_Mode,MA_AppliedPrice,CurMAShift);
   double MAPrev=iMA(Symbol(),period,MAPeriod,0,MA_Mode,MA_AppliedPrice,MA_Shift);

   //------------ trend al rialzo -----------------------+
   if ( VelocitaBuffer[0]>sogliaMinima_velocita && AccelerazioneBuffer[0]>0 && AccelerazioneBuffer[0]>sogliaMinima_accelerazione )
     {
      //text = "trend crescente e forte   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[0] = (MACur-MAPrev)/Poin;
      
      return(TREND_CRESCENTE_FORTE);
     }
   else if ( VelocitaBuffer[0]>sogliaMinima_velocita && AccelerazioneBuffer[0]>0 && AccelerazioneBuffer[0]<=sogliaMinima_accelerazione )
     {
      //text = "trend crescente con poca forza   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+2)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],1)+"";
      soglie[0] = (MACur-MAPrev)/Poin;
      
      return(TREND_CRESCENTE_POCO_FORTE);
     }

   else if ( VelocitaBuffer[0]>sogliaMinima_velocita && AccelerazioneBuffer[0]<0 )
     {
      //text = "trend crescente ma accellerazione negativa   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[0] = (MACur-MAPrev)/Poin;
      
      return(TREND_CRESCENTE_ACC_NEGATIVA);
     }

   //------------ trend al ribasso -----------------------+
   else if ( VelocitaBuffer[0]<-sogliaMinima_velocita && AccelerazioneBuffer[0]<0 && AccelerazioneBuffer[0]<-sogliaMinima_accelerazione )
     {
      //text = "trend decrescente e forte   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[1] = (MACur-MAPrev)/Poin;
      
      return(TREND_DECRESCENTE_FORTE);
     }
   else if ( VelocitaBuffer[0]<-sogliaMinima_velocita && AccelerazioneBuffer[0]<0 && AccelerazioneBuffer[0]>=-sogliaMinima_accelerazione )
     {
      //text = "trend decrescente con poca forza   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[1] = (MACur-MAPrev)/Poin;
      
      return(TREND_DECRESCENTE_POCO_FORTE);
     }

   else if ( VelocitaBuffer[0]<-sogliaMinima_velocita && AccelerazioneBuffer[0]>0 )
     {
      //text = "trend decrescente ma accellerazione positiva   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[1] = (MACur-MAPrev)/Poin;
      
      return(TREND_DECRESCENTE_ACC_POSITIVA);
     }

   //------------ trend in laterale -----------------------+
   else if ( VelocitaBuffer[0]<=sogliaMinima_velocita && VelocitaBuffer[0]>=-sogliaMinima_velocita && AccelerazioneBuffer[0]>sogliaMinima_accelerazione )
     {
      //text = "trend in laterale con un\'accelerazione per un trend al rialzo   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[2] = (MACur-MAPrev)/Poin;
      
      return(TREND_LATERALE_RIALZO);
     }

   else if ( VelocitaBuffer[0]<=sogliaMinima_velocita && VelocitaBuffer[0]>=-sogliaMinima_velocita && AccelerazioneBuffer[0]<-sogliaMinima_accelerazione )
     {
      //text = "trend in laterale con un\'accelerazione per un trend al ribasso   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[2] = (MACur-MAPrev)/Poin;
      
      return(TREND_LATERALE_RIBASSO);
     }

   else 
     {
      //text = "trend in laterale   |   "+strMAType+"("+MAPeriod+", indici da "+MA_Shift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(MA_Shift-CurMAShift+1)+" barre consecutive, è sotto la soglia (="+DoubleToStr(sogliaMinima_velocita,2)+"), accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[2] = (MACur-MAPrev)/Poin;
      
      return(TREND_LATERALE);
     }

   return(EMPTY_VALUE);
}
//---------------------------------------------------------------------------
int adjustTrend(int trend)
{
   //----
      int trend_m15, trend_m30, trend_h1;
      trend_m15 = getTrend(PERIOD_M15, soglie);
      trend_m30 = getTrend(PERIOD_M30, soglie);
      trend_h1 = getTrend(PERIOD_H1, soglie);
   
      if(trend_m15 == TREND_CRESCENTE_FORTE && trend_m30 == TREND_CRESCENTE_FORTE && trend_h1 == TREND_CRESCENTE_FORTE) trend = TREND_CRESCENTE_FORTE;
      else if(trend_m15 == TREND_DECRESCENTE_FORTE && trend_m30 == TREND_DECRESCENTE_FORTE && trend_h1 == TREND_DECRESCENTE_FORTE) trend = TREND_DECRESCENTE_FORTE;
      //else trend = TREND_LATERALE;
   
   //----
      trend_RL_Threshold = regressione_R1+regressione_R2+regressione_R3+regressione_R4;
      trend_RL = 0;
      
      // ------------------------------
      // retta di regressione R1
      // ------------------------------
      if (regressione_R1==true)
      {
         sqRegressionLine(tfInMinuti_R1,PeriodRegr_R1);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R1-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R1) // Trend
         {
            trend_R1 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R1) // Laterale
         {
            trend_R1 = TREND_LATERALE;
         }

      }
   
      // ------------------------------
      // retta di regressione R2
      // ------------------------------
      if (regressione_R2==true)
      {
         sqRegressionLine(tfInMinuti_R2,PeriodRegr_R2);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R2-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R2) // Trend
         {
            trend_R2 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R2) // Laterale
         {
            trend_R2 = TREND_LATERALE;
         }

      }
   
      // ------------------------------
      // retta di regressione R3
      // ------------------------------
      if (regressione_R3==true)
      {
         sqRegressionLine(tfInMinuti_R3,PeriodRegr_R3);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R3-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R3) // Trend
         {
            trend_R3 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R3) // Laterale
         {
            trend_R3 = TREND_LATERALE;
         }
      }
   
      // ------------------------------
      // retta di regressione R4
      // ------------------------------
      if (regressione_R4==true)
      {
         sqRegressionLine(tfInMinuti_R4,PeriodRegr_R4);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R4-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R4) // Trend
         {
            trend_R4 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R4) // Laterale
         {
            trend_R4 = TREND_LATERALE;
         }

      }

   //----
   double sma_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,0);
   double sma_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,0);

   switch(trend)
   {
      case TREND_CRESCENTE_FORTE:
      case TREND_CRESCENTE_POCO_FORTE:
      case TREND_CRESCENTE_ACC_NEGATIVA:
         if (sma_50 > sma_200 || iClose(Symbol(),PERIOD_H1,1) > sma_200 || iOpen(Symbol(),PERIOD_H1,0) > sma_200) trend = TREND_CRESCENTE_FORTE;
         else if ((sma_50 < sma_200) && (iClose(Symbol(),PERIOD_H1,1) < sma_200 || iOpen(Symbol(),PERIOD_H1,0) < sma_200)) trend = TREND_CRESCENTE_POCO_FORTE;
         else if (MathAbs(trend_RL)<trend_RL_Threshold) trend = TREND_CRESCENTE_POCO_FORTE;
         else if(trend_RL<0) trend = TREND_LATERALE;
         break;
      case TREND_DECRESCENTE_FORTE:
      case TREND_DECRESCENTE_POCO_FORTE:
      case TREND_DECRESCENTE_ACC_POSITIVA:
         if (sma_50 < sma_200 || iClose(Symbol(),PERIOD_H1,1) < sma_200 || iOpen(Symbol(),PERIOD_H1,0) < sma_200) trend = TREND_DECRESCENTE_FORTE;
         else if ((sma_50 > sma_200) && (iClose(Symbol(),PERIOD_H1,1) > sma_200 || iOpen(Symbol(),PERIOD_H1,0) > sma_200)) trend = TREND_DECRESCENTE_POCO_FORTE;
         else if (MathAbs(trend_RL)<trend_RL_Threshold) trend = TREND_DECRESCENTE_POCO_FORTE;
         else if(trend_RL>0) trend = TREND_LATERALE;
         break;
   }
   //----
   
   return(trend);
}
//---------------------------------------------------------------------------
int regressionTrend()
{
   //----
      int trend_m15, trend_m30, trend_h1;
      trend_m15 = getTrend(PERIOD_M15, soglie);
      trend_m30 = getTrend(PERIOD_M30, soglie);
      trend_h1 = getTrend(PERIOD_H1, soglie);
   
      if(trend_m15 == TREND_CRESCENTE_FORTE && trend_m30 == TREND_CRESCENTE_FORTE && trend_h1 == TREND_CRESCENTE_FORTE) trend = TREND_CRESCENTE_FORTE;
      else if(trend_m15 == TREND_DECRESCENTE_FORTE && trend_m30 == TREND_DECRESCENTE_FORTE && trend_h1 == TREND_DECRESCENTE_FORTE) trend = TREND_DECRESCENTE_FORTE;
      //else trend = TREND_LATERALE;
   
   //----
      trend_RL_Threshold = regressione_R1+regressione_R2+regressione_R3+regressione_R4;
      trend_RL = 0;
      
      // ------------------------------
      // retta di regressione R1
      // ------------------------------
      if (regressione_R1==true)
      {
         sqRegressionLine(tfInMinuti_R1,PeriodRegr_R1);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R1-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R1) // Trend
         {
            trend_R1 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R1) // Laterale
         {
            trend_R1 = TREND_LATERALE;
         }

      }
   
      // ------------------------------
      // retta di regressione R2
      // ------------------------------
      if (regressione_R2==true)
      {
         sqRegressionLine(tfInMinuti_R2,PeriodRegr_R2);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R2-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R2) // Trend
         {
            trend_R2 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R2) // Laterale
         {
            trend_R2 = TREND_LATERALE;
         }

      }
   
      // ------------------------------
      // retta di regressione R3
      // ------------------------------
      if (regressione_R3==true)
      {
         sqRegressionLine(tfInMinuti_R3,PeriodRegr_R3);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R3-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R3) // Trend
         {
            trend_R3 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R3) // Laterale
         {
            trend_R3 = TREND_LATERALE;
         }
      }
   
      // ------------------------------
      // retta di regressione R4
      // ------------------------------
      if (regressione_R4==true)
      {
         sqRegressionLine(tfInMinuti_R4,PeriodRegr_R4);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R4-1])/(Point*MathPow(10, Digits%2));
         if (MathAbs(regressione)>pipLimite_R4) // Trend
         {
            trend_R4 = (regressione > 0 ? TREND_CRESCENTE_FORTE : TREND_DECRESCENTE_FORTE);
            trend_RL+= (regressione > 0 ? 1 : -1);
         }
         if (MathAbs(regressione)<=pipLimite_R4) // Laterale
         {
            trend_R4 = TREND_LATERALE;
         }

      }

   //----
   double sma_50  = iMA(Symbol(),PERIOD_H1,50,0,MODE_SMA,PRICE_CLOSE,0);
   double sma_200 = iMA(Symbol(),PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,0);

   int trend = 0;
   
   if (trend_RL>0)
   {
	   if (sma_50 > sma_200 || iClose(Symbol(),PERIOD_H1,1) > sma_200 || iOpen(Symbol(),PERIOD_H1,0) > sma_200) trend = TREND_CRESCENTE_FORTE;
	   else if ((sma_50 < sma_200) && (iClose(Symbol(),PERIOD_H1,1) < sma_200 || iOpen(Symbol(),PERIOD_H1,0) < sma_200)) trend = TREND_CRESCENTE_POCO_FORTE;
	   else if (MathAbs(trend_RL)<trend_RL_Threshold) trend = TREND_CRESCENTE_POCO_FORTE;
	   else if(trend_RL<0) trend = TREND_LATERALE;
   }
   else if (trend_RL<0)
   {
	   if (sma_50 < sma_200 || iClose(Symbol(),PERIOD_H1,1) < sma_200 || iOpen(Symbol(),PERIOD_H1,0) < sma_200) trend = TREND_DECRESCENTE_FORTE;
	   else if ((sma_50 > sma_200) && (iClose(Symbol(),PERIOD_H1,1) > sma_200 || iOpen(Symbol(),PERIOD_H1,0) > sma_200)) trend = TREND_DECRESCENTE_POCO_FORTE;
	   else if (MathAbs(trend_RL)<trend_RL_Threshold) trend = TREND_DECRESCENTE_POCO_FORTE;
	   else if(trend_RL>0) trend = TREND_LATERALE;
   }
   else
   {
	   trend = TREND_LATERALE;
   }

   //----
   
   return(trend);
}

//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione regression_line() calcola i valori dell'array regression_line[]
//  che vengono usati per costrire l'oggetto retta di regressione
//+-------------------------------------------------------------------------------------------------------------------------------------+
void sqRegressionLine(int timeframe, int PeriodRegression)
  {

   ArrayResize(regression_line,2*PeriodRegression+1);
   ArrayInitialize(regression_line,EMPTY_VALUE);

   for(int i=PeriodRegression; i>=0; i--) 
     {
      double Y_media=0.0, X_media=0.0, Sommatoria_XiYi=0.0, Sommatoria_Xi_due=0.0;
      double  q, m;
      double Pip_differenza;
      double regressionLine;
      //================================
      // Calcolo della retta di regressione
      for (int x=0; x<PeriodRegression; x++)
        {
         X_media += x;
         if (applied_price==0)
           {
            Y_media += iClose(Symbol(),timeframe,x+i);
            Sommatoria_XiYi += x*iClose(Symbol(),timeframe,x+i);
           }
         if (applied_price==1)
           {
            Y_media += iOpen(Symbol(),timeframe,x+i);
            Sommatoria_XiYi += x*iOpen(Symbol(),timeframe,x+i);
           }
         Sommatoria_Xi_due += x*x;
        }
      X_media = X_media/PeriodRegression;
      Y_media = Y_media/PeriodRegression;

// Nell'equazione di una retta   y = mx + q   applicata al grafico dei cross valutari: 
// --> q (intercetta della retta sull'asse delle ordinate y) ha un ordine di grandezza pari al prezzo, ad esempio q=1,49  
// --> m (il coefficiente angolare o pendenza della retta) è estremamente piccolo, ad esempio m=0,0001
//
// Per la retta di regressione   y = mx + q   calcolata su n punti (Xi,Yi) valgono le seguenti formule
//
//      Sommatoria(Yi*Xi) - n*Xmedia*Ymedia
// m = -------------------------------------       q = Ymedia - m*Xmedia
//         Sommatoria(Xi^2) - n*Xmedia
//

      if (Sommatoria_Xi_due - PeriodRegression*X_media*X_media == 0)    m = 0;
      else  m = (Sommatoria_XiYi - PeriodRegression*X_media*Y_media)/(Sommatoria_Xi_due - PeriodRegression*X_media*X_media);
      q = Y_media - m*X_media;

      // Linear regression line in buffer
      for(int x=0;x<PeriodRegression;x++)
        {
         regression_line[i+x]=m*x+q;
        }

     }
  }
//---------------------------------------------------------------------------
bool sqVolatility(string symbol, int period)
{
   double vol=0;

   int limit=(Sedimentation+5);
   
   ArrayResize(ind_c,limit*2);
   ArrayResize(vol_m,limit*2);
   ArrayResize(vol_t,limit*2);
   ArrayResize(thresholdBuffer,limit*2);

   ArrayInitialize(ind_c,0);
   ArrayInitialize(vol_m,0);
   ArrayInitialize(vol_t,0);
   ArrayInitialize(thresholdBuffer,0);
   
   for(int i=limit;i>=0;i--)
   {
      double sa=iATR(symbol,period,Viscosity,i);
      double s1=ind_c[i+1];
      double s3=ind_c[i+3];
      double atr=NormalizeDouble(sa, MarketInfo(symbol, MODE_DIGITS) );
      double atr_s = iATR(symbol,period,Sedimentation,i);
      
      if(atr_s != 0)
      {
         if(lag_supressor)
            vol= sa/atr_s+lag_s_K*(s1-s3);   
         else
            vol= sa/atr_s;   
         //vol_m[i]=vol;
      }
      else
      {
         return(false);
      }
      
      double anti_thres = iStdDev(symbol,period,Viscosity,0,MODE_LWMA,PRICE_TYPICAL,i);
      
      double std_dev_s = iStdDev(symbol,period,Sedimentation,0,MODE_LWMA,PRICE_TYPICAL,i);
      if(std_dev_s != 0)
      {
         anti_thres= (anti_thres == 0 ? 0 : anti_thres/std_dev_s);
      } else {
         return(false);
      }

      double t=Threshold_level;
      t=t-anti_thres;
      
      if (vol>t) {
         vol_t[i]=vol;vol_m[i]=vol;
         
         if(i==0) {
            ind_c[i]=vol;
            thresholdBuffer[i]=t;   
            return(true);
         }
      }
      else {
         vol_t[i]=vol;vol_m[i]=EMPTY_VALUE;
         
         if(i==0) {
            ind_c[i]=vol;
            thresholdBuffer[i]=t;   
            return(false);
         }
      }

      ind_c[i]=vol;
      thresholdBuffer[i]=t;   
   }

   return(false);
}
//+-------------------------------------------------------------------------------------------------------------------------------------+
        
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
int CheckForClose()
{
//----------------------------------------------
   Count();
   
   RefreshRates();
//----------------------------------------------
   /*if(AccountBalance()>=1000){Amount=10.0+(AccountBalance()/10000);}
   else{Amount=1.0+(AccountBalance()/1000);}*/
   double amount=1.0+(AccountBalance()/1000);
   double TodayProfit = sqGetProfitToday(Symbol(),MAGICMA);
   double targetProfit = StartingBalance + AccountBalance()*1.0/100; //amount/(Amount*100);
//----------------------------------------------
   double LossPerc = (AccountEquity()-AccountBalance())*100/AccountBalance();
   double DDFromStart = (AccountBalance()-StartingBalance)*100/StartingBalance;
   double TodayLossPerc = TodayProfit*100/AccountBalance();
//----------------------------------------------
   if( TodayLossPerc<-FreezeLossPerc )
   {
      blockConditionHit = true;
   }
//----------------------------------------------
   double safeProfit = targetProfit;
   if (DDFromStart <= -2)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/2;
   } else if (DDFromStart <= -3)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/3;
   } else if (DDFromStart <= -5)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/5;
   } else if (DDFromStart <= -8)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/8;
   } else if (DDFromStart <= -10)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/10;
   } else if (DDFromStart <= -13)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/13;
   } else if (DDFromStart <= -15)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/15;
   } else if (DDFromStart <= -20)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/20;
   } else if (DDFromStart <= -50)
   {
      safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/50;
   } else if (DDFromStart <= -60)
   {
      safeProfit = AccountBalance() + (AccountBalance()*5.0)/100;
   }
//----------------------------------------------
   if (/*DDFromStart > DDShield &&*/ LossPerc <= -DDShield)
   {
      log("[CONDIZIONE DI CHIUSURA DI LOSS]; Profit: "+Profit+"; Amount: "+amount+"; LastProfit: "+LastProfit);
      
      isInGain = false;
      blockConditionHit=true;
      unlockOrdersPlaced=false;
      LastOrderTicket = -1;
      FirstOrderTicket = -1;
      LastProfit = 0;
      MaxProfit = 0;
      UnlockingOrderTicket = -1;
      TradeSeries++;

      CloseAll(trend, true);
   }   
//----------------------------------------------
   /*
   if (sqGetOpenedPositionOlderThanToday(Symbol(),MAGICMA) == 0 && Sells+Buys == 1 && Profit > 0)
   {
      log("[CONDIZIONE DI CHIUSURA PREVENTIVA]; Profit: "+Profit+"; Amount: "+amount+"; LastProfit: "+LastProfit);
      
      isInGain = false;
      blockConditionHit=false;
      unlockOrdersPlaced=false;
      LastOrderTicket = -1;
      FirstOrderTicket = -1;
      LastProfit = 0;
      MaxProfit = 0;
      UnlockingOrderTicket = -1;
      TradeSeries++;

      CloseAll(trend, true);
   }
   */
//----------------------------------------------
   //CONDIZIONE DI CHIUSURA DI SUCCESSO
//----------------------------------------------
   if( AccountEquity() >= targetProfit || (DDFromStart <= -DDShield && AccountEquity() >= StartingBalance) )
   {
      log("[CONDIZIONE DI CHIUSURA DI SUCCESSO]; Profit: "+Profit+"; Amount: "+amount+"; LastProfit: "+LastProfit);
      
      sqCheckTradeLevelsToSetBe(Symbol(),MAGICMA,BreakEvenInPips,BreakEvenAtPips);
      
      if(!isInGain)
      {
         isInGain = true;
         LastProfit = Profit;
         MaxProfit = (MaxProfit == 0 ? Profit : (MaxProfit < Profit ? Profit : MaxProfit));
      }
   
      if( Profit<(LastProfit - amount/10) || (Profit < MaxProfit - MaxProfit/2) )
      {
         log("[CONDIZIONE DI CHIUSURA DI SUCCESSO - CloseAll]; Profit: "+Profit+"; Amount: "+amount+"; LastProfit: "+LastProfit);
         isInGain = false;
         blockConditionHit=false;
         unlockOrdersPlaced=false;
         LastOrderTicket = -1;
         FirstOrderTicket = -1;
         LastProfit = 0;
         MaxProfit = 0;
         UnlockingOrderTicket = -1;
         TradeSeries++;

         CloseAll(trend, false);
         if(AccountEquity() >= StartingBalance) StartingBalance = AccountEquity();
      }
      else
      {
         isInGain = true;
         LastProfit = Profit;
         MaxProfit = (MaxProfit == 0 ? Profit : (MaxProfit < Profit ? Profit : MaxProfit));
      }
   }
//----------------------------------------------
   if( AccountEquity() >= safeProfit )
   {
      log("[CONDIZIONE DI CHIUSURA DI SUCCESSO]; Profit: "+Profit+"; Amount: "+amount+"; LastProfit: "+LastProfit);
      
      isInGain = false;
      blockConditionHit=false;
      unlockOrdersPlaced=false;
      LastOrderTicket = -1;
      FirstOrderTicket = -1;
      LastProfit = 0;
      MaxProfit = 0;
      UnlockingOrderTicket = -1;
      TradeSeries++;

      CloseAll(trend, true);
      if(AccountEquity() >= StartingBalance) StartingBalance = AccountBalance();
   }
//----------------------------------------------
   //------
   //sqCheckTradeLevelsToSetBe(Symbol(),MAGICMA,BreakEvenInPips,BreakEvenAtPips);
   //------
      for(i=OrdersTotal(); i>=0; i--)
      {
          OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
          if(OrderSymbol()==Symbol())
          {
            if(!AllOrders && OrderMagicNumber()!=MAGICMA)
            {
               continue;
            }
   
            //bool orderIsInBe = sqOrderIsInBeOrFurther(OrderTicket(),BreakEvenInPips,BreakEvenAtPips);
            if(OrderType() == OP_SELL && OrderStopLoss() > 0 && OrderStopLoss() < OrderOpenPrice())
            { 
               CheckTrailingStop(OrderTicket());
            }
            if(OrderType() == OP_BUY && OrderStopLoss() > 0 && OrderStopLoss() > OrderOpenPrice())
            { 
               CheckTrailingStop(OrderTicket());
            }
         }
      }
   //------

   CharlesStatus();
   return(0);
}  

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
int CheckTrailingStop(int ticket)
{
   RefreshRates();
   
   OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);

// Trailing Stop
   double tempValue = getOrderTrailingStop(Symbol(), Period(), MAGICMA, OrderType(), TrailingStop);
   if(tempValue > 0) {
      double tempValue2 = getOrderTrailingStopActivation(Symbol(), MAGICMA, OrderType(), BreakEvenAtPips);

      if(OrderType() == OP_BUY) {
         double plValue = MarketInfo(Symbol(), MODE_BID) - OrderOpenPrice();
         double newSL = tempValue;
         double order_sl = OrderStopLoss();

         if (plValue >= tempValue2 && (order_sl == 0 || order_sl < newSL) && !sqDoublesAreEqual(Symbol(), order_sl, newSL)) {
            Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", MAGICMA, " to :", newSL);
            if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
               int error = GetLastError();
               Verbose("Failed, error: ", error, " - ", ErrorDescription(error));
            }
         }
      } else { // OrderType() == OP_SELL
         double plValue = OrderOpenPrice() - MarketInfo(Symbol(), MODE_ASK);
         double newSL = tempValue;

         if (plValue >= tempValue2 && (OrderStopLoss() == 0 || OrderStopLoss() > newSL) && !sqDoublesAreEqual(Symbol(), OrderStopLoss(), newSL)) {
            Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", MAGICMA, " to :", newSL);
            if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
               int error = GetLastError();
               Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(Symbol(), MODE_ASK), ", Bid: ", MarketInfo(Symbol(), MODE_BID), " Current SL: ",  OrderStopLoss());
            }
         }
      }
   }
     
   return(-1);
}
//---------------------------------------------------------------------------         
void CharlesStatus()
{

   Count();
   
   int div = 1;
   if (Digits == 3 || Digits == 5)
   {
      div *= DECIMAL_CONVERSION;
   }
   
   double amount=1.0+(AccountBalance()/1000);
   double targetProfit = StartingBalance + LotStepFrom*1.0/100; //amount/(Amount*100);
   double recentProfit = sqOrderClosedProfit(Symbol(),FirstOrderTicket,MAGICMA);

   double MaxMarketPipDistance = sqGetMaxMarketPipDistance(Symbol(),MAGICMA);
          MaxMarketPipDistance = (MaxMarketPipDistance == EMPTY_VALUE ? 0 : MaxMarketPipDistance);
   double MaxMarketStopLossThreshold = -(/*(StopLoss/div)-*/((StopLoss/div)*(UltraShockSLPerc/100)));

//---
   string CommentString="";
   double PointValue=(((MarketInfo(Symbol(),MODE_TICKVALUE)*Point)/MarketInfo(Symbol(),MODE_TICKSIZE))*LOT())/10;
   string DepositCurrency=AccountInfoString(ACCOUNT_CURRENCY);

   CommentString+="\n" + "Your deposit currency: " + DepositCurrency + "\n";
   CommentString+="Lot size requested: " + DoubleToStr(LOT(),LotDigits) + "\n";
   CommentString+="-----------------------------------------------------------------\n";
   CommentString+="Value of one point (" + Symbol() + "):  $" + DepositCurrency + " " + DoubleToStr(PointValue,3) + "\n";
   CommentString+="Value of one pip    (" + Symbol() + ") : $" + DepositCurrency + " " + DoubleToStr(PointValue*10,3) + "\n";
   CommentString+="-----------------------------------------------------------------";

//--- return value of prev_calculated for next call

   Comment("Charles ",VER," - StartingBalance = ",DoubleToString(StartingBalance,3)," Gain= ",DoubleToString(Profit,3)," RecentProfit["+FirstOrderTicket+"]= ",DoubleToString(recentProfit,3)," LookingFor= ",DoubleToString(/*(LastProfit - amount/10)*/targetProfit,3),
          ";\nBalance=",DoubleToString(AccountBalance(),3),"; FreeMargin=", DoubleToString(AccountFreeMargin(),3),"; Equity=", DoubleToString(AccountEquity(),3),
          CommentString,
          "\nBuy=",Buys,"; Sell=", Sells,"; BuyLots=",DoubleToString(BuyLots,2),"; SellLots=",DoubleToString(SellLots,2),
          ";\nPendingSellLots=",DoubleToString(PendingSellLots,2),"; PendingBuyLots=", DoubleToString(PendingBuyLots,2),
          ";\nMaxMarketPipDistance=",DoubleToString(MaxMarketPipDistance,2),";\MaxMarketStopLossThreshold=",DoubleToString(MaxMarketStopLossThreshold,2),
          ";\nTrend=",strTrend(trend),";\nVolatilità=",strVolatility());
}
//---------------------------------------------------------------------------   
string strTrend(int trend)
{
   string str_trend = " - ";
   
   switch(trend)
   {
      case TREND_CRESCENTE_ACC_NEGATIVA:
         str_trend = "CRESCENTE con ACCELERAZIONE NEGATIVA";
         break;
      case TREND_CRESCENTE_FORTE:
         str_trend = "CRESCENTE FORTE";
         break;
      case TREND_CRESCENTE_POCO_FORTE:
         str_trend = "CRESCENTE POCO FORTE";
         break;
      case TREND_DECRESCENTE_ACC_POSITIVA:
         str_trend = "DECRESCENTE con ACCELERAZIONE POSITIVA";
         break;
      case TREND_DECRESCENTE_FORTE:
         str_trend = "DECRESCENTE FORTE";
         break;
      case TREND_DECRESCENTE_POCO_FORTE:
         str_trend = "DECRESCENTE POCO FORTE";
         break;
      case TREND_LATERALE:
         str_trend = "LATERALE";
         break;
      case TREND_LATERALE_RIALZO:
         str_trend = "LATERALE in RIALZO";
         break;
      case TREND_LATERALE_RIBASSO:
         str_trend = "LATERALE in RIBASSO";
         break;
   }
   
   return(str_trend);
}
      
//---------------------------------------------------------------------------         
string strVolatility()
{
   sqVolatility(Symbol(),PERIOD_H1);
   bool trade = true; //!sqVolatility(Symbol(),PERIOD_H1);
   
   //if( is_market_session_open(13,15) || is_market_session_open(0,3) ) trade = false;
   
   string str_vol = DoubleToString(ind_c[0], 3) + "/" + DoubleToString(thresholdBuffer[0], 3) + " - TRADE[" + (trade ? "OK" : "KO") + "]";
          //str_vol+= (is_market_session_open(13,17) ? " - SESSION STOP -" : "");
   return(str_vol);
}

//---------------------------------------------------------------------------         
double LOT()
{
   RefreshRates();

   double MINLOT = MarketInfo(Symbol(),MODE_MINLOT);
   double LOT = MINLOT;
   
   double leverage = Leverage;//AccountLeverage();
   double marginRequired = /*AccountBalance()*0.5;*/ AccountBalance()*(100-1.0/2)/100; //MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   double DDFromStart = (AccountBalance()-StartingBalance)*100/StartingBalance;
   
   if (LotPercent < 1)
   {
     LOT = Lots;
   }
   else
   {
     LOT = AccountBalance()*leverage*LotPercent/1000/marginRequired/15;
   }
   
   LOT = NormalizeDouble(LOT,LotDigits);

   if(LotStepEnable)
   {
      double safeProfit = AccountBalance();
      
      if (DDFromStart <= -2)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/2;
      } else if (DDFromStart <= -3)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/3;
      } else if (DDFromStart <= -5)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/5;
      } else if (DDFromStart <= -8)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/8;
      } else if (DDFromStart <= -10)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/10;
      } else if (DDFromStart <= -13)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/13;
      } else if (DDFromStart <= -15)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/15;
      } else if (DDFromStart <= -20)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/20;
      } else if (DDFromStart <= -50)
      {
         safeProfit = AccountBalance() + (StartingBalance - AccountBalance())/50;
      } else if (DDFromStart <= -60)
      {
         safeProfit = AccountBalance() + (AccountBalance()*5.0)/100;
      }
      
      double stepValue = ((safeProfit-LotStepFrom)/LotStepEvery)*LotStepValue ;
      double lotStepValue = NormalizeDouble( ( stepValue - MathMod(stepValue, LotStepValue) ) , LotDigits );;
      
      LOT += lotStepValue;
      //Log(" >>>>>>>>>>>>>>>>>>>>> ",AccountBalance(), " ----------------- ", lotStepValue, " ************** ", LOT );
   }

   /*double OneLotMargin = MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   double MarginAmount = AccountEquity(); //this means we want to use 200$ for trade
   double lotMM = MarginAmount/OneLotMargin;
   double LotStep = MarketInfo(Symbol(),MODE_LOTSTEP);
   double LOT = NormalizeDouble(lotMM/LotStep,0)*LotStep;*/
   
   if (LOT>MarketInfo(Symbol(),MODE_MAXLOT)) LOT = MarketInfo(Symbol(),MODE_MAXLOT);
   if (LOT<MINLOT) LOT = MINLOT;
   if (MINLOT<0.1) LOT = NormalizeDouble(LOT,2); else LOT = NormalizeDouble(LOT,1);
   
   return(NormalizeDouble(LOT,LotDigits));
}

//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------
void Count()
{ 
  string comment = "Charles_"+VER+"."+IntegerToString(TradeSeries);
  RefreshRates();  
  Buys=0; Sells=0; PendingBuy=0; PendingSell=0; BuyLots=0; SellLots=0; PendingBuyLots=0; PendingSellLots=0; Profit=0;
  for(i=OrdersTotal(); i>=0; i--)
  {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
      {
         if(!AllOrders && OrderMagicNumber()!=MAGICMA)
         {
            continue;
         }
         
         Profit += OrderProfit() + OrderSwap() + OrderCommission();
         
         if(OrderType()==OP_SELL)
         {
            SellLots=SellLots+OrderLots();
            
            /*if(!sqOrderIsInBeOrFurther(OrderTicket(),BreakEvenInPips,BreakEvenAtPips))*/ Sells++;

            //if((Sells+Buys)<=1)
            if(StringFind(comment,OrderComment()))
            {
               if(FirstOrderTicket <= 0 || FirstOrderTicket > OrderTicket())
               {
                  FirstOrderTicket = OrderTicket();
               }
               //Alert(FirstOrderTicket);
            }
         }
         
         if(OrderType()==OP_BUY)
         {
            BuyLots=BuyLots+OrderLots();
            
            /*if(!sqOrderIsInBeOrFurther(OrderTicket(),BreakEvenInPips,BreakEvenAtPips))*/ Buys++;

            //if((Sells+Buys)<=1)
            if(StringFind(comment,OrderComment()))
            {
               if(FirstOrderTicket <= 0 || FirstOrderTicket > OrderTicket())
               {
                  FirstOrderTicket = OrderTicket();
               }
               //Alert(FirstOrderTicket);
            }
         }
         
         if(OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT){PendingSellLots=PendingSellLots+OrderLots();PendingSell++;}
         if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLLIMIT){PendingBuyLots=PendingBuyLots+OrderLots();PendingBuy++;}
      }//if
   }//for
   
   if((Sells+Buys)==0)
   {
      FirstOrderTicket = -1;
      TryToOpenFurtherPendings = true;
   }

   /* - TOO RISKY - */
   //double recentProfit = sqOrderClosedThisBarProfit(Symbol(),MAGICMA);
   if (UltraShock && FirstOrderTicket >= 0)
   {
      double recentProfit = sqOrderClosedProfit(Symbol(),FirstOrderTicket,MAGICMA);
      //Alert(DoubleToString(recentProfit,3));
      //if (recentProfit >= 0) {
         Profit += recentProfit;
      //}
   }
}

//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
void CloseAll(int trend, bool force = false)
{
   RefreshRates();

   string todayTime = TimeToStr( TimeCurrent(), TIME_DATE);
   bool   Result;
   int    i,Pos,Error;
   int    Total=OrdersTotal();
   int    orderOpenedThisBar = sqOrderOpenedThisBar(Symbol(),MAGICMA);
   double equityPercent = (AccountEquity()-AccountBalance())*100/AccountBalance();
   
   if(Total>0)
   {for(i=Total-1; i>=0; i--) 
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       {
         Pos=OrderType();
         
         if(OrderSymbol()==Symbol() && (Pos == OP_BUY || Pos == OP_SELL) )
         {
            if(!AllOrders && OrderMagicNumber()!=MAGICMA)
            {
               continue;
            }

            bool orderIsInBe = sqOrderIsTriggeredByBe(OrderTicket(),BreakEvenInPips,BreakEvenAtPips);
            if(orderIsInBe) sqSetBreakEven(OrderTicket(),BreakEvenInPips,BreakEvenAtPips);

            double profit = OrderProfit()+OrderSwap()+OrderCommission();
            double winPercent = 100-(AccountEquity()*100/AccountBalance()); //profit*100/AccountBalance();
            
            if(force || (profit<0 && !sqOrderIsInBeOrFurther(OrderTicket(),BreakEvenInPips,BreakEvenAtPips)))
            {
               //Alert("CLOSE ORDER ["+orderIsInBe+"]" + OrderTicket());
               if(Pos==OP_BUY){Result = sqClosePositionAtMarket(OrderLots(),Slippage);/*OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, Blue);*/}
               if(Pos==OP_SELL){Result= sqClosePositionAtMarket(OrderLots(),Slippage);/*OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, Red);*/}
               //if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT)){Result=OrderDelete(OrderTicket(), CLR_NONE);}
            }
//-----------------------
            if(Result!=true){Error=GetLastError();log("LastError = "+Error);}
            else Error=0;
//-----------------------
            Sleep(10);
         }//if
       }//if
     }//for
   }//if
   
   Sleep(10);
   //TryToOpenFurtherPendings = false;
   //DeleteAllPendingOrders();
}

//---------------------------------------------------------------------------
void DeleteAllPendingOrders()
{
   RefreshRates();

   bool   Result;
   int    i,Pos,Error;
   int    Total=OrdersTotal();
   
   if(Total>0)
   {for(i=Total-1; i>=0; i--) 
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       {
         if(OrderSymbol()==Symbol())
         {
            if(!AllOrders && OrderMagicNumber()!=MAGICMA)
            {
               continue;
            }
            Pos=OrderType();
            if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT)){Result=OrderDelete(OrderTicket(), CLR_NONE);}
//-----------------------
            if(Result!=true){Error=GetLastError();log("LastError = "+Error);}
            else Error=0;
//-----------------------
            Sleep(10);
         }//if
       }//if
     }//for
   }//if
}

//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
void DeleteAllInvalidOrders()
{
   RefreshRates();

   bool   Result;
   int    i,Pos,Error;
   int    Total=OrdersTotal();
   
   if(Total>0)
   {for(i=Total-1; i>=0; i--) 
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==0 && OrderComment()==MAGICMA)
         {
            Pos=OrderType();
            if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT)){Result=OrderDelete(OrderTicket(), CLR_NONE);}
//-----------------------
            if(Result!=true){Error=GetLastError();log("LastError = "+Error);}
            else Error=0;
//-----------------------
            Sleep(10);
         }//if
       }//if
     }//for
   }//if
}

//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
int OpenOrder(double LotOpenValue, int Type, double stoploss, double takeprofit)
{
   RefreshRates();
   int    Error, Result;

   log("OpenOrder - LotHedgeValue:" + LotOpenValue + "; AccountFreeMargin: "+AccountFreeMargin());

   if(AccountFreeMargin()>0)
   {
      log("MarketInfo(Symbol(),MODE_MARGINREQUIRED) == " + MarketInfo(Symbol(),MODE_MARGINREQUIRED));
      log("Ask("+Ask+")-MaxOpenPrice("+MaxOpenPrice+") == " + (Ask-MaxOpenPrice));
      log("MinOpenPrice("+MinOpenPrice+")-Bid("+Bid+") == " + (MinOpenPrice-Bid));
      if( sqIsTradeAllowed() == 1 && Type==OP_BUY )
      {
         Result=OrderSend(Symbol(),OP_BUY,LotOpenValue,Ask,Slippage,0,0,"Charles_"+VER+"."+IntegerToString(TradeSeries),MAGICMA,0,Blue);
         
         Sleep(10);
         RefreshRates();
         if (Result > 0 && OrderSelect(Result,SELECT_BY_TICKET,MODE_TRADES) ) {
            //stoploss   = (StopLoss == 0 ? 0 : Bid-StopLoss*Point-Spread*Point-STOPLEVEL*Point);
            //takeprofit = (TakeProfit == 0 ? 0 : Ask+TakeProfit*Point+Spread*Point+STOPLEVEL*Point);
            if (stoploss != 0 || takeprofit != 0) {
               OrderModify(Result,OrderOpenPrice(),stoploss,takeprofit,0);
            }
         }
         
         //Result=sqOpenOrder(Symbol(),OP_BUY,LotOpenValue,Ask,Slippage,stoploss,takeprofit,"Charles_"+VER+"."+IntegerToString(TradeSeries),MAGICMA,"GoLong");
         Sleep(10);
         log("OpenOrder[OP_BUY] - Ask:" + Ask + "; Result: "+Result);
      }
      if(sqIsTradeAllowed() == 1 && Type==OP_SELL )
      {
         Result=OrderSend(Symbol(),OP_SELL,LotOpenValue,Bid,Slippage,0,0,"Charles_"+VER+"."+IntegerToString(TradeSeries),MAGICMA,0,Red);
         
         Sleep(10);
         RefreshRates();
         if (Result > 0 && OrderSelect(Result,SELECT_BY_TICKET,MODE_TRADES) ) {
            //stoploss   = (StopLoss == 0 ? 0 : Ask+StopLoss*Point+Spread*Point+STOPLEVEL*Point);
            //takeprofit = (TakeProfit == 0 ? 0 : Bid-TakeProfit*Point-Spread*Point-STOPLEVEL*Point);
            if (stoploss != 0 || takeprofit != 0) {
               OrderModify(Result,OrderOpenPrice(),stoploss,takeprofit,0);
            }
         }
         
         //Result=sqOpenOrder(Symbol(),OP_SELL,LotOpenValue,Bid,Slippage,stoploss,takeprofit,"Charles_"+VER+"."+IntegerToString(TradeSeries),MAGICMA,"GoShort");
         Sleep(10);
         log("OpenOrder[OP_SELL] - Bid:" + Bid + "; Result: "+Result);
      }
   }

//-----------------------
   if(Result==-1){Error=GetLastError();log("LastError = "+Error);}
   else {Error=0;}
//-----------------------

   return(Result);
}

//---------------------------------------------------------------------------
double normPrice (double price)
{
   return(NormalizeDouble (price, Digits)); 
}
//---------------------------------------------------------------------------
void startFile()
{
  int handle;
  handle=FileOpen("Charles-"+VER+".log", FILE_BIN|FILE_READ|FILE_WRITE);
    if(handle<1)
    {
     Print("can't open file error-",GetLastError());
     return;
    }
  FileSeek(handle, 0, SEEK_END);
  //---- add data to the end of file
  string str = 
      "----------------------------------------------------------------------------------------------------------------------------------------\n" + 
      "-- Charles v."+VER+" - Log Starting...                                                                                                  --\n" +
      "----------------------------------------------------------------------------------------------------------------------------------------\n";
  FileWriteString(handle, str, StringLen(str));
  FileFlush(handle);
  FileClose(handle);
}
//---------------------------------------------------------------------------
void log(string str, string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="")
{
  str = "["+Day()+"-"+Month()+"-"+Year()+" "+Hour()+":"+Minute()+":"+Seconds()+"] "+str+"\n";
  
  if(LogToFile)
  {
      int handle;
      handle=FileOpen("Charles-"+VER+".log", FILE_BIN|FILE_READ|FILE_WRITE);
        if(handle<1)
        {
         Print("can't open file error-",GetLastError());
         return;
        }
      FileSeek(handle, 0, SEEK_END);
      //---- add data to the end of file
      FileWrite(handle, str, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
      FileFlush(handle);
      FileClose(handle);
  }
  else
  {
      Verbose(str, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
  }
}
//---------------------------------------------------------------------------
string TimeStr(int taim)
{
   string sTaim;
   int HH=TimeHour(taim);     // Hour
   int MM=TimeMinute(taim);   // Minute
   if (HH<10) sTaim = StringConcatenate(sTaim,"0",DoubleToStr(HH,0));
   else       sTaim = StringConcatenate(sTaim,DoubleToStr(HH,0));
   if (MM<10) sTaim = StringConcatenate(sTaim,":0",DoubleToStr(MM,0));
   else       sTaim = StringConcatenate(sTaim,":",DoubleToStr(MM,0));
   return(sTaim);
}

//---------------------------------------------------------------------------
/*extern*/ int iMA_Period = 75; //--- (60 5 100)
/*extern*/ int iCCI_Period = 18; //--- (10 2 30)
/*extern*/ int iATR_Period = 14; //--- (10 2 30) (!) Можно не оптить
/*extern*/ int iWPR_Period = 11; //--- (10 1 20)
/*extern*/ int iWPR_Close_Period = 0; //--- (10 1 20)
//+--------------------------------------------------------------------------------------------------------------+
//| EURUSD     | GBPUSD     | USDCHF     | USDJPY     | USDCAD     |
//+----------------------------------------------------------------
//| TP=26;     | TP=50;     | TP=17;     | TP=27;     | TP=14;     |
//| SL=120;    | SL=120;    | SL=120;    | SL=130;    | SL=150;    |
//| SP=1;      | SP=2;      | SP=0;      | SP=2;      | SP=2;      |
//| SPT=10;    | SPT=24;    | SPT=15;    | SPT=14;    | SPT=10;    |
//| MLP=-65;   | MLP=-200;  | MLP=-40;   | MLP=-80;   | MLP=-30;   |
//+----------------------------------------------------------------
//| MA=75;     | MA=75;     | MA=70;     | MA=85;     | MA=65;     |
//| CCI=18;    | CCI=12;    | CCI=14;    | CCI=12;    | CCI=12;    |
//| ATR=14;    | ATR=14;    | ATR=14;    | ATR=14;    | ATR=14;    |
//| WPR=11;    | WPR=12;    | WPR=12;    | WPR=12;    | WPR=16;    |
//+----------------------------------------------------------------
//| FATR=6;    | FATR=6;    | FATR=3;    | FATR=0;    | FATR=4;    |
//| FCCI=150;  | FCCI=290;  | FCCI=170;  | FCCI=2000; | FCCI=130;  |
//+----------------------------------------------------------------
//| MAFOA=15;  | MAFOA=12;  | MAFOA=8;   | MAFOA=5;   | MAFOA=5;   |
//| MAFOB=39;  | MAFOB=33;  | MAFOB=25;  | MAFOB=21;  | MAFOB=15;  |
//| WPRFOA=-99;| WPRFOA=-99;| WPRFOA=-95;| WPRFOA=-99;| WPRFOA=-99;|
//| WPRFOB=-95;| WPRFOB=-94;| WPRFOB=-92;| WPRFOB=-95;| WPRFOB=-89;|
//+----------------------------------------------------------------
//| MAFC=14;   | MAFC=18;   | MAFC=11;   | MAFC=14;   | MAFC=14;   |
//| WPRFC=-19; | WPRFC=-19; | WPRFC=-22; | WPRFC=-27; | WPRFC=-6;  |
//+--------------------------------------------------------------------------------------------------------------+
//---
/*extern*/ int FilterATR = 6; //--- (0 1 10) Проверка на вход по ATR для Buy и Sell (if (iATR_Signal <= FilterATR * pp) return (0);) (!) Можно не оптить
/*extern*/ double iCCI_OpenFilter = 150; //--- (100 10 400) Фильтр по iCCI для Buy и Sell. При оптимизации под JPY рекомендуемо оптить по правилу (100 50 4000)
//---
/*extern*/ int iMA_Filter_Open_a = 15; //--- (4 2 20) Фильтр МА для открытия Buy и Sell (Пунты)
/*extern*/ int iMA_Filter_Open_b = 39; //--- (14 2 50) Фильтр МА для открытия Buy и Sell (Пунты)
/*extern*/ int iWPR_Filter_Open_a = -99; //--- (-100 1 0) Фильтр WPR для открытия Buy и Sell
/*extern*/ int iWPR_Filter_Open_b = -95; //--- (-100 1 0) Фильтр WPR для открытия Buy и Sell
//---
/*extern*/ int Price_Filter_Close = 14; //--- (10 2 20) Фильтр цены открытия для закрытия Buy и Sell (Пунты)
/*extern*/ int iWPR_Filter_Close = -19; //--- (0 1 -100) Фильтр WPR для закрытия Buy и Sell
//+--------------------------------------------------------------------------------------------------------------+
//| OpenLongSignal. Сигнал на открытие длинной позиции.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenLongSignal() {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- Расчет основных сигналов на вход
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_Period, 1);
double iCCI_Signal = iCCI(NULL, PERIOD_M15, iCCI_Period, PRICE_TYPICAL, 1);

double iWPR_Close_Signal = iWPR(NULL, PERIOD_M15, iWPR_Close_Period, 1);

//---
double iMA_Filter_a = NormalizeDouble(iMA_Filter_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_Filter_Open_b*pp,pd);
double BidPrice = Bid; //--- (iClose_Signal >= BidPrice) Сравнение идёт именно с Bid (а не с Ask, как должно быть), так как цена закрытия свечи iClose_Signal формируется на основании значения Bid
//---

//--- Сверяем сигнал по АТР с его фильтром
if (iATR_Signal <= FilterATR * pp) return (0);
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_a && iClose_Signal - BidPrice >= - cf && iWPR_Filter_OpenLong_a > iWPR_Signal) result1 = true;
else result1 = false;
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_b && iClose_Signal - BidPrice >= - cf && - iCCI_OpenFilter > iCCI_Signal) result2 = true;
else result2 = false;
//---
if (iClose_Signal - iMA_Signal > iMA_Filter_b && iClose_Signal - BidPrice >= - cf && iWPR_Filter_OpenLong_b > iWPR_Signal) result3 = true;
else result3 = false;
//---
if (result1 == true || result2 == true || result3 == true) result = true;
else result = false;
if (iWPR_Close_Signal > iWPR_Filter_CloseLong) result = false;
//---
return (result);

}

//+--------------------------------------------------------------------------------------------------------------+
//| OpenShortSignal. Сигнал на открытие короткой позиции.
//+--------------------------------------------------------------------------------------------------------------+
bool OpenShortSignal() {
//+--------------------------------------------------------------------------------------------------------------+

bool result = false;
bool result1 = false;
bool result2 = false;
bool result3 = false;

//--- Расчет основных сигналов на вход
double iClose_Signal = iClose(NULL, PERIOD_M15, 1);
double iMA_Signal = iMA(NULL, PERIOD_M15, iMA_Period, 0, MODE_SMMA, PRICE_CLOSE, 1);
double iWPR_Signal = iWPR(NULL, PERIOD_M15, iWPR_Period, 1);
double iATR_Signal = iATR(NULL, PERIOD_M15, iATR_Period, 1);
double iCCI_Signal = iCCI(NULL, PERIOD_M15, iCCI_Period, PRICE_TYPICAL, 1);

double iWPR_Close_Signal = iWPR(NULL, PERIOD_M15, iWPR_Close_Period, 1);

//---
double iMA_Filter_a = NormalizeDouble(iMA_Filter_Open_a*pp,pd);
double iMA_Filter_b = NormalizeDouble(iMA_Filter_Open_b*pp,pd);
double BidPrice = Bid;
//---

//--- Сверяем сигнал по АТР с его фильтром
if (iATR_Signal <= FilterATR * pp) return (0);
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_a && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_OpenShort_a) result1 = true;
else result1 = false;
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_b && iClose_Signal - BidPrice <= cf && iCCI_Signal > iCCI_OpenFilter) result2 = true;
else result2 = false;
//---
if (iMA_Signal - iClose_Signal > iMA_Filter_b && iClose_Signal - BidPrice <= cf && iWPR_Signal > iWPR_Filter_OpenShort_b) result3 = true;
else result3 = false;
//---
if (result1 == true || result2 == true || result3 == true) result = true;
else result = false;
if (iWPR_Close_Signal < iWPR_Filter_CloseShort) result = false;
//---
return (result);

}

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------