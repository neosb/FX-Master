#property copyright "Copyright © 2012 - tradergo.de"
#property link      "http://www.tradergo.de"

#include <WinUser32.mqh>
//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0);
#import

int g_period_236 = 12;
int g_period_240 = 26;
int g_period_244 = 9;
int g_period_276 = 74;
int g_period_280 = 5;
int g_period_284 = 3;
int g_slowing_288 = 3;
int g_period_292 = 36;
int g_period_296 = 89;
int g_period_300 = 4;

extern string D5___________________________ = "OTHER SETTINGS";
extern int MaxSlippage = 20;
extern string CustomComment = "3WAY2WIN";
extern int MagicNumber = 4711;
extern string D2___________________________ = "___________________________________";
extern string D6___________________________ = "STOP LOSS & TAKE PROFIT";
extern string SL1_IMPORTANT_READ = "False = s/l and t/p are visible";
extern string SL2_IMPORTANT_READ = "and handled in MT4";
extern string SL3_IMPORTANT_READ = "True = s/l and t/p are NOT visible";
extern string SL4_IMPORTANT_READ = "and handled in EA";
extern string SL5_IMPORTANT_READ = "True = in Case of Crash, = NO stop loss";
extern string SL6_IMPORTANT_READ = "this is very dangerous !";
extern string SL7_IMPORTANT_READ = "Use only at your own risk.";
extern bool DoSLandTPinEA = FALSE;
extern string W1___________________________ = "___________________________________";
extern string W2___________________________ = "Best Results with DEFAULT Value !";
extern int factorsl = 10;
extern int factortp = 10;
extern string D3___________________________ = "___________________________________";
extern string D7___________________________ = "MONEY MANAGEMENT";
extern bool UseMoneyManagement = FALSE;
extern double Lots = 0.1;
extern int LotsDecimals = 2;
extern double RiskInPercent = 2.0;
extern double MaximumLots = 0.5;

int gi_1044 = 5;
double gd_1048 = 0.0;
double gd_1056 = 0.0;
double gd_1064 = 25.0;
double gd_1072 = 0.0;
string g_dbl2str_1080 = "";
int g_pos_1088 = 0;

string gs_hinter1_1136 = "Hinter1";
int g_fontsize_1176 = 9;

int deinit() {
 ObjectsDeleteAll();
}

int init() {
   double ld_16;
   ObjectDelete("Hinter");
   ObjectDelete("top");
   ObjectDelete("name");
   ObjectDelete("Spread");
   ObjectDelete("Stellen");
   ObjectDelete("Running");
   ObjectDelete("zeit");
   ObjectDelete("serverzeit");
   ObjectDelete("Hebel");
   ObjectDelete("Available");
   ObjectDelete("shadow");
   ObjectDelete("Server");
   ObjectDelete("NeuralOn");
   ObjectDelete("NeuralOn2");
   ObjectDelete("NeuralOn3");
   ObjectDelete("Copy");
   ObjectDelete("ordershowsl");
   ObjectDelete("ordershows");
   ObjectDelete("timeer");
   ObjectDelete("timeor");
   
   ObjectCreate(gs_hinter1_1136, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSetText(gs_hinter1_1136, "g", 151, "Webdings");
   ObjectSet(gs_hinter1_1136, OBJPROP_CORNER, 1);
   ObjectSet(gs_hinter1_1136, OBJPROP_BACK, TRUE);
   ObjectSet(gs_hinter1_1136, OBJPROP_XDISTANCE, 5);
   ObjectSet(gs_hinter1_1136, OBJPROP_YDISTANCE, 16);
   ObjectSet(gs_hinter1_1136, OBJPROP_COLOR, MidnightBlue);
   f0_5("--------------------------------------------------------");
   f0_5("Starting the EA");
   if (Digits < 4) ld_16 = 2;
   else ld_16 = 4;
   gd_1048 = MathPow(10, ld_16);
   gd_1056 = 1 / gd_1048;
   gd_1072 = MarketInfo(Symbol(), MODE_STOPLEVEL) / MathPow(10, Digits);
   g_dbl2str_1080 = DoubleToStr(gi_1044, 2);
   f0_5("Broker Stop Difference: ", DoubleToStr(gd_1072 * gd_1048, 2), ", EA Stop Difference: ", g_dbl2str_1080);
   if (DoubleToStr(gd_1072 * gd_1048, 2) != g_dbl2str_1080) f0_5("WARNING! EA Stop Difference is different from real Broker Stop Difference, the backtest results in MT4 could be different from results of TraderGo.de!");
   string dbl2str_24 = DoubleToStr((Ask - Bid) * gd_1048, 2);
   string dbl2str_32 = DoubleToStr(gd_1064, 2);
   f0_5("Broker spread: ", dbl2str_24, ", TraderGo.de test spread: ", dbl2str_32);
   if (dbl2str_32 != dbl2str_24) f0_5("WARNING! Real Broker spread is different from spread used in TraderGo.de, the backtest results in MT4 could be different from results of TraderGo.de!");
   f0_5("--------------------------------------------------------");
   
   return (0);
}

int start() {
   
   
   if (Bars < 30) {
      Print("NOT ENOUGH DATA: Less Bars than 30");
      return (0);
   }
   
   double ld_20 = NormalizeDouble(Bid, 5);
   double ask_28 = MarketInfo("EURUSD", MODE_ASK);
   double point_36 = MarketInfo("EURUSD", MODE_POINT);
   int digits_44 = MarketInfo("EURUSD", MODE_DIGITS);
   int spread_48 = MarketInfo("EURUSD", MODE_SPREAD);
   int li_52 = NormalizeDouble(AccountFreeMargin(), 2);
   string name_56 = "3WAY2WIN";
   ObjectCreate(name_56, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_56, OBJPROP_CORNER, 1);
   ObjectSet(name_56, OBJPROP_BACK, FALSE);
   ObjectSet(name_56, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_56, OBJPROP_YDISTANCE, 20);
   ObjectSet(name_56, 32, 1);
   ObjectSetText(name_56, "3WAY2WIN", 24, "Arial Black", Crimson);
   string name_64 = "shadow";
   ObjectCreate(name_64, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_64, OBJPROP_CORNER, 1);
   ObjectSet(name_64, OBJPROP_BACK, FALSE);
   ObjectSet(name_64, OBJPROP_XDISTANCE, 7);
   ObjectSet(name_64, OBJPROP_YDISTANCE, 21);
   ObjectSet(name_64, 32, 1);
   ObjectSetText(name_64, "3WAY2WIN", 24, "Arial Black", White);
   string name_72 = "Copy";
   ObjectCreate(name_72, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_72, OBJPROP_CORNER, 1);
   ObjectSet(name_72, OBJPROP_BACK, FALSE);
   ObjectSet(name_72, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_72, OBJPROP_YDISTANCE, 90);
   ObjectSetText(name_72, "Copyright 2012 - www.tradergo.de", g_fontsize_1176, "Microsoft Sans Serif", White);
   string name_80 = "Spread";
   ObjectCreate(name_80, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_80, OBJPROP_CORNER, 1);
   ObjectSet(name_80, OBJPROP_BACK, FALSE);
   ObjectSet(name_80, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_80, OBJPROP_YDISTANCE, 210);
   ObjectSetText(name_80, "Spread: " + spread_48, 24, "Arial Black", White);
   string name_88 = "Stellen";
   ObjectCreate(name_88, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_88, OBJPROP_CORNER, 1);
   ObjectSet(name_88, OBJPROP_BACK, FALSE);
   ObjectSet(name_88, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_88, OBJPROP_YDISTANCE, 70);
   ObjectSetText(name_88, "Broker Digits: " + digits_44, g_fontsize_1176, "Microsoft Sans Serif", White);
   string name_96 = "Running";
   ObjectCreate(name_96, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_96, OBJPROP_CORNER, 1);
   ObjectSet(name_96, OBJPROP_BACK, FALSE);
   ObjectSet(name_96, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_96, OBJPROP_YDISTANCE, 170);
   ObjectSetText(name_96, "Order:  " + OrderTicket() + "     @ " + OrderOpenPrice(), g_fontsize_1176, "Microsoft Sans Serif", White);
   string name_104 = "Kontoname";
   ObjectCreate(name_104, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_104, OBJPROP_CORNER, 1);
   ObjectSet(name_104, OBJPROP_BACK, FALSE);
   ObjectSet(name_104, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_104, OBJPROP_YDISTANCE, 130);
   ObjectSetText(name_104, "Account: " + AccountNumber(), g_fontsize_1176, "Microsoft Sans Serif", White);
   string name_112 = "Available";
   ObjectDelete(name_112);
   ObjectCreate(name_112, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_112, OBJPROP_CORNER, 1);
   ObjectSet(name_112, OBJPROP_BACK, FALSE);
   ObjectSet(name_112, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_112, OBJPROP_YDISTANCE, 150);
   ObjectSetText(name_112, "Available: " + li_52, g_fontsize_1176, "Microsoft Sans Serif", White);
   string name_120 = "Hebel";
   ObjectCreate(name_120, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_120, OBJPROP_CORNER, 1);
   ObjectSet(name_120, OBJPROP_BACK, FALSE);
   ObjectSet(name_120, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_120, OBJPROP_YDISTANCE, 190);
   ObjectSetText(name_120, "Leverage: " + AccountLeverage(), g_fontsize_1176, "Microsoft Sans Serif", White);
   string name_128 = "Server";
   ObjectCreate(name_128, OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet(name_128, OBJPROP_CORNER, 1);
   ObjectSet(name_128, OBJPROP_BACK, FALSE);
   ObjectSet(name_128, OBJPROP_XDISTANCE, 8);
   ObjectSet(name_128, OBJPROP_YDISTANCE, 110);
   ObjectSetText(name_128, "Server: " + AccountServer(), g_fontsize_1176, "Microsoft Sans Serif", White);
  
   f0_6();
   bool bool_288 = (iStochastic(NULL, 0, g_period_280, g_period_284, g_slowing_288, MODE_SMA, 0, MODE_SIGNAL, 2) < iADX(NULL, 0, g_period_276, PRICE_CLOSE, MODE_MINUSDI,
      2) && iStochastic(NULL, 0, g_period_280, g_period_284, g_slowing_288, MODE_SMA, 0, MODE_SIGNAL, 1) > iADX(NULL, 0, g_period_276, PRICE_CLOSE, MODE_MINUSDI, 1)) || (iMA(NULL,
      0, g_period_300, 0, MODE_SMA, PRICE_CLOSE, 2) > iMA(NULL, 0, g_period_296, 0, MODE_SMA, PRICE_CLOSE, 2) && iMA(NULL, 0, g_period_300, 0, MODE_SMA, PRICE_CLOSE, 1) < iMA(NULL,
      0, g_period_296, 0, MODE_SMA, PRICE_CLOSE, 1)) || (iADX(NULL, 0, g_period_292, PRICE_CLOSE, MODE_MAIN, 2) > iMACD(NULL, 0, g_period_236, g_period_240, g_period_244,
      PRICE_CLOSE, MODE_SIGNAL, 2) && iADX(NULL, 0, g_period_292, PRICE_CLOSE, MODE_MAIN, 1) < iMACD(NULL, 0, g_period_236, g_period_240, g_period_244, PRICE_CLOSE, MODE_SIGNAL,
      1));
   if (f0_3() == 0 && bool_288 == TRUE) {
      f0_1();
      return (0);
   }
   bool bool_292 = (iStochastic(NULL, 0, g_period_280, g_period_284, g_slowing_288, MODE_SMA, 0, MODE_SIGNAL, 2) > iADX(NULL, 0, g_period_276, PRICE_CLOSE, MODE_MINUSDI,
      2) && iStochastic(NULL, 0, g_period_280, g_period_284, g_slowing_288, MODE_SMA, 0, MODE_SIGNAL, 1) < iADX(NULL, 0, g_period_276, PRICE_CLOSE, MODE_MINUSDI, 1)) || (iMA(NULL,
      0, g_period_300, 0, MODE_SMA, PRICE_CLOSE, 2) < iMA(NULL, 0, g_period_296, 0, MODE_SMA, PRICE_CLOSE, 2) && iMA(NULL, 0, g_period_300, 0, MODE_SMA, PRICE_CLOSE, 1) > iMA(NULL,
      0, g_period_296, 0, MODE_SMA, PRICE_CLOSE, 1)) || (iADX(NULL, 0, g_period_292, PRICE_CLOSE, MODE_MAIN, 2) < iMACD(NULL, 0, g_period_236, g_period_240, g_period_244,
      PRICE_CLOSE, MODE_SIGNAL, 2) && iADX(NULL, 0, g_period_292, PRICE_CLOSE, MODE_MAIN, 1) > iMACD(NULL, 0, g_period_236, g_period_240, g_period_244, PRICE_CLOSE, MODE_SIGNAL,
      1));
   if (f0_3() == 0 && bool_292 == TRUE) {
      f0_4();
      return (0);
   }
   return (0);
}

void f0_1() {
   double price_0;
   int cmd_8;
   double ld_12;
   double price_20;
   double ld_28;
   double price_36;
   string comment_44;
   double lots_52;
   int error_60;
   int ticket_64;
   if (f0_0() == FALSE) {
      RefreshRates();
      price_0 = NormalizeDouble(Ask, Digits);
      cmd_8 = 0;
      ld_12 = NormalizeDouble(123.0 * gd_1056, Digits);
      price_20 = price_0 - ld_12;
      ld_28 = NormalizeDouble(56.0 * gd_1056, Digits);
      price_36 = price_0 + ld_28;
      comment_44 = CustomComment;
      if (DoSLandTPinEA) comment_44 = "_SL:" + DoubleToStr(price_20, Digits) + "_PT:" + DoubleToStr(price_36, Digits) + "_ND";
      lots_52 = f0_2(ld_12 * gd_1048);
      if (lots_52 > MaximumLots) lots_52 = MaximumLots;
      ticket_64 = OrderSend(Symbol(), cmd_8, lots_52, price_0, MaxSlippage, 0, 0, comment_44, MagicNumber, 0, Green);
      if (ticket_64 < 0) {
         error_60 = GetLastError();
         f0_5("Error opening order: ", error_60, " : ", ErrorDescription(error_60));
      } else {
         OrderSelect(ticket_64, SELECT_BY_TICKET, MODE_TRADES);
         f0_5("Order opened: ", OrderTicket(), " at price:", OrderOpenPrice());
         if (!DoSLandTPinEA) {
            if (OrderModify(ticket_64, OrderOpenPrice(), price_20, price_36, 0, Black)) f0_5("Order modified, StopLoss: ", OrderStopLoss(), ", Profit Target: ", OrderTakeProfit());
            else f0_5("Error modifying order: ", error_60, " : ", ErrorDescription(error_60));
         }
      }
   }
}

void f0_4() {
   double price_0;
   int cmd_8;
   double ld_12;
   double price_20;
   double ld_28;
   double price_36;
   string comment_44;
   double lots_52;
   int error_60;
   int ticket_64;
   if (f0_0() == FALSE) {
      RefreshRates();
      price_0 = NormalizeDouble(Bid, Digits);
      cmd_8 = 1;
      ld_12 = NormalizeDouble(123.0 * gd_1056, Digits);
      price_20 = price_0 + ld_12;
      ld_28 = NormalizeDouble(56.0 * gd_1056, Digits);
      price_36 = price_0 - ld_28;
      comment_44 = CustomComment;
      if (DoSLandTPinEA) comment_44 = "_SL:" + DoubleToStr(price_20, Digits) + "_PT:" + DoubleToStr(price_36, Digits) + "_ND" + CustomComment;
      lots_52 = f0_2(ld_12 * gd_1048);
      if (lots_52 > MaximumLots) lots_52 = MaximumLots;
      ticket_64 = OrderSend(Symbol(), cmd_8, lots_52, price_0, MaxSlippage, 0, 0, comment_44, MagicNumber, 0, Green);
      if (ticket_64 < 0) {
         error_60 = GetLastError();
         f0_5("Error opening order: ", error_60, " : ", ErrorDescription(error_60));
      } else {
         OrderSelect(ticket_64, SELECT_BY_TICKET, MODE_TRADES);
         f0_5("Order opened: ", OrderTicket(), " at price:", OrderOpenPrice());
         if (!DoSLandTPinEA) {
            if (OrderModify(ticket_64, OrderOpenPrice(), price_20, price_36, 0, Black)) f0_5("Order modified, StopLoss: ", OrderStopLoss(), ", Profit Target: ", OrderTakeProfit());
            else f0_5("Error modifying order: ", error_60, " : ", ErrorDescription(error_60));
         }
      }
   }
}

int f0_3() {
   for (int pos_0 = 0; pos_0 < OrdersTotal(); pos_0++) {
      if (OrderSelect(pos_0, SELECT_BY_POS) == TRUE && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY) return (1);
         if (OrderType() == OP_SELL) return (-1);
      }
   }
   return (0);
}

void f0_5(string as_0, string as_8 = "", string as_16 = "", string as_24 = "", string as_32 = "", string as_40 = "", string as_48 = "", string as_56 = "", string as_64 = "", string as_72 = "", string as_80 = "", string as_88 = "") {
   Print(TimeToStr(TimeCurrent()), " ", as_0, as_8, as_16, as_24, as_32, as_40, as_48, as_56, as_64, as_72, as_80, as_88);
}

int f0_0() {
   string time2str_16;
   string time2str_0 = TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES);
   int li_8 = g_pos_1088 - 10;
   if (li_8 < 0) li_8 = 0;
   for (int pos_12 = li_8; pos_12 < OrdersHistoryTotal(); pos_12++) {
      if (OrderSelect(pos_12, SELECT_BY_POS, MODE_HISTORY) == TRUE && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
         time2str_16 = TimeToStr(OrderCloseTime(), TIME_DATE|TIME_MINUTES);
         g_pos_1088 = pos_12;
         if (time2str_16 == time2str_0) return (1);
      }
   }
   return (0);
}

void f0_6() {
   int cmd_0;
   int li_4;
   int li_8;
   int li_12;
   string ls_16;
   string ls_24;
   string ls_32;
   double str2dbl_40;
   double str2dbl_48;
   if (DoSLandTPinEA) {
      for (int pos_56 = 0; pos_56 < OrdersTotal(); pos_56++) {
         if (OrderSelect(pos_56, SELECT_BY_POS) == TRUE && OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
            cmd_0 = OrderType();
            if (cmd_0 != OP_BUY && cmd_0 != OP_SELL) continue;
            ls_16 = OrderComment();
            li_4 = StringFind(ls_16, "_SL:");
            li_8 = StringFind(ls_16, "_PT:");
            li_12 = StringFind(ls_16, "_ND");
            if (li_4 == -1 || li_8 == -1 || li_12 == -1) continue;
            ls_24 = StringSubstr(ls_16, li_4 + 4, li_8 - li_4 - 4);
            ls_32 = StringSubstr(ls_16, li_8 + 4, li_12 - li_8 - 4);
            str2dbl_40 = StrToDouble(ls_24);
            str2dbl_48 = StrToDouble(ls_32);
            if (OrderType() == OP_BUY) {
               if (str2dbl_48 > 0.0)
                  if (Bid >= str2dbl_48) OrderClose(OrderTicket(), OrderLots(), Bid, 3);
               if (str2dbl_40 <= 0.0) continue;
               if (Bid > str2dbl_40) continue;
               OrderClose(OrderTicket(), OrderLots(), Bid, 3);
               continue;
            }
            if (OrderType() == OP_SELL) {
               if (str2dbl_48 > 0.0)
                  if (Ask <= str2dbl_48) OrderClose(OrderTicket(), OrderLots(), Ask, 3);
               if (str2dbl_40 > 0.0)
                  if (Ask >= str2dbl_40) OrderClose(OrderTicket(), OrderLots(), Ask, 3);
            }
         }
      }
   }
}

double f0_2(double ad_0) {
   double ld_ret_24;
   if (ad_0 <= 0.0) return (Lots);
   if (UseMoneyManagement == FALSE) {
      if (Lots <= MaximumLots) return (Lots);
      return (MaximumLots);
   }
   if (RiskInPercent < 0.0) {
      f0_5("Incorrect RiskInPercent size, it must be > 0");
      return (0);
   }
   double ld_8 = AccountBalance() * (RiskInPercent / 100.0);
   if (ad_0 <= 0.0) {
      f0_5("Incorrect StopLossPips size, it must be above 0");
      return (0);
   }
   double ld_16 = NormalizeDouble(ld_8 / (10.0 * ad_0), LotsDecimals);
   double lotstep_32 = MarketInfo(Symbol(), MODE_LOTSTEP);
   if (MathMod(100.0 * ld_ret_24, 100.0 * lotstep_32) > 0.0) ld_ret_24 = ld_16 - MathMod(ld_16, lotstep_32);
   else ld_ret_24 = ld_16;
   ld_ret_24 = NormalizeDouble(ld_ret_24, LotsDecimals);
   if (MarketInfo(Symbol(), MODE_LOTSIZE) == 10000.0) ld_ret_24 = 10.0 * ld_ret_24;
   ld_ret_24 = NormalizeDouble(ld_ret_24, LotsDecimals);
   double ld_40 = MarketInfo(Symbol(), MODE_MINLOT);
   double ld_48 = MarketInfo(Symbol(), MODE_MAXLOT);
   if (ld_ret_24 < ld_40) ld_ret_24 = ld_40;
   if (ld_ret_24 > ld_48) ld_ret_24 = ld_48;
   if (ld_ret_24 > MaximumLots) ld_ret_24 = MaximumLots;
   return (ld_ret_24);
}