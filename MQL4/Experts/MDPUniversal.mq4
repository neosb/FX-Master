//+------------------------------------------------------------------+
//|                                                 MDPUniversal.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//#property show_inputs

//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0);

#import "MillionDollarPips.dll"
   void InitializeRobot(string a0, int a1, int a2, int& a3[], int& a4[], string a5);
   void fun(int a0, int a1, int a2, int a3, double a4, double a5, double a6, double a7, double a8, double a9, double a10, double a11, double a12, double a13, double a14, double a15, double a16, double a17, double a18, int a19, double a20, double a21, double a22, double a23, double a24, double a25, double a26, double a27, double a28, double& a29[], double& a30[]);
#import

extern string Configuration = "================ Configuration";
extern bool Show_Diagnostics = TRUE;
extern bool Show_Debug = FALSE;
extern bool Verbose = FALSE;
extern bool Silent = FALSE;
extern string NumOrders_Level_Info_1 = "Range of 0..4, adjusts Number of Trades";
extern string NumOrders_Level_Info_2 = "0=Max Profit%  4=Max Num.Trades/Rebates";
extern int NumOrders_Level = 0;
extern string Additional_Channels_Info_1 = "Range of 0..8";
extern string Additional_Channels_Info_2 = "Safely improves trading frequency";
extern int Additional_Channels = 1;
extern string Slippage_Info_1 = "Lower value improves profit rate,";
extern string Slippage_Info_2 = "higher: trades more but less accurately";
extern int Slippage = 3;
bool gi_160 = FALSE;
extern string Username = "<your order receipt # here>";
bool gi_172 = TRUE;
bool gi_176 = TRUE;
bool gi_180 = TRUE;
bool gi_184 = TRUE;
bool gi_188 = TRUE;
extern int Magic = 112226;
extern int Max_Simultaneous_Orders = 8;
extern string FIFO_Info_1 = "if Simultaneous_Orders>1 ,";
extern string FIFO_Info_2 = "u.s. citizens should turn it on";
extern string FIFO_Info_3 = "(required for NFA compliance)";
extern bool FIFO = TRUE;
extern string OrderCmt = "MDP_EURUSD_1.1.6";
extern string Pessimistic_Testing_Info_1 = "Simulate bad live account conditions";
extern string Pessimistic_Testing_Info_2 = "during backtesting (i.e. Slippages)";
extern string Pessimistic_Testing_Info_3 = "(this has no effect in FIFO mode :";
extern string Pessimistic_Testing_Info_4 = " +turn off FIFO for \"optimistic\")";
extern bool Pessimistic_Testing = FALSE;
extern string Funky_Exit_Info = "Exit trades sooner";
extern bool Funky_Exit = TRUE;
extern string AutoApply_ECN_Info_1 = "Use ECN account settings automatically";
extern string AutoApply_ECN_Info_2 = "when ECN conditions detected";
extern bool AutoApply_ECN = TRUE;
extern string Money_Management = "---------------- Money Management";
extern double Min_Lots = 0.001;
extern double Max_Lots = 1000.0;
extern string Risk_Info_1 = "Fixed risk % of balance per order";
extern string Risk_Info_2 = "NOTE : Trading volume is very variable";
extern string Risk_Info_3 = "as stop losses are in different distances";
extern double Risk = 1.5;
extern string Risk_Mode_CommPips_Info_1 = "Risk is commensurate with target pips";
extern string Risk_Mode_CommPips_Info_2 = "otherwise it\'s only determined by %";
extern bool Risk_Mode_CommPips = TRUE;
double gd_380 = 0.0;
string gs_unused_388 = "---------------- Scalping Factors";
double gd_396 = 15.0;
double gd_404 = 40.0;
double gd_412 = 230.0;
double gd_420 = 350.0;
double gd_428 = 0.4;
double gd_436 = 0.5;
double gd_444 = 0.0;
double gd_452 = 250.0;
double gd_460 = 370.0;
double gd_468 = 0.4;
double gd_476 = 0.5;
double gd_484 = 0.0;
double gd_492 = 280.0;
double gd_500 = 400.0;
double gd_508 = 0.4;
double gd_516 = 0.5;
double gd_524 = 0.0;
double gd_532 = 290.0;
double gd_540 = 410.0;
double gd_548 = 0.4;
double gd_556 = 0.5;
double gd_564 = 0.0;
double gd_572 = 320.0;
double gd_580 = 440.0;
double gd_588 = 0.4;
double gd_596 = 0.5;
double gd_604 = 0.0;
extern string SL_TP_Trailing = "---------------- SL / TP / Trailing";
extern double Trailing_Resolution = 5.0;
double gd_628 = 20.0;
double gd_636 = 20.0;
double gd_644 = 40.0;
double gd_652 = 45.0;
double gd_660 = 45.0;
double gd_668 = 75.0;
double gd_676 = 80.0;
double gd_684 = 1.0;
double gd_692;
bool gi_700 = TRUE;
extern string Use_Stop_Orders_Info_1 = "Set true if 1) your broker doesn\'t deal with";
extern string Use_Stop_Orders_Info_2 = "opening slippage when executing STOP orders";
extern string Use_Stop_Orders_Info_3 = "and 2) broker stop level is <= 2.0 pips";
extern bool Use_Stop_Orders = TRUE;
extern string Hard_Stop_Trailing_Info_1 = "Trailing hard Stop/Loss and Take/Profit";
extern string Hard_Stop_Trailing_Info_2 = "Otherwise, doing it in programmatic manner";
extern string Hard_Stop_Trailing_Info_3 = "and SL/TP is just for covering";
extern bool Hard_Stop_Trailing = TRUE;
string gs_unused_760 = "---------------- Indicators";
int g_timeframe_768 = PERIOD_M1;
int gi_772 = 1;
int g_period_776 = 10;
double gd_780 = 2.0;
int gi_788 = 1;
int gi_792 = 1;
int g_period_796 = 30;
double gd_800 = 2.0;
int gi_808 = 1;
int gi_812 = 5;
int g_period_816 = 30;
double gd_820 = 2.0;
int gi_828 = 5;
int gi_832 = 5;
int g_period_836 = 10;
double gd_840 = 2.0;
int gi_848 = 5;
int gi_852 = 5;
int g_period_856 = 30;
double gd_860 = 2.0;
int gi_unused_868 = 1;
int g_period_872 = 5;
double gd_876 = 2.0;
string gs_884;
double gda_892[2];
double gda_896[2];
int gia_900[2];
double gd_904 = 1.0;
double gd_912;
bool gi_920;
double gd_924;
bool gi_932 = FALSE;
bool gi_936 = FALSE;
double gd_940 = 1.0;
double gd_948 = 0.0;
int gi_956 = 0;
double gda_960[100];
double gd_964 = 0.0;
int gi_972 = 0;
double gda_976[100];
double gd_980 = 0.0;
int gi_988 = 0;
double gda_992[100];
double gd_996 = 0.0;
int gi_1004 = 0;
int gi_1008 = 0;
double gda_1012[100];
double gd_1016;
double gda_1024[100];
double gd_1028;
double gd_1036;
int gi_1044 = 0;
double gda_1048[100];
double gd_1052;
double gd_1060;
int g_count_1068 = 0;
double gda_1072[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
double gda_1076[5000];
double gda_1080[5000];
double gda_1084[5000];
double gda_1088[5000];
double gda_1092[5000];
int g_time_1096 = 0;
int g_count_1100 = 0;
double gda_1104[200];
int gi_1108 = 0;
bool gi_1112 = TRUE;
int gi_1116 = 0;
double gd_1120 = 0.0;
double gd_1128 = 0.0;
int g_ticket_1136 = 0;
int g_count_1140 = 0;
int g_error_1144 = 0/* NO_ERROR */;
string gs_unused_1148 = "---------------- Special";
double gd_1156 = 60.0;
double gd_1164 = 10.0;
double gd_1172 = 0.35;
double gd_1180 = 0.5;
double gd_1188 = 5.0;
double gd_1196 = 40.0;
double gd_1204 = 20.0;
double gd_1212 = 0.25;
double gd_1220 = 0.4;
double gd_1228 = 3.5;
double gd_1236 = 40.0;
double gd_1244 = 20.0;
double gd_1252 = 0.6;
double gd_1260 = 0.15;
double gd_1268 = 4.5;
double gd_1276 = 50.0;
double gd_1284 = 10.0;
double gd_1292 = 0.7;
double gd_1300 = 0.4;
double gd_1308 = 5.0;
double gd_1316 = 40.0;
double gd_1324 = 20.0;
double gd_1332 = 0.6;
double gd_1340 = 0.2;
double gd_1348 = 5.0;
double gd_1356 = 5.0;
double gd_1364 = 1.0;
bool gi_1372 = TRUE;
bool gi_1376 = TRUE;
bool gi_1380 = TRUE;
int gi_1384 = 80;
string gs_1388 = "12345678901234567890123456789012345678901234567890ABCDEFGHIJKLMNOP";
string gs_1396;
int gia_1404[] = {0};
int gia_1408[] = {0};
double gda_1412[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
string gs_1416 = "";
double g_ihigh_1424;
double g_ilow_1432;
double gd_1440;
double g_ihigh_1448;
double g_ilow_1456;
double gd_1464;
double g_ibands_1472;
double g_ibands_1480;
double g_ibands_1488;
double g_ibands_1496;
double g_ibands_1504;
double g_ibands_1512;
double g_ibands_1520;
double g_ibands_1528;
double g_ibands_1536;
double g_ibands_1544;
double g_ibands_1552;
double g_ibands_1560;
double gd_1568;
double gd_1576;
double gd_1584;
double gd_1592;
double gd_1600;
double gd_1608;
double gd_1616;
double gd_1624;
double gd_1632;
double gd_1640;
int gi_1648;
int g_count_1652 = 0;
int g_count_1656 = 0;
int g_count_1660 = 0;
int gi_1664 = -1;
int gi_1668 = 0;
string gs_1672;
int gi_1680;
int g_shift_1684;
int gi_1688;
int g_count_1692;
int g_count_1696;
int g_count_1700;
int g_count_1704;
int g_count_1708 = 0;
int gi_1712 = 0;
int gi_1716;
int g_count_1720 = 0;
bool gi_1724;
bool gi_1728;
bool gi_1732;
int gi_1736;
bool gi_1740;
bool gi_1744 = FALSE;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
   gi_1724 = FALSE;
   gi_1728 = FALSE;
   gi_1732 = FALSE;
   gi_936 = FALSE;
   ArrayInitialize(gda_1104, 0);
   ArrayInitialize(gda_1076, 0);
   ArrayInitialize(gda_1080, 0);
   ArrayInitialize(gda_1084, 0);
   ArrayInitialize(gda_1088, 0);
   ArrayInitialize(gda_1092, 0);
   if (Digits < 5) Slippage = 0;
   else gi_956 = -1;
   gi_1108 = 0;
   Additional_Channels = MathMax(Additional_Channels, 0);
   Additional_Channels = MathMin(Additional_Channels, 8);
   switch (Additional_Channels) {
   case 0:
      gi_1716 = 1;
      gd_692 = 0;
      break;
   case 1:
      gi_1716 = 2;
      gd_692 = 20;
      break;
   case 2:
      gi_1716 = 2;
      gd_692 = 7;
      break;
   case 3:
      gi_1716 = 3;
      gd_692 = 5;
      break;
   case 4:
      gi_1716 = 4;
      gd_692 = 4;
      break;
   case 5:
      gi_1716 = 5;
      gd_692 = 3;
      break;
   case 6:
      gi_1716 = 6;
      gd_692 = 2;
      break;
   case 7:
   case 8:
      gi_1716 = 7;
      gd_692 = 1;
   }
   if (!IsTesting()) f0_5();
   if (gi_160) gia_1408[0] = 1;
   else {
      if (AccountNumber() == 0) {
         gs_1396 = "MetaTrader has not yet been connected to Server.";
         gia_1408[0] = 0;
         Print(gs_1396);
      } else {
         if (Username == "" || Username == gs_884) {
            gs_1396 = "MDP_EURUSD_1.1.6" + " is unable to validate MetaTrader account credentials. Username is not set.";
            gia_1408[0] = 0;
            Print(gs_1396);
            Comment(gs_1396);
            Alert(gs_1396);
         } else {
            InitializeRobot(Username, AccountNumber(), 0, gia_1408, gia_1404, gs_1388);
            gs_1396 = gs_1388;
            if (gia_1408[0] != 1) {
               Print("Account validation failed. Username:" + Username + " AccountNumber:" + AccountNumber());
               Print(gs_1396);
               Comment("Account validation failed. Username:" + Username + " AccountNumber:" + AccountNumber() 
                  + "\n" 
               + gs_1396);
               Alert("MDP_EURUSD_1.1.6" + ": Account validation failed. Username:" + Username + " AccountNumber:" + AccountNumber());
               Alert("MDP_EURUSD_1.1.6" + ": " + gs_1396);
            } else Print("Account validation succeeded. Username:" + Username + " AccountNumber:" + AccountNumber());
         }
      }
   }
   f0_25();
   if (gia_1408[0] == 1) return(INIT_SUCCEEDED);
   gi_1724 = TRUE;
//---
   return(INIT_FAILED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   string ls_0;
   string ls_8;
   string ls_16;
   string ls_24;
   string ls_32;
   string ls_40;
   if (gia_1408[0] == 1) {
      if (Period() != PERIOD_M1) {
         Print("ERROR --  " + "MDP_EURUSD_1.1.6" + " should be attached to " + "EURUSD" + " 1 Minute Chart Window");
         Comment("ERROR --  " + "MDP_EURUSD_1.1.6" + " should be attached to " + "EURUSD" + " 1 Minute Chart Window");
      } else {
         if (Use_Stop_Orders && (!AutoApply_ECN) && (!(IsTesting() && Pessimistic_Testing)) && MarketInfo(Symbol(), MODE_STOPLEVEL) * Point > 0.00001 * gd_636) {
            Print("ERROR --  " + "MDP_EURUSD_1.1.6" + " - Use_Stop_Orders is not valid, stop level (" + f0_23(MarketInfo(Symbol(), MODE_STOPLEVEL) * Point) + ") should not be greater than " +
               f0_23(0.00001 * gd_636));
            Comment("ERROR --  " + "MDP_EURUSD_1.1.6" + " - Use_Stop_Orders is not valid, stop level (" + f0_23(MarketInfo(Symbol(), MODE_STOPLEVEL) * Point) + ") should not be greater than " +
               f0_23(0.00001 * gd_636));
         } else {
            if (Max_Simultaneous_Orders <= 1 && FIFO) {
               Print("ERROR --  " + "MDP_EURUSD_1.1.6" + " - FIFO is not valid unless setting Max_Simultaneous_Orders >= 2");
               Comment("ERROR --  " + "MDP_EURUSD_1.1.6" + " - FIFO is not valid unless setting Max_Simultaneous_Orders >= 2");
            } else {
               if (Hard_Stop_Trailing && (!AutoApply_ECN) && (!(IsTesting() && Pessimistic_Testing)) && FIFO) {
                  Print("ERROR --  " + "MDP_EURUSD_1.1.6" + " - Hard_Stop_Trailing is not valid in conjunction with FIFO");
                  Comment("ERROR --  " + "MDP_EURUSD_1.1.6" + " - Hard_Stop_Trailing is not valid in conjunction with FIFO");
               } else {
                  if (Risk < 0.001 || Risk > 1000.0) {
                     Comment("ERROR -- Invalid Risk Value.");
                     Print("ERROR -- Invalid Risk Value.");
                  } else {
                     if (AccountBalance() <= 0.0) {
                        Comment("ERROR -- Account Balance is " + DoubleToStr(MathRound(AccountBalance()), 0));
                        Print("ERROR -- Account Balance is " + DoubleToStr(MathRound(AccountBalance()), 0));
                     } else {
                        if (StringFind(OrderCmt, "[sl]") >= 0 || StringFind(OrderCmt, "[tp]") >= 0 || StringFind(OrderCmt, "partial close") >= 0) {
                           Comment("ERROR -- OrderCmt is invalid, it should not contain any special character or identifier like [sl], [tp]");
                           Print("ERROR -- OrderCmt is invalid, it should not contain any special character or identifier like [sl], [tp]");
                        } else {
                           if (gi_172 || gi_176 || gi_180 || gi_184 || gi_188) {
                              if (gi_1724 && (!gi_1728)) {
                                 if (IsTesting()) Print("Starting test...");
                                 gi_1728 = TRUE;
                                 f0_2(-1);
                              }
                              f0_15(gda_892, gda_896, gia_900, gd_904);
                              gs_1672 = "";
                              f0_38();
                              gs_1672 = gs_1672 
                              + "\n";
                              if (FIFO) {
                                 if (gi_172) {
                                    if (Show_Diagnostics) gs_1672 = gs_1672 + " CHANNEL 1:\n";
                                    f0_40(g_timeframe_768, gi_772, 0, 1, 2, Additional_Channels >= 8, gd_412, gd_420, gd_428, gd_436, gd_444, gd_1156, gd_1172, gd_1164, gd_1180, gd_1188, gd_644, g_period_776,
                                       gd_780, gda_1076);
                                 }
                                 if (gi_176) {
                                    if (Show_Diagnostics) gs_1672 = gs_1672 + " CHANNEL 2:\n";
                                    f0_40(gi_788, gi_792, 3, 4, 5, Additional_Channels >= 8, gd_452, gd_460, gd_468, gd_476, gd_484, gd_1196, gd_1212, gd_1204, gd_1220, gd_1228, gd_652, g_period_796,
                                       gd_800, gda_1080);
                                 }
                                 if (gi_180) {
                                    if (Show_Diagnostics) gs_1672 = gs_1672 + " CHANNEL 3:\n";
                                    f0_40(gi_808, gi_812, 6, 7, 8, Additional_Channels >= 8, gd_492, gd_500, gd_508, gd_516, gd_524, gd_1236, gd_1252, gd_1244, gd_1260, gd_1268, gd_660, g_period_816,
                                       gd_820, gda_1084);
                                 }
                                 if (gi_184) {
                                    if (Show_Diagnostics) gs_1672 = gs_1672 + " CHANNEL 4:\n";
                                    f0_40(gi_828, gi_832, 9, 10, 11, Additional_Channels >= 8, gd_532, gd_540, gd_548, gd_556, gd_564, gd_1276, gd_1292, gd_1284, gd_1300, gd_1308, gd_668, g_period_836,
                                       gd_840, gda_1088);
                                 }
                                 if (gi_188) {
                                    if (Show_Diagnostics) gs_1672 = gs_1672 + " CHANNEL 5:\n";
                                    f0_40(gi_848, gi_852, 12, 13, 14, Additional_Channels >= 8, gd_572, gd_580, gd_588, gd_596, gd_604, gd_1316, gd_1332, gd_1324, gd_1340, gd_1348, gd_676, g_period_856,
                                       gd_860, gda_1092);
                                 }
                              } else {
                                 ls_0 = gs_1672;
                                 if (gi_188) {
                                    if (Show_Diagnostics) gs_1672 = " CHANNEL 5:\n";
                                    else gs_1672 = "";
                                    f0_40(gi_848, gi_852, 12, 13, 14, Additional_Channels >= 8, gd_572, gd_580, gd_588, gd_596, gd_604, gd_1316, gd_1332, gd_1324, gd_1340, gd_1348, gd_676, g_period_856,
                                       gd_860, gda_1092);
                                    ls_40 = gs_1672;
                                 }
                                 if (gi_184) {
                                    if (Show_Diagnostics) gs_1672 = " CHANNEL 4:\n";
                                    else gs_1672 = "";
                                    f0_40(gi_828, gi_832, 9, 10, 11, Additional_Channels >= 8, gd_532, gd_540, gd_548, gd_556, gd_564, gd_1276, gd_1292, gd_1284, gd_1300, gd_1308, gd_668, g_period_836,
                                       gd_840, gda_1088);
                                    ls_32 = gs_1672;
                                 }
                                 if (gi_176) {
                                    if (Show_Diagnostics) gs_1672 = " CHANNEL 2:\n";
                                    else gs_1672 = "";
                                    f0_40(gi_788, gi_792, 3, 4, 5, Additional_Channels >= 8, gd_452, gd_460, gd_468, gd_476, gd_484, gd_1196, gd_1212, gd_1204, gd_1220, gd_1228, gd_652, g_period_796,
                                       gd_800, gda_1080);
                                    ls_16 = gs_1672;
                                 }
                                 if (gi_172) {
                                    if (Show_Diagnostics) gs_1672 = " CHANNEL 1:\n";
                                    else gs_1672 = "";
                                    f0_40(g_timeframe_768, gi_772, 0, 1, 2, Additional_Channels >= 8, gd_412, gd_420, gd_428, gd_436, gd_444, gd_1156, gd_1172, gd_1164, gd_1180, gd_1188, gd_644, g_period_776,
                                       gd_780, gda_1076);
                                    ls_8 = gs_1672;
                                 }
                                 if (gi_180) {
                                    if (Show_Diagnostics) gs_1672 = " CHANNEL 3:\n";
                                    else gs_1672 = "";
                                    f0_40(gi_808, gi_812, 6, 7, 8, Additional_Channels >= 8, gd_492, gd_500, gd_508, gd_516, gd_524, gd_1236, gd_1252, gd_1244, gd_1260, gd_1268, gd_660, g_period_816,
                                       gd_820, gda_1084);
                                    ls_24 = gs_1672;
                                 }
                                 gs_1672 = ls_0 + ls_8 + ls_16 + ls_24 + ls_32 + ls_40;
                              }
                              Comment(gs_1672);
                           } else Comment("");
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return;
  }
//+------------------------------------------------------------------+
void f0_20(double &ada_0[]) {
   double ld_4 = ada_0[0];
   double ld_12 = ada_0[1];
   if (Year() == 2009) {
      if (Month() <= 5) {
         ld_4 = 2.5 * ld_4;
         ld_12 /= 2.5;
      } else {
         if (Month() == 6 || Month() == 7) {
            ld_4 = 3.5 * ld_4;
            ld_12 /= 3.5;
         } else {
            ld_4 = 1.5 * ld_4;
            ld_12 /= 1.5;
         }
      }
   }
   if (Year() == 2010) {
      if (Month() == 5) {
         ld_4 = 4.0 * ld_4;
         ld_12 /= 4.0;
      } else {
         ld_4 = 1.5 * ld_4;
         ld_12 /= 1.5;
      }
   }
   ada_0[0] = ld_4;
   ada_0[1] = ld_12;
}

void f0_2(int ai_0) {
   int li_12;
   int li_16;
   string ls_20;
   if (gi_172) {
      g_shift_1684 = 1;
      gi_1688 = 1;
      g_count_1692 = 0;
      g_count_1696 = 0;
      for (int count_4 = 0; count_4 < ai_0 || gda_1076[gi_1384 - 1] == 0.0; count_4++) {
         li_16 = f0_39(g_timeframe_768, gi_772, gd_412, gd_420, gd_428, gd_436, gd_444, gd_1156, gd_1172, gd_1164, gd_1180, gd_1188, gd_644, g_period_776, gd_780, gda_1076);
         if (!(li_16)) break;
      }
      if (ai_0 == -1) {
         li_12 = f0_42(gda_1076, gi_1384);
         f0_32(gda_1076, li_12 + 1);
      }
   }
   if (gi_176) {
      g_shift_1684 = 1;
      gi_1688 = 1;
      g_count_1692 = 0;
      g_count_1696 = 0;
      for (int count_4 = 0; count_4 < ai_0 || gda_1080[gi_1384 - 1] == 0.0; count_4++) {
         li_16 = f0_39(gi_788, gi_792, gd_452, gd_460, gd_468, gd_476, gd_484, gd_1196, gd_1212, gd_1204, gd_1220, gd_1228, gd_652, g_period_796, gd_800, gda_1080);
         if (!(li_16)) break;
      }
      if (ai_0 == -1) {
         li_12 = f0_42(gda_1080, gi_1384);
         f0_32(gda_1080, li_12 + 1);
      }
   }
   if (gi_180) {
      if (gi_808 != 1 || gi_812 != 5) Print("ERROR  period3!=1 || hlperiod3!=5   period3:" + gi_808 + " hlperiod3:" + gi_812);
      g_shift_1684 = Minute() % 5 + 1;
      gi_1688 = 1;
      g_count_1692 = 0;
      g_count_1696 = 0;
      for (int count_4 = 0; count_4 < ai_0 || gda_1084[gi_1384 - 1] == 0.0; count_4++) {
         li_16 = f0_39(gi_808, gi_812, gd_492, gd_500, gd_508, gd_516, gd_524, gd_1236, gd_1252, gd_1244, gd_1260, gd_1268, gd_660, g_period_816, gd_820, gda_1084);
         if (!(li_16)) break;
      }
      if (ai_0 == -1) {
         li_12 = f0_42(gda_1084, gi_1384);
         f0_32(gda_1084, li_12 + 1);
      }
   }
   if (gi_184) {
      g_shift_1684 = 1;
      gi_1688 = 1;
      g_count_1692 = 0;
      g_count_1696 = 0;
      for (int count_4 = 0; count_4 < ai_0 || gda_1088[gi_1384 - 1] == 0.0; count_4++) {
         li_16 = f0_39(gi_828, gi_832, gd_532, gd_540, gd_548, gd_556, gd_564, gd_1276, gd_1292, gd_1284, gd_1300, gd_1308, gd_668, g_period_836, gd_840, gda_1088);
         if (!(li_16)) break;
      }
      if (ai_0 == -1) {
         li_12 = f0_42(gda_1088, gi_1384);
         f0_32(gda_1088, li_12 + 1);
      }
   }
   if (gi_188) {
      g_shift_1684 = 1;
      gi_1688 = 1;
      g_count_1692 = 0;
      g_count_1696 = 0;
      for (int count_4 = 0; count_4 < ai_0 || gda_1092[gi_1384 - 1] == 0.0; count_4++) {
         li_16 = f0_39(gi_848, gi_852, gd_572, gd_580, gd_588, gd_596, gd_604, gd_1316, gd_1332, gd_1324, gd_1340, gd_1348, gd_676, g_period_856, gd_860, gda_1092);
         if (!(li_16)) break;
      }
      if (ai_0 == -1) {
         li_12 = f0_42(gda_1092, gi_1384);
         f0_32(gda_1092, li_12 + 1);
      }
   }
   if (ai_0 == -1 || Verbose) {
      ls_20 = "";
      for (int index_8 = 0; index_8 < gi_1384; index_8++) ls_20 = ls_20 + gda_1076[index_8] + " ";
      Print("lifts1 : " + ls_20);
      ls_20 = "";
      for (int index_8 = 0; index_8 < gi_1384; index_8++) ls_20 = ls_20 + gda_1080[index_8] + " ";
      Print("lifts2 : " + ls_20);
      ls_20 = "";
      for (int index_8 = 0; index_8 < gi_1384; index_8++) ls_20 = ls_20 + gda_1084[index_8] + " ";
      Print("lifts3 : " + ls_20);
      ls_20 = "";
      for (int index_8 = 0; index_8 < gi_1384; index_8++) ls_20 = ls_20 + gda_1088[index_8] + " ";
      Print("lifts4 : " + ls_20);
      ls_20 = "";
      for (int index_8 = 0; index_8 < gi_1384; index_8++) ls_20 = ls_20 + gda_1092[index_8] + " ";
      Print("lifts5 : " + ls_20);
      Print("updateDeviations() ok...");
   }
}

int f0_39(int a_timeframe_0, int a_timeframe_4, double ad_8, double ad_16, double ad_24, double ad_32, double ad_40, double ad_48, double ad_56, double ad_64, double ad_72, double ad_80, double ad_88, int a_period_96, double ad_100, double& ada_108[]) {
   if (a_timeframe_4 % a_timeframe_0 != 0 && a_timeframe_0 % a_timeframe_4 != 0) {
      Print("ERROR hlperiod%period!=0 && period%hlperiod!=0   hlperiod:" + a_timeframe_4 + "  period:" + a_timeframe_0);
      return (0);
   }
   double ld_112 = gd_684;
   double ld_120 = 0.00001 * ad_88;
   double ld_128 = 0.00001 * gd_628;
   double ld_136 = 0.00001 * Trailing_Resolution;
   double ihigh_144 = iHigh(Symbol(), a_timeframe_4, gi_1688);
   double ilow_152 = iLow(Symbol(), a_timeframe_4, gi_1688);
   double ld_160 = ihigh_144 - ilow_152;
   double ibands_168 = iBands(Symbol(), a_timeframe_0, a_period_96, ad_100, 0, PRICE_OPEN, MODE_UPPER, g_shift_1684);
   double ibands_176 = iBands(Symbol(), a_timeframe_0, a_period_96, ad_100, 0, PRICE_OPEN, MODE_LOWER, g_shift_1684);
   if (ibands_168 == 0.0) {
      Print("offset overflow:" + g_shift_1684 + " period:" + a_timeframe_0);
      g_count_1700++;
      if (g_count_1700 > 5) return (0);
   } else g_count_1700 = 0;
   if (ihigh_144 == 0.0) {
      Print("hloffset overflow:" + gi_1688 + " hlperiod:" + a_timeframe_4);
      g_count_1704++;
      if (g_count_1704 > 5) return (0);
   } else g_count_1704 = 0;
   gda_1412[7] = ihigh_144;
   gda_1412[8] = 0;
   gda_1412[9] = gi_1384;
   fun(a_timeframe_0, a_timeframe_4, 0, 0, ad_24, ad_8, ad_16, gd_396, gd_404, ad_32, gd_684, ad_40, ad_48, ad_56, ad_64, ad_72, gd_1356, ad_80, gd_1364, NumOrders_Level - 2,
      ibands_176, ibands_168, ld_112, ld_128, ld_136, 0.00015, 0.00001, ihigh_144, ld_160, ada_108, gda_1412);
   gda_1412[7] = 0;
   gda_1412[8] = ilow_152;
   gda_1412[9] = gi_1384;
   fun(a_timeframe_0, a_timeframe_4, 0, 0, ad_24, ad_8, ad_16, gd_396, gd_404, ad_32, gd_684, ad_40, ad_48, ad_56, ad_64, ad_72, gd_1356, ad_80, gd_1364, NumOrders_Level - 2,
      ibands_176, ibands_168, ld_112, ld_128, ld_136, 0.00015, 0.00001, ilow_152, ld_160, ada_108, gda_1412);
   if (a_timeframe_0 < a_timeframe_4) {
      g_shift_1684++;
      g_count_1692++;
      if (g_count_1692 % (a_timeframe_4 / a_timeframe_0) == FALSE) {
         gi_1688++;
         g_count_1696++;
      }
   } else {
      if (a_timeframe_0 > a_timeframe_4) {
         gi_1688++;
         g_count_1696++;
         if (g_count_1696 % (a_timeframe_0 / a_timeframe_4) == FALSE) {
            g_shift_1684++;
            g_count_1692++;
         }
      } else {
         g_shift_1684++;
         g_count_1692++;
         gi_1688++;
         g_count_1696++;
      }
   }
   return (1);
}

void f0_38() {
   int ticket_16;
   string var_name_48;
   int li_64;
   string ls_68;
   int li_76;
   int li_80;
   bool li_156;
   string ls_160;
   double ld_168;
   string ls_176;
   double ld_184;
   double ld_192;
   double ld_200;
   int index_208;
   int lia_212[];
   int li_216;
   int li_220;
   int index_224;
   int lia_228[];
   string ls_232;
   if (GlobalVariableGet(f0_30() + "Reset")) {
      f0_36();
      f0_5();
   }
   if (!IsTesting()) f0_25();
   if (g_time_1096 < Time[0]) {
      g_time_1096 = Time[0];
      g_count_1100 = 0;
      if (gi_1732) f0_2(1);
      else gi_1732 = TRUE;
      if (!IsTesting()) f0_44();
   } else g_count_1100++;
   if (Verbose) f0_14();
   string ls_56 = "";
   if (AccountFreeMargin() != AccountBalance() && AccountBalance() != 0.0) {
      li_64 = AccountStopoutLevel();
      ls_68 = "Leverage:" + AccountLeverage();
      if (AccountStopoutMode() == 0) ls_68 = ls_68 + "  StopOut level:" + li_64 + "%";
      else ls_68 = ls_68 + "  StopOut level:" + li_64 + AccountCurrency();
      ls_56 = ls_68 + "   free margin:" + f0_29(AccountFreeMargin() * AccountLeverage(), 2) + " balance:" + f0_29(AccountBalance(), 2) + " margin%:" + f0_29(100.0 * (AccountFreeMargin() * AccountLeverage()) / AccountBalance(),
         2) + "%";
      ls_56 = ls_56 
      + "\n";
   }
   gs_1416 = "";
   gi_1736 = gi_1740;
   gi_1740 = FALSE;
   g_error_1144 = FALSE;
   gd_1584 = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
   gd_1592 = Ask - Bid;
   if (MarketInfo(Symbol(), MODE_LOTSTEP) == 0.0) gi_1648 = 5;
   else gi_1648 = f0_41(0.1, MarketInfo(Symbol(), MODE_LOTSTEP));
   if (IsTesting() && Pessimistic_Testing) {
      Use_Stop_Orders = 0;
      Hard_Stop_Trailing = 0;
   }
   g_ihigh_1448 = iHigh(Symbol(), PERIOD_M5, 0);
   g_ilow_1456 = iLow(Symbol(), PERIOD_M5, 0);
   gd_1464 = g_ihigh_1448 - g_ilow_1456;
   g_ihigh_1424 = iHigh(Symbol(), PERIOD_M1, 0);
   g_ilow_1432 = iLow(Symbol(), PERIOD_M1, 0);
   gd_1440 = g_ihigh_1424 - g_ilow_1432;
   if (g_count_1100 == 0) {
      g_ibands_1472 = iBands(Symbol(), g_timeframe_768, g_period_776, gd_780, 0, PRICE_OPEN, MODE_UPPER, 0);
      g_ibands_1480 = iBands(Symbol(), g_timeframe_768, g_period_776, gd_780, 0, PRICE_OPEN, MODE_LOWER, 0);
      g_ibands_1488 = iBands(Symbol(), g_timeframe_768, g_period_796, gd_800, 0, PRICE_OPEN, MODE_UPPER, 0);
      g_ibands_1496 = iBands(Symbol(), g_timeframe_768, g_period_796, gd_800, 0, PRICE_OPEN, MODE_LOWER, 0);
      g_ibands_1504 = iBands(Symbol(), g_timeframe_768, g_period_816, gd_820, 0, PRICE_OPEN, MODE_UPPER, 0);
      g_ibands_1512 = iBands(Symbol(), g_timeframe_768, g_period_816, gd_820, 0, PRICE_OPEN, MODE_LOWER, 0);
      g_ibands_1520 = iBands(Symbol(), g_timeframe_768, g_period_836, gd_840, 0, PRICE_OPEN, MODE_UPPER, 0);
      g_ibands_1528 = iBands(Symbol(), g_timeframe_768, g_period_836, gd_840, 0, PRICE_OPEN, MODE_LOWER, 0);
      g_ibands_1536 = iBands(Symbol(), g_timeframe_768, g_period_856, gd_860, 0, PRICE_OPEN, MODE_UPPER, 0);
      g_ibands_1544 = iBands(Symbol(), g_timeframe_768, g_period_856, gd_860, 0, PRICE_OPEN, MODE_LOWER, 0);
      g_ibands_1552 = iBands(Symbol(), g_timeframe_768, g_period_872, gd_876, 0, PRICE_OPEN, MODE_UPPER, 0);
      g_ibands_1560 = iBands(Symbol(), g_timeframe_768, g_period_872, gd_876, 0, PRICE_OPEN, MODE_LOWER, 0);
      gd_1568 = g_ibands_1552 - g_ibands_1560;
      gd_1576 = g_ibands_1560 + gd_1568 / 2.0;
   }
   if (!gi_932) {
      for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0 && !gi_932; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
         f0_37();
      }
   }
   if (!gi_932) {
      for (int pos_0 = OrdersHistoryTotal() - 1; pos_0 >= 0 && !gi_932; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_HISTORY);
         f0_37();
      }
   }
   if (!gi_936) {
      for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0 && g_count_1068 < 100; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && StringFind(OrderComment(), "MDP") >= 0 || OrderComment() == OrderCmt || OrderMagicNumber() == Magic) f0_3();
      }
      for (int pos_0 = OrdersHistoryTotal() - 1; pos_0 >= 0 && g_count_1068 < 100; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_HISTORY);
         if (OrderSymbol() == Symbol() && StringFind(OrderComment(), "MDP") >= 0 || OrderComment() == OrderCmt || OrderMagicNumber() == Magic) f0_3();
      }
      for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0 && g_count_1068 < 100; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol()) f0_3();
      }
      for (int pos_0 = OrdersHistoryTotal() - 1; pos_0 >= 0 && g_count_1068 < 100; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_HISTORY);
         if (OrderSymbol() == Symbol()) f0_3();
      }
      gi_936 = TRUE;
   }
   if (gi_956 >= 0 || gi_956 == -2) {
      li_76 = NormalizeDouble(Bid / 0.00001, 0);
      li_80 = NormalizeDouble(Ask / 0.00001, 0);
      if (li_76 % 10 != 0 || li_80 % 10 != 0) gi_956 = -1;
      else {
         if (gi_956 >= 0 && gi_956 < 10) gi_956++;
         else gi_956 = -2;
      }
   }
   double ld_unused_84 = gda_1104[0];
   ArrayCopy(gda_1104, gda_1104, 0, 1, 199);
   gda_1104[199] = gd_1592;
   if (gi_1108 < 200) gi_1108++;
   double ld_92 = 0;
   double ld_100 = 0;
   int li_108 = MathMin(gi_1108, 5);
   int pos_0 = 199;
   for (int index_4 = 0; index_4 < gi_1108; index_4++) {
      ld_92 += gda_1104[pos_0];
      pos_0--;
   }
   pos_0 = 199;
   for (int index_4 = 0; index_4 < li_108; index_4++) {
      ld_100 += gda_1104[pos_0];
      pos_0--;
   }
   gd_1600 = ld_92 / gi_1108;
   gd_1608 = ld_100 / li_108;
   gd_1028 = 0;
   gd_1036 = 0;
   gd_1052 = 0;
   gd_1060 = 0;
   gd_964 = 0;
   gd_980 = 0;
   gd_996 = 0;
   gd_1016 = 0;
   for (pos_0 = 0; pos_0 < 100; pos_0++) {
      gd_1028 += gda_1024[pos_0];
      gd_1036 += MathAbs(gda_1024[pos_0]);
      gd_1052 += gda_1048[pos_0];
      gd_1060 += MathAbs(gda_1048[pos_0]);
      gd_964 += gda_960[pos_0];
      gd_980 += gda_976[pos_0];
      gd_996 += gda_992[pos_0];
      gd_1016 += gda_1012[pos_0];
   }
   if (!gi_932 && gd_1600 < 0.00015) gd_948 = 0.00015 - gd_1600;
   gd_1616 = f0_28(Ask + gd_948);
   gd_1624 = f0_28(Bid - gd_948);
   gd_1632 = gd_1600 + gd_948;
   gd_1640 = gd_1608 + gd_948;
   string ls_112 = "";
   string ls_120 = "";
   string ls_128 = "";
   string ls_136 = "";
   string ls_144 = "";
   int li_unused_152 = 0;
   if (!IsTesting()) {
      if (gi_1044 > 0 || gd_1584 > 0.00001 * gd_636) {
         li_156 = FALSE;
         if (gi_1044 > 0) {
            if (gd_1028 / gi_1044 <= 10.0 && gd_1584 <= 0.00001 * gd_636) {
               ls_112 = ls_112 + " ECN Entry Conditions met";
               if (AutoApply_ECN) {
                  Use_Stop_Orders = 1;
                  ls_112 = ls_112 + " (Use_Stop_Orders adjusted)";
               } else
                  if (!Use_Stop_Orders) ls_112 = ls_112 + ", Use_Stop_Orders is recommended";
               ls_112 = ls_112 + " :  Open Slip <= 10    stop level (" + f0_23(gd_1584) + ") <= " + f0_23(0.00001 * gd_636);
               ls_112 = ls_112 
               + "\n";
            } else li_156 = TRUE;
         } else li_156 = TRUE;
         if (li_156) {
            li_unused_152 = 1;
            ls_112 = ls_112 + "!ECN Entry Conditions failed";
            if (AutoApply_ECN && gd_1584 > 0.00001 * gd_636 || gi_1044 >= 15) {
//               Use_Stop_Orders = 0;
               ls_112 = ls_112 + " (Use_Stop_Orders adjusted)";
            } else {
               if (Use_Stop_Orders) {
                  ls_112 = ls_112 + ", Use_Stop_Orders is NOT recommended";
                  if (AutoApply_ECN) ls_112 = ls_112 + " (auto-adjusted in " + ((15 - gi_1044)) + ")";
               }
            }
            ls_112 = ls_112 + " : ";
            if (gi_1044 > 0) {
               if (gd_1028 / gi_1044 > 10.0) {
                  ls_112 = ls_112 + " Open Slip > 10";
                  ls_112 = ls_112 + "    ";
               }
            }
            if (gd_1584 > 0.00001 * gd_636) ls_112 = ls_112 + "stop level (" + f0_23(gd_1584) + ") > " + f0_23(0.00001 * gd_636);
            ls_112 = ls_112 
            + "\n";
         }
      }
      if (g_count_1068 > 0 || FIFO) {
         li_156 = FALSE;
         if (g_count_1068 > 0) {
            if (gd_1052 / g_count_1068 <= 10.0 && (!FIFO)) {
               ls_120 = ls_120 + " ECN Exit Conditions met";
               if (AutoApply_ECN) {
                  Hard_Stop_Trailing = 1;
                  ls_120 = ls_120 + " (Hard_Stop_Trailing adjusted)";
               } else
                  if (!Hard_Stop_Trailing) ls_120 = ls_120 + ", Hard_Stop_Trailing is recommended";
               ls_120 = ls_120 + " : Close Slip <= 10    FIFO = false";
               ls_120 = ls_120 
               + "\n";
            } else li_156 = TRUE;
         } else li_156 = TRUE;
         if (li_156) {
            li_unused_152 = 1;
            ls_120 = ls_120 + "!ECN Exit Conditions failed";
            if (AutoApply_ECN && FIFO || g_count_1068 >= 15) {
               Hard_Stop_Trailing = 0;
               ls_120 = ls_120 + " (Hard_Stop_Trailing adjusted)";
            } else {
               if (Hard_Stop_Trailing) {
                  ls_120 = ls_120 + ", Hard_Stop_Trailing is NOT recommended";
                  if (AutoApply_ECN) ls_120 = ls_120 + " (auto-adjusted in " + ((15 - g_count_1068)) + ")";
               }
            }
            ls_120 = ls_120 + " : ";
            li_156 = FALSE;
            if (g_count_1068 > 0) {
               if (gd_1052 / g_count_1068 > 10.0) {
                  ls_120 = ls_120 + " Close Slip > 10";
                  ls_120 = ls_120 + "    ";
               }
            }
            if (FIFO) ls_120 = ls_120 + "FIFO = true";
            ls_120 = ls_120 
            + "\n";
         }
      }
      if (gi_1004 > 0) {
         if (gd_996 / gi_1004 <= 1000.0) ls_128 = " ECN Condition for order modification time met : " + f0_29(gd_996 / gi_1004, 0) + "ms <= 1000ms\n";
         else {
            ls_160 = "";
            if (Max_Simultaneous_Orders >= 5) ls_160 = " ( setting lower Max_Simultaneous_Orders may help ) ";
            li_unused_152 = 1;
            ls_128 = "!ECN Condition for order modification time failed" + ls_160 + " : " + f0_29(gd_996 / gi_1004, 0) + "ms > 1000ms\n";
         }
      }
      if (gi_1008 > 0) {
         ld_168 = gd_1016 / (5 * gi_1008);
         if (ld_168 <= 0.1) ls_136 = " ECN Condition for requotes met : " + f0_29(100.0 * ld_168, 0) + "% <= 10% of possible requote errors\n";
         else {
            ls_176 = "";
            if (Max_Simultaneous_Orders >= 5) ls_176 = " ( setting lower Max_Simultaneous_Orders may help ) ";
            li_unused_152 = 1;
            ls_136 = "!ECN Condition for requotes failed" + ls_176 + " : " + f0_29(100.0 * ld_168, 1) + "% > 10% of possible requote errors\n";
         }
      }
      if (gd_1632 <= 0.00001 * gd_404) {
         ld_184 = gd_404 - gd_396;
         ld_192 = MathMin(ld_184, MathMax(gd_404 - gd_1632 / 0.00001, 0));
         ld_200 = 90.0 * (MathPow(ld_192, 1.5) / MathPow(ld_184, 1.5)) + 10.0;
      } else ld_200 = 0;
      if (gd_1632 <= 0.0002) ls_144 = " ECN Condition of low spread met : realAvgSpread <= " + f0_23(0.0002) + "    spread strength (affecting trading frequency):" + f0_29(ld_200, 0) + "% (higher is better)\n";
      else {
         li_unused_152 = 1;
         ls_144 = "!ECN Condition of low spread failed : realAvgSpread > " + f0_23(0.0002) + "    spread strength (affecting trading frequency):" + f0_29(ld_200, 0) + "% (higher is better)\n";
      }
   }
   if (gi_1744 || (ls_56 != "" && g_count_1100 == 0) && (!IsTesting())) {
      index_208 = 0;
      for (int count_8 = 0; count_8 <= 14; count_8++) {
         for (int li_12 = 1; li_12 <= gi_1716; li_12++) {
            if (!f0_10(count_8, li_12)) {
               var_name_48 = f0_30() + count_8 + "," + li_12;
               ticket_16 = GlobalVariableGet(var_name_48);
               ArrayResize(lia_212, index_208 + 1);
               lia_212[index_208] = ticket_16;
               index_208++;
            }
         }
      }
      if (index_208 > 0) ArraySort(lia_212);
      for (pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
         OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderCloseTime() == 0) {
            ticket_16 = OrderTicket();
            int index_4 = 0;
            for (index_4 = 0; index_4 < index_208; index_4++) {
               li_216 = lia_212[index_4];
               if (ticket_16 < li_216) index_4 = index_208 - 1;
               else
                  if (ticket_16 == li_216) break;
            }
            if (index_4 >= index_208) {
               if (index_208 < 15 * gi_1716) {
                  for (int count_8 = 0; count_8 <= 14; count_8++) {
                     for (int li_12 = 1; li_12 <= gi_1716; li_12++) {
                        if (f0_10(count_8, li_12)) {
                           var_name_48 = f0_30() + count_8 + "," + li_12;
                           GlobalVariableSet(var_name_48, ticket_16);
                           GlobalVariableSet(var_name_48 + "PriceProcessed", 1);
                           GlobalVariableSet(var_name_48 + "USO", Use_Stop_Orders);
                           GlobalVariableSet(var_name_48 + "HST", Hard_Stop_Trailing);
                           GlobalVariableSet(var_name_48 + "SL", 0);
                           GlobalVariableSet(var_name_48 + "TP", 0);
                           GlobalVariableSet(var_name_48 + "Price", 0);
                           ArrayResize(lia_212, index_208 + 1);
                           lia_212[index_208] = ticket_16;
                           index_208++;
                           Print("Order #" + ticket_16 + " recovered using Magic:" + Magic + " index:" + count_8 + " subindex:" + li_12);
                           count_8 = 14;
                           li_12 = gi_1716;
                        }
                     }
                  }
                  continue;
               }
               Print("Closing order #" + ticket_16 + " using Magic:" + Magic);
               f0_0(ticket_16);
            }
         }
      }
      gi_1744 = FALSE;
   }
   g_count_1656 = 0;
   gi_1664 = -1;
   gi_1668 = 0;
   if ((!IsTesting()) || !gi_1372 || gi_1736) {
      if (FIFO) {
         li_220 = -1;
         for (pos_0 = 14; pos_0 >= 0; pos_0--) {
            for (int li_12 = 1; li_12 <= gi_1716; li_12++) {
               var_name_48 = f0_30() + pos_0 + "," + li_12;
               ticket_16 = GlobalVariableGet(var_name_48);
               if (li_220 < ticket_16)
                  if (f0_9(pos_0, li_12)) li_220 = ticket_16;
            }
         }
         if (li_220 >= 0) {
            Print(g_count_1100 + ": Closing FIFO Orders...");
            index_224 = 0;
            for (pos_0 = 0; pos_0 <= 14; pos_0++) {
               for (int li_12 = 1; li_12 <= gi_1716; li_12++) {
                  var_name_48 = f0_30() + pos_0 + "," + li_12;
                  ticket_16 = GlobalVariableGet(var_name_48);
                  if (ticket_16 <= li_220) {
                     ArrayResize(lia_228, index_224 + 1);
                     lia_228[index_224] = ticket_16;
                     index_224++;
                     GlobalVariableSet("ClosedManually#" + ticket_16, 1);
                  }
               }
            }
            ArraySort(lia_228);
            for (pos_0 = 0; pos_0 < index_224; pos_0++) f0_0(lia_228[pos_0]);
         }
      } else {
         for (pos_0 = 0; pos_0 <= 14; pos_0++) {
            for (int li_12 = 1; li_12 <= gi_1716; li_12++)
               if (f0_9(pos_0, li_12)) f0_34(pos_0, li_12);
         }
      }
      for (pos_0 = 0; pos_0 <= 14; pos_0++) {
         for (int index_4 = 1; index_4 <= gi_1716; index_4++) {
            var_name_48 = f0_30() + pos_0 + "," + index_4;
            ticket_16 = GlobalVariableGet(var_name_48);
            if (OrderSelect(ticket_16, SELECT_BY_TICKET) && OrderCloseTime() == 0) f0_19(OrderType(), pos_0);
         }
      }
   }
   if ((!IsTesting()) || Show_Debug || Verbose) {
      ls_232 = TimeToStr(TimeCurrent()) + " tick:" + f0_12(g_count_1100) + "  base balance:" + f0_29(gd_380, 2);
      ls_232 = ls_232 
      + "\n";
      ls_232 = ls_232 + ls_56;
      ls_232 = ls_232 + " NumOrders_Level:" + NumOrders_Level + "  Additional_Channels:" + Additional_Channels + "  Max.Sim.:" + Max_Simultaneous_Orders + "  Use_Stop_Orders:" +
         f0_4(Use_Stop_Orders) + "  Hard_Stop_Trailing:" + f0_4(Hard_Stop_Trailing) + "  FIFO:" + f0_4(FIFO);
      ls_232 = ls_232 
      + "\n";
      ls_232 = ls_232 + " Bid:" + f0_23(Bid) + " Ask:" + f0_23(Ask) + " avgSpread:" + f0_23(gd_1600) + "  Commission rate:" + f0_23(gd_948);
      ls_232 = ls_232 + "  Real avg. spread:" + f0_23(gd_1632);
      ls_232 = ls_232 + "  ( recent:" + f0_23(gd_1640) + " )";
      ls_232 = ls_232 
      + "\n";
      ls_232 = ls_232 
      + "\n";
      if (g_count_1140) {
         ls_232 = ls_232 + " Avg Loss:" + f0_29(gd_1128 / g_count_1140, 2) + "%";
         ls_232 = ls_232 + "  Max Loss:" + f0_29(gd_1120, 2) + "% at order #" + g_ticket_1136;
         ls_232 = ls_232 
         + "\n";
      }
      if (gi_972) {
         ls_232 = ls_232 + " Avg. Exec. Time:" + f0_29(gd_964 / gi_972, 0) + "ms";
         if (gi_988) ls_232 = ls_232 + "   Avg. Open Time:" + f0_29(gd_980 / gi_988, 0) + "ms";
         if (gi_1004) ls_232 = ls_232 + "   Avg. Modify Time:" + f0_29(gd_996 / gi_1004, 0) + "ms";
         if (gi_1008) ls_232 = ls_232 + "   Avg. Num. Requotes:" + f0_29(gd_1016 / gi_1008, 2) + " per transaction";
         ls_232 = ls_232 
         + "\n";
      }
      if (gi_1044) {
         ls_232 = ls_232 + " Avg. Open Slip.:" + f0_29(gd_1036 / gi_1044, 0) + "  (signed):" + f0_29(gd_1028 / gi_1044, 0);
         ls_232 = ls_232 + "   ";
      }
      if (g_count_1068) ls_232 = ls_232 + " Avg. Close Slip.:" + f0_29(gd_1060 / g_count_1068, 0) + "  (signed):" + f0_29(gd_1052 / g_count_1068, 0);
      if (g_count_1140 || gi_972 || gi_1044 || g_count_1068) {
         ls_232 = ls_232 
         + "\n";
         ls_232 = ls_232 
         + "\n";
      }
      if (Show_Diagnostics) {
         ls_232 = ls_232 + " Diagnostics :      ( ! marks warning, still trading unless otherwise mentioned )";
         ls_232 = ls_232 
         + "\n";
         ls_232 = ls_232 
         + "\n";
         ls_232 = ls_232 + ls_112;
         ls_232 = ls_232 + ls_120;
         ls_232 = ls_232 + ls_128;
         ls_232 = ls_232 + ls_136;
         ls_232 = ls_232 + ls_144;
      }
      if (f0_28(gd_1632) > f0_28(0.00001 * gd_404)) {
         ls_232 = ls_232 
         + "\n";
         ls_232 = ls_232 + "!Robot is OFF :: Real avg. spread is too high for this scalping strategy ( " + f0_23(gd_1632) + " > " + f0_23(0.00001 * gd_404) + " )" 
         + "\n";
      } else {
         if (f0_28(gd_1640) > f0_28(0.00001 * gd_404)) {
            ls_232 = ls_232 
            + "\n";
            ls_232 = ls_232 + "!Robot is OFF :: Real avg. (recent) spread is too high for this scalping strategy ( " + f0_23(gd_1640) + " > " + f0_23(0.00001 * gd_404) + " )" 
            + "\n";
         }
      }
      gs_1672 = gs_1672 + ls_232;
   }
}

void f0_40(int ai_0, int ai_4, int ai_8, int ai_12, int ai_16, bool ai_20, double ad_24, double ad_32, double ad_40, double ad_48, double ad_56, double ad_64, double ad_72, double ad_80, double ad_88, double ad_96, double ad_104, int ai_112, double ad_116, double& ada_124[]) {
   int ticket_136;
   string var_name_204;
   double ibands_212;
   double ibands_220;
   double ihigh_228;
   double ilow_236;
   double ld_244;
   double lda_256[2];
   double ld_316;
   double ld_324;
   int li_332;
   double ld_336;
   int li_368;
   double ld_372;
   string ls_424;
   bool li_432;
   if (ai_4 == 5) {
      ihigh_228 = g_ihigh_1448;
      ilow_236 = g_ilow_1456;
      ld_244 = gd_1464;
   } else {
      ihigh_228 = g_ihigh_1424;
      ilow_236 = g_ilow_1432;
      ld_244 = gd_1440;
   }
   switch (ai_8) {
   case 0:
      ibands_212 = g_ibands_1472;
      ibands_220 = g_ibands_1480;
      break;
   case 3:
      ibands_212 = g_ibands_1488;
      ibands_220 = g_ibands_1496;
      break;
   case 6:
      ibands_212 = g_ibands_1504;
      ibands_220 = g_ibands_1512;
      break;
   case 9:
      ibands_212 = g_ibands_1520;
      ibands_220 = g_ibands_1528;
      break;
   case 12:
      ibands_212 = g_ibands_1536;
      ibands_220 = g_ibands_1544;
   }
   lda_256[0] = ad_64;
   lda_256[1] = ad_80;
   f0_20(lda_256);
   ad_64 = lda_256[0];
   ad_80 = lda_256[1];
   double ld_260 = ibands_212 - ibands_220;
   double ld_268 = ibands_220 + ld_260 / 2.0;
   double ld_276 = gd_684;
   double ld_284 = 0.00001 * ad_104;
   double ld_292 = 0.00001 * gd_628;
   double ld_300 = ld_292;
   double ld_308 = 0.00001 * Trailing_Resolution;
   ld_284 = MathMax(ld_284, gd_1584);
   NumOrders_Level = MathMax(0, NumOrders_Level);
   NumOrders_Level = MathMin(4, NumOrders_Level);
   if (gi_1376) {
      gda_1412[7] = 0;
      gda_1412[8] = 0;
      gda_1412[9] = gi_1384;
      fun(ai_0, ai_4, 0, 0, ad_40, ad_24, ad_32, gd_396, gd_404, ad_48, gd_684, ad_56, ad_64, ad_72, ad_80, ad_88, gd_1356, ad_96, gd_1364, NumOrders_Level - 2, ibands_220,
         ibands_212, ld_276, ld_292, ld_308, gd_1632, 0.00001, Bid, ld_244, ada_124, gda_1412);
      ld_316 = gda_1412[0];
      ld_324 = gda_1412[1];
      li_332 = gda_1412[2];
      ld_336 = gda_1412[3];
      ld_276 = gda_1412[4];
      ld_292 = gda_1412[5];
      ld_308 = gda_1412[6];
      gda_1072[ai_8 / 3] = ld_336;
   } else gda_1072[ai_8 / 3] = 0;
   double ld_344 = gd_684;
   double ld_352 = 0.00001 * gd_628;
   double ld_360 = 0.00001 * Trailing_Resolution;
   if (gi_1380) {
      gda_1412[7] = 0;
      gda_1412[8] = 0;
      gda_1412[9] = gi_1384;
      fun(ai_0, ai_4, 0, 1, ad_40, ad_24, ad_32, gd_396, gd_404, ad_48, gd_684, ad_56, ad_64, ad_72, ad_80, ad_88, gd_1356, ad_96, gd_1364, NumOrders_Level - 2, ibands_220,
         ibands_212, ld_344, ld_352, ld_360, gd_1632, 0.00001, Bid, ld_244, ada_124, gda_1412);
      li_368 = gda_1412[2];
      ld_372 = gda_1412[3];
      ld_344 = gda_1412[4];
      ld_352 = gda_1412[5];
      ld_360 = gda_1412[6];
      gda_1072[ai_8 / 3 * 2] = ld_372;
   } else gda_1072[ai_8 / 3 * 2] = 0;
   if (Bid == 0.0 || MarketInfo(Symbol(), MODE_LOTSIZE) == 0.0) {
      ld_336 = 0;
      ld_372 = 0;
   } else {
      ld_336 = MathMax(0.0001, MathMax(gd_1584, ld_336));
      ld_372 = MathMax(0.0001, MathMax(gd_1584, ld_372));
   }
   if (gi_1112) gi_1680 = TimeCurrent() + 60.0 * MathMax(10 * ai_0, 60);
   else gi_1680 = 0;
   g_count_1652 = 0;
   g_count_1660 = 0;
   int count_380 = 0;
   int count_384 = 0;
   int count_388 = 0;
   if ((!IsTesting()) || !gi_1372 || gi_1736) {
      for (int li_128 = 1; li_128 <= gi_1716; li_128++) {
         if (gi_1376) {
            var_name_204 = f0_30() + ai_8 + "," + li_128;
            ticket_136 = GlobalVariableGet(var_name_204);
            if (OrderSelect(ticket_136, SELECT_BY_TICKET)) {
               count_380++;
               if (TimeCurrent() - OrderOpenTime() < 180) g_count_1660++;
               if (OrderCloseTime() == 0) f0_24(ai_8, li_128, ibands_220, ibands_212, ld_268, ld_336, ld_284, ld_292, ld_300, ld_308, ld_276);
            }
         }
         if (gi_1380) {
            var_name_204 = f0_30() + ai_16 + "," + li_128;
            ticket_136 = GlobalVariableGet(var_name_204);
            if (OrderSelect(ticket_136, SELECT_BY_TICKET)) {
               count_388++;
               if (TimeCurrent() - OrderOpenTime() < 180) g_count_1660++;
               if (OrderCloseTime() == 0) f0_24(ai_16, li_128, ibands_220, ibands_212, ld_268, ld_372, ld_284, ld_352, ld_300, ld_360, ld_344);
            }
         }
         if (ai_20) {
            var_name_204 = f0_30() + ai_12 + "," + li_128;
            ticket_136 = GlobalVariableGet(var_name_204);
            if (OrderSelect(ticket_136, SELECT_BY_TICKET)) {
               count_384++;
               if (TimeCurrent() - OrderOpenTime() < 180) g_count_1660++;
               if (OrderCloseTime() == 0) f0_24(ai_12, li_128, ibands_220, ibands_212, ld_268, ld_336, ld_284, ld_292, ld_300, ld_308, ld_276);
            }
         }
      }
   }
   string ls_392 = "";
   double ld_400 = 0;
   double ld_408 = 0;
   double ld_416 = 0;
   bool bool_144 = g_count_1656 < Max_Simultaneous_Orders && gi_1668 == 0 || (gi_1668 != (-li_332) && gi_1668 != (-li_368)) && f0_28(gd_1632) <= f0_28(0.00001 * gd_404) && f0_28(gd_1640) <= f0_28(0.00001 * gd_404) && gi_956 == -1;
   if ((!IsTesting()) || Show_Debug || Verbose) {
      if (gi_1376) {
         ld_400 = f0_13(ld_336, ld_276, li_332, 0);
         ls_392 = ls_392 + gs_1416;
         if (count_380 > 0) ls_392 = ls_392 + "   Running Trades:" + count_380;
         ls_392 = ls_392 
         + "\n";
      }
      if (gi_1380) {
         ld_416 = f0_13(ld_372, ld_344, li_368, ld_400);
         ls_392 = ls_392 + gs_1416;
         if (count_388 > 0) ls_392 = ls_392 + "   Running Trades:" + count_388;
         ls_392 = ls_392 
         + "\n";
      }
      if (ai_20) {
         ld_408 = f0_13(ld_336, ld_276, li_332, ld_400 + ld_416);
         ls_392 = ls_392 + gs_1416;
         if (count_384 > 0) ls_392 = ls_392 + "   Running Trades:" + count_384;
         ls_392 = ls_392 
         + "\n";
      }
   }
   if (bool_144) {
      if (gi_1376 && ld_336 > 0.0 && li_332 != 0) {
         ld_400 = f0_13(ld_336, ld_276, li_332, 0);
         f0_33(ai_8, ilow_236, ihigh_228, ld_336, ld_292, ld_300, ld_276, li_332, ld_400);
      }
      if (gi_1380 && ld_372 > 0.0 && li_368 != 0 && g_count_1656 < Max_Simultaneous_Orders) {
         ld_416 = f0_13(ld_372, ld_344, li_368, 0);
         f0_33(ai_16, ilow_236, ihigh_228, ld_372, ld_352, ld_300, ld_344, li_368, ld_416);
      }
      if (ai_20 && ld_336 > 0.0 && li_332 != 0 && g_count_1656 < Max_Simultaneous_Orders) {
         ld_408 = f0_13(ld_336, ld_276, li_332, 0);
         f0_33(ai_12, ilow_236, ihigh_228, ld_336, ld_292, ld_300, ld_276, li_332, ld_408);
      }
   }
   if (g_count_1652 > 0) gi_1740 = TRUE;
   if (gi_956 >= 0) Comment("Robot is initializing...");
   else {
      if (gi_956 == -2) Comment("ERROR -- Instrument " + Symbol() + " prices should have " + 5 + " fraction digits on broker account");
      else {
         ls_424 = "";
         if (Show_Debug || Verbose) {
            ls_424 = ls_424 + " " + f0_23(ld_324) + " (" + ld_316 + "->" + ad_32 + ")" + " " + f0_23(ld_336) + " digits:" + 5 + " " + gi_956 + " stopLevel:" + f0_23(gd_1584) + " (" + ld_276 + ")" 
            + "\n";
            ls_424 = ls_424 + " " + li_332 + " " + f0_23(ibands_220) + " " + f0_23(ibands_212) + " " + f0_23(ad_40) + " exp:" + TimeToStr(gi_1680, TIME_MINUTES) + " numOrders:" + g_count_1652 + " numRecentOrders:" + g_count_1660 
            + "\n";
            ls_424 = ls_424 + " " + "trailingLimit:" + f0_23(ld_292) + " trailingDist:" + f0_23(ld_284) + " trailingResolution:" + f0_23(ld_308) 
            + "\n";
         }
         if ((!IsTesting()) || Show_Debug || Verbose) {
            if (Show_Diagnostics) ls_424 = ls_424 + ls_392;
            gs_1672 = gs_1672 + ls_424;
            if (Verbose) f0_26(ls_424);
         }
      }
   }
   g_count_1708 = gi_1712;
   if (g_error_1144) {
      li_432 = f0_27(g_error_1144);
      gi_1712 = g_count_1708;
      if (li_432) f0_40(ai_0, ai_4, ai_8, ai_12, ai_16, ai_20, ad_24, ad_32, ad_40, ad_48, ad_56, ad_64, ad_72, ad_80, ad_88, ad_96, ad_104, ai_112, ad_116, ada_124);
   }
}

string f0_30() {
   if (IsTesting()) return ("MDPEU" + Magic + "T");
   return ("MDPEU" + Magic);
}

int f0_9(int ai_0, int ai_4) {
   double global_var_8;
   double global_var_16;
   string var_name_24;
   int global_var_32;
   double ibands_36;
   double ibands_44;
   double ld_56;
   double ld_64;
   int li_72;
   int li_76;
   bool li_ret_80;
   if (f0_10(ai_0, ai_4)) GetLastError();
   else {
      var_name_24 = f0_30() + ai_0 + "," + ai_4;
      global_var_32 = GlobalVariableGet(var_name_24);
      if (OrderSelect(global_var_32, SELECT_BY_TICKET) && OrderCloseTime() == 0 && (!GlobalVariableGet(var_name_24 + "HST"))) {
         switch (ai_0) {
         case 0:
         case 1:
         case 2:
            ibands_36 = g_ibands_1472;
            ibands_44 = g_ibands_1480;
            break;
         case 3:
         case 4:
         case 5:
            ibands_36 = g_ibands_1488;
            ibands_44 = g_ibands_1496;
            break;
         case 6:
         case 7:
         case 8:
            ibands_36 = g_ibands_1504;
            ibands_44 = g_ibands_1512;
            break;
         case 9:
         case 10:
         case 11:
            ibands_36 = g_ibands_1520;
            ibands_44 = g_ibands_1528;
            break;
         case 12:
         case 13:
         case 14:
            ibands_36 = g_ibands_1536;
            ibands_44 = g_ibands_1544;
         }
         ld_56 = ibands_36 - ibands_44;
         ld_64 = ibands_44 + ld_56 / 2.0;
         li_72 = Bid >= ld_64;
         li_76 = Bid <= ld_64;
         li_ret_80 = FALSE;
         global_var_16 = GlobalVariableGet(var_name_24 + "TP");
         global_var_8 = GlobalVariableGet(var_name_24 + "SL");
         switch (OrderType()) {
         case OP_BUY:
            if (Funky_Exit) li_ret_80 = Bid >= gd_1576;
            else li_ret_80 = li_72;
            if (li_ret_80) {
               gi_1116++;
               if (IsTesting()) Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": cntDirectClose:" + gi_1116);
            }
            if (!li_ret_80) li_ret_80 = f0_21(Ask, global_var_16, 65280);
            if (!li_ret_80) li_ret_80 = f0_8(Bid, global_var_8, 65280);
            if (!(li_ret_80)) break;
            GlobalVariableSet("ClosedManually#" + global_var_32, 1);
            break;
         case OP_SELL:
            if (Funky_Exit) li_ret_80 = Bid <= gd_1576;
            else li_ret_80 = li_76;
            if (li_ret_80) {
               gi_1116++;
               if (IsTesting()) Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": cntDirectClose:" + gi_1116);
            }
            if (!li_ret_80) li_ret_80 = f0_21(Ask, global_var_8, 42495);
            if (!li_ret_80) li_ret_80 = f0_8(Bid, global_var_16, 42495);
            if (!(li_ret_80)) break;
            GlobalVariableSet("ClosedManually#" + global_var_32, 1);
         }
         return (li_ret_80);
      }
   }
   return (0);
}

int f0_21(double ad_0, double ad_8, int ai_unused_16) {
   double ld_24 = gda_892[0] - gda_892[1];
   bool bool_20 = ld_24 > 0.0 && ad_8 <= ad_0 + 0.00001 * Slippage;
   return (bool_20);
}

int f0_8(double ad_0, double ad_8, int ai_unused_16) {
   double ld_24 = gda_892[0] - gda_892[1];
   bool bool_20 = ld_24 < 0.0 && ad_8 >= ad_0 - 0.00001 * Slippage;
   return (bool_20);
}

void f0_34(int ai_0, int ai_4) {
   if (f0_10(ai_0, ai_4)) {
      GetLastError();
      return;
   }
   string var_name_8 = f0_30() + ai_0 + "," + ai_4;
   int global_var_16 = GlobalVariableGet(var_name_8);
   Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + "...");
   f0_0(global_var_16);
}

void f0_0(int a_ticket_0) {
   if (OrderSelect(a_ticket_0, SELECT_BY_TICKET) && OrderCloseTime() == 0) {
      switch (OrderType()) {
      case OP_BUY:
         Print(g_count_1100 + ": Closing Soft Stop BUY #" + a_ticket_0);
         f0_35(Bid, Lime);
         return;
      case OP_SELL:
         Print(g_count_1100 + ": Closing Soft Stop SELL #" + a_ticket_0);
         f0_35(Ask, Orange);
      }
   }
}

void f0_35(double a_price_0, color a_color_8) {
   bool is_closed_12;
   int li_16;
   int li_20;
   g_count_1708 = 0;
   while (true) {
      li_20 = GetTickCount();
      is_closed_12 = OrderClose(OrderTicket(), OrderLots(), a_price_0, 100000, a_color_8);
      f0_43(li_20);
      if (is_closed_12) {
         f0_7(g_count_1708);
         return;
      }
      li_16 = f0_27(0/* NO_ERROR */);
      if (!(li_16)) break;
   }
}

int f0_1(int ai_0) {
   for (int li_ret_4 = 1; li_ret_4 <= gi_1716; li_ret_4++)
      if (f0_10(ai_0, li_ret_4)) return (li_ret_4);
   for (int li_ret_4 = 1; li_ret_4 <= gi_1716; li_ret_4++) f0_45(ai_0, li_ret_4);
   for (int li_ret_4 = 1; li_ret_4 <= gi_1716; li_ret_4++)
      if (f0_10(ai_0, li_ret_4)) return (li_ret_4);
   return (-1);
}

bool f0_10(int ai_0, int ai_4) {
   string var_name_8 = f0_30() + ai_0 + "," + ai_4;
   return (!GlobalVariableCheck(var_name_8) || GlobalVariableGet(var_name_8) == -1.0);
}

void f0_25() {
   for (int count_0 = 0; count_0 <= 14; count_0++) for (int li_4 = 1; li_4 <= gi_1716; li_4++) f0_45(count_0, li_4);
}

void f0_45(int ai_0, int ai_4) {
   string var_name_8 = f0_30() + ai_0 + "," + ai_4;
   int global_var_16 = GlobalVariableGet(var_name_8);
   if (OrderSelect(global_var_16, SELECT_BY_TICKET)) {
      if (OrderCloseTime() != 0) {
         if (!Silent) PlaySound("alert2.wav");
         f0_3();
         f0_18();
         GlobalVariableSet(var_name_8, -1);
      }
   } else GlobalVariableSet(var_name_8, -1);
}

void f0_19(int ai_0, int ai_4) {
   switch (ai_0) {
   case 0:
   case 4:
      gi_1668 = -1;
      break;
   case 1:
   case 5:
      gi_1668 = 1;
   }
   g_count_1656++;
   g_count_1652++;
   gi_1664 = MathMax(gi_1664, ai_4);
}

void f0_14() {
   string var_name_8;
   int global_var_16;
   string ls_20;
   for (int count_0 = 0; count_0 <= 14; count_0++) {
      for (int li_4 = 1; li_4 <= gi_1716; li_4++) {
         if (!f0_10(count_0, li_4)) {
            var_name_8 = f0_30() + count_0 + "," + li_4;
            global_var_16 = GlobalVariableGet(var_name_8);
            if (OrderSelect(global_var_16, SELECT_BY_TICKET)) {
               ls_20 = f0_31(OrderType()) + "#" + global_var_16 + " price:" + f0_23(OrderOpenPrice()) + "(" + f0_23(GlobalVariableGet(var_name_8 + "Price")) + ")" + " sl/hard:" + f0_23(OrderStopLoss()) + " tp/hard:" + f0_23(OrderTakeProfit()) + " sl:" + f0_23(GlobalVariableGet(var_name_8 + "SL")) + " tp:" + f0_23(GlobalVariableGet(var_name_8 + "TP")) + " opened:" + TimeToStr(OrderOpenTime());
               if (OrderCloseTime() != 0) ls_20 = ls_20 + " closed:" + TimeToStr(OrderCloseTime());
               Print(g_count_1100 + ":" + count_0 + "," + li_4 + ": " + ls_20);
               continue;
            }
            Print(g_count_1100 + ": " + count_0 + "," + li_4 + ": #" + global_var_16 + " MISSING");
         }
      }
   }
}

void f0_24(int ai_0, int ai_4, double ad_unused_8, double ad_unused_16, double ad_24, double ad_unused_32, double ad_40, double ad_48, double ad_56, double ad_64, double ad_72) {
   int li_unused_80;
   int li_84;
   bool li_92;
   bool li_96;
   double ld_116;
   double ld_164;
   double ld_172;
   double ld_196;
   bool li_204 = Bid >= ad_24;
   bool li_208 = Bid <= ad_24;
   string ls_212 = f0_30() + ai_0 + "," + ai_4;
   double global_var_220 = GlobalVariableGet(ls_212 + "Price");
   bool global_var_228 = GlobalVariableGet(ls_212 + "PriceProcessed");
   int cmd_232 = OrderType();
   if (cmd_232 != OP_BUY) {
      if (cmd_232 == OP_SELL) {
      }
   }
   double order_stoploss_180 = OrderStopLoss();
   double order_takeprofit_188 = OrderTakeProfit();
   double global_var_156 = GlobalVariableGet(ls_212 + "TP");
   double global_var_148 = GlobalVariableGet(ls_212 + "SL");
   if (ad_48 < gd_1584) {
      ad_48 = gd_1584;
      ad_56 = gd_1584 + 0.00001 * Slippage;
   }
   switch (OrderType()) {
   case OP_BUY:
      if (!global_var_228) {
         ArrayCopy(gda_1024, gda_1024, 0, 1, 99);
         gda_1024[99] = MathRound((OrderOpenPrice() - global_var_220) / 0.00001);
         if (gi_1044 < 100) gi_1044++;
         GlobalVariableSet(ls_212 + "PriceProcessed", 1);
      }
      if (GlobalVariableGet(ls_212 + "HST") && Funky_Exit && Bid >= gd_1576) {
         f0_35(Bid, Lime);
         GlobalVariableSet("ClosedManually#" + OrderTicket(), 1);
         gi_1116++;
         if (!(IsTesting())) break;
         Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": cntDirectClose:" + gi_1116);
      } else {
         if (GlobalVariableGet(ls_212 + "HST") && (!Funky_Exit) && li_204) {
            f0_35(Bid, Lime);
            GlobalVariableSet("ClosedManually#" + OrderTicket(), 1);
            gi_1116++;
            if (!(IsTesting())) break;
            Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": cntDirectClose:" + gi_1116);
         } else {
            if (gi_700) {
               if (global_var_148 != 0.0) {
                  ld_116 = (global_var_156 - global_var_148 - gd_1600 - gd_948) / 2.0;
                  ad_40 = MathMin(ad_40, ld_116);
                  ad_40 = MathMax(ad_40, gd_1584);
               }
               g_count_1708 = 0;
               while (true) {
                  ld_164 = f0_28(Bid - ad_40);
                  ld_172 = f0_28(gd_1616 + ad_40);
                  if (!(global_var_148 == 0.0 || order_stoploss_180 == 0.0 || (global_var_156 < ld_172 && ld_172 - global_var_156 > ad_64) || (global_var_148 < ld_164 && ld_164 - global_var_148 > ad_64))) break;
                  if (global_var_148 != 0.0) {
                     ld_164 = MathMax(global_var_148, ld_164);
                     ld_172 = MathMax(global_var_156, ld_172);
                  }
                  Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": Modify Order #" + OrderTicket() + " BUY tp:" + f0_23(global_var_156) + "->" + f0_23(ld_172) + "  sl:" + f0_23(global_var_148) +
                     "->" + f0_23(ld_164));
                  if (GlobalVariableGet(ls_212 + "HST")) {
                     li_84 = GetTickCount();
                     li_96 = OrderModify(OrderTicket(), 0, ld_164, ld_172, gi_1680, Lime);
                     f0_43(li_84);
                     f0_22(li_84);
                  } else {
                     if (!IsTesting() && order_stoploss_180 == 0.0 || (order_stoploss_180 < ld_164 - 0.0008 && ld_164 - 0.0008 - order_stoploss_180 > 0.0002)) {
                        li_84 = GetTickCount();
                        li_96 = OrderModify(OrderTicket(), 0, ld_164 - 0.0008, ld_172 + 0.0008, gi_1680, Lime);
                        f0_43(li_84);
                        f0_22(li_84);
                     } else li_96 = TRUE;
                  }
                  if (li_96) {
                     f0_7(g_count_1708);
                     GlobalVariableSet(ls_212 + "TP", ld_172);
                     GlobalVariableSet(ls_212 + "SL", ld_164);
                     break;
                  }
                  li_92 = f0_27(0/* NO_ERROR */);
                  if (!(li_92)) break;
               }
            }
            g_count_1652++;
            gi_1668 = -1;
            return;
         }
      }
   case OP_SELL:
      if (!global_var_228) {
         ArrayCopy(gda_1024, gda_1024, 0, 1, 99);
         gda_1024[99] = MathRound((global_var_220 - OrderOpenPrice()) / 0.00001);
         if (gi_1044 < 100) gi_1044++;
         GlobalVariableSet(ls_212 + "PriceProcessed", 1);
      }
      if (GlobalVariableGet(ls_212 + "HST") && Funky_Exit && Bid <= gd_1576) {
         f0_35(Ask, Orange);
         GlobalVariableSet("ClosedManually#" + OrderTicket(), 1);
         gi_1116++;
         if (!(IsTesting())) break;
         Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": cntDirectClose:" + gi_1116);
      } else {
         if (GlobalVariableGet(ls_212 + "HST") && (!Funky_Exit) && li_208) {
            f0_35(Ask, Orange);
            GlobalVariableSet("ClosedManually#" + OrderTicket(), 1);
            gi_1116++;
            if (!(IsTesting())) break;
            Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": cntDirectClose:" + gi_1116);
         } else {
            if (gi_700) {
               if (global_var_148 != 0.0) {
                  ld_116 = (global_var_148 - global_var_156 - gd_1600 - gd_948) / 2.0;
                  ad_40 = MathMin(ad_40, ld_116);
                  ad_40 = MathMax(ad_40, gd_1584);
               }
               g_count_1708 = 0;
               while (true) {
                  ld_164 = f0_28(Ask + ad_40);
                  ld_172 = f0_28(gd_1624 - ad_40);
                  if (!(global_var_148 == 0.0 || order_stoploss_180 == 0.0 || (global_var_156 > ld_172 && global_var_156 - ld_172 > ad_64) || (global_var_148 > ld_164 && global_var_148 - ld_164 > ad_64))) break;
                  if (global_var_148 != 0.0) {
                     ld_164 = MathMin(global_var_148, ld_164);
                     ld_172 = MathMin(global_var_156, ld_172);
                  }
                  Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": Modify Order #" + OrderTicket() + " SELL tp:" + f0_23(global_var_156) + "->" + f0_23(ld_172) + "  sl:" + f0_23(global_var_148) +
                     "->" + f0_23(ld_164));
                  if (GlobalVariableGet(ls_212 + "HST")) {
                     li_84 = GetTickCount();
                     li_96 = OrderModify(OrderTicket(), 0, ld_164, ld_172, gi_1680, Orange);
                     f0_43(li_84);
                     f0_22(li_84);
                  } else {
                     if (!IsTesting() && order_stoploss_180 == 0.0 || (order_stoploss_180 > ld_164 + 0.0008 && order_stoploss_180 - ld_164 - 0.0008 > 0.0002)) {
                        li_84 = GetTickCount();
                        li_96 = OrderModify(OrderTicket(), 0, ld_164 + 0.0008, ld_172 - 0.0008, gi_1680, Orange);
                        f0_43(li_84);
                        f0_22(li_84);
                     } else li_96 = TRUE;
                  }
                  if (li_96) {
                     f0_7(g_count_1708);
                     GlobalVariableSet(ls_212 + "TP", ld_172);
                     GlobalVariableSet(ls_212 + "SL", ld_164);
                     break;
                  }
                  li_92 = f0_27(0/* NO_ERROR */);
                  if (!(li_92)) break;
               }
            }
            g_count_1652++;
            gi_1668 = 1;
            return;
         }
      }
   case OP_BUYSTOP:
      if (li_208) {
         ld_116 = OrderTakeProfit() - OrderOpenPrice() - gd_948;
         ld_196 = ad_48;
         g_count_1708 = 0;
         while (true) {
            global_var_220 = f0_28(Ask + ld_196);
            if (!(global_var_220 < OrderOpenPrice() && OrderOpenPrice() - global_var_220 > ad_64)) break;
            ld_164 = f0_28(Bid + ld_196 - ld_116 * ad_72);
            ld_172 = f0_28(gd_1616 + ld_196 + ld_116);
            if (GlobalVariableGet(ls_212 + "HST")) {
               li_84 = GetTickCount();
               li_96 = OrderModify(OrderTicket(), global_var_220, ld_164, ld_172, 0, Lime);
               f0_43(li_84);
               f0_22(li_84);
            } else {
               if (!IsTesting() && order_stoploss_180 == 0.0 || (order_stoploss_180 < ld_164 - 0.0008 && ld_164 - 0.0008 - order_stoploss_180 > 0.0002)) {
                  li_84 = GetTickCount();
                  li_96 = OrderModify(OrderTicket(), global_var_220, ld_164 - 0.0008, ld_172 + 0.0008, 0, Lime);
                  f0_43(li_84);
                  f0_22(li_84);
               } else {
                  li_84 = GetTickCount();
                  li_96 = OrderModify(OrderTicket(), global_var_220, 0, 0, 0, Lime);
                  f0_43(li_84);
                  f0_22(li_84);
               }
            }
            if (li_96) {
               f0_7(g_count_1708);
               GlobalVariableSet(ls_212 + "Price", global_var_220);
               GlobalVariableSet(ls_212 + "TP", ld_172);
               GlobalVariableSet(ls_212 + "SL", ld_164);
               break;
            }
            li_92 = f0_27(0/* NO_ERROR */);
            if (!(li_92)) break;
            ld_196 = ad_56;
         }
         g_count_1652++;
         gi_1668 = -1;
      } else {
         li_92 = FALSE;
         g_count_1708 = 0;
         while (true) {
            li_84 = GetTickCount();
            li_96 = OrderDelete(OrderTicket());
            f0_43(li_84);
            if (li_96) {
               f0_7(g_count_1708);
               break;
            }
            if (!li_92) Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": WARN Unable to delete BUYSTOP Order #" + OrderTicket());
            li_92 = f0_27(0/* NO_ERROR */);
            if (!(li_92)) break;
         }
         li_unused_80 = -1;
         return;
      }
   case OP_SELLSTOP:
      if (li_204) {
         ld_116 = OrderOpenPrice() - OrderTakeProfit() - gd_948;
         ld_196 = ad_48;
         g_count_1708 = 0;
         while (true) {
            global_var_220 = f0_28(Bid - ld_196);
            if (!(global_var_220 > OrderOpenPrice() && global_var_220 - OrderOpenPrice() > ad_64)) break;
            ld_164 = f0_28(Ask - ld_196 + ld_116 * ad_72);
            ld_172 = f0_28(gd_1624 - ld_196 - ld_116);
            if (GlobalVariableGet(ls_212 + "HST")) {
               li_84 = GetTickCount();
               li_96 = OrderModify(OrderTicket(), global_var_220, ld_164, ld_172, 0, Orange);
               f0_43(li_84);
               f0_22(li_84);
            } else {
               if (!IsTesting() && order_stoploss_180 == 0.0 || (order_stoploss_180 > ld_164 + 0.0008 && order_stoploss_180 - ld_164 - 0.0008 > 0.0002)) {
                  li_84 = GetTickCount();
                  li_96 = OrderModify(OrderTicket(), global_var_220, ld_164 + 0.0008, ld_172 - 0.0008, 0, Orange);
                  f0_43(li_84);
                  f0_22(li_84);
               } else {
                  li_84 = GetTickCount();
                  li_96 = OrderModify(OrderTicket(), global_var_220, 0, 0, 0, Orange);
                  f0_43(li_84);
                  f0_22(li_84);
               }
            }
            if (li_96) {
               f0_7(g_count_1708);
               GlobalVariableSet(ls_212 + "Price", global_var_220);
               GlobalVariableSet(ls_212 + "TP", ld_172);
               GlobalVariableSet(ls_212 + "SL", ld_164);
               break;
            }
            li_92 = f0_27(0/* NO_ERROR */);
            if (!(li_92)) break;
            ld_196 = ad_56;
         }
         g_count_1652++;
         gi_1668 = 1;
      } else {
         li_92 = FALSE;
         g_count_1708 = 0;
         while (true) {
            li_84 = GetTickCount();
            li_96 = OrderDelete(OrderTicket());
            f0_43(li_84);
            if (li_96) {
               f0_7(g_count_1708);
               break;
            }
            if (!li_92) Print(g_count_1100 + ":" + ai_0 + "," + ai_4 + ": WARN Unable to delete SELLSTOP Order #" + OrderTicket());
            li_92 = f0_27(0/* NO_ERROR */);
            if (!(li_92)) break;
         }
         li_unused_80 = -1;
      }
      return;
   }
}

void f0_37() {
   double ld_0;
   if (OrderSymbol() == Symbol() && OrderCloseTime() != 0 && OrderLots() != 0.0 && OrderClosePrice() != OrderOpenPrice() && OrderProfit() != 0.0 && MarketInfo(Symbol(),
      MODE_LOTSIZE) != 0.0 && OrderComment() != "partial close" && StringFind(OrderComment(), "[sl]from #") == -1 && StringFind(OrderComment(), "[tp]from #") == -1) {
      gi_932 = TRUE;
      ld_0 = MathAbs(OrderProfit() / (OrderClosePrice() - OrderOpenPrice()));
      gd_940 = ld_0 / OrderLots() / MarketInfo(Symbol(), MODE_LOTSIZE);
      gd_948 = (-OrderCommission()) / ld_0;
      Print(g_count_1100 + ": Commission_Rate : " + f0_23(gd_948));
   }
}

void f0_3() {
   double ld_0 = -1000000;
   if (!GlobalVariableGet("ClosedManually#" + OrderTicket())) {
      switch (OrderType()) {
      case OP_BUY:
         if (OrderStopLoss() != 0.0 && StringFind(OrderComment(), "[sl]") >= 0 || OrderClosePrice() <= OrderStopLoss()) ld_0 = OrderStopLoss() - OrderClosePrice();
         else {
            if (!(OrderTakeProfit() != 0.0 && StringFind(OrderComment(), "[tp]") >= 0 || OrderClosePrice() >= OrderTakeProfit())) break;
            ld_0 = OrderTakeProfit() - OrderClosePrice();
         }
         break;
      case OP_SELL:
         if (OrderStopLoss() != 0.0 && StringFind(OrderComment(), "[sl]") >= 0 || OrderClosePrice() >= OrderStopLoss()) ld_0 = OrderClosePrice() - OrderStopLoss();
         else {
            if (!(OrderTakeProfit() != 0.0 && StringFind(OrderComment(), "[tp]") >= 0 || OrderClosePrice() <= OrderTakeProfit())) break;
            ld_0 = OrderClosePrice() - OrderTakeProfit();
         }
      }
   }
   if (ld_0 != -1000000.0) {
      ArrayCopy(gda_1048, gda_1048, 0, 1, 99);
      gda_1048[99] = MathRound(ld_0 / 0.00001);
      if (g_count_1068 < 100) g_count_1068++;
   }
}

void f0_18() {
   double ld_8;
   double ld_0 = OrderProfit() + OrderCommission() + OrderSwap();
   if (ld_0 < 0.0 && gd_380 > 0.0) {
      ld_8 = NormalizeDouble(100.0 * MathAbs(ld_0) / gd_380, 2);
      gd_1128 += ld_8;
      g_count_1140++;
      if (ld_8 > gd_1120) {
         gd_1120 = ld_8;
         g_ticket_1136 = OrderTicket();
         if ((Show_Debug && (!Silent)) || Verbose) {
            Print(g_count_1100 + ": realRisk:" + f0_29(ld_8, 2) + " ( profit:" + f0_29(ld_0, 2) + " of balance:" + f0_29(gd_380, 2) + " with lot:" + f0_29(OrderLots(), 2) + " )");
            Print(g_count_1100 + ": maxRealRiskPercent:" + f0_29(gd_1120, 2));
            Print(g_count_1100 + ": maxRealRiskTicket:" + g_ticket_1136);
         }
      }
   }
}

double f0_13(double ad_0, double ad_8, int ai_unused_16, double ad_20) {
   double ld_ret_28;
   double ld_36;
   double ld_52;
   string var_name_68;
   int global_var_76;
   int cmd_80;
   double ld_84;
   double ld_92;
   double ld_100;
   double ld_108;
   double ld_44 = ad_0 * ad_8 + gd_1592;
   if (ld_44 > 0.0 && MarketInfo(Symbol(), MODE_LOTSIZE) != 0.0 && AccountLeverage() != 0) {
      ld_52 = AccountFreeMargin();
      for (int count_60 = 0; count_60 <= 14; count_60++) {
         for (int index_64 = 1; index_64 <= gi_1716; index_64++) {
            var_name_68 = f0_30() + count_60 + "," + index_64;
            global_var_76 = GlobalVariableGet(var_name_68);
            if (OrderSelect(global_var_76, SELECT_BY_TICKET) && OrderCloseTime() == 0) {
               cmd_80 = OrderType();
               if (cmd_80 != OP_BUYSTOP)
                  if (cmd_80 != OP_SELLSTOP) continue;
               ld_52 -= MarketInfo(Symbol(), MODE_LOTSIZE) * OrderLots() / AccountLeverage();
            }
         }
      }
      ld_52 -= MarketInfo(Symbol(), MODE_LOTSIZE) * ad_20 / AccountLeverage();
      gd_380 = MathMax(AccountBalance(), gd_380);
      ld_84 = (ld_52 - gd_380 / 10.0) * AccountLeverage();
      ld_ret_28 = ld_84 / MarketInfo(Symbol(), MODE_LOTSIZE);
      ld_ret_28 = NormalizeDouble(ld_ret_28, gi_1648);
      if (ld_ret_28 < MarketInfo(Symbol(), MODE_MINLOT)) {
         ld_ret_28 = 0.0;
         gs_1416 = "!Lots:0.0  Risk set at:" + f0_29(Risk, 2) + "%   ( Free Margin is too low : Channel is OFF )";
      } else {
         if (Risk_Mode_CommPips) {
            ld_100 = 0;
            for (int index_64 = 0; index_64 < 10; index_64++) ld_100 = MathMax(ld_100, gda_1072[index_64] * ad_8 + gd_1592);
            ld_100 = MathMax(ld_100, ld_44);
            ld_84 = (ld_52 - gd_380 * Risk * ld_44 / ld_100 / 100.0) * AccountLeverage() / 2.0;
            ld_92 = gd_380 * Risk / 100.0 * Bid / ld_100;
         } else {
            ld_84 = (ld_52 - gd_380 * Risk / 100.0) * AccountLeverage() / 2.0;
            ld_92 = gd_380 * Risk / 100.0 * Bid / ld_44;
         }
         ld_108 = MathMin(ld_84, ld_92);
         ld_ret_28 = ld_108 / MarketInfo(Symbol(), MODE_LOTSIZE);
         ld_ret_28 = NormalizeDouble(ld_ret_28, gi_1648);
         ld_ret_28 = MathMax(Min_Lots, ld_ret_28);
         ld_ret_28 = MathMax(MarketInfo(Symbol(), MODE_MINLOT), ld_ret_28);
         ld_ret_28 = MathMin(Max_Lots, ld_ret_28);
         ld_ret_28 = MathMin(MarketInfo(Symbol(), MODE_MAXLOT), ld_ret_28);
         gs_1416 = "Lots:" + f0_29(ld_ret_28, gi_1648) + "  ";
         if (ld_ret_28 > 0.0 && AccountBalance() > 0.0 && Bid > 0.0) {
            ld_36 = 100.0 * (ld_ret_28 * MarketInfo(Symbol(), MODE_LOTSIZE) * ld_44) / Bid / AccountBalance();
            gs_1416 = gs_1416 + "Actual Risk:" + f0_29(ld_36, 2) + "%  Risk set at:" + f0_29(Risk, 2) + "%";
            if (NormalizeDouble(ld_36, 2) > NormalizeDouble(Risk, 2)) {
               if (ld_ret_28 == Min_Lots || ld_ret_28 == MarketInfo(Symbol(), MODE_MINLOT)) gs_1416 = "!" + gs_1416 + "   ( at Lot Size Minumum : " + f0_29(ld_ret_28, 2) + " : still trading with Actual Risk )";
               else gs_1416 = "!" + gs_1416 + "   ( still trading with Actual Risk )";
            } else {
               if (ld_84 < ld_92) gs_1416 = "!" + gs_1416 + "   ( free Margin at S/L reached : " + f0_29(2.0 * ld_84 / AccountLeverage(), 2) + " : still trading with Actual Risk )";
               else gs_1416 = " " + gs_1416;
            }
         } else {
            gs_1416 = "!Lots:0.0  Risk set at:" + f0_29(Risk, 2) + "%   ( Channel is OFF )";
            ld_ret_28 = 0;
         }
      }
   } else {
      gs_1416 = "!Lots:0.0  Risk set at:" + f0_29(Risk, 2) + "%   ( no scalp distance yet : Channel is OFF )";
      ld_ret_28 = 0;
   }
   return (ld_ret_28);
}

void f0_33(int ai_0, double ad_4, double ad_12, double ad_20, double ad_28, double ad_36, double ad_44, int ai_52, double a_lots_56) {
   int cmd_76;
   color color_80;
   bool bool_84;
   bool bool_92;
   double price_96;
   double price_104;
   double price_112;
   double ld_120;
   int li_136;
   int li_140;
   int datetime_144;
   double order_open_price_148;
   string var_name_156;
   int ticket_164;
   string var_name_168;
   int error_176;
   int ticket_72 = -1;
   bool li_88 = TRUE;
   double ld_128 = gda_892[0] - gda_892[1];
   if (FIFO && NumOrders_Level > 0 && ai_0 <= gi_1664) return;
   if (gi_1724) {
      if (a_lots_56 != 0.0) {
         if (!IsTesting() && g_count_1720 == 10) {
            if (AutoApply_ECN) {
               if (!Use_Stop_Orders && gd_1584 <= 0.00001 * gd_636) Use_Stop_Orders = 1;
               if ((!Hard_Stop_Trailing) && !FIFO) Hard_Stop_Trailing = 1;
            }
         }
         if (Use_Stop_Orders && ad_28 < gd_1584) {
            ad_28 = gd_1584;
            ad_36 = gd_1584 + 0.00001 * Slippage;
         }
         if (ai_52 < 0) {
            li_136 = 1;
            color_80 = Lime;
            ld_120 = GetTickCount();
            if (Use_Stop_Orders) {
               cmd_76 = 4;
               price_96 = f0_28(Ask + ad_36);
               price_104 = f0_28(Bid + ad_36 - ad_20 * ad_44);
               price_112 = f0_28(gd_1616 + ad_36 + ad_20);
            } else {
               cmd_76 = 0;
               price_96 = f0_28(ad_4 + gd_1592 + ad_28);
               bool_84 = ld_128 > 0.0 && price_96 - 0.00001 * Slippage <= Ask && Ask <= price_96 + 0.00001 * Slippage;
               price_96 = Ask;
               price_104 = f0_28(price_96 - gd_1592 - MathMax(gd_1584 + 0.00001 * Slippage, ad_20 * ad_44));
               price_112 = f0_28(price_96 + MathMax(gd_1584 + 0.00001 * Slippage, gd_948 + ad_20));
            }
         } else {
            if (ai_52 <= 0) return;
            li_136 = -1;
            color_80 = Orange;
            ld_120 = GetTickCount();
            if (Use_Stop_Orders) {
               cmd_76 = 5;
               price_96 = f0_28(Bid - ad_36);
               price_104 = f0_28(Ask - ad_36 + ad_20 * ad_44);
               price_112 = f0_28(gd_1624 - ad_36 - ad_20);
            } else {
               cmd_76 = 1;
               price_96 = f0_28(ad_12 - ad_28);
               bool_84 = ld_128 < 0.0 && price_96 + 0.00001 * Slippage >= Bid && Bid >= price_96 - 0.00001 * Slippage;
               price_96 = Bid;
               price_104 = f0_28(price_96 + gd_1592 + MathMax(gd_1584 + 0.00001 * Slippage, ad_20 * ad_44));
               price_112 = f0_28(price_96 - MathMax(gd_1584 + 0.00001 * Slippage, gd_948 + ad_20));
            }
         }
         li_140 = f0_1(ai_0);
         if (li_140 != -1) {
            datetime_144 = 0;
            order_open_price_148 = 0;
            int li_64 = 1;
            for (li_64 = 1; li_64 <= gi_1716; li_64++) {
               var_name_156 = f0_30() + ai_0 + "," + li_64;
               ticket_164 = GlobalVariableGet(var_name_156);
               if (OrderSelect(ticket_164, SELECT_BY_TICKET) && OrderCloseTime() == 0) {
                  if (datetime_144 < OrderOpenTime()) {
                     datetime_144 = OrderOpenTime();
                     order_open_price_148 = OrderOpenPrice();
                  }
               }
            }
            if (order_open_price_148 != 0.0 && li_136 * (order_open_price_148 - price_96) < 0.00001 * gd_692) return;
            var_name_168 = f0_30() + ai_0 + "," + li_140;
            bool_92 = TRUE;
            if (Use_Stop_Orders) {
               if (Hard_Stop_Trailing) {
                  gi_1744 = TRUE;
                  ticket_72 = OrderSend(Symbol(), cmd_76, a_lots_56, price_96, Slippage, price_104, price_112, OrderCmt, Magic, gi_1680, color_80);
               } else {
                  if (!IsTesting()) {
                     gi_1744 = TRUE;
                     ticket_72 = OrderSend(Symbol(), cmd_76, a_lots_56, price_96, Slippage, price_104 - 0.00001 * (80 * li_136), price_112 + 0.00001 * (80 * li_136), OrderCmt, Magic,
                        gi_1680, color_80);
                  } else {
                     gi_1744 = TRUE;
                     ticket_72 = OrderSend(Symbol(), cmd_76, a_lots_56, price_96, Slippage, 0, 0, OrderCmt, Magic, gi_1680, color_80);
                  }
               }
               error_176 = GetLastError();
            } else {
               if (!(bool_84)) return;
               gi_1744 = TRUE;
               ticket_72 = OrderSend(Symbol(), cmd_76, a_lots_56, price_96, Slippage, 0, 0, OrderCmt, Magic, gi_1680, color_80);
               error_176 = GetLastError();
               if (ticket_72 >= 0) {
                  bool_92 = TRUE;
                  if (Hard_Stop_Trailing) {
                     g_count_1708 = 0;
                     while (true) {
                        bool_92 = OrderModify(ticket_72, 0, price_104, price_112, gi_1680, color_80);
                        if (bool_92) {
                           f0_7(g_count_1708);
                           break;
                        }
                        li_88 = f0_27(0/* NO_ERROR */);
                        if (!(li_88)) break;
                     }
                  } else {
                     if (!IsTesting()) {
                        g_count_1708 = 0;
                        while (true) {
                           bool_92 = OrderModify(ticket_72, 0, price_104 - 0.00001 * (80 * li_136), price_112 + 0.00001 * (80 * li_136), gi_1680, color_80);
                           if (bool_92) {
                              f0_7(g_count_1708);
                              break;
                           }
                           li_88 = f0_27(0/* NO_ERROR */);
                           if (!(li_88)) break;
                        }
                     }
                  }
               }
            }
            if (ticket_72 >= 0) {
               if (g_count_1720 == 10) g_count_1720 = 0;
               g_count_1720++;
               GlobalVariableSet(var_name_168, ticket_72);
               GlobalVariableSet(var_name_168 + "Price", price_96);
               if (Use_Stop_Orders) GlobalVariableSet(var_name_168 + "PriceProcessed", 0);
               else GlobalVariableSet(var_name_168 + "PriceProcessed", 1);
               GlobalVariableSet(var_name_168 + "TP", price_112);
               GlobalVariableSet(var_name_168 + "SL", price_104);
               GlobalVariableSet(var_name_168 + "USO", Use_Stop_Orders);
               GlobalVariableSet(var_name_168 + "HST", Hard_Stop_Trailing);
               f0_43(ld_120);
               f0_17(ld_120);
               Print(g_count_1100 + ":" + ai_0 + "," + li_140 + ": " + f0_31(cmd_76) + "  price:" + f0_23(price_96) + " SL:" + f0_23(price_104) + " TP:" + f0_23(price_112));
               if (!Silent) {
                  if (bool_92) PlaySound("news.wav");
                  else PlaySound("wait.wav");
               }
               f0_19(cmd_76, li_64);
               f0_7(gi_1712);
               gi_1712 = FALSE;
               if (!bool_92) {
                  Print(g_count_1100 + ":" + ai_0 + "," + li_140 + ": WARN Unable to setup s/l or t/p for order #" + ticket_72 + " : " + f0_31(cmd_76) + "  price:" + f0_23(price_96) +
                     " SL:" + f0_23(price_104) + " TP:" + f0_23(price_112));
               }
            } else {
               if (li_88) g_error_1144 = error_176;
               Print(g_count_1100 + ":" + ai_0 + "," + li_140 + ": WARN Unable to create " + f0_31(cmd_76) + "  price:" + f0_23(price_96) + " SL:" + f0_23(price_104) + " TP:" + f0_23(price_112));
            }
            gi_1744 = FALSE;
         }
      }
   }
}

int f0_27(int a_error_0) {
   if (!a_error_0) a_error_0 = GetLastError();
   if (a_error_0 == 0/* NO_ERROR */) {
      if (g_count_1708 != 0) Print(g_count_1100 + ": INFO Trading command is now succeeded after recent complaints are resolved...");
      f0_7(g_count_1708);
      g_count_1708 = 0;
      return (0);
   }
   if (IsTesting()) {
      if (a_error_0 != 4059/* FUNCTION_NOT_ALLOWED_IN_TESTING_MODE */) Print(g_count_1100 + ": ERROR unhandled error (unable to repeat command in testing mode) : " + ErrorDescription(a_error_0));
      f0_7(g_count_1708);
      g_count_1708 = 0;
      return (0);
   }
   if (g_count_1708 == 5) {
      if (!Silent) Print(g_count_1100 + ": Number of subsequently repeated orders reached limit (5)");
      f0_7(g_count_1708);
      g_count_1708 = 0;
      return (0);
   }
   if (a_error_0 == 130/* INVALID_STOPS */ || a_error_0 == 129/* INVALID_PRICE */ || a_error_0 == 138/* REQUOTE */ || a_error_0 == 135/* PRICE_CHANGED */) {
      Sleep(50);
      RefreshRates();
      if (!Silent) Print(g_count_1100 + ": WARN following error blocked our last trading command (REQUOTING + REPEATING) : " + ErrorDescription(a_error_0));
      g_count_1708++;
      return (1);
   }
   if (a_error_0 == 146/* TRADE_CONTEXT_BUSY */ || a_error_0 == 133/* TRADE_DISABLED */ || a_error_0 == 128/* TRADE_TIMEOUT */ || a_error_0 == 139/* ORDER_LOCKED */ ||
      a_error_0 == 136/* OFF_QUOTES */) {
      Sleep(500);
      RefreshRates();
      if (!Silent) Print(g_count_1100 + ": WARN following error blocked our last trading command (WAITING + REQUOTING + REPEATING) : " + ErrorDescription(a_error_0));
      g_count_1708++;
      return (1);
   }
   if (a_error_0 == 4/* SERVER_BUSY */ || a_error_0 == 137/* BROKER_BUSY */ || a_error_0 == 4022/* SYSTEM_BUSY */ || a_error_0 == 6/* NO_CONNECTION */ || a_error_0 == 141/* TOO_MANY_REQUESTS */ ||
      a_error_0 == 8/* TOO_FREQUENT_REQUESTS */) {
      Sleep(1500);
      RefreshRates();
      if (!Silent) Print(g_count_1100 + ": WARN following error blocked our last trading command (WAITING(2) + REQUOTING + REPEATING) : " + ErrorDescription(a_error_0));
      g_count_1708++;
      return (1);
   }
   if (a_error_0 == 147/* TRADE_EXPIRATION_DENIED */) {
      RefreshRates();
      gi_1112 = FALSE;
      gi_1680 = 0;
      if (!Silent) Print(g_count_1100 + ": WARN following error blocked our last trading command (REQUOTING + REPEATING + TURNING OFF EXPIRATION) : " + ErrorDescription(a_error_0));
      g_count_1708++;
      return (1);
   }
   Print(g_count_1100 + ": ERROR unhandled error (unable to repeat command) : " + ErrorDescription(a_error_0));
   f0_7(g_count_1708);
   g_count_1708 = 0;
   return (0);
}

void f0_15(double &ada_0[2], double &ada_4[2], int &aia_8[2], double ad_12) {
   double ld_52;
   for (int li_20 = 1; li_20 > 0; li_20--) {
      ada_0[li_20] = ada_0[li_20 - 1];
      ada_4[li_20] = ada_4[li_20 - 1];
      aia_8[li_20] = aia_8[li_20 - 1];
   }
   ada_0[0] = Bid;
   ada_4[0] = Ask;
   aia_8[0] = GetTickCount();
   gd_912 = 0;
   gi_920 = FALSE;
   double ld_24 = 0;
   int li_32 = 0;
   double ld_36 = 0;
   int li_44 = 0;
   int li_unused_48 = 0;
   for (int li_20 = 1; li_20 < 2; li_20++) {
      if (aia_8[li_20] == 0) break;
      ld_52 = ada_0[0] - ada_0[li_20];
      if (ld_52 < ld_24) {
         ld_24 = ld_52;
         li_32 = aia_8[0] - aia_8[li_20];
      }
      if (ld_52 > ld_36) {
         ld_36 = ld_52;
         li_44 = aia_8[0] - aia_8[li_20];
         if (ld_24 < 0.0 && (-ld_24) - ld_36 > 0.00001 * ad_12) {
         }
      }
      if (ld_24 < 0.0 && ld_36 > 0.0) {
         if ((-ld_24) - ld_36 > 0.00001 * ad_12) {
            gd_912 = ld_36;
            gi_920 = li_44;
            break;
         }
         if (ld_36 + ld_24 >= 0.5) continue;
         gd_912 = ld_24;
         gi_920 = li_32;
      } else {
         if (ld_36 > 5.0 * (0.00001 * ad_12)) {
            gd_912 = ld_36;
            gi_920 = li_44;
         } else {
            if (ld_24 >= 5.0 * (0.00001 * (-ad_12))) continue;
            gd_912 = ld_24;
            gi_920 = li_32;
            break;
         }
      }
   }
   if (gi_920 == FALSE) {
      gd_924 = 0;
      return;
   }
   gd_924 = 1000.0 * gd_912 / gi_920;
}

void f0_43(int ai_0) {
   ArrayCopy(gda_960, gda_960, 0, 1, 99);
   gda_960[99] = GetTickCount() - ai_0;
   if (gi_972 < 100) gi_972++;
}

void f0_17(int ai_0) {
   ArrayCopy(gda_976, gda_976, 0, 1, 99);
   gda_976[99] = GetTickCount() - ai_0;
   if (gi_988 < 100) gi_988++;
}

void f0_22(int ai_0) {
   ArrayCopy(gda_992, gda_992, 0, 1, 99);
   gda_992[99] = GetTickCount() - ai_0;
   if (gi_1004 < 100) gi_1004++;
}

void f0_7(int ai_0) {
   ArrayCopy(gda_1012, gda_1012, 0, 1, 99);
   gda_1012[99] = ai_0;
   if (gi_1008 < 100) gi_1008++;
}

void f0_5() {
   gi_936 = FALSE;
   g_count_1068 = 0;
   ArrayInitialize(gda_1048, 0);
   gi_972 = f0_16(f0_30() + "ExecTimes", gda_960, 100);
   gi_988 = f0_16(f0_30() + "OpenTimes", gda_976, 100);
   gi_1004 = f0_16(f0_30() + "ModifyTimes", gda_992, 100);
   gi_1044 = f0_16(f0_30() + "OpenSlips", gda_1024, 100);
   gi_1008 = f0_16(f0_30() + "Requotes", gda_1012, 100);
   gd_380 = GlobalVariableGet(f0_30() + "Base_Balance");
}

void f0_44() {
   f0_6(f0_30() + "ExecTimes", gda_960, 100, gi_972);
   f0_6(f0_30() + "OpenTimes", gda_976, 100, gi_988);
   f0_6(f0_30() + "ModifyTimes", gda_992, 100, gi_1004);
   f0_6(f0_30() + "OpenSlips", gda_1024, 100, gi_1044);
   f0_6(f0_30() + "Requotes", gda_1012, 100, gi_1008);
   GlobalVariableSet(f0_30() + "Base_Balance", gd_380);
}

void f0_36() {
   GlobalVariableSet(f0_30() + "Reset", 0);
   f0_11(f0_30() + "ExecTimes", 100);
   f0_11(f0_30() + "OpenTimes", 100);
   f0_11(f0_30() + "ModifyTimes", 100);
   f0_11(f0_30() + "OpenSlips", 100);
   f0_11(f0_30() + "Requotes", 100);
   GlobalVariableSet(f0_30() + "Base_Balance", 0);
   gd_1120 = 0;
   gd_1128 = 0;
   g_ticket_1136 = 0;
   g_count_1140 = 0;
}

void f0_6(string a_var_name_0, double& ada_8[], int ai_12, int ai_16) {
   GlobalVariableSet(a_var_name_0, ai_16);
   for (int index_20 = 0; index_20 < ai_12; index_20++) GlobalVariableSet(a_var_name_0 + index_20, ada_8[index_20]);
}

void f0_11(string a_var_name_0, int ai_8) {
   GlobalVariableSet(a_var_name_0, 0);
   for (int count_12 = 0; count_12 < ai_8; count_12++) GlobalVariableSet(a_var_name_0 + count_12, 0);
}

int f0_16(string a_var_name_0, double &ada_8[100], int ai_12) {
   int global_var_16 = GlobalVariableGet(a_var_name_0);
   for (int index_20 = 0; index_20 < ai_12; index_20++) ada_8[index_20] = GlobalVariableGet(a_var_name_0 + index_20);
   return (global_var_16);
}

int f0_42(double& ada_0[], int ai_4) {
   for (int li_ret_8 = ai_4 - 1; li_ret_8 >= 0; li_ret_8--)
      if (ada_0[li_ret_8]) return (li_ret_8);
   return (-1);
}

void f0_32(double &ada_0[5000], int ai_4) {
   double ld_8;
   for (int index_16 = 0; index_16 < ai_4 / 2; index_16++) {
      ld_8 = ada_0[ai_4 - 1 - index_16];
      ada_0[ai_4 - 1 - index_16] = ada_0[index_16];
      ada_0[index_16] = ld_8;
   }
}

string f0_31(int ai_0) {
   switch (ai_0) {
   case 0:
      return ("BUY");
   case 2:
      return ("BUYLIMIT");
   case 4:
      return ("BUYSTOP");
   case 1:
      return ("SELL");
   case 3:
      return ("SELLLIMIT");
   case 5:
      return ("SELLSTOP");
   }
   return ("?");
}

string f0_23(double ad_0) {
   return (DoubleToStr(ad_0, 5));
}

string f0_29(double ad_0, int ai_8) {
   return (DoubleToStr(ad_0, ai_8));
}

double f0_28(double ad_0) {
   return (NormalizeDouble(ad_0, 5));
}

string f0_12(int ai_0) {
   if (ai_0 < 10) return ("00" + ai_0);
   if (ai_0 < 100) return ("0" + ai_0);
   return ("" + ai_0);
}

string f0_4(bool ai_0) {
   if (ai_0) return ("true");
   return ("false");
}

double f0_41(double ad_0, double ad_8) {
   return (MathLog(ad_8) / MathLog(ad_0));
}

void f0_26(string as_0) {
   int li_12;
   int li_8 = -1;
   while (li_8 < StringLen(as_0)) {
      li_12 = li_8 + 1;
      li_8 = StringFind(as_0, 
      "\n", li_12);
      if (li_8 == -1) {
         Print(StringSubstr(as_0, li_12));
         return;
      }
      Print(StringSubstr(as_0, li_12, li_8 - li_12));
   }
}
