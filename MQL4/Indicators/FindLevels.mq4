//+------------------------------------------------------------------+
//|                                                ExportLevels2.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

extern int MaxLimit = 1000;
extern int MaxCrossesLevel = 10;
extern double MaxR = 0.001;
extern color LineColor = White;
extern int LineWidth = 0;
extern int LineStyle = 0;
extern int TimePeriod = 0;

color  Colors[] = {Red,Maroon,Sienna,OrangeRed,Purple,Indigo,DarkViolet,MediumBlue,DarkSlateGray};
int    Widths[] = {1,2,3,4,5,6,7,8,9};
string Alphabet[] = {"i","h","g","f","e","d","c","b","a"};

int CrossBarsNum[];
bool CrossBarsMin[];
double d1Num =0.0, d2Num = 0.0;

datetime TMaxI = 0;

#define MaxLines 1000
string LineName[MaxLines];
int LineIndex = 0; 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
double prLow(int i)
{
  return (iLow(NULL,TimePeriod,i));
}
double prHigh(int i)
{
  return (iHigh(NULL,TimePeriod,i));
}

int Period2Int(int TmPeriod)
{
  switch (TmPeriod)
  {
    case PERIOD_M1  : return(0);
    case PERIOD_M5  : return(1);
    case PERIOD_M15 : return(2);
    case PERIOD_M30 : return(3);
    case PERIOD_H1  : return(4);
    case PERIOD_H4  : return(5);
    case PERIOD_D1  : return(6);
    case PERIOD_W1  : return(7);
    case PERIOD_MN1 : return(8);
  }      
  return (0);
}

string Period2AlpthabetString(int TmPeriod)
{
   return (Alphabet[Period2Int(TmPeriod)]);
}

int init()
  {
//---- indicators
//----
   if (TimePeriod==0)
     TimePeriod=Period();

   if (TimePeriod!=0&&LineWidth==0)
     if (Period2Int(TimePeriod)-Period2Int(Period())>=0)
       LineWidth=Widths[Period2Int(TimePeriod)-Period2Int(Period())];
     else
       {
         LineWidth=0;
         if (LineStyle==0)
           LineStyle=STYLE_DASH;
       }
   if (TimePeriod!=0&&LineColor==White)
     LineColor=Colors[Period2Int(TimePeriod)];
     
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for (int i = 0; i<LineIndex;i++)
     ObjectDelete(LineName[i]);
   
          
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int    limit = MathMin(Bars - counted_bars,MaxLimit);
   
   double d1 = prLow(Lowest(NULL,TimePeriod,MODE_LOW,limit,0));
   double d2 = prHigh(Highest(NULL,TimePeriod,MODE_HIGH,limit,0));
   
   if (d1Num!=d1||d2Num!=d2)
     {
       ArrayResize(CrossBarsNum, (d2-d1)*10000);
       ArrayResize(CrossBarsMin, (d2-d1)*10000);
       if (d1Num!=d1&&d1Num!=0.0)
       {
         ArrayCopy(CrossBarsNum,CrossBarsNum, 0, (d1Num-d1)*10000);
         ArrayCopy(CrossBarsMin,CrossBarsMin, 0, (d1Num-d1)*10000);
       }
       d1Num=d1;
       d2Num=d2;
     }
     
   
   for (double d=d1;d<=d2;d+=0.0001)
     {
       int di = (d-d1)*10000;
       for (int i=1; i<limit;i++)
         if (d>prLow(i)&&d<prHigh(i))
           CrossBarsNum[di]++;
       if (Time[limit]!=TMaxI&&TMaxI!=0)
         if (d>prLow(iBarShift(NULL,0,TMaxI))&&d<prHigh(iBarShift(NULL,0,TMaxI)))
           CrossBarsNum[di]--;
     }
   TMaxI = Time[limit]-1;

   double l=MaxR*10000;
   for (d=d1+MaxR;d<=d2-MaxR;d+=0.0001)
     {
        di = (d-d1)*10000;
        if (!CrossBarsMin[di]&&//CrossBarsNum[di]<MaxCrossesLevel&&
             CrossBarsNum[ArrayMaximum(CrossBarsNum,2*l,di-l)]-CrossBarsNum[ArrayMinimum(CrossBarsNum,2*l,di-l)]>MaxCrossesLevel
                             &&CrossBarsNum[di]  ==CrossBarsNum[ArrayMinimum(CrossBarsNum,2*l,di-l)]
                             &&CrossBarsNum[di-1]!=CrossBarsNum[ArrayMinimum(CrossBarsNum,2*l,di-l)])
        {
          CrossBarsMin[di]=true;
          LineName[LineIndex]=Period2AlpthabetString(TimePeriod)+TimePeriod+"_"+d;
          
          ObjectCreate(LineName[LineIndex],OBJ_HLINE,0,0,d);
          ObjectSet(LineName[LineIndex],OBJPROP_COLOR,LineColor);
          ObjectSet(LineName[LineIndex],OBJPROP_WIDTH,LineWidth);
          ObjectSet(LineName[LineIndex],OBJPROP_STYLE,LineStyle);
          LineIndex++;
        }

        if (CrossBarsMin[di]&&CrossBarsNum[di]!=CrossBarsNum[ArrayMinimum(CrossBarsNum,2*l,di-l)])
        {
          CrossBarsMin[di]=false;
          ObjectDelete(Period2AlpthabetString(TimePeriod)+TimePeriod+"_"+d);
        }
          
     }
       
   return(0);
  }
//+------------------------------------------------------------------+