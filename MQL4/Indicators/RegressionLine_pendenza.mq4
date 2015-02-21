//+------------------------------------------------------------------+
//|                                      RegressionLine_pendenza.mq4 |
//|                                                       Umberforex |
//|                                              http://www.mql4.com |
//////////////////////////////////////////////////////////////////////
#property copyright "Copyright © 2011 Umberforex"
#property link      "http://www.facebook.com/umberto.soracemaresca"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Orange
//#property indicator_width 3


extern string Legenda_minuti="minuti del timeframe della retta di regressione";
extern int minuti=30;    // viene usata nella funzione 'string PERIOD_timeframe(int minuti)'

extern int Period_regression = 5;   // numero di barre su cui calcolare la retta di regressione

extern double MAXpipDifferenza = 4;

int timeframe;

extern string applied_price_LEGENDA="0=Close price; 1 = Open price";
extern int applied_price=0;                  // 0 = Close price; 1 = Open price


double regression_line[];           // array dei valori della retta di regressione 

string regrName;

string commentoSulGrafico;

//////////////////////////////////////////////////////////////////////
int init()
{
   IndicatorBuffers(1);

   SetIndexBuffer(0,regression_line);        //Assegno l'array al buffer
   // SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1); // Line style
   SetIndexStyle(0,DRAW_NONE,STYLE_SOLID,1);
   SetIndexDrawBegin(0,Period_regression);
   IndicatorDigits(Digits);

   timeframe = PERIOD_timeframe(minuti);

   return(0);
}

//////////////////////////////////////////////////////////////////////
int deinit()
{  
   ObjectsDeleteAll();
   return(0);
}

//////////////////////////////////////////////////////////////////////
int start()
  {
   if (New_Bar()==true)    ObjectDelete(regrName);

   int limit, i;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars-1;
   for(i=limit; i>=0; i--) 
     {
      double Y_media=0.0, X_media=0.0, Sommatoria_XiYi=0.0, Sommatoria_Xi_due=0.0;
      double  q, m;
      double Pip_differenza;
      double regressionLine;
      //================================
      // Calcolo della retta di regressione
      for (int x=0; x<Period_regression; x++)
        {
         X_media += x;
         if (applied_price==0)
           {
            Y_media += iClose(NULL,timeframe,x+i);
            Sommatoria_XiYi += x*iClose(NULL,timeframe,x+i);
           }
         if (applied_price==1)
           {
            Y_media += iOpen(NULL,timeframe,x+i);
            Sommatoria_XiYi += x*iOpen(NULL,timeframe,x+i);
           }
         Sommatoria_Xi_due += x*x;
        }
      X_media = X_media/Period_regression;
      Y_media = Y_media/Period_regression;
   

   //      Sommatoria(Yi*Xi) - n*Xmedia*Ymedia
   // m = -------------------------------------       q = Ymedia - m*Xmedia
   //         Sommatoria(Xi^2) - n*Xmedia
      if (Sommatoria_Xi_due - Period_regression*X_media*X_media == 0)    m = 0;
      else  m = (Sommatoria_XiYi - Period_regression*X_media*Y_media)/(Sommatoria_Xi_due - Period_regression*X_media*X_media);
      q = Y_media - m*X_media;

      // Linear regression line in buffer
      for(x=0;x<Period_regression;x++)
        {
         regression_line[i+x]=m*x+q;
        }

     }

   string commentoSulGrafico1 = "retta di regressione calcolata su " + Period_regression + " barre al timeframe="+timeframe;
   if (timeframe==0)
   commentoSulGrafico1 = "retta di regressione calcolata su " + Period_regression + " barre al timeframe corrente";
   print_obj("commentoSulGrafico1", commentoSulGrafico1, 0);
   

   string commentoSulGrafico2 = "pendenza = ("+DoubleToStr(regression_line[0],Digits+1) + "-" + DoubleToStr(regression_line[Period_regression-1],Digits+1) + ") = " + DoubleToStr(MathAbs(regression_line[0]-regression_line[Period_regression-1])/(Point*MathPow(10, Digits%2)),Digits-1)+ "   MAXpipDiff="+DoubleToStr(MAXpipDifferenza,1);
   print_obj("commentoSulGrafico2", commentoSulGrafico2, 15);


   string hh1,mm1,hh0,mm0;
   
   if (TimeHour(iTime(NULL,timeframe,Period_regression-1))<10)     hh1="0"+TimeHour(iTime(NULL,timeframe,Period_regression-1));
   else                                            hh1=TimeHour(iTime(NULL,timeframe,Period_regression-1));
   if (TimeMinute(iTime(NULL,timeframe,Period_regression-1))<10)   mm1="0"+TimeMinute(iTime(NULL,timeframe,Period_regression-1));
   else                                            mm1=TimeMinute(iTime(NULL,timeframe,Period_regression-1));

   if (TimeHour(Time[0])<10)     hh0="0"+TimeHour(Time[0]);
   else                          hh0=TimeHour(Time[0]);
   if (TimeMinute(Time[0])<10)   mm0="0"+TimeMinute(Time[0]);
   else                          mm0=TimeMinute(Time[0]);

   string commentoSulGrafico3 = "time1="+hh1+":"+mm1+" r["+(Period_regression-1)+"]="+DoubleToStr(regression_line[Period_regression-1],Digits)+"   time0="+hh0+":"+mm0+" r[0]="+DoubleToStr(regression_line[0],Digits);
   print_obj("commentoSulGrafico3", commentoSulGrafico3, 30);


   regrName = "regrName " + TimeToStr(Time[0]);
   if (ObjectFind(regrName) < 0)
     {
      Create_regrLine(regrName, iTime(NULL,timeframe,Period_regression-1), regression_line[Period_regression-1], Time[0], regression_line[0]);
      // Create_regrLine(regrName, Time[20],High[20],Time[0],High[0]);
     }
   ObjectMove(regrName, 0, iTime(NULL,timeframe,Period_regression-1), regression_line[Period_regression-1]);
   ObjectMove(regrName, 1, Time[0], regression_line[0]);
   if (MathAbs(regression_line[0]-regression_line[Period_regression-1])/(Point*MathPow(10, Digits%2))>MAXpipDifferenza)
     {
      ObjectSet(   regrName, OBJPROP_COLOR, Red);
      //Alert("sono qui, i=",i,"   pip differenza=",DoubleToStr(MathAbs(regression_line[0]-regression_line[Period_regression-1])/(Point*MathPow(10, Digits%2)),Digits-1)," > ",MAXpipDifferenza,"=MAXpipDifferenza");
     }
   if (MathAbs(regression_line[0]-regression_line[Period_regression-1])/(Point*MathPow(10, Digits%2))<=MAXpipDifferenza)
     {
      ObjectSet(   regrName, OBJPROP_COLOR, Green);
      //Alert("sono qui, i=",i,"   pip differenza=",DoubleToStr(MathAbs(regression_line[0]-regression_line[Period_regression-1])/(Point*MathPow(10, Digits%2)),Digits-1)," <= ",MAXpipDifferenza,"=MAXpipDifferenza");
     }
   WindowRedraw(); // vengono ridisegnati forzatamente gli oggetti quando le sueproprietà vengono modificate

// int Create_regrLine(string regrName, double time1, double price1, double time0, double price0)


   //string commentoSulGrafico4 = "timeframe="+timeframe;
   //print_obj("commentoSulGrafico4", commentoSulGrafico3, 45);

   



   return(0);
  }

  

// Nell'equazione di una retta   y = mx + q   applicata al grafico dei cross valutari: 
// --> q (intercetta della retta sull'asse delle ordinate y) ha un ordine di grandezza pari al prezzo, ad esempio q=1,49  
// --> m (il coefficiente angolare o pendenza della retta) è estremamente piccolo, ad esempio m=0,0001
//
// Per la retta di regressione   y = mx + q   calcolata su n punti (Xi,Yi) valgono le seguenti formule
//
//      Sommatoria(Yi*Xi) - n*Xmedia*Ymedia
// m = -------------------------------------       q = Ymedia - m*Xmedia
//         Sommatoria(Xi^2) - n*Xmedia
//








//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione print() stampa un Text Label che rimane fissa su una porzione di schermo e NON si muove allo scorrere delle barre
// La Text Label necessita di una sola coordinata (x,y)
//+-------------------------------------------------------------------------------------------------------------------------------------+
int print_obj(string textLabel, string text, int shift, bool flashing = false)
{
   if (ObjectFind( textLabel) < 0)
   {
      ObjectCreate(textLabel, OBJ_LABEL,         0, 0, 0);
      ObjectSet(   textLabel, OBJPROP_COLOR,     DarkViolet);  // Il testo ha colore violetto
      // ObjectSet(   "Check text", OBJPROP_BACK,      false);    // Per le Text Label non serve
      ObjectSet(   textLabel, OBJPROP_CORNER,    0);     // 0 = angolo in alto a sinistra;   1 = in alto a destra;   2 in basso a sinistra;   3 = in basso a destra
      ObjectSet(   textLabel, OBJPROP_XDISTANCE, 200);   // 300 pixel dall'angolo
      ObjectSet(   textLabel, OBJPROP_YDISTANCE, 30+shift);    //  30 pixel dall'angolo + shift pixel
   }
   // ObjectSetText(  "Check text", TimeToStr(iTime(NULL, PERIOD_M1, 0), TIME_MINUTES) + " " + text, 10, "Tahoma");  // Stampa l'ora ed il minuto segito dal text
   ObjectSetText(  textLabel, text, 10, "Tahoma");  // Stampa l'ora ed il minuto segito dal text

   // flashing effect: ad ogni tick se il colore della Label è violetto, modificala in rosso e viceversa. 
   // Se invece l'effetto non è abilitato, cioè flashing=false, il colore della label è violetto
   if      (flashing && ObjectGet(textLabel, OBJPROP_COLOR) == DarkViolet) ObjectSet(textLabel, OBJPROP_COLOR, Red);
   else if (flashing && ObjectGet(textLabel, OBJPROP_COLOR) == Red)        ObjectSet(textLabel, OBJPROP_COLOR, DarkViolet);
   else                                                                    ObjectSet(textLabel, OBJPROP_COLOR, DarkViolet);

   // for debugging porpouses uncomment the print
   // to log journal and mt4 file
   // Print(text);

   return(0);
}
//+-------------------------------------------------------------------------------------------------------------------------------------+


int Create_regrLine(string regrName, datetime time1, double price1, datetime time0, double price0)
  {
   ObjectCreate(regrName,OBJ_TREND,0,time1,price1,time0,price0);
   ObjectSet(   regrName, OBJPROP_RAY, false);
   ObjectSet(   regrName, OBJPROP_WIDTH, 2);
   ObjectSet(   regrName, OBJPROP_COLOR, Green);
   return;
  }

//+-------------------------------------------------------------------------------------------------------------------------------------+
int PERIOD_timeframe(int minuti)
  {
   int timeframe;
   switch(minuti)
     {
      case 1:
         timeframe=PERIOD_M1;
         break;
      case 5:
         timeframe=PERIOD_M5;
         break;
      case 15:
         timeframe=PERIOD_M15;
         break;
      case 30:
         timeframe=PERIOD_M30;
         break;
      case 60:
         timeframe=PERIOD_H1;
         break;
      case 240:
         timeframe=PERIOD_H4;
         break;
      case 1440:
         timeframe=PERIOD_D1;
         break;
      //case 0:
      //   timeframe=0;
      //   break;
      default:
         timeframe=0;
         break;
     }
   return(timeframe);
  }



//-----------------------------------------------------------------------
bool New_Bar()    // funzione che individua l'avvio di una nuova barra
  {
   static datetime New_Time=0;   // New_Time viene inizializzata al tempo 0 solo la prima volta, essendo una variabile statica ai successivi tick mantiene il valore 
                                 //  che gli viene assegnato nel corso del tempo dalla funzione New_Bar(), cioè la data di avvio della ultima barra.
   if (New_Time!=Time[0])        // Se la barra corrente ha diversa data di avvio memorizzata da New_Time, è stata individuata una nuova barra
     {
      New_Time=Time[0]; // Viene memorizzata la data di avvio della nuova barra
      return(true);     // C'è una nuova barra
     }
   else return(false);  // La barra corrente ha la stessa data di avvio memorizzata da New_Time 
   }
//--------------------------------------------------------------------


