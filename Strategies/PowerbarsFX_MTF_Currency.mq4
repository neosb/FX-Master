#property copyright "Copyright � 2012, Andrea Salvatore"
#property link      "http://www.pimpmyea.com"

#property indicator_separate_window
#property indicator_minimum 0.0
#property indicator_maximum 1.0
#property indicator_buffers 1
#property indicator_color1 Black

#import "wininet.dll"
   int InternetOpenA(string a0, int a1, string a2, string a3, int a4);
   int InternetOpenUrlA(int a0, string a1, string a2, int a3, int a4, int a5);
   int InternetReadFile(int a0, string a1, int a2, int& a3[]);
   int InternetCloseHandle(int a0);
#import

bool gi_unused_76 = FALSE;
string gs_dummy_80;
int gi_unused_88 = 0;
int gi_92 = 1;
string gs_dummy_96;
int gi_104 = 0;
int gi_108 = 0;
int g_count_112 = 0;
string gs_116;
int gia_124[1];
string gs_132 = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
int gia_140[64] = {65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47};
int gia_unused_144[1];
bool gi_148 = FALSE;
extern string e_mail = "";
extern string note_0 = "AUD, CAD, CHF, EUR, GBP, JPY, NZD, USD";
extern string currency = "AUD";
extern int timeframe_1 = 15;
extern int timeframe_2 = 30;
extern int timeframe_3 = 60;
extern int timeframe_4 = 240;
extern int timeframe_5 = 1440;
extern string note_1 = "1-RSI; 2-WPR; 3-Stoch; 4-BB%B";
extern int algo = 2;
extern int line_hours = 24;
int g_window_212;
string gs_216;
string gsa_224[8];
string gsa_228[64];
double gda_unused_232[64];
int g_index_236;
int gia_240[5];
int gia_244[5];
double gd_248;
string gs_256;
int g_shift_264;
string g_name_268;
string g_name_276;
string g_name_284;
color g_color_292;
int g_count_296;
datetime g_time_300;

int init() {
   Comment("");
   g_count_296 = 1440 / Period() - 1;
   IndicatorBuffers(1);
   f0_7();
   gia_240[0] = timeframe_1;
   gia_240[1] = timeframe_2;
   gia_240[2] = timeframe_3;
   gia_240[3] = timeframe_4;
   gia_240[4] = timeframe_5;
   for (int index_0 = 0; index_0 < 5; index_0++) {
      if (gia_240[index_0] == 0) gia_240[index_0] = Period();
      if (gia_240[index_0] == 1) gia_244[index_0] = 30;
      if (gia_240[index_0] == 5) gia_244[index_0] = 24;
      if (gia_240[index_0] == 15) gia_244[index_0] = 24;
      if (gia_240[index_0] == 30) gia_244[index_0] = 24;
      if (gia_240[index_0] == 60) gia_244[index_0] = 24;
      if (gia_240[index_0] == 240) gia_244[index_0] = 30;
      if (gia_240[index_0] == 1440) gia_244[index_0] = 20;
      if (gia_240[index_0] == 10080) gia_244[index_0] = 27;
      if (gia_240[index_0] == 43200) gia_244[index_0] = 24;
   }
   gs_256 = currency + " MTF (Algo: " + algo + ")";
   IndicatorShortName(gs_256);
   g_name_276 = "PowerbarsFX_MTF_Currency" + "label_" + currency + algo;
   IndicatorDigits(2);
   Comment("");
   return (0);
}

int deinit() {
   Comment("");
   ObjectDelete(g_name_276);
   for (int index_0 = 0; index_0 < Bars; index_0++) {
      g_name_268 = "PowerbarsFX_MTF_Currency" + currency + algo + Time[index_0];
      ObjectDelete(g_name_268);
      g_name_284 = "PowerbarsFX_MTF_Currency" + currency + "line_hour" + algo + Time[index_0];
      ObjectDelete(g_name_284);
   }
   return (0);
}

int start() {
   string ls_0;
   int str2int_8;
   int li_16;
   int li_20;
   double ld_28;
   /* if (f0_2()) {
      g_count_296++;
      if (g_count_296 == 1440 / Period()) {
         ls_0 = e_mail;
         str2int_8 = StrToInteger(f0_4(ls_0));
         if (str2int_8 == 1) gi_148 = TRUE;
         else gi_148 = FALSE;
         g_count_296 = 0;
      }
   }
   if (gi_148 == FALSE) {
      Comment("\n Authorization Failed.\n Please contact us at\n http://www.pimpmyea.com");
      return (0);
   } */
   gi_148 = TRUE ;
   if (gi_148) {
      g_window_212 = WindowFind(gs_256);
      li_20 = IndicatorCounted();
      if (li_20 < 0) return (-1);
      if (li_20 > 0) li_20--;
      li_16 = Bars - li_20;
      for (int index_12 = 0; index_12 < li_16; index_12++) {
         gd_248 = 0;
         for (int index_24 = 0; index_24 < 5; index_24++) {
            g_shift_264 = iBarShift(Symbol(), gia_240[index_24], Time[index_12]);
            ld_28 = f0_1(currency, gia_244[index_24], gia_240[index_24], g_shift_264);
            gd_248 += 2.0 * (ld_28 - 50.0);
         }
         gd_248 /= 5.0;
         if (gd_248 < 0.0) g_color_292 = f0_0(255, 0, 0, 255, 255, 255, 0, 100, MathAbs(gd_248));
         if (gd_248 > 0.0) g_color_292 = f0_0(0, 255, 0, 255, 255, 255, 0, 100, MathAbs(gd_248));
         if (index_12 == 0) {
            ObjectDelete(g_name_276);
            ObjectCreate(g_name_276, OBJ_TEXT, g_window_212, TimeCurrent(), 0.9);
            ObjectSetText(g_name_276, "                                 " + currency + ": " + DoubleToStr(gd_248, 2), 10, "Segoe UI", g_color_292);
         }
         g_name_268 = "PowerbarsFX_MTF_Currency" + currency + algo + Time[index_12];
         ObjectDelete(g_name_268);
         ObjectCreate(g_name_268, OBJ_RECTANGLE, g_window_212, Time[index_12] - Period(), 1, Time[index_12], 0);
         ObjectSet(g_name_268, OBJPROP_BACK, TRUE);
         ObjectSet(g_name_268, OBJPROP_COLOR, g_color_292);
         if (TimeHour(Time[index_12]) % line_hours == 0 && TimeMinute(Time[index_12]) == 0) {
            g_name_284 = "PowerbarsFX_MTF_Currency" + currency + "line_hour" + algo + Time[index_12];
            ObjectDelete(g_name_284);
            ObjectCreate(g_name_284, OBJ_VLINE, g_window_212, Time[index_12] - Period(), 0);
            ObjectSet(g_name_284, OBJPROP_COLOR, Black);
         }
         ObjectsRedraw();
      }
      return (0);
   }
   return (0);
}

double f0_8(string a_symbol_0, int a_timeframe_8, int a_period_12, double ad_16, int ai_24) {
   double ld_28 = (iClose(a_symbol_0, a_timeframe_8, ai_24) - iBands(a_symbol_0, a_timeframe_8, a_period_12, ad_16, 0, PRICE_CLOSE, MODE_LOWER, ai_24)) / (iBands(a_symbol_0,
      a_timeframe_8, a_period_12, ad_16, 0, PRICE_CLOSE, MODE_UPPER, ai_24) - iBands(a_symbol_0, a_timeframe_8, a_period_12, ad_16, 0, PRICE_CLOSE, MODE_LOWER, ai_24));
   return (100.0 * ld_28);
}

double f0_1(string as_0, int a_period_8, int a_timeframe_12, int ai_16) {
   double ld_20;
   int li_28;
   for (int index_32 = 0; index_32 < g_index_236; index_32++) {
      if (StringSubstr(gsa_228[index_32], 0, 3) == as_0) {
         if (algo == 1) ld_20 += iRSI(gsa_228[index_32], a_timeframe_12, a_period_8, PRICE_CLOSE, ai_16);
         if (algo == 2) ld_20 += iWPR(gsa_228[index_32], a_timeframe_12, a_period_8, ai_16) + 100.0;
         if (algo == 3) ld_20 += iStochastic(gsa_228[index_32], a_timeframe_12, a_period_8, 3, 3, MODE_SMA, 0, MODE_MAIN, ai_16);
         if (algo == 4) ld_20 += f0_8(gsa_228[index_32], a_timeframe_12, a_period_8, 2, ai_16);
         li_28++;
      }
      if (StringSubstr(gsa_228[index_32], 3, 3) == as_0) {
         if (algo == 1) ld_20 += 100 - iRSI(gsa_228[index_32], a_timeframe_12, a_period_8, PRICE_CLOSE, ai_16);
         if (algo == 2) ld_20 += 100 - (iWPR(gsa_228[index_32], a_timeframe_12, a_period_8, ai_16) + 100.0);
         if (algo == 3) ld_20 += 100 - iStochastic(gsa_228[index_32], a_timeframe_12, a_period_8, 3, 3, MODE_SMA, 0, MODE_MAIN, ai_16);
         if (algo == 4) ld_20 += 100 - f0_8(gsa_228[index_32], a_timeframe_12, a_period_8, 2, ai_16);
         li_28++;
      }
   }
   return (ld_20 / li_28);
}

int f0_2() {
   if (g_time_300 == Time[0]) return (0);
   g_time_300 = Time[0];
   return (1);
}

int f0_6(int ai_0, int ai_4, int ai_8) {
   int li_ret_12 = MathMin(255, MathAbs(ai_0)) + 256.0 * MathMin(255, MathAbs(ai_4)) + 65536.0 * MathMin(255, MathAbs(ai_8));
   return (li_ret_12);
}

int f0_0(int ai_0, int ai_4, int ai_8, int ai_12, int ai_16, int ai_20, double ad_24, double ad_32, double ad_40) {
   double ld_48 = ad_32 - ad_24;
   ad_40 = ad_32 - ad_40;
   double ld_56 = (ai_0 - ai_12) / (ld_48 - 1.0);
   double ld_64 = (ai_4 - ai_16) / (ld_48 - 1.0);
   double ld_72 = (ai_8 - ai_20) / (ld_48 - 1.0);
   return (f0_6(ai_0 - ld_56 * ad_40, ai_4 - ld_64 * ad_40, ai_8 - ld_72 * ad_40));
}

void f0_7() {
   string symbol_0;
   gs_216 = StringSubstr(Symbol(), 6, 0);
   gsa_224[0] = "AUD";
   gsa_224[1] = "CAD";
   gsa_224[2] = "CHF";
   gsa_224[3] = "EUR";
   gsa_224[4] = "GBP";
   gsa_224[5] = "JPY";
   gsa_224[6] = "NZD";
   gsa_224[7] = "USD";
   g_index_236 = 0;
   for (int index_8 = 0; index_8 < 8; index_8++) {
      for (int index_12 = 0; index_12 < 8; index_12++) {
         if (index_8 != index_12) {
            symbol_0 = gsa_224[index_8] + gsa_224[index_12] + gs_216;
            if (MarketInfo(symbol_0, MODE_TRADEALLOWED) == 1.0) {
               gsa_228[g_index_236] = symbol_0;
               g_index_236++;
            }
         }
      }
   }
}

string f0_9(string as_0) {
   string ls_12;
   string ls_20;
   for (int li_8 = StringFind(as_0, " "); li_8 != -1; li_8 = StringFind(as_0, " ")) {
      ls_12 = StringTrimLeft(StringTrimRight(StringSubstr(as_0, 0, StringFind(as_0, " ", 0))));
      ls_20 = StringTrimLeft(StringTrimRight(StringSubstr(as_0, StringFind(as_0, " ", 0))));
      as_0 = ls_12 + "%20" + ls_20;
   }
   return (as_0);
}

string f0_3(string as_0) {
   g_count_112 = 0;
   for (gi_104 = FALSE; g_count_112 < 3 && gi_104 == FALSE; g_count_112++) {
      if (gi_108 != 0) gi_104 = InternetOpenUrlA(gi_108, as_0, 0, 0, -2079850240, 0);
      if (gi_104 == FALSE) {
         InternetCloseHandle(gi_108);
         gi_108 = InternetOpenA("mymt4InetSession", gi_92, 0, 0, 0);
      }
   }
   gs_116 = "";
   gia_124[0] = 1;
   while (gia_124[0] > 0) {
      InternetReadFile(gi_104, gs_132, 200, gia_124);
      if (gia_124[0] > 0) gs_116 = gs_116 + StringSubstr(gs_132, 0, gia_124[0]);
   }
   InternetCloseHandle(gi_104);
   return (gs_116);
}

string f0_4(string as_0) {
   string ls_8;
   string ls_unused_16;
   f0_5(as_0, ls_8);
   return (f0_3(f0_9("http://www.pimpmyea.com/auth/PowerbarsFX/" + ls_8 + ".html")));
}

void f0_5(string as_0, string &as_8) {
   int li_28;
   int li_32;
   int li_36;
   int li_40;
   int li_44;
   int li_48;
   int li_52;
   int li_16 = 0;
   int li_20 = 0;
   int str_len_24 = StringLen(as_0);
   while (li_16 < str_len_24) {
      li_36 = StringGetChar(as_0, li_16);
      li_16++;
      if (li_16 >= str_len_24) {
         li_32 = 0;
         li_28 = 0;
         li_20 = 2;
      } else {
         li_32 = StringGetChar(as_0, li_16);
         li_16++;
         if (li_16 >= str_len_24) {
            li_28 = 0;
            li_20 = 1;
         } else {
            li_28 = StringGetChar(as_0, li_16);
            li_16++;
         }
      }
      li_40 = li_36 >> 2;
      li_44 = (li_36 & 3 * 16) | li_32 >> 4;
      li_48 = (li_32 & 15 * 4) | li_28 >> 6;
      li_52 = li_28 & 63;
      as_8 = as_8 + CharToStr(gia_140[li_40]);
      as_8 = as_8 + CharToStr(gia_140[li_44]);
      switch (li_20) {
      case 0:
         as_8 = as_8 + CharToStr(gia_140[li_48]);
         as_8 = as_8 + CharToStr(gia_140[li_52]);
         break;
      case 1:
         as_8 = as_8 + CharToStr(gia_140[li_48]);
         as_8 = as_8 + "=";
         break;
      case 2:
         as_8 = as_8 + "==";
      }
   }
}
