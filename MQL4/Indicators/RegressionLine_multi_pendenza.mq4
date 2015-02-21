//+------------------------------------------------------------------+
//|                                RegressionLine_multi_pendenza.mq4 |
//|                                                       Umberforex |
//|                                              http://www.mql4.com |
//////////////////////////////////////////////////////////////////////
#property copyright "Copyright © 2011 Umberforex"
#property link      "http://www.facebook.com/umberto.soracemaresca"
#include <WinUser32.mqh>               // Needed to MessageBox

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Orange



extern bool abilita_regressione_R1=true;  // Se false, la retta di regressione R1 non viene visualizzata
extern int timeframeInMinuti_R1=60;       // Timeframe in minuti su cui viene calcolata la retta di regressione R1
extern int PeriodRegression_R1 = 3;       // Numero di barre su cui calcolare la retta di regressione R1
string timeframe_R1;                      // Contiene la stringa corrispondente a timeframeInMinuti_R1, quindi M1, M5, M15, M30, H1, H4, Daily, Weekly o Monthly.
extern double pipLimite_R1 = 8;           // Pip di pendenza della retta di regressione R1 per il cambio di colore


extern bool abilita_regressione_R2=true;
extern int timeframeInMinuti_R2=30;
extern int PeriodRegression_R2 = 5;
string timeframe_R2;
extern double pipLimite_R2 = 8;


extern bool abilita_regressione_R3=true;
extern int timeframeInMinuti_R3=15;
extern int PeriodRegression_R3 = 8;
string timeframe_R3;
extern double pipLimite_R3 = 8;

extern bool abilita_regressione_R4=false;
extern int timeframeInMinuti_R4=5;
extern int PeriodRegression_R4 = 30;
string timeframe_R4;
extern double pipLimite_R4 = 8;


extern string applied_price_LEGENDA="0=Close price; 1 = Open price";
extern int applied_price=0;                  // 0 = Close price; 1 = Open price


double regression_line[];           // array dei valori della retta di regressione 

string regrName_R1="", regrName_R2="", regrName_R3="", regrName_R4="";

datetime avvio;

//////////////////////////////////////////////////////////////////////
int init()
{
   IndicatorBuffers(1);

   SetIndexBuffer(0,regression_line);              //Assegno l'array al buffer
   // SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);    // Line style
   SetIndexStyle(0,DRAW_NONE,STYLE_SOLID,1);
   SetIndexDrawBegin(0,100);


   IndicatorDigits(Digits);

   avvio=true;


   if ( TimeframeCorretto(timeframeInMinuti_R1)==false )
     {
      Alert("ATTENZIONE: timeframeInMinuti_R1=",timeframeInMinuti_R1," non corrisponde ai minuti di una barra di Mt4\n Si possono inserire soltanto i valori 1 =M1, 5 =M5, 15 =M15, 30 =M30, 60 =H1\n240 =H4, 1440 =Daily, 10080 =Weekly, 43200 =Monthly");
      timeframeInMinuti_R1=60;
     }
   if ( TimeframeCorretto(timeframeInMinuti_R2)==false )
     {
      Alert("ATTENZIONE: timeframeInMinuti_R2=",timeframeInMinuti_R2," non corrisponde ai minuti di una barra di Mt4\n Si possono inserire soltanto i valori 1 =M1, 5 =M5, 15 =M15, 30 =M30, 60 =H1\n240 =H4, 1440 =Daily, 10080 =Weekly, 43200 =Monthly");
      timeframeInMinuti_R2=30;
     }
   if ( TimeframeCorretto(timeframeInMinuti_R3)==false )
     {
      Alert("ATTENZIONE: timeframeInMinuti_R3=",timeframeInMinuti_R3," non corrisponde ai minuti di una barra di Mt4\n Si possono inserire soltanto i valori 1 =M1, 5 =M5, 15 =M15, 30 =M30, 60 =H1\n240 =H4, 1440 =Daily, 10080 =Weekly, 43200 =Monthly");
      timeframeInMinuti_R3=15;
     }
   if ( TimeframeCorretto(timeframeInMinuti_R4)==false )
     {
      Alert("ATTENZIONE: timeframeInMinuti_R4=",timeframeInMinuti_R4," non corrisponde ai minuti di una barra di Mt4\n Si possono inserire soltanto i valori 1 =M1, 5 =M5, 15 =M15, 30 =M30, 60 =H1\n240 =H4, 1440 =Daily, 10080 =Weekly, 43200 =Monthly");
      timeframeInMinuti_R4=5;
     }

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
   if (New_Bar()==true && avvio==false)
     {
      //Alert("ObjectFind(regrName_R1)=",ObjectFind(regrName_R1),",  ",   ObjectFind(regrName_R2),",  ",   ObjectFind(regrName_R3),",  ",   ObjectFind(regrName_R4));
      if (regrName_R1 !="")
        {
         if (ObjectFind(regrName_R1) >=0)   ObjectDelete(regrName_R1);
        }
      if (regrName_R2 !="")
        {
         if (ObjectFind(regrName_R2) >=0)   ObjectDelete(regrName_R2);
        }
      if (regrName_R3 !="")
        {
         if (ObjectFind(regrName_R3) >=0)   ObjectDelete(regrName_R3);
        }
      if (regrName_R4 !="")
        {
         if (ObjectFind(regrName_R4) >=0)   ObjectDelete(regrName_R4);
        }

      //Alert("ObjectFind(regrName_R1)=",ObjectFind(regrName_R1),",  ",   ObjectFind(regrName_R2),",  ",   ObjectFind(regrName_R3),",  ",   ObjectFind(regrName_R4));
     }
   if (avvio==true)  avvio=false;

   string commentoLabel0 = "Retta di Regressione";
   print_Label("Label0", commentoLabel0, 61);
   ObjectSet("Label0", OBJPROP_CORNER,    2);     // 0 = angolo in alto a sinistra;   1 = in alto a destra;   2 in basso a sinistra;   3 = in basso a destra
   ObjectSet("Label0", OBJPROP_XDISTANCE, 100);   // 300 pixel dall'angolo
   ObjectSet("Label0", OBJPROP_YDISTANCE, 61);    //  30 pixel dall'angolo + shift pixel
   ObjectSetText("Label0", commentoLabel0, 14, "Tahoma", MidnightBlue);  // Stampa il text



   // ------------------------------
   // retta di regressione R1
   // ------------------------------
   if (abilita_regressione_R1==true)
     {
      //void regression_line(int timeframe, int PeriodRegression)
      regression_line(timeframeInMinuti_R1,PeriodRegression_R1);

      regrName_R1 = "regrName_R1 " + TimeToStr(Time[0]);

      //void gestisci_RdR_Text(string Text, string Label, int shiftLabel, string regrName, int timeframeInMinuti, int PeriodRegression, double pipLimite)
      gestisci_RdR_Text("Text_R1", "Label_R1", 46, regrName_R1, timeframeInMinuti_R1, PeriodRegression_R1, pipLimite_R1, FireBrick, Green);
     }


   // ------------------------------
   // retta di regressione R2
   // ------------------------------
   if (abilita_regressione_R2==true)
     {
      regression_line(timeframeInMinuti_R2,PeriodRegression_R2);
      regrName_R2 = "regrName_R2 " + TimeToStr(Time[0]);
      gestisci_RdR_Text("Text_R2", "Label_R2", 31, regrName_R2, timeframeInMinuti_R2, PeriodRegression_R2, pipLimite_R2, Red, Lime);
     }


   // ------------------------------
   // retta di regressione R3
   // ------------------------------
   if (abilita_regressione_R3==true)
     {
      regression_line(timeframeInMinuti_R3,PeriodRegression_R3);
      regrName_R3 = "regrName_R3 " + TimeToStr(Time[0]);
      gestisci_RdR_Text("Text_R3", "Label_R3", 16, regrName_R3, timeframeInMinuti_R3, PeriodRegression_R3, pipLimite_R3, HotPink, SpringGreen);
     }


   // ------------------------------
   // retta di regressione R4
   // ------------------------------
   if (abilita_regressione_R4==true)
     {
      regression_line(timeframeInMinuti_R4,PeriodRegression_R4);
      regrName_R4 = "regrName_R4 " + TimeToStr(Time[0]);
      gestisci_RdR_Text("Text_R4", "Label_R4", 1, regrName_R4, timeframeInMinuti_R4, PeriodRegression_R4, pipLimite_R4, Chocolate, OliveDrab);
     }


/*
   int timeframe = timeframeInMinuti_R1;
   string hh1,mm1,hh0,mm0;
   
   if (TimeHour(iTime(NULL,timeframe,PeriodRegression_R1-1))<10)     hh1="0"+TimeHour(iTime(NULL,timeframe,PeriodRegression_R1-1));
   else                                            hh1=TimeHour(iTime(NULL,timeframe,PeriodRegression_R1-1));
   if (TimeMinute(iTime(NULL,timeframe,PeriodRegression_R1-1))<10)   mm1="0"+TimeMinute(iTime(NULL,timeframe,PeriodRegression_R1-1));
   else                                            mm1=TimeMinute(iTime(NULL,timeframe,PeriodRegression_R1-1));

   if (TimeHour(Time[0])<10)     hh0="0"+TimeHour(Time[0]);
   else                          hh0=TimeHour(Time[0]);
   if (TimeMinute(Time[0])<10)   mm0="0"+TimeMinute(Time[0]);
   else                          mm0=TimeMinute(Time[0]);

   string commento = "tf="+timeframe+" time1="+hh1+":"+mm1+" r["+(PeriodRegression_R1-1)+"]="+DoubleToStr(regression_line[PeriodRegression_R1-1],Digits+1)+"   time0="+hh0+":"+mm0+" r[0]="+DoubleToStr(regression_line[0],Digits+1);
   Comment(commento);
*/

   return(0);
  }



//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione regression_line() calcola i valori dell'array regression_line[]
//  che vengono usati per costrire l'oggetto retta di regressione
//+-------------------------------------------------------------------------------------------------------------------------------------+
void regression_line(int timeframe, int PeriodRegression)
  {
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
      for (int x=0; x<PeriodRegression; x++)
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
      X_media = X_media/PeriodRegression;
      Y_media = Y_media/PeriodRegression;

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

      if (Sommatoria_Xi_due - PeriodRegression*X_media*X_media == 0)    m = 0;
      else  m = (Sommatoria_XiYi - PeriodRegression*X_media*Y_media)/(Sommatoria_Xi_due - PeriodRegression*X_media*X_media);
      q = Y_media - m*X_media;

      // Linear regression line in buffer
      for(x=0;x<PeriodRegression;x++)
        {
         regression_line[i+x]=m*x+q;
        }

     }
  }
//+-------------------------------------------------------------------------------------------------------------------------------------+


//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione gestisci_RdR_Text() stampa la retta di regressione, del testo informativo all'estremo sinistro della retta e
//  un testo in basso nella finestra; inoltre gestisce i movimenti della retta allo scorrere dei tick
//+-------------------------------------------------------------------------------------------------------------------------------------+
void gestisci_RdR_Text(string Text, string Label, int shiftLabel, string regrName, int timeframeInMinuti, int PeriodRegression, double pipLimite, color coloreTrend, color coloreLaterale)
  {

   string commentoText = "tf="+PERIOD_timeframe(timeframeInMinuti);
   string commentoLabel = "RdR (" + PeriodRegression + " barre, tf="+PERIOD_timeframe(timeframeInMinuti)+")   pipPendenza=" + DoubleToStr(MathAbs(regression_line[0]-regression_line[PeriodRegression-1])/(Point*MathPow(10, Digits%2)),2)+ "   pipLimite="+DoubleToStr(pipLimite,1);
   // commentoText = "RdR (" + PeriodRegression + " barre, tf="+timeframe+")   pipPendenza=(" + DoubleToStr(regression_line[0],Digits) + "-" + DoubleToStr(regression_line[PeriodRegression-1],Digits) + " = " + DoubleToStr(MathAbs(regression_line[0]-regression_line[PeriodRegression-1])/(Point*MathPow(10, Digits%2)),Digits-1)+ "   pipLimite="+DoubleToStr(pipLimite,1);

   print_Text(Text, commentoText, iTime(NULL,timeframeInMinuti,PeriodRegression-1), regression_line[PeriodRegression-1]);

   print_Label(Label, commentoLabel, shiftLabel);

   // regrName = "regrName " + TimeToStr(Time[0]);
   if (regrName!="" && ObjectFind(regrName) < 0) Create_regrLine(regrName, iTime(NULL,timeframeInMinuti,PeriodRegression-1), regression_line[PeriodRegression-1], Time[0], regression_line[0]);
   ObjectMove(regrName, 0, iTime(NULL,timeframeInMinuti,PeriodRegression-1), regression_line[PeriodRegression-1]);
   ObjectMove(regrName, 1, Time[0], regression_line[0]);
   ObjectMove(Text, 0, iTime(NULL,timeframeInMinuti,PeriodRegression-1), regression_line[PeriodRegression-1]);
   ObjectMove(Text, 0, iTime(NULL,timeframeInMinuti,PeriodRegression-1), regression_line[PeriodRegression-1]);

   ObjectSet(Label, OBJPROP_CORNER,    2);     // 0 = angolo in alto a sinistra;   1 = in alto a destra;   2 in basso a sinistra;   3 = in basso a destra
   ObjectSet(Label, OBJPROP_XDISTANCE, 100);   // 300 pixel dall'angolo
   ObjectSet(Label, OBJPROP_YDISTANCE, shiftLabel);    //  30 pixel dall'angolo + shift pixel


   if (MathAbs(regression_line[0]-regression_line[PeriodRegression-1])/(Point*MathPow(10, Digits%2))>pipLimite)
     {
      ObjectSet(regrName, OBJPROP_COLOR, coloreTrend);
      ObjectSet(Text, OBJPROP_COLOR, coloreTrend);
      ObjectSet(Label, OBJPROP_COLOR, coloreTrend);
      //Alert("sono qui, i=",i,"   pip differenza=",DoubleToStr(MathAbs(regression_line[0]-regression_line[PeriodRegression-1])/(Point*MathPow(10, Digits%2)),Digits-1)," > ",pipLimite,"=pipLimite");
     }
   if (MathAbs(regression_line[0]-regression_line[PeriodRegression-1])/(Point*MathPow(10, Digits%2))<=pipLimite)
     {
      ObjectSet(regrName, OBJPROP_COLOR, coloreLaterale);
      ObjectSet(Text, OBJPROP_COLOR, coloreLaterale);
      ObjectSet(Label, OBJPROP_COLOR, coloreLaterale);
      //Alert("sono qui, i=",i,"   pip differenza=",DoubleToStr(MathAbs(regression_line[0]-regression_line[PeriodRegression-1])/(Point*MathPow(10, Digits%2)),Digits-1)," <= ",pipLimite,"=pipLimite");
     }
   WindowRedraw(); // vengono ridisegnati forzatamente gli oggetti quando le sueproprietà vengono modificate
  }




//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione print_Label() stampa una Label che rimane fissa su una porzione di schermo e NON si muove allo scorrere delle barre
// La Text Label necessita di una sola coordinata (x,y)
//+-------------------------------------------------------------------------------------------------------------------------------------+
int print_Label(string Label, string commentoLabel, int shift, bool flashing = false)
  {
   if (ObjectFind(Label) < 0)
     {
      ObjectCreate(Label, OBJ_LABEL,         0, 0, 0);
      ObjectSet(   Label, OBJPROP_COLOR,     DarkViolet);  // Il testo ha colore violetto
      // ObjectSet(   "Check text", OBJPROP_BACK,      false);    // Per le Text Label non serve
      ObjectSet(   Label, OBJPROP_CORNER,    2);     // 0 = angolo in alto a sinistra;   1 = in alto a destra;   2 in basso a sinistra;   3 = in basso a destra
      ObjectSet(   Label, OBJPROP_XDISTANCE, 100);   // 300 pixel dall'angolo
      ObjectSet(   Label, OBJPROP_YDISTANCE, shift);    //  30 pixel dall'angolo + shift pixel
     }
   // ObjectSetText(  "Check text", TimeToStr(iTime(NULL, PERIOD_M1, 0), TIME_MINUTES) + " " + commentoLabel, 10, "Tahoma");  // Stampa l'ora ed il minuto segito dal text
   ObjectSetText(  Label, commentoLabel, 10, "Tahoma");  // Stampa il text

   // flashing effect: ad ogni tick se il colore della Label è violetto, modificala in rosso e viceversa. 
   // Se invece l'effetto non è abilitato, cioè flashing=false, il colore della label è violetto
   if      (flashing && ObjectGet(Label, OBJPROP_COLOR) == DarkViolet) ObjectSet(Label, OBJPROP_COLOR, Red);
   else if (flashing && ObjectGet(Label, OBJPROP_COLOR) == Red)        ObjectSet(Label, OBJPROP_COLOR, DarkViolet);
   else                                                                ObjectSet(Label, OBJPROP_COLOR, DarkViolet);

   // for debugging porpouses uncomment the print
   // to log journal and mt4 file
   // Print(commentoLabel);

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
string PERIOD_timeframe(int minuti)
  {
   string timeframe;
   switch(minuti)
     {
      case 1:
         timeframe="M1";
         break;
      case 5:
         timeframe="M5";
         break;
      case 15:
         timeframe="M15";
         break;
      case 30:
         timeframe="M30";
         break;
      case 60:
         timeframe="H1";
         break;
      case 240:
         timeframe="H4";
         break;
      case 1440:
         timeframe="Daily";
         break;
      case 10080:
         timeframe="Weekly";
         break;
      case 43200:
         timeframe="Monthly";
         break;
      default:
         timeframe="errore";
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



//+-------------------------------------------------------------------------------------------------------------------------------------+
// La funzione print_Text() stampa un Text che si muove allo scorrere delle barre
// La Text necessita di una sola coordinata (x,y)
//+-------------------------------------------------------------------------------------------------------------------------------------+
int print_Text(string Text, string commentoText, datetime time1, double price1)
{
   if (ObjectFind(Text) < 0)
   {
      ObjectCreate(Text, OBJ_TEXT, 0, time1, price1);
      ObjectSet(   Text, OBJPROP_COLOR,     DarkViolet);  // Il testo ha colore violetto
   }
   // ObjectSetText(  "Check text", TimeToStr(iTime(NULL, PERIOD_M1, 0), TIME_MINUTES) + " " + text, 10, "Tahoma");  // Stampa l'ora ed il minuto segito dal text
   ObjectSetText(  Text, commentoText, 10, "Tahoma");  // Stampa il text
}



bool TimeframeCorretto(int timeframeInMinuti)
  {
   if (timeframeInMinuti!=1 && timeframeInMinuti!=5 && timeframeInMinuti!=15 && timeframeInMinuti!=30 && timeframeInMinuti!=60
         && timeframeInMinuti!=240 && timeframeInMinuti!=1440 && timeframeInMinuti!=10080 && timeframeInMinuti!=43200)
         return(false);
   else  return(true);
  }

