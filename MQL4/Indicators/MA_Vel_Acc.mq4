//+------------------------------------------------------------------+
//                                                      MA_Vel_Acc.mq4 
//                                                                  
// L'indicatore misura la velocità e accellerazione di una media mobile.
// La VELOCITA', che è la variazione di spazio in funzione nell'unità di tempo (distanza percorsa/tempo), 
// è misurata come la variazione di pip tra due punti della media mobile, diviso il numero di barre che intercorrono tra i due punti.
// L'ACCELERAZIONE, che è la variazione di velocità positiva o negativa nell'unità di tempo, 
// è misurata come la variazione della velocità tra due punti della media mobile, diviso il numero di barre che intercorrono tra i due punti.
// Viene imposta una soglia di minima velocità della media mobile al di sotto della quale si ritiene che il trend sia in laterale.
// Viene imposta una soglia minima di accelerazione della media mobile perché si consideri che il mercato stia dimostrando una forza di accelerazione in grado di far partire un trend.

// L'indicatore informa della forza di un trend, con un commento in alto nella finestra del grafico della forza del trend, in funzione della velocità e accelerazione.

// Le variabili 'PrevMAShift' a 'CurMAShift' sono gli indici delle barre che individuano i due punti della media mobile su cui viene individuato il segmento di retta sul quale viene calcolato l'angolo:
// Normalmente CurMAShift=0 cioè è la barra corrente, ma può essere posta uguale a qualsiasiindice di barra, purché sia sempre PrevMAShift > CurMAShift, 
// altrimenti compare un messaggio di errore e viene per default posto PrevMAShift=1 e CurMAShift=0.
// Il periodo della media mobile è MAPeriod: MA period.
//+------------------------------------------------------------------+

#property  copyright "Umberto Sorace Maresca, 2011"

//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 7
#property  indicator_color1  LimeGreen
#property  indicator_color2  FireBrick
#property  indicator_color3  Khaki
#property  indicator_color4  DodgerBlue
#property  indicator_color5  Purple
#property  indicator_color6  LimeGreen
#property  indicator_color7  FireBrick
#property  indicator_width1 2
#property  indicator_width2 2
#property  indicator_width3 2
#property  indicator_width4 2
#property  indicator_width5 1



//---- indicator parameters
extern int MAPeriod = 20;  // numero di periodi su cui viene calcolata la media mobile

extern string  m = "tipi di media mobile: 0=SMA, 1=EMA";
extern int MA_Type = 1; //0=SMA, 1=EMA, 2=SMMA, 3=LWMA
// extern string  m0 = " 0 = SMA";
// extern string  m1 = " 1 = EMA";
// extern string  m2 = " 2 = SMMA";
// extern string  m3 = " 3 = LWMA";

extern string  p = "prezzo applicazione media: 0=close";
extern int MA_AppliedPrice = 0;  //0=close
// extern string  p0 = " 0 = close";
// extern string  p1 = " 1 = open";
// extern string  p2 = " 2 = high";
// extern string  p3 = " 3 = low";
// extern string  p4 = " 4 = median(high+low)/2";
// extern string  p5 = " 5 = typical(high+low+close)/3";
// extern string  p6 = " 6 = weighted(high+low+close+close)/4";


extern double sogliaMinima_velocita=2;       // misura in pip della minima velocità di soglia, cioè della minima variazione di pip, che si deve avere su due punti della media mobile
                                             // perché si consideri il mercato corrente in trend e non in laterale.
extern double sogliaMinima_accelerazione=3;  // misura in pip della minima variazione di velocità che la media mobile deve avere su due punti della media mobile
                                             // perché si consideri che il mercato sta dimnostrando una forza di accelerazione in grado di far partire un trend
extern int PrevMAShift=5;
extern int CurMAShift=0;

int MA_Mode;         // 
string strMAType;    // variabile per stampare l'etichetta dell'indicatore

//---- indicator buffers
double UpBuffer[];               // variazione positiva di pip tra due punti della media mobile 
double DownBuffer[];             // variazione negativa di pip tra due punti della media mobile 
double ZeroBuffer[];             // variazione positiva o negativa di pip tra due punti della media mobile, quando è minore della soglia 'sogliaMinima_velocita'.
double VelocitaBuffer[];         // Velocità della media mobile: variazione di pip nell'unità di tempo
double AccelerazioneBuffer[];    // Accelerazione della media mobile: variazione di pip nell'unità di tempo
double AccelerUpSoglia[];        // Pallino sulla linea dell'accelerazione se è maggiore di sogliaMinima_accelerazione
double AccelerDownSoglia[];      // Pallino sulla linea dell'accelerazione se è minore di -sogliaMinima_accelerazione

extern bool abilitaCommenti = true;   // se =false non viene stampato un commento in alto a sinistra sul grafico principale

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorBuffers(7);

//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(0,UpBuffer);

   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(1,DownBuffer);

   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(2,ZeroBuffer);

   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID);
   SetIndexBuffer(3,VelocitaBuffer);

   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID);
   SetIndexBuffer(4,AccelerazioneBuffer);

   SetIndexStyle(5, DRAW_ARROW);
   SetIndexArrow(5, 108);          // 108 è l'indice del pallino nel font Wingdings.
   SetIndexBuffer(5,AccelerUpSoglia);

   SetIndexStyle(6, DRAW_ARROW);
   SetIndexArrow(6, 108);
   SetIndexBuffer(6,AccelerDownSoglia);

   SetIndexDrawBegin(0,MAPeriod);
   SetIndexDrawBegin(1,MAPeriod);
   SetIndexDrawBegin(2,MAPeriod);
   SetIndexDrawBegin(3,MAPeriod);
   SetIndexDrawBegin(4,MAPeriod+PrevMAShift);
   SetIndexDrawBegin(5,MAPeriod+PrevMAShift);
   SetIndexDrawBegin(6,MAPeriod+PrevMAShift);


   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);

   switch (MA_Type)
     {
      case 1: strMAType="EMA"; MA_Mode=MODE_EMA; break;
      case 2: strMAType="SMMA"; MA_Mode=MODE_SMMA; break;
      case 3: strMAType="LWMA"; MA_Mode=MODE_LWMA; break;
      default: strMAType="SMA"; MA_Mode=MODE_SMA; break;
     }
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MA_Vel_Acc_" + strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+")");
   SetIndexLabel(0,"pip al rialzo");
   SetIndexLabel(1,"pip al ribasso");
   SetIndexLabel(2,"pip sotto soglia");
   SetIndexLabel(3,"velocità MM");
   SetIndexLabel(4,"accelerazione MM");
   SetIndexLabel(5,"AccelerUpSoglia");
   SetIndexLabel(6,"AccelerDownSoglia");

//---- initialization done
   return(0);
}



//+------------------------------------------------------------------+
//| The angle for MA                                                |
//+------------------------------------------------------------------+
int start()
{
   double Poin;
   double MACur, MAPrev;
   int i;
   int nCountedBars;
   int pos;
   string text;

   if(Bars<=MAPeriod+1) 
     {
      Print("Errore: il numero di barre nel grafico sono inferiori al periodo della media mobile");
      return(0);
     }

   if(CurMAShift >= PrevMAShift)
   {
      Alert("Errore: CurMAShift deve essere minore di PrevMAShift");
      PrevMAShift = 1;
      CurMAShift = 0;      
   }

//--- Per piattaforme con 3 e 5 cifre decimali, come il broker Alpari
   if(Digits == 3 || Digits == 5)   Poin = Point*10;
   else Poin = Point;


         
   nCountedBars = IndicatorCounted();
//---- check for possible errors
   if(nCountedBars<0) 
      return(-1);
//---- last counted bar will be recounted


   if(nCountedBars<1)   // al primo start() le MAPeriod barre più antiche sono impostate a zero
     {
      for(pos=1; pos<MAPeriod; pos++)
        {
         UpBuffer[Bars-pos] = 0.0;
         DownBuffer[Bars-pos] = 0.0;
         VelocitaBuffer[Bars-pos] = 0.0;
         AccelerazioneBuffer[Bars-pos]=0.0;
        }
     }
   i = Bars-MAPeriod-1;
   if(nCountedBars>=MAPeriod) i=Bars-nCountedBars-1;

//---- main loop
   while(i>=0)
     {
      MACur=iMA(NULL,0,MAPeriod,0,MA_Mode,MA_AppliedPrice,i+CurMAShift);
      MAPrev=iMA(NULL,0,MAPeriod,0,MA_Mode,MA_AppliedPrice,i+PrevMAShift);

      VelocitaBuffer[i] = (MACur-MAPrev)/Poin;

      AccelerazioneBuffer[i] = VelocitaBuffer[i+CurMAShift] - VelocitaBuffer[i+PrevMAShift];

      if ( AccelerazioneBuffer[i]>sogliaMinima_accelerazione )    AccelerUpSoglia[i]=AccelerazioneBuffer[i];
      if ( AccelerazioneBuffer[i]<-sogliaMinima_accelerazione )   AccelerDownSoglia[i]=AccelerazioneBuffer[i];

      UpBuffer[i] = 0.0;
      DownBuffer[i] = 0.0;
      ZeroBuffer[i] = 0.0;

      //------------ trend al rialzo -----------------------+
      if ( VelocitaBuffer[i]>sogliaMinima_velocita && AccelerazioneBuffer[i]>0 && AccelerazioneBuffer[i]>sogliaMinima_accelerazione )
        {
         text = "trend crescente e forte   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         UpBuffer[i] = (MACur-MAPrev)/Poin;
        }
      else if ( VelocitaBuffer[i]>sogliaMinima_velocita && AccelerazioneBuffer[i]>0 && AccelerazioneBuffer[i]<=sogliaMinima_accelerazione )
        {
         text = "trend crescente con poca forza   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+2)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],1)+"";
         UpBuffer[i] = (MACur-MAPrev)/Poin;
        }

      else if ( VelocitaBuffer[i]>sogliaMinima_velocita && AccelerazioneBuffer[i]<0 )
        {
         text = "trend crescente ma accellerazione negativa   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         UpBuffer[i] = (MACur-MAPrev)/Poin;
        }

      //------------ trend al ribasso -----------------------+
      else if ( VelocitaBuffer[i]<-sogliaMinima_velocita && AccelerazioneBuffer[i]<0 && AccelerazioneBuffer[i]<-sogliaMinima_accelerazione )
        {
         text = "trend decrescente e forte   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         DownBuffer[i] = (MACur-MAPrev)/Poin;
        }
      else if ( VelocitaBuffer[i]<-sogliaMinima_velocita && AccelerazioneBuffer[i]<0 && AccelerazioneBuffer[i]>=-sogliaMinima_accelerazione )
        {
         text = "trend decrescente con poca forza   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         DownBuffer[i] = (MACur-MAPrev)/Poin;
        }

      else if ( VelocitaBuffer[i]<-sogliaMinima_velocita && AccelerazioneBuffer[i]>0 )
        {
         text = "trend decrescente ma accellerazione positiva   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         DownBuffer[i] = (MACur-MAPrev)/Poin;
        }

      //------------ trend in laterale -----------------------+
      else if ( VelocitaBuffer[i]<=sogliaMinima_velocita && VelocitaBuffer[i]>=-sogliaMinima_velocita && AccelerazioneBuffer[i]>sogliaMinima_accelerazione )
        {
         text = "trend in laterale con un\'accelerazione per un trend al rialzo   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         ZeroBuffer[i] = (MACur-MAPrev)/Poin;
        }

      else if ( VelocitaBuffer[i]<=sogliaMinima_velocita && VelocitaBuffer[i]>=-sogliaMinima_velocita && AccelerazioneBuffer[i]<-sogliaMinima_accelerazione )
        {
         text = "trend in laterale con un\'accelerazione per un trend al ribasso   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         ZeroBuffer[i] = (MACur-MAPrev)/Poin;
        }

      else 
        {
         text = "trend in laterale   |   "+strMAType+"("+MAPeriod+", indici da "+PrevMAShift+" a "+CurMAShift+"): velocità = "+DoubleToStr(VelocitaBuffer[i],2)+" pip tra "+(PrevMAShift-CurMAShift+1)+" barre consecutive, è sotto la soglia (="+DoubleToStr(sogliaMinima_velocita,2)+"), accelerazione = "+DoubleToStr(AccelerazioneBuffer[i],2)+"";
         ZeroBuffer[i] = (MACur-MAPrev)/Poin;
        }
         text = text + "\nsogliaMinima_velocita="+DoubleToStr(sogliaMinima_velocita,1)+", sogliaMinima_accelerazione="+DoubleToStr(sogliaMinima_accelerazione,1);
         if (abilitaCommenti) Comment(text);


      i--;
     }

   return(0);
  }
//+------------------------------------------------------------------+

