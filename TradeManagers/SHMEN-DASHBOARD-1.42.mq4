//+------------------------------------------------------------------+
//|                                              shmen-dashboard.mq4 |
//|                                                            Bendo |
//|                                             "Creative Solutions" |
//|                                                                  |
//|PLEASE SEND MONEYBOOKERS/SKRILL                                   |
//|DONATIONS AND MT4 CUSTOM PROGRAMMING                              |
//|INQUIRIES TO bendx77@gmail.com                                    |
//+------------------------------------------------------------------+

         //Alert ("-----------------------------------------");
         //Alert("Change the name of the horizontal line to:");
         //Alert ("hcb (if there is a high on close below)");      
         //Alert ("lca (if there is a low on close above)");
         //Alert ("ocb (if price opens and closes below)");
         //Alert ("oca (if price opens and closes above)");
         //Alert ("cb (if price closes below)" );
         //Alert ("ca (if price closes above)");
         //Alert ("b (if price goes below)");
         //Alert("a (if price goes above)");
         //Alert("-------------------------------------------");

#property copyright "bendx77@gmail.com"
#property link      ""
// Always appreciate donations that are sent via SKRILL to: bendx77@gmail.com

#include <stdlib.mqh>
#include <stderror.mqh>


//---- input parameters

//extern int       Targets=2;
extern int       Max_Slip=20;
//extern int       Units_Per_Trade=1;


extern double    Standard_Lot_Size=0.1; //not used

//extern bool      Market_Orders=True;
//extern bool      Resting_Orders=True;
extern bool      Action_Line=false;
extern int       Lot_Precision=1; // 1 for minilots, 2 for microlots, 3 for nano, 0 for standard
extern double     Commission=10.00; // To add in to spread for risk calculations
extern int      Risk_Management=0; // 0 = Standard LotSize is Actual Lotsize....1 = Standard LotSize is a portion of equity
extern string Com = "J"; //comments for orders.
extern int   Default_Stop;  //not used
extern int   Default_Take1; // not used
//extern int   Default_Take2;
//extern int   Default_Take3;
//extern int   Default_Take4;

extern int  Y_Adjust=20; // adjust this to change the verticle padding
extern double  X_Adjust=2.9; // adjust this to change the horizontal padding
extern double   Bottom_Adjust = 5; // adjust this to shift the controls up or down.
//extern color   Arrow_Color;
extern double  RR_Center = 6; // adjust this to center the Risk:Reward Text Object
extern double  ST_Center = 6; // adjust this to center the Selected Trade text
extern double  LS0_Center = 6; // adjust this to center Lots Text
extern double  LS1_Center = 8; // adjust this to center Lots Text in % risk mode
extern color Text_Color=White;

extern string Font = "Times New Roman"; 
extern string COMMENT_TryTheseFonts = "Try these fonts: Arial ,  Comic Sans MS , Courier ,  Modern , Roman , Georgia , Verdana" ;

extern int Font_Size=10; 
//extern int Icon_Size=1;
extern int SleepTimer=500; //adjust for cycle timer.
extern double   EAdjC=0;   //adjusted equity. If you want to manualy include more equity than what's in the trading account (for risk calc).
extern bool ContAlm=false;
extern double atrr=0.3;// percent of atr risk
extern double afraction=5;
extern string EAdjPair="USDCAD"; //currency pair used to calculate the rate for the adjusted equity. Leave it blank to be the same as the home currency;
extern bool EAdjdiv=true; //divide by exchange rate or false for multiply by rate;
// the default is a CAD external account.


extern bool show_alls=false;
extern bool show_adjusted=false;
extern bool show_leverage_and_ATR=true;
extern bool show_tickvalue_and_margin=false;
extern bool show_spread_and_range_ratio=true;
double EAdj;
double   Lot_Size;
double   Stop_Loss;
double   Entry;
double   TStop;
double   AlertP;
double   TTake1;
double   TTake2;
double   TTake3;
double   TTake4;
double   Target1;
double   Target2;
double   Target3;
double   Target4;
double   Resting_Target; 
double   Risk_Reward;
bool ReOrder = False;
int   acount;
double Atrigger,Btrigger,CAtrigger,CBtrigger,OCAtrigger,OCBtrigger,LCAtrigger,HCBtrigger;


extern int   MagicNumber = 77777;
int   Select = -1, ASymbol, OResult;
int countx;
double avgspread;
double   Pips_Deposit;
double Bottom_Fly;
bool  Action_Taken=true,Shifted=false, NoTradeFound = true;
string XSymbol,ReOrderType,Astr="xxx",Bstr="xxx",CAstr="xxx",CBstr="xxx",OCAstr="xxx",OCBstr="xxx",LCAstr="xxx",HCBstr="xxx";
string Comment_Text;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----

XSymbol = Symbol();
Select = -1;


// Add any missing symbols from your trading station
if (XSymbol == "USDJPY") ASymbol = 1;
if (XSymbol == "USDCAD") ASymbol = 2;
if (XSymbol == "USDCHF") ASymbol = 3;
if (XSymbol == "GBPUSD") ASymbol = 4;
if (XSymbol == "AUDUSD") ASymbol = 5;
if (XSymbol == "GBPJPY") ASymbol = 6;
if (XSymbol == "EURJPY") ASymbol = 7;
if (XSymbol == "USDCAD") ASymbol = 8;
if (XSymbol == "USDCHF") ASymbol = 9;
if (XSymbol == "XAGUSD") ASymbol = 10;
if (XSymbol == "XAUUSD") ASymbol = 11;
if (XSymbol == "NZDUSD") ASymbol = 12;
if (XSymbol == "AUDNZD") ASymbol = 13;
if (XSymbol == "EURGBP") ASymbol = 14;
if (XSymbol == "EURCHF") ASymbol = 15;
if (XSymbol == "CHFJPY") ASymbol = 16;
if (XSymbol == "GBPCHF") ASymbol = 17;
if (XSymbol == "AUDCAD") ASymbol = 18;
if (XSymbol == "EURUSD") ASymbol = 19;
if (XSymbol == "USDMXN") ASymbol = 20;
if (XSymbol == "USDTRY") ASymbol = 21;
if (XSymbol == "CADJPY") ASymbol = 22;
if (XSymbol == "AUDJPY") ASymbol = 23;
if (XSymbol == "EURCAD") ASymbol = 24;
if (XSymbol == "EURAUD") ASymbol = 25;


Pips_Deposit = AccountEquity( ) ;
//Alert("Pips Value"+Pips_Deposit);

Risk_Management= GlobalVariableGet("G_Risk_Management");
Standard_Lot_Size= GlobalVariableGet("G_Lot_Size");
      Update_Board();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   GlobalVariableSet("G_Lot_Size", Standard_Lot_Size);
   GlobalVariableSet("G_Risk_Management", Risk_Management);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   while (!IsStopped())
   {
      
      RefreshRates();
      
      Check_For_Inputs();
      Update_Board();
      Recalculate_Risk(); // and check for alerts
      WindowRedraw();
      Sleep(SleepTimer);
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void Update_Board()
{
   //Print("a");
   double spread = MarketInfo(Symbol(),MODE_SPREAD);
   double Top = WindowPriceMax();
   double Price_Unit = (Top-WindowPriceMin())/ Y_Adjust;
   double Bottom = WindowPriceMin()+ ((Bottom_Adjust+Bottom_Fly)*Price_Unit);
   //Print("b");
   datetime Time_Unit = Period()* (WindowBarsPerChart( )/ X_Adjust ) * 2.5;
   if (EAdjPair != "" && EAdjdiv) EAdj = EAdjC / MarketInfo(EAdjPair,MODE_BID); 
   if (EAdjPair != "" && !EAdjdiv) EAdj = EAdjC * MarketInfo(EAdjPair,MODE_BID);
   if (EAdjPair == "") EAdj = EAdjC;
   // Comment Data
   string PoType;
   double R, P;
   double W, B;
   int D = MarketInfo (Symbol(),MODE_DIGITS);
   //Print("c");

   OrderSelect(Select,SELECT_BY_POS);
   if (OrderTicket() > 1 && !NoTradeFound && OrderSymbol() == Symbol()) 
      {
      

      switch (OrderType()) 
         {
         case OP_BUY: PoType = "OPEN BUY"; 
            if (OrderStopLoss() != 0)
               {
               R = (Bid - OrderStopLoss()) / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               W = (OrderStopLoss() - OrderOpenPrice())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
            if (OrderTakeProfit() !=0)
               {
               P = (OrderTakeProfit() - Bid) / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               B = (OrderTakeProfit() - OrderOpenPrice())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
         break;
         case OP_SELL: PoType = "OPEN SELL"; 
            if (OrderStopLoss() != 0)
               {
               R = (OrderStopLoss() - Ask) / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               W = (OrderOpenPrice() - OrderStopLoss())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
            if (OrderTakeProfit() !=0)
               {
               P = (Ask - OrderTakeProfit()) / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               B = (OrderOpenPrice() - OrderTakeProfit())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
         break;
         case OP_BUYLIMIT: PoType = "RESTING BUY LIMIT"; 
            if (OrderStopLoss() != 0)
               {
               R = 0;
               W = (OrderStopLoss() - OrderOpenPrice())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
            if (OrderTakeProfit() !=0)
               {
               P = 0;
               B = (OrderTakeProfit() - OrderOpenPrice())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
         break;
         case OP_SELLLIMIT: PoType = "RESTING SELL LIMIT"; 
            if (OrderStopLoss() != 0)
               {
               R = 0;
               W = (OrderOpenPrice() - OrderStopLoss())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
            if (OrderTakeProfit() !=0)
               {
               P = 0;
               B = (OrderOpenPrice() - OrderTakeProfit())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
         break;
         case OP_BUYSTOP: PoType = "RESTING BUY STOP"; 
            if (OrderStopLoss() != 0)
               {
               R = 0;
               W = (OrderStopLoss() - OrderOpenPrice())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
            if (OrderTakeProfit() !=0)
               {
               P = 0;
               B = (OrderTakeProfit() - OrderOpenPrice())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
         break;
         case OP_SELLSTOP: PoType = "RESTING SELL STOP"; 
            if (OrderStopLoss() != 0)
               {
               R = 0;
               W = (OrderOpenPrice() - OrderStopLoss())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
            if (OrderTakeProfit() !=0)
               {
               P = 0;
               B = (OrderOpenPrice() - OrderTakeProfit())  / MarketInfo (Symbol(),MODE_TICKSIZE)  * MarketInfo (Symbol(),MODE_TICKVALUE)*OrderLots();
               }
         break; 
         }
      
      
      Comment_Text = "--ORDER INFO-- \n" + Select + ". "  + OrderTicket() + " " + PoType + 
         "\nLots: " + DoubleToStr(OrderLots(), 2) + "  P/L: " + DoubleToStr(OrderProfit(),2) + 
         "\nOpen: " + DoubleToStr(OrderOpenPrice(),D) + "  T: " + TimeToStr(OrderOpenTime()) +
         "\nStop:  " + DoubleToStr(OrderStopLoss(),D) + "  R: " + DoubleToStr(R,2) + "  W: " + DoubleToStr(W,2) +
         "\nTake: " + DoubleToStr(OrderTakeProfit(),D) + "  P: " + DoubleToStr(P,2) + "  B: " + DoubleToStr(B,2);  
      }
   else Comment_Text = " --no order selected--";
   
   Comment_Text = Comment_Text + "\n \n --ACCOUNT INFO--";
   // Account Specific Comments
   R = 0;
   W = 0;
   P = 0;
   B = 0;
   //Print("d");
   for (int TOC = -1; TOC <= OrdersTotal(); TOC++)
      {
      OrderSelect(TOC,SELECT_BY_POS);
      if (OrderTicket() > 1 && OrderLots() > 0) 
      {
      switch (OrderType()) 
         { 
         case OP_BUY: PoType = "OPEN BUY";   
            if (OrderStopLoss() != 0)
               {
               R = R + ((OrderStopLoss() - MarketInfo (OrderSymbol(),MODE_BID)) / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               W = W + ((OrderStopLoss() - OrderOpenPrice())  / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               }
            if (OrderTakeProfit() !=0)
               {
               P = P + ((OrderTakeProfit() - MarketInfo (OrderSymbol(),MODE_BID)) / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               B = B + ((OrderTakeProfit() - OrderOpenPrice())  / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               }
            //Alert ("BTOC=" +  TOC + " P="+ P + " B=" + B + " R=" + R + " W=" + W); 
         break;
         case OP_SELL: PoType = "OPEN SELL"; 
            if (OrderStopLoss() != 0)
               {
               R = R + ((MarketInfo (OrderSymbol(),MODE_ASK) - OrderStopLoss()) / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               W = W + ((OrderOpenPrice() - OrderStopLoss())  / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               }
            if (OrderTakeProfit() !=0)
               {
               P = P + ((MarketInfo (OrderSymbol(),MODE_ASK) - OrderTakeProfit()) / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               B = B + ((OrderOpenPrice() - OrderTakeProfit())  / MarketInfo (OrderSymbol(),MODE_TICKSIZE)  * MarketInfo (OrderSymbol(),MODE_TICKVALUE)*OrderLots());
               }
            //Alert ("STOC=" +  TOC + " P="+ P + " B=" + B + " R=" + R + " W=" + W);  
         break; 
         }
         } 
      
      
      }   
      OrderSelect(Select,SELECT_BY_POS); 
      if (show_alls) Comment_Text = Comment_Text + 
      "\nAll Stops:   R: " + DoubleToStr(R,2) + "  W: " + DoubleToStr(W,2) +
      "  Equity: " + DoubleToStr(AccountEquity()+R+EAdj,2) + "  Balance: " + DoubleToStr(AccountBalance()+W,2) +
      "\nAll Takes:  P: " + DoubleToStr(P,2) + "  B: " + DoubleToStr(B,2)+
      "  Equity: " + DoubleToStr(AccountEquity()+P+EAdj,2) + "  Balance: " + DoubleToStr(AccountBalance()+B,2);
      if (show_adjusted)  Comment_Text = Comment_Text + 
      "\nEQUITY  " + AccountCurrency() +":  " + DoubleToStr(AccountEquity()+EAdj,2) + "   "+EAdjPair +" " + DoubleToStr((AccountEquity()+EAdj)*MarketInfo(EAdjPair,MODE_BID),2);  

   double totallots, TrueLeverage, P3, P3S;
   /*for (int lx = 0; lx < OrdersTotal(); lx ++)
      {
      OrderSelect(lx,SELECT_BY_POS);
      if (OrderType < 2) totallots = totallots + OrderLots;
      } */
   P3 = (EAdj * MarketInfo("USDCAD",MODE_BID) + AccountEquity()) * (atrr/100);
   P3S = P3 / (MarketInfo(Symbol(),MODE_TICKVALUE) * iATR(Symbol(),Period(),20,1)/Point/afraction);
   TrueLeverage = AccountMargin()/(AccountEquity()+EAdj)*AccountLeverage();  
   if (show_leverage_and_ATR)
   Comment_Text = Comment_Text + 
      "\nTrue Leverage: " + DoubleToStr (TrueLeverage,3) + " : 1    ATR points: " + DoubleToStr(iATR(Symbol(),Period(),20,1)/Point/5,0);
   if (show_tickvalue_and_margin)
   Comment_Text = Comment_Text + 
      "\nTickValue: " + DoubleToStr(MarketInfo(Symbol(),MODE_TICKVALUE),2) + "  Margin Required: " +
      DoubleToStr(MarketInfo(Symbol(),MODE_MARGINREQUIRED),2);
   //Print("g" + DoubleToStr(spread,2));   
   if (show_spread_and_range_ratio)
   
   {
    countx = countx + 1;
    avgspread = avgspread + ((spread - avgspread)/countx);
    if (avgspread != 0)
     Comment_Text = Comment_Text + 
       "\nSpread: " + DoubleToStr(spread,0) +
         "  A/S: " + DoubleToStr(iATR(Symbol(),Period(),20,0)/Point/(avgspread),0);// + "  PS: " + DoubleToStr(P3S,2) ;
    else
     Comment_Text = Comment_Text + 
       "\nSpread: " + DoubleToStr(spread,0) +
         "  A/S: " + "inf. "; //+ "  PS: " + DoubleToStr(P3S,2) ;
   }
   
   Comment (Comment_Text);
   //Print("g2");
   if (ObjectFind("Move") == -1)
   {
      ObjectCreate ("Move", OBJ_ARROW,0, Time[0] + Time_Unit*8, Bottom + Price_Unit*2.5); 
      ObjectSet ("Move", OBJPROP_ARROWCODE, 3);
      ObjectSet ("Move", OBJPROP_COLOR, Blue);
   }
   else
   {
       if (ObjectGet ("Move", OBJPROP_TIME1 ) < Time[0] && Shifted == false) 
         {
         Bottom_Fly = (ObjectGet ("Move", OBJPROP_PRICE1) - ((Bottom + Price_Unit*2.5) - Bottom_Fly*Price_Unit ) ) / Price_Unit;  
         Shifted = True;           
         }
       else
         {
         Shifted = False;     
         ObjectSet ("Move", OBJPROP_TIME1, Time[0] + Time_Unit*8); 
         ObjectSet ("Move", OBJPROP_PRICE1, Bottom + Price_Unit*2.5);  
         }          
   }
   
  
   if (Action_Line) 
   {
      if (ObjectFind("Action_Line") == -1)
      {
         ObjectCreate ("Action_Line", OBJ_VLINE, 0, Time[0]+Time_Unit, Bottom + Price_Unit);
         ObjectSet ("Action_Line", OBJPROP_COLOR, Text_Color);
      }
      else
      {
         ObjectSet ("Action_Line", OBJPROP_TIME1, Time[0]+Time_Unit);          
      }
   }
   
   
   if (ObjectFind("Safety") == -1)
   {
      ObjectCreate ("Safety", OBJ_ARROW, 0, Time[0] + Time_Unit*6, Bottom + Price_Unit*3);
      ObjectSet ("Safety", OBJPROP_ARROWCODE, SYMBOL_THUMBSUP);
   }
   else
   {
       ObjectSet ("Safety", OBJPROP_TIME1, Time[0] + Time_Unit*6);
       ObjectSet ("Safety", OBJPROP_PRICE1, Bottom + Price_Unit*3);
       if (!Action_Taken) ObjectSet ("Safety", OBJPROP_COLOR, ForestGreen); else ObjectSet ("Safety", OBJPROP_COLOR, Crimson);
            
   }
   
   if (ObjectFind("Stop_Loss_Icon") == -1)
   
   {
      ObjectCreate ("Stop_Loss_Icon", OBJ_TEXT, 0, Bottom + Price_Unit*5, Time[0] + Time_Unit*2); 
      ObjectSetText ("Stop_Loss_Icon", "----", Font_Size, Font, Crimson);
   }
   else
   {
       ObjectSet ("Stop_Loss_Icon", OBJPROP_TIME1, Time[0] + Time_Unit*2);
       ObjectSet ("Stop_Loss_Icon", OBJPROP_PRICE1, Bottom + Price_Unit*5);            
   }

   if (ObjectFind("Entry_Icon") == -1)
   {
      ObjectCreate ("Entry_Icon", OBJ_TEXT, 0, Time[0] + Time_Unit*4, Bottom + Price_Unit*5);
      ObjectSetText ("Entry_Icon", "----", Font_Size, Font, Blue);
   }
   else
   {
       ObjectSet ("Entry_Icon", OBJPROP_TIME1, Time[0] + Time_Unit*4);
       ObjectSet ("Entry_Icon", OBJPROP_PRICE1, Bottom + Price_Unit*5);            
   }
   
   if (ObjectFind("Alert_Icon") == -1)
   {
      ObjectCreate ("Alert_Icon", OBJ_TEXT, 0, Time[0] + Time_Unit*8, Bottom + Price_Unit*5);
      ObjectSetText ("Alert_Icon", "----", Font_Size, Font, Pink);
   }
   else
   {
       ObjectSet ("Alert_Icon", OBJPROP_TIME1, Time[0] + Time_Unit*8);
       ObjectSet ("Alert_Icon", OBJPROP_PRICE1, Bottom + Price_Unit*5);            
   }
   

   if (ObjectFind("Target1_Icon") == -1)
   {
      ObjectCreate ("Target1_Icon", OBJ_TEXT, 0, Time[0] + Time_Unit*6, Bottom + Price_Unit*5);
      ObjectSetText ("Target1_Icon", "----", Font_Size, Font, ForestGreen);
   }
   else
   {
       ObjectSet ("Target1_Icon", OBJPROP_TIME1, Time[0] + Time_Unit*6);
       ObjectSet ("Target1_Icon", OBJPROP_PRICE1, Bottom + Price_Unit*5);            
   }
   

   if (ObjectFind("Delete_Order") == -1)
   {
      
      ObjectCreate ("Delete_Order", OBJ_ARROW, 0, Time[0] + Time_Unit*6 , Bottom + Price_Unit*4);
      ObjectSet ("Delete_Order", OBJPROP_ARROWCODE, SYMBOL_STOPSIGN);
      ObjectSet ("Delete_Order", OBJPROP_COLOR, Crimson);
   }
   else
   {
      ObjectSet ("Delete_Order", OBJPROP_TIME1, Time[0] + Time_Unit*6);
      ObjectSet ("Delete_Order", OBJPROP_PRICE1, Bottom + Price_Unit*4);            
   }

   if (ObjectFind("Update_Order") == -1)
   {
      
      ObjectCreate ("Update_Order", OBJ_ARROW, 0, Time[0] + Time_Unit*8 , Bottom + Price_Unit*4);
      ObjectSet ("Update_Order", OBJPROP_ARROWCODE, SYMBOL_CHECKSIGN);
      ObjectSet ("Update_Order", OBJPROP_COLOR, Crimson);
   }
   else
   {
      ObjectSet ("Update_Order", OBJPROP_TIME1, Time[0] + Time_Unit*8);
      ObjectSet ("Update_Order", OBJPROP_PRICE1, Bottom + Price_Unit*4);            
   }

   
   if (ObjectFind("Market_Buy_Order") == -1)
   {
      
      ObjectCreate ("Market_Buy_Order", OBJ_ARROW, 0, Time[0] + Time_Unit*2 , Bottom + Price_Unit*4);
      ObjectSet ("Market_Buy_Order", OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
      ObjectSet ("Market_Buy_Order", OBJPROP_COLOR, Crimson);
   }
   else
   {
      ObjectSet ("Market_Buy_Order", OBJPROP_TIME1, Time[0] + Time_Unit*2);
      ObjectSet ("Market_Buy_Order", OBJPROP_PRICE1, Bottom + Price_Unit*4);            
   }
   

   if (ObjectFind("Market_Sell_Order") == -1)
   {
      
      ObjectCreate ("Market_Sell_Order", OBJ_ARROW, 0, Time[0] + Time_Unit*4 , Bottom + Price_Unit*4);
      ObjectSet ("Market_Sell_Order", OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
      ObjectSet ("Market_Sell_Order", OBJPROP_COLOR, Crimson);
   }
   else
   {
      ObjectSet ("Market_Sell_Order", OBJPROP_TIME1, Time[0] + Time_Unit*4);
      ObjectSet ("Market_Sell_Order", OBJPROP_PRICE1, Bottom + Price_Unit*4);            
   }
   

   
   
   if (Stop_Loss != 0)
   {
      if (ObjectFind("Stop_Loss") == -1)
      {
         ObjectCreate ("Stop_Loss", OBJ_HLINE, 0, Time[0] + Time_Unit*2 , Stop_Loss);
         ObjectSet ("Stop_Loss", OBJPROP_COLOR, Crimson);      
      }
   }
   
   if (Entry != 0)
   {
      if (ObjectFind("Entry") == -1)
      {
         ObjectCreate ("Entry", OBJ_HLINE, 0, Time[0] + Time_Unit*2 , Entry);      
         ObjectSet ("Entry", OBJPROP_COLOR, Blue);      
      }
   }

   if (Target1 != 0)
   {
      if (ObjectFind("Target1") == -1)
      {
         ObjectCreate ("Target1", OBJ_HLINE, 0, Time[0] + Time_Unit*2 , Target1);      
         ObjectSet ("Target1", OBJPROP_COLOR, ForestGreen);      
      }
   }
   
   //if (AlertP != 0)
   //{
      //if (ObjectFind("Alert") == -1)
      //{
         //ObjectCreate ("Alert", OBJ_HLINE, 0, Time[0] + Time_Unit*2 , AlertP);      
         //ObjectSet ("Alert", OBJPROP_COLOR, Pink);      
      //}
   //}

   //Print("h");

   if (ObjectFind("Risk_Reward") == -1)
   {
      ObjectCreate ("Risk_Reward", OBJ_TEXT,0, Time[0] + (Time_Unit*RR_Center/X_Adjust)+(Time_Unit) , Bottom + Price_Unit);
      ObjectSet ("Risk_Reward", OBJPROP_COLOR, Text_Color);                     
   }
   else
   {
      ObjectSet ("Risk_Reward", OBJPROP_TIME1, Time[0] + (Time_Unit*RR_Center/X_Adjust)+(Time_Unit));            
      ObjectSet ("Risk_Reward", OBJPROP_PRICE1, Bottom + Price_Unit);            
      ObjectSetText ("Risk_Reward", "R:R: "+ DoubleToStr( Risk_Reward, 2) +" : 1", Font_Size, Font, Text_Color);
   }
   //Print("i");
   if (ObjectFind("Selected_Trade") == -1)
   {
      ObjectCreate ("Selected_Trade", OBJ_TEXT, 0, Time[0] + (Time_Unit*ST_Center/X_Adjust)+(Time_Unit) , Bottom);
      ObjectSet ("Selected_Trade", OBJPROP_COLOR, Text_Color);                     
   }
   else
   {
      string SelectS = "" + Select;
      if (Select == -1) SelectS = "NEW";
      ObjectSet ("Selected_Trade", OBJPROP_TIME1, Time[0] + (Time_Unit*ST_Center/X_Adjust)+(Time_Unit));            
      ObjectSet ("Selected_Trade", OBJPROP_PRICE1, Bottom);            
      ObjectSetText ("Selected_Trade", "Order: "+ SelectS, Font_Size, Font, Text_Color);
   }

//Print("j");
   
   switch (Risk_Management)
   {
      case 0:
      {
         if (ObjectFind("Lot_Size") == -1)
         {
            ObjectCreate ("Lot_Size", OBJ_TEXT, 0, Time[0] + (Time_Unit*LS0_Center/X_Adjust) +Time_Unit  , Bottom + Price_Unit*2);
            ObjectSet ("Lot_Size", OBJPROP_COLOR, Text_Color); 
                       
         }
         else
         {
            ObjectSet ("Lot_Size", OBJPROP_TIME1, Time[0] + (Time_Unit*LS0_Center/X_Adjust) +Time_Unit );            
            ObjectSet ("Lot_Size", OBJPROP_PRICE1, Bottom + Price_Unit*2);            
            ObjectSetText ("Lot_Size", "Lot Size: "+ DoubleToStr( Lot_Size, Lot_Precision) , Font_Size, Font, Text_Color);
         }
         
         if (ObjectFind("Inc_Lot_Size") == -1)
         {
            ObjectCreate("Inc_Lot_Size", OBJ_ARROW, 0, Time[0] + Time_Unit*2, Bottom + Price_Unit*3);
            ObjectSet ("Inc_Lot_Size", OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
            ObjectSet ("Inc_Lot_Size", OBJPROP_COLOR, Text_Color);             
         }
         else
         {
            ObjectSet ("Inc_Lot_Size", OBJPROP_TIME1, Time[0] + Time_Unit*2);            
            ObjectSet ("Inc_Lot_Size", OBJPROP_PRICE1, Bottom + Price_Unit*3);            
            
         }
         if (ObjectFind("Dec_Lot_Size") == -1)
         {
            ObjectCreate("Dec_Lot_Size", OBJ_ARROW, 0, Time[0] + Time_Unit*4, Bottom + Price_Unit*3);
            ObjectSet ("Dec_Lot_Size", OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
            ObjectSet ("Dec_Lot_Size", OBJPROP_COLOR, Text_Color);             
         }
         else
         {
            ObjectSet ("Dec_Lot_Size", OBJPROP_TIME1, Time[0] + Time_Unit*4);            
            ObjectSet ("Dec_Lot_Size", OBJPROP_PRICE1, Bottom + Price_Unit*3);            
            
         }
         break;
      }
      
      //Print("k");
      case 1:
      {
         if (ObjectFind("Lot_Size") == -1)
         {
            ObjectCreate ("Lot_Size", OBJ_TEXT, 0, Time[0] + (Time_Unit*LS1_Center/X_Adjust) +Time_Unit , Bottom + Price_Unit*2);
            ObjectSet ("Lot_Size", OBJPROP_COLOR, Text_Color);                     
         }
         else
         {
            ObjectSet ("Lot_Size", OBJPROP_TIME1, Time[0] + (Time_Unit*LS1_Center/X_Adjust) +Time_Unit );            
            ObjectSet ("Lot_Size", OBJPROP_PRICE1, Bottom + Price_Unit*2);            
            ObjectSetText ("Lot_Size", "Lots: "+ DoubleToStr( Lot_Size, Lot_Precision) +"  "+" E: "+DoubleToStr( Standard_Lot_Size, 1)+"%" , Font_Size, Font, Text_Color);
         }
         
         
         
         if (ObjectFind("Inc_Lot_Size") == -1) 
         {
            ObjectCreate("Inc_Lot_Size", OBJ_ARROW, 0, Time[0] + Time_Unit*2, Bottom + Price_Unit*3);
            ObjectSet ("Inc_Lot_Size", OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
            ObjectSet ("Inc_Lot_Size", OBJPROP_COLOR, Text_Color);             
         }
         else
         {
            ObjectSet ("Inc_Lot_Size", OBJPROP_TIME1, Time[0] + Time_Unit*2);            
            ObjectSet ("Inc_Lot_Size", OBJPROP_PRICE1, Bottom + Price_Unit*3);            
            
         }
         
         
         if (ObjectFind("Dec_Lot_Size") == -1)
         {
            ObjectCreate("Dec_Lot_Size", OBJ_ARROW, 0, Time[0] + Time_Unit*4, Bottom + Price_Unit*3);
            ObjectSet ("Dec_Lot_Size", OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
            ObjectSet ("Dec_Lot_Size", OBJPROP_COLOR, Text_Color);             
         }
         else
         {
            ObjectSet ("Dec_Lot_Size", OBJPROP_TIME1, Time[0] + Time_Unit*4);            
            ObjectSet ("Dec_Lot_Size", OBJPROP_PRICE1, Bottom + Price_Unit*3);            
            
         }
         break;

      }
   }
//Print("L");
  }     
      
void Check_For_Inputs()
{
   if (ReOrder)
   {
      if (ReOrderType == "BS")
         {
            if (Entry - Ask >= 11 *Point) 
            {
               ReOrder = false;
               Buy_At_Market();
               Action_Taken = true;
               
            }
            if (Entry - Ask <= 0) 
            {
               ReOrder = false;
               Entry = 0;
               Buy_At_Market();
               Action_Taken = true;
            }
         }
      if (ReOrderType == "BL")
         {
            if (Ask - Entry >= 11 *Point) 
            {
               ReOrder = false;
               Buy_At_Market();
               Action_Taken = true;
               
            }
            if (Ask - Entry <= 0) 
            {
               ReOrder = false;
               Entry = 0;
               Buy_At_Market();
               Action_Taken = true;
            }
         }



      if (ReOrderType == "SL")
         {
            if (Entry - Bid >= 11 *Point) 
            {
               ReOrder = false;
               Sell_At_Market();
               Action_Taken = true;
               
            }
            if (Entry - Bid <= 0) 
            {
               ReOrder = false;
               Entry = 0;
               Sell_At_Market();
               Action_Taken = true;
            }
         }
      if (ReOrderType == "SS")
         {
            if (Bid - Entry >= 11 *Point) 
            {
               ReOrder = false;
               Sell_At_Market();
               Action_Taken = true;
               
            }
            if (Bid - Entry <= 0) 
            {
               ReOrder = false;
               Entry = 0;
               Sell_At_Market();
               Action_Taken = true;
            }
         }


   }
   
   if (ObjectFind("Market_Buy_Order") != -1)

   {
      if (ObjectGet("Market_Buy_Order", OBJPROP_TIME1) <= Time [0] )
      {
         //Imediately Place Order
         if (!Action_Taken) 
         {
            Buy_At_Market();
            Action_Taken = true;
         }
      }
   }
   
   if (ObjectFind("Market_Sell_Order") != -1)
   {
      if (ObjectGet("Market_Sell_Order", OBJPROP_TIME1) <= Time [0] )
      {
         //Imediately Place Order
         if (!Action_Taken) 
         {
            Sell_At_Market();
            Action_Taken = true;
         }
      }
   }
   
   
   if (ObjectFind("Safety") != -1)

   {
      if (ObjectGet("Safety", OBJPROP_TIME1) <= Time [0] )
      {
         //Reload Safety
         Action_Taken = false;


      }
   } 


   if (ObjectFind("Inc_Lot_Size") != -1)

   {
      if (ObjectGet("Inc_Lot_Size", OBJPROP_TIME1) <= Time [0] )
      {
         if (Risk_Management == 0)
            Standard_Lot_Size = Standard_Lot_Size + 1.0/MathPow(10,Lot_Precision);
         else
            Standard_Lot_Size = Standard_Lot_Size + 0.1;


      }
   }

   if (ObjectFind("Dec_Lot_Size") != -1)

   {
      if (ObjectGet("Dec_Lot_Size", OBJPROP_TIME1) <= Time [0] )
      {
         //Reload Safety
         if (Risk_Management == 0)
            Standard_Lot_Size = Standard_Lot_Size - 1.0/MathPow(10,Lot_Precision);
         else
            Standard_Lot_Size = Standard_Lot_Size - 0.1; 
   
      }
   } 
   
   if (ObjectFind("Stop_Loss") != -1)
   {
      Stop_Loss = ObjectGet("Stop_Loss", OBJPROP_PRICE1);          
   }
   else
   {
      Stop_Loss = 0;
      
   }
   if (ObjectFind("Stop_Loss_Icon") != -1)

   {
      if (ObjectGet("Stop_Loss_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         //Place Stop Loss
         Stop_Loss = ObjectGet("Stop_Loss_Icon", OBJPROP_PRICE1);
         ObjectSet("Stop_Loss", OBJPROP_PRICE1, Stop_Loss);
         
      }
   }
   

   if (ObjectFind("Entry") != -1)
   {
      Entry = ObjectGet("Entry", OBJPROP_PRICE1);          
   }
   else
   {
      Entry = 0;
      
   }
   if (ObjectFind("Entry_Icon") != -1)

   {
      if (ObjectGet("Entry_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         //Place Stop Loss
         Entry = ObjectGet("Entry_Icon", OBJPROP_PRICE1);
         ObjectSet("Entry", OBJPROP_PRICE1, Entry);
         
      }
   }

   if (ObjectFind("Target1") != -1)
   {
      Target1 = ObjectGet("Target1", OBJPROP_PRICE1);          
   }
   else
   {
      Target1 = 0;
      
   }
   if (ObjectFind("Target1_Icon") != -1)

   {
      if (ObjectGet("Target1_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         //Place Stop Loss
         Target1 = ObjectGet("Target1_Icon", OBJPROP_PRICE1);
         ObjectSet("Target1", OBJPROP_PRICE1, Target1);
         
      }
   }

   if (ObjectFind("Target2") != -1)
   {
      Target2 = ObjectGet("Target2", OBJPROP_PRICE1);          
   }
   else
   {
      Target2 = 0;
      
   }
   if (ObjectFind("Target2_Icon") != -1)

   {
      if (ObjectGet("Target2_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         //Place Stop Loss
         Target2 = ObjectGet("Target2_Icon", OBJPROP_PRICE1);
         ObjectSet("Target2", OBJPROP_PRICE1, Target2);
         
      }
   }

   if (ObjectFind("Target3") != -1)
   {
      Target3 = ObjectGet("Target3", OBJPROP_PRICE1);          
   }
   else
   {
      Target3 = 0;
      
   }
   if (ObjectFind("Target3_Icon") != -1)

   {
      if (ObjectGet("Target3_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         //Place Stop Loss
         Target3 = ObjectGet("Target3_Icon", OBJPROP_PRICE1);
         ObjectSet("Target3", OBJPROP_PRICE1, Target3);
         
      }
   }

   if (ObjectFind("Target4") != -1)
   {
      Target4 = ObjectGet("Target4", OBJPROP_PRICE1);          
   }
   else
   {
      Target4 = 0;
      
   }
   if (ObjectFind("Target4_Icon") != -1)

   {
      if (ObjectGet("Target4_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         
         Target4 = ObjectGet("Target4_Icon", OBJPROP_PRICE1);
         ObjectSet("Target4", OBJPROP_PRICE1, Target4); 
         
      }
   }
   if (ObjectFind("Alert") != -1)
   {
      //ObjectSet("Alert", OBJPROP_PRICE1, AlertP);         
   }
   else
   {
      

      
      
   }
   if (ObjectFind("Alert_Icon") != -1)

   {
      if (ObjectGet("Alert_Icon", OBJPROP_TIME1) <= Time [0] )
      {
         //Place Alert
         AlertP = ObjectGet("Alert_Icon", OBJPROP_PRICE1);
         ObjectCreate ("Alert", OBJ_HLINE, 0, Time[1], AlertP);      
         ObjectSet ("Alert", OBJPROP_COLOR, Pink); 
         ObjectSet("Alert", OBJPROP_PRICE1, AlertP);
         ObjectSet("Alert", OBJPROP_STYLE, STYLE_DOT);
         Alert ("-----------------------------------------");
         Alert ("hcb (if there is a high on close below)");      
         Alert ("lca (if there is a low on close above)");
         Alert ("ocb (if price opens and closes below)");
         Alert ("oca (if price opens and closes above)");
         Alert ("cb (if price closes below)" );
         Alert ("ca (if price closes above)");
         Alert ("b (if price goes below)");
         Alert("a (if price goes above)");
         Alert("Change the name of the horizontal line to");
         Alert("-------------------------------------------");
      }
   }



   if (ObjectFind("Lot_Size") != -1)

   {
      if (ObjectGet("Lot_Size", OBJPROP_TIME1) <= Time [0] )
      {
         
         Risk_Management++;
         if (Risk_Management > 1) Risk_Management = 0;
         Standard_Lot_Size = 0;
         
      }
   }

   if (ObjectFind("Delete_Order") != -1)
   {
      if (ObjectGet("Delete_Order", OBJPROP_TIME1) <= Time [0] )
      {
        if (Select > -1)
        {
         OrderSelect(Select,SELECT_BY_POS);
         if (OrderType()>1)
         {
            OResult = OrderDelete(OrderTicket());
            Alert("Closing Resting Order: "+OrderType()+" Ticket:"+OrderTicket() + "Error:" + GetLastError());
         } 
         else 
         {
            if (OrderType() == OP_BUY) OResult = OrderClose(OrderTicket(),Lot_Size,NormalizeDouble(Bid,Digits),Max_Slip);
            else OResult = OrderClose(OrderTicket(),Lot_Size,NormalizeDouble(Ask,Digits),Max_Slip);
            Alert("Closing Open Order: "+OrderType()+" Ticket:"+OrderTicket()+ " Error:" + GetLastError());

         }
         if (OResult==1)
            {
            Select = -1;               
            ObjectDelete ("Target1");
            Target1 = 0;
            ObjectDelete ("Stop_Loss");
            Stop_Loss = 0;
            ObjectDelete ("Entry");
            Entry = 0;
            }
        }
            
      }
   }

   if (ObjectFind("Update_Order") != -1)

   {
      if (ObjectGet("Update_Order", OBJPROP_TIME1) <= Time [0] )
      {
        OrderSelect(Select,SELECT_BY_POS);
        OrderModify(OrderTicket(),Entry,Stop_Loss,Target1,0);
        Alert ("ORDER MODIFIED "+Symbol()+ " E:" + Entry + " S:" + Stop_Loss + " T:" + Target1+ " ERROR:" +GetLastError());
       
      }
   }


   if (ObjectFind("Selected_Trade") != -1)
   {
      if (ObjectGet("Selected_Trade", OBJPROP_TIME1) <= Time [0] )
      {
         NoTradeFound = true;
         //Alert("deleting");
         ObjectDelete ("Target1");
         Target1 = 0;
         ObjectDelete ("Stop_Loss");
         Stop_Loss = 0;
         ObjectDelete ("Entry");
         Entry = 0;
         Risk_Management = 0;
         Standard_Lot_Size = 0;
         while (NoTradeFound)
         {
            Select ++;
    
            if (Select > OrdersTotal()) 
            {
               Select = -1;
               NoTradeFound = false;    
            }
            else
            {
               if (OrderSelect(Select, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() ) 
               {
                  //Alert("Found Active Order");
                  Stop_Loss = OrderStopLoss();
                  Target1 = OrderTakeProfit();
                  Entry = OrderOpenPrice(); 
                  Standard_Lot_Size = OrderLots();
                  NoTradeFound = false; 
                  
               }
            }
            
            
         }
         
         
      
      } 
   }

}

void Recalculate_Risk()
{
      double spread = MarketInfo(Symbol(),MODE_SPREAD);
       {
         {
            acount = 300;
            bool Afound = false;
            bool Bfound = false;
            bool CAfound = false;
            bool CBfound = false;
            bool OCAfound = false;
            bool OCBfound = false;
            bool LCAfound = false;
            bool HCBfound = false;

            for(int i = ObjectsTotal()-1; i >= 0; i--)
            {
               string name = ObjectName(i);

               if(StringSubstr(name,0,1) == "a" && StringLen(name) < 3 )
               {
                  Afound = true;
                  if (ObjectType(name) == OBJ_HLINE) double value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);                  
                  if(Bid >= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     Atrigger = true; 
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     Astr = name;
                     string AltStr = name;
                  }
                  if(!Atrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);

               }
               if(StringSubstr(name,0,1) == "b" && StringLen(name) < 3 && ObjectGet (name,OBJPROP_COLOR) != MediumPurple)
               {
                  Bfound = true;
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(Bid <= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     Btrigger = true; 
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     Bstr = name;
                     AltStr = name;
                  } 
                  if(!Btrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
               }
               if(StringSubstr(name,0,2) == "ca" && StringLen(name) < 4 )
               {
                  CAfound = true;
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(Close[1] >= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     CAtrigger = true; 
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     CAstr = name;AltStr = name;
                  }
                  if(!CAtrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
               }
               if(StringSubstr(name,0,2) == "cb" && StringLen(name) < 4 )
               {
                  CBfound = true;
                  if(!CBtrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(Close[1] <= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow ))
                  {
                     CBtrigger = true;
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     CBstr = name;AltStr = name;
                  }
                  if(!CBtrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
               }
               if(StringSubstr(name,0,3) == "oca" && StringLen(name) < 5 )
               {
                  OCAfound = true;
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(Close[1] >= value && Open[1] >= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     OCAtrigger = true;
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     OCAstr = name;AltStr = name;
                  }
                  if(!OCAtrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
               }
               if(StringSubstr(name,0,3) == "ocb" && StringLen(name) < 5 )
               {
                  OCBfound = true;
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(Close[1] <= value && Open[1] <= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     OCBtrigger = true;
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     OCBstr = name;AltStr = name;
                  }
                  if(!OCBtrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
               }
               if(StringSubstr(name,0,3) == "lca" && StringLen(name) < 5 )
               {
                  LCAfound = true;
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(Low[1] >= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     LCAtrigger = true;
                     if (ContAlm) ObjectSet(name,OBJPROP_COLOR,Orange); else ObjectSet(name,OBJPROP_COLOR,MediumPurple);
                     LCAstr = name;
                     AltStr = name;
                  }
                  if(!LCAtrigger)ObjectSet(name,OBJPROP_COLOR,Yellow);
               }
               if(StringSubstr(name,0,3) == "hcb" && StringLen(name) < 5 )
               {
                  HCBfound = true;
                  if (ObjectType(name) == OBJ_HLINE) value = ObjectGet(name,OBJPROP_PRICE1 );
                  else value = ObjectGetValueByShift(name,0);
                  if(High[1] <= value && (ContAlm || ObjectGet (name,OBJPROP_COLOR) == Yellow )) 
                  {
                     HCBtrigger = true;
                     ObjectSet(name,OBJPROP_COLOR,Orange);
                     HCBstr = name;
                     AltStr = name;
                  }
                  if(!HCBtrigger) ObjectSet(name,OBJPROP_COLOR,Yellow);
               }


            }
            
            if (Atrigger || Btrigger || CAtrigger || CBtrigger || OCAtrigger || OCBtrigger || LCAtrigger || HCBtrigger)   
            {
               Alert("Alert for " + Symbol() + " " + Period()+ " " + AltStr  );
               
         
            }
            
            
            if (!Afound ||  (ObjectFind(Astr) == -1)) {Atrigger = false; }
            if (!Bfound ||  (ObjectFind(Bstr) == -1)) {Btrigger = false; }
            if (!CAfound ||  (ObjectFind(CAstr) == -1)) {CAtrigger = false; }
            if (!CBfound ||  (ObjectFind(CBstr) == -1)) {CBtrigger = false; }
            if (!OCAfound ||  (ObjectFind(OCAstr) == -1)) {OCAtrigger = false;}
            if (!OCBfound ||  (ObjectFind(OCBstr) == -1)) {OCBtrigger = false;}
            if (!LCAfound ||  (ObjectFind(LCAstr) == -1)) {LCAtrigger = false;}
            if (!HCBfound ||  (ObjectFind(HCBstr) == -1)) {HCBtrigger = false;}
            
               
               
         } 
         
   /*      
if (XSymbol == "USDJPY") ASymbol = 1;
if (XSymbol == "USDCAD") ASymbol = 2;
if (XSymbol == "USDCHF") ASymbol = 3;
if (XSymbol == "GBPUSD") ASymbol = 4;
if (XSymbol == "AUDUSD") ASymbol = 5;
if (XSymbol == "GBPJPY") ASymbol = 6;
if (XSymbol == "EURJPY") ASymbol = 7;
if (XSymbol == "USDCAD") ASymbol = 8;
if (XSymbol == "USDCHF") ASymbol = 9;
if (XSymbol == "XAGUSD") ASymbol = 10;
if (XSymbol == "XAUUSD") ASymbol = 11;
if (XSymbol == "NZDUSD") ASymbol = 12;
if (XSymbol == "AUDNZD") ASymbol = 13;
if (XSymbol == "EURGBP") ASymbol = 14;
if (XSymbol == "EURCHF") ASymbol = 15;
if (XSymbol == "CHFJPY") ASymbol = 16;
if (XSymbol == "GBPCHF") ASymbol = 17;
if (XSymbol == "AUDCAD") ASymbol = 18;
if (XSymbol == "EURUSD") ASymbol = 19;
if (XSymbol == "USDMXN") ASymbol = 20;
if (XSymbol == "USDTRY") ASymbol = 21;
if (XSymbol == "CADJPY") ASymbol = 22;
if (XSymbol == "AUDJPY") ASymbol = 23;
if (XSymbol == "EURCAD") ASymbol = 24;
if (XSymbol == "EURAUD") ASymbol = 25;
       */  
         
        // Alert (XSymbol);
      }

   
   
   
   if (Lot_Size < 0) Lot_Size =0;
   if (Standard_Lot_Size < 0) Standard_Lot_Size =0;
   if (Target1 !=0 && Stop_Loss !=0)
   {
      if (Entry != 0)
      {
         Risk_Reward = (Target1 - Entry) / (Entry - Stop_Loss) ;
      }
      else
      {
         Risk_Reward = (Target1 - Close[0]) / (Close[0] - Stop_Loss) ;
      }
      
   }
   else
   {
      Risk_Reward = 0;
   }   
   if (Risk_Management == 0)
   {
      Lot_Size = NormalizeDouble(Standard_Lot_Size,Lot_Precision);
   }   

   if (Risk_Management == 1)
   {  
      if (Stop_Loss != 0)
      {
         if (Entry != 0)
         {
            if (Stop_Loss > Entry)
            {
               if (Stop_Loss-Entry != 0)
               Lot_Size = NormalizeDouble(((AccountEquity()+EAdj)*Standard_Lot_Size/100) / ((Stop_Loss-Entry)/Point*MarketInfo(Symbol(),MODE_TICKVALUE)),Lot_Precision);
               //Alert("Lotsize:"+Lot_Size);     
            
            }
            else
            {
               if (Stop_Loss-Entry != 0)
               Lot_Size = NormalizeDouble(((AccountEquity()+EAdj)*Standard_Lot_Size/100) / ((Entry-Stop_Loss)/Point*MarketInfo(Symbol(),MODE_TICKVALUE)),Lot_Precision);

            }
         }
         else
         {
            if (Stop_Loss > Ask)
            {
               
               Lot_Size = NormalizeDouble(((AccountEquity()+EAdj)*Standard_Lot_Size/100) / ((Stop_Loss-Bid)/Point*MarketInfo(Symbol(),MODE_TICKVALUE)),Lot_Precision);

            }
            if (Stop_Loss < Bid)
            {
               Lot_Size = NormalizeDouble(((AccountEquity()+EAdj)*Standard_Lot_Size/100) / ((Ask-Stop_Loss)/Point*MarketInfo(Symbol(),MODE_TICKVALUE)),Lot_Precision);
            
            }
         }
         
       
      }
      else
      {
         Lot_Size = 0;
      }
   }   

}

void Buy_At_Market()
{
   if (Stop_Loss != 0)
   {
      TStop = NormalizeDouble(Stop_Loss,Digits);
   } 
   else
   {
      if (Default_Stop != 0) TStop = Ask - Default_Stop * Point; else TStop = 0;
   }
      
   if (Target1 != 0)
   {
      TTake1 = NormalizeDouble(Target1,Digits);
   } 
   else
   {
      if (Default_Take1 != 0) TTake1 = Ask + Default_Take1 * Point; else TTake1 = 0;
   }
/*
   if (Target2 != 0)
   {
      TTake2 = Target2;
   } 
   else
   {
      if (Default_Take2 != 0) TTake2 = Ask + Default_Take2 * Point; else TTake2 = 0;
   }

   if (Target3 != 0)
   {
      TTake3 = Target3;
   } 
   else
   {
      if (Default_Take3 != 0) TTake3 = Ask + Default_Take3 * Point; else TTake3 = 0;
   }

   if (Target4 != 0)
   {
      TTake4 = Target4;
   } 
   else
   {
      if (Default_Take4 != 0) TTake4 = Ask + Default_Take4 * Point; else TTake4 = 0;
   }
   */
   if (Entry == 0)   
   {
      OResult = OrderSend(Symbol(),OP_BUY,Lot_Size,NormalizeDouble(Ask,Digits),Max_Slip,TStop,TTake1,TimeCurrent()+Com,MagicNumber,0);
      Alert ("Buy_Market"+Symbol()+" "+OP_BUY+" "+Lot_Size+" "+Ask+" "+Max_Slip+" "+TStop+" "+TTake1+" "+TimeCurrent()+Com+MagicNumber + " ERROR:" +GetLastError());
   }
   else
   {
      Entry = NormalizeDouble(Entry,Digits);
      if (Entry < Ask) OResult = OrderSend(Symbol(),OP_BUYLIMIT,Lot_Size,Entry,Max_Slip,TStop,TTake1,TimeCurrent()+Com,MagicNumber,0); 
      else OResult = OrderSend(Symbol(),OP_BUYSTOP,Lot_Size,Entry,Max_Slip,TStop,TTake1,TimeCurrent()+Com,MagicNumber,0);
      if (OResult == -1) 
      {
         if (Entry - Ask <= 10*Point && Entry - Ask >= 0 ) {ReOrder = true;ReOrderType = "BS";Alert("AutoReorder");}
         if (Ask - Entry <= 10*Point && Ask - Entry >= 0 ) {ReOrder = true;ReOrderType = "BL";Alert("AutoReorder");}
      }
      Alert (OResult+ "  Resting Order Buy "+Symbol()+" EO "+Lot_Size+" "+Entry+" "+Max_Slip+" "+TStop+" "+TTake1+" "+TimeCurrent()+Com+MagicNumber + " ERROR:" +GetLastError());
   }
   //Entry = NormalizeDouble(Entry,);
   //if (Units_Per_Trade > 1) OrderSend(Symbol(),OP,Lot_Size,Entry,Max_Slip,TStop,TTake2,TimeCurrent()+"U2",MagicNumber,0);
   //if (Units_Per_Trade > 2) OrderSend(Symbol(),OP,Lot_Size,Entry,Max_Slip,TStop,TTake3,TimeCurrent()+"U3",MagicNumber,0);
   //if (Units_Per_Trade > 3) OrderSend(Symbol(),OP,Lot_Size,Entry,Max_Slip,TStop,TTake4,TimeCurrent()+"U4",MagicNumber,0);
   if (OResult != -1)
      {
      Select = OrdersTotal( )-1 ;  
      OrderSelect(Select, SELECT_BY_POS);  
      NoTradeFound = False;           
      //ObjectDelete ("Target1");
      //Target1 = 0;
      //ObjectDelete ("Stop_Loss");
      //Stop_Loss = 0;
      //ObjectDelete ("Entry");
      //Entry = 0;
      }
}


void Sell_At_Market()
{
   if (Stop_Loss != 0)
   {
      TStop = NormalizeDouble(Stop_Loss,Digits);
   } 
   else
   {
      if (Default_Stop != 0) TStop = Bid - Default_Stop * Point; else TStop = 0;
   }
      
   if (Target1 != 0)
   {
      TTake1 = NormalizeDouble(Target1,Digits);
   } 
   else
   {
      if (Default_Take1 != 0) TTake1 = Bid + Default_Take1 * Point; else TTake1 = 0;
   }
/*
   if (Target2 != 0)
   {
      TTake2 = Target2;
   } 
   else
   {
      if (Default_Take2 != 0) TTake2 = Bid + Default_Take2 * Point; else TTake2 = 0;
   }

   if (Target3 != 0)
   {
      TTake3 = Target3;
   } 
   else
   {
      if (Default_Take3 != 0) TTake3 = Bid + Default_Take3 * Point; else TTake3 = 0;
   }

   if (Target4 != 0)
   {
      TTake4 = Target4;
   } 
   else
   {
      if (Default_Take4 != 0) TTake4 = Bid + Default_Take4 * Point; else TTake4 = 0;
   }
   */
   if (Entry == 0)   
   {
      OResult = OrderSend(Symbol(),OP_SELL,Lot_Size,NormalizeDouble(Bid,Digits),Max_Slip,NormalizeDouble(TStop,Digits),NormalizeDouble(TTake1,Digits),TimeCurrent()+Com,MagicNumber,0);
      Alert ("Sell_Market"+Symbol()+" "+OP_SELL+" "+Lot_Size+" "+Bid+" "+Max_Slip+" "+TStop+" "+TTake1+" "+TimeCurrent()+Com+MagicNumber + " Error:"+GetLastError());
   }
   else
   {
     Entry = NormalizeDouble(Entry,Digits);
     if (Entry < Bid) OResult = OrderSend(Symbol(),OP_SELLSTOP,Lot_Size,Entry,Max_Slip,TStop,TTake1,TimeCurrent()+Com,MagicNumber,0); 
     else OResult = OrderSend(Symbol(),OP_SELLLIMIT,Lot_Size,Entry,Max_Slip,TStop,TTake1,TimeCurrent()+Com,MagicNumber,0);
     if (OResult == -1) 
     {
        if (Entry - Bid <= 10*Point && Entry - Bid >= 0 ) {ReOrder = true;ReOrderType = "SL";Alert("AutoReorder");}
        if (Bid - Entry <= 10*Point && Bid - Entry >= 0 ) {ReOrder = true;ReOrderType = "SS";Alert("AutoReorder");}
     }
     Alert (OResult+"   Sell_Resting"+Symbol()+" EO "+Lot_Size+" "+Bid+" "+Max_Slip+" "+TStop+" "+TTake1+" "+TimeCurrent()+Com+MagicNumber+ " Error:"+GetLastError());
    
   }
   
   
   //Entry = NormalizeDouble(Entry,);
   //if (Units_Per_Trade > 1) OrderSend(Symbol(),OP,Lot_Size,Entry,Max_Slip,TStop,TTake2,TimeCurrent()+"U2",MagicNumber,0);
   //if (Units_Per_Trade > 2) OrderSend(Symbol(),OP,Lot_Size,Entry,Max_Slip,TStop,TTake3,TimeCurrent()+"U3",MagicNumber,0);
   //if (Units_Per_Trade > 3) OrderSend(Symbol(),OP,Lot_Size,Entry,Max_Slip,TStop,TTake4,TimeCurrent()+"U4",MagicNumber,0);
   if (OResult != -1)
      {
      Select = OrdersTotal( )-1 ;  
      OrderSelect(Select, SELECT_BY_POS);  
      NoTradeFound = False;           
      //ObjectDelete ("Target1");
      //Target1 = 0;
      //ObjectDelete ("Stop_Loss");
      //Stop_Loss = 0;
      //ObjectDelete ("Entry");
      //Entry = 0;
      }

}       
        