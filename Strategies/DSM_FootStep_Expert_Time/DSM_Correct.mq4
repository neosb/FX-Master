//+-------------------------------------------------------------------------------------+
//|                                                                     DSM_Correct.mq4 |
//|                                                                           Scriptong |
//|                                                                   scriptong@mail.ru |
//+-------------------------------------------------------------------------------------+
#property copyright "Scriptong"
#property link      "scriptong@mail.ru"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

extern int AppliedPrice=0; //По какой цене считать. 4 - H+L/2
extern int MAperiod=13;
extern int Setting=1;
extern int iShift=0;


double ExtMapBuffer[];
double Tick;

//+--------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                             |
//+--------------------------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,ExtMapBuffer);
   Tick = MarketInfo(Symbol(), MODE_TICKSIZE)*MathPow(10, Setting);
   return(0);
  } 

//+--------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                  |
//+--------------------------------------------------------------------------------------+
int start()
  {
   int limit = Bars - IndicatorCounted();
   if (IndicatorCounted() > 0)
     limit++;
     
   for (int i = limit; i >= 0; i--)
     ExtMapBuffer[i] = MathRound(iMA(Symbol(), 0, MAperiod, iShift, MODE_EMA, 
                                 AppliedPrice, i)/Tick)*Tick;

   return(0);
  }

