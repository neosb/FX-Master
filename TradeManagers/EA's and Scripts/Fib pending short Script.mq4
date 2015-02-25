//+------------------------------------------------------------------+
//|                                             Fib pending long.mq4 |
//|                                  Copyright © 2008, Steve Hopwood |
//|                              http://www.hopwood3.freeserve.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Steve Hopwood"
#property link      "http://www.hopwood3.freeserve.co.uk"
#include <WinUser32.mqh>
#include <stdlib.mqh>
#property show_inputs

extern double  Lots=0.1;
extern double  FibPriceHigh=1.5613;
extern double  FibPriceLow=1.5549;
extern bool    AutoStopLoss=true;
extern double  NextFibLevel=1.5691;
extern double  SL=0;
extern double  TP=0;
//extern int     AutoSlPercent=50;
extern string  TradeComment = "Fib";
extern int     MagicNumber=274693;

bool           EntryError=false;
double         MidPrice;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int init()
  {
//----
   // Check for entry errors
   
   if (Lots==0)
   {
      Alert("You have not entered a lot size. This  Script  will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }
   
   if (FibPriceHigh==0)
   {
      Alert("You have not entered a FibPriceHigh value. This  Script  will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }
   
   if (FibPriceLow==0)
   {
      Alert("You have not entered a FibPriceLow value. This  Script  will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }

      
   
//----
   return(0);
  }


int start()
  {
//----
   
   if (EntryError) return; // Can't do anything

   // Got this far without user blunders, so calculate the midprice for the pending order.
   double PriceDifference;
   PriceDifference=NormalizeDouble((FibPriceHigh - FibPriceLow)/2,Digits);
   MidPrice = FibPriceLow + PriceDifference;
   
   int ticket; // for error handling
   
   // Set tp and sl
   double stoploss, takeprofit;
   
   if(TP==0) takeprofit=0;
   else takeprofit=TP;
   
   if(SL==0) stoploss=0;
   else stoploss=SL;
   
   // Calculate auto stop loss
   if (AutoStopLoss && !NextFibLevel==0)
   {
      PriceDifference=NormalizeDouble((NextFibLevel-FibPriceHigh)/2, Digits);
      stoploss = FibPriceHigh + PriceDifference;
   }
   
    
   ticket=OrderSend(Symbol(),OP_SELLSTOP ,Lots,MidPrice,0,stoploss,takeprofit,TradeComment,MagicNumber,0,CLR_NONE);
   // Check for errors
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return;
     }


   
//----
   return(0);
  }
//+------------------------------------------------------------------+