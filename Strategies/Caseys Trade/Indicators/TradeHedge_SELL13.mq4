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



   OrderSend("EURJPY",OP_SELL, Lot, MarketInfo("EURJPY",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("GBPUSD",OP_SELL, Lot, MarketInfo("GBPUSD",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("EURGBP",OP_SELL, Lot, MarketInfo("EURGBP",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("GBPCHF",OP_SELL, Lot, MarketInfo("GBPCHF",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("CHFJPY",OP_SELL, Lot, MarketInfo("CHFJPY",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("USDCHF",OP_BUY, Lot, MarketInfo("USDCHF",MODE_ASK), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("AUDJPY",OP_SELL, Lot, MarketInfo("AUDJPY",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);

   OrderSend("USDJPY",OP_SELL, Lot, MarketInfo("USDJPY",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("EURUSD",OP_SELL, Lot, MarketInfo("EURUSD",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("EURCHF",OP_SELL, Lot, MarketInfo("EURCHF",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("GBPJPY",OP_SELL, Lot, MarketInfo("GBPJPY",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("USDCAD",OP_SELL, Lot, MarketInfo("USDCAD",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("CADJPY",OP_SELL, Lot, MarketInfo("CADJPY",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   OrderSend("AUDUSD",OP_SELL, Lot, MarketInfo("AUDUSD",MODE_BID), 2, NULL, NULL, NULL, 0, 0, CLR_NONE);
   
   return(0);
  }
//+----------------------------------------------------------------------------------------------------+