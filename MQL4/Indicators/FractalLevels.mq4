//+------------------------------------------------------------------+
//|                                                FractalLevels.mq4 |
//|                                        Copyright © 2008, lotos4u |
//|                                                lotos4u@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, lotos4u"
#property link      "lotos4u@gmail.com"

#property indicator_chart_window
#property indicator_buffers 4

#property indicator_width1 4
#property indicator_width2 4
#property indicator_width3 2
#property indicator_width4 2

#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Gold
#property indicator_color4 Gold

//---- input parameters
extern int FractalBars = 3;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ArrowUpBuffer3[];
double ArrowDownBuffer4[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexArrow(0, 158);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexEmptyValue(0, 0.0);
   SetIndexLabel(0, "Фрактальное сопротивление");
   
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexArrow(1, 158);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexEmptyValue(1, 0.0);
   SetIndexLabel(1, "Фрактальная поддержка");

   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, 119);
   SetIndexBuffer(2, ArrowUpBuffer3);
   SetIndexEmptyValue(2, 0.0);
   SetIndexLabel(2, "Фрактал ВЕРХ");
   
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 119);
   SetIndexBuffer(3, ArrowDownBuffer4);
   SetIndexEmptyValue(3, 0.0);
   SetIndexLabel(3, "Фрактал ВНИЗ");
   return(0);
}


//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit(){return(0);}



//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int counted_bars = IndicatorCounted();
   int periods[] = {0, PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30, PERIOD_H1, 
                    PERIOD_H4, PERIOD_D1, PERIOD_W1, PERIOD_MN1};
   int limit;
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars;

   for(int i = limit; i > 0; i--)
   {
      //---- ma_shift присваивается 0, потому что SetIndexShift, вызываемый выше
      ExtMapBuffer1[i] = isFractalUp(i, FractalBars);
      if(ExtMapBuffer1[i] == 0)
         ExtMapBuffer1[i] = ExtMapBuffer1[i+1];
      else
         ArrowUpBuffer3[i] = ExtMapBuffer1[i];
      
      //ExtMapBuffer2[i] = iFractals(NULL, period0, MODE_LOWER, BS);
      ExtMapBuffer2[i] = isFractalDown(i, FractalBars);
      if(ExtMapBuffer2[i] == 0)
         ExtMapBuffer2[i] = ExtMapBuffer2[i+1];
      else
         ArrowDownBuffer4[i] = ExtMapBuffer2[i];
   }
   return(0);
}


double isFractalUp(int index, int bars)
{
   double max = High[index];
   for(int i = index + bars; i >= (index - bars); i--)
   {
      if(High[i] == 0.0)return(0);
      if(max <= High[i] && i != index)
      {
         if(max < High[i])
            return(0);
         if(MathAbs(i - index) > 1)
            return(0);
      }
   }
   return(max);
}


double isFractalDown(int index, int bars)
{
   double min = Low[index];
   for(int i = index + bars; i >= (index - bars); i--)
   {
      if(Low[i] == 0.0)return(0);
      if(min >= Low[i] && i != index)
      {
         if(min > Low[i])
            return(0);

         if(MathAbs(i - index) > 1)
            return(0);
      }
   }
   return(min);
}