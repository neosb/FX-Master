//+------------------------------------------------------------------+
//|                                            Fib trade manager.mq4 |
//|                                  Copyright © 2008, Steve Hopwood |
//|                              http://www.hopwood3.freeserve.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Steve Hopwood"
#property link      "http://www.hopwood3.freeserve.co.uk"
/*
The Start function calls the MonitorTrades function. This cycles through the list of open orders,
checking to see which management style the user has chosen - by ticket number, magic number,
comment or all trades, regardelss of anything else etc. 

If an appropriate management style choice is found, the ManageTrade function is called. This in
turn calls functions that checks for action depending on the choice of facilities - breakeven, 
jumping stop etc.

The ea offers the option to close 50% of a profitable trade at a target 
set by the user (PartCloseOrder).

Start then calls GlobalOrderClosure. If enabled, this routine closes all open orders at
a $profit or % of account balance.

The order of program run is: Start calls MonitorTrades (calls ManageTrade) then GlobalOrderClosure.
*/
#include <WinUser32.mqh>
#include <stdlib.mqh>
#define  NL    "\n"

// User can choose a variety of trade managment triggers.
// These are for use on a chart that controls the currency of that chart
extern string  ManagementStyle="You can select more than one option";
extern bool    ManageByMagicNumber=false;
extern int     MagicNumber=274693;
extern bool    ManageByTradeComment=false;
extern string  TradeComment = "Fib";
extern bool    ManageByTickeNumber=false;
extern int     TicketNumber;
// This allows the ea to manage all existing trades
extern string  OverRide="ManageAllTrades will override all others";
extern bool    ManageAllTrades=true;
// Now give user a variety of facilities
extern string  bl1="---------------------------------------------------------------------";
extern string  ManagementFacilities="Select the management facilities you want";
extern string  BE="Break even settings";
extern bool    BreakEven=false;
extern int     BreakEvenPips=30;
extern int     BreakEvenProfit=2;
extern string  JSL="Jumping stop loss settings";
extern bool    JumpingStop=true;
extern int     JumpingStopPips=30;
extern bool    AddBEP=true;
extern string  TSL="Trailing stop loss settings";
extern bool    TrailingStop=false;
extern int     TrailingStopPips=30;
extern string  ITSL="Instant trailing stop loss settings";
extern bool    InstantTrailingStop=false;
extern int     InstantTrailingStopPips=30;
extern string  bl2="---------------------------------------------------------------------";
extern string  GOC="Global order closure settings";
extern bool    GlobalOrderClosureEnabled=false;
extern bool    IncludePendingOrdersInClosure=false;
extern bool    ProfitInDollars=false;
extern double  DollarProfit=100000;
extern bool    ProfitAsPercentageOfBalance=false;
extern double  PercentageProfit=10000;
extern string  bl3="---------------------------------------------------------------------";
extern string  PCS="Part close settings";
extern bool    PartCloseEnabled=false;
extern string  b1="-----------";
extern string  s1="EURUSD";
extern bool    EU=false;
extern double  EUTargetPrice;
extern double  EUTargetPips=10;
extern string  b2="-----------";
extern string  s2="GBPUSD";
extern bool    GU=false;
extern double  GUTargetPrice;
extern double  GUTargetPips;
extern string  b3="-----------";
extern string  s3="USDJPY";
extern bool    UJ=false;
extern double  UJTargetPrice;
extern double  UJTargetPips;
extern string  b4="-----------";
extern string  s4="USDCHF";
extern bool    UC=false;
extern double  UCTargetPrice;
extern double  UCTargetPips;
extern string  b5="-----------";
extern string  s5="USDCAD";
extern bool    UCad=false;
extern double  UCadTargetPrice;
extern double  UCadTargetPips;
extern string  b6="-----------";
extern string  s6="USDCAD";
extern bool    AU=false;
extern double  AUTargetPrice;
extern double  AUTargetPips;
extern string  b7="-----------";
extern string  s7="NZDUSD";
extern bool    NU=false;
extern double  NUTargetPrice;
extern double  NUTargetPips;
extern string  b8="-----------";
extern string  s8="EURGBP";
extern bool    EG=false;
extern double  EGTargetPrice;
extern double  EGTargetPips;
extern string  b9="-----------";
extern string  s9="EURJPY";
extern bool    EJ=false;
extern double  EJTargetPrice;
extern double  EJTargetPips;
extern string  b10="-----------";
extern string  s10="EURCHF";
extern bool    EC=false;
extern double  ECTargetPrice;
extern double  ECTargetPips;
extern string  b11="-----------";
extern string  s11="GBPJPY";
extern bool    GJ=false;
extern double  GJTargetPrice;
extern double  GJTargetPips;
extern string  b12="-----------";
extern string  s12="GBPCHF";
extern bool    GC=false;
extern double  GCTargetPrice;
extern double  GCTargetPips;
extern string  b13="-----------";
extern string  s13="AUDJPY";
extern bool    AJ=false;
extern double  AJTargetPrice;
extern double  AJTargetPips;
extern string  b14="-----------";
extern string  s14="CHFJPY";
extern bool    CJ=false;
extern double  CJTargetPrice;
extern double  CJTargetPips;
extern string  b15="-----------";
extern string  s15="EURCAD";
extern bool    ECad=false;
extern double  ECadTargetPrice;
extern double  ECadTargetPips;
extern string  b16="-----------";
extern string  s16="EURAUD";
extern bool    EA=false;
extern double  EATargetPrice;
extern double  EATargetPips;
extern string  b17="-----------";
extern string  s17="AUDCAD";
extern bool    AC=false;
extern double  ACTargetPrice;
extern double  ACTargetPips;
extern string  b18="-----------";
extern string  s18="AUDNZD";
extern bool    AN=false;
extern double  ANTargetPrice;
extern double  ANTargetPips;
extern string  b19="-----------";
extern string  s19="NZDJPY";
extern bool    NJ=false;
extern double  NJTargetPrice;
extern double  NJTargetPips;
extern string  bl4="---------------------------------------------------------------------";
extern string  OtherStuff="Other stuff";
extern bool    ShowAlerts=true;



int            cnt=0; //loop counter
double         bid, ask; // For storing the Bid\Ask so that one instance of the ea can manage all trades, if required
double         point, digits; // Saves the Point and Digits of an order
// Variables for part-close reoutine
double         TargetAsPrice, TargetAsPips;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----

   // Stop if there is nothing to do
   if (OrdersTotal()==0)
   {
      Comment("No trades to manage. I am bored witless.");
      return(0);
   }
   
   Comment("Monitoring trades");
   
   MonitorTrades(); // Stop loss adjusting
   
   if(GlobalOrderClosureEnabled) GlobalOrderClosure(); // Whole position closing at set profit level
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
void MonitorTrades()
{

   bool ManageTrade; // tell the program when there is a trade to manage
   string ScreenMessage;
   
   
   for (cnt=0;cnt<OrdersTotal();cnt++)
   { 
      OrderSelect(cnt, SELECT_BY_POS);   
      ManageTrade=false;
      if (OrderSymbol()==Symbol() || ManageAllTrades==true) // Continue if order is correct symbol or the ea is to manage all trades regardless
      {
         ScreenMessage = StringConcatenate("Managing ", Symbol(), " by: ");
         // Set up bid and ask so the program can use them to calculate jumping stops, be's etc
         bid = MarketInfo(OrderSymbol(), MODE_BID);           
         ask = MarketInfo(OrderSymbol(), MODE_ASK);
         point = MarketInfo(OrderSymbol(), MODE_POINT);
         digits = MarketInfo(OrderSymbol(), MODE_DIGITS);
         
         // Test whether this individual trade needs managing
         // MagicNumber
         if (ManageByMagicNumber && OrderMagicNumber()==MagicNumber)
         {   
            ManageTrade=true;
            ScreenMessage=StringConcatenate(ScreenMessage, "Magic Number=", MagicNumber,"; ");
         }   
         
         // TradeComment
         if (ManageByTradeComment && OrderComment()==TradeComment)
         {   
            ManageTrade=true;
            ScreenMessage=StringConcatenate(ScreenMessage, "Trade Comment=",TradeComment,"; ");
         }   
         
         // ManageByTickeNumber
         if (ManageByTickeNumber && OrderTicket()==TicketNumber)
         {   
            ManageTrade=true;
            ScreenMessage=StringConcatenate(ScreenMessage, "Ticket Number=", TicketNumber, "; ");
         }
                                            
         
         // ManageAllTrades
         if (ManageAllTrades)
         {   
            ManageTrade=true;
            ScreenMessage="Managing all open trades";
         }   
         
                  
         // Is this trade being managed by the ea?
         if (ManageTrade) ManageTrade(); // The subroutine that calls the other working subroutines
         
      } // Close if (OrderSymbol()==Symbol())
      
   
   } // Close For loop
   
   // Set up some user feedback
   if(BreakEven)
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Break even set to ", BreakEvenPips, ". BreakEvenProfit is set to ", BreakEvenProfit, " pips");
   }
   else
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Break even not set");
   }
   
   if(JumpingStop==true)
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Jumping stop set to ", JumpingStopPips);
      if(AddBEP==true)
      {
         ScreenMessage = StringConcatenate(ScreenMessage, ", also adding BreakEvenProfit (", BreakEvenProfit, " pips)");      
      }      
   }
   else
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Jumping stop not set");
   }
   
   if(TrailingStop==true)
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Trailing stop on and set to ", TrailingStopPips);
   }
   else
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Trailing stop not set");
   }
   
   if (InstantTrailingStop)
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Instant trailing stop on and set to ", InstantTrailingStopPips);
   }
   else
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Instant trailing stop not set");
   }
   
   // Include global profit closure
   if (GlobalOrderClosureEnabled)   
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Global order closure enabled");
      if (IncludePendingOrdersInClosure) ScreenMessage = StringConcatenate(ScreenMessage, ", including pending orders");
   }
   else ScreenMessage = StringConcatenate(ScreenMessage, NL, "Global order closure not set");
   
   if (PartCloseEnabled)
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Order part close enabled");
   }
   else
   {
      ScreenMessage = StringConcatenate(ScreenMessage, NL, "Order part close not enabled");
   }
   
   
   
   Comment(ScreenMessage); // User feedback
   
   
   
} // end of MonitorTrades

void BreakEvenStopLoss() // Move stop loss to breakeven
{
   if (!BreakEven) return(0); // User has not chosen this option, so abort
   int ticket;

           
   if (OrderType()==OP_BUY)
         {
            if (bid >= OrderOpenPrice () + (point*BreakEvenPips) && 
                OrderStopLoss()<OrderOpenPrice())
            {
               ticket = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(BreakEvenProfit*point),OrderTakeProfit(),0,CLR_NONE);
               if (ticket>0 && ShowAlerts==true) Alert("Breakeven set on ", OrderSymbol(), " ticket no ", OrderTicket());
            }
   	   }               			         
          
   if (OrderType()==OP_SELL)
         {
           if (ask <= OrderOpenPrice() - (point*BreakEvenPips) &&
              (OrderStopLoss()>OrderOpenPrice()|| OrderStopLoss()==0)) 
            {
               ticket = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(BreakEvenProfit*point),OrderTakeProfit(),0,CLR_NONE);
               if (ticket>0 && ShowAlerts==true) Alert("Breakeven set on ", OrderSymbol(), " ticket no ", OrderTicket());
            }    
         }
      

} // End BreakevenStopLoss sub

void JumpingStopLoss() // Jump sl by pips and at intervals chosen by user 
{
   
   if (!JumpingStop) return(0); // User has not chosen this option, so abort
   int ticket;
   double sl=OrderStopLoss(); //Stop loss
  
   if (OrderType()==OP_BUY)
   {
      // First check if sl needs setting to breakeven
      if (sl==0 || sl<OrderOpenPrice())
      {
         if (bid >= OrderOpenPrice() + (JumpingStopPips*point))
         {
            sl=OrderOpenPrice();
            if (AddBEP==true) sl=sl+(BreakEvenProfit*point); // If user wants to add a profit to the break even
            ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
            if (ticket>0)
            {
               if (ShowAlerts==true) Alert("Jumping stop set at breakeven ",sl, " ", OrderSymbol(), " ticket no ", OrderTicket());
               Print("Jumping stop set at breakeven: ", OrderSymbol(), ": SL ", sl, ": Ask ", ask);
            }            
            return(0);
         }
      } //close if (sl==0 || sl<OrderOpenPrice()
      
      // Increment sl by sl + JumpingStopPips.
      // This will happen when market price >= (sl + JumpingStopPips)
      if (bid>= sl + ((JumpingStopPips*2)*point) && sl>= OrderOpenPrice())      
      {
         sl=sl+(JumpingStopPips*point);
         ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
         if (ticket>0)
         {
            if (ShowAlerts==true) Alert("Jumping stop set at ",sl, " ", OrderSymbol(), " ticket no ", OrderTicket());
            Print("Jumping stop set: ", OrderSymbol(), ": SL ", sl, ": Ask ", ask);
         }            
            
      }// close if (bid>= sl + (JumpingStopPips*point) && sl>= OrderOpenPrice())      
   }
      
   if (OrderType()==OP_SELL)
   {
      // First check if sl needs setting to breakeven
      if (sl==0 || sl>OrderOpenPrice())
      {
         if (ask <= OrderOpenPrice() - (JumpingStopPips*point))
         {
            sl=OrderOpenPrice();
            if (AddBEP==true) sl=sl-(BreakEvenProfit*point); // If user wants to add a profit to the break even
            ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
            if (ticket>0)
            {
               if (ShowAlerts==true) Alert("Jumping stop set at breakeven ",sl, " ", OrderSymbol(), " ticket no ", OrderTicket());
               Print("Jumping stop set at breakeven: ", OrderSymbol(), ": SL ", sl, ": Ask ", ask);
            }            
            return(0);
         }
      } //close if (sl==0 || sl>OrderOpenPrice()
      
      // Decrement sl by sl - JumpingStopPips.
      // This will happen when market price <= (sl - JumpingStopPips)
      if (bid<= sl - ((JumpingStopPips*2)*point) && sl<= OrderOpenPrice())      
      {
         sl=sl-(JumpingStopPips*point);
         ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
         if (ticket>0)
         {
            if (ShowAlerts==true) Alert("Jumping stop set at ",sl, " ", OrderSymbol(), " ticket no ", OrderTicket());
            Print("Jumping stop set: ", OrderSymbol(), ": SL ", sl, ": Ask ", ask);
         }            
            
      }// close if (bid>= sl + (JumpingStopPips*point) && sl>= OrderOpenPrice())      
   
   
   }

} //End of JumpingStopLoss sub

void TrailingStopLoss()
{
   if (!TrailingStop) return(0); // User has not chosen this option, so abort
   int ticket;
   double sl=OrderStopLoss(); //Stop loss
   double BuyStop=0, SellStop=0;
   
   if (OrderType()==OP_BUY) 
      {
		   if (bid >= OrderOpenPrice() + (TrailingStopPips*point))
		   {
		       if (bid > sl +  (TrailingStopPips*point))
		       {
		          sl= bid - (TrailingStopPips*point);
		          ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
               if (ticket>0)
               {
                  Print("Trailing stop updated: ", OrderSymbol(), ": SL ", sl, ": Ask ", ask);
               } 
		       }
		   }
      }

if (OrderType()==OP_SELL) 
      {
		   if (ask <= OrderOpenPrice() - (TrailingStopPips*point))
		   {
		       if (ask < sl -  (TrailingStopPips*point))
		       {
		          sl= ask + (TrailingStopPips*point);
		          //Alert(OrderSymbol(), " ", sl);
		            ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
                  if (ticket>0)
                  {
                     Print("Trailing stop updated: ", OrderSymbol(), ": SL ", sl, ": Bid ", bid);
                  } 
		       }
		   }
      }


} // End of TrailingStopLoss sub
   
void InstantTrailingStopLoss()
/* This is the same as TrailingStopLoss, except that it moves the sl as soon as
 the market moves ion favour of the trade. 
 It will set an initial sl of market price +- UtsPips, depending on the type of trade,
 then move it every time the market moves in favour of the trade. It will therefore override
 any user set sl on the trade.
 Market price +- UtsPips will result in breakeven, and move into profit after that.
*/ 
{
   if (!InstantTrailingStop) return(0); // User has not chosen this option, so abort
   int ticket;
   double sl=OrderStopLoss(); //Stop loss
   double BuyStop=0, SellStop=0;
   
   if (OrderType()==OP_BUY) 
      {
		   if (bid >= sl+(InstantTrailingStopPips*point)) // Has to overcome the spread first
		   {
	         sl= bid - (InstantTrailingStopPips*point);
	         ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
            if (ticket>0)
            {
               Print("Instant trailing stop updated: ", OrderSymbol(), ": SL ", sl, ": Ask ", ask);
            } 
		    }
      }

      if (OrderType()==OP_SELL) 
      {
	       if ((ask <= sl + (InstantTrailingStopPips*point)) || sl==0)
	       {
	            sl= ask + (InstantTrailingStopPips*point);
	            ticket = OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),0,CLR_NONE);
               if (ticket>0)
               {
                  Print("Trailing stop updated: ", OrderSymbol(), ": SL ", sl, ": Bid ", bid);
               } 
	       }		   
      }


} // End of InstantTrailingStopLoss() sub
   
void GlobalOrderClosure()
{
   bool CloseOrders=false;
   double ProfitPercentage=0;

   // First calculate whether the upl is >= the point at which the position is to close

   // Profit in dollars enabled
   if (ProfitInDollars)
   {
      if(AccountProfit()>=DollarProfit) CloseOrders=true;
   }
   
   // Profit as percentage of account balance enabled
   if (ProfitAsPercentageOfBalance)
   {
      ProfitPercentage=AccountBalance() * (PercentageProfit/100);
      if (AccountProfit()>= ProfitPercentage) CloseOrders=true;
   }

   // Abort routine if profit has not hit the required level
   if (!CloseOrders) return(0);
   
   // Got this far, so orders are to be closed.
   // Code lifted from CloseAll-PL, so thanks to whoever wrote the ea. Ok, so I could
   // have written my own, buy why re-invent the wheel?
   
   int _total=OrdersTotal(); // number of lots or trades  ????
   int _ordertype;// order type   
   if (_total==0) {return;}  // if total==0
   int _ticket; // ticket number
   double _priceClose;// price to close orders;
   for(int _i=_total-1;_i>=0;_i--)
         {  //# for loop
         if (OrderSelect(_i,SELECT_BY_POS))
            { //# if 
            _ordertype=OrderType();
            _ticket=OrderTicket();
            switch(_ordertype)
               {  //# switch
          case OP_BUYLIMIT:
            if(IncludePendingOrdersInClosure) OrderDelete(OrderTicket());
          case OP_BUYSTOP:
            if(IncludePendingOrdersInClosure) OrderDelete(OrderTicket());
          case OP_BUY:
                  // close buy                
                  _priceClose=MarketInfo(OrderSymbol(),MODE_BID);
                  Print("Close on ",_i," position order with ticket ¹",_ticket);
                  OrderClose(_ticket,OrderLots(),_priceClose,3,Red);
                  break;
          case OP_SELLLIMIT:
            if(IncludePendingOrdersInClosure) OrderDelete(OrderTicket());
          case OP_SELLSTOP:
            if(IncludePendingOrdersInClosure) OrderDelete(OrderTicket());
          case OP_SELL:
                  // close sell
                  _priceClose=MarketInfo(OrderSymbol(),MODE_ASK);
                  Print("Close on ",_i," position order with ticket ¹",_ticket);
                  OrderClose(_ticket,OrderLots(),_priceClose,3,Red);
                  break;
               default:
                  // values from  1 to 5, deleting pending orders
   //               Print("Delete on ",_i," position order with ticket ¹",_ticket);
   //               OrderDelete(_ticket);  
                  break;
               }    //# switch
         }  // # if 
   }  // # for loop

   // User feedback
   if (ShowAlerts) Alert("Global profit hit your target, so all open trades should have been closed");
   
} //End of GlobalOrderClosure()

bool ExtractPartCloseVariables()
{
   /*
   This routine extracts the targets at which PartCloseOrder closes part of a position.
   Also tells PartCloseOrder whether the pair is enabled for part-closure.
   Written as a separate function because it is huge, so avoids clutter in PartCloseOrder
   */
   
   bool PairEnabled=false;
   
   if (OrderSymbol()=="EURUSD" || OrderSymbol()=="EURUSDm") 
   {
      TargetAsPrice=EUTargetPrice;
      TargetAsPips=EUTargetPips;
      if(EU) PairEnabled=true;
   }
      
   if (OrderSymbol()=="GBPUSD" || OrderSymbol()=="GBPUSDm") 
   {
      TargetAsPrice=GUTargetPrice;
      TargetAsPips=GUTargetPips;
      if(GU) PairEnabled=true;
   }
      
   if (OrderSymbol()=="USDJPY" || OrderSymbol()=="USDJPYm") 
   {
      TargetAsPrice=UJTargetPrice;
      TargetAsPips=UJTargetPips;
      if(UJ) PairEnabled=true;
   }
      
   if (OrderSymbol()=="USDCHF" || OrderSymbol()=="USDCHFm") 
   {
      TargetAsPrice=UCTargetPrice;
      TargetAsPips=UCTargetPips;
      if(UC) PairEnabled=true;
   }
      
   if (OrderSymbol()=="USDCAD" || OrderSymbol()=="USDCADm") 
   {
      TargetAsPrice=UCadTargetPrice;
      TargetAsPips=UCadTargetPips;
      if(UCad) PairEnabled=true;
   }
      
   if (OrderSymbol()=="AUDUSD" || OrderSymbol()=="AUDUSDm") 
   {
      TargetAsPrice=AUTargetPrice;
      TargetAsPips=AUTargetPips;
      if(AU) PairEnabled=true;
   }
      
   if (OrderSymbol()=="NZDUSD" || OrderSymbol()=="NZDUSDm") 
   {
      TargetAsPrice=NUTargetPrice;
      TargetAsPips=NUTargetPips;
      if(NU) PairEnabled=true;
   }
      
   if (OrderSymbol()=="EURGBP" || OrderSymbol()=="EURGBPm") 
   {
      TargetAsPrice=EGTargetPrice;
      TargetAsPips=EGTargetPips;
      if(EG) PairEnabled=true;
   }
      
   if (OrderSymbol()=="EURJPY" || OrderSymbol()=="EURJPYm") 
   {
      TargetAsPrice=EJTargetPrice;
      TargetAsPips=EJTargetPips;
      if(EJ) PairEnabled=true;
   }
      
   if (OrderSymbol()=="EURCHF" || OrderSymbol()=="EURCHFm") 
   {
      TargetAsPrice=ECTargetPrice;
      TargetAsPips=ECTargetPips;
      if(EC) PairEnabled=true;
   }
      
   if (OrderSymbol()=="GBPJPY" || OrderSymbol()=="GBPJPYm") 
   {
      TargetAsPrice=GJTargetPrice;
      TargetAsPips=GJTargetPips;
      if(GJ) PairEnabled=true;
   }
      
   if (OrderSymbol()=="GBPCHF" || OrderSymbol()=="GBPCHFm") 
   {
      TargetAsPrice=GCTargetPrice;
      TargetAsPips=GCTargetPips;
      if(GC) PairEnabled=true;
   }
      
   if (OrderSymbol()=="AUDJPY" || OrderSymbol()=="AUDJPYm") 
   {
      TargetAsPrice=AJTargetPrice;
      TargetAsPips=AJTargetPips;
      if(AJ) PairEnabled=true;
   }
      
   if (OrderSymbol()=="CHFJPY" || OrderSymbol()=="CHFJPYm") 
   {
      TargetAsPrice=CJTargetPrice;
      TargetAsPips=CJTargetPips;
      if(CJ) PairEnabled=true;
   }
      
   if (OrderSymbol()=="EURCAD" || OrderSymbol()=="EURCADm") 
   {
      TargetAsPrice=ECadTargetPrice;
      TargetAsPips=ECadTargetPips;
      if(ECad) PairEnabled=true;
   }
      
   if (OrderSymbol()=="EURAUD" || OrderSymbol()=="EURAUDm") 
   {
      TargetAsPrice=EATargetPrice;
      TargetAsPips=EATargetPips;
      if(EA) PairEnabled=true;
   }

   if (OrderSymbol()=="AUDCAD" || OrderSymbol()=="AUDCADm") 
   {
      TargetAsPrice=ACTargetPrice;
      TargetAsPips=ACTargetPips;
      if(AC) PairEnabled=true;
   }
      
   if (OrderSymbol()=="AUDNZD" || OrderSymbol()=="AUDNZDm") 
   {
      TargetAsPrice=ANTargetPrice;
      TargetAsPips=ANTargetPips;
      if(AN) PairEnabled=true;
   }
      
   if (OrderSymbol()=="NZDJPY" || OrderSymbol()=="AUDNZDm") 
   {
      TargetAsPrice=NJTargetPrice;
      TargetAsPips=NJTargetPips;
      if(NJ) PairEnabled=true;
   }
      

   return (PairEnabled);

} // End ExtractPartCloseVariables

void PartCloseOrder()
{

   if(!PartCloseEnabled) return(0); // This option has not been selected
   int index=StringFind(OrderComment(), "split from");
   if (index>-1) return(0); // Order already part-closed
   
   // Extract the external part-close variables for this pairing.Put this into 
   //a separate routine to avoid clutter here. Ascertain if this pair is 
   // enabled for partial closure. 
   TargetAsPrice=0;
   TargetAsPips=0;
   bool PairEnabled=ExtractPartCloseVariables();   
   if (!PairEnabled) return(0); // Not wanted on this pair
   if(TargetAsPrice==0 && TargetAsPips==0) return(0); // User entry error

   // Got this far, so pair is enabled, trade is not already split and no user errors, so continue
   int ticket;
   double ProfitTarget;
   double LotsToClose=OrderLots()/2;
   if(!TargetAsPrice==0) ProfitTarget=TargetAsPrice;
         
   if (OrderType()==OP_BUY)
   {
      if(TargetAsPips>0) ProfitTarget=NormalizeDouble(OrderOpenPrice()+(TargetAsPips*point),digits);
      if (bid>=ProfitTarget)
      {         
         ticket=OrderClose(OrderTicket(), LotsToClose,bid,3,CLR_NONE);
         if (ticket>0)
         {
            if(ShowAlerts) Alert("Partial closure on ", OrderSymbol(), ": ticket no ",OrderTicket());
         } 

      }
   }
   
   if (OrderType()==OP_SELL)
   {
      if(TargetAsPips>0) ProfitTarget=NormalizeDouble(OrderOpenPrice()-(TargetAsPips*point),digits);
      if (ask<=ProfitTarget)
      {         
         ticket=OrderClose(OrderTicket(), LotsToClose,ask,3,CLR_NONE);
         if (ticket>0)
         {
            if(ShowAlerts) Alert("Partial closure on ", OrderSymbol(), ": ticket no ",OrderTicket());
         } 

      }
         
   }
   
} // End of PartCloseOrder()

void ManageTrade()
{
     
   // Call the working subroutines one by one. The check for whether the user wants
   // the particular facility is coded at the start of each subroutine.
   
   // Breakeven
   BreakEvenStopLoss();
   
   // JumpingStop
   JumpingStopLoss();
   
   // TrailingStop
   TrailingStopLoss();

   // Trailing stop loss that moves as soon as the market moves in the direction of the trade.
   InstantTrailingStopLoss();

   // Partial order closure at profit point chosen by user
   PartCloseOrder();

} // End of ManageTrade()


