//+-------------------------------------------------------------------------------------+
//|                                                             DSM_FootStep_Expert.mq4 |
//|                                                                           Scriptong |
//|                                                                   scriptong@mail.ru |
//+-------------------------------------------------------------------------------------+
#property copyright "Scriptong"
#property link      "scriptong@mail.ru"


//---- input parameters
extern string V_R = "Время работы";  
extern bool      use_work_time = false;  
extern int       Start = 0;  
extern int       Stop = 24;  
extern int       TakeProfit = 2000;
extern int       StopLoss = 2000;
extern double    Lots = 0.1;
extern string    A1 = "Параметры индикатора DSM";
extern int       AppliedPrice = 0; //По какой цене считать. 4 - H+L/2
extern int       MAperiod = 34;
extern int       Setting = 1;
extern int       iShift = 0;
extern string    A2 = "==================================";
extern string    A3 = "Количество ступеней назад для входа в рынок";
extern double        BackFootSteps = 1;
extern string    A4 = "==================================";
extern string    A5 = "Сколько ступеней считается трендом";
extern int       TrendFootSteps = 2;
extern string    A6 = "==================================";

extern string    OpenOrderSound = "ok.wav";
extern int       MagicNumber = 10002;

bool Activate, FreeMarginAlert, FatalError, IsClose;
double Tick, Spread, StopLevel, MinLot, MaxLot, LotStep, TickSet, Price, BLPrice, 
       SLPrice, BuyTP, SellTP, FreezeLevel;
int Signal, BuyLimitTicket, SellLimitTicket, LastDir, BuyTicket, SellTicket, BB;
datetime LastBar = 0;

//+-------------------------------------------------------------------------------------+
//| expert initialization function                                                      |
//+-------------------------------------------------------------------------------------+
int init()
  {
   FatalError = False;
   Activate = False;
   IsClose = False;
// - 1 - == Сбор информации об условиях торговли ========================================   
   Tick = MarketInfo(Symbol(), MODE_TICKSIZE);                         // минимальный тик    
   Spread = ND(MarketInfo(Symbol(), MODE_SPREAD)*Point);                 // текущий спрэд
   StopLevel = ND(MarketInfo(Symbol(), MODE_STOPLEVEL)*Point);  // текущий уровень стопов 
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);    // минимальный разрешенный объем сделки
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);   // максимальный разрешенный объем сделки
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);          // шаг приращения объема сделки
   TickSet = Tick*MathPow(10, Setting);       // До скольки тиков идет округление средней 
   FreezeLevel = ND(MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point);   // Уровень заморозки
// - 1 - == Окончание блока =============================================================

// - 2 - == Приведение объема сделки к допустимому и проверка корректности объема =======   
   Lots = MathRound(Lots/LotStep)*LotStep; // округление объема до ближайшего допустимого
   if(Lots < MinLot || Lots > MaxLot) // объем сделки не меньше MinLot и не больше MaxLot
     {
      Comment("Параметром Lots был задан неправильный объем сделки! Советник отключен!");
      return(0);
     }
// - 2 - == Окончание блока =============================================================

// - 3 - == Проверка корректности входных параметров ====================================   
   if (TakeProfit <= StopLevel/Point && TakeProfit != 0)
     {
      Comment("Значение параметра TakeProfit должно быть больше ", StopLevel/Point, 
              " пунктов.");
      Print("Значение параметра TakeProfit должно быть больше ", StopLevel/Point,
            " пунктов.");
      return(0);
     }
     
   if (StopLoss <= (StopLevel+Spread)/Point && StopLoss != 0)
     {
      Comment("Значение параметра StopLoss должно быть больше ",(StopLevel+Spread)/Point,
              " пунктов.");
      Print("Значение параметра StopLoss должно быть больше ", (StopLevel+Spread)/Point,
            " пунктов.");
      return(0);
     }  
   if (BackFootSteps < 0)
     {
      Comment("BackFootSteps должен быть положительным! Советник отключен!");
      Print("BackFootSteps должен быть положительным! Советник отключен!");
      return(0);
     }
   if (TrendFootSteps < 1)
     {
      Comment("TrendFootSteps должен быть 1 и больше! Советник отключен!");
      Print("TrendFootSteps должен быть 1 и больше! Советник отключен!");
      return(0);
     }
// - 3 - == Окончание блока =============================================================
    
   Activate = True;
   
//----
   return(0);
  }
//+-------------------------------------------------------------------------------------+
//| expert deinitialization function                                                    |
//+-------------------------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
  
//+-------------------------------------------------------------------------------------+
//| Приведение значений к точности одного тика                                          |
//+-------------------------------------------------------------------------------------+
double ND(double A)
{
 return(NormalizeDouble(A, Digits));
}  

//+-------------------------------------------------------------------------------------+
//| Расшифровка сообщения об ошибке                                                     |
//+-------------------------------------------------------------------------------------+
string ErrorToString(int Error)
{
 switch(Error)
   {
    case 2: return("зафиксирована общая ошибка, обратитесь в техподдержку."); 
    case 5: return("у вас старая версия терминала, обновите ее."); 
    case 6: return("нет связи с сервером, попробуйте перезагрузить терминал."); 
    case 64: return("счет заблокирован, обратитесь в техподдержку.");
    case 132: return("рынок закрыт."); 
    case 133: return("торговля запрещена."); 
    case 149: return("запрещено локирование."); 
   }
}

//+-------------------------------------------------------------------------------------+
//| Ожидание торгового потока. Если поток свободен, то результат True, иначе - False    |
//+-------------------------------------------------------------------------------------+  
bool WaitForTradeContext()
{
 int P = 0;
 // цикл "пока"
 while(IsTradeContextBusy() && P < 5)
   {
    P++;
    Sleep(1000);
   }
 // -------------  
 if(P == 5)
   return(False);
 return(True);    
}
  
//+-------------------------------------------------------------------------------------+
//| "Правильное" открытие позиции                                                       |
//| В отличие от OpenOrder проверяет соотношение текущих уровней и устанавливаемых      |
//| Возвращает:                                                                         |
//|   0 - нет ошибок                                                                    |
//|   1 - Ошибка открытия                                                               |
//|   2 - Ошибка значения Price                                                         |
//|   3 - Ошибка значения SL                                                            |
//|   4 - Ошибка значения TP                                                            |
//|   5 - Ошибка значения Lot                                                           |
//+-------------------------------------------------------------------------------------+
int OpenOrderCorrect(int Type, double Price, double SL, double TP, 
                     bool Redefinition = True)
// Redefinition - при True доопределять параметры до минимально допустимых
//                при False - возвращать ошибку
{
// - 1 - == Проверка достаточности свободных средств ====================================
 if(AccountFreeMarginCheck(Symbol(), OP_BUY, Lots) <= 0 || GetLastError() == 134) 
  {
   if(!FreeMarginAlert)
    {
     Print("Недостаточно средств для открытия позиции. Free Margin = ", 
           AccountFreeMargin());
     FreeMarginAlert = True;
    } 
   return(5);  
  }
 FreeMarginAlert = False;  
// - 1 - == Окончание блока =============================================================

// - 2 - == Корректировка значений Price, SL и TP или возврат ошибки ====================   

 RefreshRates();
 switch (Type)
   {
    case OP_BUY: 
                string S = "BUY"; 
                if (MathAbs(Price-Ask)/Point > 3)
                  if (Redefinition) Price = ND(Ask);
                  else              return(2);
                if (ND(TP-Bid) < StopLevel && TP != 0)
                  if (Redefinition) TP = ND(Bid+StopLevel);
                  else              return(4);
                if (ND(Bid-SL) < StopLevel)
                  if (Redefinition) SL = ND(Bid-StopLevel);
                  else              return(3);
                break;
    case OP_SELL: 
                 S = "SELL"; 
                 if (MathAbs(Price-Bid)/Point > 3)
                   if (Redefinition) Price = ND(Bid);
                   else              return(2);
                 if (ND(Ask-TP) < StopLevel) 
                   if (Redefinition) TP = ND(Ask-StopLevel);
                   else              return(4);
                 if (ND(SL-Ask) < StopLevel && SL != 0)
                   if (Redefinition) SL = ND(Ask+StopLevel);
                   else              return(3);
                 break;
    case OP_BUYSTOP: 
                    S = "BUYSTOP";
                    if (ND(Price-Ask) < StopLevel)
                      if (Redefinition) Price = ND(Ask+StopLevel);
                      else              return(2);
                    if (ND(TP-Price) < StopLevel && TP != 0)
                      if (Redefinition) TP = ND(Price+StopLevel);
                      else              return(4);
                    if (ND(Price-SL) < StopLevel)
                      if (Redefinition) SL = ND(Price-StopLevel);
                      else              return(3);
                    break;
    case OP_SELLSTOP: 
                     S = "SELLSTOP";
                     if (ND(Bid-Price) < StopLevel)
                       if (Redefinition) Price = ND(Bid-StopLevel);
                       else              return(2);
                     if (ND(Price-TP) < StopLevel)
                       if (Redefinition) TP = ND(Price-StopLevel);
                       else              return(4);
                     if (ND(SL-Price) < StopLevel && SL != 0)
                       if (Redefinition) SL = ND(Price+StopLevel);
                       else              return(3);
                     break;
    case OP_BUYLIMIT: 
                     S = "BUYLIMIT";
                     if (ND(Ask-Price) < StopLevel)
                      if (Redefinition) Price = ND(Ask-StopLevel);
                      else              return(2);
                     if (ND(TP-Price) < StopLevel && TP != 0)
                       if (Redefinition) TP = ND(Price+StopLevel);
                       else              return(4);
                     if (ND(Price-SL) < StopLevel)
                       if (Redefinition) SL = ND(Price-StopLevel);
                       else              return(3);
                     break;
    case OP_SELLLIMIT: 
                     S = "SELLLIMIT";
                     if (ND(Price - Bid) < StopLevel) 
                       if (Redefinition) Price = ND(Bid+StopLevel);
                       else              return(2);
                     if (ND(Price-TP) < StopLevel)
                       if (Redefinition) TP = ND(Price-StopLevel);
                       else              return(4);
                     if (ND(SL-Price) < StopLevel && SL != 0)
                       if (Redefinition) SL = ND(Price+StopLevel);
                       else              return(3);
                     break;
   }
// - 2 - == Окончание блока =============================================================
 
// - 3 - == Открытие ордера с ожидание торгового потока =================================   
 if(WaitForTradeContext())  // ожидание освобождения торгового потока
   {  
    Comment("Отправлен запрос на открытие ордера ", S, " ...");  
    int ticket=OrderSend(Symbol(), Type, Lots, Price, 3, 
               SL, TP, NULL, MagicNumber, 0);// открытие позиции
    // Попытка открытия позиции завершилась неудачей
    if(ticket<0)
      {
       int Error = GetLastError();
       if(Error == 2 || Error == 5 || Error == 6 || Error == 64 
          || Error == 132 || Error == 133 || Error == 149)     // список фатальных ошибок
         {
          Comment("Фатальная ошибка при открытии позиции т. к. "+
                   ErrorToString(Error)+" Советник отключен!");
          FatalError = True;
         }
        else 
         Comment("Ошибка открытия позиции ", S, ": ", Error);       // нефатальная ошибка
       return(1);
      }
    // ---------------------------------------------
    
    // Удачное открытие позиции   
    Comment("Позиция ", S, " открыта успешно!"); 
    PlaySound(OpenOrderSound); 
    return(0); 
    // ------------------------
   }
  else
   {
    Comment("Время ожидания освобождения торгового потока истекло!");
    return(1);  
   } 
// - 3 - == Окончание блока =============================================================  
}

//+-------------------------------------------------------------------------------------+
//| Расчет значений DSM и ценовых уровней входа                                         |
//+-------------------------------------------------------------------------------------+
void GetSignal()
{
 Signal = 0;
// - 1 - ========= Поиск TrendFootSteps ступеней подряд =================================
 double DSMCur = MathRound(iMA(Symbol(), 0, MAperiod, iShift, MODE_EMA, AppliedPrice, 1)
                           /TickSet)*TickSet;                   // Ближайшее значение DSM
 double DSMMin = DSMCur, DSMMax = DSMCur;                           
 for (int i = 2; i < Bars && MathAbs(Signal) < TrendFootSteps; i++)
   { 
    double DSMPrev = MathRound(iMA(Symbol(), 0, MAperiod, iShift, MODE_EMA, AppliedPrice,
                                   i)/TickSet)*TickSet;        // предыдущее значение DSM
    if (DSMPrev - DSMCur >= Tick)    // Предыдущее значение DSM больше текущего - падение
      {
       if (Signal > 0)                        // Сбрасываем значение Signal в нейтральное
         Signal = 0;                                   
       Signal--;
      } 
    if (DSMCur - DSMPrev >= Tick)    // Предыдущее значение DSM меньше текущего - падение
      {
       if (Signal < 0)                        // Сбрасываем значение Signal в нейтральное
         Signal = 0;                                
       Signal++;
      } 
    DSMCur = DSMPrev;                       // Предыдущее значение DSM становится текущим
    DSMMin = MathMin(DSMCur, DSMMin);               // Отслеживание минимального значения
    DSMMax = MathMax(DSMCur, DSMMax);              // Отслеживание максимального значения
   }
// - 1 - == Окончание блока =============================================================

// - 2 - ========================== Расчет цены открытия ордера =========================
 if (i == Bars) return;

 if (Signal == TrendFootSteps)
   Price = ND(DSMMax - BackFootSteps*TickSet + Spread);  // Цена открытия длинной позиции

 if (Signal == -TrendFootSteps)
   Price = ND(DSMMin + BackFootSteps*TickSet);          // Цена открытия короткой позиции
// - 2 - == Окончание блока =============================================================
}

//+-------------------------------------------------------------------------------------+
//| Мониторинг своих ордеров                                                            |
//+-------------------------------------------------------------------------------------+
void OwnOrders()
{
// - 1 - =============== Нахождение своей сделки ========================================
 BuyLimitTicket = -1; SellLimitTicket = -1;
 BuyTicket = -1; SellTicket = -1;
 for (int i = 0; i < OrdersTotal(); i++)
   if (OrderSelect(i, SELECT_BY_POS))
     if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
// - 1 - =============== Окончание блока ================================================
       {        
// - 2 - =============== Обработка позиций ==============================================
        if (OrderType() < 2)
          {
           LastDir = OrderType();                                      
           if (OrderType() == OP_BUY)
             {
              BuyTicket = OrderTicket();
              BuyTP = OrderTakeProfit();
             } 
            else
             {
              SellTicket = OrderTicket();
              SellTP = OrderTakeProfit();
             } 
          }
// - 2 - =============== Окончание блока ================================================
         else
// - 3 - =============== Обработка ордеров ==============================================
          if (OrderType() == OP_BUYLIMIT)
            {
             BuyLimitTicket = OrderTicket();
             BLPrice = OrderOpenPrice();
            } 
           else
            if (OrderType() == OP_SELLLIMIT)
              {
               SellLimitTicket = OrderTicket();  
               SLPrice = OrderOpenPrice();
              } 
// - 3 - =============== Окончание блока ================================================
       }   
}  

//+-------------------------------------------------------------------------------------+
//| Удаление ордера с указанным тикетом                                                 |
//+-------------------------------------------------------------------------------------+
void DeleteOrder(int Ticket)
{
 if (WaitForTradeContext())
   if (OrderSelect(Ticket, SELECT_BY_TICKET))
     if ((OrderType() == OP_BUYLIMIT && Ask - OrderOpenPrice() > FreezeLevel) ||
         (OrderType() == OP_SELLLIMIT && OrderOpenPrice() - Bid > FreezeLevel))
       OrderDelete(Ticket);
}

//+-------------------------------------------------------------------------------------+
//| Установка ордера Sell Limit                                                         |
//+-------------------------------------------------------------------------------------+
bool SellLimit()
{
// - 1 - =========== Изменение профита существующей длинной позиции =====================
 if (BuyTicket > 0 && MathAbs(BuyTP - Price) >= Tick && Price - Bid > StopLevel)
   {
    if (WaitForTradeContext())
      if (OrderSelect(BuyTicket, SELECT_BY_TICKET))
        OrderModify(BuyTicket, 0, OrderStopLoss(), Price, 0);
    return(False);  // В любом случае вернем False, так как еще не все операции выполнены
   } 
// - 1 - =========== Окончание блока ====================================================
  else
   if (LastDir != 1)                                // Последняя позиция была не короткая
     {
// - 2 - =========== В случае существования ордера BuyLimit удаляем его =================
      if (BuyLimitTicket > 0) 
        {
         DeleteOrder(BuyLimitTicket);
         return(False);      // Снова вернем False, так как еще не все операции выполнены
        }  
// - 2 - =========================== Окончание блока ====================================
      RefreshRates();
// - 3 - =========== Если существует Sell Limit, то просто изменим его параметры ========
      if (SellLimitTicket > 0)
        {
         if (MathAbs(SLPrice - Price) >= Tick) // Цена открытия Sell Limit не равна новой
           {
            double SL = ND(Price + StopLoss*Tick);               
            double TP = ND(Price - TakeProfit*Tick);
            if (Price - Bid  > StopLevel)
              if (!OrderModify(SellLimitTicket, Price, SL, TP, 0))
                return(False);
           }     
        }
// - 3 - =========================== Окончание блока ====================================
       else
// - 4 - =========== Если нет позиций и ордеров, то устанавливаем Sell Limit ============
        {
         SL = ND(Price + StopLoss*Tick);               
         TP = ND(Price - TakeProfit*Tick);
         if (OpenOrderCorrect(OP_SELLLIMIT, Price, SL, TP, False) != 0)//открытие позиции
           return(False);               //если не удалось открыть, то попытка переносится
        } 
     }
// - 4 - =========================== Окончание блока ====================================
 return(True);                                                  // Все операции выполнены
}

//+-------------------------------------------------------------------------------------+
//| Установка ордера Buy Limit                                                          |
//+-------------------------------------------------------------------------------------+
bool BuyLimit()
{
// - 1 - =========== Изменение профита существующей короткой позиции ====================
  if (SellTicket > 0 && MathAbs(SellTP - Price) >= Tick && Ask - Price > StopLevel)
    {
     if (WaitForTradeContext())
       if (OrderSelect(SellTicket, SELECT_BY_TICKET))
         OrderModify(SellTicket, 0, OrderStopLoss(), Price, 0);
     return(False); // В любом случае вернем False, так как еще не все операции выполнены
    }
// - 1 - =========== Окончание блока ====================================================
  else
   if (LastDir != 0)                                 // Последняя позиция была не длинная
     {
// - 2 - =========== В случае существования ордера SellLimit удаляем его ================
      if (SellLimitTicket > 0) 
        {
         DeleteOrder(SellLimitTicket);
         return(False);      // Снова вернем False, так как еще не все операции выполнены
        } 
// - 2 - =========================== Окончание блока ====================================
      RefreshRates();
// - 3 - =========== Если существует Buy Limit, то просто изменим его параметры =========
      if (BuyLimitTicket > 0)
        {
         if (MathAbs(BLPrice - Price) >= Tick)
           {
            double SL = ND(Price - StopLoss*Tick);               
            double TP = ND(Price + TakeProfit*Tick);
            if (Ask - Price > StopLevel)
              if (!OrderModify(BuyLimitTicket, Price, SL, TP, 0))
                return(False);
           }     
        }
// - 3 - =========================== Окончание блока ====================================
       else
// - 4 - =========== Если нет позиций и ордеров, то устанавливаем Buy Limit =============
        {
         SL = ND(Price - StopLoss*Tick);               
         TP = ND(Price + TakeProfit*Tick);
         if (OpenOrderCorrect(OP_BUYLIMIT, Price, SL, TP, False) != 0) //открытие позиции
           return(False);               //если не удалось открыть, то попытка переносится
        } 
     }
// - 4 - =========================== Окончание блока ====================================
 return(True);                                                  // Все операции выполнены
}
 
//+-------------------------------------------------------------------------------------+
//| Функция START эксперта                                                              |
//+-------------------------------------------------------------------------------------+
int start()
  {
  //фильтр время  
 if(use_work_time)  
 {  
  if(Start>Stop)  
 {  
 if(Hour()>=Stop && Hour()<Start) return;  
 }  
   
 if(Start<Stop)  
 {  
 if(Hour()<Start || Hour()>=Stop) return;  
 }  
 } 
// - 1 -  == Разрешено ли советнику работать? ===========================================
   if (!Activate || FatalError)             // Отключается работа советника, если функция
    return(0);           //  init завершилась с ошибкой  или имела место фатальная ошибка
// - 1 -  == Окончание блока ============================================================
     
// - 2 - == Сбор информации об условиях торговли ========================================
   Spread = ND(MarketInfo(Symbol(), MODE_SPREAD)*Point);                 // текущий спрэд
   StopLevel = ND(MarketInfo(Symbol(), MODE_STOPLEVEL)*Point);  // текущий уровень стопов 
   FreezeLevel = ND(MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point);   // Уровень заморозки
// - 2 -  == Окончание блока ============================================================

// - 3 - ======== Обработка существующей позиции и контроль открытия нового бара ========
   if (LastBar == Time[0])
     return(0);
// - 3 -  == Окончание блока ============================================================

// - 4 - ======================== Расчет сигнала и мониторинг своих ордеров =============
   GetSignal();
   OwnOrders();
// - 4 -  == Окончание блока ============================================================

// - 5 - ============================== Установка ордеров ===============================
   if (Signal == -TrendFootSteps)                                // Откладываем SELLLIMIT
     if (!SellLimit())
       return(0);

   if (Signal == TrendFootSteps)                                  // Откладываем BUYLIMIT
     if (!BuyLimit())
       return(0);
// - 5 -  == Окончание блока ============================================================

   LastBar = Time[0];

   return(0);
  }

