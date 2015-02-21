//+------------------------------------------------------------------+
//|                                                  Doda-Bands2.mq4 |
//|                                             Copyright 2013, AlFa |
//|                                     alessio.fabiani at gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, AlFa"
#property link      "alessio.fabiani at gmail.com"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 RoyalBlue
#property indicator_color2 Red
#property indicator_color3 RoyalBlue
#property indicator_color4 Red
#property indicator_color5 RoyalBlue
#property indicator_color6 Red

extern int Length = 20;
extern int Deviation = 2;
extern double MoneyRisk = 1.0;
extern int Signal = 1;
extern int Line = 1;
extern int Nbars = 1000;
double a_ibuf_124[];
double a_ibuf_128[];
double a_ibuf_132[];
double a_ibuf_136[];
double a_ibuf_140[];
double a_ibuf_144[];
extern bool SoundON = TRUE;
bool ai_152 = FALSE;
bool ai_156 = FALSE;

int init() {
   ObjectCreate("mywebsite", OBJ_LABEL, 0, 0, 0);
   SetIndexBuffer(0, a_ibuf_124);
   SetIndexBuffer(1, a_ibuf_128);
   SetIndexBuffer(2, a_ibuf_132);
   SetIndexBuffer(3, a_ibuf_136);
   SetIndexBuffer(4, a_ibuf_140);
   SetIndexBuffer(5, a_ibuf_144);
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexStyle(3, DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexStyle(5, DRAW_LINE);
   SetIndexArrow(0, 159);
   SetIndexArrow(1, 159);
   SetIndexArrow(2, 108);
   SetIndexArrow(3, 108);
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS));
   string ls_0 = "BBands Stop(" + Length + "," + Deviation + ")";
   IndicatorShortName(ls_0);
   SetIndexLabel(0, "UpTrend Stop");
   SetIndexLabel(1, "DownTrend Stop");
   SetIndexLabel(2, "UpTrend Signal");
   SetIndexLabel(3, "DownTrend Signal");
   SetIndexLabel(4, "UpTrend Line");
   SetIndexLabel(5, "DownTrend Line");
   SetIndexDrawBegin(0, Length);
   SetIndexDrawBegin(1, Length);
   SetIndexDrawBegin(2, Length);
   SetIndexDrawBegin(3, Length);
   SetIndexDrawBegin(4, Length);
   SetIndexDrawBegin(5, Length);
   return (0);
}

int deinit() {
   ObjectDelete("mywebsite");
   return (0);
}

int start() {
   int ali_8;
   double lda_12[25000];
   double lda_16[25000];
   double lda_20[25000];
   double lda_24[25000];
   for (int al_shift_4 = Nbars; al_shift_4 >= 0; al_shift_4--) {
      a_ibuf_124[al_shift_4] = 0;
      a_ibuf_128[al_shift_4] = 0;
      a_ibuf_132[al_shift_4] = 0;
      a_ibuf_136[al_shift_4] = 0;
      a_ibuf_140[al_shift_4] = EMPTY_VALUE;
      a_ibuf_144[al_shift_4] = EMPTY_VALUE;
   }
   for (al_shift_4 = Nbars - Length - 1; al_shift_4 >= 0; al_shift_4--) {
      lda_12[al_shift_4] = iBands(NULL, 0, Length, Deviation, 0, PRICE_CLOSE, MODE_UPPER, al_shift_4);
      lda_16[al_shift_4] = iBands(NULL, 0, Length, Deviation, 0, PRICE_CLOSE, MODE_LOWER, al_shift_4);
      if (Close[al_shift_4] > lda_12[al_shift_4 + 1]) ali_8 = 1;
      if (Close[al_shift_4] < lda_16[al_shift_4 + 1]) ali_8 = -1;
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
               Alert("DodaCharts-BBands going Up on ", Symbol(), "-", Period());
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
               Alert("DodaCharts-BBands going Down on ", Symbol(), "-", Period());
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
   ObjectSetText("mywebsite", "Doda-Bollinger 1.0 | Powered by www.DodaCharts.com", 10, "Arial", Red);
   ObjectSet("mywebsite", OBJPROP_XDISTANCE, 2);
   ObjectSet("mywebsite", OBJPROP_YDISTANCE, 15);
   ObjectSet("mywebsite", OBJPROP_CORNER, 0);
   return (0);
}