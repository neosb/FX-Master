//+-------------------------------------------------------------------------------------+
//|                                                             DSM_FootStep_Expert.mq4 |
//|                                                                           Scriptong |
//|                                                                   scriptong@mail.ru |
//+-------------------------------------------------------------------------------------+
#property copyright "Scriptong"
#property link      "scriptong@mail.ru"


//---- input parameters
extern string V_R = "����� ������";  
extern bool      use_work_time = false;  
extern int       Start = 0;  
extern int       Stop = 24;  
extern int       TakeProfit = 2000;
extern int       StopLoss = 2000;
extern double    Lots = 0.1;
extern string    A1 = "��������� ���������� DSM";
extern int       AppliedPrice = 0; //�� ����� ���� �������. 4 - H+L/2
extern int       MAperiod = 34;
extern int       Setting = 1;
extern int       iShift = 0;
extern string    A2 = "==================================";
extern string    A3 = "���������� �������� ����� ��� ����� � �����";
extern double        BackFootSteps = 1;
extern string    A4 = "==================================";
extern string    A5 = "������� �������� ��������� �������";
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
// - 1 - == ���� ���������� �� �������� �������� ========================================   
   Tick = MarketInfo(Symbol(), MODE_TICKSIZE);                         // ����������� ���    
   Spread = ND(MarketInfo(Symbol(), MODE_SPREAD)*Point);                 // ������� �����
   StopLevel = ND(MarketInfo(Symbol(), MODE_STOPLEVEL)*Point);  // ������� ������� ������ 
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);    // ����������� ����������� ����� ������
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);   // ������������ ����������� ����� ������
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);          // ��� ���������� ������ ������
   TickSet = Tick*MathPow(10, Setting);       // �� ������� ����� ���� ���������� ������� 
   FreezeLevel = ND(MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point);   // ������� ���������
// - 1 - == ��������� ����� =============================================================

// - 2 - == ���������� ������ ������ � ����������� � �������� ������������ ������ =======   
   Lots = MathRound(Lots/LotStep)*LotStep; // ���������� ������ �� ���������� �����������
   if(Lots < MinLot || Lots > MaxLot) // ����� ������ �� ������ MinLot � �� ������ MaxLot
     {
      Comment("���������� Lots ��� ����� ������������ ����� ������! �������� ��������!");
      return(0);
     }
// - 2 - == ��������� ����� =============================================================

// - 3 - == �������� ������������ ������� ���������� ====================================   
   if (TakeProfit <= StopLevel/Point && TakeProfit != 0)
     {
      Comment("�������� ��������� TakeProfit ������ ���� ������ ", StopLevel/Point, 
              " �������.");
      Print("�������� ��������� TakeProfit ������ ���� ������ ", StopLevel/Point,
            " �������.");
      return(0);
     }
     
   if (StopLoss <= (StopLevel+Spread)/Point && StopLoss != 0)
     {
      Comment("�������� ��������� StopLoss ������ ���� ������ ",(StopLevel+Spread)/Point,
              " �������.");
      Print("�������� ��������� StopLoss ������ ���� ������ ", (StopLevel+Spread)/Point,
            " �������.");
      return(0);
     }  
   if (BackFootSteps < 0)
     {
      Comment("BackFootSteps ������ ���� �������������! �������� ��������!");
      Print("BackFootSteps ������ ���� �������������! �������� ��������!");
      return(0);
     }
   if (TrendFootSteps < 1)
     {
      Comment("TrendFootSteps ������ ���� 1 � ������! �������� ��������!");
      Print("TrendFootSteps ������ ���� 1 � ������! �������� ��������!");
      return(0);
     }
// - 3 - == ��������� ����� =============================================================
    
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
//| ���������� �������� � �������� ������ ����                                          |
//+-------------------------------------------------------------------------------------+
double ND(double A)
{
 return(NormalizeDouble(A, Digits));
}  

//+-------------------------------------------------------------------------------------+
//| ����������� ��������� �� ������                                                     |
//+-------------------------------------------------------------------------------------+
string ErrorToString(int Error)
{
 switch(Error)
   {
    case 2: return("������������� ����� ������, ���������� � ������������."); 
    case 5: return("� ��� ������ ������ ���������, �������� ��."); 
    case 6: return("��� ����� � ��������, ���������� ������������� ��������."); 
    case 64: return("���� ������������, ���������� � ������������.");
    case 132: return("����� ������."); 
    case 133: return("�������� ���������."); 
    case 149: return("��������� �����������."); 
   }
}

//+-------------------------------------------------------------------------------------+
//| �������� ��������� ������. ���� ����� ��������, �� ��������� True, ����� - False    |
//+-------------------------------------------------------------------------------------+  
bool WaitForTradeContext()
{
 int P = 0;
 // ���� "����"
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
//| "����������" �������� �������                                                       |
//| � ������� �� OpenOrder ��������� ����������� ������� ������� � ���������������      |
//| ����������:                                                                         |
//|   0 - ��� ������                                                                    |
//|   1 - ������ ��������                                                               |
//|   2 - ������ �������� Price                                                         |
//|   3 - ������ �������� SL                                                            |
//|   4 - ������ �������� TP                                                            |
//|   5 - ������ �������� Lot                                                           |
//+-------------------------------------------------------------------------------------+
int OpenOrderCorrect(int Type, double Price, double SL, double TP, 
                     bool Redefinition = True)
// Redefinition - ��� True ������������ ��������� �� ���������� ����������
//                ��� False - ���������� ������
{
// - 1 - == �������� ������������� ��������� ������� ====================================
 if(AccountFreeMarginCheck(Symbol(), OP_BUY, Lots) <= 0 || GetLastError() == 134) 
  {
   if(!FreeMarginAlert)
    {
     Print("������������ ������� ��� �������� �������. Free Margin = ", 
           AccountFreeMargin());
     FreeMarginAlert = True;
    } 
   return(5);  
  }
 FreeMarginAlert = False;  
// - 1 - == ��������� ����� =============================================================

// - 2 - == ������������� �������� Price, SL � TP ��� ������� ������ ====================   

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
// - 2 - == ��������� ����� =============================================================
 
// - 3 - == �������� ������ � �������� ��������� ������ =================================   
 if(WaitForTradeContext())  // �������� ������������ ��������� ������
   {  
    Comment("��������� ������ �� �������� ������ ", S, " ...");  
    int ticket=OrderSend(Symbol(), Type, Lots, Price, 3, 
               SL, TP, NULL, MagicNumber, 0);// �������� �������
    // ������� �������� ������� ����������� ��������
    if(ticket<0)
      {
       int Error = GetLastError();
       if(Error == 2 || Error == 5 || Error == 6 || Error == 64 
          || Error == 132 || Error == 133 || Error == 149)     // ������ ��������� ������
         {
          Comment("��������� ������ ��� �������� ������� �. �. "+
                   ErrorToString(Error)+" �������� ��������!");
          FatalError = True;
         }
        else 
         Comment("������ �������� ������� ", S, ": ", Error);       // ����������� ������
       return(1);
      }
    // ---------------------------------------------
    
    // ������� �������� �������   
    Comment("������� ", S, " ������� �������!"); 
    PlaySound(OpenOrderSound); 
    return(0); 
    // ------------------------
   }
  else
   {
    Comment("����� �������� ������������ ��������� ������ �������!");
    return(1);  
   } 
// - 3 - == ��������� ����� =============================================================  
}

//+-------------------------------------------------------------------------------------+
//| ������ �������� DSM � ������� ������� �����                                         |
//+-------------------------------------------------------------------------------------+
void GetSignal()
{
 Signal = 0;
// - 1 - ========= ����� TrendFootSteps �������� ������ =================================
 double DSMCur = MathRound(iMA(Symbol(), 0, MAperiod, iShift, MODE_EMA, AppliedPrice, 1)
                           /TickSet)*TickSet;                   // ��������� �������� DSM
 double DSMMin = DSMCur, DSMMax = DSMCur;                           
 for (int i = 2; i < Bars && MathAbs(Signal) < TrendFootSteps; i++)
   { 
    double DSMPrev = MathRound(iMA(Symbol(), 0, MAperiod, iShift, MODE_EMA, AppliedPrice,
                                   i)/TickSet)*TickSet;        // ���������� �������� DSM
    if (DSMPrev - DSMCur >= Tick)    // ���������� �������� DSM ������ �������� - �������
      {
       if (Signal > 0)                        // ���������� �������� Signal � �����������
         Signal = 0;                                   
       Signal--;
      } 
    if (DSMCur - DSMPrev >= Tick)    // ���������� �������� DSM ������ �������� - �������
      {
       if (Signal < 0)                        // ���������� �������� Signal � �����������
         Signal = 0;                                
       Signal++;
      } 
    DSMCur = DSMPrev;                       // ���������� �������� DSM ���������� �������
    DSMMin = MathMin(DSMCur, DSMMin);               // ������������ ������������ ��������
    DSMMax = MathMax(DSMCur, DSMMax);              // ������������ ������������� ��������
   }
// - 1 - == ��������� ����� =============================================================

// - 2 - ========================== ������ ���� �������� ������ =========================
 if (i == Bars) return;

 if (Signal == TrendFootSteps)
   Price = ND(DSMMax - BackFootSteps*TickSet + Spread);  // ���� �������� ������� �������

 if (Signal == -TrendFootSteps)
   Price = ND(DSMMin + BackFootSteps*TickSet);          // ���� �������� �������� �������
// - 2 - == ��������� ����� =============================================================
}

//+-------------------------------------------------------------------------------------+
//| ���������� ����� �������                                                            |
//+-------------------------------------------------------------------------------------+
void OwnOrders()
{
// - 1 - =============== ���������� ����� ������ ========================================
 BuyLimitTicket = -1; SellLimitTicket = -1;
 BuyTicket = -1; SellTicket = -1;
 for (int i = 0; i < OrdersTotal(); i++)
   if (OrderSelect(i, SELECT_BY_POS))
     if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
// - 1 - =============== ��������� ����� ================================================
       {        
// - 2 - =============== ��������� ������� ==============================================
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
// - 2 - =============== ��������� ����� ================================================
         else
// - 3 - =============== ��������� ������� ==============================================
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
// - 3 - =============== ��������� ����� ================================================
       }   
}  

//+-------------------------------------------------------------------------------------+
//| �������� ������ � ��������� �������                                                 |
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
//| ��������� ������ Sell Limit                                                         |
//+-------------------------------------------------------------------------------------+
bool SellLimit()
{
// - 1 - =========== ��������� ������� ������������ ������� ������� =====================
 if (BuyTicket > 0 && MathAbs(BuyTP - Price) >= Tick && Price - Bid > StopLevel)
   {
    if (WaitForTradeContext())
      if (OrderSelect(BuyTicket, SELECT_BY_TICKET))
        OrderModify(BuyTicket, 0, OrderStopLoss(), Price, 0);
    return(False);  // � ����� ������ ������ False, ��� ��� ��� �� ��� �������� ���������
   } 
// - 1 - =========== ��������� ����� ====================================================
  else
   if (LastDir != 1)                                // ��������� ������� ���� �� ��������
     {
// - 2 - =========== � ������ ������������� ������ BuyLimit ������� ��� =================
      if (BuyLimitTicket > 0) 
        {
         DeleteOrder(BuyLimitTicket);
         return(False);      // ����� ������ False, ��� ��� ��� �� ��� �������� ���������
        }  
// - 2 - =========================== ��������� ����� ====================================
      RefreshRates();
// - 3 - =========== ���� ���������� Sell Limit, �� ������ ������� ��� ��������� ========
      if (SellLimitTicket > 0)
        {
         if (MathAbs(SLPrice - Price) >= Tick) // ���� �������� Sell Limit �� ����� �����
           {
            double SL = ND(Price + StopLoss*Tick);               
            double TP = ND(Price - TakeProfit*Tick);
            if (Price - Bid  > StopLevel)
              if (!OrderModify(SellLimitTicket, Price, SL, TP, 0))
                return(False);
           }     
        }
// - 3 - =========================== ��������� ����� ====================================
       else
// - 4 - =========== ���� ��� ������� � �������, �� ������������� Sell Limit ============
        {
         SL = ND(Price + StopLoss*Tick);               
         TP = ND(Price - TakeProfit*Tick);
         if (OpenOrderCorrect(OP_SELLLIMIT, Price, SL, TP, False) != 0)//�������� �������
           return(False);               //���� �� ������� �������, �� ������� �����������
        } 
     }
// - 4 - =========================== ��������� ����� ====================================
 return(True);                                                  // ��� �������� ���������
}

//+-------------------------------------------------------------------------------------+
//| ��������� ������ Buy Limit                                                          |
//+-------------------------------------------------------------------------------------+
bool BuyLimit()
{
// - 1 - =========== ��������� ������� ������������ �������� ������� ====================
  if (SellTicket > 0 && MathAbs(SellTP - Price) >= Tick && Ask - Price > StopLevel)
    {
     if (WaitForTradeContext())
       if (OrderSelect(SellTicket, SELECT_BY_TICKET))
         OrderModify(SellTicket, 0, OrderStopLoss(), Price, 0);
     return(False); // � ����� ������ ������ False, ��� ��� ��� �� ��� �������� ���������
    }
// - 1 - =========== ��������� ����� ====================================================
  else
   if (LastDir != 0)                                 // ��������� ������� ���� �� �������
     {
// - 2 - =========== � ������ ������������� ������ SellLimit ������� ��� ================
      if (SellLimitTicket > 0) 
        {
         DeleteOrder(SellLimitTicket);
         return(False);      // ����� ������ False, ��� ��� ��� �� ��� �������� ���������
        } 
// - 2 - =========================== ��������� ����� ====================================
      RefreshRates();
// - 3 - =========== ���� ���������� Buy Limit, �� ������ ������� ��� ��������� =========
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
// - 3 - =========================== ��������� ����� ====================================
       else
// - 4 - =========== ���� ��� ������� � �������, �� ������������� Buy Limit =============
        {
         SL = ND(Price - StopLoss*Tick);               
         TP = ND(Price + TakeProfit*Tick);
         if (OpenOrderCorrect(OP_BUYLIMIT, Price, SL, TP, False) != 0) //�������� �������
           return(False);               //���� �� ������� �������, �� ������� �����������
        } 
     }
// - 4 - =========================== ��������� ����� ====================================
 return(True);                                                  // ��� �������� ���������
}
 
//+-------------------------------------------------------------------------------------+
//| ������� START ��������                                                              |
//+-------------------------------------------------------------------------------------+
int start()
  {
  //������ �����  
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
// - 1 -  == ��������� �� ��������� ��������? ===========================================
   if (!Activate || FatalError)             // ����������� ������ ���������, ���� �������
    return(0);           //  init ����������� � �������  ��� ����� ����� ��������� ������
// - 1 -  == ��������� ����� ============================================================
     
// - 2 - == ���� ���������� �� �������� �������� ========================================
   Spread = ND(MarketInfo(Symbol(), MODE_SPREAD)*Point);                 // ������� �����
   StopLevel = ND(MarketInfo(Symbol(), MODE_STOPLEVEL)*Point);  // ������� ������� ������ 
   FreezeLevel = ND(MarketInfo(Symbol(), MODE_FREEZELEVEL)*Point);   // ������� ���������
// - 2 -  == ��������� ����� ============================================================

// - 3 - ======== ��������� ������������ ������� � �������� �������� ������ ���� ========
   if (LastBar == Time[0])
     return(0);
// - 3 -  == ��������� ����� ============================================================

// - 4 - ======================== ������ ������� � ���������� ����� ������� =============
   GetSignal();
   OwnOrders();
// - 4 -  == ��������� ����� ============================================================

// - 5 - ============================== ��������� ������� ===============================
   if (Signal == -TrendFootSteps)                                // ����������� SELLLIMIT
     if (!SellLimit())
       return(0);

   if (Signal == TrendFootSteps)                                  // ����������� BUYLIMIT
     if (!BuyLimit())
       return(0);
// - 5 -  == ��������� ����� ============================================================

   LastBar = Time[0];

   return(0);
  }

