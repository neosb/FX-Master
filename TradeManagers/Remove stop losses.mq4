//+------------------------------------------------------------------+
//|                                           Remove stop losses.mq4 |
//|                                  Copyright © 2008, Steve Hopwood |
//|                              http://www.hopwood3.freeserve.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Steve Hopwood"
#property link      "http://www.hopwood3.freeserve.co.uk"
#include <WinUser32.mqh>
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----

   if (OrdersTotal()==0) return(0);
   
   for (int cnt=0;cnt<OrdersTotal();cnt++)
   { 
      OrderSelect(cnt, SELECT_BY_POS); 
      int ticket = OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderTakeProfit(),0,CLR_NONE);
            
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+