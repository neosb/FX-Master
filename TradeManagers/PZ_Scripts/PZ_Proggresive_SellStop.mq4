//+------------------------------------------------------------------+
//| PZ_ProggresiveSell.mq4
//| --
//| This script places four short orders with proper SL settings.
//| The goal is to enter the market progressively as it runs in our favor.
//| Orders have a distance of ATR(30)/2 between each other and lotsize is
//| decreased for each trade to avoid overbetting. Initial risk 2%.
//+------------------------------------------------------------------+
#property copyright "Copyright © http://www.pointzero-trading.com"
#property link      "http://www.pointzero-trading.com"

//---- Dependencies
#import "stdlib.ex4"
   string ErrorDescription(int e);
#import
#include <stdlib.mqh>
#include <WinUser32.mqh>

//-- Orders to be opened
#define  PendingOrders        3                       // Amount of pending orders to be added

//-- Money management
#define  MoneyManagement      1                       // Use Money Management
#define  LotSize              0.1                     // If not, use this lotsize
#define  RiskPercent          2                       // Risk for initial trade
#define  RiskDecrease         0.5                     // Risk decrease for the next trade

//-- ATR and multipliers
#define  ATRPeriod            30                      // ATR Period to use
#define  ATRStopMultiplier    2                       // Multiplier for the initial stop-loss
#define  ATROrderMultiplier   0.5                     // Multiplier for further pending orders

//-- Don't change me
#define  ShortName            "PZ Proggresive Sell Stop"
#define  MagicNumber          5001
#define  Slippage             6
#define  Shift                1

//-- Internal
double   LastOrderLots = EMPTY_VALUE;
double   LastOrderPrice;
double   DecimalPip;

//+------------------------------------------------------------------+
//| Custom Script start function                           
//+------------------------------------------------------------------+
int start()
{
    // Confirm
   if(MessageBox(ShortName +" - Do you really want to place "+ (PendingOrders+1) +" SELLSTOP orders?",
                 "Script",MB_YESNO|MB_ICONQUESTION)!=IDYES) return(1);
                 
   // Pip value 
   DecimalPip = GetDecimalPip();
   
   // Bars
   double CLOSE = iClose(Symbol(),0, Shift);
   double HIGH = iHigh(Symbol(),0, Shift);
   double LOW = iLow(Symbol(),0, Shift);
   
   //--
   //-- Place the first order 
   //--
   if(Ask < LOW)
   {
      PlaceOrder(OP_SELL, GetLotSize());
   } else {
      PlaceOrder(OP_SELLSTOP, GetLotSize(), LOW);
   }
   
   //--
   //-- Place pending orders
   //--
   for(int it = 0; it < PendingOrders; it++)
      PlaceOrder(OP_SELLSTOP, GetLotSize(), LastOrderPrice - iATR(Symbol(), 0, ATRPeriod, Shift)*ATROrderMultiplier);
   
   // Hi there!
   Comment("Copyright © http://www.pointzero-trading.com");
   
   // Bye
   return(0);
}

//+------------------------------------------------------------------+
//| My functions
//+------------------------------------------------------------------+


/**
* Calculates lot size according to risk
* @return   double
*/
double GetLotSize()
{
   // Lots
   double l_lotz = LotSize;
   
   // Lotsize and restrictions 
   double l_minlot = MarketInfo(Symbol(), MODE_MINLOT);
   double l_maxlot = MarketInfo(Symbol(), MODE_MAXLOT);
   double l_lotstep = MarketInfo(Symbol(), MODE_LOTSTEP);
   int vp = 0; if(l_lotstep == 0.01) vp = 2; else vp = 1;
   
   // Apply money management
   if(MoneyManagement == true)
      l_lotz = MathFloor(AccountBalance() * RiskPercent / 100.0) / 1000.0;
  
   // Wait! Check if we are pyramiding
   if(LastOrderLots != EMPTY_VALUE && LastOrderLots > 0)
      l_lotz = LastOrderLots * RiskDecrease;
      
   // Normalize to lotstep
   l_lotz = NormalizeDouble(l_lotz, vp);
   
   // Check max/minlot here
   if (l_lotz < l_minlot) l_lotz = l_minlot;
   if(l_lotz > l_maxlot) l_lotz = l_maxlot; 
   
   // Bye!
   return (l_lotz);
}


/**
* Places an order
* @param    int      Type
* @param    double   Lotz
* @param    double   PendingPrice
*/
void PlaceOrder(int Type, double Lotz, double PendingPrice = 0)
{  
   // Local
   int err;
   color  l_color;
   double l_stoploss, l_price, l_sprice = 0;
   double stoplevel = getStopLevelInPips();
   RefreshRates();
   
   // Price and color for the trade type
   if(Type == OP_BUY){ l_price = Ask;  l_color = Blue; }
   if(Type == OP_SELL){ l_price = Bid; l_color = Red; } 
   if(Type == OP_BUYSTOP) { l_price = PendingPrice; if(l_price <= Ask+stoplevel*DecimalPip) l_price = Ask + stoplevel*DecimalPip; l_color = LightBlue; }
   if(Type == OP_SELLSTOP) { l_price = PendingPrice; if(l_price >= Bid-stoplevel*DecimalPip) l_price = Bid - stoplevel*DecimalPip; l_color = Salmon; }
   
   // Avoid collusions
   while (IsTradeContextBusy()) Sleep(1000);
   int l_datetime = TimeCurrent();
   
   // Send order
   int l_ticket = OrderSend(Symbol(), Type, Lotz, MyNormalizeDouble(l_price), Slippage, 0, 0, "", MagicNumber, 0, l_color);
   
   // Rety if failure
   if (l_ticket == -1)
   {
      while(l_ticket == -1 && TimeCurrent() - l_datetime < 5 && !IsTesting())
      {
         err = GetLastError();
         if (err == 148) return;
         Sleep(1000);
         while (IsTradeContextBusy()) Sleep(1000);
         RefreshRates();
         l_ticket = OrderSend(Symbol(), Type, Lotz, MyNormalizeDouble(l_price), Slippage, 0, 0, "", MagicNumber, 0, l_color);
      }
      if (l_ticket == -1)
         Print(ShortName +" (OrderSend Error) "+ ErrorDescription(GetLastError()));
   }
   if (l_ticket != -1)
   {
      LastOrderLots = Lotz; 
      LastOrderPrice = l_price;
      if (OrderSelect(l_ticket, SELECT_BY_TICKET, MODE_TRADES))
      {
         l_stoploss = MyNormalizeDouble(GetStopLoss(Type, PendingPrice));
         if(!OrderModify(l_ticket, OrderOpenPrice(), l_stoploss, 0, 0, Green))
            Print(ShortName +" (OrderModify Error) "+ ErrorDescription(GetLastError())); 
      }
   }
}


/**
* Returns initial stoploss
* @param   int       Type
* @param   double    ForcedPrice
* @return  double
*/
double GetStopLoss(int Type, double ForcedPrice = 0)
{
   double l_sl = 0;
   if(Type == OP_BUY) l_sl = Ask - iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier - (Ask - Bid);
   if(Type == OP_SELL) l_sl = Bid + iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier + (Ask - Bid);
   if(Type == OP_BUYSTOP) l_sl = ForcedPrice - iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier - (Ask - Bid);
   if(Type == OP_SELLSTOP) l_sl = ForcedPrice + iATR(Symbol(), 0, ATRPeriod, Shift)*ATRStopMultiplier + (Ask - Bid);
   return (l_sl);
}

/**
* Returns decimal pip value
* @return   double
*/
double GetDecimalPip()
{
   switch(Digits)
   {
      case 5: return(0.0001);
      case 4: return(0.0001);
      case 3: return(0.001);
      default: return(0.01);
   }
}

/**
* Normalizes price
* @param    double   price 
* @return   double
*/
double MyNormalizeDouble(double price)
{
   return (NormalizeDouble(price, Digits));
}

/**
* Get baseline plus deviation
* @return   double
*/
double getStopLevelInPips()
{
   double s = MarketInfo(Symbol(), MODE_STOPLEVEL) + 1.0;
   if(Digits == 5) s = s / 10;
   return(s);
}