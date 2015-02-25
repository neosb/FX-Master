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

extern double Lots=0.01;
extern int    MagicNumber=274693;
extern int    StopLoss;
extern int    TakeProfit;
extern string TradeComment = "ES";
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
      TP=NormalizeDouble(Bid-TakeProfit*Point,Digits);
   }
   
   if (StopLoss==0) SL=0;
   else
   {
      SL=NormalizeDouble(Ask+StopLoss*Point,Digits); 
   }

  
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,5,SL,TP,TradeComment,MagicNumber,0,CLR_NONE);
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