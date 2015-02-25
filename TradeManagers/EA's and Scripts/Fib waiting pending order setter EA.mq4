//+------------------------------------------------------------------+
//|                                     Fib pending order setter.mq4 |
//|                                  Copyright © 2008, Steve Hopwood |
//|                              http://www.hopwood3.freeserve.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Steve Hopwood"
#property link      "http://www.hopwood3.freeserve.co.uk"
#include <WinUser32.mqh>
#include <stdlib.mqh>

extern double  Lots=0.1;
extern bool    Long=true;
extern bool    Short=false;
extern double  FibPriceHigh=0;
extern double  FibPriceLow=0;
extern double  SL=0;
extern double  TP=0;
extern bool    AutoStopLoss=true;
extern double  NextFibLevel;
//extern int     AutoSlPercent=50;
extern string  TradeComment = "Fib";
extern int     MagicNumber=274693;

double takeprofit,stoploss; //order setting
double MidPrice; //midway between FibPriceHigh and FibPriceLow
bool TradingAllowed = true; // set to false when the ea has sent a pending order
bool EntryError=false; // set to true if the user makes an error with the entries

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   // Check for entry errors
   if (Long==true && Short == true)
   {
      Alert("Either Long or Short must be true, not both. This ea will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }
   
   if (Long==false && Short == false)
   {
      Alert("Either Long or Short must be false, not both. This ea will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }
   
   if (Lots==0)
   {
      Alert("You have not entered a lot size. This ea will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }
   
   if (FibPriceHigh==0)
   {
      Alert("You have not entered a FibPriceHigh value. This ea will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }
   
   if (FibPriceLow==0)
   {
      Alert("You have not entered a FibPriceLow value. This ea will not function. Reload and try again.");
      EntryError=true;
      return(0);
   }

   // Got this far without user blunders, so calculate the midprice for the pending order.
   double PriceDifference;
   PriceDifference=NormalizeDouble((FibPriceHigh - FibPriceLow)/2,Digits);
   MidPrice = FibPriceLow + PriceDifference;
      
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   //Check for entry errors
   if (EntryError==true) return(0);
   
   // Only continue if an order has not already been placed
   if (!TradingAllowed) return(0);
   
   // Check to see if market price has hit the required price. If so, set an pending order 
   // and set TradingAllowed to false to abort further attempts to place an order. The routine
   // checks TradingAllowed each time the ea start function is triggered by a price quote.
   // Buy order
   if (Long==true) CheckMarketPriceForBuy(); // Check for long order setting
   if (Short==true) CheckMarketPriceForSell(); // Check for short order setting
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

void CheckMarketPriceForBuy()
{
   // Only continue if an order has not already been placed
   if (!TradingAllowed) return(0);
   
   
   // Market price =< FibPriceLow, so set the pending order and set TradeingAllowed to false
   int ticket; // for error handling
   
   // Set tp and sl
   if(TP==0) takeprofit=0;
   else takeprofit=TP;
   
   if(SL==0) stoploss=0;
   else stoploss=SL;
   
   // Calculate auto stop loss
   if (AutoStopLoss && !NextFibLevel==0)
   {
      double PriceDifference;
      PriceDifference=NormalizeDouble((FibPriceLow - NextFibLevel)/2, Digits);
      stoploss = NextFibLevel + PriceDifference;
   }

   // If market price is > the fib low price then the order does not need setting
   double CurrentMarketPrice = MarketInfo(Symbol(), MODE_BID);
   if (CurrentMarketPrice > FibPriceLow) 
   {
      Comment("Monitoring position. Waiting to send pending buy order at ", MidPrice, " after a bounce up from ", FibPriceLow, ": SL=", stoploss, ": TP=", takeprofit);
      return(0);
   }
     
   ticket=OrderSend(Symbol(),OP_BUYSTOP ,Lots,MidPrice,0,stoploss,takeprofit,TradeComment,MagicNumber,0,CLR_NONE);
   // Check for errors
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return;
     }

   // Everything ok, so pending order has been set and further trading needs disallowing
   TradingAllowed=false;
   Comment("Pending buy order sent. I need removing from the chart as soon as possible.");
   
   return(0);
}

void CheckMarketPriceForSell()
{
   // Only continue if an order has not already been placed
   if (!TradingAllowed) return(0);

      
   // Market price =< FibPriceLow, so set the pending order and set TradeingAllowed to false
   int ticket; // for error handling
   
   // Set tp and sl
   if(TP==0) takeprofit=0;
   else takeprofit=TP;
   
   if(SL==0) stoploss=0;
   else stoploss=SL;
   
   // Calculate auto stop loss
   if (AutoStopLoss && !NextFibLevel==0)
   {
      double PriceDifference;
      PriceDifference=NormalizeDouble((NextFibLevel-FibPriceHigh)/2, Digits);
      stoploss = FibPriceHigh + PriceDifference;
   }
     
   // If market price is > the fib low price then the order does not need setting
   double CurrentMarketPrice = MarketInfo(Symbol(), MODE_BID);
   if (CurrentMarketPrice < FibPriceHigh) 
   {
      Comment("Monitoring position. Waiting to send pending sell order at ", MidPrice, " after a bounce down from ", FibPriceHigh, ": SL=", stoploss, ": TP=", takeprofit);
      return(0);
   }
   

   ticket=OrderSend(Symbol(),OP_SELLSTOP,Lots,MidPrice,0,stoploss,takeprofit,TradeComment,MagicNumber,0,CLR_NONE);
   // Check for errors
   if(ticket<1)
     {
      int error=GetLastError();
      Print("Error = ",ErrorDescription(error));
      return;
     }

   // Everything ok, so pending order has been set and further trading needs disallowing
   TradingAllowed=false;
   Comment("Pending sell order sent. I need removing from the chart as soon as possible.");
   
   return(0);
}

