//+------------------------------------------------------------------+
//|                                                   TradeHedge.mq4 |
//|                                      Copyright © 2008, Trader101 |
//|                                          trader101@optonline.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Trader101"
#property link      "trader101@optonline.net"

#property show_inputs
extern double Lot = 0.1;



//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {



   OrderSend("EURJPY",OP_BUY, Lot, MarketInfo("EURJPY",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("GBPUSD",OP_BUY, Lot, MarketInfo("GBPUSD",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("EURGBP",OP_BUY, Lot, MarketInfo("EURGBP",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("GBPCHF",OP_BUY, Lot, MarketInfo("GBPCHF",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("CHFJPY",OP_BUY, Lot, MarketInfo("CHFJPY",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("USDCHF",OP_SELL, Lot, MarketInfo("USDCHF",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("AUDJPY",OP_BUY, Lot, MarketInfo("AUDJPY",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);

   OrderSend("USDJPY",OP_BUY, Lot, MarketInfo("USDJPY",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("EURUSD",OP_BUY, Lot, MarketInfo("EURUSD",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("EURCHF",OP_BUY, Lot, MarketInfo("EURCHF",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("GBPJPY",OP_BUY, Lot, MarketInfo("GBPJPY",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("USDCAD",OP_BUY, Lot, MarketInfo("USDCAD",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("CADJPY",OP_BUY, Lot, MarketInfo("CADJPY",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("AUDUSD",OP_BUY, Lot, MarketInfo("AUDUSD",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   
   return(0);
  }
//+----------------------------------------------------------------------------------------------------+