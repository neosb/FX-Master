//+------------------------------------------------------------------+
//|                                               Doda-Donchian2.mq4 |
//|                                             Copyright 2013, AlFa |
//|                                     alessio.fabiani at gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, AlFa"
#property link      "alessio.fabiani at gmail.com"

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
int ai_108 = 0;
int a_datetime_112;
double a_price_116;
string a_dbl2str_124;
string a_str_concat_132;
double a_ibuf_140[];
double a_ibuf_144[];
double a_ibuf_148[];
double a_ibuf_152[];
double a_ibuf_156[];
bool ai_160 = FALSE;
bool ai_164 = FALSE;

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, a_ibuf_140);
   SetIndexLabel(0, "UpperLine");
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, a_ibuf_144);
   SetIndexLabel(1, "LowerLine");
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, a_ibuf_148);
   SetIndexLabel(2, "MidLine");
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexArrow(3, SYMBOL_ARROWUP);
   SetIndexBuffer(3, a_ibuf_152);
   SetIndexLabel(3, "Buy");
   SetIndexStyle(4, DRAW_ARROW, EMPTY);
   SetIndexArrow(4, SYMBOL_ARROWDOWN);
   SetIndexBuffer(4, a_ibuf_156);
   SetIndexLabel(4, "Sell");
   ObjectCreate("myPriceLabel", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("myPrice", OBJ_TEXT, 0, a_datetime_112, a_price_116);
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
   double ald_4;
   double ald_12;
   double ald_20;
   int ali_100;
   double l_ima_136;
   double l_ima_144;
   double ald_152;
   ArrayCopyRates(lda_0, Symbol(), PERIOD_D1);
   if (DayOfWeek() == 1) {
      if (TimeDayOfWeek(iTime(Symbol(), PERIOD_D1, 1)) == 5) {
         ald_4 = lda_0[1][4];
         ald_12 = lda_0[1][3];
         ald_20 = lda_0[1][2];
      } else {
         for (int ali_28 = 5; ali_28 >= 0; ali_28--) {
            if (TimeDayOfWeek(iTime(Symbol(), PERIOD_D1, ali_28)) == 5) {
               ald_4 = lda_0[ali_28][4];
               ald_12 = lda_0[ali_28][3];
               ald_20 = lda_0[ali_28][2];
            }
         }
      }
   } else {
      ald_4 = lda_0[1][4];
      ald_12 = lda_0[1][3];
      ald_20 = lda_0[1][2];
   }
   double ald_32 = ald_12 - ald_20;
   double ald_40 = (ald_12 + ald_20 + ald_4) / 3.0;
   double ald_48 = ald_40 + 1.0 * ald_32;
   double ald_56 = ald_40 + 0.618 * ald_32;
   double ald_64 = ald_40 + ald_32 / 2.0;
   double ald_72 = ald_40 - ald_32 / 2.0;
   double ald_80 = ald_40 - 0.618 * ald_32;
   double ald_88 = ald_40 - 1.0 * ald_32;
   drawLine(ald_48, "R3", Green, 0);
   drawLabel("Resistance 3", ald_48, Green);
   drawLine(ald_56, "R2", Green, 0);
   drawLabel("Resistance 2", ald_56, Green);
   drawLine(ald_64, "R1", DarkGreen, 0);
   drawLabel("Resistance 1", ald_64, Green);
   drawLine(ald_40, "PIVOT", pivotColor, 1);
   drawLabel("Pivot level", ald_40, pivotlevelColor);
   drawLine(ald_72, "S1", Maroon, 0);
   drawLabel("Support 1", ald_72, Red);
   drawLine(ald_80, "S2", Crimson, 0);
   drawLabel("Support 2", ald_80, Red);
   drawLine(ald_88, "S3", Red, 0);
   drawLabel("Support 3", ald_88, Red);
   int l_ind_counted_104 = IndicatorCounted();
   if (Bars <= ChannelPeriod) return (0);
   if (l_ind_counted_104 >= ChannelPeriod) ali_100 = Bars - l_ind_counted_104 - 1;
   else ali_100 = Bars - ChannelPeriod - 1;
   a_ibuf_152[0] = 0;
   a_ibuf_156[0] = 0;
   for (int ali_96 = ali_100; ali_96 >= 0; ali_96--) {
      a_ibuf_140[ali_96] = High[iHighest(NULL, 0, MODE_HIGH, ChannelPeriod, ali_96)];
      a_ibuf_144[ali_96] = Low[iLowest(NULL, 0, MODE_LOW, ChannelPeriod, ali_96)];
      a_ibuf_148[ali_96] = (a_ibuf_140[ali_96] + a_ibuf_144[ali_96]) / 2.0;
      l_ima_136 = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_MEDIAN, ali_96 + EndEMAShift);
      l_ima_144 = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_MEDIAN, ali_96 + StartEMAShift);
      ald_152 = 10000.0 * (l_ima_136 - l_ima_144) / (StartEMAShift - EndEMAShift);
      if (a_ibuf_140[ali_96 + 1] < High[ali_96] && ald_152 > AngleTreshold) a_ibuf_152[ali_96] = High[ali_96];
      if (a_ibuf_144[ali_96 + 1] > Low[ali_96] && ald_152 < (-AngleTreshold)) a_ibuf_156[ali_96] = Low[ali_96];
      if (Close[ali_96] > a_ibuf_148[ali_96] && ai_160 == FALSE) {
         ai_108 = TRUE;
         a_price_116 = Close[ali_96];
         a_datetime_112 = Time[ali_96];
         ai_160 = TRUE;
         ai_164 = FALSE;
      }
      if (Close[ali_96] < a_ibuf_148[ali_96] && ai_164 == FALSE) {
         ai_108 = FALSE;
         a_price_116 = Close[ali_96];
         a_datetime_112 = Time[ali_96];
         ai_160 = FALSE;
         ai_164 = TRUE;
      }
   }
   if (ai_108 == TRUE) {
      ObjectDelete("myHline2");
      ObjectDelete("myVline2");
      ObjectCreate("myHline2", OBJ_HLINE, 0, a_datetime_112, a_price_116, 0, 0);
      ObjectCreate("myVline2", OBJ_VLINE, 0, a_datetime_112, a_price_116, 0, 0);
      ObjectSet("myHline2", OBJPROP_COLOR, Lime);
      ObjectSet("myVline2", OBJPROP_COLOR, Lime);
      ObjectSetText("myPrice", StringConcatenate("", a_price_116), 18, "Arial", Lime);
      ObjectSetText("myPriceLabel", StringConcatenate("Buy Price @: ", DoubleToStr(a_price_116, Digits)), 10, "Arial", Lime);
      ObjectSet("myPriceLabel", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPriceLabel", OBJPROP_YDISTANCE, 30);
      ObjectSet("myPriceLabel", OBJPROP_CORNER, 1);
      if (Symbol() == "AUDNZD" || Symbol() == "GBPAUD" || Symbol() == "EURAUD" || Symbol() == "EURCAD") ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - a_price_116, Digits) / Point), 10, "Arial", Lime);
      else ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - a_price_116, Digits) / Point / 10.0), 10, "Arial", Lime);
      ObjectSet("myPips", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPips", OBJPROP_YDISTANCE, 46);
      ObjectSet("myPips", OBJPROP_CORNER, 1);
      a_dbl2str_124 = DoubleToStr(a_price_116, Digits);
      a_str_concat_132 = StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - a_price_116, Digits) / Point / 10.0);
   }
   if (ai_108 == FALSE) {
      ObjectDelete("myHline2");
      ObjectDelete("myVline2");
      ObjectCreate("myHline2", OBJ_HLINE, 0, a_datetime_112, a_price_116, 0, 0);
      ObjectCreate("myVline2", OBJ_VLINE, 0, a_datetime_112, a_price_116, 0, 0);
      ObjectSet("myHline2", OBJPROP_COLOR, Red);
      ObjectSet("myVline2", OBJPROP_COLOR, Red);
      ObjectSetText("myPrice", StringConcatenate("", a_price_116), 18, "Arial", Red);
      ObjectSetText("myPriceLabel", StringConcatenate("Sell Price @: ", DoubleToStr(a_price_116, Digits)), 10, "Arial", Red);
      ObjectSet("myPriceLabel", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPriceLabel", OBJPROP_YDISTANCE, 30);
      ObjectSet("myPriceLabel", OBJPROP_CORNER, 1);
      if (Symbol() == "AUDNZD" || Symbol() == "GBPAUD" || Symbol() == "EURAUD" || Symbol() == "EURCAD") ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(a_price_116 - Close[0], Digits) / Point), 10, "Arial", Red);
      else ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(a_price_116 - Close[0], Digits) / Point / 10.0), 10, "Arial", Red);
      ObjectSet("myPips", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPips", OBJPROP_YDISTANCE, 46);
      ObjectSet("myPips", OBJPROP_CORNER, 1);
      a_dbl2str_124 = DoubleToStr(a_price_116, Digits);
      a_str_concat_132 = StringConcatenate("Profit in Pips: ", NormalizeDouble(a_price_116 - Close[0], Digits) / Point / 10.0);
   }
   ObjectSetText("mywebsite", "Powered by www.DodaCharts.com", 10, "Arial", Red);
   ObjectSet("mywebsite", OBJPROP_XDISTANCE, 2);
   ObjectSet("mywebsite", OBJPROP_YDISTANCE, 2);
   ObjectSet("mywebsite", OBJPROP_CORNER, 1);
   ObjectSetText("nameversion", "Doda-Donchian ver 2.0", 10, "Arial", Red);
   ObjectSet("nameversion", OBJPROP_XDISTANCE, 2);
   ObjectSet("nameversion", OBJPROP_YDISTANCE, 16);
   ObjectSet("nameversion", OBJPROP_CORNER, 1);
   ObjectSetText("mysl", "Stop Loss: " + DoubleToStr(a_ibuf_148[0], Digits), 10, "Arial", Red);
   ObjectSet("mysl", OBJPROP_XDISTANCE, 2);
   ObjectSet("mysl", OBJPROP_YDISTANCE, 60);
   ObjectSet("mysl", OBJPROP_CORNER, 1);
   ObjectSetText("support1", "Support1: " + DoubleToStr(ald_72, Digits), 10, "Arial", Red);
   ObjectSet("support1", OBJPROP_XDISTANCE, 2);
   ObjectSet("support1", OBJPROP_YDISTANCE, 75);
   ObjectSet("support1", OBJPROP_CORNER, 1);
   ObjectSetText("support2", "Support2: " + DoubleToStr(ald_80, Digits), 10, "Arial", Red);
   ObjectSet("support2", OBJPROP_XDISTANCE, 2);
   ObjectSet("support2", OBJPROP_YDISTANCE, 90);
   ObjectSet("support2", OBJPROP_CORNER, 1);
   ObjectSetText("support3", "Support3: " + DoubleToStr(ald_88, Digits), 10, "Arial", Red);
   ObjectSet("support3", OBJPROP_XDISTANCE, 2);
   ObjectSet("support3", OBJPROP_YDISTANCE, 105);
   ObjectSet("support3", OBJPROP_CORNER, 1);
   ObjectSetText("resistance1", "Resistance1: " + DoubleToStr(ald_64, Digits), 10, "Arial", Red);
   ObjectSet("resistance1", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance1", OBJPROP_YDISTANCE, 120);
   ObjectSet("resistance1", OBJPROP_CORNER, 1);
   ObjectSetText("resistance2", "Resistance2: " + DoubleToStr(ald_56, Digits), 10, "Arial", Red);
   ObjectSet("resistance2", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance2", OBJPROP_YDISTANCE, 135);
   ObjectSet("resistance2", OBJPROP_CORNER, 1);
   ObjectSetText("resistance3", "Resistance3: " + DoubleToStr(ald_48, Digits), 10, "Arial", Red);
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

