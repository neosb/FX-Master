//+------------------------------------------------------------------+
//|                                                  Market Long.mq4 |
//|                                                    Steve Hopwood |
//| www.hopwood3.freeserve.co.uk                                     |
//+------------------------------------------------------------------+
#property copyright "Steve Hopwood"
#property link      ""
#property show_inputs
#include <WinUser32.mqh>
#include <stdlib.mqh>

extern double Lots=0.1;
extern int    MagicNumber=274693;
extern int    StopLoss=20;
extern int    TakeProfit=40;
extern string TradeComment = "Mine";
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
  
  // Include spread
   double BrokerSpread=MarketInfo(Symbol(),MODE_SPREAD);
   double TP=TakeProfit; 
   double SL=StopLoss;
   
   if (TakeProfit==0) TP=0;
   else
   {
      //TP=NormalizeDouble(TakeProfit-(BrokerSpread*Point),Digits);
      TP=NormalizeDouble(Ask+TakeProfit*Point,Digits);
   }
   
   if (StopLoss==0) SL=0;
   else
   {
      //SL=NormalizeDouble(StopLoss-(BrokerSpread*Point),Digits);
      SL=NormalizeDouble(Bid-StopLoss*Point,Digits);
   }
   
   
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,5,SL,TP,TradeComment,MagicNumber,0,CLR_NONE);
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return;
     }
//----
   OrderPrint();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+