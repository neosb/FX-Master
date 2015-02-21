/*
   Generated by EX4-TO-MQ4 decompiler V4.0.225.1g []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 CLR_NONE
#property indicator_color2 CLR_NONE
#property indicator_color3 Red
#property indicator_color4 CLR_NONE
#property indicator_color5 CLR_NONE

extern color pivotColor = White;
extern color pivotlevelColor = White;
extern int ChannelPeriod = 28;
extern int EMAPeriod = 120;
extern int StartEMAShift = 6;
extern int EndEMAShift = 0;
extern double AngleTreshold = 0.32;
int gi_108 = 0;
int g_datetime_112;
double g_price_116;
string g_dbl2str_124;
string g_str_concat_132;
double g_ibuf_140[];
double g_ibuf_144[];
double g_ibuf_148[];
double g_ibuf_152[];
double g_ibuf_156[];
bool gi_160 = FALSE;
bool gi_164 = FALSE;

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, g_ibuf_140);
   SetIndexLabel(0, "UpperLine");
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, g_ibuf_144);
   SetIndexLabel(1, "LowerLine");
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, g_ibuf_148);
   SetIndexLabel(2, "MidLine");
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexArrow(3, SYMBOL_ARROWUP);
   SetIndexBuffer(3, g_ibuf_152);
   SetIndexLabel(3, "Buy");
   SetIndexStyle(4, DRAW_ARROW, EMPTY);
   SetIndexArrow(4, SYMBOL_ARROWDOWN);
   SetIndexBuffer(4, g_ibuf_156);
   SetIndexLabel(4, "Sell");
   ObjectCreate("myPriceLabel", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("myPrice", OBJ_TEXT, 0, g_datetime_112, g_price_116);
   ObjectCreate("myPips", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("nameversion", OBJ_LABEL, 0, 0, 0);
   IndicatorShortName("DonchianChannel(" + ChannelPeriod + ")");
   SetIndexDrawBegin(0, ChannelPeriod);
   SetIndexDrawBegin(1, ChannelPeriod);
   ObjectCreate("mywebsite", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("mysl", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("support1", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("support2", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("support3", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("resistance1", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("resistance2", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("resistance3", OBJ_LABEL, 0, 0, 0);
   return (0);
}

int deinit() {
   ObjectDelete("mysl");
   ObjectDelete("mywebsite");
   ObjectDelete("myHline2");
   ObjectDelete("myVline2");
   ObjectDelete("nameversion");
   ObjectDelete("S1");
   ObjectDelete("S2");
   ObjectDelete("S3");
   ObjectDelete("R1");
   ObjectDelete("R2");
   ObjectDelete("R3");
   ObjectDelete("PIVIOT");
   ObjectDelete("Support 1");
   ObjectDelete("Support 2");
   ObjectDelete("Support 3");
   ObjectDelete("Piviot level");
   ObjectDelete("Resistance 1");
   ObjectDelete("Resistance 2");
   ObjectDelete("Resistance 3");
   ObjectDelete("support1");
   ObjectDelete("support2");
   ObjectDelete("support3");
   ObjectDelete("resistance1");
   ObjectDelete("resistance2");
   ObjectDelete("resistance3");
   return (0);
}

int start() {
   double lda_0[1][6];
   double ld_4;
   double ld_12;
   double ld_20;
   int li_100;
   double l_ima_136;
   double l_ima_144;
   double ld_152;
   ArrayCopyRates(lda_0, Symbol(), PERIOD_D1);
   if (DayOfWeek() == 1) {
      if (TimeDayOfWeek(iTime(Symbol(), PERIOD_D1, 1)) == 5) {
         ld_4 = lda_0[1][4];
         ld_12 = lda_0[1][3];
         ld_20 = lda_0[1][2];
      } else {
         for (int li_28 = 5; li_28 >= 0; li_28--) {
            if (TimeDayOfWeek(iTime(Symbol(), PERIOD_D1, li_28)) == 5) {
               ld_4 = lda_0[li_28][4];
               ld_12 = lda_0[li_28][3];
               ld_20 = lda_0[li_28][2];
            }
         }
      }
   } else {
      ld_4 = lda_0[1][4];
      ld_12 = lda_0[1][3];
      ld_20 = lda_0[1][2];
   }
   double ld_32 = ld_12 - ld_20;
   double ld_40 = (ld_12 + ld_20 + ld_4) / 3.0;
   double ld_48 = ld_40 + 1.0 * ld_32;
   double ld_56 = ld_40 + 0.618 * ld_32;
   double ld_64 = ld_40 + ld_32 / 2.0;
   double ld_72 = ld_40 - ld_32 / 2.0;
   double ld_80 = ld_40 - 0.618 * ld_32;
   double ld_88 = ld_40 - 1.0 * ld_32;
   drawLine(ld_48, "R3", Green, 0);
   drawLabel("Resistance 3", ld_48, Green);
   drawLine(ld_56, "R2", Green, 0);
   drawLabel("Resistance 2", ld_56, Green);
   drawLine(ld_64, "R1", DarkGreen, 0);
   drawLabel("Resistance 1", ld_64, Green);
   drawLine(ld_40, "PIVOT", pivotColor, 1);
   drawLabel("Pivot level", ld_40, pivotlevelColor);
   drawLine(ld_72, "S1", Maroon, 0);
   drawLabel("Support 1", ld_72, Red);
   drawLine(ld_80, "S2", Crimson, 0);
   drawLabel("Support 2", ld_80, Red);
   drawLine(ld_88, "S3", Red, 0);
   drawLabel("Support 3", ld_88, Red);
   int l_ind_counted_104 = IndicatorCounted();
   if (Bars <= ChannelPeriod) return (0);
   if (l_ind_counted_104 >= ChannelPeriod) li_100 = Bars - l_ind_counted_104 - 1;
   else li_100 = Bars - ChannelPeriod - 1;
   g_ibuf_152[0] = 0;
   g_ibuf_156[0] = 0;
   for (int li_96 = li_100; li_96 >= 0; li_96--) {
      g_ibuf_140[li_96] = High[iHighest(NULL, 0, MODE_HIGH, ChannelPeriod, li_96)];
      g_ibuf_144[li_96] = Low[iLowest(NULL, 0, MODE_LOW, ChannelPeriod, li_96)];
      g_ibuf_148[li_96] = (g_ibuf_140[li_96] + g_ibuf_144[li_96]) / 2.0;
      l_ima_136 = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_MEDIAN, li_96 + EndEMAShift);
      l_ima_144 = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_MEDIAN, li_96 + StartEMAShift);
      ld_152 = 10000.0 * (l_ima_136 - l_ima_144) / (StartEMAShift - EndEMAShift);
      if (g_ibuf_140[li_96 + 1] < High[li_96] && ld_152 > AngleTreshold) g_ibuf_152[li_96] = High[li_96];
      if (g_ibuf_144[li_96 + 1] > Low[li_96] && ld_152 < (-AngleTreshold)) g_ibuf_156[li_96] = Low[li_96];
      if (Close[li_96] > g_ibuf_148[li_96] && gi_160 == FALSE) {
         gi_108 = TRUE;
         g_price_116 = Close[li_96];
         g_datetime_112 = Time[li_96];
         gi_160 = TRUE;
         gi_164 = FALSE;
      }
      if (Close[li_96] < g_ibuf_148[li_96] && gi_164 == FALSE) {
         gi_108 = FALSE;
         g_price_116 = Close[li_96];
         g_datetime_112 = Time[li_96];
         gi_160 = FALSE;
         gi_164 = TRUE;
      }
   }
   if (gi_108 == TRUE) {
      ObjectDelete("myHline2");
      ObjectDelete("myVline2");
      ObjectCreate("myHline2", OBJ_HLINE, 0, g_datetime_112, g_price_116, 0, 0);
      ObjectCreate("myVline2", OBJ_VLINE, 0, g_datetime_112, g_price_116, 0, 0);
      ObjectSet("myHline2", OBJPROP_COLOR, Lime);
      ObjectSet("myVline2", OBJPROP_COLOR, Lime);
      ObjectSetText("myPrice", StringConcatenate("", g_price_116), 18, "Arial", Lime);
      ObjectSetText("myPriceLabel", StringConcatenate("Buy Price @: ", DoubleToStr(g_price_116, Digits)), 10, "Arial", Lime);
      ObjectSet("myPriceLabel", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPriceLabel", OBJPROP_YDISTANCE, 30);
      ObjectSet("myPriceLabel", OBJPROP_CORNER, 1);
      if (Symbol() == "AUDNZD" || Symbol() == "GBPAUD" || Symbol() == "EURAUD" || Symbol() == "EURCAD") ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - g_price_116, Digits) / Point), 10, "Arial", Lime);
      else ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - g_price_116, Digits) / Point / 10.0), 10, "Arial", Lime);
      ObjectSet("myPips", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPips", OBJPROP_YDISTANCE, 46);
      ObjectSet("myPips", OBJPROP_CORNER, 1);
      g_dbl2str_124 = DoubleToStr(g_price_116, Digits);
      g_str_concat_132 = StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - g_price_116, Digits) / Point / 10.0);
   }
   if (gi_108 == FALSE) {
      ObjectDelete("myHline2");
      ObjectDelete("myVline2");
      ObjectCreate("myHline2", OBJ_HLINE, 0, g_datetime_112, g_price_116, 0, 0);
      ObjectCreate("myVline2", OBJ_VLINE, 0, g_datetime_112, g_price_116, 0, 0);
      ObjectSet("myHline2", OBJPROP_COLOR, Red);
      ObjectSet("myVline2", OBJPROP_COLOR, Red);
      ObjectSetText("myPrice", StringConcatenate("", g_price_116), 18, "Arial", Red);
      ObjectSetText("myPriceLabel", StringConcatenate("Sell Price @: ", DoubleToStr(g_price_116, Digits)), 10, "Arial", Red);
      ObjectSet("myPriceLabel", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPriceLabel", OBJPROP_YDISTANCE, 30);
      ObjectSet("myPriceLabel", OBJPROP_CORNER, 1);
      if (Symbol() == "AUDNZD" || Symbol() == "GBPAUD" || Symbol() == "EURAUD" || Symbol() == "EURCAD") ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(g_price_116 - Close[0], Digits) / Point), 10, "Arial", Red);
      else ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(g_price_116 - Close[0], Digits) / Point / 10.0), 10, "Arial", Red);
      ObjectSet("myPips", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPips", OBJPROP_YDISTANCE, 46);
      ObjectSet("myPips", OBJPROP_CORNER, 1);
      g_dbl2str_124 = DoubleToStr(g_price_116, Digits);
      g_str_concat_132 = StringConcatenate("Profit in Pips: ", NormalizeDouble(g_price_116 - Close[0], Digits) / Point / 10.0);
   }
   ObjectSetText("mywebsite", "Powered by www.DodaCharts.com", 10, "Arial", Red);
   ObjectSet("mywebsite", OBJPROP_XDISTANCE, 2);
   ObjectSet("mywebsite", OBJPROP_YDISTANCE, 2);
   ObjectSet("mywebsite", OBJPROP_CORNER, 1);
   ObjectSetText("nameversion", "Doda-Donchian ver 2.0", 10, "Arial", Red);
   ObjectSet("nameversion", OBJPROP_XDISTANCE, 2);
   ObjectSet("nameversion", OBJPROP_YDISTANCE, 16);
   ObjectSet("nameversion", OBJPROP_CORNER, 1);
   ObjectSetText("mysl", "Stop Loss: " + DoubleToStr(g_ibuf_148[0], Digits), 10, "Arial", Red);
   ObjectSet("mysl", OBJPROP_XDISTANCE, 2);
   ObjectSet("mysl", OBJPROP_YDISTANCE, 60);
   ObjectSet("mysl", OBJPROP_CORNER, 1);
   ObjectSetText("support1", "Support1: " + DoubleToStr(ld_72, Digits), 10, "Arial", Red);
   ObjectSet("support1", OBJPROP_XDISTANCE, 2);
   ObjectSet("support1", OBJPROP_YDISTANCE, 75);
   ObjectSet("support1", OBJPROP_CORNER, 1);
   ObjectSetText("support2", "Support2: " + DoubleToStr(ld_80, Digits), 10, "Arial", Red);
   ObjectSet("support2", OBJPROP_XDISTANCE, 2);
   ObjectSet("support2", OBJPROP_YDISTANCE, 90);
   ObjectSet("support2", OBJPROP_CORNER, 1);
   ObjectSetText("support3", "Support3: " + DoubleToStr(ld_88, Digits), 10, "Arial", Red);
   ObjectSet("support3", OBJPROP_XDISTANCE, 2);
   ObjectSet("support3", OBJPROP_YDISTANCE, 105);
   ObjectSet("support3", OBJPROP_CORNER, 1);
   ObjectSetText("resistance1", "Resistance1: " + DoubleToStr(ld_64, Digits), 10, "Arial", Red);
   ObjectSet("resistance1", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance1", OBJPROP_YDISTANCE, 120);
   ObjectSet("resistance1", OBJPROP_CORNER, 1);
   ObjectSetText("resistance2", "Resistance2: " + DoubleToStr(ld_56, Digits), 10, "Arial", Red);
   ObjectSet("resistance2", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance2", OBJPROP_YDISTANCE, 135);
   ObjectSet("resistance2", OBJPROP_CORNER, 1);
   ObjectSetText("resistance3", "Resistance3: " + DoubleToStr(ld_48, Digits), 10, "Arial", Red);
   ObjectSet("resistance3", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance3", OBJPROP_YDISTANCE, 150);
   ObjectSet("resistance3", OBJPROP_CORNER, 1);
   Comment("Doda-Donchian indicator by: www.DodaCharts.com");
   return (0);
}

void drawLabel(string a_name_0, double a_price_8, color a_color_16) {
   if (ObjectFind(a_name_0) != 0) {
      ObjectCreate(a_name_0, OBJ_TEXT, 0, Time[10], a_price_8);
      ObjectSetText(a_name_0, a_name_0, 8, "Arial", CLR_NONE);
      ObjectSet(a_name_0, OBJPROP_COLOR, a_color_16);
      return;
   }
   ObjectMove(a_name_0, 0, Time[10], a_price_8);
}

void drawLine(double a_price_0, string a_name_8, color a_color_16, int ai_20) {
   if (ObjectFind(a_name_8) != 0) {
      ObjectCreate(a_name_8, OBJ_HLINE, 0, Time[0], a_price_0, Time[0], a_price_0);
      if (ai_20 == 1) ObjectSet(a_name_8, OBJPROP_STYLE, STYLE_SOLID);
      else ObjectSet(a_name_8, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(a_name_8, OBJPROP_COLOR, a_color_16);
      ObjectSet(a_name_8, OBJPROP_WIDTH, 1);
      return;
   }
   ObjectDelete(a_name_8);
   ObjectCreate(a_name_8, OBJ_HLINE, 0, Time[0], a_price_0, Time[0], a_price_0);
   if (ai_20 == 1) ObjectSet(a_name_8, OBJPROP_STYLE, STYLE_SOLID);
   else ObjectSet(a_name_8, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(a_name_8, OBJPROP_COLOR, a_color_16);
   ObjectSet(a_name_8, OBJPROP_WIDTH, 1);
}
