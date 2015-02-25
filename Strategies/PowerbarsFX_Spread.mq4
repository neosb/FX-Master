#property copyright "Copyright © 2012, Andrea Salvatore"
#property link      "http://www.pimpmyea.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 White

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
extern int timeframe_1 = 15;
extern int timeframe_2 = 30;
extern int timeframe_3 = 60;
extern int timeframe_4 = 240;
extern int timeframe_5 = 1440;
extern string note_1 = "1-RSI; 2-WPR; 3-Stoch; 4-BB%B";
extern int algo = 2;
extern bool auto_timeframes = FALSE;
extern string threshold_alert = "";
extern bool iCustom_flag = FALSE;
int g_window_216;
string gs_220;
string gs_228;
string gs_236;
string gs_244;
string gsa_252[8];
string gsa_256[64];
double gda_unused_260[64];
double g_ibuf_264[];
int g_index_268;
int gia_272[5];
int gia_276[5];
string gs_280;
string g_name_288;
int g_shift_296;
string g_name_300;
color g_color_308;
int g_count_312;
double g_price_316;
double g_price_324;
bool gi_332 = TRUE;
string g_name_336;
string g_name_344;
string g_name_352;
string g_name_360;
bool gi_368 = FALSE;
bool gi_372 = FALSE;
bool gi_376 = FALSE;
bool gi_380 = FALSE;
double gd_384;
datetime g_time_392;

int init() {
   Comment("");
   g_count_312 = 1440 / Period() - 1;
   IndicatorBuffers(1);
   SetIndexStyle(0, DRAW_NONE);
   SetIndexBuffer(0, g_ibuf_264);
   gs_220 = StringSubstr(Symbol(), 0, 3);
   gs_228 = StringSubstr(Symbol(), 3, 3);
   gs_236 = gs_220 + gs_228;
   f0_9();
   int lia_0[] = {1, 5, 15, 30, 60, 240, 1440, 10080, 43200, 43200, 43200, 43200, 43200};
   if (auto_timeframes) {
      gia_272[0] = Period();
      for (int index_4 = 0; lia_0[index_4] < gia_272[0]; index_4++) {
      }
      index_4++;
      gia_272[1] = lia_0[index_4];
      index_4++;
      gia_272[2] = lia_0[index_4];
      index_4++;
      gia_272[3] = lia_0[index_4];
      index_4++;
      gia_272[4] = lia_0[index_4];
   } else {
      gia_272[0] = timeframe_1;
      gia_272[1] = timeframe_2;
      gia_272[2] = timeframe_3;
      gia_272[3] = timeframe_4;
      gia_272[4] = timeframe_5;
   }
   Print("timeframe[0] = ", gia_272[0]);
   Print("timeframe[1] = ", gia_272[1]);
   Print("timeframe[2] = ", gia_272[2]);
   Print("timeframe[3] = ", gia_272[3]);
   Print("timeframe[4] = ", gia_272[4]);
   for (index_4 = 0; index_4 < 5; index_4++) {
      if (gia_272[index_4] == 0) gia_272[index_4] = Period();
      if (gia_272[index_4] == 1) gia_276[index_4] = 30;
      if (gia_272[index_4] == 5) gia_276[index_4] = 24;
      if (gia_272[index_4] == 15) gia_276[index_4] = 24;
      if (gia_272[index_4] == 30) gia_276[index_4] = 24;
      if (gia_272[index_4] == 60) gia_276[index_4] = 24;
      if (gia_272[index_4] == 240) gia_276[index_4] = 30;
      if (gia_272[index_4] == 1440) gia_276[index_4] = 20;
      if (gia_272[index_4] == 10080) gia_276[index_4] = 27;
      if (gia_272[index_4] == 43200) gia_276[index_4] = 24;
   }
   gs_280 = gs_220 + gs_228 + " MTF Spread (Algo: " + algo + ")";
   IndicatorShortName(gs_280);
   IndicatorDigits(2);
   g_name_288 = "PowerbarsFX_Spread" + "label_" + gs_220 + gs_228 + algo;
   g_name_336 = "PowerbarsFX_Spread" + "THR1up_" + gs_220 + gs_228 + algo;
   g_name_344 = "PowerbarsFX_Spread" + "THR1dn_" + gs_220 + gs_228 + algo;
   g_name_352 = "PowerbarsFX_Spread" + "THR2up_" + gs_220 + gs_228 + algo;
   g_name_360 = "PowerbarsFX_Spread" + "THR2dn_" + gs_220 + gs_228 + algo;
   f0_5(threshold_alert);
   if (g_price_316 < 1000.0 && g_price_324 < 1000.0) {
      gi_332 = FALSE;
      gi_368 = TRUE;
   }
   Comment("");
   return (0);
}

int deinit() {
   Comment("");
   ObjectDelete(g_name_288);
   ObjectDelete(g_name_336);
   ObjectDelete(g_name_344);
   ObjectDelete(g_name_352);
   ObjectDelete(g_name_360);
   for (int index_0 = 0; index_0 < Bars; index_0++) {
      g_name_300 = "PowerbarsFX_Spread" + gs_220 + gs_228 + algo + Time[index_0];
      ObjectDelete(g_name_300);
   }
   return (0);
}

int start() {
   string ls_0;
   int str2int_8;
   int li_16;
   int li_20;
   double ld_28;
   double ld_36;
   double ld_44;
   /* if (f0_3()) {
      gi_380 = TRUE;
      g_count_312++;
      if (g_count_312 == 1440 / Period()) {
         ls_0 = e_mail;
         str2int_8 = StrToInteger(f0_6(ls_0));
         if (str2int_8 == 1) gi_148 = TRUE;
         else gi_148 = FALSE;
         g_count_312 = 0;
      }
   }
   if (gi_148 == FALSE) {
      Comment("\n Authorization Failed.\n Please contact us at\n http://www.pimpmyea.com");
      return (0);
   } */
   gi_148 = TRUE ;
   if (gi_148) {
      li_20 = IndicatorCounted();
      if (li_20 < 0) return (-1);
      if (li_20 > 0) li_20--;
      li_16 = Bars - li_20;
      if (iCustom_flag == FALSE) {
         g_window_216 = WindowFind(gs_280);
         if (gi_332 == FALSE && gi_368 == TRUE) {
            if (g_price_316 != -g_price_324) {
               ObjectCreate(g_name_336, OBJ_HLINE, g_window_216, 0, g_price_316);
               ObjectCreate(g_name_344, OBJ_HLINE, g_window_216, 0, -g_price_316);
               ObjectSet(g_name_336, OBJPROP_STYLE, STYLE_DOT);
               ObjectSet(g_name_344, OBJPROP_STYLE, STYLE_DOT);
               ObjectSet(g_name_336, OBJPROP_COLOR, RoyalBlue);
               ObjectSet(g_name_344, OBJPROP_COLOR, RoyalBlue);
            }
            ObjectCreate(g_name_352, OBJ_HLINE, g_window_216, 0, g_price_324);
            ObjectCreate(g_name_360, OBJ_HLINE, g_window_216, 0, -g_price_324);
            ObjectSet(g_name_352, OBJPROP_STYLE, STYLE_DASH);
            ObjectSet(g_name_360, OBJPROP_STYLE, STYLE_DASH);
            ObjectSet(g_name_352, OBJPROP_COLOR, Yellow);
            ObjectSet(g_name_360, OBJPROP_COLOR, Yellow);
            gi_332 = TRUE;
         }
      }
      if (gi_380 && iCustom_flag == FALSE) {
         gi_380 = FALSE;
         if (gi_368) {
            if (gd_384 < g_price_316) gi_372 = TRUE;
            if (gd_384 > -g_price_316) gi_376 = TRUE;
            if (gd_384 > g_price_324 && gi_372) {
               gi_372 = FALSE;
               Alert(Symbol(), ": PowerbarsFX Spread > ", g_price_324);
            }
            if (gd_384 < (-g_price_324) && gi_376) {
               gi_376 = FALSE;
               Alert(Symbol(), ": PowerbarsFX Spread < ", -g_price_324);
            }
         }
      }
      for (int index_12 = 0; index_12 < li_16; index_12++) {
         g_name_300 = "PowerbarsFX_Spread" + gs_220 + gs_228 + algo + Time[index_12];
         if (index_12 == 0 || ObjectFind(g_name_300) != g_window_216) {
            g_ibuf_264[index_12] = 0;
            for (int index_24 = 0; index_24 < 5; index_24++) {
               g_shift_296 = iBarShift(Symbol(), gia_272[index_24], Time[index_12]);
               ld_28 = f0_2(gs_220, gia_276[index_24], gia_272[index_24], g_shift_296);
               ld_36 = f0_2(gs_228, gia_276[index_24], gia_272[index_24], g_shift_296);
               ld_44 = ld_28 - ld_36;
               g_ibuf_264[index_12] += ld_44;
            }
            g_ibuf_264[index_12] = g_ibuf_264[index_12] / 5.0;
            if (g_ibuf_264[index_12] < 0.0) g_color_308 = f0_1(255, 0, 0, 255, 255, 255, 0, 100, MathAbs(g_ibuf_264[index_12]));
            if (g_ibuf_264[index_12] > 0.0) g_color_308 = f0_1(0, 255, 0, 255, 255, 255, 0, 100, MathAbs(g_ibuf_264[index_12]));
            if (iCustom_flag == FALSE) {
               ObjectDelete(g_name_300);
               ObjectCreate(g_name_300, OBJ_RECTANGLE, g_window_216, Time[index_12] - Period(), g_ibuf_264[index_12], Time[index_12], 0);
               ObjectSet(g_name_300, OBJPROP_BACK, TRUE);
               ObjectSet(g_name_300, OBJPROP_COLOR, g_color_308);
            }
         }
         if (index_12 == 0 && iCustom_flag == FALSE) {
            ObjectDelete(g_name_288);
            ObjectCreate(g_name_288, OBJ_TEXT, g_window_216, TimeCurrent(), 0);
            ObjectSetText(g_name_288, "                                 " + gs_236 + ": " + DoubleToStr(g_ibuf_264[index_12], 2), 10, "Segoe UI", g_color_308);
         }
         gd_384 = g_ibuf_264[0];
      }
      if (iCustom_flag != FALSE) return (0);
      ObjectsRedraw();
      return (0);
   }
   return (0);
}

double f0_10(string a_symbol_0, int a_timeframe_8, int a_period_12, double ad_16, int ai_24) {
   double ld_28 = (iClose(a_symbol_0, a_timeframe_8, ai_24) - iBands(a_symbol_0, a_timeframe_8, a_period_12, ad_16, 0, PRICE_CLOSE, MODE_LOWER, ai_24)) / (iBands(a_symbol_0,
      a_timeframe_8, a_period_12, ad_16, 0, PRICE_CLOSE, MODE_UPPER, ai_24) - iBands(a_symbol_0, a_timeframe_8, a_period_12, ad_16, 0, PRICE_CLOSE, MODE_LOWER, ai_24));
   return (100.0 * ld_28);
}

double f0_2(string as_0, int a_period_8, int a_timeframe_12, int ai_16) {
   double ld_20;
   int li_28;
   for (int index_32 = 0; index_32 < g_index_268; index_32++) {
      if (StringSubstr(gsa_256[index_32], 0, 3) == as_0) {
         if (algo == 1) ld_20 += iRSI(gsa_256[index_32], a_timeframe_12, a_period_8, PRICE_CLOSE, ai_16);
         if (algo == 2) ld_20 += iWPR(gsa_256[index_32], a_timeframe_12, a_period_8, ai_16) + 100.0;
         if (algo == 3) ld_20 += iStochastic(gsa_256[index_32], a_timeframe_12, a_period_8, 3, 3, MODE_SMA, 0, MODE_MAIN, ai_16);
         if (algo == 4) ld_20 += f0_10(gsa_256[index_32], a_timeframe_12, a_period_8, 2, ai_16);
         li_28++;
      }
      if (StringSubstr(gsa_256[index_32], 3, 3) == as_0) {
         if (algo == 1) ld_20 += 100 - iRSI(gsa_256[index_32], a_timeframe_12, a_period_8, PRICE_CLOSE, ai_16);
         if (algo == 2) ld_20 += 100 - (iWPR(gsa_256[index_32], a_timeframe_12, a_period_8, ai_16) + 100.0);
         if (algo == 3) ld_20 += 100 - iStochastic(gsa_256[index_32], a_timeframe_12, a_period_8, 3, 3, MODE_SMA, 0, MODE_MAIN, ai_16);
         if (algo == 4) ld_20 += 100 - f0_10(gsa_256[index_32], a_timeframe_12, a_period_8, 2, ai_16);
         li_28++;
      }
   }
   return (ld_20 / li_28);
}

int f0_3() {
   if (g_time_392 == Time[0]) return (0);
   g_time_392 = Time[0];
   return (1);
}

int f0_8(int ai_0, int ai_4, int ai_8) {
   int li_ret_12 = MathMin(255, MathAbs(ai_0)) + 256.0 * MathMin(255, MathAbs(ai_4)) + 65536.0 * MathMin(255, MathAbs(ai_8));
   return (li_ret_12);
}

int f0_1(int ai_0, int ai_4, int ai_8, int ai_12, int ai_16, int ai_20, double ad_24, double ad_32, double ad_40) {
   double ld_48 = ad_32 - ad_24;
   ad_40 = ad_32 - ad_40;
   double ld_56 = (ai_0 - ai_12) / (ld_48 - 1.0);
   double ld_64 = (ai_4 - ai_16) / (ld_48 - 1.0);
   double ld_72 = (ai_8 - ai_20) / (ld_48 - 1.0);
   return (f0_8(ai_0 - ld_56 * ad_40, ai_4 - ld_64 * ad_40, ai_8 - ld_72 * ad_40));
}

void f0_9() {
   string symbol_0;
   gs_244 = StringSubstr(Symbol(), 6, 0);
   gsa_252[0] = "AUD";
   gsa_252[1] = "CAD";
   gsa_252[2] = "CHF";
   gsa_252[3] = "EUR";
   gsa_252[4] = "GBP";
   gsa_252[5] = "JPY";
   gsa_252[6] = "NZD";
   gsa_252[7] = "USD";
   g_index_268 = 0;
   for (int index_8 = 0; index_8 < 8; index_8++) {
      for (int index_12 = 0; index_12 < 8; index_12++) {
         if (index_8 != index_12) {
            symbol_0 = gsa_252[index_8] + gsa_252[index_12] + gs_244;
            if (MarketInfo(symbol_0, MODE_TRADEALLOWED) == 1.0) {
               gsa_256[g_index_268] = symbol_0;
               g_index_268++;
            }
         }
      }
   }
}

string f0_13(string as_0) {
   string ls_12;
   string ls_20;
   for (int li_8 = StringFind(as_0, " "); li_8 != -1; li_8 = StringFind(as_0, " ")) {
      ls_12 = StringTrimLeft(StringTrimRight(StringSubstr(as_0, 0, StringFind(as_0, " ", 0))));
      ls_20 = StringTrimLeft(StringTrimRight(StringSubstr(as_0, StringFind(as_0, " ", 0))));
      as_0 = ls_12 + "%20" + ls_20;
   }
   return (as_0);
}

string f0_4(string as_0) {
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

string f0_6(string as_0) {
   string ls_8;
   string ls_unused_16;
   f0_7(as_0, ls_8);
   return (f0_4(f0_13("http://www.pimpmyea.com/auth/PowerbarsFX/" + ls_8 + ".html")));
}

void f0_7(string as_0, string &as_8) {
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

void f0_5(string as_0) {
   double ld_8;
   string lsa_16[];
   g_price_316 = 1000;
   g_price_324 = 1000;
   if (StringLen(as_0) != 0) {
      if (as_0 == "0") {
         g_price_316 = 0;
         g_price_324 = 0;
      } else {
         ld_8 = StrToDouble(as_0);
         if (ld_8 != 0.0 && f0_12(as_0)) {
            g_price_316 = -ld_8;
            g_price_324 = ld_8;
         } else {
            if (f0_11(as_0, ";", lsa_16, 2) != 0) {
               if (f0_0(lsa_16[0]) && f0_14(lsa_16[1])) return;
               g_price_316 = 1000;
               g_price_324 = 1000;
            }
         }
      }
   }
}

int f0_14(string as_0) {
   if (StringLen(as_0) == 0) return (0);
   if (f0_12(as_0) == 0) return (0);
   if (as_0 == "0") {
      g_price_316 = 0;
      return (1);
   }
   double ld_8 = StrToDouble(as_0);
   if (ld_8 != 0.0) {
      g_price_316 = ld_8;
      return (1);
   }
   return (0);
}

int f0_0(string as_0) {
   if (StringLen(as_0) == 0) return (0);
   if (f0_12(as_0) == 0) return (0);
   if (as_0 == "0") {
      g_price_324 = 0;
      return (1);
   }
   double ld_8 = StrToDouble(as_0);
   if (ld_8 != 0.0) {
      g_price_324 = ld_8;
      return (1);
   }
   return (0);
}

int f0_12(string as_0) {
   int li_16;
   if (StringLen(as_0) == 0) return (0);
   int count_8 = 0;
   for (int li_12 = 0; li_12 < StringLen(as_0); li_12++) {
      li_16 = StringGetChar(as_0, li_12);
      if (li_16 == '/') return (0);
      if (li_16 == '-' && li_12 > 0) return (0);
      if (li_16 < '-') return (0);
      if (li_16 > '9') return (0);
      if (li_16 == '.') count_8++;
   }
   if (count_8 > 1) return (0);
   return (1);
}

int f0_11(string as_0, string as_8, string &asa_16[], int ai_20 = 0) {
   int li_24;
   int li_28;
   int li_32;
   if (StringFind(as_0, as_8) < 0) {
      ArrayResize(asa_16, 1);
      asa_16[0] = as_0;
   } else {
      li_24 = 0;
      li_28 = 0;
      li_32 = 0;
      while (li_28 > -1) {
         li_32++;
         li_28 = StringFind(as_0, as_8, li_24);
         ArrayResize(asa_16, li_32);
         if (li_28 > -1) {
            if (li_28 - li_24 > 0) asa_16[li_32 - 1] = StringSubstr(as_0, li_24, li_28 - li_24);
         } else asa_16[li_32 - 1] = StringSubstr(as_0, li_24, 0);
         li_24 = li_28 + 1;
      }
   }
   if (ai_20 == 0 || ai_20 == ArraySize(asa_16)) return (1);
   return (0);
}
