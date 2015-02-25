//+------------------------------------------------------------------+
//|                                        Market Short by Steve.mq4 |
//|                  Based on code by David J. Lin, so thanks, David |
//| NOTE: Here, the stoploss is based on Ask for fast moving markets |
//| The true stoploss value is SL + the spread at time of execution  |
//|                                                                  |
//| www.hopwood3.freeserve.co.uk                                     |
//+------------------------------------------------------------------+
#property copyright "Steve Hopwood"
#property link      ""
#property show_inputs

extern double  Lots=0.01;
extern string  ins1="Stop loss and take profit as price";    
extern double  SlAsPrice;
extern double  TpAsPrice;
extern string  ins2="Stop loss and take profit as pips";    
extern int     SlAsPips=0;
extern int     TpAsPips=0;
extern int     MagicNumber=274693;
extern string  TradeComment = "";


double takeprofit,stoploss;
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   if (TpAsPrice==0 && TpAsPips==0) takeprofit=0;
   if (!TpAsPips==0) takeprofit=NormalizeDouble(Bid-TpAsPips*Point,Digits);
   if (!TpAsPrice==0) takeprofit=TpAsPrice;
   
   if (SlAsPrice==0 && SlAsPips==0) stoploss=0;
   if (!SlAsPips==0) stoploss=NormalizeDouble(Ask+SlAsPips*Point,Digits); 
   if (!SlAsPrice==0) stoploss=SlAsPrice;
   
//----
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,0,stoploss,takeprofit,TradeComment,MagicNumber,0,CLR_NONE);
   
//----
   OrderPrint();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+