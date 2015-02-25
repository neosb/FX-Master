//+------------------------------------------------------------------+
//|                                        Market Short by Steve.mq4 |
//|                  Based on code by David J. Lin, so thanks, David |
//| NOTE: Here, the stoploss is based on Bid for fast moving markets |
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
//----
   if(TpAsPips==0 && TpAsPrice==0) takeprofit=0;
   if (!TpAsPips==0) takeprofit=NormalizeDouble(Ask+TpAsPips*Point,Digits);
   if (!TpAsPrice==0) takeprofit=TpAsPrice;
   
   if (SlAsPips==0 && SlAsPrice) stoploss=0;
   if (!SlAsPips==0) stoploss=NormalizeDouble(Bid-SlAsPips*Point,Digits);
   if (!SlAsPrice==0) stoploss=SlAsPrice;
   
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,0,stoploss,takeprofit,TradeComment,MagicNumber,0,Green);
   
//----
   OrderPrint();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+