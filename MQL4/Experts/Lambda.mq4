//+------------------------------------------------------------------+
//|                                                       Lambda.mq4 |
//|                       Copyright 2014, AlFa'Quotes Software Corp. |
//|                                              http://www.----.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, AlFa'Quotes Software Corp."
#property link      "http://www.----.com"
#property version   "1.06"
#property strict

#include <sqlite.mqh>
#include <stderror.mqh>
#include <stdlib.mqh>
#include <hash.mqh>

#define VERSION 1.06

#define CLOSE_MODE 0
#define OPENCLOSE_MODE 1
#define CLOSE_RELATIVE_MODE 2

#define DIR_LONG 1
#define DIR_SHORT -1

#define STR_WEAK 0
#define STR_NEUTRAL 1
#define STR_RISING 2
#define STR_STRONG 3

/**
 * Bearish
 *   SS 2,3,4  - Shooting Star
 *   E_Star    - Evening Star
 *   E_Doji    - Evening Doji Star
 *   DCC       - Dark Cloud Pattern
 *   S_E       - Bearish Engulfing Pattern
 * Bullish
 *   HMR 2,3,4 - Bullish Hammer
 *   M_Star    - Morning Star
 *   M_Doji    - Morning Doji Star
 *   P_L       - Piercing Line Pattern
 *   L_E       - Bullish Engulfing Pattern
 */
#define PATTERN_UNDEFINED      0

#define PATTERN_BEARISH_SS2    2
#define PATTERN_BEARISH_SS3    4
#define PATTERN_BEARISH_SS4    8
#define PATTERN_BEARISH_E_STAR 16
#define PATTERN_BEARISH_E_DOJI 32
#define PATTERN_BEARISH_DCC    64
#define PATTERN_BEARISH_S_E    128

#define PATTERN_BULLISH_HMR2   256
#define PATTERN_BULLISH_HMR3   512
#define PATTERN_BULLISH_HMR4   1024
#define PATTERN_BULLISH_M_STAR 2048
#define PATTERN_BULLISH_M_DOJI 4096
#define PATTERN_BULLISH_P_L    8192
#define PATTERN_BULLISH_L_E    16384

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

//+------------------------------------------------------------------+
//| Expert public global variables                                   |
//+------------------------------------------------------------------+
extern int MaxSlippage                       = 3;
extern bool CloseAtError                     = false;
extern int BreakEvenAtPips                   = 11;
extern int TrailingStopPips                  = 20;
extern int VerboseMode                       = 1;
extern double LotsIfNoMM                     = 0.1;
extern double RiskInPercent                  = 0.0;
extern double MaximumLots                    = 0.0;
extern double LotsDecimals                   = 2;
extern bool LotStepEnable                    = true;
extern double LotStepValue                   = 0.01;
extern double LotStepFrom                    = 1000;
extern double LotStepEvery                   = 1000;
extern int Leverage                          = 200;
extern string PairSuffix                     = "";

extern bool SupportECNBrokers                = true;
bool InitializeDB                     = true;
extern bool AllowWeakSignals                 = false;

//---- indicator parameters
int Mode                              = CLOSE_RELATIVE_MODE;
int CorrelationRadius                 = 25;
int MA_Period                         = 20;
int ResultingBars                     = 0;
double HeatMapDailyPercRateTholdMin   = 0.23;
double HeatMapDailyPercRateTholdMax   = 0.33;
string II1   = "== BBands Signals";
string II1_2 = "== Doda-BBands2";
int        Length                     = 20;
int        Deviation                  = 2;
double     MoneyRisk                  = 2.0;
int        Signal                     = 1;
int        Line                       = 1;
int        Nbars                      = 500;
string II1_3 = "== bbsqueeze_dark";
int        bolPrd                     = 20;
double     bolDev                     = 2.0;
int        keltPrd                    = 20;
double     keltFactor                 = 1.5;
int        momPrd                     = 12;
int MAPeriod          = 9;     //[MAPeriod] - Periodi per la Media Mobile
int MA_Type           = 1;      //[MA_Type] - 0=SMA, 1=EMA, 2=SMMA, 3=LWMA
int PrevMAShift       = 3;      //[PrevMAShift] - Numero di Barre indietro
int CurMAShift        = 0;      //[CurMAShift] - Numero di Barra corrente
int MA_AppliedPrice   = 4;      //[MA_AppliedPrice] - Prezzo applicazione media: 0=close
string  p0            = " 0 = close";
string  p1            = " 1 = open";
string  p2            = " 2 = high";
string  p3            = " 3 = low";
string  p4            = " 4 = median(high+low)/2";
string  p5            = " 5 = typical(high+low+close)/3";
string  p6            = " 6 = weighted(high+low+close+close)/4";
double sogliaMinima_velocita=3; //[sogliaMinima_velocita] - Soglia Minima di Velocità
string smin0          = " misura in pip della minima velocità di soglia, cioè della minima variazione di pip, che si deve avere su due punti della media mobile";
string smin1          = " perché si consideri il mercato corrente in trend e non in laterale.";
double sogliaMinima_accelerazione=2; //[sogliaMinima_accelerazione] - Soglia Minima di Accelerazione
string smin2          = " misura in pip della minima variazione di velocità che la media mobile deve avere su due punti della media mobile";
string smin3          = " perché si consideri che il mercato sta dimnostrando una forza di accelerazione in grado di far partire un trend";
bool regressione_R1   = true;   //[regressione_R1] - Se false, la retta di regressione R1 non viene visualizzata
int tfInMinuti_R1     = 60;     //[tfInMinuti_R1] - Timeframe in minuti della retta di regressione R1
int PeriodRegr_R1     = 3;      //[PeriodRegr_R1] - Numero di barre della retta di regressione R1
double pipLimite_R1   = 8;      //[pipLimite_R1] - Pip di trend della retta di regressione R1
bool regressione_R2   = true;   //[regressione_R2] - Se false, la retta di regressione R2 non viene visualizzata
int tfInMinuti_R2     = 30;     //[tfInMinuti_R2] - Timeframe in minuti della retta di regressione R2
int PeriodRegr_R2     = 5;      //[PeriodRegr_R2] - Numero di barre della retta di regressione R2
double pipLimite_R2   = 8;      //[pipLimite_R2] - Pip di trend della retta di regressione R2
bool regressione_R3   = true;   //[regressione_R3] - Se false, la retta di regressione R3 non viene visualizzata
int tfInMinuti_R3     = 15;     //[tfInMinuti_R3] - Timeframe in minuti della retta di regressione R3
int PeriodRegr_R3     = 8;      //[PeriodRegr_R3] - Numero di barre della retta di regressione R3
double pipLimite_R3   = 8;      //[pipLimite_R3] - Pip di trend della retta di regressione R3
bool regressione_R4   = false;  //[regressione_R4] - Se false, la retta di regressione R4 non viene visualizzata
int tfInMinuti_R4     = 5;      //[tfInMinuti_R4] - Timeframe in minuti della retta di regressione R4
int PeriodRegr_R4     = 30;     //[PeriodRegr_R4] - Numero di barre della retta di regressione R4
double pipLimite_R4   = 8;      //[pipLimite_R4] - Pip di trend della retta di regressione R4
int applied_price     = 0;      //[applied_price] - 0 = Close price; 1 = Open price
//---- input parameters
int Viscosity         = 7;      //[Viscosity] - Volatility Viscosity
int Sedimentation     = 50;     //[Sedimentation] - Volatility Sedimentation
double Threshold_level= 1.1;   //[Threshold_level] - Volatility Threshold
bool lag_supressor    = true;   //[lag_supressor] - Volatility Lag Suppressor

//+------------------------------------------------------------------+
//| Expert private global variables                                  |
//+------------------------------------------------------------------+
long global_counter = -1;
int  skip_ticks     = 5;
//---
int handle, handleSig;
int cols[2];
string db;
bool db_populated = false;
bool db_reset = true;
//---
double Correlation[], AverageCorrelation[];
double AverageX, AverageY, AverageXY, DispersionX, DispersionY, CovariationXY;
int CalculateCounter, ValidDataCounter;
int correlationCounter = 0;
int signalCounter = 0;
//--- Daily Percent rate GLOBALS
string         marketWatchSymbolsList[];
double         percentChange[];
//---
int            symbolsTotal=0;
int            timeGMTOffset=0;
//---
MqlRates       DailyBar[];
MqlDateTime currentBarTimeStruct, lastBarTimeStruct, timeGMTStruct;
datetime currentBarTimeGMT;
datetime lastBarTimeGMT;
int lastOrderErrorCloseTime = 0;
int tmpRet;
//--- Market Sessions Hours
int Euro_Frankfurt_GMT_Start = 7;
int Euro_Frankfurt_GMT_End   = 16;

int Euro_London_GMT_Start    = 8;
int Euro_London_GMT_End      = 17;

int USA_NewYork_GMT_Start    = 13;
int USA_NewYork_GMT_End      = 22;

int USA_Chicago_GMT_Start    = 14;
int USA_Chicago_GMT_End      = 23;

int Asia_Tokyo_GMT_Start     = 0;
int Asia_Tokyo_GMT_End       = 9;

int Asia_HongKong_GMT_Start  = 1;
int Asia_HongKong_GMT_End    = 10;

int Pacific_Sydney_GMT_Start = 22;
int Pacific_Sydney_GMT_End   = 7;

int Pacific_Wellington_GMT_Start  = 22;
int Pacific_Wellington_GMT_End    = 6;
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
double BB_LONG_MaxPoint       ;
double BB_LONG_MinPoint       ;
int BB_LONG_CurrentBar        ;
int BB_LONG_LastBar           ;
int BB_LONG_EuroSessionOpen   ;
int BB_LONG_EuroSessionClosed ;
int BB_LONG_MorningSession    ;
int BB_LONG_AfternoonSession  ;
int BB_LONG_NightSession      ;
int BB_LONG_StrengthStrong    ;
int BB_LONG_StrengthWeak      ;
int BB_LONG_DailyPercentHot   ;
int BB_LONG_DailyPercentCold  ;
int BB_LONG_PivotNear         ;
int BB_LONG_PivotFar          ;
int BB_LONG_SupportNear       ;
int BB_LONG_SupportFar        ;
int BB_LONG_ResistanceNear    ;
int BB_LONG_ResistanceFar     ;
int BB_LONG_DailyLevelNear    ;
int BB_LONG_DailyLevelFar     ;
//---------------------------------
double BB_SHORT_MaxPoint      ;
double BB_SHORT_MinPoint      ;
int BB_SHORT_CurrentBar       ;
int BB_SHORT_LastBar          ;
int BB_SHORT_EuroSessionOpen  ;
int BB_SHORT_EuroSessionClosed;
int BB_SHORT_MorningSession   ;
int BB_SHORT_AfternoonSession ;
int BB_SHORT_NightSession     ;
int BB_SHORT_StrengthStrong   ;
int BB_SHORT_StrengthWeak     ;
int BB_SHORT_DailyPercentHot  ;
int BB_SHORT_DailyPercentCold ;
int BB_SHORT_PivotNear        ;
int BB_SHORT_PivotFar         ;
int BB_SHORT_SupportNear      ;
int BB_SHORT_SupportFar       ;
int BB_SHORT_ResistanceNear   ;
int BB_SHORT_ResistanceFar    ;
int BB_SHORT_DailyLevelNear   ;
int BB_SHORT_DailyLevelFar    ;
//---------------------------------
double ISW_LONG_MaxPoint      ;
double ISW_LONG_MinPoint      ;
int ISW_LONG_CurrentBar       ;
int ISW_LONG_LastBar          ;
int ISW_LONG_EuroSessionOpen  ;
int ISW_LONG_EuroSessionClosed;
int ISW_LONG_MorningSession   ;
int ISW_LONG_AfternoonSession ;
int ISW_LONG_NightSession     ;
int ISW_LONG_StrengthStrong   ;
int ISW_LONG_StrengthWeak     ;
int ISW_LONG_DailyPercentHot  ;
int ISW_LONG_DailyPercentCold ;
int ISW_LONG_PivotNear        ;
int ISW_LONG_PivotFar         ;
int ISW_LONG_SupportNear      ;
int ISW_LONG_SupportFar       ;
int ISW_LONG_ResistanceNear   ;
int ISW_LONG_ResistanceFar    ;
int ISW_LONG_DailyLevelNear   ;
int ISW_LONG_DailyLevelFar    ;
//---------------------------------
double ISW_SHORT_MaxPoint     ;
double ISW_SHORT_MinPoint     ;
int ISW_SHORT_CurrentBar      ;
int ISW_SHORT_LastBar         ;
int ISW_SHORT_EuroSessionOpen ;
int ISW_SHORT_EuroSessionClosed;
int ISW_SHORT_MorningSession  ;
int ISW_SHORT_AfternoonSession;
int ISW_SHORT_NightSession    ;
int ISW_SHORT_StrengthStrong  ;
int ISW_SHORT_StrengthWeak    ;
int ISW_SHORT_DailyPercentHot ;
int ISW_SHORT_DailyPercentCold;
int ISW_SHORT_PivotNear       ;
int ISW_SHORT_PivotFar        ;
int ISW_SHORT_SupportNear     ;
int ISW_SHORT_SupportFar      ;
int ISW_SHORT_ResistanceNear  ;
int ISW_SHORT_ResistanceFar   ;
int ISW_SHORT_DailyLevelNear  ;
int ISW_SHORT_DailyLevelFar   ;
//---------------------------------
double    lag_s_K=0.5;
//---- buffers
double thresholdBuffer[];
double vol_m[];
double vol_t[];
double ind_c[];
double soglie[];
double regression_line[];           // array dei valori della retta di regressione
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   VerboseLog("--------------------------------------------------------");
   VerboseLog("Starting the EA");
//--- check Symbols available
   if(SymbolsTotal(true)<5)
   {
      Alert("The minimum number of symbols must be 5 (five).");
      return(INIT_PARAMETERS_INCORRECT);
   }

   if(IsTesting() || InitializeDB == false)
   {
      db_reset = false;
   }
   else
   {
      db_reset = true;
   }
//--- indicators
D_R1=0; D_R2=0; D_R3=0;
D_M0=0; D_M1=0; D_M2=0; D_M3=0; D_M4=0; D_M5=0;
D_S1=0; D_S2=0; D_S3=0;

Fhr_R1=0; Fhr_R2=0; Fhr_R3=0;
Fhr_M0=0; Fhr_M1=0; Fhr_M2=0; Fhr_M3=0; Fhr_M4=0; Fhr_M5=0;
Fhr_S1=0; Fhr_S2=0; Fhr_S3=0;

//--- create timer
   EventSetTimer(5*60);

   TimeToStruct(iTime(Symbol(),PERIOD_M1,0),currentBarTimeStruct);
   //TimeToStruct(iTime(Symbol(),PERIOD_M1,1),lastBarTimeStruct);
   TimeGMT(timeGMTStruct);
   timeGMTOffset = (currentBarTimeStruct.hour-timeGMTStruct.hour);
   //currentBarTimeGMT = StrToTime(currentBarTimeStruct.year+"."+currentBarTimeStruct.mon+"."+currentBarTimeStruct.day+" "+(currentBarTimeStruct.hour-timeGMTOffset)+":"+currentBarTimeStruct.min+":"+currentBarTimeStruct.sec);
   //lastBarTimeGMT = StrToTime(lastBarTimeStruct.year+"."+lastBarTimeStruct.mon+"."+lastBarTimeStruct.day+" "+(lastBarTimeStruct.hour-timeGMTOffset)+":"+lastBarTimeStruct.min+":"+lastBarTimeStruct.sec);
   currentBarTimeGMT = get_TimeToGMT(iTime(Symbol(),PERIOD_M1,0));
   lastBarTimeGMT = currentBarTimeGMT;

//--- initialize sqlite engine
    if (!sqlite_init())
    {
      Alert("DB Initialization failed.");
      return(INIT_FAILED);
    }

    db = StringConcatenate("LambdaDB-", AccountNumber(), ".db");

//--- create schema if tables do not exist
   //-- 'HeatMap' --> 'Time', 'TimeFrame', 'Pair1', 'Pair2', 'AvgCorrelation', 'DailyPercentChange'
   if (!do_check_table_exists(db, "HeatMap"))
   {
      Print("Creating schema for ", db + " / HeatMap");
      string sql = "CREATE TABLE 'HeatMap' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Time' INTEGER, 'TimeFrame' INTEGER, ";
             sql+= "'Pair1' TEXT, 'Pair2' TEXT, 'AvgCorrelation' REAL, 'DailyPercentChange' REAL)";
      do_exec(db, sql);
   }
   /*else if( db_reset )
   {
      string sql = "DELETE FROM 'HeatMap'";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);
   }*/

   //-- 'CurrencyData' --> 'Time', 'TimeFrame', 'Pair', 'High', 'Ask', 'Bid', 'Low', 'PIPRange', 'BidRatio', 'RelStr1', 'RelStr2'
   if (!do_check_table_exists(db, "CurrencyData")) {
      Print("Creating schema for ", db + " / CurrencyData");
      string sql = "CREATE TABLE 'CurrencyData' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Time' INTEGER, 'TimeFrame' INTEGER, 'Pair' TEXT, ";
             sql+= "'High' REAL, 'Ask' REAL, 'Bid' REAL, 'Low' REAL, 'PIPRange' REAL, 'BidRatio' REAL, 'RelStr1' REAL, 'RelStr2' REAL)";
      do_exec(db, sql);
   }
   /*else if( db_reset )
   {
      string sql = "DELETE FROM 'CurrencyData'";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);
   }*/

   //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
   if (!do_check_table_exists(db, "TotalStrength")) {
      Print("Creating schema for ", db + " / TotalStrength");
      string sql = "CREATE TABLE 'TotalStrength' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Time' INTEGER, 'TimeFrame' INTEGER, 'Currency' TEXT, 'Strength' REAL)";
      do_exec(db, sql);
   }
   /*else if( db_reset )
   {
      string sql = "DELETE FROM 'TotalStrength'";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);
   }*/

   //-- 'Pivots' --> 'Time', 'Currency', 'FhrR1', 'FhrR2', 'FhrR3', 'FhrS1', 'FhrS2', 'FhrS3', 'FhrP', 'DR1', 'DR2', 'DR3', 'DS1', 'DS2', 'DS3', 'DP'
   if (!do_check_table_exists(db, "Pivots")) {
      Print("Creating schema for ", db + " / Pivots");
      string sql = "CREATE TABLE 'Pivots' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Time' INTEGER, 'Currency' TEXT, 'FhrR1' REAL, 'FhrR2' REAL, 'FhrR3' REAL, 'FhrS1' REAL, 'FhrS2' REAL, 'FhrS3' REAL, 'FhrP' REAL, 'DR1' REAL, 'DR2' REAL, 'DR3' REAL, 'DS1' REAL, 'DS2' REAL, 'DS3' REAL, 'DP' REAL)";
      do_exec(db, sql);
   }
   /*else if( db_reset )
   {
      string sql = "DELETE FROM 'Pivots'";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);
   }*/

   //-- 'Signals' --> 'Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5', 'Value6', 'Value7', 'Value8', 'Value9'
   if (!do_check_table_exists(db, "Signals")) {
      Print("Creating schema for ", db + " / Signals");
      string sql = "CREATE TABLE 'Signals' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Time' INTEGER, 'TimeFrame' INTEGER, 'Currency' TEXT, 'LastUpdate' INTEGER, 'Hits' INTEGER, ";
             sql+= "'Type' TEXT, 'Description' TEXT, 'Direction' INTEGER, 'Strength' REAL, 'High' REAL, 'Ask' REAL, 'Bid' REAL, 'Low' REAL, 'Open' REAL, 'TradeVolume' REAL,";
             sql+= "'Value0' REAL, 'Value1' REAL, 'Value2' REAL, 'Value3' REAL, 'Value4' REAL, 'Value5' REAL, 'Value6' REAL, 'Value7' REAL, 'Value8' REAL, 'Value9' REAL)";
      do_exec(db, sql);
   }

   //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
   if (!do_check_table_exists(db, "Trades")) {
     Print("Creating schema for ", db + " / Trades");
     string sql = "CREATE TABLE 'Trades' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'Ticket' INTEGER, 'TimeFrame' INTEGER, 'Pair' TEXT, 'Closed' INTEGER, 'SignalType' TEXT, 'SignalPoints' REAL, 'Direction' INTEGER, 'Strength' REAL, ";
            sql+= "'Size' REAL, 'TimeOpened' TIMESTAMP, 'TimeTouched' TIMESTAMP, 'CountTouched' INTEGER, RecentPoints INTEGER, RecentMoney REAL, 'High' INTEGER, 'Low' INTEGER, 'HighMoney' REAL, 'LowMoney' REAL, 'Hedge1' INTEGER, 'Hedge2' INTEGER, ";
            sql+= "'Hedge3' INTEGER, 'Hedge4' INTEGER, 'Hedge5' INTEGER, 'Hedge6' INTEGER, 'Hedge7' INTEGER, 'Hedge8' INTEGER)";
     do_exec(db, sql);
   }
   /*else if( db_reset )
   {
      string sql = "DELETE FROM 'Trades'";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);
   }*/

   //-- 'WeightMatrix' --> 'SignalType', 'Direction', 'MaxPoint', 'MinPoint', 'CurrentBar', 'LastBar', 'EuroSessionOpen', 'EuroSessionClosed', 'MorningSession', 'AfternoonSession', 'NightSession', 'StrengthStrong', 'StrengthWeak', 'DailyPercentHot', 'DailyPercentCold', 'PivotNear', 'PivotFar', 'SupportNear', 'SupportFar', 'ResistanceNear', 'ResistanceFar', 'DailyLevelNear', 'DailyLevelFar'
   if ( db_reset || !do_check_table_exists(db, "WeightMatrix") ) {
      string sql;

      if( !do_check_table_exists(db, "WeightMatrix" ) )
      {
         Print("Creating schema for ", db + " / WeightMatrix");
                sql = "CREATE TABLE 'WeightMatrix' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'SignalType' TEXT, 'Direction' INTEGER, 'MaxPoint' REAL, 'MinPoint' REAL, 'CurrentBar' INTEGER, 'LastBar' INTEGER, ";
                sql+= "'EuroSessionOpen' INTEGER, 'EuroSessionClosed' INTEGER, 'MorningSession' INTEGER, 'AfternoonSession' INTEGER, 'NightSession' INTEGER, 'StrengthStrong' INTEGER, 'StrengthWeak' INTEGER, ";
                sql+= "'DailyPercentHot' INTEGER, 'DailyPercentCold' INTEGER, 'PivotNear' INTEGER, 'PivotFar' INTEGER, 'SupportNear' INTEGER, 'SupportFar' INTEGER, 'ResistanceNear' INTEGER, 'ResistanceFar' INTEGER, ";
                sql+= "'DailyLevelNear' INTEGER, 'DailyLevelFar' INTEGER)";
         do_exec(db, sql);
      }

             sql = "DELETE FROM 'WeightMatrix'";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);

      //-- BB Weight Matrix
             sql = "INSERT INTO 'WeightMatrix'('SignalType', 'Direction'   , 'MaxPoint', 'MinPoint', 'CurrentBar', 'LastBar', 'EuroSessionOpen', 'EuroSessionClosed', 'MorningSession', 'AfternoonSession', 'NightSession', 'StrengthStrong', 'StrengthWeak', 'DailyPercentHot', 'DailyPercentCold', 'PivotNear', 'PivotFar', 'SupportNear', 'SupportFar', 'ResistanceNear', 'ResistanceFar', 'DailyLevelNear', 'DailyLevelFar') ";
                                 sql+= "VALUES('BB'        , '"+DIR_LONG+"',  21       ,  11       ,  1          ,  2       ,  2               ,  1                 ,  2              ,  1                ,  1            ,  2              ,  0            ,  1               ,  -1               ,  0         ,  2        ,  2           ,  0          ,  0              ,  2             ,  0              ,  2)";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);

             sql = "INSERT INTO 'WeightMatrix'('SignalType', 'Direction'    , 'MaxPoint', 'MinPoint', 'CurrentBar', 'LastBar', 'EuroSessionOpen', 'EuroSessionClosed', 'MorningSession', 'AfternoonSession', 'NightSession', 'StrengthStrong', 'StrengthWeak', 'DailyPercentHot', 'DailyPercentCold', 'PivotNear', 'PivotFar', 'SupportNear', 'SupportFar', 'ResistanceNear', 'ResistanceFar', 'DailyLevelNear', 'DailyLevelFar') ";
                                 sql+= "VALUES('BB'        , '"+DIR_SHORT+"',  21       ,  11       ,  1          ,  2       ,  2               ,  1                 ,  2              ,  1                ,  1            ,  2              ,  0            ,  1               ,  -1               ,  0         ,  2        ,  0           ,  2          ,  2              ,  0             ,  0              ,  2)";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);

      //-- ISW Weight Matrix
             sql = "INSERT INTO 'WeightMatrix'('SignalType', 'Direction'    , 'MaxPoint', 'MinPoint', 'CurrentBar', 'LastBar', 'EuroSessionOpen', 'EuroSessionClosed', 'MorningSession', 'AfternoonSession', 'NightSession', 'StrengthStrong', 'StrengthWeak', 'DailyPercentHot', 'DailyPercentCold', 'PivotNear', 'PivotFar', 'SupportNear', 'SupportFar', 'ResistanceNear', 'ResistanceFar', 'DailyLevelNear', 'DailyLevelFar') ";
                                 sql+= "VALUES('ISW'       , '"+DIR_LONG +"',  21       ,  11       ,  1          ,  2       ,  2               ,  1                 ,  2              ,  1                ,  1            ,  2              ,  0            ,  1               ,  -1               ,  0         ,  2        ,  2           ,  0          ,  0              ,  2             ,  0              ,  2)";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);

             sql = "INSERT INTO 'WeightMatrix'('SignalType', 'Direction'    , 'MaxPoint', 'MinPoint', 'CurrentBar', 'LastBar', 'EuroSessionOpen', 'EuroSessionClosed', 'MorningSession', 'AfternoonSession', 'NightSession', 'StrengthStrong', 'StrengthWeak', 'DailyPercentHot', 'DailyPercentCold', 'PivotNear', 'PivotFar', 'SupportNear', 'SupportFar', 'ResistanceNear', 'ResistanceFar', 'DailyLevelNear', 'DailyLevelFar') ";
                                 sql+= "VALUES('ISW'       , '"+DIR_SHORT+"',  21       ,  11       ,  1          ,  2       ,  2               ,  1                 ,  2              ,  1                ,  1            ,  2              ,  0            ,  1               ,  -1               ,  0         ,  2        ,  0           ,  2          ,  2              ,  0             ,  0              ,  2)";
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      do_exec(db, sql);

   }
   else
   {
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;

      //-- BB Weight Matrix

      handle = sqlite_query(db, "SELECT MaxPoint, MinPoint, CurrentBar, LastBar, EuroSessionOpen, EuroSessionClosed, MorningSession, AfternoonSession, NightSession, StrengthStrong, StrengthWeak, DailyPercentHot, DailyPercentCold, PivotNear, PivotFar, SupportNear, SupportFar, ResistanceNear, ResistanceFar, DailyLevelNear, DailyLevelFar FROM WeightMatrix WHERE SignalType = 'BB' AND Direction = "+DIR_LONG+" ORDER BY id DESC LIMIT 1", cols);
      if(sqlite_next_row(handle) > 0)
      {
         BB_LONG_MaxPoint            =   StringToDouble(sqlite_get_col(handle, 0));
         BB_LONG_MinPoint            =   StringToDouble(sqlite_get_col(handle, 1));
         BB_LONG_CurrentBar          =  StringToInteger(sqlite_get_col(handle, 2));
         BB_LONG_LastBar             =  StringToInteger(sqlite_get_col(handle, 3));
         BB_LONG_EuroSessionOpen     =  StringToInteger(sqlite_get_col(handle, 4));
         BB_LONG_EuroSessionClosed   =  StringToInteger(sqlite_get_col(handle, 5));
         BB_LONG_MorningSession      =  StringToInteger(sqlite_get_col(handle, 6));
         BB_LONG_AfternoonSession    =  StringToInteger(sqlite_get_col(handle, 7));
         BB_LONG_NightSession        =  StringToInteger(sqlite_get_col(handle, 8));
         BB_LONG_StrengthStrong      =  StringToInteger(sqlite_get_col(handle, 9));
         BB_LONG_StrengthWeak        = StringToInteger(sqlite_get_col(handle, 10));
         BB_LONG_DailyPercentHot     = StringToInteger(sqlite_get_col(handle, 11));
         BB_LONG_DailyPercentCold    = StringToInteger(sqlite_get_col(handle, 12));
         BB_LONG_PivotNear           = StringToInteger(sqlite_get_col(handle, 13));
         BB_LONG_PivotFar            = StringToInteger(sqlite_get_col(handle, 14));
         BB_LONG_SupportNear         = StringToInteger(sqlite_get_col(handle, 15));
         BB_LONG_SupportFar          = StringToInteger(sqlite_get_col(handle, 16));
         BB_LONG_ResistanceNear      = StringToInteger(sqlite_get_col(handle, 17));
         BB_LONG_ResistanceFar       = StringToInteger(sqlite_get_col(handle, 18));
         BB_LONG_DailyLevelNear      = StringToInteger(sqlite_get_col(handle, 19));
         BB_LONG_DailyLevelFar       = StringToInteger(sqlite_get_col(handle, 20));
      }
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;

      handle = sqlite_query(db, "SELECT MaxPoint, MinPoint, CurrentBar, LastBar, EuroSessionOpen, EuroSessionClosed, MorningSession, AfternoonSession, NightSession, StrengthStrong, StrengthWeak, DailyPercentHot, DailyPercentCold, PivotNear, PivotFar, SupportNear, SupportFar, ResistanceNear, ResistanceFar, DailyLevelNear, DailyLevelFar FROM WeightMatrix WHERE SignalType = 'BB' AND Direction = "+DIR_SHORT+" ORDER BY id DESC LIMIT 1", cols);
      if(sqlite_next_row(handle) > 0)
      {
         BB_SHORT_MaxPoint            =   StringToDouble(sqlite_get_col(handle, 0));
         BB_SHORT_MinPoint            =   StringToDouble(sqlite_get_col(handle, 1));
         BB_SHORT_CurrentBar          =  StringToInteger(sqlite_get_col(handle, 2));
         BB_SHORT_LastBar             =  StringToInteger(sqlite_get_col(handle, 3));
         BB_SHORT_EuroSessionOpen     =  StringToInteger(sqlite_get_col(handle, 4));
         BB_SHORT_EuroSessionClosed   =  StringToInteger(sqlite_get_col(handle, 5));
         BB_SHORT_MorningSession      =  StringToInteger(sqlite_get_col(handle, 6));
         BB_SHORT_AfternoonSession    =  StringToInteger(sqlite_get_col(handle, 7));
         BB_SHORT_NightSession        =  StringToInteger(sqlite_get_col(handle, 8));
         BB_SHORT_StrengthStrong      =  StringToInteger(sqlite_get_col(handle, 9));
         BB_SHORT_StrengthWeak        = StringToInteger(sqlite_get_col(handle, 10));
         BB_SHORT_DailyPercentHot     = StringToInteger(sqlite_get_col(handle, 11));
         BB_SHORT_DailyPercentCold    = StringToInteger(sqlite_get_col(handle, 12));
         BB_SHORT_PivotNear           = StringToInteger(sqlite_get_col(handle, 13));
         BB_SHORT_PivotFar            = StringToInteger(sqlite_get_col(handle, 14));
         BB_SHORT_SupportNear         = StringToInteger(sqlite_get_col(handle, 15));
         BB_SHORT_SupportFar          = StringToInteger(sqlite_get_col(handle, 16));
         BB_SHORT_ResistanceNear      = StringToInteger(sqlite_get_col(handle, 17));
         BB_SHORT_ResistanceFar       = StringToInteger(sqlite_get_col(handle, 18));
         BB_SHORT_DailyLevelNear      = StringToInteger(sqlite_get_col(handle, 19));
         BB_SHORT_DailyLevelFar       = StringToInteger(sqlite_get_col(handle, 20));
      }
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;

      //-- ISW Weight Matrix

      handle = sqlite_query(db, "SELECT MaxPoint, MinPoint, CurrentBar, LastBar, EuroSessionOpen, EuroSessionClosed, MorningSession, AfternoonSession, NightSession, StrengthStrong, StrengthWeak, DailyPercentHot, DailyPercentCold, PivotNear, PivotFar, SupportNear, SupportFar, ResistanceNear, ResistanceFar, DailyLevelNear, DailyLevelFar FROM WeightMatrix WHERE SignalType = 'ISW' AND Direction = "+DIR_LONG+" ORDER BY id DESC LIMIT 1", cols);
      if(sqlite_next_row(handle) > 0)
      {
         ISW_LONG_MaxPoint            =   StringToDouble(sqlite_get_col(handle, 0));
         ISW_LONG_MinPoint            =   StringToDouble(sqlite_get_col(handle, 1));
         ISW_LONG_CurrentBar          =  StringToInteger(sqlite_get_col(handle, 2));
         ISW_LONG_LastBar             =  StringToInteger(sqlite_get_col(handle, 3));
         ISW_LONG_EuroSessionOpen     =  StringToInteger(sqlite_get_col(handle, 4));
         ISW_LONG_EuroSessionClosed   =  StringToInteger(sqlite_get_col(handle, 5));
         ISW_LONG_MorningSession      =  StringToInteger(sqlite_get_col(handle, 6));
         ISW_LONG_AfternoonSession    =  StringToInteger(sqlite_get_col(handle, 7));
         ISW_LONG_NightSession        =  StringToInteger(sqlite_get_col(handle, 8));
         ISW_LONG_StrengthStrong      =  StringToInteger(sqlite_get_col(handle, 9));
         ISW_LONG_StrengthWeak        = StringToInteger(sqlite_get_col(handle, 10));
         ISW_LONG_DailyPercentHot     = StringToInteger(sqlite_get_col(handle, 11));
         ISW_LONG_DailyPercentCold    = StringToInteger(sqlite_get_col(handle, 12));
         ISW_LONG_PivotNear           = StringToInteger(sqlite_get_col(handle, 13));
         ISW_LONG_PivotFar            = StringToInteger(sqlite_get_col(handle, 14));
         ISW_LONG_SupportNear         = StringToInteger(sqlite_get_col(handle, 15));
         ISW_LONG_SupportFar          = StringToInteger(sqlite_get_col(handle, 16));
         ISW_LONG_ResistanceNear      = StringToInteger(sqlite_get_col(handle, 17));
         ISW_LONG_ResistanceFar       = StringToInteger(sqlite_get_col(handle, 18));
         ISW_LONG_DailyLevelNear      = StringToInteger(sqlite_get_col(handle, 19));
         ISW_LONG_DailyLevelFar       = StringToInteger(sqlite_get_col(handle, 20));
      }
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;

      handle = sqlite_query(db, "SELECT MaxPoint, MinPoint, CurrentBar, LastBar, EuroSessionOpen, EuroSessionClosed, MorningSession, AfternoonSession, NightSession, StrengthStrong, StrengthWeak, DailyPercentHot, DailyPercentCold, PivotNear, PivotFar, SupportNear, SupportFar, ResistanceNear, ResistanceFar, DailyLevelNear, DailyLevelFar FROM WeightMatrix WHERE SignalType = 'ISW' AND Direction = "+DIR_SHORT+" ORDER BY id DESC LIMIT 1", cols);
      if(sqlite_next_row(handle) > 0)
      {
         ISW_SHORT_MaxPoint            =   StringToDouble(sqlite_get_col(handle, 0));
         ISW_SHORT_MinPoint            =   StringToDouble(sqlite_get_col(handle, 1));
         ISW_SHORT_CurrentBar          =  StringToInteger(sqlite_get_col(handle, 2));
         ISW_SHORT_LastBar             =  StringToInteger(sqlite_get_col(handle, 3));
         ISW_SHORT_EuroSessionOpen     =  StringToInteger(sqlite_get_col(handle, 4));
         ISW_SHORT_EuroSessionClosed   =  StringToInteger(sqlite_get_col(handle, 5));
         ISW_SHORT_MorningSession      =  StringToInteger(sqlite_get_col(handle, 6));
         ISW_SHORT_AfternoonSession    =  StringToInteger(sqlite_get_col(handle, 7));
         ISW_SHORT_NightSession        =  StringToInteger(sqlite_get_col(handle, 8));
         ISW_SHORT_StrengthStrong      =  StringToInteger(sqlite_get_col(handle, 9));
         ISW_SHORT_StrengthWeak        = StringToInteger(sqlite_get_col(handle, 10));
         ISW_SHORT_DailyPercentHot     = StringToInteger(sqlite_get_col(handle, 11));
         ISW_SHORT_DailyPercentCold    = StringToInteger(sqlite_get_col(handle, 12));
         ISW_SHORT_PivotNear           = StringToInteger(sqlite_get_col(handle, 13));
         ISW_SHORT_PivotFar            = StringToInteger(sqlite_get_col(handle, 14));
         ISW_SHORT_SupportNear         = StringToInteger(sqlite_get_col(handle, 15));
         ISW_SHORT_SupportFar          = StringToInteger(sqlite_get_col(handle, 16));
         ISW_SHORT_ResistanceNear      = StringToInteger(sqlite_get_col(handle, 17));
         ISW_SHORT_ResistanceFar       = StringToInteger(sqlite_get_col(handle, 18));
         ISW_SHORT_DailyLevelNear      = StringToInteger(sqlite_get_col(handle, 19));
         ISW_SHORT_DailyLevelFar       = StringToInteger(sqlite_get_col(handle, 20));
      }
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
   }

//--- VIEWS

   //-- 'Statistics' --> 'Pair', 'SignalType', 'Trades', 'Points', 'WonPoints', 'LostPoints', 'BuyTrades', 'SellTrades', 'Winners', 'Losers', 'BuyPoints', 'SellPoints', 'PercWon', 'PercLost', 'PercBuy', 'PercSell'
   if ( !do_check_table_exists(db, "Statistics")) {
     Print("Creating schema for ", db + " / Statistics");
     do_exec(db, "CREATE VIEW 'Statistics' AS SELECT T.*, Winners, WonPoints, Losers, LostPoints, BuyTrades, BuyPoints, SellTrades, SellPoints, ((Winners*1.0/Trades)*100) PercWon,((Losers*1.0/Trades)*100) PercLost,((BuyTrades*1.0/Trades)*100) PercBuy,((SellTrades*1.0/Trades)*100) PercSell FROM ((SELECT Pair, SignalType, count(*) 'Trades', sum(RecentPoints) 'Points' FROM Trades GROUP BY Pair,SignalType) 'T' LEFT JOIN (SELECT Pair, SignalType, count(*) 'Winners', sum(RecentPoints) 'WonPoints' FROM Trades WHERE RecentPoints >= 0 GROUP BY Pair,SignalType) 'W' ON T.Pair = W.Pair AND T.SignalType = W.SignalType LEFT JOIN (SELECT Pair, SignalType, count(*) 'Losers', sum(RecentPoints) 'LostPoints' FROM Trades WHERE RecentPoints < 0 GROUP BY Pair,SignalType) 'L' ON T.Pair = L.Pair AND T.SignalType = L.SignalType LEFT JOIN (SELECT Pair, SignalType, count(*) 'BuyTrades', sum(RecentPoints) 'BuyPoints' FROM Trades WHERE Direction = 1 GROUP BY Pair,SignalType) 'B' ON T.Pair = B.Pair AND T.SignalType = B.SignalType LEFT JOIN (SELECT Pair, SignalType, count(*) 'SellTrades', sum(RecentPoints) 'SellPoints' FROM Trades WHERE Direction = -1 GROUP BY Pair,SignalType) 'S' ON T.Pair = S.Pair AND T.SignalType = S.SignalType)");
   }

//---
   ArraySetAsSeries(DailyBar,true);
   db_populated = false;
//---
   VerboseLog("--------------------------------------------------------");
//---
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();

//--- deinit sqlite engine
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;
   sqlite_finalize();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   global_counter++;
//---
   bool is_new_bar = is_a_new_bar();
//---
   if( db_reset && !db_populated )
   {
   //---
      manageOrders( is_new_bar );
   //---
      if (global_counter == 0)
      {
         PopulateDBStatistics();
      }
   //---
      return;
   }
//---
   int h_eu_session_hours  = hours_from_session_start(Euro_London_GMT_Start);
   bool h_eu_session_start = is_market_session_open(Euro_London_GMT_Start,Euro_London_GMT_End);

   int h_asian_session_hours = hours_from_session_start(Asia_Tokyo_GMT_Start);
//--- Check Signals - every X ticks

   bool sqBarIsOpen = false;
   if( is_new_bar )
   {
      sqBarIsOpen = true;
   }

   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

if (global_counter % skip_ticks == 0 ) {

   Hash *h  = new Hash();
   handleSig = sqlite_query(db, "SELECT * FROM 'Signals' ORDER BY LastUpdate ASC", cols);
   while(sqlite_next_row(handleSig) > 0)
   {
      string   sig_id     = sqlite_get_col(handleSig, 0);
      string sig_type     = sqlite_get_col(handleSig, 6);
      h.hPutLong(sig_type+"_"+sig_id,StringToInteger(sig_id));
   }

   if (handleSig > 0) sqlite_free_query(handleSig);
   handleSig = 0;

   HashLoop *l ;
   for( l = new HashLoop(h) ; l.hasNext() ; l.next()) {
      long sig_id = l.valLong();

      handle = sqlite_query(db, "SELECT * FROM 'Signals' WHERE id = "+sig_id+" ORDER BY LastUpdate ASC LIMIT 1", cols);
      if(sqlite_next_row(handle) > 0)
      {
         datetime sig_time   =       StrToTime(sqlite_get_col(handle, 1));
         int sig_timeFrame   = StringToInteger(sqlite_get_col(handle, 2));
         string sig_currency =                 sqlite_get_col(handle, 3);
         datetime sig_last_u =       StrToTime(sqlite_get_col(handle, 4));
         int sig_hits        = StringToInteger(sqlite_get_col(handle, 5));
         string sig_type     =                 sqlite_get_col(handle, 6);
         string sig_desc     =                 sqlite_get_col(handle, 7);
         int sig_direction   = StringToInteger(sqlite_get_col(handle, 8));
         int sig_strength    = StringToInteger(sqlite_get_col(handle, 9));
         double sig_high     =  StringToDouble(sqlite_get_col(handle,10));
         double sig_ask      = StringToDouble(sqlite_get_col(handle, 11));
         double sig_bid      = StringToDouble(sqlite_get_col(handle, 12));
         double sig_low      = StringToDouble(sqlite_get_col(handle, 13));
         double sig_open     = StringToDouble(sqlite_get_col(handle, 14));
         double sig_volume   = StringToDouble(sqlite_get_col(handle, 15));
         double sig_value0   = StringToDouble(sqlite_get_col(handle, 16));
         double sig_value1   = StringToDouble(sqlite_get_col(handle, 17));
         double sig_value2   = StringToDouble(sqlite_get_col(handle, 18));
         double sig_value3   = StringToDouble(sqlite_get_col(handle, 19));
         double sig_value4   = StringToDouble(sqlite_get_col(handle, 20));
         double sig_value5   = StringToDouble(sqlite_get_col(handle, 21));
         double sig_value6   = StringToDouble(sqlite_get_col(handle, 22));
         double sig_value7   = StringToDouble(sqlite_get_col(handle, 23));
         double sig_value8   = StringToDouble(sqlite_get_col(handle, 24));
         double sig_value9   = StringToDouble(sqlite_get_col(handle, 25));

         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         //-- Volatility
         bool volatility = sqVolatility(sig_currency,sig_timeFrame);

         int time_difference = (TimeGMT() - sig_last_u)/60;

         if( sig_hits < 0 || time_difference > sig_timeFrame )
         {
            //Print("Delete tuple from ", db + " / Signals");
            string sql = "DELETE FROM 'Signals' ";
                   sql+= "WHERE id = "+sig_id+"";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }

         //---- BB Signals
         else if( sig_type == "BB" && sig_hits >= 0 )
         {
            //--- Signal Type 'BB' - Confirmation

              HideTestIndicators(true);
               double bb_squeeze_green_0  = bb_squeeze_dark(sig_currency, sig_timeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
                        //iCustom(sig_currency, sig_timeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
               double bb_squeeze_green_1  = bb_squeeze_dark(sig_currency, sig_timeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);
                        //iCustom(sig_currency, sig_timeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);

               double upTrendStop         = doda_bands2(sig_currency, sig_timeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 0, 0);
               double downTrendStop       = doda_bands2(sig_currency, sig_timeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 1, 0);
               double upTrendSignal       = doda_bands2(sig_currency, sig_timeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 2, 0);
               double downTrendSignal     = doda_bands2(sig_currency, sig_timeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 3, 0);

               double upTrendStop_H       = doda_bands2(sig_currency, get_HigherTimeFrame(sig_timeFrame), "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 0, 0);
               double downTrendStop_H     = doda_bands2(sig_currency, get_HigherTimeFrame(sig_timeFrame), "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 1, 0);
              HideTestIndicators(false);

            int points = 0;
            //-- Current or Last Bar Signal Confirmation
            if( sqBarIsOpen )
            {
               if( bb_squeeze_green_0 != EMPTY_VALUE && bb_squeeze_green_0 == 0 && bb_squeeze_green_1 != EMPTY_VALUE && bb_squeeze_green_1 == 0 )
               {
                  if(upTrendStop > 0   && upTrendStop_H > 0   && sig_direction == DIR_LONG ) points += BB_LONG_LastBar;
                  if(downTrendStop > 0 && downTrendStop_H > 0 && sig_direction == DIR_SHORT) points += BB_SHORT_LastBar;
               }
            }
            else if( bb_squeeze_green_0 != EMPTY_VALUE && bb_squeeze_green_0 == 0 && bb_squeeze_green_1 != EMPTY_VALUE && bb_squeeze_green_1 == 0 )
            {
               if(upTrendSignal > 0   && upTrendStop_H > 0   && sig_direction == DIR_LONG ) points += BB_LONG_CurrentBar;
               if(downTrendSignal > 0 && downTrendStop_H > 0 && sig_direction == DIR_SHORT) points += BB_SHORT_CurrentBar;
            }

            //--- Japanese Candlestick Patterns - Strengthening
            int pattern = sqGetCandlePattern(sig_currency, sig_timeFrame, 1);
                pattern = (pattern != PATTERN_UNDEFINED ? pattern : sqGetCandlePattern(sig_currency, sig_timeFrame, 0));

            if( pattern >= 0 )
            {
               if( pattern != PATTERN_UNDEFINED )
               {
                  //-- Bearish Patterns
                  switch(pattern)
                  {
                     case PATTERN_BEARISH_DCC:
                     case PATTERN_BEARISH_E_DOJI:
                     case PATTERN_BEARISH_E_STAR:
                     case PATTERN_BEARISH_SS2:
                     case PATTERN_BEARISH_SS3:
                     case PATTERN_BEARISH_SS4:
                     case PATTERN_BEARISH_S_E:
                        points += (sig_direction == DIR_LONG ? -2 : +2);
                        break;
                  }

                  //-- Bullish Patterns
                  switch(pattern)
                  {
                     case PATTERN_BULLISH_HMR2:
                     case PATTERN_BULLISH_HMR3:
                     case PATTERN_BULLISH_HMR4:
                     case PATTERN_BULLISH_L_E:
                     case PATTERN_BULLISH_M_DOJI:
                     case PATTERN_BULLISH_M_STAR:
                     case PATTERN_BULLISH_P_L:
                        points += (sig_direction == DIR_SHORT ? -2 : +2);
                        break;
                  }
               }
            }

            //-- MM Velocity and Acceleration
            //int trend = getTrend(sig_currency,sig_timeFrame,soglie);
            int trend, trend_m15, trend_m30, trend_h1;
            trend_m15 = getTrend(sig_currency,PERIOD_M15, soglie);
            trend_m30 = getTrend(sig_currency,PERIOD_M30, soglie);
            trend_h1 = getTrend(sig_currency,PERIOD_H1, soglie);

            if(trend_m15 == TREND_CRESCENTE_FORTE && trend_m30 == TREND_CRESCENTE_FORTE && trend_h1 == TREND_CRESCENTE_FORTE) trend = TREND_CRESCENTE_FORTE;
            else if(trend_m15 == TREND_DECRESCENTE_FORTE && trend_m30 == TREND_DECRESCENTE_FORTE && trend_h1 == TREND_DECRESCENTE_FORTE) trend = TREND_DECRESCENTE_FORTE;
            else trend = TREND_LATERALE;
            //--
            trend = getTrendConfirmation(sig_currency,trend);
            //--
            switch(trend)
            {
               case TREND_CRESCENTE_FORTE:
                  points += (sig_direction == DIR_LONG ? +2 : -2);
                  break;
               case TREND_CRESCENTE_POCO_FORTE:
                  points += (sig_direction == DIR_LONG ? +1 : -1);
                  break;
               case TREND_CRESCENTE_ACC_NEGATIVA:
                  points += (sig_direction == DIR_LONG ? -1 : 0);
                  break;
               case TREND_DECRESCENTE_FORTE:
                  points += (sig_direction == DIR_SHORT ? +2 : -2);
                  break;
               case TREND_DECRESCENTE_POCO_FORTE:
                  points += (sig_direction == DIR_SHORT ? +1 : -1);
                  break;
               case TREND_DECRESCENTE_ACC_POSITIVA:
                  points += (sig_direction == DIR_SHORT ? -1 : 0);
                  break;
               default:
                  points += -1;
                  break;
            }

            //-- Market Sessions
            if( h_eu_session_start ) points += (sig_direction == DIR_LONG ? BB_LONG_EuroSessionOpen : BB_SHORT_EuroSessionOpen);
            else                     points += (sig_direction == DIR_LONG ? BB_LONG_EuroSessionClosed : BB_SHORT_EuroSessionClosed);

            if( h_eu_session_hours < 5 )                                points += (sig_direction == DIR_LONG ? BB_LONG_MorningSession : BB_SHORT_MorningSession);
            if( h_eu_session_hours >= 5 && h_eu_session_hours < 10)     points += (sig_direction == DIR_LONG ? BB_LONG_AfternoonSession : BB_SHORT_AfternoonSession);
            if( h_eu_session_hours >= 10 && h_asian_session_hours < 1 ) points += (sig_direction == DIR_LONG ? BB_LONG_NightSession : BB_SHORT_NightSession);

            //-- Individual Strength and Weakness
            string curr1    = StringSubstr(sig_currency,0,3);
            string curr2    = StringSubstr(sig_currency,3,5);

            double strength1 = 0;
            double strength2 = 0;

            //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
            handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr1+"' AND TimeFrame = "+sig_timeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               strength1  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr2+"' AND TimeFrame = "+sig_timeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               strength2  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            if(strength1 > 7 && strength2 < 3 && sig_direction == DIR_LONG )  points += BB_LONG_StrengthStrong;
            else if(strength1 - strength2 >= 4 && sig_direction == DIR_LONG ) points += BB_LONG_StrengthWeak;

            if(strength2 > 7 && strength1 < 3 && sig_direction == DIR_SHORT )  points += BB_SHORT_StrengthStrong;
            else if(strength2 - strength1 >= 4 && sig_direction == DIR_SHORT ) points += BB_SHORT_StrengthWeak;

            //-- Daily Percent Rate Consistency
            double dailyPercentChange = 0;

            //-- 'HeatMap' --> 'Time', 'TimeFrame', 'Pair1', 'Pair2', 'AvgCorrelation', 'DailyPercentChange'
            handle = sqlite_query(db, "SELECT DailyPercentChange FROM 'HeatMap' WHERE Pair2 = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               dailyPercentChange  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            //-- Daily Percent Range Concordance
            int dailyPercentChangeConcordanceCounter = 0;
            handle = sqlite_query(db, "SELECT distinct(DailyPercentChange),TimeFrame FROM 'HeatMap' WHERE Pair2 = '"+sig_currency+"' AND TimeFrame <> "+sig_timeFrame+" ORDER BY id DESC", cols);
            while(sqlite_next_row(handle) > 0)
            {
               double dailyPercentChange2 = StringToDouble(sqlite_get_col(handle, 0));

               if( dailyPercentChange > 0 && dailyPercentChange2 >= dailyPercentChange )
               {
                  dailyPercentChangeConcordanceCounter += 1;
               }
               else if( dailyPercentChange < 0 && dailyPercentChange2 <= dailyPercentChange )
               {
                  dailyPercentChangeConcordanceCounter += 1;
               }
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            if( /*(h_asian_session_hours <= 1 || h_eu_session_hours <= 1) &&*/ dailyPercentChangeConcordanceCounter > 1 && dailyPercentChange <= HeatMapDailyPercRateTholdMax && dailyPercentChange >= HeatMapDailyPercRateTholdMin && sig_direction == DIR_LONG )    points += BB_LONG_DailyPercentHot;
            else if( sig_direction == DIR_LONG ) points += BB_LONG_DailyPercentCold;

            if( /*(h_asian_session_hours <= 1 || h_eu_session_hours <= 1) &&*/ dailyPercentChangeConcordanceCounter > 1 && dailyPercentChange >= -HeatMapDailyPercRateTholdMax && dailyPercentChange <= -HeatMapDailyPercRateTholdMin && sig_direction == DIR_SHORT ) points += BB_SHORT_DailyPercentHot;
            else if( sig_direction == DIR_SHORT ) points += BB_SHORT_DailyPercentCold;

            //-- Pivots, Support/Resistance and Price Alerts
            //get_pivots(sig_currency);
            //-- 'Pivots' --> 'Time', 'Currency', 'FhrR1', 'FhrR2', 'FhrR3', 'FhrS1', 'FhrS2', 'FhrS3', 'FhrP', 'DR1', 'DR2', 'DR3', 'DS1', 'DS2', 'DS3', 'DP'
            handle = sqlite_query(db, "SELECT * FROM 'Pivots' WHERE Currency = '"+sig_currency+"' ORDER BY id DESC LIMIT 1", cols);
            if (sqlite_next_row(handle) > 0)
            {
               Fhr_R1 = StringToDouble(sqlite_get_col(handle,  3));
               Fhr_R2 = StringToDouble(sqlite_get_col(handle,  4));
               Fhr_R3 = StringToDouble(sqlite_get_col(handle,  5));
               Fhr_S1 = StringToDouble(sqlite_get_col(handle,  6));
               Fhr_S2 = StringToDouble(sqlite_get_col(handle,  7));
               Fhr_S3 = StringToDouble(sqlite_get_col(handle,  8));
               Fhr_P  = StringToDouble(sqlite_get_col(handle,  9));
               D_R1   = StringToDouble(sqlite_get_col(handle, 10));
               D_R2   = StringToDouble(sqlite_get_col(handle, 11));
               D_R3   = StringToDouble(sqlite_get_col(handle, 12));
               D_S1   = StringToDouble(sqlite_get_col(handle, 13));
               D_S2   = StringToDouble(sqlite_get_col(handle, 14));
               D_S3   = StringToDouble(sqlite_get_col(handle, 15));
               D_P    = StringToDouble(sqlite_get_col(handle, 16));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            double price = 0;

            MqlRates RatesBar[];
            ArraySetAsSeries(RatesBar,true);
            if(CopyRates(sig_currency,sig_timeFrame,0,2,RatesBar)==2)
            {
               double high     = RatesBar[0].high;
               double point    = MarketInfo(sig_currency,MODE_POINT);
               int    digits   = MarketInfo(sig_currency,MODE_DIGITS);
               double ask      = MarketInfo(sig_currency,MODE_ASK);
               double bid      = MarketInfo(sig_currency,MODE_BID);
               double low      = RatesBar[0].low;
               int    power    = MathPow(10,digits-1);
               double pipRange = (high-low)*power;
               double bidRatio = (pipRange > 0 ? ((bid-low)/pipRange*power)*100 : 0);
                      pipRange = (pipRange != 0 ? pipRange : 0.001);

               if( sig_direction == DIR_LONG )       price = bid;
               else if( sig_direction == DIR_SHORT ) price = ask;

               //--
               get_NearestAndFarestSR(sig_currency, sig_timeFrame, price);
               //--

               double distance_from_pivot             = MathAbs((price - Fhr_P)*power);
               double distance_from_support           = (price - nearest_support)*power;
               double distance_from_resistance        = (nearest_resistance - price)*power;
               double distance_from_daily_pivot       = MathAbs((price - D_P)*power);
               double distance_from_daily_support     = (price - nearest_daily_support)*power;
               double distance_from_daily_resistance  = (nearest_daily_resistance - price)*power;

               double SR_Range   = (nearest_resistance - nearest_support)*power;
                      SR_Range   = (SR_Range != 0 ? SR_Range : 0.001);
               double DSR_Range  = (nearest_daily_resistance - nearest_daily_support)*power;
                      DSR_Range  = (DSR_Range != 0 ? DSR_Range : 0.001);

               //--Fair distance from the Pivots
               double highest_distance = MathMax(distance_from_support,distance_from_resistance);
               double fair_perc_max    = highest_distance / (highest_distance - 15);
               double fair_perc_min    = (highest_distance - 15) / highest_distance;
               double fair_perc        = (distance_from_support/distance_from_resistance);

               if ( fair_perc < fair_perc_min || fair_perc > fair_perc_min ) points -= 10;

               //--Near/Far from the Pivot
               if( SR_Range >= 15 )
               {
                  double perc_dist_pivot = (distance_from_pivot*100)/SR_Range;

                  if( perc_dist_pivot >= 0 && perc_dist_pivot <= 50) points += (sig_direction == DIR_LONG ? BB_LONG_PivotNear : BB_SHORT_PivotNear);
                  else points += (sig_direction == DIR_LONG ? BB_LONG_PivotFar : BB_SHORT_PivotFar);

                  //--Near/Far from a Support or Resistance
                  double perc_dist_support    = (distance_from_support*100)/SR_Range;
                  double perc_dist_resistance = (distance_from_resistance*100)/SR_Range;

                  if( perc_dist_support >= 0 && perc_dist_support <= 25) points += (sig_direction == DIR_LONG ? BB_LONG_SupportNear : BB_SHORT_SupportNear);
                  else points += (sig_direction == DIR_LONG ? BB_LONG_SupportFar : BB_SHORT_SupportFar);

                  if( perc_dist_resistance >= 0 && perc_dist_resistance <= 25) points += (sig_direction == DIR_LONG ? BB_LONG_ResistanceNear : BB_SHORT_ResistanceNear);
                  else points += (sig_direction == DIR_LONG ? BB_LONG_ResistanceFar : BB_SHORT_ResistanceFar);
               }

               //--Near/Far from a Daily level
               if( DSR_Range >= 25 )
               {
                  double perc_dist_daily_pivot      = (distance_from_daily_pivot*100)/DSR_Range;
                  double perc_dist_daily_support    = (distance_from_daily_support*100)/DSR_Range;
                  double perc_dist_daily_resistance = (distance_from_daily_resistance*100)/DSR_Range;

                  if( perc_dist_daily_pivot >= 0 && perc_dist_daily_pivot <= 20) points += (sig_direction == DIR_LONG ? BB_LONG_DailyLevelNear : BB_SHORT_DailyLevelNear);
                  else points += (sig_direction == DIR_LONG ? BB_LONG_DailyLevelFar : BB_SHORT_DailyLevelFar);

                  if( perc_dist_daily_support >= 0 && perc_dist_daily_support <= 10) points += (sig_direction == DIR_LONG ? BB_LONG_DailyLevelNear : BB_SHORT_DailyLevelNear);
                  else points += (sig_direction == DIR_LONG ? BB_LONG_DailyLevelFar : BB_SHORT_DailyLevelFar);

                  if( perc_dist_daily_resistance >= 0 && perc_dist_daily_resistance <= 10) points += (sig_direction == DIR_LONG ? BB_LONG_DailyLevelNear : BB_SHORT_DailyLevelNear);
                  else points += (sig_direction == DIR_LONG ? BB_LONG_DailyLevelFar : BB_SHORT_DailyLevelFar);
               }

               //Print(points);
               if( sig_direction == DIR_LONG )
               {
                  //---
                  points = get_BayesanFilterPoints(points, sig_time, sig_timeFrame, sig_currency, sig_last_u, sig_hits, sig_type, sig_desc, sig_direction, sig_strength);
                  //---
                  double entry_points = BB_LONG_MinPoint + ((BB_LONG_MaxPoint - BB_LONG_MinPoint) / 2);
                  if( points >= entry_points)
                  {
                     double realSL = NormalizeDouble(upTrendStop, MarketInfo(sig_currency,MODE_DIGITS));
                     double realPT = NormalizeDouble(MathMin(farest_resistance,farest_daily_resistance), MarketInfo(sig_currency,MODE_DIGITS));

                     if(volatility)
                        sqOpenOrder(sig_currency, OP_BUY, getOrderSize(sig_currency, 1000, OP_BUY ), getOrderPrice(sig_currency, 1000), realSL, realPT, "BB_Long("+sqGetTimeFrameAsStr(sig_timeFrame)+")", 1000, "GoLong1");

                     int PointProfit = (OrderClosePrice() - OrderOpenPrice()) * power;
                     double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

                     string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                     StringReplace(timeTouched,".","-");

                     //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
                     bool tradeAlreadyStored = false;
                     string sql = "SELECT count(*) FROM 'Trades' WHERE Ticket = " + OrderTicket();
                     handle = sqlite_query(db, sql, cols);
                     if (sqlite_next_row(handle) > 0) {
                        int numTrades = StrToInteger(sqlite_get_col(handle, 0));
                        tradeAlreadyStored = (numTrades > 0);
                     }
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     if( !tradeAlreadyStored )
                     {
                            sql = "INSERT INTO 'Trades' ('Ticket','TimeFrame','Pair','Closed','SignalType','SignalPoints','Direction','Strength','Size','TimeOpened','TimeTouched','CountTouched', 'RecentPoints', 'RecentMoney', 'High','Low','HighMoney','LowMoney','Hedge1','Hedge2','Hedge3','Hedge4') VALUES (";
                            sql+= "'" + OrderTicket() + "',"+sig_timeFrame+",'" + OrderSymbol() + "','0','" + sig_type + "','" + points + "','" + DIR_LONG + "','" + sig_strength + "',";
                            sql+= "'" + OrderLots() + "','" + TimeGMT() + "','" + timeTouched + "', 0, '"+ PointProfit +"', '"+ MoneyProfit +"', '"+ PointProfit +"',  '"+ PointProfit +"', '" + MoneyProfit + "', '" + MoneyProfit + "',";
                            sql+= "'" + OrderOpenPrice() + "','" + OrderClosePrice() + "','" + OrderStopLoss() + "', '" + OrderTakeProfit() + "' ";
                            sql+= ")";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }

                     //Print("Updating tuple for ", db + " / Signals");
                            sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '-1', ";
                            sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(sig_currency,MODE_ASK)+"', Bid = '"+MarketInfo(sig_currency,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"', ";
                            sql+= "Value0 = '"+bb_squeeze_green_0+"', Value1 = '"+bb_squeeze_green_1+"', Value2 = '"+upTrendStop+"', Value3 = '"+downTrendStop+"', Value4 = '"+upTrendSignal+"', Value5 = '"+downTrendSignal+"' ";
                            sql+= "WHERE Currency = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Type = 'BB' AND Direction = '"+DIR_LONG+"' AND Strength = '"+STR_STRONG+"'";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }

                  //-- Close opposite directions
                  if( sqLiveOrderExists(sig_currency, 2000) )
                  {
                     RefreshRates();
                     if( sqClosePositionAtMarket(OrderLots()) )
                     {
                        int PointProfit = (OrderOpenPrice() - OrderClosePrice()) * power;
                        double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();
                        handle = sqlite_query(db, "SELECT TimeOpened, High, Low, HighMoney, LowMoney, Hedge1, Hedge2, Hedge3, Hedge4, Hedge5, Hedge6, Hedge7, Hedge8 FROM Trades WHERE Ticket=" + OrderTicket() + " LIMIT 1", cols);
                        if (sqlite_next_row(handle) > 0) {
                           int ticket = OrderTicket();
                           datetime dataTimeOpened = StrToTime(sqlite_get_col(handle, 0));
                           int dataHighPoints = StrToDouble(sqlite_get_col(handle, 1));
                           int dataLowPoints = StrToDouble(sqlite_get_col(handle, 2));
                           double dataHighMoney = StrToDouble(sqlite_get_col(handle, 3));
                           double dataLowMoney = StrToDouble(sqlite_get_col(handle, 4));

                           string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                           StringReplace(timeTouched,".","-");

                           string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', Closed = -2, CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit +" " ;
                                  sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                                  sql+= " WHERE Ticket=" + ticket + "";
                           if (handle > 0) sqlite_free_query(handle);
                           handle = 0;
                           do_exec(db, sql);
                        }
                     }
                  }

               }
               else if( sig_direction == DIR_SHORT )
               {
                  //---
                  points = get_BayesanFilterPoints(points, sig_time, sig_timeFrame, sig_currency, sig_last_u, sig_hits, sig_type, sig_desc, sig_direction, sig_strength);
                  //---
                  double entry_points = BB_SHORT_MinPoint + ((BB_SHORT_MaxPoint - BB_SHORT_MinPoint) / 2);
                  if( points >= entry_points)
                  {
                     double realSL = NormalizeDouble(downTrendStop, MarketInfo(sig_currency,MODE_DIGITS));
                     double realPT = NormalizeDouble(MathMax(farest_support,farest_daily_support), MarketInfo(sig_currency,MODE_DIGITS));

                     if(volatility)
                        sqOpenOrder(sig_currency, OP_SELL, getOrderSize(sig_currency, 2000, OP_SELL ), getOrderPrice(sig_currency, 2000), realSL, realPT, "BB_Short("+sqGetTimeFrameAsStr(sig_timeFrame)+")", 2000, "GoShort1");

                     int PointProfit = (OrderOpenPrice() - OrderClosePrice()) * power;
                     double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

                     string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                     StringReplace(timeTouched,".","-");

                     //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
                     bool tradeAlreadyStored = false;
                     string sql = "SELECT count(*) FROM 'Trades' WHERE Ticket = " + OrderTicket();
                     handle = sqlite_query(db, sql, cols);
                     if (sqlite_next_row(handle) > 0) {
                        int numTrades = StrToInteger(sqlite_get_col(handle, 0));
                        tradeAlreadyStored = (numTrades > 0);
                     }
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     if( !tradeAlreadyStored )
                     {
                            sql = "INSERT INTO 'Trades' ('Ticket','TimeFrame','Pair','Closed','SignalType','SignalPoints','Direction','Strength','Size','TimeOpened','TimeTouched','CountTouched', 'RecentPoints', 'RecentMoney', 'High','Low','HighMoney','LowMoney','Hedge1','Hedge2','Hedge3','Hedge4') VALUES (";
                            sql+= "'" + OrderTicket() + "',"+sig_timeFrame+",'" + OrderSymbol() + "','0','" + sig_type + "','" + points + "','" + DIR_SHORT + "','" + sig_strength + "',";
                            sql+= "'" + OrderLots() + "','" + TimeGMT() + "','" + timeTouched + "', 0, '"+ PointProfit +"', '"+ MoneyProfit +"', '"+ PointProfit +"',  '"+ PointProfit +"', '" + MoneyProfit + "', '" + MoneyProfit + "',";
                            sql+= "'" + OrderOpenPrice() + "','" + OrderClosePrice() + "','" + OrderStopLoss() + "', '" + OrderTakeProfit() + "' ";
                            sql+= ")";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }

                     //Print("Updating tuple for ", db + " / Signals");
                            sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '-1', ";
                            sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(sig_currency,MODE_ASK)+"', Bid = '"+MarketInfo(sig_currency,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"', ";
                            sql+= "Value0 = '"+bb_squeeze_green_0+"', Value1 = '"+bb_squeeze_green_1+"', Value2 = '"+upTrendStop+"', Value3 = '"+downTrendStop+"', Value4 = '"+upTrendSignal+"', Value5 = '"+downTrendSignal+"' ";
                            sql+= "WHERE Currency = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Type = 'BB' AND Direction = '"+DIR_SHORT+"' AND Strength = '"+STR_STRONG+"'";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }

                  //-- Close opposite directions
                  if( sqLiveOrderExists(sig_currency, 1000) )
                  {
                     RefreshRates();
                     if( sqClosePositionAtMarket(OrderLots()) )
                     {
                        int PointProfit = (OrderClosePrice() - OrderOpenPrice()) * power;
                        double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();
                        handle = sqlite_query(db, "SELECT TimeOpened, High, Low, HighMoney, LowMoney, Hedge1, Hedge2, Hedge3, Hedge4, Hedge5, Hedge6, Hedge7, Hedge8 FROM Trades WHERE Ticket=" + OrderTicket() + " LIMIT 1", cols);
                        if (sqlite_next_row(handle) > 0) {
                           int ticket = OrderTicket();
                           datetime dataTimeOpened = StrToTime(sqlite_get_col(handle, 0));
                           int dataHighPoints = StrToDouble(sqlite_get_col(handle, 1));
                           int dataLowPoints = StrToDouble(sqlite_get_col(handle, 2));
                           double dataHighMoney = StrToDouble(sqlite_get_col(handle, 3));
                           double dataLowMoney = StrToDouble(sqlite_get_col(handle, 4));

                           string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                           StringReplace(timeTouched,".","-");

                           string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', Closed = -2, CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit +" " ;
                                  sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                                  sql+= " WHERE Ticket=" + ticket + "";
                           if (handle > 0) sqlite_free_query(handle);
                           handle = 0;
                           do_exec(db, sql);
                        }
                     }
                  }
               }
            }

            //Print(points);
         }

         //---- ISW Signals
         else if( sig_type == "ISW" && sig_hits >= 0 )
         {
            HideTestIndicators(true);
               double upTrendStop_H       = doda_bands2(sig_currency, get_HigherTimeFrame(sig_timeFrame), "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 0, 0);
               double downTrendStop_H     = doda_bands2(sig_currency, get_HigherTimeFrame(sig_timeFrame), "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 1, 0);
            HideTestIndicators(false);

            int points = 0;
            //-- Current or Last Bar Signal Confirmation
            if( sqBarIsOpen )
            {
               if( upTrendStop_H > 0   && sig_direction == DIR_LONG  ) points += ISW_LONG_LastBar;
               if( downTrendStop_H > 0 && sig_direction == DIR_SHORT ) points += ISW_SHORT_LastBar;
            }
            else
            {
               if( upTrendStop_H > 0   && sig_direction == DIR_LONG  ) points += ISW_LONG_CurrentBar;
               if( downTrendStop_H > 0 && sig_direction == DIR_SHORT ) points += ISW_SHORT_CurrentBar;
            }

            //--- Japanese Candlestick Patterns - Strengthening
            int pattern = sqGetCandlePattern(sig_currency, sig_timeFrame, 1);
                pattern = (pattern != PATTERN_UNDEFINED ? pattern : sqGetCandlePattern(sig_currency, sig_timeFrame, 0));

            if( pattern >= 0 )
            {
               if( pattern != PATTERN_UNDEFINED )
               {
                  //-- Bearish Patterns
                  switch(pattern)
                  {
                     case PATTERN_BEARISH_DCC:
                     case PATTERN_BEARISH_E_DOJI:
                     case PATTERN_BEARISH_E_STAR:
                     case PATTERN_BEARISH_SS2:
                     case PATTERN_BEARISH_SS3:
                     case PATTERN_BEARISH_SS4:
                     case PATTERN_BEARISH_S_E:
                        points += (sig_direction == DIR_LONG ? -2 : +2);
                        break;
                  }

                  //-- Bullish Patterns
                  switch(pattern)
                  {
                     case PATTERN_BULLISH_HMR2:
                     case PATTERN_BULLISH_HMR3:
                     case PATTERN_BULLISH_HMR4:
                     case PATTERN_BULLISH_L_E:
                     case PATTERN_BULLISH_M_DOJI:
                     case PATTERN_BULLISH_M_STAR:
                     case PATTERN_BULLISH_P_L:
                        points += (sig_direction == DIR_SHORT ? -2 : +2);
                        break;
                  }
               }
            }

            //-- MM Velocity and Acceleration
            //int trend = getTrend(sig_currency,sig_timeFrame,soglie);
            int trend, trend_m15, trend_m30, trend_h1;
            trend_m15 = getTrend(sig_currency,PERIOD_M15, soglie);
            trend_m30 = getTrend(sig_currency,PERIOD_M30, soglie);
            trend_h1 = getTrend(sig_currency,PERIOD_H1, soglie);

            if(trend_m15 == TREND_CRESCENTE_FORTE && trend_m30 == TREND_CRESCENTE_FORTE && trend_h1 == TREND_CRESCENTE_FORTE) trend = TREND_CRESCENTE_FORTE;
            else if(trend_m15 == TREND_DECRESCENTE_FORTE && trend_m30 == TREND_DECRESCENTE_FORTE && trend_h1 == TREND_DECRESCENTE_FORTE) trend = TREND_DECRESCENTE_FORTE;
            else trend = TREND_LATERALE;
            //--
            trend = getTrendConfirmation(sig_currency,trend);
            //--
            switch(trend)
            {
               case TREND_CRESCENTE_FORTE:
                  points += (sig_direction == DIR_LONG ? +2 : -2);
                  break;
               case TREND_CRESCENTE_POCO_FORTE:
                  points += (sig_direction == DIR_LONG ? +1 : -1);
                  break;
               case TREND_CRESCENTE_ACC_NEGATIVA:
                  points += (sig_direction == DIR_LONG ? -1 : 0);
                  break;
               case TREND_DECRESCENTE_FORTE:
                  points += (sig_direction == DIR_SHORT ? +2 : -2);
                  break;
               case TREND_DECRESCENTE_POCO_FORTE:
                  points += (sig_direction == DIR_SHORT ? +1 : -1);
                  break;
               case TREND_DECRESCENTE_ACC_POSITIVA:
                  points += (sig_direction == DIR_SHORT ? -1 : 0);
                  break;
               default:
                  points += -1;
                  break;
            }

            //-- Market Sessions
            if( h_eu_session_start ) points += (sig_direction == DIR_LONG ? ISW_LONG_EuroSessionOpen   : ISW_SHORT_EuroSessionOpen);
            else                     points += (sig_direction == DIR_LONG ? ISW_LONG_EuroSessionClosed : ISW_SHORT_EuroSessionClosed);

            if( h_eu_session_hours < 5 )                                points += (sig_direction == DIR_LONG ? ISW_LONG_MorningSession   : ISW_SHORT_MorningSession);
            if( h_eu_session_hours >= 5 && h_eu_session_hours < 10)     points += (sig_direction == DIR_LONG ? ISW_LONG_AfternoonSession : ISW_SHORT_AfternoonSession);
            if( h_eu_session_hours >= 10 && h_asian_session_hours < 1 ) points += (sig_direction == DIR_LONG ? ISW_LONG_NightSession     : ISW_SHORT_NightSession);

            //-- Individual Strength and Weakness
            string curr1    = StringSubstr(sig_currency,0,3);
            string curr2    = StringSubstr(sig_currency,3,5);

            double strength1 = 0;
            double strength2 = 0;

            //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
            handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr1+"' AND TimeFrame = "+sig_timeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               strength1  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr2+"' AND TimeFrame = "+sig_timeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               strength2  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            if(strength1 > 7 && strength2 < 3 && sig_direction == DIR_LONG )  points += ISW_LONG_StrengthStrong;
            else if(strength1 - strength2 >= 4 && sig_direction == DIR_LONG ) points += ISW_LONG_StrengthWeak;

            if(strength2 > 7 && strength1 < 3 && sig_direction == DIR_SHORT )  points += ISW_SHORT_StrengthStrong;
            else if(strength2 - strength1 >= 4 && sig_direction == DIR_SHORT ) points += ISW_SHORT_StrengthWeak;

            //-- Daily Percent Rate Consistency
            double dailyPercentChange = 0;

            //-- 'HeatMap' --> 'Time', 'TimeFrame', 'Pair1', 'Pair2', 'AvgCorrelation', 'DailyPercentChange'
            handle = sqlite_query(db, "SELECT DailyPercentChange FROM 'HeatMap' WHERE Pair2 = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               dailyPercentChange  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            //-- Daily Percent Range Concordance
            int dailyPercentChangeConcordanceCounter = 0;
            handle = sqlite_query(db, "SELECT distinct(DailyPercentChange),TimeFrame FROM 'HeatMap' WHERE Pair2 = '"+sig_currency+"' AND TimeFrame <> "+sig_timeFrame+" ORDER BY id DESC", cols);
            while(sqlite_next_row(handle) > 0)
            {
               double dailyPercentChange2 = StringToDouble(sqlite_get_col(handle, 0));

               if( dailyPercentChange > 0 && dailyPercentChange2 >= dailyPercentChange )
               {
                  dailyPercentChangeConcordanceCounter += 1;
               }
               else if( dailyPercentChange < 0 && dailyPercentChange2 <= dailyPercentChange )
               {
                  dailyPercentChangeConcordanceCounter += 1;
               }
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            if( /*(h_asian_session_hours < 2 || h_eu_session_hours < 2) &&*/ dailyPercentChangeConcordanceCounter > 1 && dailyPercentChange <= HeatMapDailyPercRateTholdMax && dailyPercentChange >= HeatMapDailyPercRateTholdMin && sig_direction == DIR_LONG )    points += ISW_LONG_DailyPercentHot;
            else if( sig_direction == DIR_LONG ) points += ISW_LONG_DailyPercentCold;

            if( /*(h_asian_session_hours < 2 || h_eu_session_hours < 2) &&*/ dailyPercentChangeConcordanceCounter > 1 && dailyPercentChange >= -HeatMapDailyPercRateTholdMax && dailyPercentChange <= -HeatMapDailyPercRateTholdMin && sig_direction == DIR_SHORT ) points += ISW_SHORT_DailyPercentHot;
            else if( sig_direction == DIR_SHORT ) points += ISW_SHORT_DailyPercentCold;

            //-- Pivots, Support/Resistance and Price Alerts
            //get_pivots(sig_currency);
            //-- 'Pivots' --> 'Time', 'Currency', 'FhrR1', 'FhrR2', 'FhrR3', 'FhrS1', 'FhrS2', 'FhrS3', 'FhrP', 'DR1', 'DR2', 'DR3', 'DS1', 'DS2', 'DS3', 'DP'
            handle = sqlite_query(db, "SELECT * FROM 'Pivots' WHERE Currency = '"+sig_currency+"' ORDER BY id DESC LIMIT 1", cols);
            if (sqlite_next_row(handle) > 0)
            {
               Fhr_R1 = StringToDouble(sqlite_get_col(handle,  3));
               Fhr_R2 = StringToDouble(sqlite_get_col(handle,  4));
               Fhr_R3 = StringToDouble(sqlite_get_col(handle,  5));
               Fhr_S1 = StringToDouble(sqlite_get_col(handle,  6));
               Fhr_S2 = StringToDouble(sqlite_get_col(handle,  7));
               Fhr_S3 = StringToDouble(sqlite_get_col(handle,  8));
               Fhr_P  = StringToDouble(sqlite_get_col(handle,  9));
               D_R1   = StringToDouble(sqlite_get_col(handle, 10));
               D_R2   = StringToDouble(sqlite_get_col(handle, 11));
               D_R3   = StringToDouble(sqlite_get_col(handle, 12));
               D_S1   = StringToDouble(sqlite_get_col(handle, 13));
               D_S2   = StringToDouble(sqlite_get_col(handle, 14));
               D_S3   = StringToDouble(sqlite_get_col(handle, 15));
               D_P    = StringToDouble(sqlite_get_col(handle, 16));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            double price = 0;

            MqlRates RatesBar[];
            ArraySetAsSeries(RatesBar,true);
            if(CopyRates(sig_currency,sig_timeFrame,0,2,RatesBar)==2)
            {
               double high     = RatesBar[0].high;
               double point    = MarketInfo(sig_currency,MODE_POINT);
               int    digits   = MarketInfo(sig_currency,MODE_DIGITS);
               double ask      = MarketInfo(sig_currency,MODE_ASK);
               double bid      = MarketInfo(sig_currency,MODE_BID);
               double low      = RatesBar[0].low;
               int    power    = MathPow(10,digits-1);
               double pipRange = (high-low)*power;
               double bidRatio = (pipRange > 0 ? ((bid-low)/pipRange*power)*100 : 0);
                      pipRange = (pipRange != 0 ? pipRange : 0.001);

               if( sig_direction == DIR_LONG )       price = bid;
               else if( sig_direction == DIR_SHORT ) price = ask;

               //--
               get_NearestAndFarestSR(sig_currency, sig_timeFrame, price);
               //--

               double distance_from_pivot             = MathAbs((price - Fhr_P)*power);
               double distance_from_support           = (price - nearest_support)*power;
               double distance_from_resistance        = (nearest_resistance - price)*power;
               double distance_from_daily_pivot       = MathAbs((price - D_P)*power);
               double distance_from_daily_support     = (price - nearest_daily_support)*power;
               double distance_from_daily_resistance  = (nearest_daily_resistance - price)*power;

               double SR_Range   = (nearest_resistance - nearest_support)*power;
                      SR_Range   = (SR_Range != 0 ? SR_Range : 0.001);
               double DSR_Range  = (nearest_daily_resistance - nearest_daily_support)*power;
                      DSR_Range  = (DSR_Range != 0 ? DSR_Range : 0.001);

               //--Fair distance from the Pivots
               double highest_distance = MathMax(distance_from_support,distance_from_resistance);
               double fair_perc_max    = highest_distance / (highest_distance - 15);
               double fair_perc_min    = (highest_distance - 15) / highest_distance;
               double fair_perc        = (distance_from_support/distance_from_resistance);

               if ( fair_perc < fair_perc_min || fair_perc > fair_perc_min ) points -= 10;

               //--Near/Far from the Pivot
               if( SR_Range >= 15 )
               {
                  double perc_dist_pivot = (distance_from_pivot*100)/SR_Range;

                  if( perc_dist_pivot >= 0 && perc_dist_pivot <= 50) points += (sig_direction == DIR_LONG ? ISW_LONG_PivotNear : ISW_SHORT_PivotNear);
                  else points += (sig_direction == DIR_LONG ? ISW_LONG_PivotFar : ISW_SHORT_PivotFar);

                  //--Near/Far from a Support or Resistance
                  double perc_dist_support    = (distance_from_support*100)/SR_Range;
                  double perc_dist_resistance = (distance_from_resistance*100)/SR_Range;

                  if( perc_dist_support >= 0 && perc_dist_support <= 25) points += (sig_direction == DIR_LONG ? ISW_LONG_SupportNear : ISW_SHORT_SupportNear);
                  else points += (sig_direction == DIR_LONG ? ISW_LONG_SupportFar : ISW_SHORT_SupportFar);

                  if( perc_dist_resistance >= 0 && perc_dist_resistance <= 25) points += (sig_direction == DIR_LONG ? ISW_LONG_ResistanceNear : ISW_SHORT_ResistanceNear);
                  else points += (sig_direction == DIR_LONG ? ISW_LONG_ResistanceFar : ISW_SHORT_ResistanceFar);
               }

               //--Near/Far from a Daily level
               if( DSR_Range >= 25 )
               {
                  double perc_dist_daily_pivot      = (distance_from_daily_pivot*100)/DSR_Range;
                  double perc_dist_daily_support    = (distance_from_daily_support*100)/DSR_Range;
                  double perc_dist_daily_resistance = (distance_from_daily_resistance*100)/DSR_Range;

                  if( perc_dist_daily_pivot >= 0 && perc_dist_daily_pivot <= 20) points += (sig_direction == DIR_LONG ? ISW_LONG_DailyLevelNear : ISW_SHORT_DailyLevelNear);
                  else points += (sig_direction == DIR_LONG ? ISW_LONG_DailyLevelFar : ISW_SHORT_DailyLevelFar);

                  if( perc_dist_daily_support >= 0 && perc_dist_daily_support <= 10) points += (sig_direction == DIR_LONG ? ISW_LONG_DailyLevelNear : ISW_SHORT_DailyLevelNear);
                  else points += (sig_direction == DIR_LONG ? ISW_LONG_DailyLevelFar : ISW_SHORT_DailyLevelFar);

                  if( perc_dist_daily_resistance >= 0 && perc_dist_daily_resistance <= 10) points += (sig_direction == DIR_LONG ? ISW_LONG_DailyLevelNear : ISW_SHORT_DailyLevelNear);
                  else points += (sig_direction == DIR_LONG ? ISW_LONG_DailyLevelFar : ISW_SHORT_DailyLevelFar);
               }

               //Print(points);
               if( sig_direction == DIR_LONG )
               {
                  //---
                  points = get_BayesanFilterPoints(points, sig_time, sig_timeFrame, sig_currency, sig_last_u, sig_hits, sig_type, sig_desc, sig_direction, sig_strength);
                  //---
                  double entry_points = ISW_LONG_MinPoint + ((ISW_LONG_MaxPoint - ISW_LONG_MinPoint) / 2);
                  if( points >= entry_points)
                  {
                     double realSL = NormalizeDouble(MathMax(nearest_support,nearest_daily_support), MarketInfo(sig_currency,MODE_DIGITS));
                     double realPT = NormalizeDouble(MathMin(farest_resistance,farest_daily_resistance), MarketInfo(sig_currency,MODE_DIGITS));

                     if(volatility)
                        sqOpenOrder(sig_currency, OP_BUY, getOrderSize(sig_currency, 1000, OP_BUY ), getOrderPrice(sig_currency, 1000), realSL, realPT, "ISW_Long("+sqGetTimeFrameAsStr(sig_timeFrame)+")", 1000, "GoLong1");

                     int PointProfit = (OrderClosePrice() - OrderOpenPrice()) * power;
                     double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

                     string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                     StringReplace(timeTouched,".","-");

                     //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
                     bool tradeAlreadyStored = false;
                     string sql = "SELECT count(*) FROM 'Trades' WHERE Ticket = " + OrderTicket();
                     handle = sqlite_query(db, sql, cols);
                     if (sqlite_next_row(handle) > 0) {
                        int numTrades = StrToInteger(sqlite_get_col(handle, 0));
                        tradeAlreadyStored = (numTrades > 0);
                     }
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     if( !tradeAlreadyStored )
                     {
                            sql = "INSERT INTO 'Trades' ('Ticket','TimeFrame','Pair','Closed','SignalType','SignalPoints','Direction','Strength','Size','TimeOpened','TimeTouched','CountTouched', 'RecentPoints', 'RecentMoney', 'High','Low','HighMoney','LowMoney','Hedge1','Hedge2','Hedge3','Hedge4') VALUES (";
                            sql+= "'" + OrderTicket() + "',"+sig_timeFrame+",'" + OrderSymbol() + "','0','" + sig_type + "','" + points + "','" + DIR_LONG + "','" + sig_strength + "',";
                            sql+= "'" + OrderLots() + "','" + TimeGMT() + "','" + timeTouched + "', 0, '"+ PointProfit +"', '"+ MoneyProfit +"', '"+ PointProfit +"',  '"+ PointProfit +"', '" + MoneyProfit + "', '" + MoneyProfit + "',";
                            sql+= "'" + OrderOpenPrice() + "','" + OrderClosePrice() + "','" + OrderStopLoss() + "', '" + OrderTakeProfit() + "' ";
                            sql+= ")";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }

                     //Print("Updating tuple for ", db + " / Signals");
                            sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '-1', ";
                            sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(sig_currency,MODE_ASK)+"', Bid = '"+MarketInfo(sig_currency,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"' ";
                            sql+= "WHERE Currency = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Type = 'ISW' AND Direction = '"+DIR_LONG+"' AND Strength = '"+STR_STRONG+"'";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }

                  //-- Close opposite directions
                  if( sqLiveOrderExists(sig_currency, 2000) )
                  {
                     RefreshRates();
                     if( sqClosePositionAtMarket(OrderLots()) )
                     {
                        int PointProfit = (OrderOpenPrice() - OrderClosePrice()) * power;
                        double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();
                        handle = sqlite_query(db, "SELECT TimeOpened, High, Low, HighMoney, LowMoney, Hedge1, Hedge2, Hedge3, Hedge4, Hedge5, Hedge6, Hedge7, Hedge8 FROM Trades WHERE Ticket=" + OrderTicket() + " LIMIT 1", cols);
                        if (sqlite_next_row(handle) > 0) {
                           int ticket = OrderTicket();
                           datetime dataTimeOpened = StrToTime(sqlite_get_col(handle, 0));
                           int dataHighPoints = StrToDouble(sqlite_get_col(handle, 1));
                           int dataLowPoints = StrToDouble(sqlite_get_col(handle, 2));
                           double dataHighMoney = StrToDouble(sqlite_get_col(handle, 3));
                           double dataLowMoney = StrToDouble(sqlite_get_col(handle, 4));

                           string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                           StringReplace(timeTouched,".","-");

                           string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', Closed = -2, CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit +" " ;
                                  sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                                  sql+= " WHERE Ticket=" + ticket + "";
                           if (handle > 0) sqlite_free_query(handle);
                           handle = 0;
                           do_exec(db, sql);
                        }
                     }
                  }

               }
               else if( sig_direction == DIR_SHORT )
               {
                  //---
                  points = get_BayesanFilterPoints(points, sig_time, sig_timeFrame, sig_currency, sig_last_u, sig_hits, sig_type, sig_desc, sig_direction, sig_strength);
                  //---
                  double entry_points = ISW_SHORT_MinPoint + ((ISW_SHORT_MaxPoint - ISW_SHORT_MinPoint) / 2);
                  if( points >= entry_points)
                  {
                     double realSL = NormalizeDouble(MathMin(nearest_resistance,nearest_daily_resistance), MarketInfo(sig_currency,MODE_DIGITS));
                     double realPT = NormalizeDouble(MathMax(farest_support,farest_daily_support), MarketInfo(sig_currency,MODE_DIGITS));

                     if(volatility)
                        sqOpenOrder(sig_currency, OP_SELL, getOrderSize(sig_currency, 2000, OP_SELL ), getOrderPrice(sig_currency, 2000), realSL, realPT, "ISW_Short("+sqGetTimeFrameAsStr(sig_timeFrame)+")", 2000, "GoShort1");

                     int PointProfit = (OrderOpenPrice() - OrderClosePrice()) * power;
                     double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

                     string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                     StringReplace(timeTouched,".","-");

                     //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
                     bool tradeAlreadyStored = false;

                     string sql = "SELECT count(*) FROM 'Trades' WHERE Ticket = " + OrderTicket();
                     handle = sqlite_query(db, sql, cols);
                     if (sqlite_next_row(handle) > 0) {
                        int numTrades = StrToInteger(sqlite_get_col(handle, 0));
                        tradeAlreadyStored = (numTrades > 0);
                     }
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     if( !tradeAlreadyStored )
                     {
                            sql = "INSERT INTO 'Trades' ('Ticket','TimeFrame','Pair','Closed','SignalType','SignalPoints','Direction','Strength','Size','TimeOpened','TimeTouched','CountTouched', 'RecentPoints', 'RecentMoney', 'High','Low','HighMoney','LowMoney','Hedge1','Hedge2','Hedge3','Hedge4') VALUES (";
                            sql+= "'" + OrderTicket() + "',"+sig_timeFrame+",'" + OrderSymbol() + "','0','" + sig_type + "','" + points + "','" + DIR_SHORT + "','" + sig_strength + "',";
                            sql+= "'" + OrderLots() + "','" + TimeGMT() + "','" + timeTouched + "', 0, '"+ PointProfit +"', '"+ MoneyProfit +"', '"+ PointProfit +"',  '"+ PointProfit +"', '" + MoneyProfit + "', '" + MoneyProfit + "',";
                            sql+= "'" + OrderOpenPrice() + "','" + OrderClosePrice() + "','" + OrderStopLoss() + "', '" + OrderTakeProfit() + "' ";
                            sql+= ")";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }

                     //Print("Updating tuple for ", db + " / Signals");
                            sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '-1', ";
                            sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(sig_currency,MODE_ASK)+"', Bid = '"+MarketInfo(sig_currency,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"' ";
                            sql+= "WHERE Currency = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Type = 'ISW' AND Direction = '"+DIR_SHORT+"' AND Strength = '"+STR_STRONG+"'";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }

                  //-- Close opposite directions
                  if( sqLiveOrderExists(sig_currency, 1000) )
                  {
                     RefreshRates();
                     if( sqClosePositionAtMarket(OrderLots()) )
                     {
                        int PointProfit = (OrderClosePrice() - OrderOpenPrice()) * power;
                        double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();
                        handle = sqlite_query(db, "SELECT TimeOpened, High, Low, HighMoney, LowMoney, Hedge1, Hedge2, Hedge3, Hedge4, Hedge5, Hedge6, Hedge7, Hedge8 FROM Trades WHERE Ticket=" + OrderTicket() + " LIMIT 1", cols);
                        if (sqlite_next_row(handle) > 0) {
                           int ticket = OrderTicket();
                           datetime dataTimeOpened = StrToTime(sqlite_get_col(handle, 0));
                           int dataHighPoints = StrToDouble(sqlite_get_col(handle, 1));
                           int dataLowPoints = StrToDouble(sqlite_get_col(handle, 2));
                           double dataHighMoney = StrToDouble(sqlite_get_col(handle, 3));
                           double dataLowMoney = StrToDouble(sqlite_get_col(handle, 4));

                           string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
                           StringReplace(timeTouched,".","-");

                           string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', Closed = -2, CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit +" " ;
                                  sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                                  sql+= " WHERE Ticket=" + ticket + "";
                           if (handle > 0) sqlite_free_query(handle);
                           handle = 0;
                           do_exec(db, sql);
                        }
                     }
                  }
               }
            }

            //Print(points);
         }

      }

      if (handle > 0) sqlite_free_query(handle);
      handle = 0;

   }

   delete l;
   delete h;
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

   if (handleSig > 0) sqlite_free_query(handleSig);
   handleSig = 0;
}

//---
   manageOrders(sqBarIsOpen);
//---

}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   PopulateDBStatistics();
}

void PopulateDBStatistics()
{
//--- Correlation and Daily Percent change update
   int currentSymbolsTotal=SymbolsTotal(true);
//--- If we add or remove a symbol to the market watch
   if(symbolsTotal!=currentSymbolsTotal)
   {
      //--- resize arrays
      ArrayResize(marketWatchSymbolsList,currentSymbolsTotal);
      ArrayResize(percentChange,currentSymbolsTotal);
      //--- update arrays of symbol's name
      for(int i=0;i<currentSymbolsTotal;i++) marketWatchSymbolsList[i]=SymbolName(i,true);
      //---
      symbolsTotal=currentSymbolsTotal;
   }

//--- TimeFrames to take into account
   int TimeFrameArray[] = {PERIOD_H1/*, PERIOD_H4, PERIOD_D1*/};
   int t_length = ArrayRange(TimeFrameArray,0);
//--- Main Symbol loop
  if(correlationCounter == 0)
  {
   for(int i=0;i<symbolsTotal;i++)
   {
      //---
      Verbose("Populate DB:",marketWatchSymbolsList[i]);
      //--- Calculates the percent change of each symbol
      if(CopyRates(marketWatchSymbolsList[i],PERIOD_D1,0,2,DailyBar)==2)
      {
         percentChange[i]=((DailyBar[0].close/DailyBar[1].close)-1)*100;
      } else {
         continue;
      }

      //--- Cross Correlation Index and Individual Strength and Weakness on each TIMEFRAME
      for(int t=0;t<t_length;t++)
      {
         int TimeFrame =  TimeFrameArray[t];

      //--- Correlation and Daily Percent Change
      for(int ii=0;ii<symbolsTotal;ii++)
      {
        if(marketWatchSymbolsList[i] != marketWatchSymbolsList[ii])
        {
         double AvgCorrelation  = do_correlation(marketWatchSymbolsList[ii], marketWatchSymbolsList[i], TimeFrame);

         //---
         Verbose("Populate DB:","Correlation"," ",marketWatchSymbolsList[i]," ",marketWatchSymbolsList[ii]," -> ",AvgCorrelation);
         //---

         //--- Insert into DB
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         //-- 'HeatMap' --> 'Time', 'TimeFrame', 'Pair1', 'Pair2', 'AvgCorrelation', 'DailyPercentChange'
         handle = sqlite_query(db, "SELECT TimeFrame,Pair1 FROM 'HeatMap' WHERE Pair1 = '"+marketWatchSymbolsList[ii]+"' AND Pair2 = '"+marketWatchSymbolsList[i]+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
         if (sqlite_next_row(handle) > 0)
         {
            Verbose("Updating tuple for ", db + " / HeatMap");
            string sql = "UPDATE 'HeatMap' SET Time = '"+TimeGMT()+"', AvgCorrelation = '"+DoubleToString(AvgCorrelation,2)+"', DailyPercentChange = '"+DoubleToString(percentChange[i],2)+"' ";
                   sql+= "WHERE Pair1 = '"+marketWatchSymbolsList[ii]+"' AND Pair2 = '"+marketWatchSymbolsList[i]+"' AND TimeFrame = "+TimeFrame;
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }
         else
         {
            Verbose("Inserting tuple for ", db + " / HeatMap");
            string sql = "INSERT INTO 'HeatMap'('Time','TimeFrame','Pair1','Pair2','AvgCorrelation','DailyPercentChange') ";
                   sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+marketWatchSymbolsList[ii]+"','"+marketWatchSymbolsList[i]+"','"+DoubleToString(AvgCorrelation,2)+"','"+DoubleToString(percentChange[i],2)+"')";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }
        }
       }

      //--- Individual Strength and Weakness
         MqlRates RatesBar[];
         ArraySetAsSeries(RatesBar,true);
         if(CopyRates(marketWatchSymbolsList[i],TimeFrame,0,2,RatesBar)==2)
         {
            //---
            Verbose("Populate DB:","Individual Strength and Weakness");
            //---
            double high     = RatesBar[0].high;
            double point    = MarketInfo(marketWatchSymbolsList[i],MODE_POINT);
            int    digits   = MarketInfo(marketWatchSymbolsList[i],MODE_DIGITS);
            double ask      = MarketInfo(marketWatchSymbolsList[i],MODE_ASK);
            double bid      = MarketInfo(marketWatchSymbolsList[i],MODE_BID);
            double low      = RatesBar[0].low;
            int    power    = MathPow(10,digits-1);
            double pipRange = (high-low)*power;
            double bidRatio = (pipRange > 0 ? ((bid-low)/pipRange*power)*100 : 0);
                   pipRange = (pipRange != 0 ? pipRange : 0.001);

            double relStr1  = do_strength_lookup(bidRatio);
            double relStr2  = 9-relStr1;

            //-- 'CurrencyData' --> 'Time', 'TimeFrame', 'Pair', 'High', 'Ask', 'Bid', 'Low', 'PIPRange', 'BidRatio', 'RelStr1', 'RelStr2'
            handle = sqlite_query(db, "SELECT TimeFrame,Pair FROM 'CurrencyData' WHERE Pair = '"+marketWatchSymbolsList[i]+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
            if (sqlite_next_row(handle) > 0)
            {
               //Print("Updating tuple for ", db + " / CurrencyData");
               string sql = "UPDATE 'CurrencyData' SET Time = '"+TimeGMT()+"', High = '"+DoubleToString(high,digits)+"', Ask = '"+DoubleToString(ask,digits)+"', ";
                      sql+= "Bid = '"+DoubleToString(bid,digits)+"', Low = '"+DoubleToString(low,digits)+"', PIPRange = '"+DoubleToString(pipRange,digits)+"', ";
                      sql+= "BidRatio = '"+DoubleToString(bidRatio,digits)+"', RelStr1 = '"+DoubleToString(relStr1,digits)+"', RelStr2 = '"+DoubleToString(relStr2,digits)+"' ";
                      sql+= "WHERE Pair = '"+marketWatchSymbolsList[i]+"' AND TimeFrame = "+TimeFrame;
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;
               do_exec(db, sql);
            }
            else
            {
               //Print("Inserting tuple for ", db + " / CurrencyData");
               string sql = "INSERT INTO 'CurrencyData'('Time','TimeFrame','Pair','High','Ask','Bid','Low','PIPRange','BidRatio','RelStr1','RelStr2') ";
                      sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+marketWatchSymbolsList[i]+"','"+DoubleToString(high,digits)+"',";
                      sql+= "'"+DoubleToString(ask,digits)+"','"+DoubleToString(bid,digits)+"','"+DoubleToString(low,digits)+"',";
                      sql+= "'"+DoubleToString(pipRange,digits)+"','"+DoubleToString(bidRatio,digits)+"','"+DoubleToString(relStr1,digits)+"','"+DoubleToString(relStr2,digits)+"')";
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;
               do_exec(db, sql);
            }
         }

      }

   }
  }

   //-- Compute and populate the Total Strength matrix
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

   //--- TimeFrames Loop
   for(int t=0;t<t_length;t++)
   {
      int TimeFrame =  TimeFrameArray[t];
      Hash *h  = new Hash();
      Hash *h1 = new Hash();

      handle = sqlite_query(db, "SELECT Pair,RelStr1,RelStr2 FROM 'CurrencyData' WHERE TimeFrame = "+TimeFrame+" ORDER BY id DESC", cols);
      while(sqlite_next_row(handle) > 0)
      {
         string pair     = sqlite_get_col(handle, 0);
         double relStr1  = StringToDouble(sqlite_get_col(handle, 1));
         double relStr2  = StringToDouble(sqlite_get_col(handle, 2));

         string curr1    = StringSubstr(pair,0,3);
         string curr2    = StringSubstr(pair,3,5);

         double hRelStr1 = h.hGetDouble(curr1);
         double hRelStr2 = h.hGetDouble(curr2);

         if(hRelStr1 == NULL || hRelStr1 == 0)
         {
            h.hPutDouble(curr1,relStr1);
            h1.hPutInt(curr1,1);
         }
         else
         {
            //h.hDel(curr1);
            h.hPutDouble(curr1,(relStr1+hRelStr1));
            hRelStr1 = h.hGetDouble(curr1);

            int inc = h1.hGetInt(curr1);
            h1.hPutInt(curr1,inc+1);
         }

         if(hRelStr2 == NULL || hRelStr2 == 0)
         {
            h.hPutDouble(curr2,relStr2);
            h1.hPutInt(curr2,1);
         }
         else
         {
            //h.hDel(curr2);
            h.hPutDouble(curr2,(relStr2+hRelStr2));
            hRelStr2 = h.hGetDouble(curr2);

            int inc = h1.hGetInt(curr2);
            h1.hPutInt(curr2,inc+1);
         }

      }
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;

      HashLoop *l ;
      for( l = new HashLoop(h) ; l.hasNext() ; l.next()) {
        string key = l.key();
        int inc = h1.hGetInt(key);
            inc = (inc != 0 ? inc : 1);
        double j = round((l.valDouble()/inc));
        h.hPutDouble(key, j);

        //Print(key," = ",j);
        //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
        handle = sqlite_query(db, "SELECT TimeFrame,Currency FROM 'TotalStrength' WHERE Currency = '"+key+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
        if (sqlite_next_row(handle) > 0)
         {
            //Print("Updating tuple for ", db + " / TotalStrength");
            string sql = "UPDATE 'TotalStrength' SET Time = '"+TimeGMT()+"', Strength = '"+j+"' ";
                   sql+= "WHERE Currency = '"+key+"' AND TimeFrame = "+TimeFrame;
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }
        else
         {
            //Print("Inserting tuple for ", db + " / TotalStrength");
            string sql = "INSERT INTO 'TotalStrength'('Time','TimeFrame','Currency','Strength') ";
                   sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+key+"','"+j+"')";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }
      }
      delete l;
      delete h;
      delete h1;
   }

//--- Store Indicator Signals
   //---
   Verbose("Populate DB:","Store Indicator Signals");
   //---
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

   int AvgLength = MathMin(ResultingBars, 500);
   if(ResultingBars == 0)
      AvgLength = 500;

//--- Main Symbol loop
   for(int i=0;i<symbolsTotal;i++)
   {
      string Pair = marketWatchSymbolsList[i];
      get_pivots(Pair, PERIOD_H4);

      //--- Store Symbol Pivots
      //-- 'Pivots' --> 'Time', 'Currency', 'FhrR1', 'FhrR2', 'FhrR3', 'FhrS1', 'FhrS2', 'FhrS3', 'FhrP', 'DR1', 'DR2', 'DR3', 'DS1', 'DS2', 'DS3', 'DP'
      handle = sqlite_query(db, "SELECT * FROM 'Pivots' WHERE Currency = '"+Pair+"' ORDER BY id DESC LIMIT 1", cols);
      if (sqlite_next_row(handle) > 0)
      {
         //Print("Updating tuple for ", db + " / Pivots");
         string sql = "UPDATE 'Pivots' SET Time = '"+TimeGMT()+"', ";
                sql+= "FhrR1 = '"+Fhr_R1+"', FhrR2 = '"+Fhr_R2+"', FhrR3 = '"+Fhr_R3+"', FhrS1 = '"+Fhr_S1+"', FhrS2 = '"+Fhr_S2+"', FhrS3 = '"+Fhr_S3+"', FhrP = '"+Fhr_P+"', DR1 = '"+D_R1+"', DR2 = '"+D_R2+"', DR3 = '"+D_R3+"', DS1 = '"+D_S1+"', DS2 = '"+D_S2+"', DS3 = '"+D_S3+"', DP = '"+D_P+"' ";
                sql+= "WHERE Currency = '"+Pair+"'";
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;
         do_exec(db, sql);
      }
      else
      {
         //Print("Inserting tuple for ", db + " / Pivots");
         string sql = "INSERT INTO 'Pivots'('Time', 'Currency', 'FhrR1', 'FhrR2', 'FhrR3', 'FhrS1', 'FhrS2', 'FhrS3', 'FhrP', 'DR1', 'DR2', 'DR3', 'DS1', 'DS2', 'DS3', 'DP') ";
                sql+= "VALUES('"+TimeGMT()+"','"+Pair+"','"+Fhr_R1+"','"+Fhr_R2+"','"+Fhr_R3+"','"+Fhr_S1+"','"+Fhr_S2+"','"+Fhr_S3+"','"+Fhr_P+"','"+D_R1+"','"+D_R2+"','"+D_R3+"','"+D_S1+"','"+D_S2+"','"+D_S3+"','"+D_P+"')";
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;
         do_exec(db, sql);
      }

      //--- TimeFrames Loop
      for(int t=0;t<t_length;t++)
      {
         int TimeFrame =  TimeFrameArray[t];

         MqlRates RatesBar[];
         ArraySetAsSeries(RatesBar,true);
         if(CopyRates(Pair,TimeFrame,0,AvgLength,RatesBar)==AvgLength)
         {
         //--- Signal Type 'BB'

           HideTestIndicators(true);
            double bb_squeeze_green_0  = bb_squeeze_dark(Pair, TimeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
                     //iCustom(Pair, TimeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
            double bb_squeeze_green_1  = bb_squeeze_dark(Pair, TimeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);
                     //iCustom(Pair, TimeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);

            double upTrendStop         = doda_bands2(Pair, TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 0, 0);
            double downTrendStop       = doda_bands2(Pair, TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 1, 0);
            double upTrendSignal       = doda_bands2(Pair, TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 2, 0);
            double downTrendSignal     = doda_bands2(Pair, TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 3, 0);

            //--_T_S_R__Signal_Line
            double signalLineValue0_0  = i_TSRLine(Pair, TimeFrame, "_T_S_R__Signal_Line", 15, 3, 0, 0, 0); // Blue
            double signalLineValue1_0  = i_TSRLine(Pair, TimeFrame, "_T_S_R__Signal_Line", 15, 3, 0, 1, 0); // Red
            double signalLineValue0_1  = i_TSRLine(Pair, TimeFrame, "_T_S_R__Signal_Line", 15, 3, 0, 0, 1); // Blue
            double signalLineValue1_1  = i_TSRLine(Pair, TimeFrame, "_T_S_R__Signal_Line", 15, 3, 0, 1, 1); // Red

            //--HAMA
            double hamaValue0_0        = i_hama(Pair, TimeFrame, "HAMA_", 0, 0);
            double hamaValue1_0        = i_hama(Pair, TimeFrame, "HAMA_", 1, 0);
            double hamaValue2_0        = i_hama(Pair, TimeFrame, "HAMA_", 2, 0);
            double hamaValue3_0        = i_hama(Pair, TimeFrame, "HAMA_", 3, 0);
            double hamaValue0_1        = i_hama(Pair, TimeFrame, "HAMA_", 0, 1);
            double hamaValue1_1        = i_hama(Pair, TimeFrame, "HAMA_", 1, 1);
            double hamaValue2_1        = i_hama(Pair, TimeFrame, "HAMA_", 2, 1);
            double hamaValue3_1        = i_hama(Pair, TimeFrame, "HAMA_", 3, 1);

            double bbSMA_0             = iBands(Pair, TimeFrame, 20,2,0, PRICE_CLOSE, MODE_MAIN, 0);
            double bbSMA_1             = iBands(Pair, TimeFrame, 20,2,0, PRICE_CLOSE, MODE_MAIN, 1);
           HideTestIndicators(false);

            if(bb_squeeze_green_0 != EMPTY_VALUE && bb_squeeze_green_0 == 0 && bb_squeeze_green_1 != EMPTY_VALUE && bb_squeeze_green_1 == 0)
            {
               //--- Signal Line Reinforcement
               bool strongSignalLineLong  = false;
               bool strongSignalLineShort = false;

                  if( signalLineValue0_0 != EMPTY_VALUE && signalLineValue0_1 != EMPTY_VALUE && signalLineValue0_0 > bbSMA_0 && signalLineValue0_1 < bbSMA_1 )
                  {
                     if( upTrendStop > 0 && (hamaValue0_0 == hamaValue2_0 && hamaValue0_0 < hamaValue1_0) && (hamaValue0_1 == hamaValue2_1 && hamaValue0_1 < hamaValue1_1) )
                     {
                        strongSignalLineLong = true;
                     }
                  }

                  if( signalLineValue1_0 != EMPTY_VALUE && signalLineValue1_1 != EMPTY_VALUE && signalLineValue1_0 < bbSMA_0 && signalLineValue1_1 > bbSMA_1 )
                  {
                     if( downTrendStop > 0 && (hamaValue1_0 == hamaValue3_0 && hamaValue0_0 > hamaValue1_0) && (hamaValue1_1 == hamaValue3_1 && hamaValue0_1 > hamaValue1_1) )
                     {
                        strongSignalLineShort = true;
                     }
                  }
               //---

               //--- BB Signal STRONG
               if(upTrendSignal > 0 || downTrendSignal > 0 || strongSignalLineLong == true || strongSignalLineShort == true )
               {
                 bool updated = false;
                 int Direction = (upTrendStop > 0 ? DIR_LONG : DIR_SHORT);

                 //-- 'Signals' --> 'Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5', 'Value6', 'Value7', 'Value8', 'Value9'
                 handle = sqlite_query(db, "SELECT * FROM 'Signals' WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'BB' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"' ORDER BY id DESC LIMIT 1", cols);
                 if (sqlite_next_row(handle) > 0)
                  {
                     datetime sig_time   =       StrToTime(sqlite_get_col(handle, 1));
                     int sig_timeFrame   = StringToInteger(sqlite_get_col(handle, 2));
                     string sig_currency =                 sqlite_get_col(handle, 3);
                     datetime sig_last_u =       StrToTime(sqlite_get_col(handle, 4));
                     int sig_hits        = StringToInteger(sqlite_get_col(handle, 5));
                     string sig_type     =                 sqlite_get_col(handle, 6);
                     string sig_desc     =                 sqlite_get_col(handle, 7);
                     int sig_direction   = StringToInteger(sqlite_get_col(handle, 8));
                     int sig_strength    = StringToInteger(sqlite_get_col(handle, 9));
                     double sig_high     =  StringToDouble(sqlite_get_col(handle,10));
                     double sig_ask      = StringToDouble(sqlite_get_col(handle, 11));
                     double sig_bid      = StringToDouble(sqlite_get_col(handle, 12));
                     double sig_low      = StringToDouble(sqlite_get_col(handle, 13));
                     double sig_open     = StringToDouble(sqlite_get_col(handle, 14));
                     double sig_volume   = StringToDouble(sqlite_get_col(handle, 15));
                     double sig_value0   = StringToDouble(sqlite_get_col(handle, 16));
                     double sig_value1   = StringToDouble(sqlite_get_col(handle, 17));
                     double sig_value2   = StringToDouble(sqlite_get_col(handle, 18));
                     double sig_value3   = StringToDouble(sqlite_get_col(handle, 19));
                     double sig_value4   = StringToDouble(sqlite_get_col(handle, 20));
                     double sig_value5   = StringToDouble(sqlite_get_col(handle, 21));
                     double sig_value6   = StringToDouble(sqlite_get_col(handle, 22));
                     double sig_value7   = StringToDouble(sqlite_get_col(handle, 23));
                     double sig_value8   = StringToDouble(sqlite_get_col(handle, 24));
                     double sig_value9   = StringToDouble(sqlite_get_col(handle, 25));

                     int time_difference = (sig_last_u - sig_time)/60;

                     if(time_difference > 2*sig_timeFrame)
                     {
                        //Print("Delete tuple from ", db + " / Signals");
                        string sql = "DELETE FROM 'Signals' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'BB' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }
                     else
                     {
                        //Print("Updating tuple for ", db + " / Signals");
                        string sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '"+(sig_hits+1)+"', ";
                               sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(Pair,MODE_ASK)+"', Bid = '"+MarketInfo(Pair,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"', ";
                               sql+= "Value0 = '"+bb_squeeze_green_0+"', Value1 = '"+bb_squeeze_green_1+"', Value2 = '"+upTrendStop+"', Value3 = '"+downTrendStop+"', Value4 = '"+upTrendSignal+"', Value5 = '"+downTrendSignal+"' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'BB' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                        updated = true;
                     }
                  }
                 if (!updated)
                  {
                     //Print("Inserting tuple for ", db + " / Signals");
                     string sql = "INSERT INTO 'Signals'('Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5') ";
                            sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+Pair+"','"+TimeGMT()+"','1','BB','BBands Signal','"+Direction+"','"+STR_STRONG+"',";
                            sql+= "'"+RatesBar[0].high+"','"+MarketInfo(Pair,MODE_ASK)+"','"+MarketInfo(Pair,MODE_BID)+"','"+RatesBar[0].low+"','"+RatesBar[0].open+"','"+RatesBar[0].real_volume+"',";
                            sql+= "'"+bb_squeeze_green_0+"','"+bb_squeeze_green_1+"','"+upTrendStop+"','"+downTrendStop+"','"+upTrendSignal+"','"+downTrendSignal+"')";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }
               }
               //--- BB Signal Weak
               else if( AllowWeakSignals && ( (upTrendStop > 0 && strongSignalLineLong == true) || (downTrendStop > 0 && strongSignalLineShort == true) ) )
               {
                 bool updated = false;
                 int Direction = (upTrendStop > 0 ? DIR_LONG : DIR_SHORT);

                 //-- 'Signals' --> 'Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5', 'Value6', 'Value7', 'Value8', 'Value9'
                 handle = sqlite_query(db, "SELECT * FROM 'Signals' WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'BB' AND Direction = '"+Direction+"' AND Strength = '"+STR_WEAK+"' ORDER BY id DESC LIMIT 1", cols);
                 if (sqlite_next_row(handle) > 0)
                  {
                     datetime sig_time   =       StrToTime(sqlite_get_col(handle, 1));
                     int sig_timeFrame   = StringToInteger(sqlite_get_col(handle, 2));
                     string sig_currency =                 sqlite_get_col(handle, 3);
                     datetime sig_last_u =       StrToTime(sqlite_get_col(handle, 4));
                     int sig_hits        = StringToInteger(sqlite_get_col(handle, 5));
                     string sig_type     =                 sqlite_get_col(handle, 6);
                     string sig_desc     =                 sqlite_get_col(handle, 7);
                     int sig_direction   = StringToInteger(sqlite_get_col(handle, 8));
                     int sig_strength    = StringToInteger(sqlite_get_col(handle, 9));
                     double sig_high     =  StringToDouble(sqlite_get_col(handle,10));
                     double sig_ask      = StringToDouble(sqlite_get_col(handle, 11));
                     double sig_bid      = StringToDouble(sqlite_get_col(handle, 12));
                     double sig_low      = StringToDouble(sqlite_get_col(handle, 13));
                     double sig_open     = StringToDouble(sqlite_get_col(handle, 14));
                     double sig_volume   = StringToDouble(sqlite_get_col(handle, 15));
                     double sig_value0   = StringToDouble(sqlite_get_col(handle, 16));
                     double sig_value1   = StringToDouble(sqlite_get_col(handle, 17));
                     double sig_value2   = StringToDouble(sqlite_get_col(handle, 18));
                     double sig_value3   = StringToDouble(sqlite_get_col(handle, 19));
                     double sig_value4   = StringToDouble(sqlite_get_col(handle, 20));
                     double sig_value5   = StringToDouble(sqlite_get_col(handle, 21));
                     double sig_value6   = StringToDouble(sqlite_get_col(handle, 22));
                     double sig_value7   = StringToDouble(sqlite_get_col(handle, 23));
                     double sig_value8   = StringToDouble(sqlite_get_col(handle, 24));
                     double sig_value9   = StringToDouble(sqlite_get_col(handle, 25));

                     int time_difference = (sig_last_u - sig_time)/60;

                     if(time_difference > 2*sig_timeFrame)
                     {
                        //Print("Delete tuple from ", db + " / Signals");
                        string sql = "DELETE FROM 'Signals' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'BB' AND Direction = '"+Direction+"' AND Strength = '"+STR_WEAK+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }
                     else
                     {
                        //Print("Updating tuple for ", db + " / Signals");
                        string sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '"+(sig_hits+1)+"', ";
                               sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(Pair,MODE_ASK)+"', Bid = '"+MarketInfo(Pair,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"', ";
                               sql+= "Value0 = '"+bb_squeeze_green_0+"', Value1 = '"+bb_squeeze_green_1+"', Value2 = '"+upTrendStop+"', Value3 = '"+downTrendStop+"', Value4 = '"+upTrendSignal+"', Value5 = '"+downTrendSignal+"' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'BB' AND Direction = '"+Direction+"' AND Strength = '"+STR_WEAK+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                        updated = true;
                     }
                  }
                 if (!updated)
                  {
                     //Print("Inserting tuple for ", db + " / Signals");
                     string sql = "INSERT INTO 'Signals'('Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5') ";
                            sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+Pair+"','"+TimeGMT()+"','1','BB','BBands Signal','"+Direction+"','"+STR_WEAK+"',";
                            sql+= "'"+RatesBar[0].high+"','"+MarketInfo(Pair,MODE_ASK)+"','"+MarketInfo(Pair,MODE_BID)+"','"+RatesBar[0].low+"','"+RatesBar[0].open+"','"+RatesBar[0].real_volume+"',";
                            sql+= "'"+bb_squeeze_green_0+"','"+bb_squeeze_green_1+"','"+upTrendStop+"','"+downTrendStop+"','"+upTrendSignal+"','"+downTrendSignal+"')";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }
               }

            }

         //--- Signal Type 'ISW'
            //-- Individual Strength and Weakness
            string curr1    = StringSubstr(Pair,0,3);
            string curr2    = StringSubstr(Pair,3,5);

            double strength1 = 0;
            double strength2 = 0;

            //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
            handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr1+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               strength1  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr2+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
            while(sqlite_next_row(handle) > 0)
            {
               strength2  = StringToDouble(sqlite_get_col(handle, 0));
            }
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            int Direction = 0;
            bool updated = false;
            if(strength1 > 7 && strength2 < 3 )
            {
               Direction = DIR_LONG;
               //ISW_LONG_StrengthStrong;

               //-- HeatMap Group Confirmation LONG
               /**
                * curr1
                * 1. SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE 'curr1%'
                *    must be all > HeatMapDailyPercRateTholdMin
                *
                * 2. SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '%curr1'
                *    must be all < -HeatMapDailyPercRateTholdMin
                *
                * 3. curr2 the opposite
                *
                */
                //-- curr1 Groups Confirmation
                int curr1Cnt  = 0;
                int curr1Conf = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '"+curr1+"%'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr1Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange >= HeatMapDailyPercRateTholdMin ) curr1Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '%"+curr1+PairSuffix+"'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr1Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange <= -HeatMapDailyPercRateTholdMin ) curr1Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;

                //-- curr2 Groups Confirmation
                int curr2Cnt  = 0;
                int curr2Conf = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '"+curr2+"%'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr2Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange <= -HeatMapDailyPercRateTholdMin ) curr2Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '%"+curr2+PairSuffix+"'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr2Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange >= HeatMapDailyPercRateTholdMin ) curr2Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;

                //-- ISW Signal
                if( curr1Cnt == curr1Conf || curr2Cnt == curr2Conf )
                {
                 //-- 'Signals' --> 'Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5', 'Value6', 'Value7', 'Value8', 'Value9'
                 handle = sqlite_query(db, "SELECT * FROM 'Signals' WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'ISW' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"' ORDER BY id DESC LIMIT 1", cols);
                 if (sqlite_next_row(handle) > 0)
                  {
                     datetime sig_time   =       StrToTime(sqlite_get_col(handle, 1));
                     int sig_timeFrame   = StringToInteger(sqlite_get_col(handle, 2));
                     string sig_currency =                 sqlite_get_col(handle, 3);
                     datetime sig_last_u =       StrToTime(sqlite_get_col(handle, 4));
                     int sig_hits        = StringToInteger(sqlite_get_col(handle, 5));
                     string sig_type     =                 sqlite_get_col(handle, 6);
                     string sig_desc     =                 sqlite_get_col(handle, 7);
                     int sig_direction   = StringToInteger(sqlite_get_col(handle, 8));
                     int sig_strength    = StringToInteger(sqlite_get_col(handle, 9));
                     double sig_high     =  StringToDouble(sqlite_get_col(handle,10));
                     double sig_ask      = StringToDouble(sqlite_get_col(handle, 11));
                     double sig_bid      = StringToDouble(sqlite_get_col(handle, 12));
                     double sig_low      = StringToDouble(sqlite_get_col(handle, 13));
                     double sig_open     = StringToDouble(sqlite_get_col(handle, 14));
                     double sig_volume   = StringToDouble(sqlite_get_col(handle, 15));
                     double sig_value0   = StringToDouble(sqlite_get_col(handle, 16));
                     double sig_value1   = StringToDouble(sqlite_get_col(handle, 17));
                     double sig_value2   = StringToDouble(sqlite_get_col(handle, 18));
                     double sig_value3   = StringToDouble(sqlite_get_col(handle, 19));
                     double sig_value4   = StringToDouble(sqlite_get_col(handle, 20));
                     double sig_value5   = StringToDouble(sqlite_get_col(handle, 21));
                     double sig_value6   = StringToDouble(sqlite_get_col(handle, 22));
                     double sig_value7   = StringToDouble(sqlite_get_col(handle, 23));
                     double sig_value8   = StringToDouble(sqlite_get_col(handle, 24));
                     double sig_value9   = StringToDouble(sqlite_get_col(handle, 25));

                     int time_difference = (sig_last_u - sig_time)/60;

                     if(time_difference > 2*sig_timeFrame)
                     {
                        //Print("Delete tuple from ", db + " / Signals");
                        string sql = "DELETE FROM 'Signals' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'ISW' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }
                     else
                     {
                        //Print("Updating tuple for ", db + " / Signals");
                        string sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '"+(sig_hits+1)+"', ";
                               sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(Pair,MODE_ASK)+"', Bid = '"+MarketInfo(Pair,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"', ";
                               sql+= "Value0 = '"+strength1+"', Value1 = '"+strength2+"', Value2 = '"+upTrendStop+"', Value3 = '"+downTrendStop+"', Value4 = '"+upTrendSignal+"', Value5 = '"+downTrendSignal+"' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'ISW' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                        updated = true;
                     }
                  }
                 if (!updated)
                  {
                     //Print("Inserting tuple for ", db + " / Signals");
                     string sql = "INSERT INTO 'Signals'('Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5') ";
                            sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+Pair+"','"+TimeGMT()+"','1','ISW','Individual Strength/Weakness Signal','"+Direction+"','"+STR_STRONG+"',";
                            sql+= "'"+RatesBar[0].high+"','"+MarketInfo(Pair,MODE_ASK)+"','"+MarketInfo(Pair,MODE_BID)+"','"+RatesBar[0].low+"','"+RatesBar[0].open+"','"+RatesBar[0].real_volume+"',";
                            sql+= "'"+strength1+"','"+strength2+"','"+upTrendStop+"','"+downTrendStop+"','"+upTrendSignal+"','"+downTrendSignal+"')";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }
               }
            }

            if(strength2 > 7 && strength1 < 3 )
            {
               Direction = DIR_SHORT;
               //ISW_SHORT_StrengthStrong;

               //-- HeatMap Group Confirmation SHORT
               /**
                * curr2
                * 1. SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE 'curr1%'
                *    must be all < -HeatMapDailyPercRateTholdMin
                *
                * 2. SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '%curr1'
                *    must be all > HeatMapDailyPercRateTholdMin
                *
                * 3. curr2 the opposite
                *
                */
                //-- curr1 Groups Confirmation
                int curr1Cnt  = 0;
                int curr1Conf = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '"+curr1+"%'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr1Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange <= -HeatMapDailyPercRateTholdMin ) curr1Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '%"+curr1+PairSuffix+"'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr1Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange >= HeatMapDailyPercRateTholdMin ) curr1Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;

                //-- curr2 Groups Confirmation
                int curr2Cnt  = 0;
                int curr2Conf = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '"+curr2+"%'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr2Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange >= HeatMapDailyPercRateTholdMin ) curr2Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;
                handle = sqlite_query(db, "SELECT distinct(Pair2),DailyPercentChange FROM 'HeatMap' WHERE Pair2 LIKE '%"+curr2+PairSuffix+"'", cols);
                while( sqlite_next_row(handle) > 0 )
                {
                     curr2Cnt += 1;
                     double dailyPercentChange = StringToDouble(sqlite_get_col(handle,1));
                     if( dailyPercentChange <= -HeatMapDailyPercRateTholdMin ) curr2Conf +=1;
                }
                if (handle > 0) sqlite_free_query(handle);
                handle = 0;

                //-- ISW Signal
                if( curr1Cnt == curr1Conf || curr2Cnt == curr2Conf )
                {
                 //-- 'Signals' --> 'Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5', 'Value6', 'Value7', 'Value8', 'Value9'
                 handle = sqlite_query(db, "SELECT * FROM 'Signals' WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'ISW' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"' ORDER BY id DESC LIMIT 1", cols);
                 if (sqlite_next_row(handle) > 0)
                  {
                     datetime sig_time   =       StrToTime(sqlite_get_col(handle, 1));
                     int sig_timeFrame   = StringToInteger(sqlite_get_col(handle, 2));
                     string sig_currency =                 sqlite_get_col(handle, 3);
                     datetime sig_last_u =       StrToTime(sqlite_get_col(handle, 4));
                     int sig_hits        = StringToInteger(sqlite_get_col(handle, 5));
                     string sig_type     =                 sqlite_get_col(handle, 6);
                     string sig_desc     =                 sqlite_get_col(handle, 7);
                     int sig_direction   = StringToInteger(sqlite_get_col(handle, 8));
                     int sig_strength    = StringToInteger(sqlite_get_col(handle, 9));
                     double sig_high     =  StringToDouble(sqlite_get_col(handle,10));
                     double sig_ask      = StringToDouble(sqlite_get_col(handle, 11));
                     double sig_bid      = StringToDouble(sqlite_get_col(handle, 12));
                     double sig_low      = StringToDouble(sqlite_get_col(handle, 13));
                     double sig_open     = StringToDouble(sqlite_get_col(handle, 14));
                     double sig_volume   = StringToDouble(sqlite_get_col(handle, 15));
                     double sig_value0   = StringToDouble(sqlite_get_col(handle, 16));
                     double sig_value1   = StringToDouble(sqlite_get_col(handle, 17));
                     double sig_value2   = StringToDouble(sqlite_get_col(handle, 18));
                     double sig_value3   = StringToDouble(sqlite_get_col(handle, 19));
                     double sig_value4   = StringToDouble(sqlite_get_col(handle, 20));
                     double sig_value5   = StringToDouble(sqlite_get_col(handle, 21));
                     double sig_value6   = StringToDouble(sqlite_get_col(handle, 22));
                     double sig_value7   = StringToDouble(sqlite_get_col(handle, 23));
                     double sig_value8   = StringToDouble(sqlite_get_col(handle, 24));
                     double sig_value9   = StringToDouble(sqlite_get_col(handle, 25));

                     int time_difference = (sig_last_u - sig_time)/60;

                     if(time_difference > 2*sig_timeFrame)
                     {
                        //Print("Delete tuple from ", db + " / Signals");
                        string sql = "DELETE FROM 'Signals' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'ISW' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                     }
                     else
                     {
                        //Print("Updating tuple for ", db + " / Signals");
                        string sql = "UPDATE 'Signals' SET LastUpdate = '"+TimeGMT()+"', Hits = '"+(sig_hits+1)+"', ";
                               sql+= "High = '"+RatesBar[0].high+"', Ask = '"+MarketInfo(Pair,MODE_ASK)+"', Bid = '"+MarketInfo(Pair,MODE_BID)+"', Low = '"+RatesBar[0].low+"', Open = '"+RatesBar[0].open+"', TradeVolume = '"+RatesBar[0].real_volume+"', ";
                               sql+= "Value0 = '"+strength1+"', Value1 = '"+strength2+"', Value2 = '"+upTrendStop+"', Value3 = '"+downTrendStop+"', Value4 = '"+upTrendSignal+"', Value5 = '"+downTrendSignal+"' ";
                               sql+= "WHERE Currency = '"+Pair+"' AND TimeFrame = "+TimeFrame+" AND Type = 'ISW' AND Direction = '"+Direction+"' AND Strength = '"+STR_STRONG+"'";
                        if (handle > 0) sqlite_free_query(handle);
                        handle = 0;
                        do_exec(db, sql);
                        updated = true;
                     }
                  }
                 if (!updated)
                  {
                     //Print("Inserting tuple for ", db + " / Signals");
                     string sql = "INSERT INTO 'Signals'('Time', 'TimeFrame', 'Currency', 'LastUpdate', 'Hits', 'Type', 'Description', 'Direction', 'Strength', 'High', 'Ask', 'Bid', 'Low', 'Open', 'TradeVolume', 'Value0', 'Value1', 'Value2', 'Value3', 'Value4', 'Value5') ";
                            sql+= "VALUES('"+TimeGMT()+"', "+TimeFrame+",'"+Pair+"','"+TimeGMT()+"','1','ISW','Individual Strength/Weakness Signal','"+Direction+"','"+STR_STRONG+"',";
                            sql+= "'"+RatesBar[0].high+"','"+MarketInfo(Pair,MODE_ASK)+"','"+MarketInfo(Pair,MODE_BID)+"','"+RatesBar[0].low+"','"+RatesBar[0].open+"','"+RatesBar[0].real_volume+"',";
                            sql+= "'"+strength1+"','"+strength2+"','"+upTrendStop+"','"+downTrendStop+"','"+upTrendSignal+"','"+downTrendSignal+"')";
                     if (handle > 0) sqlite_free_query(handle);
                     handle = 0;
                     do_exec(db, sql);
                  }
               }
            }
         }
      }
   }

   //--
   db_populated = true;
   //--
   correlationCounter = (correlationCounter >= 10 ? 0 : correlationCounter+1);
   signalCounter      = (signalCounter      >= 10 ? 0 : signalCounter+1);
   //--
}

bool is_a_new_bar()
{
   TimeToStruct(iTime(Symbol(),Period(),0),currentBarTimeStruct);
   currentBarTimeGMT = StrToTime(currentBarTimeStruct.year+"."+currentBarTimeStruct.mon+"."+currentBarTimeStruct.day+" "+(currentBarTimeStruct.hour-timeGMTOffset)+":"+currentBarTimeStruct.min+":"+currentBarTimeStruct.sec);
   Comment("EA Version ("+VERSION+") |" + Symbol() + " --> currentBarTimeGMT:  " + TimeToString(currentBarTimeGMT,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+ " --> lastBarTimeGMT:  " + TimeToString(lastBarTimeGMT,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+"\n");

   if( currentBarTimeGMT != lastBarTimeGMT)
   {
      Comment("EA Version ("+VERSION+") |" + Symbol() + " --> currentBarTimeGMT:  " + TimeToString(currentBarTimeGMT,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+ " --> lastBarTimeGMT:  " + TimeToString(lastBarTimeGMT,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+"\n");
      lastBarTimeGMT = currentBarTimeGMT;

      return(true);
   }

   return(false);
}
//---
int hours_from_session_start(int session_start)
{
   TimeGMT(timeGMTStruct);

   if(timeGMTStruct.hour<session_start)
   {
      return(24+timeGMTStruct.hour-session_start);
   }

   return(timeGMTStruct.hour-session_start);
}
//---
bool is_market_session_open(int session_start, int session_end)
{
   return(hours_from_session_start(session_start)<MathAbs(session_end-session_start));
}
//---

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---

}
//+------------------------------------------------------------------+

//// Functions

//+------------------------------------------------------------------+
//| SQLite DB Check if Table Exists                                  |
//+------------------------------------------------------------------+
bool do_check_table_exists(string db, string table)
{
    int res = sqlite_table_exists(db, table);
    if (res < 0) {
        Print("Check for table existence failed with code " + res);
        return (false);
    }
    return (res > 0);
}

//+------------------------------------------------------------------+
//| SQLite DB Exec Functions                                         |
//+------------------------------------------------------------------+
void do_exec(string db, string exp)
{
    int res = sqlite_exec(db, exp);
    if (res != 0) Print("Expression '" + exp + "' failed with code " + res);
}

//+------------------------------------------------------------------+
//| Individual Strength & Weakness Functions                         |
//+------------------------------------------------------------------+
double do_strength_lookup(double bid_ratio)
{
   int relStrengthValue = -1;

   if(bid_ratio<3)                   relStrengthValue = 0;
   if(bid_ratio>=3 && bid_ratio<10)  relStrengthValue = 1;
   if(bid_ratio>=10 && bid_ratio<25) relStrengthValue = 2;
   if(bid_ratio>=25 && bid_ratio<40) relStrengthValue = 3;
   if(bid_ratio>=40 && bid_ratio<50) relStrengthValue = 4;
   if(bid_ratio>=50 && bid_ratio<60) relStrengthValue = 5;
   if(bid_ratio>=60 && bid_ratio<75) relStrengthValue = 6;
   if(bid_ratio>=75 && bid_ratio<90) relStrengthValue = 7;
   if(bid_ratio>=90 && bid_ratio<97) relStrengthValue = 8;
   if(bid_ratio>=97)                 relStrengthValue = 9;

   return(relStrengthValue);
}

//+------------------------------------------------------------------+
//| Correlation Index Functions                                      |
//+------------------------------------------------------------------+
double do_correlation(string PairX, string PairY, int TimeFrame)
{
   double AvgCorrelation;
   int AvgLength;

   AvgLength = MathMin(ResultingBars, 500);
   if(ResultingBars == 0)
      AvgLength = 500;

   ArrayResize(Correlation, AvgLength);
   //ArrayResize(AverageCorrelation, AvgLength);
   ArrayInitialize(Correlation, 0.0);
   //ArrayInitialize(AverageCorrelation, 0.0);
   ArraySetAsSeries(Correlation, true);

   for(int i = 0; i < AvgLength; i++)
   {
      get_Averages(PairX, PairY, TimeFrame, i, CorrelationRadius);
      if(DispersionX*DispersionY > 0 && MathSqrt(DispersionX*DispersionY) > 0)
      {
         Correlation[i] = CovariationXY/MathSqrt(DispersionX*DispersionY);
      }
      else
      {
         Correlation[i] = 0.0;
      }
   }

   /*
   for(int i = 0; i < AvgLength; i++)
   {
      AverageCorrelation[i] = iMAOnArray(Correlation, 0, MA_Period, 0, MODE_SMA, i);
   }
   */

   AvgCorrelation = iMAOnArray(Correlation, 0, AvgLength, 0, MODE_SMA, 0);
   //---
   Verbose("AvgCorrelation(",PairX,"/",PairY,"/",TimeFrame,")");
   //---
   return(AvgCorrelation);
}

double get_Price(string Pair, int TimeFrame, int shift)
{
   switch(Mode)
   {
      case CLOSE_MODE:
         return(iClose(Pair, TimeFrame, shift));
      case OPENCLOSE_MODE:
         return(iClose(Pair, TimeFrame, shift) - iOpen(Pair, TimeFrame, shift));
      case CLOSE_RELATIVE_MODE:
         return(iClose(Pair, TimeFrame, shift)/iHigh(Pair, TimeFrame, shift));
      default:
         return(0);
   }
}

datetime get_TimeToGMT(datetime time1)
{
   MqlDateTime time1Struct, time1GMTStruct;
   TimeToStruct(iTime(Symbol(),PERIOD_M1,0),time1Struct);
   TimeGMT(time1GMTStruct);
   int timeOffset = (time1Struct.hour-time1GMTStruct.hour);

   TimeToStruct(time1,time1Struct);
   //datetime time1GMT = StrToTime(time1Struct.year+"."+time1Struct.mon+"."+time1Struct.day+" "+(time1Struct.hour-timeGMTOffset)+":"+time1Struct.min+":"+time1Struct.sec);
   time1GMTStruct.year = time1Struct.year;
   time1GMTStruct.mon  = time1Struct.mon;
   time1GMTStruct.day  = time1Struct.day;
   time1GMTStruct.hour = (time1Struct.hour-timeOffset);
   time1GMTStruct.min  = time1Struct.min;
   time1GMTStruct.sec  = time1Struct.sec;
   datetime time1GMT = StructToTime(time1GMTStruct);

   return(time1GMT);
}

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

//-------------------------------
int get_HigherTimeFrame(int sig_timeFrame)
{
   //--
   int time_frame = sig_timeFrame;
   //--
   switch (sig_timeFrame) {
      case 1:
         time_frame = 5;

         break;
      case 5:
         time_frame = 15;

         break;
      case 15:
         time_frame = 30;

         break;
      case 30:
         time_frame = 60;

         break;
      case 60:
         time_frame = 240;

         break;
      case 240:
         time_frame = 1440;

         break;
      case 1440:
         time_frame = 10080;

         break;
      case 10080:
         time_frame = 43200;

         break;
      case 43200:
         time_frame = 43200;

         break;
   }
   //--
   return(time_frame);
}

//-------------------------------
int get_BayesanFilterPoints(int points, datetime sig_time, int sig_timeFrame, string sig_currency, datetime sig_last_u, int sig_hits, string sig_type, string sig_desc, int sig_direction, int sig_strength)
{
   //--
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;
  //-- Bayesan Filter 1 - Orders within 'sig_timeFrame' minutes
   int minutes = sig_timeFrame;
   int recentTrades = 0;
   handle = sqlite_query(db, "SELECT count(*) FROM Trades WHERE Pair = '"+sig_currency+"' AND (SignalType = '"+sig_type+"' OR SignalType = 'UNKNOWN') AND ((strftime('%M','now')+strftime('%H','now')*60+strftime('%d','now')*1440) - (strftime('%M',TimeTouched)+strftime('%H',TimeTouched)*60+strftime('%d',TimeTouched)*1440)) <= "+minutes+" AND Closed < 0 ORDER BY TimeTouched DESC", cols);
   if (sqlite_next_row(handle) > 0)
   {
      recentTrades = StringToInteger(sqlite_get_col(handle,  0));
      if (recentTrades > 0) points -= (5+recentTrades);
   }
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

  //-- Bayesan Filter 2 - Losers with less points and strength within 1 Week
       minutes = PERIOD_W1; // 1 Week
   int losingOrders = 0;
   handle = sqlite_query(db, "SELECT count(*) FROM Trades WHERE Pair = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Direction = "+sig_direction+" AND (SignalType = '"+sig_type+"' OR SignalType = 'UNKNOWN') AND SignalPoints <= "+points+" AND Strength <= "+sig_strength+" AND ((strftime('%M','now')+strftime('%H','now')*60+strftime('%d','now')*1440) - (strftime('%M',TimeTouched)+strftime('%H',TimeTouched)*60+strftime('%d',TimeTouched)*1440)) <= "+minutes+" AND Closed < 0 AND RecentPoints < 0 ORDER BY TimeTouched DESC", cols);
   if ( sqlite_next_row(handle) > 0 )
   {
      losingOrders = StringToInteger(sqlite_get_col(handle,  0));
      if (losingOrders > 0) points -= losingOrders;
   }
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

  //-- Bayesan Filter 3 - Losers opened around the same time during the Week
       minutes = PERIOD_W1; // 1 Week
       losingOrders = 0;
   handle = sqlite_query(db, "SELECT TimeOpened FROM Trades WHERE Pair = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Direction = "+sig_direction+" AND (SignalType = '"+sig_type+"' OR SignalType = 'UNKNOWN') AND Strength <= "+sig_strength+" AND ((strftime('%M','now')+strftime('%H','now')*60+strftime('%d','now')*1440) - (strftime('%M',TimeOpened)+strftime('%H',TimeOpened)*60+strftime('%d',TimeOpened)*1440)) <= "+minutes+" AND RecentMoney <= 0 ORDER BY TimeOpened ASC", cols);
   while (sqlite_next_row(handle) > 0)
   {
      datetime timeOpened = StringToTime(sqlite_get_col(handle,  0));
      int h_now = TimeHour(TimeGMT());
      int h_ref = TimeHour(timeOpened);

      int h_interval = 1;//(int)((Euro_London_GMT_End - Euro_London_GMT_Start)/4);
      int h_now_min = h_now - h_interval;
          h_now_min = (h_now_min > 0 ? h_now_min : h_now_min + 24);
      int h_now_max = h_now + h_interval;
          h_now_max = (h_now_max <= 24 ? h_now_max : h_now_max - 24);

      if( h_now_min < h_now_max && (h_ref >= h_now_min && h_ref <= h_now_max) ) losingOrders += 1;
      if( h_now_min > h_now_max && (h_ref >= h_now_min || h_ref <= h_now_max) ) losingOrders += 1;
   }
   points -= losingOrders;
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

  //-- Bayesan Filter 4 - Winners opened around the same time during the Week
       minutes = PERIOD_W1; // 1 Week
   int winningOrders = 0;
   handle = sqlite_query(db, "SELECT TimeOpened FROM Trades WHERE Pair = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Direction = "+sig_direction+" AND (SignalType = '"+sig_type+"' OR SignalType = 'UNKNOWN') AND Strength = "+sig_strength+" AND ((strftime('%M','now')+strftime('%H','now')*60+strftime('%d','now')*1440) - (strftime('%M',TimeOpened)+strftime('%H',TimeOpened)*60+strftime('%d',TimeOpened)*1440)) <= "+minutes+" AND RecentMoney > 0 ORDER BY TimeOpened ASC", cols);
   while (sqlite_next_row(handle) > 0)
   {
      datetime timeOpened = StringToTime(sqlite_get_col(handle,  0));
      int h_now = TimeHour(TimeGMT());
      int h_ref = TimeHour(timeOpened);

      int h_interval = 1;//(int)((Euro_London_GMT_End - Euro_London_GMT_Start)/4);
      int h_now_min = h_now - h_interval;
          h_now_min = (h_now_min > 0 ? h_now_min : h_now_min + 24);
      int h_now_max = h_now + h_interval;
          h_now_max = (h_now_max <= 24 ? h_now_max : h_now_max - 24);

      if( h_now_min < h_now_max && (h_ref >= h_now_min && h_ref <= h_now_max) ) winningOrders += 1;
      if( h_now_min > h_now_max && (h_ref >= h_now_min || h_ref <= h_now_max) ) winningOrders += 1;
   }
   points += winningOrders;
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

  //-- Bayesan Filter 5 - Slow orders opened around the same time during the Week
       minutes = PERIOD_W1; // 1 Week
       losingOrders = 0;
   handle = sqlite_query(db, "SELECT TimeOpened, CountTouched FROM Trades WHERE Pair = '"+sig_currency+"' AND TimeFrame = "+sig_timeFrame+" AND Direction = "+sig_direction+" AND (SignalType = '"+sig_type+"' OR SignalType = 'UNKNOWN') AND Strength <= "+sig_strength+" AND ((strftime('%M','now')+strftime('%H','now')*60+strftime('%d','now')*1440) - (strftime('%M',TimeOpened)+strftime('%H',TimeOpened)*60+strftime('%d',TimeOpened)*1440)) <= "+minutes+" ORDER BY TimeOpened ASC", cols);
   while (sqlite_next_row(handle) > 0)
   {
      datetime timeOpened = StringToTime(sqlite_get_col(handle,  0));
      int countTouched    = StringToInteger(sqlite_get_col(handle,  1));
      int h_now = TimeHour(TimeGMT());
      int h_ref = TimeHour(timeOpened);

      int h_interval = 1;//(int)((Euro_London_GMT_End - Euro_London_GMT_Start)/4);
      int h_now_min = h_now - h_interval;
          h_now_min = (h_now_min > 0 ? h_now_min : h_now_min + 24);
      int h_now_max = h_now + h_interval;
          h_now_max = (h_now_max <= 24 ? h_now_max : h_now_max - 24);

      if( h_now_min < h_now_max && (h_ref >= h_now_min && h_ref <= h_now_max) ) points -= countTouched/1000;
      if( h_now_min > h_now_max && (h_ref >= h_now_min || h_ref <= h_now_max) ) points -= countTouched/1000;
   }

   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

  //-- Check Statistics
   handle = sqlite_query(db, "SELECT SignalType,Trades,Points,WonPoints,LostPoints,BuyTrades,SellTrades,Winners,Losers,BuyPoints,SellPoints,PercWon,PercLost,PercBuy,PercSell FROM Statistics WHERE Pair = '"+sig_currency+"' AND SignalType = '"+sig_type+"'", cols);
   if (sqlite_next_row(handle) > 0)
   {
      string   SignalType  =                sqlite_get_col(handle,  0);
      int      Trades      = StringToInteger(sqlite_get_col(handle, 1));
      double   Points      = StringToDouble(sqlite_get_col(handle,  2));
      double   WonPoints   = StringToDouble(sqlite_get_col(handle,  3));
      double   LostPoints  = StringToDouble(sqlite_get_col(handle,  4));
      int      BuyTrades   = StringToInteger(sqlite_get_col(handle, 5));
      int      SellTrades  = StringToInteger(sqlite_get_col(handle, 6));
      int      Winners     = StringToInteger(sqlite_get_col(handle, 7));
      int      Losers      = StringToInteger(sqlite_get_col(handle, 8));
      double   BuyPoints   = StringToDouble(sqlite_get_col(handle,  9));
      double   SellPoints  = StringToDouble(sqlite_get_col(handle, 10));
      double   PercWon     = StringToDouble(sqlite_get_col(handle, 11));
      double   PercLost    = StringToDouble(sqlite_get_col(handle, 12));
      double   PercBuy     = StringToDouble(sqlite_get_col(handle, 13));
      double   PercSell    = StringToDouble(sqlite_get_col(handle, 14));

      if( Points < 0 )
      {
         if( PercWon < PercSell )
         {
            points -= 1;

            if( BuyPoints < 0 && sig_direction == DIR_LONG) points -= 1;
            if( SellPoints < 0 && sig_direction == DIR_SHORT) points -= 1;
         }
      }
      else
      {
         if( BuyPoints > 0 && sig_direction == DIR_LONG) points += 1;
         if( SellPoints > 0 && sig_direction == DIR_SHORT) points += 1;

         int perc_points = MathRound(2.0*(PercWon + PercLost) / 100.0);

         points += perc_points;
      }
   }
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

   return(points);
}
//-------------------------------

bool is_ValidTime(string PairX, string PairY, int TimeFrame, int shift)
{
   return(iTime(PairX, TimeFrame, shift) == iTime(PairY, TimeFrame, shift));
}

bool is_ValidPrice(string PairX, string PairY, int TimeFrame, int shift)
{
   return((iOpen(PairX, TimeFrame, shift) > 0.0) && (iOpen(PairY, TimeFrame, shift) > 0.0));
}

double get_Averages(string PairX, string PairY, int TimeFrame, int start, int interval)
{
   ValidDataCounter = 0;
   AverageX = 0;
   AverageY = 0;
   AverageXY = 0;
   DispersionX = 0;
   DispersionY = 0;
   for(int i = 0; i < interval; i++)
   {
      if(is_ValidTime(PairX, PairY, TimeFrame, start + i))
      {
         if(!is_ValidPrice(PairX, PairY, TimeFrame, start + i))
         {
            Sleep(2000);
            if(!is_ValidPrice(PairX, PairY, TimeFrame, start + i))
               continue;
         }
         ValidDataCounter++;
         AverageX += get_Price(PairX, TimeFrame, start + i);
         AverageY += get_Price(PairY, TimeFrame, start + i);
         AverageXY += get_Price(PairX, TimeFrame, start + i)*get_Price(PairY, TimeFrame, start + i);
      }
   }
   if(ValidDataCounter == 0) return(0);
   AverageX /= ValidDataCounter;
   AverageY /= ValidDataCounter;
   AverageXY /= ValidDataCounter;

   ValidDataCounter = 0;
   for(int i = 0; i < interval; i++)
   {
      if(is_ValidTime(PairX, PairY, TimeFrame, start + i))
      {
         if(!is_ValidPrice(PairX, PairY, TimeFrame, start + i))
         {
            Sleep(2000);
            if(!is_ValidPrice(PairX, PairY, TimeFrame, start + i))
               continue;
         }
         ValidDataCounter++;
         DispersionX += (get_Price(PairX, TimeFrame, start + i) - AverageX)*(get_Price(PairX, TimeFrame, start + i) - AverageX);
         DispersionY += (get_Price(PairY, TimeFrame, start + i) - AverageY)*(get_Price(PairY, TimeFrame, start + i) - AverageY);
      }
   }
   if(ValidDataCounter == 0)return(0);
   DispersionX /= ValidDataCounter;
   DispersionY /= ValidDataCounter;

   CovariationXY = AverageXY - AverageX*AverageY;

   return(CovariationXY);
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

//+------------------------------------------------------------------+
//| Trading Functions                                                |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

void manageOrders(bool sqIsBarOpen) {
   //--
   Hash *h;
   HashLoop *l;
   //-- Check Oldest
   if( sqIsBarOpen )
   {
      int minutes = PERIOD_MN1; // 1 Month
      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      h = new Hash();
      handle = sqlite_query(db, "SELECT Ticket FROM Trades WHERE ((strftime('%M','now')+strftime('%H','now')*60+strftime('%d','now')*1440) - (strftime('%M',TimeTouched)+strftime('%H',TimeTouched)*60+strftime('%d',TimeTouched)*1440)) > "+minutes+" AND Closed < 0 ORDER BY TimeTouched DESC", cols);
      while( sqlite_next_row(handle) > 0 )
      {
         int ticket   =  StrToInteger(sqlite_get_col(handle, 0));
         h.hPutInt("OrderClosed_"+ticket, ticket);
      }

      if (handle > 0) sqlite_free_query(handle);
      handle = 0;
      for( l = new HashLoop(h) ; l.hasNext() ; l.next())
      {
         long ticketClosed = l.valInt();

         //-- DELETE
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         string sql = "DELETE FROM Trades " ;
                sql+= " WHERE Ticket=" + ticketClosed + "";
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;
         do_exec(db, sql);
      }

      delete h;
      delete l;
   }

   //-- Check Closed
   if (handle > 0) sqlite_free_query(handle);
   handle = 0;
   h = new Hash();
   handle = sqlite_query(db, "SELECT Ticket FROM Trades WHERE Closed >= 0", cols);
   while( sqlite_next_row(handle) > 0 )
   {
      bool orderIsInHistory = false;
      bool orderActive = false;
      int ticket   =  StrToInteger(sqlite_get_col(handle, 0));
      for( int trade=OrdersHistoryTotal()-1;trade>=0;trade-- )
      {
         OrderSelect(trade,SELECT_BY_POS,MODE_HISTORY);

         if( OrderTicket()==ticket )
         {
            orderIsInHistory = true;
            break;
         }
      }

      if( !orderIsInHistory )
      {
         //-- Scan if currently opened
         for(int i=OrdersTotal()-1; i>=0; i--)
         {
            if( OrderSelect(i,SELECT_BY_POS)==true )
            {
               if( OrderTicket() == ticket)
               {
                  orderActive = true;
                  break;
               }
            }
         }
      }

      if( !orderActive ) h.hPutInt("OrderClosed_"+ticket, ticket);
   }

   if (handle > 0) sqlite_free_query(handle);
   handle = 0;
   for( l = new HashLoop(h) ; l.hasNext() ; l.next())
   {
      long ticketClosed = l.valInt();

      if( OrderSelect(ticketClosed, SELECT_BY_TICKET, MODE_HISTORY)==true )
      {
         string symbol   = OrderSymbol();
         int    digits   = MarketInfo(OrderSymbol(),MODE_DIGITS);
         double ask      = MarketInfo(OrderSymbol(),MODE_ASK);
         double bid      = MarketInfo(OrderSymbol(),MODE_BID);
         int    power    = MathPow(10,digits-1);

         int PointProfit = (OrderType() == OP_BUY ? (OrderClosePrice() - OrderOpenPrice()) * power : (OrderOpenPrice() - OrderClosePrice()) * power);
         double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

         //-- UPDATE
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         string timeTouched = TimeToString(get_TimeToGMT(OrderCloseTime()),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
         StringReplace(timeTouched,".","-");

         string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', Closed=-1, CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit + " " ;
                sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                sql+= " WHERE Ticket=" + ticketClosed + "";
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;
         do_exec(db, sql);
      }
      else
      {
         //-- DELETE
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         string sql = "DELETE FROM Trades " ;
                sql+= " WHERE Ticket=" + ticketClosed + "";
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;
         do_exec(db, sql);
      }
   }

   if (handle > 0) sqlite_free_query(handle);
   handle = 0;

   delete l;
   delete h;


   //-- Update Active Trades
   for(int i=OrdersTotal()-1; i>=0; i--) {
      if( OrderSelect(i,SELECT_BY_POS)==true )
      {
         string timeTouched = TimeToString(get_TimeToGMT(OrderOpenTime()),TIME_DATE|TIME_MINUTES|TIME_SECONDS);

         int orderMagicNumber = OrderMagicNumber();
         if( orderMagicNumber == 0 )
         {
            if( OrderType() == OP_BUY )       orderMagicNumber = 1000;
            else if( OrderType() == OP_SELL ) orderMagicNumber = 2000;
         }
         manageOrder(OrderSymbol(), orderMagicNumber);

         /*if(sqIsBarOpen) {
            manageOrderExpiration(OrderSymbol(), OrderMagicNumber());
         }*/
      }

      if(OrdersTotal() <= 0) return;
   }
}

//----------------------------------------------------------------------------

void manageOrder(string symbol, int orderMagicNumber) {
   double tempValue = 0;
   double tempValue2 = 0;
   double newSL    = 0;
   double plValue  = 0;
   int error;
   int addPips     = BreakEvenAtPips;
   int    digits   = MarketInfo(symbol,MODE_DIGITS);
   double ask      = MarketInfo(symbol,MODE_ASK);
   double bid      = MarketInfo(symbol,MODE_BID);
   int    power    = MathPow(10,digits-1);

   if(orderMagicNumber == 1000 && OrderSymbol() == symbol)
   {
      if( OrderType() == OP_BUY)
      {
         // handle only active orders
         int TimeFrame = PERIOD_D1;
         int Direction = (OrderType() == OP_BUY ? DIR_LONG : DIR_SHORT);
         int PointProfit = (OrderClosePrice() - OrderOpenPrice()) * power;
         double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

//--------- 1.03 --
         datetime dataTimeOpened = TimeGMT();
         int dataHighPoints = PointProfit;
         int dataHighPoints_old = 0;
         int dataLowPoints = PointProfit;
         int dataLowPoints_old = 0;
         double dataHighMoney = MoneyProfit;
         double dataLowMoney = MoneyProfit;

         bool bullishCandle = false;
         bool bearishCandle = false;

         double bb_squeeze_green_0;
         double bb_squeeze_green_1;

         double upTrendStop;
         double downTrendStop;
         double upTrendSignal;
         double downTrendSignal;
//--------- 1.03 --

         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         handle = sqlite_query(db, "SELECT TimeOpened, TimeFrame, High, Low, HighMoney, LowMoney, Hedge1, Hedge2, Hedge3, Hedge4, Hedge5, Hedge6, Hedge7, Hedge8 FROM Trades WHERE Ticket=" + OrderTicket() + " LIMIT 1", cols);
         if (sqlite_next_row(handle) > 0) {
            int ticket = OrderTicket();
                dataTimeOpened   =     StrToTime(sqlite_get_col(handle, 0));
                TimeFrame        =  StrToInteger(sqlite_get_col(handle, 1));
                dataHighPoints   =   StrToDouble(sqlite_get_col(handle, 2));
                dataLowPoints    =   StrToDouble(sqlite_get_col(handle, 3));
                dataHighMoney    =   StrToDouble(sqlite_get_col(handle, 4));
                dataLowMoney     =   StrToDouble(sqlite_get_col(handle, 5));
            double dataHedge1    =   StrToDouble(sqlite_get_col(handle, 6));
            double dataHedge2    =   StrToDouble(sqlite_get_col(handle, 7));
            double dataHedge3    =   StrToDouble(sqlite_get_col(handle, 8));
            double dataHedge4    =   StrToDouble(sqlite_get_col(handle, 9));
            double dataHedge5    =   StrToDouble(sqlite_get_col(handle,10));
            double dataHedge6    =   StrToDouble(sqlite_get_col(handle,11));
            double dataHedge7    =   StrToDouble(sqlite_get_col(handle,12));
            double dataHedge8    =   StrToDouble(sqlite_get_col(handle,13));
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            //-- Update Order Status
            dataHighPoints_old = dataHighPoints;
            dataLowPoints_old  = dataLowPoints;
            if (PointProfit > dataHighPoints) dataHighPoints = PointProfit;
            if (PointProfit < dataLowPoints)  dataLowPoints = PointProfit;

            if (MoneyProfit > dataHighMoney) dataHighMoney = MoneyProfit;
            if (MoneyProfit < dataLowMoney) dataLowMoney = MoneyProfit;

            string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
            StringReplace(timeTouched,".","-");

            string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit +", High=" + dataHighPoints + ", Low=" + dataLowPoints + ", HighMoney=" + dataHighMoney + ", LowMoney=" + dataLowMoney + " " ;
                   sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                   sql+= " WHERE Ticket=" + ticket + "";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }
         else
         {
            string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
            StringReplace(timeTouched,".","-");

            //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
            string sql = "INSERT INTO 'Trades' ('Ticket','TimeFrame','Pair','Closed','SignalType','SignalPoints','Direction','Strength','Size','TimeOpened','TimeTouched','CountTouched', 'RecentPoints', 'RecentMoney', 'High','Low','HighMoney','LowMoney','Hedge1','Hedge2','Hedge3','Hedge4') VALUES (";
                   sql+= "'" + OrderTicket() + "','" + TimeFrame + "','" + OrderSymbol() + "','0','UNKNOWN','0','" + Direction + "','" + STR_NEUTRAL + "',";
                   sql+= "'" + OrderLots() + "','" + TimeGMT() + "','" + timeTouched + "', 0, '"+ PointProfit +"', '"+ MoneyProfit +"', '"+ PointProfit +"',  '"+ PointProfit +"', '" + MoneyProfit + "', '" + MoneyProfit + "',";
                   sql+= "'" + OrderOpenPrice() + "','" + OrderClosePrice() + "','" + OrderStopLoss() + "', '" + OrderTakeProfit() + "' ";
                   sql+= ")";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }

//--------- 1.03 --
         //--- Japanese Candlestick Patterns - Strengthening
         int pattern = sqGetCandlePattern(OrderSymbol(), TimeFrame, 1);

         if( pattern >= 0 )
         {
            if( pattern != PATTERN_UNDEFINED )
            {
               //-- Bearish Patterns
               switch(pattern)
               {
                  case PATTERN_BEARISH_DCC:
                  case PATTERN_BEARISH_E_DOJI:
                  case PATTERN_BEARISH_E_STAR:
                  case PATTERN_BEARISH_SS2:
                  case PATTERN_BEARISH_SS3:
                  case PATTERN_BEARISH_SS4:
                  case PATTERN_BEARISH_S_E:
                     bearishCandle = true;
                     break;
               }

               //-- Bullish Patterns
               switch(pattern)
               {
                  case PATTERN_BULLISH_HMR2:
                  case PATTERN_BULLISH_HMR3:
                  case PATTERN_BULLISH_HMR4:
                  case PATTERN_BULLISH_L_E:
                  case PATTERN_BULLISH_M_DOJI:
                  case PATTERN_BULLISH_M_STAR:
                  case PATTERN_BULLISH_P_L:
                     bullishCandle = true;
                     break;
               }
            }
         }

         //-- MM Velocity and Acceleration
         //int trend = getTrend(sig_currency,sig_timeFrame,soglie);
         int trend, trend_m15, trend_m30, trend_h1;
         trend_m15 = getTrend(OrderSymbol(),PERIOD_M15, soglie);
         trend_m30 = getTrend(OrderSymbol(),PERIOD_M30, soglie);
         trend_h1 = getTrend(OrderSymbol(),PERIOD_H1, soglie);

         if(trend_m15 == TREND_CRESCENTE_FORTE && trend_m30 == TREND_CRESCENTE_FORTE && trend_h1 == TREND_CRESCENTE_FORTE) trend = TREND_CRESCENTE_FORTE;
         else if(trend_m15 == TREND_DECRESCENTE_FORTE && trend_m30 == TREND_DECRESCENTE_FORTE && trend_h1 == TREND_DECRESCENTE_FORTE) trend = TREND_DECRESCENTE_FORTE;
         else trend = TREND_LATERALE;
         //--
         trend = getTrendConfirmation(OrderSymbol(),trend);
         //--
         switch(trend)
         {
            case TREND_CRESCENTE_FORTE:
               bullishCandle = true;
               break;
            case TREND_DECRESCENTE_FORTE:
               bearishCandle = true;
               break;
         }

         //--- Signal Type 'BB' - Confirmation

           HideTestIndicators(true);
            bb_squeeze_green_0  = bb_squeeze_dark(OrderSymbol(), TimeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
                     //iCustom(OrderSymbol(), TimeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
            bb_squeeze_green_1  = bb_squeeze_dark(OrderSymbol(), TimeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);
                     //iCustom(OrderSymbol(), TimeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);

            upTrendStop         = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 0, 0);
            downTrendStop       = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 1, 0);
            upTrendSignal       = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 2, 0);
            downTrendSignal     = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 3, 0);
           HideTestIndicators(false);

         //-- Check Time Opened and Profits
         int hoursSinceOpened = (TimeGMT() - dataTimeOpened)/3600;

         if( (bearishCandle && hoursSinceOpened > (TimeFrame / 60)) && PointProfit >= (dataHighPoints + dataLowPoints)/4 )
         {
            if( bb_squeeze_green_0 == EMPTY_VALUE || bb_squeeze_green_0 != 0 || downTrendStop > 0 || downTrendSignal > 0 )
            {
               if( sqClosePositionAtMarket(OrderLots()) )
               {
                  return;
               }
            }
         }
//--------- 1.03 --

         // SL/TP
         if(OrderStopLoss() == 0 || OrderTakeProfit() == 0)
         {

            //--
            get_NearestAndFarestSR(symbol, TimeFrame, MarketInfo(symbol,MODE_ASK));
            //--

            double realSL = (OrderStopLoss() != 0 ? OrderStopLoss() : NormalizeDouble(nearest_support,MarketInfo(symbol,MODE_DIGITS)));
            double realPT = (OrderTakeProfit() != 0 ? OrderTakeProfit() : NormalizeDouble(farest_resistance,MarketInfo(symbol,MODE_DIGITS)));

            if( realSL >= MarketInfo(symbol, MODE_BID) - MarketInfo(symbol, MODE_STOPLEVEL) * MarketInfo(symbol, MODE_POINT) || newSL <= OrderStopLoss())
            {
               get_NearestAndFarestSR(symbol, TimeFrame, nearest_support);
               realSL = NormalizeDouble(nearest_support,MarketInfo(symbol,MODE_DIGITS));
            }

            if(sqIsTradeAllowed() == 1) {
               double distance_from_open_price = (realPT - OrderOpenPrice())*power;
               if ( distance_from_open_price < BreakEvenAtPips )
               {
                  realPT = OrderTakeProfit();
               }
               sqSetSLPTForOrder(OrderTicket(), realSL, realPT, orderMagicNumber, OrderType(), OrderOpenPrice(), symbol, 3, CloseAtError);
            }
         }

         // Trailing Stop
         tempValue = getOrderTrailingStop(symbol, TimeFrame, 1000, OrderType());
         if(tempValue > 0) {
            tempValue2 = getOrderTrailingStopActivation(symbol, 1000, addPips);

            if(OrderType() == OP_BUY) {
               plValue = MarketInfo(symbol, MODE_BID) - OrderOpenPrice();
               newSL = tempValue;
               double order_sl = OrderStopLoss();

               if (plValue >= tempValue2 && (order_sl == 0 || order_sl < newSL) && !sqDoublesAreEqual(symbol, order_sl, newSL)) {
                  Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                     error = GetLastError();
                     Verbose("Failed, error: ", error, " - ", ErrorDescription(error));
                  }
               }
            } else { // OrderType() == OP_SELL
               plValue = OrderOpenPrice() - MarketInfo(symbol, MODE_ASK);
               newSL = tempValue;

               if (plValue >= tempValue2 && (OrderStopLoss() == 0 || OrderStopLoss() > newSL) && !sqDoublesAreEqual(symbol, OrderStopLoss(), newSL)) {
                  Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                     error = GetLastError();
                     Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(symbol, MODE_ASK), ", Bid: ", MarketInfo(symbol, MODE_BID), " Current SL: ",  OrderStopLoss());
                  }
               }
            }
         }

         // Move Stop Loss to Break Even

//--------- 1.03 --
         //--Check the strengthness of the signal
         bool signalIsWeak = false;

         if( bearishCandle )
         {
            signalIsWeak = true;
         }
         if( bb_squeeze_green_0 == EMPTY_VALUE || bb_squeeze_green_0 != 0 || downTrendStop > 0 || downTrendSignal > 0 )
         {
            signalIsWeak = true;
         }

               //-- Individual Strength and Weakness
               string curr1    = StringSubstr(OrderSymbol(),0,3);
               string curr2    = StringSubstr(OrderSymbol(),3,5);

               double strength1 = 0;
               double strength2 = 0;

               //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
               handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr1+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  strength1  = StringToDouble(sqlite_get_col(handle, 0));
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

               handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr2+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  strength2  = StringToDouble(sqlite_get_col(handle, 0));
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

         if(strength1 - strength2 >= 4 )
         {
            signalIsWeak = true;
         }

         if(strength2 > 7 && strength1 < 3 )
         {
            signalIsWeak = true;
         }

               //-- Daily Percent Rate Consistency
               double dailyPercentChange = 0;

               //-- 'HeatMap' --> 'Time', 'TimeFrame', 'Pair1', 'Pair2', 'AvgCorrelation', 'DailyPercentChange'
               handle = sqlite_query(db, "SELECT DailyPercentChange FROM 'HeatMap' WHERE Pair2 = '"+OrderSymbol()+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  dailyPercentChange  = StringToDouble(sqlite_get_col(handle, 0));
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

               //-- Daily Percent Range Concordance
               int dailyPercentChangeConcordanceCounter = 0;
               handle = sqlite_query(db, "SELECT distinct(DailyPercentChange),TimeFrame FROM 'HeatMap' WHERE Pair2 = '"+OrderSymbol()+"' AND TimeFrame <> "+TimeFrame+" ORDER BY id DESC", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  double dailyPercentChange2 = StringToDouble(sqlite_get_col(handle, 0));

                  if( dailyPercentChange > 0 && dailyPercentChange2 >= dailyPercentChange )
                  {
                     dailyPercentChangeConcordanceCounter += 1;
                  }
                  else if( dailyPercentChange < 0 && dailyPercentChange2 <= dailyPercentChange )
                  {
                     dailyPercentChangeConcordanceCounter += 1;
                  }
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

         if( /*(h_asian_session_hours <= 1 || h_eu_session_hours <= 1) &&*/ dailyPercentChangeConcordanceCounter > 1 && dailyPercentChange >= -HeatMapDailyPercRateTholdMax && dailyPercentChange <= -HeatMapDailyPercRateTholdMin )
         {
            signalIsWeak = true;
         }

      //----- 1.05 --
        //-- Check Statistics
         handle = sqlite_query(db, "SELECT SignalType,Trades,Points,WonPoints,LostPoints,BuyTrades,SellTrades,Winners,Losers,BuyPoints,SellPoints,PercWon,PercLost,PercBuy,PercSell FROM Statistics WHERE Pair = '"+OrderSymbol()+"'", cols);
         while (sqlite_next_row(handle) > 0)
         {
            string   SignalType  =                sqlite_get_col(handle,  0);
            int      Trades      = StringToInteger(sqlite_get_col(handle, 1));
            double   Points      = StringToDouble(sqlite_get_col(handle,  2));
            double   WonPoints   = StringToDouble(sqlite_get_col(handle,  3));
            double   LostPoints  = StringToDouble(sqlite_get_col(handle,  4));
            int      BuyTrades   = StringToInteger(sqlite_get_col(handle, 5));
            int      SellTrades  = StringToInteger(sqlite_get_col(handle, 6));
            int      Winners     = StringToInteger(sqlite_get_col(handle, 7));
            int      Losers      = StringToInteger(sqlite_get_col(handle, 8));
            double   BuyPoints   = StringToDouble(sqlite_get_col(handle,  9));
            double   SellPoints  = StringToDouble(sqlite_get_col(handle, 10));
            double   PercWon     = StringToDouble(sqlite_get_col(handle, 11));
            double   PercLost    = StringToDouble(sqlite_get_col(handle, 12));
            double   PercBuy     = StringToDouble(sqlite_get_col(handle, 13));
            double   PercSell    = StringToDouble(sqlite_get_col(handle, 14));

            if( PercWon < PercSell )
            {
               signalIsWeak = true;
            }
         }
         if (handle > 0) sqlite_free_query(handle);
         handle = 0;
      //----- 1.05 --

         if( signalIsWeak )
         {
            tempValue = getOrderBreakEven(symbol, 1000, OrderType(), OrderOpenPrice(), 2*addPips);
            tempValue2 = getOrderBreakEvenAddPips(symbol, 1000, addPips);
            if(tempValue > 0) {
               if(OrderType() == OP_BUY) {
                  newSL = OrderOpenPrice() + tempValue2;
                  if (OrderOpenPrice() <= tempValue && (OrderStopLoss() == 0 || OrderStopLoss() < newSL) && !sqDoublesAreEqual(OrderSymbol(), OrderStopLoss(), newSL)) {
                     Verbose("Moving SL 2 BE for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                     if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                        error = GetLastError();
                        Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(symbol,MODE_ASK), ", Bid: ", MarketInfo(symbol,MODE_BID), " Current SL: ",  OrderStopLoss());
                     }
                  }
               } else { // OrderType() == OP_SELL
                  newSL = OrderOpenPrice() - tempValue2;
                  if (OrderOpenPrice() >= tempValue && (OrderStopLoss() == 0 || OrderStopLoss() > newSL) && !sqDoublesAreEqual(OrderSymbol(), OrderStopLoss(), newSL)) {
                     Verbose("Moving SL 2 BE for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                     if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                        error = GetLastError();
                        Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(symbol,MODE_ASK), ", Bid: ", MarketInfo(symbol,MODE_BID), " Current SL: ",  OrderStopLoss());
                     }
                  }
               }
            }

            // Exit After X Bars
            /*tempValue = getOrderExitAfterXBars(1000);
            if(tempValue > 0) {
               if (sqGetOpenBarsForOrder(tempValue+10) >= tempValue) {
                  Verbose("Exit After ", tempValue, "bars - closing order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber);
                  sqClosePositionAtMarket(-1);
               }
            }*/
         }
//--------- 1.03 --

         //--
         double price = OrderClosePrice();
         double profit = OrderProfit() + OrderCommission() + OrderSwap();
         get_NearestAndFarestSR(symbol, TimeFrame, price);
         //--

         MqlRates RatesBar[];
         ArraySetAsSeries(RatesBar,true);
         if(profit > 0 && CopyRates(symbol,TimeFrame,0,2,RatesBar)==2)
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

            double distance_from_pivot             = MathAbs((price - Fhr_P)*power);
            double distance_from_support           = (price - nearest_support)*power;
            double distance_from_resistance        = (nearest_resistance - price)*power;
            double distance_from_daily_pivot       = MathAbs((price - D_P)*power);
            double distance_from_daily_support     = (price - nearest_daily_support)*power;
            double distance_from_daily_resistance  = (nearest_daily_resistance - price)*power;

            double order_tp                        = OrderTakeProfit();
            double distance_from_tp                = (order_tp - price)*power;

            double order_sl                        = OrderStopLoss();
            double distance_from_sl                = (price - order_sl)*power;

            bool look_next  = true;

            //--Moving toward TP (BUY)
            if (look_next && price < order_tp && distance_from_tp > 0 && distance_from_tp <= TrailingStopPips/2 && dataHighPoints_old > 0 && (dataHighPoints_old - PointProfit) > 0 && (dataHighPoints_old - PointProfit) <= dataHighPoints_old / 4 )
            {
               sqClosePositionAtMarket(OrderLots());
               look_next = false;
            }
            //--The Price is above the Trailing Profit
            if (look_next && order_tp < price && MathAbs(distance_from_tp) > TrailingStopPips)
            {
               //--Move StopLoss to older TakeProfit
               if ((order_sl == 0 || order_sl < order_tp) && !sqDoublesAreEqual(symbol, order_sl, order_tp)) {
                  Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", order_tp);
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), order_tp, 0, 0)) {
                     error = GetLastError();
                     Verbose("Failed, error: ", error, " - ", ErrorDescription(error));
                  }
               }
               look_next = false;
            }
            //--The Price is below the Stop Loss
            if (look_next && order_sl >= price && MathAbs(distance_from_sl) > TrailingStopPips/2)
            {
               sqClosePositionAtMarket(OrderLots());
               look_next = false;
            }

            double SR_Range   = (nearest_resistance - nearest_support)*power;
                   SR_Range   = (SR_Range != 0 ? SR_Range : 0.001);
            double DSR_Range  = (nearest_daily_resistance - nearest_daily_support)*power;
                   DSR_Range  = (DSR_Range != 0 ? DSR_Range : 0.001);

            //--Near/Far from the Pivot
            if( look_next && hoursSinceOpened > (TimeFrame / 60) && SR_Range >= TrailingStopPips )
            {
               double perc_dist_pivot = (distance_from_pivot*100)/SR_Range;

               if( perc_dist_pivot >= 0 && perc_dist_pivot <= TrailingStopPips)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }

               //--Near/Far from a Support or Resistance
               double perc_dist_support    = (distance_from_support*100)/SR_Range;
               double perc_dist_resistance = (distance_from_resistance*100)/SR_Range;

               if( look_next && perc_dist_support >= 0 && perc_dist_support <= 25)
               {
                  //sqClosePositionAtMarket(OrderLots());
                  //look_next = false;
               }

               if( look_next && perc_dist_resistance >= 0 && perc_dist_resistance <= TrailingStopPips/2)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }
            }

            //--Near/Far from a Daily level
            if( look_next && hoursSinceOpened > (TimeFrame / 60) && DSR_Range >= TrailingStopPips )
            {
               double perc_dist_daily_pivot      = (distance_from_daily_pivot*100)/DSR_Range;
               double perc_dist_daily_support    = (distance_from_daily_support*100)/DSR_Range;
               double perc_dist_daily_resistance = (distance_from_daily_resistance*100)/DSR_Range;

               if( perc_dist_daily_pivot >= 0 && perc_dist_daily_pivot <= TrailingStopPips)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }

               if( look_next && perc_dist_daily_support >= 0 && perc_dist_daily_support <= 10)
               {
                  //sqClosePositionAtMarket(OrderLots());
                  //look_next = false;
               }

               if( look_next && perc_dist_daily_resistance >= 0 && perc_dist_daily_resistance <= TrailingStopPips/2)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }
            }
         }
      }
   }

   if(orderMagicNumber == 2000 && OrderSymbol() == symbol) {
      if(OrderType() == OP_SELL) {
         // handle only active orders
         int TimeFrame = PERIOD_D1;
         int Direction = (OrderType() == OP_BUY ? DIR_LONG : DIR_SHORT);
         int PointProfit = (OrderOpenPrice() - OrderClosePrice()) * power;
         double MoneyProfit = OrderProfit() + OrderCommission() + OrderSwap();

//--------- 1.03 --
         datetime dataTimeOpened = TimeGMT();
         int dataHighPoints = PointProfit;
         int dataHighPoints_old = 0;
         int dataLowPoints = PointProfit;
         int dataLowPoints_old = 0;
         double dataHighMoney = MoneyProfit;
         double dataLowMoney = MoneyProfit;

         bool bullishCandle = false;
         bool bearishCandle = false;

         double bb_squeeze_green_0;
         double bb_squeeze_green_1;

         double upTrendStop;
         double downTrendStop;
         double upTrendSignal;
         double downTrendSignal;
//--------- 1.03 --

         if (handle > 0) sqlite_free_query(handle);
         handle = 0;

         handle = sqlite_query(db, "SELECT TimeOpened, TimeFrame, High, Low, HighMoney, LowMoney, Hedge1, Hedge2, Hedge3, Hedge4, Hedge5, Hedge6, Hedge7, Hedge8 FROM Trades WHERE Ticket=" + OrderTicket() + " LIMIT 1", cols);
         if (sqlite_next_row(handle) > 0) {
            int ticket = OrderTicket();
            datetime dataTimeOpened=   StrToTime(sqlite_get_col(handle, 0));
                TimeFrame        =  StrToInteger(sqlite_get_col(handle, 1));
            int dataHighPoints   =   StrToDouble(sqlite_get_col(handle, 2));
            int dataLowPoints    =   StrToDouble(sqlite_get_col(handle, 3));
            double dataHighMoney =   StrToDouble(sqlite_get_col(handle, 4));
            double dataLowMoney  =   StrToDouble(sqlite_get_col(handle, 5));
            double dataHedge1    =   StrToDouble(sqlite_get_col(handle, 6));
            double dataHedge2    =   StrToDouble(sqlite_get_col(handle, 7));
            double dataHedge3    =   StrToDouble(sqlite_get_col(handle, 8));
            double dataHedge4    =   StrToDouble(sqlite_get_col(handle, 9));
            double dataHedge5    =   StrToDouble(sqlite_get_col(handle,10));
            double dataHedge6    =   StrToDouble(sqlite_get_col(handle,11));
            double dataHedge7    =   StrToDouble(sqlite_get_col(handle,12));
            double dataHedge8    =   StrToDouble(sqlite_get_col(handle,13));
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;

            //-- Update Order Status
            dataHighPoints_old = dataHighPoints;
            dataLowPoints_old  = dataLowPoints;
            if (PointProfit > dataHighPoints) dataHighPoints = PointProfit;
            if (PointProfit < dataLowPoints)  dataLowPoints = PointProfit;

            if (MoneyProfit > dataHighMoney) dataHighMoney = MoneyProfit;
            if (MoneyProfit < dataLowMoney) dataLowMoney = MoneyProfit;

            string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
            StringReplace(timeTouched,".","-");

            string sql = "UPDATE Trades SET TimeTouched='" + timeTouched + "', CountTouched=CountTouched+1, RecentPoints="+ PointProfit +", RecentMoney="+ MoneyProfit +", High=" + dataHighPoints + ", Low=" + dataLowPoints + ", HighMoney=" + dataHighMoney + ", LowMoney=" + dataLowMoney + " " ;
                   sql+= ", Hedge1=" + OrderOpenPrice() + ", Hedge2=" + OrderClosePrice() + ", Hedge3=" + OrderStopLoss() + ", Hedge4=" + OrderTakeProfit() + " ";
                   sql+= " WHERE Ticket=" + ticket + "";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }
         else
         {
            string timeTouched = TimeToString(TimeGMT(),TIME_DATE|TIME_MINUTES|TIME_SECONDS);
            StringReplace(timeTouched,".","-");

            //-- 'Trades' --> 'Ticket', 'TimeFrame', 'Pair', 'Closed', 'SignalType', 'SignalPoints', 'Direction', 'Strength', 'Size', 'TimeOpened', 'TimeTouched', 'CountTouched', 'RecentPoints', 'RecentMoney', 'High', 'Low', 'HighMoney', 'LowMoney', 'Hedge1', 'Hedge2', 'Hedge3', 'Hedge4', 'Hedge5', 'Hedge6', 'Hedge7', 'Hedge8'
            string sql = "INSERT INTO 'Trades' ('Ticket','TimeFrame','Pair','Closed','SignalType','SignalPoints','Direction','Strength','Size','TimeOpened','TimeTouched','CountTouched', 'RecentPoints', 'RecentMoney', 'High','Low','HighMoney','LowMoney','Hedge1','Hedge2','Hedge3','Hedge4') VALUES (";
                   sql+= "'" + OrderTicket() + "','" + TimeFrame + "','" + OrderSymbol() + "','0','UNKNOWN','0','" + Direction + "','" + STR_NEUTRAL + "',";
                   sql+= "'" + OrderLots() + "','" + TimeGMT() + "','" + timeTouched + "', 0, '"+ PointProfit +"', '"+ MoneyProfit +"', '"+ PointProfit +"',  '"+ PointProfit +"', '" + MoneyProfit + "', '" + MoneyProfit + "',";
                   sql+= "'" + OrderOpenPrice() + "','" + OrderClosePrice() + "','" + OrderStopLoss() + "', '" + OrderTakeProfit() + "' ";
                   sql+= ")";
            if (handle > 0) sqlite_free_query(handle);
            handle = 0;
            do_exec(db, sql);
         }

//--------- 1.03 --
         //--- Japanese Candlestick Patterns - Strengthening
         int pattern = sqGetCandlePattern(OrderSymbol(), TimeFrame, 1);

         if( pattern >= 0 )
         {
            if( pattern != PATTERN_UNDEFINED )
            {
               //-- Bearish Patterns
               switch(pattern)
               {
                  case PATTERN_BEARISH_DCC:
                  case PATTERN_BEARISH_E_DOJI:
                  case PATTERN_BEARISH_E_STAR:
                  case PATTERN_BEARISH_SS2:
                  case PATTERN_BEARISH_SS3:
                  case PATTERN_BEARISH_SS4:
                  case PATTERN_BEARISH_S_E:
                     bearishCandle = true;
                     break;
               }

               //-- Bullish Patterns
               switch(pattern)
               {
                  case PATTERN_BULLISH_HMR2:
                  case PATTERN_BULLISH_HMR3:
                  case PATTERN_BULLISH_HMR4:
                  case PATTERN_BULLISH_L_E:
                  case PATTERN_BULLISH_M_DOJI:
                  case PATTERN_BULLISH_M_STAR:
                  case PATTERN_BULLISH_P_L:
                     bullishCandle = true;
                     break;
               }
            }
         }

         //-- MM Velocity and Acceleration
         //int trend = getTrend(sig_currency,sig_timeFrame,soglie);
         int trend, trend_m15, trend_m30, trend_h1;
         trend_m15 = getTrend(OrderSymbol(),PERIOD_M15, soglie);
         trend_m30 = getTrend(OrderSymbol(),PERIOD_M30, soglie);
         trend_h1 = getTrend(OrderSymbol(),PERIOD_H1, soglie);

         if(trend_m15 == TREND_CRESCENTE_FORTE && trend_m30 == TREND_CRESCENTE_FORTE && trend_h1 == TREND_CRESCENTE_FORTE) trend = TREND_CRESCENTE_FORTE;
         else if(trend_m15 == TREND_DECRESCENTE_FORTE && trend_m30 == TREND_DECRESCENTE_FORTE && trend_h1 == TREND_DECRESCENTE_FORTE) trend = TREND_DECRESCENTE_FORTE;
         else trend = TREND_LATERALE;
         //--
         trend = getTrendConfirmation(OrderSymbol(),trend);
         //--
         switch(trend)
         {
            case TREND_CRESCENTE_FORTE:
               bullishCandle = true;
               break;
            case TREND_DECRESCENTE_FORTE:
               bearishCandle = true;
               break;
         }

         //--- Signal Type 'BB' - Confirmation

           HideTestIndicators(true);
            bb_squeeze_green_0  = bb_squeeze_dark(OrderSymbol(), TimeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
                     //iCustom(OrderSymbol(), TimeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 0);
            bb_squeeze_green_1  = bb_squeeze_dark(OrderSymbol(), TimeFrame, bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);
                     //iCustom(OrderSymbol(), TimeFrame, "bbsqueeze_dark", bolPrd, bolDev, keltPrd, keltFactor, momPrd, Length, Nbars, 5, 1);

            upTrendStop         = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 0, 0);
            downTrendStop       = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 1, 0);
            upTrendSignal       = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 2, 0);
            downTrendSignal     = doda_bands2(OrderSymbol(), TimeFrame, "Doda-Bands2", Length, Deviation, MoneyRisk, Signal, Line, Nbars, FALSE, 3, 0);
           HideTestIndicators(false);

         //-- Check Time Opened and Profits
         int hoursSinceOpened = (TimeGMT() - dataTimeOpened)/3600;

         if( (bullishCandle && hoursSinceOpened > (TimeFrame / 60)) && PointProfit >= (dataHighPoints + dataLowPoints)/4 )
         {
            if( bb_squeeze_green_0 == EMPTY_VALUE || bb_squeeze_green_0 != 0 || upTrendStop > 0 || upTrendSignal > 0 )
            {
               if( sqClosePositionAtMarket(OrderLots()) )
               {
                  return;
               }
            }
         }
//--------- 1.03 --

         // SL/TP
         if(OrderStopLoss() == 0 || OrderTakeProfit() == 0)
         {

            //--
            get_NearestAndFarestSR(symbol, TimeFrame, MarketInfo(symbol,MODE_BID));
            //--

            double realSL = (OrderStopLoss() != 0 ? OrderStopLoss() : NormalizeDouble(nearest_resistance,MarketInfo(symbol,MODE_DIGITS)));
            double realPT = (OrderTakeProfit() != 0 ? OrderTakeProfit() : NormalizeDouble(farest_support,MarketInfo(symbol,MODE_DIGITS)));

            if( realSL <= MarketInfo(symbol, MODE_ASK) + MarketInfo(symbol, MODE_STOPLEVEL) * MarketInfo(symbol, MODE_POINT) || (OrderStopLoss() > 0 && newSL >= OrderStopLoss()))
            {
               get_NearestAndFarestSR(symbol, TimeFrame, nearest_resistance);
               realSL = NormalizeDouble(nearest_resistance,MarketInfo(symbol,MODE_DIGITS));
            }

            if(sqIsTradeAllowed() == 1) {
               double distance_from_open_price = (OrderOpenPrice() - realPT)*power;
               if ( distance_from_open_price < BreakEvenAtPips )
               {
                  realPT = OrderTakeProfit();
               }
               sqSetSLPTForOrder(OrderTicket(), realSL, realPT, orderMagicNumber, OrderType(), OrderOpenPrice(), symbol, 3, CloseAtError);
            }
         }

         // Trailing Stop
         tempValue = getOrderTrailingStop(symbol, TimeFrame, 2000, OrderType());
         if(tempValue > 0) {
            tempValue2 = getOrderTrailingStopActivation(symbol, 2000, addPips);

            if(OrderType() == OP_BUY) {
               plValue = MarketInfo(symbol, MODE_BID) - OrderOpenPrice();
               newSL = tempValue;

               if (plValue >= tempValue2 && (OrderStopLoss() == 0 || OrderStopLoss() < newSL) && !sqDoublesAreEqual(symbol, OrderStopLoss(), newSL)) {
                  Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                     error = GetLastError();
                     Verbose("Failed, error: ", error, " - ", ErrorDescription(error));
                  }
               }
            } else { // OrderType() == OP_SELL
               plValue = OrderOpenPrice() - MarketInfo(symbol, MODE_ASK);
               newSL = tempValue;

               if (plValue >= tempValue2 && (OrderStopLoss() == 0 || OrderStopLoss() > newSL) && !sqDoublesAreEqual(symbol, OrderStopLoss(), newSL)) {
                  Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                     error = GetLastError();
                     Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(symbol, MODE_ASK), ", Bid: ", MarketInfo(symbol, MODE_BID), " Current SL: ",  OrderStopLoss());
                  }
               }
            }
         }

         // Move Stop Loss to Break Even

//--------- 1.03 --
         //--Check the strengthness of the signal
         bool signalIsWeak = false;

         if( bullishCandle )
         {
            signalIsWeak = true;
         }
         if( bb_squeeze_green_0 == EMPTY_VALUE || bb_squeeze_green_0 != 0 || upTrendStop > 0 || upTrendSignal > 0 )
         {
            signalIsWeak = true;
         }

               //-- Individual Strength and Weakness
               string curr1    = StringSubstr(OrderSymbol(),0,3);
               string curr2    = StringSubstr(OrderSymbol(),3,5);

               double strength1 = 0;
               double strength2 = 0;

               //-- 'TotalStrength' --> 'Time', 'TimeFrame', 'Currency', 'Strength'
               handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr1+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  strength1  = StringToDouble(sqlite_get_col(handle, 0));
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

               handle = sqlite_query(db, "SELECT Strength FROM 'TotalStrength' WHERE Currency = '"+curr2+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  strength2  = StringToDouble(sqlite_get_col(handle, 0));
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

         if( strength1 > 7 && strength2 < 3 )
         {
            signalIsWeak = true;
         }

         if( strength2 - strength1 >= 4  )
         {
            signalIsWeak = true;
         }

               //-- Daily Percent Rate Consistency
               double dailyPercentChange = 0;

               //-- 'HeatMap' --> 'Time', 'TimeFrame', 'Pair1', 'Pair2', 'AvgCorrelation', 'DailyPercentChange'
               handle = sqlite_query(db, "SELECT DailyPercentChange FROM 'HeatMap' WHERE Pair2 = '"+OrderSymbol()+"' AND TimeFrame = "+TimeFrame+" ORDER BY id DESC LIMIT 1", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  dailyPercentChange  = StringToDouble(sqlite_get_col(handle, 0));
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

               //-- Daily Percent Range Concordance
               int dailyPercentChangeConcordanceCounter = 0;
               handle = sqlite_query(db, "SELECT distinct(DailyPercentChange),TimeFrame FROM 'HeatMap' WHERE Pair2 = '"+OrderSymbol()+"' AND TimeFrame <> "+TimeFrame+" ORDER BY id DESC", cols);
               while(sqlite_next_row(handle) > 0)
               {
                  double dailyPercentChange2 = StringToDouble(sqlite_get_col(handle, 0));

                  if( dailyPercentChange > 0 && dailyPercentChange2 >= dailyPercentChange )
                  {
                     dailyPercentChangeConcordanceCounter += 1;
                  }
                  else if( dailyPercentChange < 0 && dailyPercentChange2 <= dailyPercentChange )
                  {
                     dailyPercentChangeConcordanceCounter += 1;
                  }
               }
               if (handle > 0) sqlite_free_query(handle);
               handle = 0;

         if( /*(h_asian_session_hours <= 1 || h_eu_session_hours <= 1) &&*/ dailyPercentChangeConcordanceCounter > 1 && dailyPercentChange <= HeatMapDailyPercRateTholdMax && dailyPercentChange >= HeatMapDailyPercRateTholdMin )
         {
            signalIsWeak = true;
         }

         if( signalIsWeak )
         {
            tempValue = getOrderBreakEven(symbol, 2000, OrderType(), OrderOpenPrice(), 2*addPips);
            tempValue2 = getOrderBreakEvenAddPips(symbol, 2000, addPips);
            if(tempValue > 0) {
               if(OrderType() == OP_BUY) {
                  newSL = OrderOpenPrice() + tempValue2;
                  if (OrderOpenPrice() <= tempValue && (OrderStopLoss() == 0 || OrderStopLoss() < newSL) && !sqDoublesAreEqual(OrderSymbol(), OrderStopLoss(), newSL)) {
                     Verbose("Moving SL 2 BE for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                     if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                        error = GetLastError();
                        Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(symbol,MODE_ASK), ", Bid: ", MarketInfo(symbol,MODE_BID), " Current SL: ",  OrderStopLoss());
                     }
                  }
               } else { // OrderType() == OP_SELL
                  newSL = OrderOpenPrice() - tempValue2;
                  if (OrderOpenPrice() >= tempValue && (OrderStopLoss() == 0 || OrderStopLoss() > newSL) && !sqDoublesAreEqual(OrderSymbol(), OrderStopLoss(), newSL)) {
                     Verbose("Moving SL 2 BE for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", newSL);
                     if(!OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0)) {
                        error = GetLastError();
                        Verbose("Failed, error: ", error, " - ", ErrorDescription(error),", Ask: ", MarketInfo(symbol,MODE_ASK), ", Bid: ", MarketInfo(symbol,MODE_BID), " Current SL: ",  OrderStopLoss());
                     }
                  }
               }
            }

            // Exit After X Bars
            /*tempValue = getOrderExitAfterXBars(2000);
            if(tempValue > 0) {
               if (sqGetOpenBarsForOrder(tempValue+10) >= tempValue) {
                  Verbose("Exit After ", tempValue, "bars - closing order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber);
                  sqClosePositionAtMarket(-1);
               }
            }*/
         }
//--------- 1.03 --

         //--
         double price = OrderClosePrice();
         double profit = OrderProfit() + OrderCommission() + OrderSwap();
         get_NearestAndFarestSR(symbol, TimeFrame, price);
         //--

         MqlRates RatesBar[];
         ArraySetAsSeries(RatesBar,true);
         if(profit > 0 && CopyRates(symbol,TimeFrame,0,2,RatesBar)==2)
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

            double distance_from_pivot             = MathAbs((price - Fhr_P)*power);
            double distance_from_support           = (price - nearest_support)*power;
            double distance_from_resistance        = (nearest_resistance - price)*power;
            double distance_from_daily_pivot       = MathAbs((price - D_P)*power);
            double distance_from_daily_support     = (price - nearest_daily_support)*power;
            double distance_from_daily_resistance  = (nearest_daily_resistance - price)*power;

            double order_tp                        = OrderTakeProfit();
            double distance_from_tp                = (price - order_tp)*power;

            double order_sl                        = OrderStopLoss();
            double distance_from_sl                = (order_sl - price)*power;

            bool look_next  = true;

            //--Moving toward TP(SELL)
            if (look_next && price > order_tp && distance_from_tp > 0 && distance_from_tp <= TrailingStopPips/2 && dataHighPoints_old > 0 && (dataHighPoints_old - PointProfit) > 0 && (dataHighPoints_old - PointProfit) <= dataHighPoints_old / 4 )
            {
               sqClosePositionAtMarket(OrderLots());
               look_next = false;
            }
            //--The Price is below the Trailing Profit
            if (look_next && order_tp > price && MathAbs(distance_from_tp) > TrailingStopPips)
            {
               //--Move StopLoss to older TakeProfit
               if ((order_sl == 0 || order_sl > order_tp) && !sqDoublesAreEqual(symbol, order_sl, order_tp)) {
                  Verbose("Moving trailing stop for order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber, " to :", order_tp);
                  if(!OrderModify(OrderTicket(), OrderOpenPrice(), order_tp, 0, 0)) {
                     error = GetLastError();
                     Verbose("Failed, error: ", error, " - ", ErrorDescription(error));
                  }
               }
               look_next = false;
            }
            //--The Price is above the Stop Loss
            if (look_next && order_sl <= price && MathAbs(distance_from_sl) > TrailingStopPips/2)
            {
               sqClosePositionAtMarket(OrderLots());
               look_next = false;
            }

            double SR_Range   = (nearest_resistance - nearest_support)*power;
                   SR_Range   = (SR_Range != 0 ? SR_Range : 0.001);
            double DSR_Range  = (nearest_daily_resistance - nearest_daily_support)*power;
                   DSR_Range  = (DSR_Range != 0 ? DSR_Range : 0.001);

            //--Near/Far from the Pivot
            if( look_next && hoursSinceOpened > (TimeFrame / 60) && SR_Range >= TrailingStopPips )
            {
               double perc_dist_pivot = (distance_from_pivot*100)/SR_Range;

               if( look_next && perc_dist_pivot >= 0 && perc_dist_pivot <= TrailingStopPips)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }

               //--Near/Far from a Support or Resistance
               double perc_dist_support    = (distance_from_support*100)/SR_Range;
               double perc_dist_resistance = (distance_from_resistance*100)/SR_Range;

               if( look_next && perc_dist_support >= 0 && perc_dist_support <= TrailingStopPips/2)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }

               if( look_next && perc_dist_resistance >= 0 && perc_dist_resistance <= 25)
               {
                  //sqClosePositionAtMarket(OrderLots());
                  //look_next = false;
               }
            }

            //--Near/Far from a Daily level
            if( look_next && hoursSinceOpened > (TimeFrame / 60) && DSR_Range >= TrailingStopPips )
            {
               double perc_dist_daily_pivot      = (distance_from_daily_pivot*100)/DSR_Range;
               double perc_dist_daily_support    = (distance_from_daily_support*100)/DSR_Range;
               double perc_dist_daily_resistance = (distance_from_daily_resistance*100)/DSR_Range;

               if( look_next && perc_dist_daily_pivot >= 0 && perc_dist_daily_pivot <= TrailingStopPips)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }

               if( look_next && perc_dist_daily_support >= 0 && perc_dist_daily_support <= TrailingStopPips/2)
               {
                  sqClosePositionAtMarket(OrderLots());
                  look_next = false;
               }

               if( look_next && perc_dist_daily_resistance >= 0 && perc_dist_daily_resistance <= 10)
               {
                  //sqClosePositionAtMarket(OrderLots());
                  //look_next = false;
               }
            }
         }
      }
   }

}


//----------------------------------------------------------------------------

void manageOrderExpiration(string symbol, int orderMagicNumber) {
   int tempValue = 0;
   int barsOpen = 0;

   if(orderMagicNumber == 1000) {
      if(OrderType() != OP_BUY && OrderType() != OP_SELL) {
         // handle only pending orders

         // Stop/Limit Order Expiration
         tempValue = getOrderExpiration(symbol, 1000);
         if(tempValue > 0) {
            barsOpen = sqGetOpenBarsForOrder(symbol, tempValue+10);
            if(barsOpen >= tempValue) {
               Verbose("Order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber," expired");
               tmpRet = OrderDelete(OrderTicket());
            }
         }
      }
   }

   if(orderMagicNumber == 2000) {
      if(OrderType() != OP_BUY && OrderType() != OP_SELL) {
         // handle only pending orders

         // Stop/Limit Order Expiration
         tempValue = getOrderExpiration(symbol, 2000);
         if(tempValue > 0) {
            barsOpen = sqGetOpenBarsForOrder(symbol, tempValue+10);
            if(barsOpen >= tempValue) {
               Verbose("Order with ticket: ", OrderTicket(), ", Magic Number: ", orderMagicNumber," expired");
               tmpRet = OrderDelete(OrderTicket());
            }
         }
      }
   }

}

//+------------------------------------------------------------------+

//----------------------------------------------------------------------------

//+------------------------------------------------------------------+
//+ Japanese Candlestick Pattern Recognition
//+------------------------------------------------------------------+

/**
 * Bearish
 *   SS 2,3,4  - Shooting Star
 *   E_Star    - Evening Star
 *   E_Doji    - Evening Doji Star
 *   DCC       - Dark Cloud Pattern
 *   S_E       - Bearish Engulfing Pattern
 * Bullish
 *   HMR 2,3,4 - Bullish Hammer
 *   M_Star    - Morning Star
 *   M_Doji    - Morning Doji Star
 *   P_L       - Piercing Line Pattern
 *   L_E       - Bullish Engulfing Pattern
 */

//----------------------------------------------------------------------------

int sqGetCandlePattern(string pair, int time_frame, int shift)
{

//--- Setup
   double Range, AvgRange;
   int shift1;
   int shift2;
   int shift3;
   int shift4;
   double O, O1, O2, C, C1, C2, C3, L, L1, L2, L3, H, H1, H2, H3;
   double CL, CLmin, CL1, CL2, BL, BLa, BL90, BL1, BL2, UW, UWa, UW1, UW2, LW, LWa, LW1, LW2, BodyHigh, BodyLow;
   BodyHigh = 0;
   BodyLow = 0;
   double Doji_Star_Ratio = 0;
   double Doji_MinLength = 0;
   double Star_MinLength = 0;

   double Piercing_Line_Ratio = 0;
   int Piercing_Candle_Length = 0;
   int Engulfing_Length = 0;
   int Star_Body_Length = 5;
   double Candle_WickBody_Percent = 0;
   int CandleLength = 0;

   switch (time_frame) {
      case 1:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 10;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 5:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 10;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 15:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 0;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 30:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 15;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 60:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 25;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 240:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 20;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 1440:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 30;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 10080:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 40;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
      case 43200:
         Doji_Star_Ratio = 0;
         Piercing_Line_Ratio = 0.5;
         Piercing_Candle_Length = 10;
         Engulfing_Length = 50;
         Candle_WickBody_Percent = 0.9;
         CandleLength = 12;

         break;
   }

//---
   int AvgLength = MathMin(ResultingBars, 500);
   if(ResultingBars == 0)
      AvgLength = 500;
//---
   MqlRates RatesBar[];
   ArraySetAsSeries(RatesBar,true);
   if( shift<=AvgLength+9 && CopyRates(pair,time_frame,0,AvgLength,RatesBar)==AvgLength )
   {
      int counter=shift;
      Range=0;
      AvgRange=0;
      for (counter=shift ;counter<=shift+9;counter++) {
         AvgRange=AvgRange+MathAbs(RatesBar[counter].high-RatesBar[counter].low);
      }
      Range=AvgRange/10;
      shift1 = shift + 1;
      shift2 = shift + 2;
      shift3 = shift + 3;
      shift4 = shift + 4;


      O = RatesBar[shift1].open;
      O1 = RatesBar[shift2].open;
      O2 = RatesBar[shift3].open;
      H = RatesBar[shift1].high;
      H1 = RatesBar[shift2].high;
      H2 = RatesBar[shift3].high;
      H3 = RatesBar[shift4].high;
      L = RatesBar[shift1].low;
      L1 = RatesBar[shift2].low;
      L2 = RatesBar[shift3].low;
      L3 = RatesBar[shift4].low;
      C = RatesBar[shift1].close;
      C1 = RatesBar[shift2].close;
      C2 = RatesBar[shift3].close;
      C3 = RatesBar[shift4].close;
      if (O>C) {
         BodyHigh = O;
         BodyLow = C;  }
      else {
         BodyHigh = C;
         BodyLow = O; }
      CL = RatesBar[shift1].high-RatesBar[shift1].low;
      CL1 = RatesBar[shift2].high-RatesBar[shift2].low;
      CL2 = RatesBar[shift3].high-RatesBar[shift3].low;
      BL = RatesBar[shift1].open-RatesBar[shift1].close;
      UW = RatesBar[shift1].high-BodyHigh;
      LW = BodyLow-RatesBar[shift1].low;
      BLa = MathAbs(BL);
      BL90 = BLa*Candle_WickBody_Percent;


 // Bearish Patterns

      // Check for Bearish Shooting ShootStar
      if ((H>=H1)&&(H>H2)&&(H>H3))  {
         if (((UW/2)>LW)&&(UW>(2*BL90))&&(CL>=(CandleLength*MarketInfo(pair,MODE_POINT)))&&(O!=C)&&((UW/3)<=LW)&&((UW/4)<=LW)/*&&(L>L1)&&(L>L2)*/)
         {
            return(PATTERN_BEARISH_SS2);
         }
      }

      // Check for Bearish Shooting ShootStar
      if ((H>=H1)&&(H>H2)&&(H>H3))  {
         if (((UW/3)>LW)&&(UW>(2*BL90))&&(CL>=(CandleLength*MarketInfo(pair,MODE_POINT)))&&(O!=C)&&((UW/4)<=LW)/*&&(L>L1)&&(L>L2)*/)
         {
            return(PATTERN_BEARISH_SS3);
         }
      }

      // Check for Bearish Shooting ShootStar
      if ((H>=H1)&&(H>H2)&&(H>H3))  {
         if (((UW/4)>LW)&&(UW>(2*BL90))&&(CL>=(CandleLength*MarketInfo(pair,MODE_POINT)))&&(O!=C)/*&&(L>L1)&&(L>L2)*/)
         {
            return(PATTERN_BEARISH_SS4);
         }
      }

      // Check for Evening Star pattern
      if ((H>=H1)&&(H1>H2)&&(H1>H3))  {
         if (/*(L>O1)&&*/(BLa<(Star_Body_Length*MarketInfo(pair,MODE_POINT)))&&(C2>O2)&&(!O==C)&&((C2-O2)/(0.001+H2-L2)>Doji_Star_Ratio)/*&&(C2<O1)*/&&(C1>O1)/*&&((H1-L1)>(3*(C1-O1)))*/&&(O>C)&&(CL>=(Star_MinLength*MarketInfo(pair,MODE_POINT))))
         {
            return(PATTERN_BEARISH_E_STAR);
         }
      }

      // Check for Evening Doji Star pattern
      if ((H>=H1)&&(H1>H2)&&(H1>H3))  {
         if (/*(L>O1)&&*/(O==C)&&((C2>O2)&&(C2-O2)/(0.001+H2-L2)>Doji_Star_Ratio)/*&&(C2<O1)*/&&(C1>O1)/*&&((H1-L1)>(3*(C1-O1)))*/&&(CL>=(Doji_MinLength*MarketInfo(pair,MODE_POINT))))
         {
            return(PATTERN_BEARISH_E_DOJI);
         }
      }

      // Check for a Dark Cloud Cover pattern
      if ((C1>O1)&&(((C1+O1)/2)>C)&&(O>C)/*&&(O>C1)*/&&(C>O1)&&((O-C)/(0.001+(H-L))>Piercing_Line_Ratio)&&((CL>=Piercing_Candle_Length*MarketInfo(pair,MODE_POINT))))
      {
         return(PATTERN_BEARISH_DCC);
      }

      // Check for Bearish Engulfing pattern
      if ((C1>O1)&&(O>C)&&(O>=C1)&&(O1>=C)&&((O-C)>(C1-O1))&&(CL>=(Engulfing_Length*MarketInfo(pair,MODE_POINT))))
      {
         return(PATTERN_BEARISH_S_E);
      }

 // End of Bearish Patterns

 // Bullish Patterns

      // Check for Bullish Hammer
      if ((L<=L1)&&(L<L2)&&(L<L3))  {
         if (((LW/2)>UW)&&(LW>BL90)&&(CL>=(CandleLength*MarketInfo(pair,MODE_POINT)))&&(O!=C)&&((LW/3)<=UW)&&((LW/4)<=UW)/*&&(H<H1)&&(H<H2)*/)
         {
            return(PATTERN_BULLISH_HMR2);
         }
      }

      // Check for Bullish Hammer
      if ((L<=L1)&&(L<L2)&&(L<L3))  {
         if (((LW/3)>UW)&&(LW>BL90)&&(CL>=(CandleLength*MarketInfo(pair,MODE_POINT)))&&(O!=C)&&((LW/4)<=UW)/*&&(H<H1)&&(H<H2)*/)
         {
            return(PATTERN_BULLISH_HMR3);
         }
      }

      // Check for Bullish Hammer
      if ((L<=L1)&&(L<L2)&&(L<L3))  {
         if (((LW/4)>UW)&&(LW>BL90)&&(CL>=(CandleLength*MarketInfo(pair,MODE_POINT)))&&(O!=C)/*&&(H<H1)&&(H<H2)*/)
         {
            return(PATTERN_BULLISH_HMR4);
         }
      }

     // Check for Morning Star

      if ((L<=L1)&&(L1<L2)&&(L1<L3))  {
         if (/*(H1<(BL/2))&&*/(BLa<(Star_Body_Length*MarketInfo(pair,MODE_POINT)))&&(!O==C)&&((O2>C2)&&((O2-C2)/(0.001+H2-L2)>Doji_Star_Ratio))/*&&(C2>O1)*/&&(O1>C1)/*&&((H1-L1)>(3*(C1-O1)))*/&&(C>O)&&(CL>=(Star_MinLength*MarketInfo(pair,MODE_POINT))))
         {
            return(PATTERN_BULLISH_M_STAR);
         }
      }

      // Check for Morning Doji Star

      if ((L<=L1)&&(L1<L2)&&(L1<L3))  {
         if (/*(H1<(BL/2))&&*/(O==C)&&((O2>C2)&&((O2-C2)/(0.001+H2-L2)>Doji_Star_Ratio))/*&&(C2>O1)*/&&(O1>C1)/*&&((H1-L1)>(3*(C1-O1)))*/&&(CL>=(Doji_MinLength*MarketInfo(pair,MODE_POINT))))
         {
            return(PATTERN_BULLISH_M_DOJI);
         }
      }

      // Check for Piercing Line pattern

      if ((C1<O1)&&(((O1+C1)/2)<C)&&(O<C)/*&&(O<C1)*//*&&(C<O1)*/&&((C-O)/(0.001+(H-L))>Piercing_Line_Ratio)&&(CL>=(Piercing_Candle_Length*MarketInfo(pair,MODE_POINT))))
      {
         return(PATTERN_BULLISH_P_L);
      }

      // Check for Bullish Engulfing pattern

      if ((O1>C1)&&(C>O)&&(C>=O1)&&(C1>=O)&&((C-O)>(O1-C1))&&(CL>=(Engulfing_Length*MarketInfo(pair,MODE_POINT))))
      {
         return(PATTERN_BULLISH_L_E);
      }

 // End of Bullish Patterns

      return(PATTERN_UNDEFINED);
   }

  //-- ERROR
   return(-1);
}

//+------------------------------------------------------------------+

//----------------------------------------------------------------------------

//+------------------------------------------------------------------+
//+ Global functions
//+------------------------------------------------------------------+

//----------------------------------------------------------------------------

double getOrderPrice(string symbol, int orderMagicNumber) {
   double price = 0;

   if(orderMagicNumber == 1000) {
      price = MarketInfo(symbol, MODE_ASK);
   }
   if(orderMagicNumber == 2000) {
      price = MarketInfo(symbol, MODE_BID);
   }

   return(NormalizeDouble(price, MarketInfo(symbol,MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderSize(string symbol, int orderMagicNumber, int orderType) {
   double size = 0;
   if(orderMagicNumber == 1000) {
      size = sqMMFixedRisk(symbol, orderMagicNumber, orderType);
   }

   if(orderMagicNumber == 2000) {
      size = sqMMFixedRisk(symbol, orderMagicNumber, orderType);
   }

   return(size);
}

//----------------------------------------------------------------------------

double getOrderTrailingStop(string symbol, int timeFrame, int orderMagicNumber, int orderType) {
   double value = 0;

   //--
   double price = (orderType == OP_BUY ? MarketInfo(symbol,MODE_ASK) : MarketInfo(symbol,MODE_BID));
   get_NearestAndFarestSR(symbol, timeFrame, price);
   //--

   if(orderMagicNumber == 1000) {
      double trailingStop_value = ( TrailingStopPips * getPointCoef(symbol, orderMagicNumber));
      if(trailingStop_value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            trailingStop_value = MarketInfo(symbol, MODE_BID) - trailingStop_value;
         } else {
            trailingStop_value = MarketInfo(symbol, MODE_ASK) + trailingStop_value;
         }
      }

      double nearestSR_value = MathMin(nearest_support, nearest_daily_support) - (MarketInfo(symbol,MODE_STOPLEVEL)*MarketInfo(symbol,MODE_POINT));

      value = MathMax(trailingStop_value, nearestSR_value);
   }

   if(orderMagicNumber == 2000) {
      double trailingStop_value = ( TrailingStopPips * getPointCoef(symbol, orderMagicNumber));
      if(trailingStop_value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            trailingStop_value = MarketInfo(symbol, MODE_BID) - trailingStop_value;
         } else {
            trailingStop_value = MarketInfo(symbol, MODE_ASK) + trailingStop_value;
         }
      }

      double nearestSR_value = MathMax(nearest_resistance, nearest_daily_resistance) + (MarketInfo(symbol,MODE_STOPLEVEL)*MarketInfo(symbol,MODE_POINT));

      value = MathMin(trailingStop_value, nearestSR_value);
   }

   return(NormalizeDouble(value, MarketInfo(symbol, MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderTrailingStopActivation(string symbol, int orderMagicNumber, int addPips) {
   double value = 0;

   if(orderMagicNumber == 1000) {
      value = ( addPips * getPointCoef(symbol, orderMagicNumber));
   }

   if(orderMagicNumber == 2000) {
      value = ( addPips * getPointCoef(symbol, orderMagicNumber));
   }

   return(NormalizeDouble(value, MarketInfo(symbol, MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderBreakEven(string symbol, int orderMagicNumber, int orderType, double price, int addPips) {
   double value = 0;

   if(orderMagicNumber == 1000) {
      value = ( addPips * getPointCoef(symbol, orderMagicNumber));
      if(value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            value = MarketInfo(symbol, MODE_BID) - value;
         } else {
            value = MarketInfo(symbol, MODE_ASK) + value;
         }
      }

   }

   if(orderMagicNumber == 2000) {
      value = ( addPips * getPointCoef(symbol, orderMagicNumber));
      if(value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            value = MarketInfo(symbol, MODE_BID) - value;
         } else {
            value = MarketInfo(symbol, MODE_ASK) + value;
         }
      }

   }


   return(NormalizeDouble(value, MarketInfo(symbol, MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderBreakEvenAddPips(string symbol, int orderMagicNumber, int addPips) {
   double value = 0;

   if(orderMagicNumber == 1000) {
      value = ( addPips * getPointCoef(symbol, orderMagicNumber));
   }

   if(orderMagicNumber == 2000) {
      value = ( addPips * getPointCoef(symbol, orderMagicNumber));
   }


   return(NormalizeDouble(value, MarketInfo(symbol, MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderExpiration(string symbol, int orderMagicNumber) {
   double price = 0;

   if(orderMagicNumber == 1000) {
      price = 0;
   }

   if(orderMagicNumber == 2000) {
      price = 0;
   }


   return(NormalizeDouble(price, MarketInfo(symbol, MODE_DIGITS)));
}

//+------------------------------------------------------------------+

double getOrderExitAfterXBars(string symbol, int orderMagicNumber) {
   double price = 0;

   if(orderMagicNumber == 1000) {
      price = 0;
   }

   if(orderMagicNumber == 2000) {
      price = 0;
   }


   return(NormalizeDouble(price, MarketInfo(symbol, MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getStopDifferencePrice(string symbol, int orderMagicNumber) {
   double price = 0;

   if(orderMagicNumber == 1000) {
      price = 0;
   }

   if(orderMagicNumber == 2000) {
      price = 0;
   }


   return(NormalizeDouble(price, MarketInfo(symbol,MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderStopLoss(string symbol, int orderMagicNumber, int orderType, double price) {
   double value = 0;

   if(orderMagicNumber == 1000) {
      value = 1.5 * iATR(NULL, 0, 14 ,1)+ sqConvertToRealPips(symbol, 15);
      if(value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            value = price - value;
         } else {
            value = price + value;
         }
      }
   }

   if(orderMagicNumber == 2000) {
      value = 1.5 * iATR(NULL, 0, 14 ,1)+ sqConvertToRealPips(symbol, 15);
      if(value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            value = price - value;
         } else {
            value = price + value;
         }
      }
   }

   return(NormalizeDouble(value, MarketInfo(symbol,MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getOrderProfitTarget(string symbol, int orderMagicNumber, int orderType, double price) {
   double value = 0;

   if(orderMagicNumber == 1000) {
      value = 3 * iATR(NULL, 0, 14 ,1);
      if(value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            value = price + value;
         } else {
            value = price - value;
         }
      }

   }

   if(orderMagicNumber == 2000) {
      value = 3 * iATR(NULL, 0, 14 ,1);
      if(value > 0) {
         if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
            value = price + value;
         } else {
            value = price - value;
         }
      }

   }

   return(NormalizeDouble(value, MarketInfo(symbol,MODE_DIGITS)));
}

//----------------------------------------------------------------------------

double getPointCoef(string symbol, int orderMagicNumber) {
   double coef = 0;
   double rDigits, pointPow;

   if(orderMagicNumber == 1000) {
      rDigits = MarketInfo(symbol, MODE_DIGITS);
      if(rDigits > 0 && rDigits != 2 && rDigits != 4) {
         rDigits -= 1;
      }

      pointPow = MathPow(10, rDigits);
      coef = 1/pointPow;
   }
   if(orderMagicNumber == 2000) {
      rDigits = MarketInfo(symbol, MODE_DIGITS);
      if(rDigits > 0 && rDigits != 2 && rDigits != 4) {
         rDigits -= 1;
      }

      pointPow = MathPow(10, rDigits);
      coef = 1/pointPow;
   }

   return(coef);
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

double sqSafeDivide(double var1, double var2) {
   if(var2 == 0) return(10000000);
   return(var1/var2);
}

//----------------------------------------------------------------------------

datetime sqGetTime(int hour, int minute, int second) {
   // StrToTime works only on a current date, for previous dates it should be used like this:
   string str = TimeToStr(TimeCurrent(), TIME_DATE)+ " " +hour+ ":" + minute;
   datetime time2 =  StrToTime(str)+second;
   return(time2);
}

//+------------------------------------------------------------------+

int sqGetBarsSinceExit(string symbol, int orderMagicNumber) {

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true) {

         if(OrderMagicNumber() == orderMagicNumber && OrderSymbol() == symbol) {
            return (sqGetBarsFromOrderClose(symbol, 1000));
         }
      }
   }

   return(-1);
}

//+------------------------------------------------------------------+

int sqGetOpenBarsForOrder(string symbol, int expBarsPeriod) {
   datetime opTime = OrderOpenTime();

   int numberOfBars = 0;
   for(int i=0; i<expBarsPeriod+10; i++) {
      if(opTime < iTime(symbol,Period(),i)) {
         numberOfBars++;
      }
   }

   return(numberOfBars);
}

//+------------------------------------------------------------------+

int sqGetOrdersOpenedToday(string symbol, int direction, string includePending) {
   string todayTime = TimeToStr( TimeCurrent(), TIME_DATE);
   int tradesOpenedToday = 0;

   for(int i=0;i<OrdersHistoryTotal();i++) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {

         if(direction == 1) {
            if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) {
               // skip short orders
               continue;
            }
         } else if(direction == -1) {
            if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) {
               // skip long orders
               continue;
            }
         }

         if(includePending == "false") {
            if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) {
               // skip pending orders
               continue;
            }
         }

         if(TimeToStr( OrderOpenTime(), TIME_DATE) == todayTime) {
            tradesOpenedToday++;
         }
      }
   }

   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (OrderSelect(cc, SELECT_BY_POS) && OrderSymbol() == symbol) {

         if(direction == 1) {
            if(OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) {
               // skip short orders
               continue;
            }
         } else if(direction == -1) {
            if(OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) {
               // skip long orders
               continue;
            }
         }

         if(includePending == "false") {
            if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) {
               // skip pending orders
               continue;
            }
         }

         if(TimeToStr( OrderOpenTime(), TIME_DATE) == todayTime) {
            tradesOpenedToday++;
         }
      }
   }

   return(tradesOpenedToday);
}

//+------------------------------------------------------------------+

int sqGetLastOrderType(string symbol) {
   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(OrderType() == OP_BUY) {
            return(1);
         }
         if(OrderType() == OP_SELL) {
            return(-1);
         }
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

int sqGetLastOrderTodayType(string symbol) {
   string todayTime = TimeToStr( TimeCurrent(), TIME_DATE);

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(TimeToStr( OrderOpenTime(), TIME_DATE) != todayTime) {
            continue;
         }

         if(OrderType() == OP_BUY) {
            return(1);
         }
         if(OrderType() == OP_SELL) {
            return(-1);
         }
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

bool sqOrderOpenedThisBar(string symbol, int orderMagicNumber) {
   double pl = 0;

   for(int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderOpenTime() > Time[1]) {
               return(true);
            }
         }
      }
   }

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderOpenTime() > Time[1]) {
               return(true);
            }
         }
      }
   }


   return(false);
}

//+------------------------------------------------------------------+

bool sqOrderClosedThisBar(string symbol, int orderMagicNumber) {
   double pl = 0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderCloseTime() > Time[1]) {
               return(true);
            }
         }
      }
   }

   return(false);
}

//+------------------------------------------------------------------+

bool sqOrderOpenedThisMinute(string symbol, int orderMagicNumber) {
   datetime timeCandle = TimeCurrent() - 60; //iTime(NULL, PERIOD_M1, 1);

   for(int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i,SELECT_BY_POS)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderOpenTime() >= timeCandle) {
               return(true);
            }
         }
      }
   }

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderOpenTime() >= timeCandle) {
               return(true);
            }
         }
      }
   }

   return(false);
}

//+------------------------------------------------------------------+

bool sqOrderClosedThisMinute(string symbol, int orderMagicNumber) {
   datetime timeCandle = TimeCurrent() - 60; //iTime(NULL, PERIOD_M1, 1);

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderCloseTime() >= timeCandle) {
               return(true);
            }
         }
      }
   }

   return(false);
}

//+------------------------------------------------------------------+

double sqGetAngle(double value1, double value2, int period, double coef) {
   double diff = value1 - value2;

   double fAngleRad = MathArctan(diff / (coef*period));
   double PI =  3.141592654;

   double fAngleDegrees = (fAngleRad * 180) / PI;

   return((fAngleDegrees));
}

//+------------------------------------------------------------------+

string sqGetOrderSymbol(string symbol, int orderMagicNumber) {
   datetime timeCandle = TimeCurrent() - 60; //iTime(NULL, PERIOD_M1, 1);

   for(int i=OrdersHistoryTotal(); i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol() == symbol) {
         if(orderMagicNumber == 0 || OrderMagicNumber() == orderMagicNumber) {
            if(OrderCloseTime() >= timeCandle) {
               return(OrderSymbol());
            }
         }
      }
   }

   return("");
}

//+------------------------------------------------------------------+

string sqGetPeriodAsStr() {
   string str = TimeToStr(Time[0], TIME_DATE);
   int period = Period();

   if(period == PERIOD_H4 || period == PERIOD_H1) {
      str = str + TimeHour(Time[0]);
   }
   if(period == PERIOD_M30 || period == PERIOD_M15 || period == PERIOD_M5 || period == PERIOD_M1) {
      str = str + " " + TimeToStr(Time[0], TIME_MINUTES);
   }

   return(str);
}

//+------------------------------------------------------------------+

string sqGetTimeFrameAsStr(int time_frame) {
   string str = "";

   switch( time_frame )
   {
      case PERIOD_M1:
         str = "M1";
         break;
      case PERIOD_M5:
         str = "M5";
         break;
      case PERIOD_M15:
         str = "M15";
         break;
      case PERIOD_M30:
         str = "M30";
         break;
      case PERIOD_H1:
         str = "H1";
         break;
      case PERIOD_H4:
         str = "H4";
         break;
      case PERIOD_D1:
         str = "D1";
         break;
      case PERIOD_W1:
         str = "W1";
         break;
      case PERIOD_MN1:
         str = "MN1";
         break;
   }

   return(str);
}

//+------------------------------------------------------------------+

string sqGetOrderTypeAsString(int type) {
   switch(type) {
      case OP_BUY: return("Buy");
      case OP_SELL: return("Sell");
      case OP_BUYLIMIT: return("Buy Limit");
      case OP_BUYSTOP: return("Buy Stop");
      case OP_SELLLIMIT: return("Sell Limit");
      case OP_SELLSTOP: return("Sell Stop");
   }

   return("Unknown");
}

//+------------------------------------------------------------------+

int sqGetBarsFromOrderOpen(string symbol, int expBarsPeriod) {
   datetime opTime = OrderOpenTime();

   int numberOfBars = 0;
   for(int i=0; i<expBarsPeriod+10; i++) {
      if(opTime < Time[i]) {
         numberOfBars++;
      }
   }

   return(numberOfBars);
}

//+------------------------------------------------------------------+

int sqGetBarsFromOrderClose(string symbol, int expBarsPeriod) {
   datetime clTime = OrderCloseTime();

   int numberOfBars = 0;
   for(int i=0; i<expBarsPeriod+10; i++) {
      if(clTime < Time[i]) {
         numberOfBars++;
      }
   }

   return(numberOfBars);
}

//+------------------------------------------------------------------+

int sqGetMarketPosition(string symbol) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (OrderSelect(cc, SELECT_BY_POS) && OrderSymbol() == symbol) {

         if(OrderType() == OP_BUY) {
            return(1);
         }
         if(OrderType() == OP_SELL) {
            return(-1);
         }
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

double sqGetOrderPosition(string symbol, int orderMagicNumber) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if(OrderSymbol() == symbol && OrderMagicNumber() == orderMagicNumber) {
         if(OrderType() == OP_BUY) {
            return(1);
         }
         if(OrderType() == OP_SELL) {
            return(-1);
         }
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

double sqGetOpenPrice(string symbol, int orderMagicNumber) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if((orderMagicNumber == 0 && OrderSymbol() == symbol) || OrderMagicNumber() == orderMagicNumber) {
         return(OrderOpenPrice());
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

double sqGetOrderStopLoss(string symbol, int orderMagicNumber) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if(OrderMagicNumber() == orderMagicNumber && OrderSymbol() == symbol) {
         return(OrderStopLoss());
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

double sqGetOrderProfitTarget(string symbol, int orderMagicNumber) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if(OrderMagicNumber() == orderMagicNumber && OrderSymbol() == symbol) {
         return(OrderTakeProfit());
      }
   }

   return(0);
}

//+------------------------------------------------------------------+

void sqDeletePendingOrder(string symbol, int orderMagicNumber) {
   for(int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i,SELECT_BY_POS)==true) {
         if(OrderMagicNumber() == orderMagicNumber && OrderSymbol() == symbol) {
            tmpRet = OrderDelete(OrderTicket());
            return;
         }
      }
   }
}

//+------------------------------------------------------------------+

bool sqLiveOrderExists(string symbol, int orderMagicNumber) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if(OrderMagicNumber() == orderMagicNumber && OrderSymbol() == symbol) return(true);
   }

   return(false);
}

//+------------------------------------------------------------------+

bool sqPendingOrderExists(string symbol, int orderMagicNumber) {
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if(OrderMagicNumber() != orderMagicNumber && OrderSymbol() != symbol) continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL) continue;

      return(true);
   }

   return(false);
}

//----------------------------------------------------------------------------

bool getReplaceStopLimitOrder(int orderMagicNumber) {
   bool value = false;

   if(orderMagicNumber == 1000) {
      value = 0;
   }

   if(orderMagicNumber == 2000) {
      value = 0;
   }

   return(value);
}

//+------------------------------------------------------------------+

double sqGetOrdersAveragePrice(string symbol, int orderMagicNumber) {
   double sum = 0.0;
   double cnt = 0.0;
   for (int cc = OrdersTotal() - 1; cc >= 0; cc--) {
      if (!OrderSelect(cc, SELECT_BY_POS) ) continue;
      if(OrderMagicNumber() == orderMagicNumber && OrderSymbol() == symbol) {
         if(OrderType() == OP_BUY && OrderCloseTime() == 0) {
            sum += OrderLots() * OrderOpenPrice ();
            cnt += OrderLots();
         }
         if(OrderType() == OP_SELL && OrderCloseTime() == 0) {
            sum += OrderLots() * OrderOpenPrice ();
			   cnt += OrderLots();
         }
      }
   }

   if (NormalizeDouble (cnt, MarketInfo(symbol,MODE_DIGITS)) == 0) return (0);

   return(sum / cnt);
}

//+------------------------------------------------------------------+

double sqGetIf (string symbol, double condition, double val1, double val2) {
	if (NormalizeDouble(condition, MarketInfo(symbol,MODE_DIGITS)) > 0) return (val1);
	return (val2);
}

//+------------------------------------------------------------------+

double sqRound(double value, int digits) {
   double pow = MathPow(10, digits);
   return(MathRound(value * pow) / pow);
}

//+------------------------------------------------------------------+

double sqGetAsk(string symbol) {
   if(symbol == "NULL") {
      return(MarketInfo(symbol,MODE_ASK));
   } else {
      return(MarketInfo(symbol,MODE_ASK));
   }
}

//+------------------------------------------------------------------+

double sqGetBid(string symbol) {
   if(symbol == "NULL") {
      return(MarketInfo(symbol, MODE_BID));
   } else {
      return(MarketInfo(symbol,MODE_BID));
   }
}

//+------------------------------------------------------------------+

bool sqDoublesAreEqual(string symbol, double n1, double n2) {
   string s1 = DoubleToStr(n1, MarketInfo(symbol, MODE_DIGITS));
   string s2 = DoubleToStr(n2, MarketInfo(symbol, MODE_DIGITS));

   return (s1 == s2);
}

//+------------------------------------------------------------------+

int sqIsTradeAllowed(int MaxWaiting_sec = 30) {
    // check whether the trade context is free
    if(!IsTradeAllowed()) {
        int StartWaitingTime = GetTickCount();
        Print("Trade context is busy! Wait until it is free...");
        // infinite loop
        while(true) {
            // if the expert was terminated by the user, stop operation
            if(IsStopped()) {
                Print("The expert was terminated by the user!");
                return(-1);
            }
            // if the waiting time exceeds the time specified in the
            // MaxWaiting_sec variable, stop operation, as well
            int diff = GetTickCount() - StartWaitingTime;
            if(diff > MaxWaiting_sec * 1000) {
                Print("The waiting limit exceeded (" + MaxWaiting_sec + " ???.)!");
                return(-2);
            }
            // if the trade context has become free,
            if(IsTradeAllowed()) {
                Print("Trade context has become free!");
                RefreshRates();
                return(1);
            }
            // if no loop breaking condition has been met, "wait" for 0.1
            // second and then restart checking
            Sleep(100);
          }
    } else {
        //Print("Trade context is free!");
        return(1);
    }

    return(1);
}

//+------------------------------------------------------------------+

int sqOpenOrderWithErrorHandling(string symbol, int orderType, double orderLots, double price, double realSL, double realPT, string comment, int orderMagicNumber) {
   int ticket, error;

   Verbose("Sending order...");
   double sl = realSL;
   double pt = realPT;
   if(SupportECNBrokers) {
      sl = 0;
      pt = 0;
   }

   ticket = OrderSend(symbol, orderType, orderLots, price, MaxSlippage, sl, pt, comment, orderMagicNumber);

   if(ticket < 0) {
      // order failed, write error to log
      error = GetLastError();
      Verbose("Order failed, error: ", error);
      return(-1*error);
   }

   tmpRet = OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);

   Log("Order opened with ticket: ", OrderTicket(), " at price:", OrderOpenPrice());
   VerboseLog("Order with Magic Number: ",orderMagicNumber," opened with ticket: ", OrderTicket(), " at price:", OrderOpenPrice());

   if(SupportECNBrokers) {
      // set up stop loss and profit target
      // it has to be done separately to support ECN brokers

      int retries = 3;
      while(true) {
         retries--;
         if(retries < 0) return(0);

         if((realSL == 0 && realPT == 0) || (OrderStopLoss() == realSL && OrderTakeProfit() == realPT)) {
            return(ticket);
         }

         if(sqIsTradeAllowed() == 1) {
            Verbose("Setting SL/PT, try #", 3-retries);
            if(sqSetSLPTForOrder(ticket, realSL, realPT, orderMagicNumber, orderType, price, symbol, retries, CloseAtError)) {
               return(ticket);
            }
            if(retries == 0) {
               // there was eror setting SL/PT and order was deleted
               return(-11111);
            }
         }

         Sleep(1000);
      }

      Verbose("Retries of setting SL/PT order finished unsuccessfuly", " ----------------");
      return(-1);
   }

   return(ticket);
}

//+------------------------------------------------------------------+

bool sqSetSLPTForOrder(int ticket, double realSL, double realPT, int orderMagicNumber, int orderType, double price, string symbol, int retries, bool closeAtError) {
   Verbose("Setting SL: ", realSL, " and PT: ", realPT, " for order with ticket ", ticket);

   if( OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES) )
   {
      if(OrderModify(ticket, OrderOpenPrice(), realSL, realPT, 0, 0)) {
         VerboseLog("Order updates, StopLoss: ", realSL,", Profit Target: ", realPT);
         return(true);
      } else {
         int error = GetLastError();
         VerboseLog("Error modifying order with ticket("+ticket+") - error #",error, " : ", ErrorDescription(error));
         VerboseLog("Order Details - Type: "+sqGetOrderTypeAsString(OrderType())+", OpenPrice: "+OrderOpenPrice()+", SL: "+OrderStopLoss()+", TP: "+OrderTakeProfit());
         VerboseLog("Order Modify Bid: "+MarketInfo(symbol, MODE_BID)+", Ask: "+MarketInfo(symbol, MODE_ASK)+", NewSL: "+realSL+", NewTP: "+realPT);

         if(retries == 0 && closeAtError) {
            // when it is last unsuccessful retry, it tries to close the order
            RefreshRates();
            sqClosePositionAtMarket(-1);
            lastOrderErrorCloseTime = TimeCurrent();
         }
         return(false);
      }

      return(true);
   }

   return(false);
}

//+------------------------------------------------------------------+

bool sqClosePositionAtMarket(double size) {
   Verbose("Closing order with Magic Number: ", OrderMagicNumber(), ", ticket: ", OrderTicket(), " at market price");

   int error;

   int retries = 3;
   while(true) {
      retries--;
      if(retries < 0) return(false);

      if(sqIsTradeAllowed() == 1) {
         Verbose("Closing retry #", 3-retries);
         if(sqClosePositionWithHandling(size)) {
            // trade successfuly closed
            Verbose("Order with Magic Number: ", OrderMagicNumber(), ", ticket: ", OrderTicket(), " successfuly closed");
            return(true);
         } else {
            error = GetLastError();
            Verbose("Closing order failed, error: ", error," - ", ErrorDescription(error));
         }
      }

      Sleep(500);
   }

   return(false);
}

//+------------------------------------------------------------------+

bool sqClosePositionWithHandling(double size) {
   RefreshRates();
   double priceCP;

   if(OrderType() != OP_BUY && OrderType() != OP_SELL) {
     return(true);
   }

   if(OrderType() == OP_BUY) {
      priceCP = sqGetBid(OrderSymbol());
   } else {
      priceCP = sqGetAsk(OrderSymbol());
   }

   if(size <= 0) {
      Verbose("Closing Market price: ", priceCP, ", closing size: ", OrderLots());
      return(OrderClose(OrderTicket(), OrderLots(), priceCP, MaxSlippage));
   } else {
      Verbose("Closing Market price: ", priceCP, ", closing size: ", size);
      return(OrderClose(OrderTicket(), size, priceCP, MaxSlippage));
   }
}

//+------------------------------------------------------------------+

bool sqOpenOrder(string symbol, int orderType, double orderLots, double price, double realSL, double realPT, string comment, int orderMagicNumber, string ruleName) {
   int ticket;

   Verbose("Opening order with MagicNumber: ", orderMagicNumber,", type: ", sqGetOrderTypeAsString(orderType), ", price: ", price,", lots: ", orderLots, ", comment: ", comment, " ----------------");
   Verbose("Current Ask: ", MarketInfo(symbol,MODE_ASK), ", Bid: ", MarketInfo(symbol,MODE_BID));

   if(TimeCurrent() - lastOrderErrorCloseTime < 600) {
      return(false);
      Verbose("There was error placing order less that a minute ago, waiting with another order!");
   }

   if(sqLiveOrderExists(symbol, orderMagicNumber)) {
      Verbose("Order with magic number: ", orderMagicNumber, " already exists, cannot open another one!");
      Verbose("----------------------------------");
      return(false);
   }

   if(sqPendingOrderExists(symbol, orderMagicNumber)) {
      if(!getReplaceStopLimitOrder(orderMagicNumber)) {
         Verbose("Pending Order with magic number: ", orderMagicNumber, " already exists, and replace is not allowed!", " ----------------");
         return(false);
      }

      // close pending order
      Verbose("Deleting previous pending order");
      sqDeletePendingOrder(symbol, orderMagicNumber);
   }

   RefreshRates();
   if(orderType == OP_BUYSTOP || orderType == OP_SELLSTOP) {
      double AskOrBid;
      if(orderType == OP_BUYSTOP) { AskOrBid = sqGetAsk(symbol); } else { AskOrBid = sqGetBid(symbol); }

      // check if stop/limit price isn't too close
      if(NormalizeDouble(MathAbs(price - AskOrBid), MarketInfo(symbol,MODE_DIGITS)) <= NormalizeDouble(getStopDifferencePrice(symbol,orderMagicNumber)/sqGetPointPow(symbol), MarketInfo(symbol,MODE_DIGITS))) {
         Verbose("Stop/limit order is too close to actual price", " ----------------");
         return(false);
      }
   }

   if( realSL == 0 ) realSL = getOrderStopLoss(symbol, orderMagicNumber, orderType, price);
   if( realPT == 0 ) realPT = getOrderProfitTarget(symbol, orderMagicNumber, orderType, price);

   int retries = 3;
   while(true) {
      retries--;
      if(retries < 0) return(0);
      if(sqGetOrderPosition(symbol, orderMagicNumber) != 0) {
         Verbose("Order already opened", " ----------------");
         return(0);
      }

      if(sqIsTradeAllowed() == 1) {
         Verbose("Opening, try #", 3-retries);
         ticket = sqOpenOrderWithErrorHandling(symbol, orderType, orderLots, price, realSL, realPT, comment, orderMagicNumber);
         if(ticket > 0) {
            // trade successfuly opened
            Verbose("Trade successfuly opened", " ----------------");
            ObjectSetText("lines", "Last Signal: "+ruleName, 8, "Tahoma", White);
            OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES);

            return(true);
         }
      }

      if(ticket == -130) {
         Verbose("Invalid stops, cannot open the trade", " ----------------");
         return(false);
      }

      if(ticket == -131) {
         // invalid volume, we cannot open the trade
         Verbose("Invalid volume, cannot open the trade", " ----------------");
         return(false);
      }

      if(ticket == -11111) {
         Verbose("Trade opened, but cannot set SL/PT, closing trade", " ----------------");
         return(false);
      }

      Sleep(1000);
   }

   Verbose("Retries of opening order finished", " ----------------");
   return(false);
}

//+------------------------------------------------------------------+
//+ Money Management functions
//+------------------------------------------------------------------+

double sqMMGetOrderStopLossDistance(string symbol, int orderMagicNumber, int orderType) {
   double openPrice = getOrderPrice(symbol, orderMagicNumber);
   double slSize = getOrderStopLoss(symbol, orderMagicNumber, orderType, openPrice);

   if(slSize == 0) return(0);

   if(orderType == OP_BUY || orderType == OP_BUYSTOP || orderType == OP_BUYLIMIT) {
      return(openPrice - slSize);
   } else {
      return(slSize - openPrice);
   }
}

double sqMMFixedRisk(string symbol, int orderMagicNumber, int orderType) {
   Verbose("Computing Money Management for order with Magic Number: ", orderMagicNumber," - fixed risk");

   double slSize = sqMMGetOrderStopLossDistance(symbol, orderMagicNumber, orderType) * sqGetPointPow(symbol);
   if(slSize <= 0) {
      Verbose("Computing Money Management - Stop Loss is zero, using Lots if no MM: ", LotsIfNoMM);

      double LOT = LotsIfNoMM;
      if(LotStepEnable)
      {
         double stepValue = ((AccountBalance()-LotStepFrom)/LotStepEvery)*LotStepValue ;
         double lotStepValue = NormalizeDouble( ( stepValue - MathMod(stepValue, LotStepValue) ) , LotsDecimals );

         LOT += lotStepValue;
      }

      return(LOT);
   }

   double _riskInPercent = RiskInPercent;
   double _lotsDecimals = LotsDecimals;
   double _maximumLots = MaximumLots;

   if(_riskInPercent <= 0) {
      Verbose("Computing Money Management - Risk In Percent is zero, using Lots if no MM: ", LotsIfNoMM);

      double LOT = LotsIfNoMM;
      if(LotStepEnable)
      {
         double stepValue = ((AccountBalance()-LotStepFrom)/LotStepEvery)*LotStepValue ;
         double lotStepValue = NormalizeDouble( ( stepValue - MathMod(stepValue, LotStepValue) ) , LotsDecimals );

         LOT += lotStepValue;
      }

      return(LOT);
   }

   string _baseCurrency = StringSubstr(symbol,0,3) + "USD" + PairSuffix;
   /*double _exchRate = (MarketInfo(_baseCurrency, MODE_BID) != EMPTY_VALUE && MarketInfo(_baseCurrency, MODE_BID) != 0
                        ? (1/MarketInfo(_baseCurrency, MODE_BID)) : BaseCurrencyExChgUSD);*/
   double _exchRate = (1/MarketInfo(symbol, MODE_BID));

   if(_riskInPercent < 0 ) {
      Verbose("Computing Money Management - Incorrect RiskInPercent size, it must be above 0");
      return(0);
   }

   double riskPerTrade = (_exchRate * AccountBalance() *  (_riskInPercent / Leverage));
   if(slSize <= 0) {
      Verbose("Computing Money Management - Incorrect StopLossPips size, it must be above 0");
      return(0);
   }
   Verbose("Risk per trade: ", riskPerTrade);

   Verbose("Computing Money Management - SL: ", slSize, ", Account Balance: ", AccountBalance(),", Tick value: ", MarketInfo(symbol, MODE_TICKVALUE),", Point: ", MarketInfo(symbol, MODE_POINT), ", Lot size: ", MarketInfo(symbol, MODE_LOTSIZE),", Tick size: ", MarketInfo(symbol, MODE_TICKSIZE));
   double tickValue = MarketInfo(symbol,MODE_TICKVALUE);

   double lossPerTick = riskPerTrade / slSize;
   Verbose("Computed lossPerTick: ",lossPerTick);
   double lossPerTick2 = lossPerTick;
   if(MarketInfo(symbol,MODE_DIGITS) == 1 || MarketInfo(symbol,MODE_DIGITS) == 3 || MarketInfo(symbol,MODE_DIGITS) == 5) {
      lossPerTick2 = 0.1 * lossPerTick;
   }
   Verbose("Computing: LossPerTick: ",lossPerTick, ", LossPerTick2: ",lossPerTick2);

   double lotMM1 = lossPerTick2;
   if(tickValue < 10) {
      lotMM1 /= MarketInfo(symbol,MODE_TICKVALUE);
   }
   Verbose("Computing Money Management - precomputed lots: ", lotMM1);

   double lotMM;
   double lotStep = MarketInfo(symbol, MODE_LOTSTEP);
   if(MathMod(lotMM*100, lotStep*100) > 0) {
      lotMM = lotMM1 - MathMod(lotMM1, lotStep);
   } else {
      lotMM = lotMM1;
   }

   lotMM = NormalizeDouble( lotMM, _lotsDecimals);

   if(MarketInfo(symbol, MODE_LOTSIZE)==10000.0) lotMM=lotMM*10;
   lotMM=NormalizeDouble(lotMM,_lotsDecimals);

   double Smallest_Lot = MarketInfo(symbol, MODE_MINLOT);
   double Largest_Lot = MarketInfo(symbol, MODE_MAXLOT);

   if(LotStepEnable)
   {
      double stepValue = ((AccountBalance()-LotStepFrom)/LotStepEvery)*LotStepValue ;
      double lotStepValue = NormalizeDouble( ( stepValue - MathMod(stepValue, LotStepValue) ) , LotsDecimals );

      lotMM += lotStepValue;
   }

   if (lotMM < Smallest_Lot) lotMM = Smallest_Lot;
   if (lotMM > Largest_Lot) lotMM = Largest_Lot;

   if(lotMM > _maximumLots) {
      lotMM = _maximumLots;
   }

   Verbose("Computing Money Management - final computed lots: ", lotMM);
   return (lotMM);
}

//+------------------------------------------------------------------+

void Verbose(string s1, string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="" ) {
   if(VerboseMode == 1) {
      // log to standard log
      Print("---VERBOSE--- ", TimeToStr(TimeCurrent()), " ", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);

   } else if(VerboseMode == 2) {
      // log to special file
      int handle = FileOpen("EAW_VerboseLog.txt", FILE_READ | FILE_WRITE);
      if(handle>0) {
         FileSeek(handle,0,SEEK_END);
         FileWrite(handle, TimeToStr(TimeCurrent()), " VERBOSE: ", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
         FileClose(handle);
      }
   }
}

//+------------------------------------------------------------------+

void VerboseLog(string s1, string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="" ) {
   if(VerboseMode != 1) {
      Log(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
   }

   Verbose(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
}

//----------------------------------------------------------------------------

void Log(string s1, string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="" ) {
   Print(TimeToStr(TimeCurrent()), " ", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
}


//+------------------------------------------------------------------+

void LogToFile(string fileName, string s1, string s2="", string s3="", string s4="", string s5="", string s6="", string s7="", string s8="", string s9="", string s10="", string s11="", string s12="" ) {
   int handle = FileOpen(fileName, FILE_READ | FILE_WRITE, ";");
   if(handle>0) {
      FileSeek(handle,0,SEEK_END);
      FileWrite(handle, TimeToStr(TimeCurrent()), " ", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
      FileClose(handle);
   }
}
//+------------------------------------------------------------------+
//+-----  INDICATORS                                           ------+
//+------------------------------------------------------------------+

double i_TSRLine(string sig_currency, int sig_timeFrame, string indexLabel, int period, int method, int price, int indexBuffer, int shiftBuffer) {

   MqlRates RatesBarTSR[];
   ArraySetAsSeries(RatesBarTSR,true);

   //---- buffers
   double Uptrend[];
   double Dntrend[];
   double ExtMapBuffer[];

   ArrayResize(Uptrend, Nbars);
   ArraySetAsSeries(Uptrend, true);
   ArrayResize(Dntrend, Nbars);
   ArraySetAsSeries(Dntrend, true);
   ArrayResize(ExtMapBuffer, Nbars);
   ArraySetAsSeries(ExtMapBuffer, true);

   if( signalCounter == 0 && CopyRates(sig_currency,sig_timeFrame,0,Nbars+period,RatesBarTSR)==Nbars+period )
   {
      int x = 0;
      int p = MathSqrt(2*period);
      int e = Nbars;

      double vect[], trend[];

      ArrayResize(vect, e);
      ArraySetAsSeries(vect, true);
      ArrayResize(trend, e);
      ArraySetAsSeries(trend, true);

      for(x = 0; x < e; x++)
      {
         //vect[x] = 2*WMA(Pair, TimeFrame, x, period/2, method, price) - WMA(Pair, TimeFrame, x, period, method, price);
         vect[x] = 2*iMA(sig_currency,sig_timeFrame, period, 0, method, price, x) - iMA(sig_currency,sig_timeFrame, 2*period, 0, method, price, x);
      }

      for(x = 0; x < e; x++) ExtMapBuffer[x] = iMAOnArray(vect, 0, p, 0, method, x);

      for(x = e-2; x >= 0; x--)
      {
         trend[x] = trend[x+1];
         if (ExtMapBuffer[x]> ExtMapBuffer[x+1]) trend[x] =1;
         if (ExtMapBuffer[x]< ExtMapBuffer[x+1]) trend[x] =-1;

         if (trend[x]>0)
         {
            Uptrend[x] = ExtMapBuffer[x];
            if (trend[x+1]<0) Uptrend[x+1]=ExtMapBuffer[x+1];
            Dntrend[x] = EMPTY_VALUE;
         }
         else if (trend[x]<0)
         {
            Dntrend[x] = ExtMapBuffer[x];
            if (trend[x+1]>0) Dntrend[x+1]=ExtMapBuffer[x+1];
            Uptrend[x] = EMPTY_VALUE;
         }

      }
   }

   switch(indexBuffer) {
   case 0:
      return Uptrend[shiftBuffer];
   case 1:
      return Dntrend[shiftBuffer];
   default:
      return EMPTY_VALUE;
   }

}

//+------------------------------------------------------------------+

double i_hama(string sig_currency, int sig_timeFrame, string indexLabel, int indexBuffer, int shiftBuffer) {

   //---- buffers
   int MaMetod  = 1;
   int MaPeriod = 20;
   //---- buffers
   double ExtMapBuffer1[];
   double ExtMapBuffer2[];
   double ExtMapBuffer3[];
   double ExtMapBuffer4[];

   ArrayResize(ExtMapBuffer1, Nbars);
   ArrayResize(ExtMapBuffer2, Nbars);
   ArrayResize(ExtMapBuffer3, Nbars);
   ArrayResize(ExtMapBuffer4, Nbars);

   ArrayInitialize(ExtMapBuffer1, EMPTY_VALUE);
   ArrayInitialize(ExtMapBuffer2, EMPTY_VALUE);
   ArrayInitialize(ExtMapBuffer3, EMPTY_VALUE);
   ArrayInitialize(ExtMapBuffer4, EMPTY_VALUE);
   //----
   double maOpen, maClose, maLow, maHigh;
   double haOpen, haHigh, haLow, haClose;

   int pos=Nbars - Length - 1;
   while(pos>=0)
     {
      maOpen=iMA(sig_currency, sig_timeFrame,MaPeriod,0,MaMetod,0,pos);
      maClose=iMA(sig_currency, sig_timeFrame,MaPeriod,0,MaMetod,3,pos);
      maLow=iMA(sig_currency, sig_timeFrame,MaPeriod,0,MaMetod,1,pos);
      maHigh=iMA(sig_currency, sig_timeFrame,MaPeriod,0,MaMetod,2,pos);

      haOpen=(ExtMapBuffer3[pos+1]+ExtMapBuffer4[pos+1])/2;
      haClose=(maOpen+maHigh+maLow+maClose)/4;
      haHigh=MathMax(maHigh, MathMax(haOpen, haClose));
      haLow=MathMin(maLow, MathMin(haOpen, haClose));
      if (haOpen<haClose)
        {
         ExtMapBuffer1[pos]=haLow;
         ExtMapBuffer2[pos]=haHigh;
        }
      else
        {
         ExtMapBuffer1[pos]=haHigh;
         ExtMapBuffer2[pos]=haLow;
        }
      ExtMapBuffer3[pos]=haOpen;
      ExtMapBuffer4[pos]=haClose;
 	   pos--;
     }

   switch(indexBuffer) {
   case 0:
      return ExtMapBuffer1[shiftBuffer];
   case 1:
      return ExtMapBuffer2[shiftBuffer];
   case 2:
      return ExtMapBuffer3[shiftBuffer];
   case 3:
      return ExtMapBuffer4[shiftBuffer];
   default:
      return EMPTY_VALUE;
   }
}

//+------------------------------------------------------------------+

double doda_bands2(string sig_currency, int sig_timeFrame, string indexLabel, int Length, int Deviation, double MoneyRisk, int Signal, int Line, int Nbars, bool SoundON, int indexBuffer, int shiftBuffer) {

   //---- buffers
   double a_ibuf_124[];
   double a_ibuf_128[];
   double a_ibuf_132[];
   double a_ibuf_136[];
   double a_ibuf_140[];
   double a_ibuf_144[];

   ArrayResize(a_ibuf_124, Nbars);
   ArrayResize(a_ibuf_128, Nbars);
   ArrayResize(a_ibuf_132, Nbars);
   ArrayResize(a_ibuf_136, Nbars);
   ArrayResize(a_ibuf_140, Nbars);
   ArrayResize(a_ibuf_144, Nbars);

   ArrayInitialize(a_ibuf_124, EMPTY_VALUE);
   ArrayInitialize(a_ibuf_128, EMPTY_VALUE);
   ArrayInitialize(a_ibuf_132, EMPTY_VALUE);
   ArrayInitialize(a_ibuf_136, EMPTY_VALUE);
   ArrayInitialize(a_ibuf_140, EMPTY_VALUE);
   ArrayInitialize(a_ibuf_144, EMPTY_VALUE);

   bool ai_152 = FALSE;
   bool ai_156 = FALSE;

   int ali_8;
   double lda_12[25000];
   double lda_16[25000];
   double lda_20[25000];
   double lda_24[25000];
   for (int al_shift_4 = Nbars - 1; al_shift_4 >= 0; al_shift_4--) {
      a_ibuf_124[al_shift_4] = 0;
      a_ibuf_128[al_shift_4] = 0;
      a_ibuf_132[al_shift_4] = 0;
      a_ibuf_136[al_shift_4] = 0;
      a_ibuf_140[al_shift_4] = EMPTY_VALUE;
      a_ibuf_144[al_shift_4] = EMPTY_VALUE;
   }
   for (int al_shift_4 = Nbars - Length - 1; al_shift_4 >= 0; al_shift_4--) {
      lda_12[al_shift_4] = iBands(sig_currency, sig_timeFrame, Length, Deviation, 0, PRICE_CLOSE, MODE_UPPER, al_shift_4);
      lda_16[al_shift_4] = iBands(sig_currency, sig_timeFrame, Length, Deviation, 0, PRICE_CLOSE, MODE_LOWER, al_shift_4);
      if (iClose(sig_currency, sig_timeFrame, al_shift_4) > lda_12[al_shift_4 + 1]) ali_8 = 1;
      if (iClose(sig_currency, sig_timeFrame, al_shift_4) < lda_16[al_shift_4 + 1]) ali_8 = -1;
      if (ali_8 > 0 && lda_16[al_shift_4] < lda_16[al_shift_4 + 1]) lda_16[al_shift_4] = lda_16[al_shift_4 + 1];
      if (ali_8 < 0 && lda_12[al_shift_4] > lda_12[al_shift_4 + 1]) lda_12[al_shift_4] = lda_12[al_shift_4 + 1];
      lda_20[al_shift_4] = lda_12[al_shift_4] + (MoneyRisk - 1.0) / 2.0 * (lda_12[al_shift_4] - lda_16[al_shift_4]);
      lda_24[al_shift_4] = lda_16[al_shift_4] - (MoneyRisk - 1.0) / 2.0 * (lda_12[al_shift_4] - lda_16[al_shift_4]);
      if (ali_8 > 0 && lda_24[al_shift_4] < lda_24[al_shift_4 + 1]) lda_24[al_shift_4] = lda_24[al_shift_4 + 1];
      if (ali_8 < 0 && lda_20[al_shift_4] > lda_20[al_shift_4 + 1]) lda_20[al_shift_4] = lda_20[al_shift_4 + 1];
      if (ali_8 > 0) {
         if (Signal > 0 && a_ibuf_124[al_shift_4 + 1] == -1.0) {
            a_ibuf_132[al_shift_4] = lda_24[al_shift_4];
            a_ibuf_124[al_shift_4] = lda_24[al_shift_4];
            if (Line > 0) a_ibuf_140[al_shift_4] = lda_24[al_shift_4];
            if (SoundON == TRUE && al_shift_4 == 0 && (!ai_152)) {
               Alert("DodaCharts-BBands going Up on ", sig_currency, "-", sig_timeFrame);
               ai_152 = TRUE;
               ai_156 = FALSE;
            }
         } else {
            a_ibuf_124[al_shift_4] = lda_24[al_shift_4];
            if (Line > 0) a_ibuf_140[al_shift_4] = lda_24[al_shift_4];
            a_ibuf_132[al_shift_4] = -1;
         }
         if (Signal == 2) a_ibuf_124[al_shift_4] = 0;
         a_ibuf_136[al_shift_4] = -1;
         a_ibuf_128[al_shift_4] = -1.0;
         a_ibuf_144[al_shift_4] = EMPTY_VALUE;
      }
      if (ali_8 < 0) {
         if (Signal > 0 && a_ibuf_128[al_shift_4 + 1] == -1.0) {
            a_ibuf_136[al_shift_4] = lda_20[al_shift_4];
            a_ibuf_128[al_shift_4] = lda_20[al_shift_4];
            if (Line > 0) a_ibuf_144[al_shift_4] = lda_20[al_shift_4];
            if (SoundON == TRUE && al_shift_4 == 0 && (!ai_156)) {
               Alert("DodaCharts-BBands going Down on ", sig_currency, "-", sig_timeFrame);
               ai_156 = TRUE;
               ai_152 = FALSE;
            }
         } else {
            a_ibuf_128[al_shift_4] = lda_20[al_shift_4];
            if (Line > 0) a_ibuf_144[al_shift_4] = lda_20[al_shift_4];
            a_ibuf_136[al_shift_4] = -1;
         }
         if (Signal == 2) a_ibuf_128[al_shift_4] = 0;
         a_ibuf_132[al_shift_4] = -1;
         a_ibuf_124[al_shift_4] = -1.0;
         a_ibuf_140[al_shift_4] = EMPTY_VALUE;
      }
   }

   switch(indexBuffer) {
   case 0:
      return a_ibuf_124[shiftBuffer];
   case 1:
      return a_ibuf_128[shiftBuffer];
   case 2:
      return a_ibuf_132[shiftBuffer];
   case 3:
      return a_ibuf_136[shiftBuffer];
   case 4:
      return a_ibuf_140[shiftBuffer];
   case 5:
      return a_ibuf_144[shiftBuffer];
   default:
      return EMPTY_VALUE;
   }

}

//+------------------------------------------------------------------+

double bb_squeeze_dark(string sig_currency, int sig_timeFrame, int bolPrd, double bolDev, int keltPrd, double keltFactor, int momPrd, long Length, long Nbars, int indexBuffer, int shiftBuffer) {

   //---- buffers
   double upB[];
   double upB2[];
   double loB[];
   double loB2[];
   double upK[];
   double loK[];

   ArrayResize(upB,  Nbars);
   ArrayResize(upB2, Nbars);
   ArrayResize(loB,  Nbars);
   ArrayResize(loB2, Nbars);
   ArrayResize(upK,  Nbars);
   ArrayResize(loK,  Nbars);

   ArrayInitialize(upB,  EMPTY_VALUE);
   ArrayInitialize(upB2, EMPTY_VALUE);
   ArrayInitialize(loB,  EMPTY_VALUE);
   ArrayInitialize(loB2, EMPTY_VALUE);
   ArrayInitialize(upK,  EMPTY_VALUE);
   ArrayInitialize(loK,  EMPTY_VALUE);

   int i,j,slippage=3;
   double breakpoint=0.0;
   double ema=0.0;
   int peakf=0;
   int peaks=0;
   int valleyf=0;
   int valleys=0;
   double ccis[61],ccif[61];
   double delta=0;
   double ugol=0;

   int shift;
   double diff,d,dPrev, std,bbs;

   for (shift=Nbars - Length - 1;shift>=0;shift--) {
      //d=iMomentum(NULL,0,momPrd,PRICE_CLOSE,shift);
      d=LinearRegressionValue(sig_currency, sig_timeFrame, bolPrd,shift);
      dPrev=LinearRegressionValue(sig_currency, sig_timeFrame, bolPrd,shift+1);
      if(d>0) {
         if ((dPrev>0) && (dPrev > d)){ upB2[shift]=d; upB[shift] = 0; } else { upB[shift]= d; upB2[shift] = 0; }
         //upB[shift]=0;
         loB[shift]=0;
         loB2[shift]=0;
      } else {
         if ((dPrev<0) && (dPrev < d)){ loB2[shift]=d; loB[shift] = 0; } else { loB[shift]= d; loB2[shift] = 0; }
         upB[shift]=0;
         upB2[shift]=0;
         //loB[shift]=d;
      }
		diff = iATR(sig_currency,sig_timeFrame,keltPrd,shift)*keltFactor;
		std = iStdDev(sig_currency,sig_timeFrame,bolPrd,MODE_SMA,0,PRICE_CLOSE,shift);
		bbs = bolDev * std / diff;
      if(bbs<1) {
         upK[shift]=0;
         loK[shift]=EMPTY_VALUE;
      } else {
         loK[shift]=0;
         upK[shift]=EMPTY_VALUE;
      }
   }

   switch(indexBuffer) {
   case 0:
      return upB[shiftBuffer];
   case 1:
      return loB[shiftBuffer];
   case 2:
      return upB2[shiftBuffer];
   case 3:
      return loB2[shiftBuffer];
   case 4:
      return upK[shiftBuffer];
   case 5:
      return loK[shiftBuffer];
   default:
      return EMPTY_VALUE;
   }
}

double LinearRegressionValue(string sig_currency, int sig_timeFrame, int Len,int shift) {
   double SumBars = 0;
   double SumSqrBars = 0;
   double SumY = 0;
   double Sum1 = 0;
   double Sum2 = 0;
   double Slope = 0;

   SumBars = Len * (Len-1) * 0.5;
   SumSqrBars = (Len - 1) * Len * (2 * Len - 1)/6;

  for (int x=0; x<=Len-1;x++) {
   double HH = iLow(sig_currency,sig_timeFrame,x+shift);
   double LL = iHigh(sig_currency,sig_timeFrame,x+shift);
   for (int y=x; y<=(x+Len)-1; y++) {
     HH = MathMax(HH, iHigh(sig_currency,sig_timeFrame,y+shift));
     LL = MathMin(LL, iLow(sig_currency,sig_timeFrame,y+shift));
   }
    Sum1 += x* (iClose(sig_currency,sig_timeFrame,x+shift)-((HH+LL)/2 + iMA(sig_currency,sig_timeFrame,Len,0,MODE_EMA,PRICE_CLOSE,x+shift))/2);
    SumY += (iClose(sig_currency,sig_timeFrame,x+shift)-((HH+LL)/2 + iMA(sig_currency,sig_timeFrame,Len,0,MODE_EMA,PRICE_CLOSE,x+shift))/2);
  }
  Sum2 = SumBars * SumY;
  double Num1 = Len * Sum1 - Sum2;
  double Num2 = SumBars * SumBars-Len * SumSqrBars;

  if (Num2 != 0.0)  {
    Slope = Num1/Num2;
  } else {
    Slope = 0;
  }

  double Intercept = (SumY - Slope*SumBars) /Len;
  double LinearRegValue = Intercept+Slope * (Len - 1);

  return (LinearRegValue);
}

//---------------------------------------------------------------------------

int getTrend(string symbol, int period, double& soglie[])
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

   double Poin;
   if(MarketInfo(symbol,MODE_DIGITS) == 3 || MarketInfo(symbol,MODE_DIGITS) == 5)   Poin = MarketInfo(symbol,MODE_POINT)*10;
   else Poin = MarketInfo(symbol,MODE_POINT);

   double VelocitaBuffer[];
   double AccelerazioneBuffer[];
   ArrayResize(VelocitaBuffer,2*PrevMAShift+1);
   ArrayResize(AccelerazioneBuffer,2*PrevMAShift+1);
   ArrayInitialize(VelocitaBuffer,0);
   ArrayInitialize(AccelerazioneBuffer,0);

   ArrayResize(soglie,3);
   ArrayInitialize(soglie,EMPTY_VALUE);

   for(int mm=PrevMAShift;mm>=0;mm--)
   {
      double MACur=iMA(symbol,period,MAPeriod,0,MA_Mode,MA_AppliedPrice,mm+CurMAShift);
      double MAPrev=iMA(symbol,period,MAPeriod,0,MA_Mode,MA_AppliedPrice,mm+PrevMAShift);

      VelocitaBuffer[mm] = (MACur-MAPrev)/Poin;
      AccelerazioneBuffer[mm] = VelocitaBuffer[mm+CurMAShift] - VelocitaBuffer[mm+PrevMAShift];

      //if ( AccelerazioneBuffer[mm]>sogliaMinima_accelerazione )    AccelerUpSoglia[mm]=AccelerazioneBuffer[mm];
      //if ( AccelerazioneBuffer[mm]<-sogliaMinima_accelerazione )   AccelerDownSoglia[mm]=AccelerazioneBuffer[mm];
   }

   double MACur=iMA(symbol,period,MAPeriod,0,MA_Mode,MA_AppliedPrice,CurMAShift);
   double MAPrev=iMA(symbol,period,MAPeriod,0,MA_Mode,MA_AppliedPrice,PrevMAShift);

   //------------ trend al rialzo -----------------------+
   if ( VelocitaBuffer[0]>sogliaMinima_velocita && AccelerazioneBuffer[0]>0 && AccelerazioneBuffer[0]>sogliaMinima_accelerazione )
     {
      //text = "trend crescente e forte   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[0] = (MACur-MAPrev)/Poin;

      return(TREND_CRESCENTE_FORTE);
     }
   else if ( VelocitaBuffer[0]>sogliaMinima_velocita && AccelerazioneBuffer[0]>0 && AccelerazioneBuffer[0]<=sogliaMinima_accelerazione )
     {
      //text = "trend crescente con poca forza   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+2)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],1)+"";
      soglie[0] = (MACur-MAPrev)/Poin;

      return(TREND_CRESCENTE_POCO_FORTE);
     }

   else if ( VelocitaBuffer[0]>sogliaMinima_velocita && AccelerazioneBuffer[0]<0 )
     {
      //text = "trend crescente ma accellerazione negativa   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[0] = (MACur-MAPrev)/Poin;

      return(TREND_CRESCENTE_ACC_NEGATIVA);
     }

   //------------ trend al ribasso -----------------------+
   else if ( VelocitaBuffer[0]<-sogliaMinima_velocita && AccelerazioneBuffer[0]<0 && AccelerazioneBuffer[0]<-sogliaMinima_accelerazione )
     {
      //text = "trend decrescente e forte   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[1] = (MACur-MAPrev)/Poin;

      return(TREND_DECRESCENTE_FORTE);
     }
   else if ( VelocitaBuffer[0]<-sogliaMinima_velocita && AccelerazioneBuffer[0]<0 && AccelerazioneBuffer[0]>=-sogliaMinima_accelerazione )
     {
      //text = "trend decrescente con poca forza   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[1] = (MACur-MAPrev)/Poin;

      return(TREND_DECRESCENTE_POCO_FORTE);
     }

   else if ( VelocitaBuffer[0]<-sogliaMinima_velocita && AccelerazioneBuffer[0]>0 )
     {
      //text = "trend decrescente ma accellerazione positiva   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[1] = (MACur-MAPrev)/Poin;

      return(TREND_DECRESCENTE_ACC_POSITIVA);
     }

   //------------ trend in laterale -----------------------+
   else if ( VelocitaBuffer[0]<=sogliaMinima_velocita && VelocitaBuffer[0]>=-sogliaMinima_velocita && AccelerazioneBuffer[0]>sogliaMinima_accelerazione )
     {
      //text = "trend in laterale con un\'accelerazione per un trend al rialzo   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[2] = (MACur-MAPrev)/Poin;

      return(TREND_LATERALE_RIALZO);
     }

   else if ( VelocitaBuffer[0]<=sogliaMinima_velocita && VelocitaBuffer[0]>=-sogliaMinima_velocita && AccelerazioneBuffer[0]<-sogliaMinima_accelerazione )
     {
      //text = "trend in laterale con un\'accelerazione per un trend al ribasso   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[2] = (MACur-MAPrev)/Poin;

      return(TREND_LATERALE_RIBASSO);
     }

   else
     {
      //text = "trend in laterale   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, è sotto la soglia (="+DoubleToStr(sogliaMinima_velocita,2)+"), accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
      soglie[2] = (MACur-MAPrev)/Poin;

      return(TREND_LATERALE);
     }

   return(EMPTY_VALUE);
}
//--------------------------------------------------------------------------
int getTrendConfirmation(string symbol, int trend)
{
   double points = MarketInfo(symbol,MODE_POINT);
   int    digits = MarketInfo(symbol,MODE_DIGITS);
   int trendConfirmation = trend;
   int trend_RL,trend_RL_Threshold,trend_R1,trend_R2,trend_R3,trend_R4;
   //----
      trend_RL_Threshold = regressione_R1+regressione_R2+regressione_R3+regressione_R4;
      trend_RL = 0;

      // ------------------------------
      // retta di regressione R1
      // ------------------------------
      if (regressione_R1==true)
      {
         sqRegressionLine(symbol,tfInMinuti_R1,PeriodRegr_R1);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R1-1])/(points*MathPow(10, digits%2));
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
         sqRegressionLine(symbol,tfInMinuti_R2,PeriodRegr_R2);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R2-1])/(points*MathPow(10, digits%2));
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
         sqRegressionLine(symbol,tfInMinuti_R3,PeriodRegr_R3);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R3-1])/(points*MathPow(10, digits%2));
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
         sqRegressionLine(symbol,tfInMinuti_R4,PeriodRegr_R4);

         double regressione = (regression_line[0]-regression_line[PeriodRegr_R4-1])/(points*MathPow(10, digits%2));
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
   switch(trend)
   {
      case TREND_CRESCENTE_FORTE:
      case TREND_CRESCENTE_POCO_FORTE:
      case TREND_CRESCENTE_ACC_NEGATIVA:
         if (MathAbs(trend_RL)<trend_RL_Threshold) trendConfirmation = TREND_CRESCENTE_POCO_FORTE;
         else if(trend_RL<0) trendConfirmation = TREND_LATERALE;
         break;
      case TREND_DECRESCENTE_FORTE:
      case TREND_DECRESCENTE_POCO_FORTE:
      case TREND_DECRESCENTE_ACC_POSITIVA:
         if (MathAbs(trend_RL)<trend_RL_Threshold) trendConfirmation = TREND_DECRESCENTE_POCO_FORTE;
         else if(trend_RL>0) trendConfirmation = TREND_LATERALE;
         break;
   }
   //----
   return(trendConfirmation);
}

//--------------------------------------------------------------------------
//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione regression_line() calcola i valori dell'array regression_line[]
//  che vengono usati per costrire l'oggetto retta di regressione
//+-------------------------------------------------------------------------------------------------------------------------------------+
void sqRegressionLine(string simbol, int timeframe, int PeriodRegression)
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
            Y_media += iClose(simbol,timeframe,x+i);
            Sommatoria_XiYi += x*iClose(simbol,timeframe,x+i);
           }
         if (applied_price==1)
           {
            Y_media += iOpen(simbol,timeframe,x+i);
            Sommatoria_XiYi += x*iOpen(simbol,timeframe,x+i);
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

         if(i==0) return(true);
      }
      else {
         vol_t[i]=vol;vol_m[i]=EMPTY_VALUE;

         if(i==0) return(false);
      }

      ind_c[i]=vol;
      thresholdBuffer[i]=t;
   }

   return(false);
}
//+-------------------------------------------------------------------------------------------------------------------------------------+
