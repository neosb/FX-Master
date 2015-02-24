
#property copyright "Copyright © 2013, Forex Sensation Championship"
#property link      "http://www.forexsensation.com/"

#include <WinUser32.mqh>
//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A
#import "ForexSensationExtended.dll"
   bool CheckVersion(string a0);
   void Initialize(string a0, string a1, int a2, int a3, string a4);
   int StatusWait();
   int Status();
   int ErrorCode();
   int Utc();
   int Msg(int a0, int a1, int& a2[]);
   bool GetMsg(int a0, int a1, string& a2[], int& a3[], int a4);
   int StartExpert(int a0, int a1, string a2, double a3, int a4);
   void StopExpert(int a0);
   void SetBalance(int a0, double a1, string a2);
   bool SetMarket(int a0, int a1, double a2, double a3, double a4, double a5);
   void SetMaxSpread(int a0, double a1);
   void S1_SetIndicators(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8);
   bool S1_OpenLong1(int a0, double a1);
   bool S1_OpenShort1(int a0, double a1);
   bool S1_OpenLong2(int a0, double a1);
   bool S1_OpenShort2(int a0, double a1);
   bool S1_OpenLong22(int a0, int a1, double a2, double a3);
   bool S1_OpenShort22(int a0, int a1, double a2, double a3);
   bool S1_CloseLong(int a0, double a1, double a2, int a3);
   bool S1_CloseShort(int a0, double a1, double a2, int a3);
   bool S1_CloseDa(int a0, int a1, double a2, double a3, double a4);
   void S2_SetIndicators(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8, double a9, int a10);
   bool S2_OpenLong(int a0, int a1);
   bool S2_OpenShort(int a0, int a1);
   bool S2_CloseLong(int a0, double a1);
   bool S2_CloseShort(int a0, double a1);
   void S3_SetIndicators(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7);
   bool S3_OpenLong(int a0);
   bool S3_OpenShort(int a0);
#import
double F1d_112SymbolAUDUSD;
double F1d_184SymbolAUDUSD;
double F1d_192SymbolAUDUSD;
double F1d_200SymbolAUDUSD;
double F1d_208SymbolAUDUSD;
int F1d_268SymbolAUDUSD;
bool F1d_276SymbolAUDUSD = TRUE;
double F1d_360SymbolAUDUSD;
double F1d_368SymbolAUDUSD;
double F1d_high_376SymbolAUDUSD;
double F1d_low_392SymbolAUDUSD;
int F1d_highest_400SymbolAUDUSD;
int F1d_lowest_404SymbolAUDUSD;
int F1d_408SymbolAUDUSD;
int F1d_412SymbolAUDUSD;
int F1d_416SymbolAUDUSD;
int F1W_176SymbolAUDUSD = 1;
double F1W_112SymbolAUDUSD;
double F1W_184SymbolAUDUSD;
double F1W_192SymbolAUDUSD;
double F1W_200SymbolAUDUSD;
double F1W_208SymbolAUDUSD;
int F1W_268SymbolAUDUSD;
bool F1W_276SymbolAUDUSD = TRUE;
double F1W_360SymbolAUDUSD;
double F1W_368SymbolAUDUSD;
double F1W_high_376SymbolAUDUSD;
double F1W_low_392SymbolAUDUSD;
int F1W_highest_400SymbolAUDUSD;
int F1W_lowest_404SymbolAUDUSD;
int F1W_408SymbolAUDUSD;
int F1W_412SymbolAUDUSD;
int F1W_416SymbolAUDUSD;
//#include <WinUser32.mqh>
double g_high_376SymbolAUDUSD;
double g_low_392SymbolAUDUSD;
int g_highest_400SymbolAUDUSD;
int g_lowest_404SymbolAUDUSD;
int gi_408SymbolAUDUSD;
int gi_412SymbolAUDUSD;
int gi_416SymbolAUDUSD;
int F4_176SymbolAUDUSD = 1;
double F4_112SymbolAUDUSD;
double F4_184SymbolAUDUSD;
double F4_192SymbolAUDUSD;
double F4_200SymbolAUDUSD;
double F4_208SymbolAUDUSD;
int F4_268SymbolAUDUSD;
bool F4_276SymbolAUDUSD = TRUE;
double F4_360SymbolAUDUSD;
double F4_368SymbolAUDUSD;
double F4_high_376SymbolAUDUSD;
double F4_low_392SymbolAUDUSD;
int F4_highest_400SymbolAUDUSD;
int F4_lowest_404SymbolAUDUSD;
int F4_408SymbolAUDUSD;
int F4_412SymbolAUDUSD;
int F4_416SymbolAUDUSD;
int TrendAUDUSD;
int gi_176SymbolAUDUSD = 1;
double gd_360SymbolAUDUSD;
double gd_368SymbolAUDUSD;
//int F4_176SymbolAUDUSD = 1;
double gd_192SymbolAUDUSD;
int F1d_176SymbolAUDUSD = 1;
string H_A_K = "S_U_N_E";
int EURUSD_H_A_K;

extern int YourAccountNumber = 58004068;
int gi_76=58004078;
extern int GMTOFFSET=0;
bool IsDemoEXP=false;
int GMTOFFSETCA=2;
#import "user32.dll"
  int GetAncestor(int hWnd, int gaFlags);
  void keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import
extern int SAFE_RANGE=500;
double SymbolAUDUSDAsk;
double SymbolAUDUSDBid;
double SymbolAUDUSDPOINT;
extern string Expert_Name = "SUN2012";
string comment = " AUDUSD";
string comment2 = " RT";
int float = 40;
int floatH4 = 40;
int FLOATW1=30;
int FLOATD1=5;
 double LOSS= -340.30;
int Magic=761349;
int Magic2=4563216;
///int Magic2= D'19.04.2001 06:23:51';
int MAXTRADE=1;
string SetupAUUSD = "--------AUDUSD------";
extern string SymbolAUDUSD="AUDUSD";
extern bool TRADEAUDUSD=TRUE;
bool AUDUSD_BUY=TRUE;
 bool AUDUSD_SELL=TRUE;
double SymbolAUDUSD_ind1, SymbolAUDUSD_ind2, SymbolAUDUSD_ind3,SymbolAUDUSD_ind4;
int value_AUDUSD;
bool WriteDebugLog = FALSE;
extern bool LockProfit=true;
extern double    MYProfitTarget     = 0.82;
extern double    MYProfitTarget_RT     = 2.22;
 extern string MyMaxProfit = "------ If more then 1 order open for Lot 0.01 is $12.00-----";
 extern double My_Max_Profit=12.00;
double CRPF = 0.0002;
color col = ForestGreen;
string txt2="";
string txt3="";
double Balans, Sredstva ;
extern bool CLOSE_ALL=FALSE;
bool Auto_Take_Profit_Stop_Loss = false;
extern bool Forced_Take_Profit_Stop_Loss = True;
extern int TakeProfit = 1000;
extern int StopLoss = 2000;
int gi_112 = 0;
double g_pips_116 = 40.0;
double g_pips_124 = 20.0;
double g_pips_132 = 70.0;
double gd_140 = 0.001;
double gd_unused_148 = 0.001;
double gd_156 = 0.000800;
double gd_unused_164 = 0.0002;
extern int TrailingStop = 10;
int gi_176SymbolEURUSD = 1;
extern bool Show_Settings = False;
string gs_664 = "SUN AUDCAD";
bool gi_672 = FALSE;
bool gi_676 = FALSE;
bool gi_unused_216 = FALSE;
int gi_unused_220 = 10;
int gi_unused_224 = 0;
int gi_228 = 0;
int gi_unused_232 = 0;
int gi_unused_236 = 1;
int gi_unused_240 = 0;
 string EXTRA = "--------Extras";
 string TradingHours = "Trading Hours EURUSD/GBPUSD:";
 int StartHour_EUGB = 5;
 int EndHour_EUGB = 7;
 string Use_AUUS_TradeHour = "AUUS TradeHour";
 int StartHour_AUUS = 9;
 int EndHour_AUUS = 12;
 string Use_CADUS_TradeHour = "CAUS TradeHour";
 int StartHour_CAUS = 14;
 int EndHour_CAUS = 18;
int Trade_AUUS,TradeCAUS,TradeEUGB, MyTime_AUUS,MyTimeEUGB,MyTimeCAUS;
int Trade_AUUSCA1,TradeCAUSCA2,TradeEUGBCA3;
int MyTime_AUUSCA1,MyTimeCAUSCA2, MyTimeEUGBCA3;
extern string LotSet = "Lot Setting:";
extern double MYLots = 0.01;
extern double MaximumRisk = 0.02;
extern double DecreaseFactor = 3.0;

//-----------------------------
extern string v.1.01.5.98 = "";
extern string Code = "";
extern double TesterGmtOffset = 0.0;
extern double MaxSpread = 2.1;
extern bool NewsFilter = TRUE;
extern string _1 = "Strategy 1";
extern bool S1 = TRUE;
extern double S1_Lot = 0.1;
extern double S1_Risk = 0.2;
extern double S1_TakeProfit = 10.0;
extern double S1_StopLoss = 30.0;
extern double S1_AdaptiveTPk = 1.0;
extern double S1_AdaptiveSLk = 3.0;
extern double S1_MinStopLoss = 20.0;
extern double S1_MinTakeProfit = 5.0;
extern double S1_MaxStopLoss = 100.0;
extern double S1_MaxTakeProfit = 30.0;
extern string _2 = "Strategy 2";
extern bool S2 = TRUE;
extern double S2_Lot = 0.1;
extern double S2_Risk = 0.2;
extern double S2_MinStopLoss = 20.0;
extern double S2_MaxStopLoss = 40.0;
extern double S2_TakeProfit = 70.0;
extern double S2_TrailingStop = 20.0;
extern string _3 = "Strategy 3";
extern bool S3 = TRUE;
extern bool S3_Aggressive = FALSE;
extern double S3_Lot = 0.1;
extern double S3_Risk = 0.2;
extern double S3_TakeProfit = 40.0;
extern double S3_StopLoss = 20.0;
extern double S3_TrailingStop = 7.0;
extern int S1_Magic = 761349;
int G_magic_324 = 650238;
extern int S2_Magic = 4563216;
extern int S3_Magic = D'19.04.2001 06:23:51';
double Gd_336 = 1.0;
bool Gi_344 = FALSE;
double Gd_348 = 5.0;
double Gd_356 = 1.5;
double Gd_364 = 4.0;
bool G_bool_372 = TRUE;
int Gi_376 = 20;
int Gi_380 = 20;
extern color TextColor1 = IndianRed;
extern color TextColor2 = Tomato;
int G_color_392 = C'0x64,0x64,0xFF';
double G_pips_396;
bool G_global_var_404 = FALSE;
int G_datetime_408;
int Gi_412;
int Gi_416;
int Gi_unused_420;
int G_day_of_week_424;
string Gsa_428[] = {".", "..", "...", "....", "....."};
int Gi_unused_432 = 0;
int Gi_unused_436 = 0;
int Gi_440 = 0;
int Gi_444 = 0;
int Gi_448 = 0;
int Gi_452;
int Gi_456;
int Gi_460;
int Gi_464;
string Gs_468 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
int Gi_unused_476 = 0;
int Gi_unused_480 = 0;
double Gda_unused_484[];
bool Gi_488 = FALSE;
string Gsa_492[];
string Gsa_496[];
string Gsa_500[];
int Gia_504[];
int Gia_508[];
int Gia_512[];
int Gi_516;
int Gi_520;
int Gi_524;
string G_str_concat_528;
string Gs_536;
int Gi_544 = -1;
int Gi_548 = -1;
int Gi_552 = -1;
bool Gi_556 = FALSE;
int G_period_560 = 70;
int G_period_564 = 11;
int G_period_568 = 11;
int G_period_572 = 18;
int G_period_576 = 18;
int Gi_580 = 56;
double G_ima_584;
int G_timeframe_592 = PERIOD_M5;
int G_period_596 = 17;

// 3BE4B59601B7B2E82D21E1C5C718B88F
double f0_7(bool Ai_0, double Ad_4, double Ad_12) {
   if (Ai_0) return (Ad_4);
   return (Ad_12);
}
	 			  			 	 	  		 					 		  								 		 		  			      						   	  	 			 		 					   	 		   		 	   		  	 	 	  	  	   		     				  	  								      
// AEAA03D41A3A752C422C407A2EBDF031
string f0_19(int Ai_0) {
   string Ls_ret_4;
   switch (Ai_0) {
   case 0:
      Ls_ret_4 = "Buy";
      break;
   case 1:
      Ls_ret_4 = "Sell";
      break;
   case 2:
      Ls_ret_4 = "BuyLimit";
      break;
   case 3:
      Ls_ret_4 = "SellLimit";
      break;
   case 4:
      Ls_ret_4 = "BuyStop";
      break;
   case 5:
      Ls_ret_4 = "SellStop";
      break;
   default:
      Ls_ret_4 = "Unknown";
   }
   return (Ls_ret_4);
}
		 	 	 		 			   	 		  		    	 			  	 			    	 		 		 					  			 	 	    	 	 		  		 				 	  	 		       	  	  	  	 	 			 	   	 	    				  			   		   
// E3EEC3F2E5BF785368EFFB4040FD4F55
string f0_31(int Ai_0) {
   return (StringConcatenate("ForexSensationExtended", " lb: ", Ai_0));
}
			  				   	 	 	      	  			  		 	  	 	  			  	 	 			 		 	 				 			    	      	 	  	    		 	 	   			 		   	 			 	   		  		   	 		     		 					  
// 1D75F0D638248553D80CFFB8D1DC6682
void f0_2(int Ai_0, int &Ai_4, int &Ai_8) {
   string name_12 = f0_31(Ai_0);
   if (ObjectFind(name_12) == 0) {
      Ai_4 = ObjectGet(name_12, OBJPROP_XDISTANCE);
      Ai_8 = ObjectGet(name_12, OBJPROP_YDISTANCE);
   }
}
				       			 	   	 		 	 	 			   		  	 	 	 			 		  	 	   			   			  			   	 		 		 											 		 	 		  	       		 	   					 	 	 	 	 		   	 	  		
// C3BAA9C535265F9452B54C5C75FB8004
void f0_23(string A_text_0, color A_color_8 = -1, int Ai_12 = -1, double Ad_16 = -1.0, int Ai_24 = 0) {
   if (A_color_8 == CLR_NONE) A_color_8 = TextColor1;
   if (Ai_12 == -1) Ai_12 = Gi_444;
   if (Ad_16 == -1.0) Ad_16 = Gi_440;
   string name_28 = f0_31(Ai_12);
   if (ObjectFind(name_28) != 0) {
      ObjectCreate(name_28, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_28, OBJPROP_CORNER, 0);
   }
   ObjectSetText(name_28, A_text_0, 9, "Courier New", A_color_8);
   ObjectSet(name_28, OBJPROP_XDISTANCE, Gi_456 + Ai_24);
   ObjectSet(name_28, OBJPROP_YDISTANCE, Gi_452 + 14.0 * Ad_16);
   Gi_440 = MathMax(Gi_440, Ad_16 + 1.0);
   Gi_444 = MathMax(Gi_444, Ai_12 + 1);
   Gi_448 = MathMax(Gi_448, Ai_12);
}
	   							   	 			 	  	 	 	   			  		 	 	 	   	  		 	 			   			   		   			 	  	  	           	  	 	  		 							  	 			     	 	 	 	 	  			 	 		  
// BF5A9BC44BBE42C10E8B2D4446B20D89
void f0_21(int Ai_0 = -1, double Ad_4 = -1.0, int Ai_12 = 0) {
   if (Ai_0 == -1) Ai_0 = Gi_444;
   if (Ad_4 == -1.0) Ad_4 = Gi_440;
   f0_23("_______", TextColor1, Ai_0, Ad_4 - 0.3, Ai_12);
   Gi_440 = MathMax(Gi_440, Ad_4 + 1.0);
}
		 		 		  		 		   				 		    	 	   		  		    	 				    	   	  				  		    				 					 	  		 	 		 	    				 	 	 							 	 		 				  					 	      	 	
// 8A6D85A0B52E3C8A8E55A15F14BE6D0A
int f0_14(string As_0, string As_8, int Ai_16 = -1, double Ad_20 = -1.0, int Ai_28 = 0) {
   if (Ai_16 == -1) Ai_16 = Gi_444;
   if (Ad_20 == -1.0) Ad_20 = Gi_440;
   f0_23(As_0, TextColor1, Ai_16, Ad_20, Ai_28);
   f0_23(As_8, TextColor2, Ai_16 + 1, Ad_20, Ai_28 + 7 * (StringLen(As_0) + 1));
   return (0);
}
	   	 	  		  			 		 		  		 	 	   	  	   		 	 	  	 		     	    	 	  			 	 		 		  	 	  	 		    					 	 		 					 	 	 	 	 			   				  	 		   	 	  			
// C2C5CA64BFA878771207E31C1E4B9E4F
void f0_22(int Ai_0, int Ai_4) {
   Gi_456 = Ai_0;
   Gi_452 = Ai_4;
   if (Gi_460 != Ai_0 || Gi_464 != Ai_4) {
      Gi_460 = Gi_380;
      Gi_464 = Gi_376;
   } else f0_2(0, Gi_456, Gi_452);
   Gi_444 = 0;
   Gi_440 = 0;
}
	 	      	  		 	 	   		 							  		   	 							 	  		 	  		 	   	 		 			 	   		 	   					 	 		 							  		 	    	      		 	  	 	     		  				  		
// D61FF371629181373AAEA1B1C60EF302
void f0_27(int Ai_0, int Ai_4 = 0) {
   if (Ai_4 == 0) {
      Ai_4 = Gi_448;
      Gi_448 = Ai_0 - 1;
   }
   for (int Li_8 = Ai_0; Li_8 <= Ai_4; Li_8++) ObjectDelete(f0_31(Li_8));
}
									  	  	 	  		  	  	    		 				 	  	    	 	   	 		 		 			 		 	   	  		  	 	 	     			  	   	   		    				 	 				  				 	 		 		  		 	  		  
// CC9E8226BD8EC7D27CF11D972D60721C
int f0_24(string Asa_0[], int Aia_4[], int Ai_8 = -1, double Ad_12 = -1.0, int Ai_20 = 0) {
   int color_36;
   if (Ai_8 == -1) Ai_8 = Gi_444;
   if (Ad_12 == -1.0) Ad_12 = Gi_440;
   int arr_size_24 = ArraySize(Asa_0);
   if (arr_size_24 != ArraySize(Aia_4)) return (Ai_8);
   int Li_28 = 0;
   for (int index_32 = 0; index_32 < arr_size_24; index_32++) {
      color_36 = TextColor2;
      if (Aia_4[index_32] & 8 > 0) color_36 = G_color_392;
      f0_23(Asa_0[index_32], color_36, Ai_8, Ad_12, Ai_20 + 7 * Li_28);
      Li_28 += StringLen(Asa_0[index_32]);
      Ai_8++;
      if (Aia_4[index_32] & 4 > 0) {
         Ad_12++;
         Li_28 = 0;
      }
   }
   return (Ai_8);
}
		  	 	   	  			  	 		  	  	 	      	   	  	 	  				          	 		 			 	  	 		  			  	 			   				  	 		 	 			 	 			 	 				  				 		 		     	  			
// B12E8292EDAA45EC08452A504747D823
void f0_20(string &Asa_0[], int Aia_4[], int Ai_8) {
   ArrayResize(Asa_0, Ai_8);
   ArrayResize(Aia_4, Ai_8);
   for (int index_12 = 0; index_12 < Ai_8; index_12++) Asa_0[index_12] = StringTrimLeft("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
}
	     		 		 			  		  	 			 			 	 	     			 			 		 			  	 	  	 			  	 	   		  	 		 	 		  	   			 		 									  			 	   	 	    		   	  	 	 	 		 	 	
// 57862CA56FB6CA780A1AA075901C0C7C
double f0_11(string As_0) {
   int Li_24;
   As_0 = f0_26(As_0);
   int str_len_8 = StringLen(As_0);
   double Ld_ret_12 = 0;
   for (int Li_20 = 0; Li_20 < str_len_8; Li_20++) {
      Li_24 = StringFind(Gs_468, StringSubstr(As_0, str_len_8 - Li_20 - 1, 1));
      Ld_ret_12 += Li_24 * MathPow(36, Li_20);
   }
   return (Ld_ret_12);
}
	 			   		 	 	 			 				  		  		 					 	  		  		       	 				      	 						 				    	 			  		 	 	 		  	   	  	      		  	  				 		  				 			    	 
// DF423827A5F770FA7875E68553FDD0BB
string f0_30(double Ad_0) {
   string str_concat_8 = "";
   for (Ad_0 = MathAbs(Ad_0); Ad_0 >= 1.0; Ad_0 = MathFloor(Ad_0 / 36.0)) str_concat_8 = StringConcatenate(StringSubstr(Gs_468, MathMod(Ad_0, 36), 1), str_concat_8);
   return (str_concat_8);
}
	   	  				  	  			 				 	 	 					  	 		 	 	 			  		  				     	   				 			 				  	  		      	   	 	 	 	 				  	  	 	       		  	 	 						 	     
// D27AF7D1516C24C3278EA8BCC56C9759
string f0_26(string As_0) {
   int Li_8;
   int Li_20;
   int str_len_16 = StringLen(As_0);
   for (int Li_12 = 0; Li_12 < str_len_16; Li_12++) {
      Li_20 = 0;
      Li_8 = StringGetChar(As_0, Li_12);
      if (Li_8 > '`' && Li_8 < '{') Li_20 = Li_8 - 32;
      if (Li_8 > 'ß' && Li_8 < 256) Li_20 = Li_8 - 32;
      if (Li_8 == '¸') Li_20 = 168;
      if (Li_20 > 0) As_0 = StringSetChar(As_0, Li_12, Li_20);
   }
   return (As_0);
}
		  		 		 	     	 	 	 		   	  			   				   	  		 			 				    	 	 	 		 	 	 	 	 		 		   	  	         	   	  				 	 		 		   	  	   			 	 			  	 	   
// A1C3E4052962E3D363F2BF4323568F49
int f0_17() {
   for (int count_0 = 0; IsTradeContextBusy() && count_0 < 10; count_0++) Sleep(15);
   if (count_0 >= 10) Print("Trade context is buisy more than ", DoubleToStr(15 * count_0 / 1000, 2), " seconds");
   else
      if (count_0 > 0) Print("Trade context was buisy ", DoubleToStr(15 * count_0 / 1000, 2), " seconds");
   return (count_0);
}
		 	  			 					 	 		 	 	    		 		  	   	    		 	 		 	  		  		 		 	   	  	 		 	 	 					   	 				     				  	   		 			  	  	 	 		 				 	 		   	 	  
// A908BF30D5A0CAE9E3CAA8BBF9AF6384
int f0_18(int A_cmd_0, double A_lots_4, double A_price_12, double A_price_20, double A_price_28, int A_magic_36, string A_comment_40, color A_color_48, bool Ai_52 = FALSE) {
   double price_56;
   double price_64;
   int error_76;
   double price_84;
   int ticket_72 = -1;
   int count_80 = 0;
   bool Li_92 = FALSE;
   double Ld_96 = 2.0 * G_pips_396 * Point;
   double slippage_104 = 3.0 * G_pips_396;
   while (!Li_92) {
      if (!Ai_52) {
         price_56 = A_price_20;
         price_64 = A_price_28;
      } else {
         price_56 = 0;
         price_64 = 0;
      }
      if (A_cmd_0 == OP_BUY) price_84 = MarketInfo(Symbol(), MODE_ASK);
      else
         if (A_cmd_0 == OP_SELL) price_84 = MarketInfo(Symbol(), MODE_BID);
      if (count_80 > 0 && MathAbs(price_84 - A_price_12) > Ld_96) {
         Print("Price is too far");
         break;
      }
      f0_17();
      ticket_72 = OrderSend(Symbol(), A_cmd_0, A_lots_4, A_price_12, slippage_104, price_64, price_56, A_comment_40, A_magic_36, 0, A_color_48);
      if (ticket_72 >= 0) break;
      count_80++;
      error_76 = GetLastError();
      switch (error_76) {
      case 130/* INVALID_STOPS */:
         if (!Ai_52) G_global_var_404 = 1;
      case 0/* NO_ERROR */:
         if (!Ai_52) Ai_52 = TRUE;
         else Li_92 = TRUE;
         break;
      case 4/* SERVER_BUSY */: break;
      case 6/* NO_CONNECTION */: break;
      case 129/* INVALID_PRICE */: break;
      case 136/* OFF_QUOTES */: break;
      case 137/* BROKER_BUSY */: break;
      case 146/* TRADE_CONTEXT_BUSY */: break;
      case 135/* PRICE_CHANGED */:
      case 138/* REQUOTE */:
         RefreshRates();
         break;
      default:
         Li_92 = TRUE;
      }
      if (count_80 > 10) break;
   }
   if (ticket_72 >= 0) {
      if (Ai_52) {
         if (OrderSelect(ticket_72, SELECT_BY_TICKET)) {
            Sleep(1000);
            f0_17();
            OrderModify(ticket_72, OrderOpenPrice(), A_price_28, A_price_20, 0, A_color_48);
         }
      }
      if (count_80 > 5) Print(f0_19(A_cmd_0) + " operation attempts: ", count_80);
   } else Print(f0_19(A_cmd_0) + " operation failed - error(", error_76, "): ", ErrorDescription(error_76), " attempts: ", count_80);
   return (ticket_72);
}
	  			   			   	 				 	 		    	  	 				 		    	 	 	  		  	 	 	  	   	 		 				 	 	 		  			  	   			      			 		  	 				 		  		  	  			 	  	   	 		
// 0D8DF1C15E383B163F5CB1A2BE7799FC
int f0_1(int A_ticket_0, int Ai_4, double Ad_8 = 1.0) {
   if (OrderSelect(A_ticket_0, SELECT_BY_TICKET)) return (f0_25(Ai_4, Ad_8));
   return (-2);
}
	 			 		 	 	 		  	 			 				  	 	 				  				  	 		      	 			  			 	 		   	 			 		  	 	  	 		 		 			  					  	 			  		 	 	 					    			 	 		   	 	
// D0B773F3CEA185836A86C349E30F8167
int f0_25(color A_color_0, double Ad_4 = 1.0) {
   double order_lots_12;
   double price_44;
   int error_52;
   string symbol_20 = OrderSymbol();
   if (Ad_4 == 1.0) order_lots_12 = OrderLots();
   else order_lots_12 = f0_6(OrderLots() * Ad_4);
   bool Li_28 = FALSE;
   double slippage_32 = 3.0 * f0_12(symbol_20);
   for (int count_40 = 0; count_40 < 10; count_40++) {
      if (f0_17() > 5) RefreshRates();
      if (OrderType() == OP_BUY) price_44 = MarketInfo(symbol_20, MODE_BID);
      else price_44 = MarketInfo(symbol_20, MODE_ASK);
      if (OrderClose(OrderTicket(), order_lots_12, price_44, slippage_32, A_color_0)) {
         Li_28 = TRUE;
         if (Ad_4 >= 1.0) return (-1);
         f0_10(OrderMagicNumber(), OrderType());
         break;
      }
      error_52 = GetLastError();
      Print("Order close operation failed - error(", error_52, "): ", ErrorDescription(error_52));
      RefreshRates();
   }
   if (!Li_28) Print("Order close operation failed");
   return (OrderTicket());
}
	  	 		 					 						     	  	   		 	 	   	  	     	 		  		 				        					      			  	   		 		 	  	 	  		  		   		 			   	  			 		    		  				 
// DA91C8297B29714F1032A7F7B3F099AB
double f0_29(double Ad_0, double Ad_8) {
   int Li_16;
   return (f0_32(Ad_0, Ad_8, Li_16));
}
	 				 	 	 	     	 		 					   		 										   			    			 			 	 		 	 	 	  	 		 			  	  	 	 		    			    			  		 		  			  	 			      		 		 		  	  	
// EB20E9232C8D576D1AF86E66E193C68A
double f0_32(double Ad_0, double Ad_8, int &Ai_16) {
   if (AccountLeverage() < 100) return (f0_15(Ad_0 * Ad_8 / MarketInfo(Symbol(), MODE_MARGINREQUIRED), Ai_16));
   return (f0_15(Ad_0 * Ad_8 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / (AccountLeverage() / 100.0), Ai_16));
}
	 	 	 				   		 		  		 	 			 	 				 	  	 			 	 	   	   				   		  				  		  		 	     	    	  		  			 			 	 		 		    	 	   	 			 	   		 					  	  
// 38350FE142782EF0E6BB82AC5D70CEFB
double f0_6(double Ad_0) {
   int Li_8;
   return (f0_15(Ad_0, Li_8));
}
			 					     	 	   	  	  		   		 	 		 	  		   	 	 	 	 		 	  			 				   	   	  	 	       		   	   		  		   					 	  			  		 	 	 		  	  		 		 		  
// 8BB10F52F0AC31289E87BEDAE9317915
double f0_15(double Ad_0, int &Ai_8) {
   double lotstep_20 = MarketInfo(Symbol(), MODE_LOTSTEP);
   double Ld_28 = MarketInfo(Symbol(), MODE_MINLOT);
   double Ld_36 = MarketInfo(Symbol(), MODE_MAXLOT);
   double Ld_ret_12 = MathCeil(Ad_0 / lotstep_20) * lotstep_20;
   Ai_8 = 0;
   if (Ld_ret_12 < Ld_28) {
      Ld_ret_12 = Ld_28;
      Ai_8 = -1;
   }
   if (Ld_ret_12 > Ld_36) {
      Ld_ret_12 = Ld_36;
      Ai_8 = 1;
   }
   return (Ld_ret_12);
}
	    	 	 		 	    		   				 		 		 	   					 		 			 						 	  		 		  	  	  		   			 	 	 	 	   	   		 		  					 	 		 	  	  	         	   		 	 			  	
// 618646BE358BBCADF82CB1DC9D6366D5
double f0_12(string A_symbol_0) {
   double Ld_ret_8 = 0.0001 / MarketInfo(A_symbol_0, MODE_POINT);
   if (MarketInfo(A_symbol_0, MODE_DIGITS) < 4.0) Ld_ret_8 = 100.0 * Ld_ret_8;
   return (Ld_ret_8);
}
				 			   		 	    	   		 	 	  	  		 	 		 	 	  			  		 	  									        	   			 		   					 	 	 	 	 			    					 	 		 				  	  	 	   	  	 			 	
// 556B050CE914D18480D6EA30308C7790
int f0_10(int A_magic_0, int A_cmd_4) {
   for (int pos_8 = OrdersTotal() - 1; pos_8 >= 0; pos_8--) {
      if (OrderSelect(pos_8, SELECT_BY_POS)) {
         if (OrderMagicNumber() == A_magic_0) {
            if (OrderSymbol() == Symbol())
               if (OrderType() == A_cmd_4) return (OrderTicket());
         }
      }
   }
   return (-1);
}
	 	      	  		 	 	   		 							  		   	 							 	  		 	  		 	   	 		 			 	   		 	   					 	 		 							  		 	    	      		 	  	 	     		  				  		
// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   double global_var_0;
   double Ld_8;
   int Li_20;
   int Li_24;
   string str_concat_28;
   int Li_36;
   f0_22(Gi_380, Gi_376);
   G_str_concat_528 = StringConcatenate("ForexSensationExtended", " v.", "1.01");
   f0_23(G_str_concat_528, TextColor2);
   f0_21();
   Gi_488 = CheckVersion("1.01");
   if (!Gi_488) {
      f0_14("Error:", "Dll and Expert versions mismatch");
      return (0);
   }
   Code = StringTrimLeft(StringTrimRight(Code));
   if (StringLen(Code) <= 0) {
      if (GlobalVariableCheck("FSEX_CODE")) {
         global_var_0 = GlobalVariableGet("FSEX_CODE");
         Code = f0_30(global_var_0);
      }
   } else {
      Ld_8 = f0_11(Code);
      GlobalVariableSet("FSEX_CODE", Ld_8);
   }
   G_bool_372 = G_bool_372 && (!IsTesting()) || IsVisualMode();
   Gs_536 = AccountName();
   //Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   f0_23("Authentication...");
   WindowRedraw();
   int str_concat_16 =5;// StatusWait();
   Gi_444--;
   Gi_440--;
   if (str_concat_16 & 1 == 0) {
      Li_20 = f0_3(1, 0, Gi_516, Gsa_492, Gia_504);
      Li_24 = ErrorCode();
      if (Li_24 == 0) str_concat_28 = str_concat_16;
      else str_concat_28 = StringConcatenate(str_concat_16, " (", Li_24, ")");
      if (Li_20 == 0) f0_14("Authentication Failed! Error: ", str_concat_28);
      Print("Authentication Failed! Error: ", str_concat_28);
   } else {
      Li_20 = 0;//f0_3(1, 0, Gi_516, Gsa_492, Gia_504);
      if (Li_20 == 0) f0_23("Authenticated");
   }
   if (S1) {
      Li_36 = 0;
      if (!NewsFilter) Li_36 |= 16;
      Gi_544 = StartExpert(1, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_544 >= 0) SetMaxSpread(Gi_544, MaxSpread);
      else f0_14("Strategy1:", "This currency is not supported!");
   } else Gi_544 = -1;
   if (S2) {
      Li_36 = 0;
      if (!NewsFilter) Li_36 |= 16;
      Gi_548 = StartExpert(2, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_548 >= 0) SetMaxSpread(Gi_548, MaxSpread);
      else f0_14("Strategy2:", "This currency is not supported!");
   } else Gi_548 = -1;
   if (S3) {
      Li_36 = 0;
      if (!NewsFilter) Li_36 |= 16;
      if (S3_Aggressive) Li_36 |= 1048576;
      Gi_552 = StartExpert(3, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_552 >= 0) SetMaxSpread(Gi_552, MaxSpread);
      else f0_14("Strategy3:", "This currency is not supported!");
   } else Gi_552 = -1;
   WindowRedraw();
   if (Gi_544 < 0 && Gi_548 < 0 && Gi_552 < 0) MessageBox("You have selected the wrong currency pair!", G_str_concat_528 + ": Warning", MB_ICONEXCLAMATION);
   G_pips_396 = f0_12(Symbol());
   G_global_var_404 = 0;
   if (!IsTesting())
      if (GlobalVariableCheck("FSEX_MARKET")) G_global_var_404 = GlobalVariableGet("FSEX_MARKET");
   return (0);
}
				 	 	   		      	  			 	 	 		  		 				 	 	 				  				  				 				   	    	  				 		 	 					   	 	 	  		    	 			 	 	  				     	 	  		  	 		  	
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   int spread_0;
   StopExpert(Gi_544);
   StopExpert(Gi_548);
   StopExpert(Gi_552);
   if (IsTesting()) {
      if (!(!IsVisualMode())) return (0);
      f0_21();
      f0_14("TesterGmtOffset:", DoubleToStr(TesterGmtOffset, 1));
      f0_21();
      spread_0 = MarketInfo(Symbol(), MODE_SPREAD);
      f0_14("Spread:", StringConcatenate(DoubleToStr(spread_0 / G_pips_396, 1), " (", spread_0, " pips)"));
      f0_21();
      return (0);
   }
   GlobalVariableSet("FSEX_MARKET", G_global_var_404);
   switch (UninitializeReason()) {
   case REASON_CHARTCLOSE:
   case REASON_REMOVE:
      f0_27(0, Gi_448);
      Gi_448 = 0;
      break;
   case REASON_RECOMPILE:
   case REASON_CHARTCHANGE:
   case REASON_PARAMETERS:
   case REASON_ACCOUNT:
      f0_27(1, Gi_448);
      Gi_448 = 1;
   }
   return (0);
}
	 		   	 	 			   	 	 						 				 			  					 					   	 		 				  		 	  		  	 	 				  				 	 				  			 		 			     		  	    	 		 	     	 			 		 	   	
// 03B62516184FB6EF591F45BD4974B753
void f0_0() {
   RefreshRates();
   G_datetime_408 = TimeCurrent();
   if (IsTesting()) Gi_412 = G_datetime_408 - 3600.0 * TesterGmtOffset;
   else Gi_412 = Utc();
   Gi_416 = G_datetime_408 - 3600.0 * TimeHour(Gi_412) - 60 * TimeMinute(Gi_412) - TimeSeconds(Gi_412);
   Gi_unused_420 = Gi_412 - 3600.0 * TimeHour(Gi_412) - 60 * TimeMinute(Gi_412) - TimeSeconds(Gi_412);
   G_day_of_week_424 = TimeDayOfWeek(Gi_412);
}
	 					 		 	  				 		    		     						   		          	  				 		   	 	  			 		      	   	  		  		 		   	  	  			    					  			 			  		   			  			 
// 25D8FA49F2C78939384F1B1F7C3C8CC3
int f0_3(int Ai_0, int Ai_4, int &Ai_8, string Asa_12[], int Aia_16[], string As_20 = "") {
   int Lia_28[1];
   int str_len_36;
   int Li_ret_32 = Msg(Ai_0, Ai_4, Lia_28);
   if (Lia_28[0] != Ai_8 || Li_ret_32 != ArraySize(Asa_12)) {
      Ai_8 = Lia_28[0];
      f0_20(Asa_12, Aia_16, Li_ret_32);
      GetMsg(Ai_0, Ai_4, Asa_12, Aia_16, Li_ret_32);
   }
   if (Li_ret_32 > 0) {
      str_len_36 = StringLen(As_20);
      if (str_len_36 > 0) {
         f0_23(As_20);
         f0_24(Asa_12, Aia_16, Gi_444, Gi_440 - 1, 7 * (str_len_36 + 1));
      } else f0_24(Asa_12, Aia_16);
   }
   return (Li_ret_32);
}
		   	    	 	  	  	   	 	  		 	      		 	  		 	 							     		  		 	  		  	   	 			 	 				  	  		  		   	 		 	  			  	 			     	 		   	    			 		
// 288510B44320B9D19D3AD3E90BD66D99
double f0_4(string As_0, double Ad_8, double Ad_16) {
   double Ld_ret_24;
   int Li_32;
   if (Ad_16 > 0.0) Ld_ret_24 = f0_32(Ad_16, AccountFreeMargin(), Li_32);
   else Ld_ret_24 = f0_15(Ad_8, Li_32);
   f0_14(StringConcatenate(As_0, "Lot:"), DoubleToStr(Ld_ret_24, 2));
   switch (Li_32) {
   case 1:
      f0_23("Maximum Lot size exeeded!");
      break;
   case -1:
      f0_23("Minimum Lot size exeeded!");
   }
   return (Ld_ret_24);
}
	   		 				     			 	 		 	 	  				  				 	 	  		  		 					   	 	   		 	 			 	 		  	   	          	 	   	 					 	  	 		      	   	 	 	 				 	 	   
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
if (LockProfit==True)CloseAllProfit();

   if (Bars < 100 || IsTradeAllowed() == FALSE) return;
   if (CalculateCurrentOrders(Symbol()) == 0) CheckForOpen();

   int Li_4;
   int Li_8;
   string str_concat_12;
   int Li_20;
   int Li_24;
   int spread_28;
   double Ld_32;
   double Ld_40;
   bool Li_48;
   if (!Gi_488) return (0);
   if (Gi_544 < 0 && Gi_548 < 0 && Gi_552 < 0) return (0);
   if (Gs_536 != AccountName()) {
      Gs_536 = AccountName();
    //  Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   }
   int str_concat_0 = 5;//Status();
   f0_0();
   if (G_bool_372) {
      f0_2(0, Gi_456, Gi_452);
      Gi_444 = 0;
      Gi_440 = 0;
      f0_23(G_str_concat_528, TextColor2);
      f0_21();
      if (str_concat_0 & 1 == 0) {
         Li_4 = f0_3(1, 0, Gi_516, Gsa_492, Gia_504);
         Li_8 = ErrorCode();
         if (Li_8 == 0) str_concat_12 = str_concat_0;
         else str_concat_12 = StringConcatenate(str_concat_0, " (", Li_8, ")");
         if (Li_4 == 0) f0_14("Authentication Failed! Error: ", str_concat_12);
      } else {
         Li_4 = 0;//f0_3(1, 0, Gi_516, Gsa_492, Gia_504);
         if (Li_4 == 0) f0_23("Authenticated");
         f0_21();
         Li_20 = f0_3(2, 0, Gi_520, Gsa_496, Gia_508);
         if (Li_20 > 0) f0_21();
         if (NewsFilter) {
            Li_24 = f0_3(3, Gi_544, Gi_524, Gsa_500, Gia_512, "Market Alert:");
            if (Li_24 > 0) f0_21();
         }
         f0_14("ServerTime:", TimeToStr(G_datetime_408));
         f0_14("UtcTime:", TimeToStr(Gi_412));
         f0_21();
         spread_28 = MarketInfo(Symbol(), MODE_SPREAD);
         f0_14("Spread:", StringConcatenate(DoubleToStr(spread_28 / G_pips_396, 1), " (", spread_28, " pips)"));
         f0_14("Leverage:", StringConcatenate(AccountLeverage(), ":1"));
         f0_21();
         Ld_32 = 0;
         if (Gi_544 >= 0) Ld_32 = MathMax(Ld_32, f0_4("S1 ", S1_Lot, S1_Risk));
         if (Gi_548 >= 0) Ld_32 = MathMax(Ld_32, f0_4("S2 ", S2_Lot, S2_Risk));
         if (Gi_552 >= 0) Ld_32 = MathMax(Ld_32, f0_4("S3 ", S3_Lot, S3_Risk));
         Ld_40 = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED) * Ld_32, 8);
         Li_48 = NormalizeDouble(AccountFreeMargin(), 8) < Ld_40;
         if (Gi_556 != Li_48) {
            if (Li_48) Print("Not enough money! Available margin = ", DoubleToStr(AccountFreeMargin(), 2), ", Required margin = ", DoubleToStr(Ld_40, 2));
            Gi_556 = Li_48;
         }
         if (Li_48) {
            f0_21();
            f0_23("Not enough money!");
            f0_14("Available margin =", DoubleToStr(AccountFreeMargin(), 2));
            f0_14("Required margin =", DoubleToStr(Ld_40, 2));
         }
      }
      f0_27(Gi_444);
      WindowRedraw();
   }
   if (Gi_544 >= 0) f0_9();
   if (Gi_544 >= 0 && Gi_548 >= 0) f0_0();
   if (Gi_548 >= 0) f0_16();
   if (Gi_544 >= 0 || Gi_548 >= 0 && Gi_552 >= 0) f0_0();
   if (Gi_552 >= 0) f0_33();
   return (0);
}
		 	 		   			 		  		    	   	      	 	  	   	   			 		     				 		     	  		    					  			 		 			   	 	 	 	  		 				 					 	  		 			        					
// 4280E6883D02734AF90C834569725E81
int f0_9() {
   double order_open_price_20;
   double order_open_price_28;
   int datetime_36;
   int datetime_40;
   double order_stoploss_44;
   double order_takeprofit_52;
   double order_stoploss_60;
   double order_takeprofit_68;
   double stoplevel_88;
   double pips_96;
   double pips_104;
   double Ld_112;
   bool Li_120;
   bool Li_124;
   double Ld_128;
   double Ld_136;
   double iatr_144;
   double Ld_152;
   double Ld_160;
   int Li_0 = SetMarket(Gi_544, G_datetime_408, Point, G_pips_396, MarketInfo(Symbol(), MODE_SPREAD), MarketInfo(Symbol(), MODE_TICKVALUE));
   SetBalance(Gi_544, AccountBalance(), AccountCurrency());
   f0_13();
   int ticket_4 = -1;
   int ticket_8 = -1;
   int ticket_12 = -1;
   int ticket_16 = -1;
   for (int pos_76 = OrdersTotal() - 1; pos_76 >= 0; pos_76--) {
      if (OrderSelect(pos_76, SELECT_BY_POS)) {
         if (OrderSymbol() == Symbol()) {
            if (OrderMagicNumber() == S1_Magic) {
               switch (OrderType()) {
               case OP_BUY:
                  ticket_4 = OrderTicket();
                  order_open_price_20 = OrderOpenPrice();
                  datetime_36 = OrderOpenTime();
                  order_stoploss_44 = OrderStopLoss();
                  order_takeprofit_52 = OrderTakeProfit();
                  break;
               case OP_SELL:
                  ticket_8 = OrderTicket();
                  order_open_price_28 = OrderOpenPrice();
                  datetime_40 = OrderOpenTime();
                  order_stoploss_60 = OrderStopLoss();
                  order_takeprofit_68 = OrderTakeProfit();
                  break;
               }
            }
            if (OrderMagicNumber() == G_magic_324) {
               switch (OrderType()) {
               case OP_BUY:
                  ticket_12 = OrderTicket();
                  break;
               case OP_SELL:
                  ticket_16 = OrderTicket();
               }
            }
         }
      }
   }
   if (ticket_4 >= 0) {
      if (order_stoploss_44 == 0.0 || order_takeprofit_52 == 0.0) {
         stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         if (order_takeprofit_52 == 0.0) {
            pips_96 = MathMax(S1_TakeProfit * G_pips_396, stoplevel_88);
            order_takeprofit_52 = NormalizeDouble(Ask + pips_96 * Point, Digits);
         }
         if (order_stoploss_44 == 0.0) {
            pips_104 = MathMax(S1_StopLoss * G_pips_396, stoplevel_88);
            order_stoploss_44 = NormalizeDouble(Bid - pips_104 * Point, Digits);
         }
         f0_17();
         OrderModify(ticket_4, order_open_price_20, order_stoploss_44, order_takeprofit_52, 0, Green);
      }
      if (Gi_344) {
         if (f0_5(ticket_4, ticket_12)) {
            ticket_4 = f0_1(ticket_4, 32768);
            ticket_12 = f0_1(ticket_12, 32768);
         }
      } else
         if (S1_CloseLong(Gi_544, Bid, order_open_price_20, datetime_36)) ticket_4 = f0_1(ticket_4, 255);
   } else
      if (ticket_12 >= 0) ticket_12 = f0_1(ticket_12, 32768);
   if (ticket_8 >= 0) {
      if (order_stoploss_60 == 0.0 || order_takeprofit_68 == 0.0) {
         stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         if (order_takeprofit_68 == 0.0) {
            pips_96 = MathMax(S1_TakeProfit * G_pips_396, stoplevel_88);
            order_takeprofit_68 = NormalizeDouble(Bid - pips_96 * Point, Digits);
         }
         if (order_stoploss_60 == 0.0) {
            pips_104 = MathMax(S1_StopLoss * G_pips_396, stoplevel_88);
            order_stoploss_60 = NormalizeDouble(Ask + pips_104 * Point, Digits);
         }
         f0_17();
         OrderModify(ticket_8, order_open_price_28, order_stoploss_60, order_takeprofit_68, 0, Green);
      }
      if (Gi_344) {
         if (f0_5(ticket_8, ticket_16)) {
            ticket_8 = f0_1(ticket_8, 32768);
            ticket_16 = f0_1(ticket_16, 32768);
         }
      } else
         if (S1_CloseShort(Gi_544, Ask, order_open_price_28, datetime_40)) ticket_8 = f0_1(ticket_8, 255);
   } else
      if (ticket_16 >= 0) ticket_16 = f0_1(ticket_16, 32768);
   if (Li_0 && ticket_4 < 0 || ticket_8 < 0) {
      if (S1_Risk > 0.0) Ld_112 = f0_29(S1_Risk, AccountFreeMargin());
      else Ld_112 = f0_6(S1_Lot);
      Li_120 = true;//f0_28();
      Li_124 = true;//f0_8();
      Ld_128 = S1_TakeProfit * G_pips_396;
      Ld_136 = S1_StopLoss * G_pips_396;
      if (Li_120 || Li_124 && S1_AdaptiveTPk > 0.0) {
         iatr_144 = iATR(NULL, PERIOD_M15, 14, 0);
         Ld_128 = S1_AdaptiveTPk * iatr_144 / Point;
         Ld_136 = S1_AdaptiveSLk * iatr_144 / Point;
         Ld_128 = MathMax(S1_MinTakeProfit * G_pips_396, MathMin(S1_MaxTakeProfit * G_pips_396, Ld_128));
         Ld_136 = MathMax(S1_MinStopLoss * G_pips_396, MathMin(S1_MaxStopLoss * G_pips_396, Ld_136));
      }
      if (Li_120 || Li_124 && Gd_336 > 0.0) {
         for (pos_76 = OrdersHistoryTotal() - 1; pos_76 >= 0; pos_76--) {
            if (OrderSelect(pos_76, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol()) {
                  if (OrderMagicNumber() == S1_Magic) {
                     if ((G_datetime_408 - OrderCloseTime()) / 3600.0 <= Gd_336) {
                        if (Li_120 && OrderType() == OP_BUY) {
                           Li_120 = FALSE;
                           break;
                        }
                        if (Li_124 && OrderType() == OP_SELL) {
                           Li_124 = FALSE;
                           break;
                        }
                     }
                  }
               }
            }
         }
      }
      if (Li_120 && ticket_4 < 0) {
         Ld_152 = 0;
         Ld_160 = 0;
         pips_104 = 0;
         pips_96 = 0;
         stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         pips_104 = MathMax(Ld_136, stoplevel_88);
         pips_96 = MathMax(Ld_128, stoplevel_88);
         Ld_160 = NormalizeDouble(Bid - pips_104 * Point, Digits);
         Ld_152 = NormalizeDouble(Ask + pips_96 * Point, Digits);
         ticket_4 = f0_18(OP_BUY, Ld_112, Ask, Ld_152, Ld_160, S1_Magic, "", Blue);
      }
      if (Li_124 && ticket_8 < 0) {
         Ld_152 = 0;
         Ld_160 = 0;
         pips_104 = 0;
         pips_96 = 0;
         stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         pips_104 = MathMax(Ld_136, stoplevel_88);
         pips_96 = MathMax(Ld_128, stoplevel_88);
         Ld_160 = NormalizeDouble(Ask + pips_104 * Point, Digits);
         Ld_152 = NormalizeDouble(Bid - pips_96 * Point, Digits);
         ticket_8 = f0_18(OP_SELL, Ld_112, Bid, Ld_152, Ld_160, S1_Magic, "", Blue);
      }
   }
   return (0);
}
		  	  		 	  	  	 	 				   	 				   	 		   	 			 			  			      	 	 				 	 	 				 		  		  	   	     	 	 	  			  	 		 	    	  		  			 					  	     
// 635171E21C4AAA4E3B8671F1CEA4CD16
void f0_13() {
   HideTestIndicators(TRUE);
   double iopen_0 = iOpen(NULL, PERIOD_M15, 1);
   double iclose_8 = iClose(NULL, PERIOD_M15, 1);
   G_ima_584 = iMA(NULL, PERIOD_M15, G_period_560, 0, MODE_SMMA, PRICE_MEDIAN, 1);
   double istochastic_16 = iStochastic(NULL, PERIOD_M15, G_period_564, 1, 1, MODE_SMA, 0, MODE_MAIN, 1);
   double iwpr_24 = iWPR(NULL, PERIOD_M1, G_period_568, 0);
   double icci_32 = iCCI(NULL, PERIOD_M1, G_period_572, PRICE_CLOSE, 0);
   double icci_40 = iCCI(NULL, PERIOD_M5, G_period_576, PRICE_CLOSE, 0);
   double ima_48 = iMA(NULL, PERIOD_M15, G_period_560 / 2.0, 0, MODE_SMMA, PRICE_MEDIAN, 1);
   S1_SetIndicators(Gi_544, iopen_0, iclose_8, G_ima_584, istochastic_16, iwpr_24, icci_32, icci_40, ima_48);
}
	   			 			   					 	    	 	    		  		   	 	      		 	  		   		    		  				 	     	    	      		 	 	  	  						   	 				    	 			 	 	   		 	 			 
// D925AC83A3A30655165085569C2CB44E
int f0_28() {
   bool Li_0;
   double ihigh_4;
   double ima_12;
   int datetime_24;
   double ihigh_28;
   double ima_36;
   if (S1_OpenLong1(Gi_544, Bid)) return (1);
   if (S1_OpenLong2(Gi_544, Bid)) {
      Li_0 = TRUE;
      ihigh_4 = iHigh(NULL, PERIOD_M15, 1);
      ima_12 = G_ima_584;
      for (int Li_20 = 2; Li_20 < Gi_580; Li_20++) {
         datetime_24 = iTime(NULL, PERIOD_M15, Li_20);
         ihigh_28 = iHigh(NULL, PERIOD_M15, Li_20);
         ima_36 = iMA(NULL, PERIOD_M15, G_period_560, 0, MODE_SMMA, PRICE_MEDIAN, Li_20);
         if (TimeDayOfWeek(datetime_24) != G_day_of_week_424) break;
         if (ihigh_28 < ima_36) break;
         if (ihigh_28 > ihigh_4) {
            ihigh_4 = ihigh_28;
            ima_12 = ima_36;
            Li_0 = Li_20;
         }
      }
      return (S1_OpenLong22(Gi_544, Li_0, ihigh_4, ima_12));
   }
   return (0);
}
		  				  	   	   	 	  		  	   	    		 		  	   					 	 	     					 		     	 	  				     		    	 	  	  			 									 			 		  	 	  		 	  	   	 		 	
// 3DAB84832E3339AFE000C7FCBE935FFE
int f0_8() {
   bool Li_0;
   double ilow_4;
   double ima_12;
   int datetime_24;
   double ilow_28;
   double ima_36;
   if (S1_OpenShort1(Gi_544, Bid)) return (1);
   if (S1_OpenShort2(Gi_544, Bid)) {
      Li_0 = TRUE;
      ilow_4 = iLow(NULL, PERIOD_M15, 1);
      ima_12 = G_ima_584;
      for (int Li_20 = 2; Li_20 < Gi_580; Li_20++) {
         datetime_24 = iTime(NULL, PERIOD_M15, Li_20);
         ilow_28 = iLow(NULL, PERIOD_M15, Li_20);
         ima_36 = iMA(NULL, PERIOD_M15, G_period_560, 0, MODE_SMMA, PRICE_MEDIAN, Li_20);
         if (TimeDayOfWeek(datetime_24) != G_day_of_week_424) break;
         if (ilow_28 > ima_36) break;
         if (ilow_28 < ilow_4) {
            ilow_4 = ilow_28;
            ima_12 = ima_36;
            Li_0 = Li_20;
         }
      }
      return (S1_OpenShort22(Gi_544, Li_0, ilow_4, ima_12));
   }
   return (0);
}
	  			   			   	 				 	 		    	  	 				 		    	 	 	  		  	 	 	  	   	 		 				 	 	 		  			  	   			      			 		  	 				 		  		  	  			 	  	   	 		
// 3685F5650D16B72FFB48183DC7AFC721
int f0_5(int A_ticket_0, int &A_ticket_4) {
   int cmd_24;
   double order_takeprofit_28;
   double order_stoploss_36;
   double order_lots_44;
   int datetime_52;
   double Ld_60;
   double order_profit_68;
   double Ld_76;
   double order_profit_8 = 0;
   double Ld_16 = 0;
   if (OrderSelect(A_ticket_0, SELECT_BY_TICKET)) {
      order_profit_8 = OrderProfit();
      cmd_24 = OrderType();
      order_lots_44 = OrderLots();
      order_takeprofit_28 = OrderTakeProfit();
      order_stoploss_36 = OrderStopLoss();
      datetime_52 = OrderOpenTime();
      switch (cmd_24) {
      case OP_BUY:
         Ld_16 = (OrderClosePrice() - OrderOpenPrice()) / Point;
         break;
      case OP_SELL:
         Ld_16 = (OrderOpenPrice() - OrderClosePrice()) / Point;
      }
   } else return (0);
   if (A_ticket_4 < 0) {
      if (Ld_16 < (-Gd_348) * G_pips_396 && G_datetime_408 - datetime_52 <= 3600.0 * Gd_364) {
         Ld_60 = f0_6(order_lots_44 * Gd_356);
         Print("Opening DA order with lot: ", DoubleToStr(Ld_60, 2), " [target_profit: ", DoubleToStr(Ld_16, 1), "]");
         A_ticket_4 = f0_18(cmd_24, Ld_60, f0_7(cmd_24 == OP_BUY, Bid, Ask), order_takeprofit_28, order_stoploss_36, G_magic_324, A_ticket_0, Green);
      }
   } else {
      Ld_76 = 0;
      if (OrderSelect(A_ticket_4, SELECT_BY_TICKET)) {
         order_profit_68 = OrderProfit();
         switch (OrderType()) {
         case OP_BUY:
            Ld_76 = (OrderClosePrice() - OrderOpenPrice()) / Point;
            break;
         case OP_SELL:
            Ld_76 = (OrderOpenPrice() - OrderClosePrice()) / Point;
         }
         if (OrderTakeProfit() == 0.0 || OrderStopLoss() == 0.0) {
            f0_17();
            OrderModify(OrderTicket(), OrderOpenPrice(), order_stoploss_36, order_takeprofit_28, 0, Green);
         }
      } else return (0);
      if (S1_CloseDa(Gi_544, datetime_52, order_profit_8, order_profit_68, order_lots_44)) {
         Print("Closing DA bucket with profit: ", DoubleToStr(order_profit_8 + order_profit_68, 2));
         return (1);
      }
   }
   return (0);
}
	  	 								 	 				   	 	  	  			 	 	 	 	  	  	  	 		 			 					        				   	  			      		 	  	  	 		 		  			  		 		    	  	 	 		   			  			  
// 9C188057B3CC2464220D62DC135F3C65
int f0_16() {
   double Ld_92;
   double Ld_100;
   double Ld_108;
   double Ld_116;
   double pips_124;
   double stoplevel_132;
   double Ld_140;
   int Li_148;
   double Ld_152;
   int Li_160;
   int Li_0 = SetMarket(Gi_548, G_datetime_408, Point, G_pips_396, MarketInfo(Symbol(), MODE_SPREAD), MarketInfo(Symbol(), MODE_TICKVALUE));
   SetBalance(Gi_548, AccountBalance(), AccountCurrency());
   HideTestIndicators(TRUE);
   double ima_4 = iMA(NULL, PERIOD_M5, G_period_596, 0, MODE_SMA, PRICE_CLOSE, 0);
   double ima_12 = iMA(NULL, PERIOD_M5, G_period_596, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ima_20 = iMA(NULL, PERIOD_M5, 40, 0, MODE_SMA, PRICE_CLOSE, 0);
   double imacd_28 = iMACD(NULL, PERIOD_M5, 12, 120, 24, PRICE_CLOSE, MODE_MAIN, 0);
   double imacd_36 = iMACD(NULL, PERIOD_M5, 12, 120, 24, PRICE_CLOSE, MODE_SIGNAL, 0);
   double iopen_44 = iOpen(NULL, PERIOD_M5, 0);
   double iclose_52 = iClose(NULL, PERIOD_M5, 0);
   double iopen_60 = iOpen(NULL, PERIOD_M1, 1);
   double iclose_68 = iClose(NULL, PERIOD_M1, 1);
   S2_SetIndicators(Gi_548, ima_4, ima_12, ima_20, imacd_28, imacd_36, iopen_44, iclose_52, iopen_60, iclose_68, iTime(NULL, G_timeframe_592, 0));
   int count_76 = 0;
   int count_80 = 0;
   for (int pos_84 = OrdersTotal() - 1; pos_84 >= 0; pos_84--) {
      if (OrderSelect(pos_84, SELECT_BY_POS)) {
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != S2_Magic) continue;
         switch (OrderType()) {
         case OP_BUY:
            if (S2_CloseLong(Gi_548, OrderProfit())) f0_25(Red);
            else {
               if (S2_TrailingStop > 0.0) {
                  if (Bid - OrderOpenPrice() >= Point * G_pips_396 * S2_TrailingStop) {
                     if (OrderStopLoss() < Bid - Point * G_pips_396 * S2_TrailingStop || OrderStopLoss() == 0.0) {
                        f0_17();
                        OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_396 * S2_TrailingStop, Digits), OrderTakeProfit(), 0, Green);
                     }
                  }
               }
               count_76++;
            }
            break;
         case OP_SELL:
            if (S2_CloseShort(Gi_548, OrderProfit())) f0_25(Red);
            else {
               if (S2_TrailingStop > 0.0) {
                  if (OrderOpenPrice() - Ask >= Point * G_pips_396 * S2_TrailingStop) {
                     if (OrderStopLoss() > Ask + Point * G_pips_396 * S2_TrailingStop || OrderStopLoss() == 0.0) {
                        f0_17();
                        OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_396 * S2_TrailingStop, Digits), OrderTakeProfit(), 0, Red);
                     }
                  }
               }
               count_80++;
            }
         }
      }
   }
   if (Li_0 && count_76 == 0 && count_80 == 0) {
      if (S2_Risk > 0.0) Ld_92 = f0_29(S2_Risk, AccountFreeMargin());
      else Ld_92 = f0_6(S2_Lot);
      if (S2_OpenLong(Gi_548, iTime(NULL, G_timeframe_592, 0))) {
         Ld_100 = 0;
         Ld_108 = 0;
         Ld_116 = 0;
         pips_124 = 0;
         stoplevel_132 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         Ld_140 = MathMin(iLow(NULL, PERIOD_H4, 0), iLow(NULL, PERIOD_H4, 1));
         Ld_116 = (Bid - Ld_140) / Point + 5.0 * G_pips_396;
         Ld_116 = MathMax(S2_MinStopLoss * G_pips_396, MathMin(S2_MaxStopLoss * G_pips_396, Ld_116));
         Ld_116 = MathMax(Ld_116, stoplevel_132);
         pips_124 = MathMax(S2_TakeProfit * G_pips_396, stoplevel_132);
         Ld_108 = NormalizeDouble(Bid - Ld_116 * Point, Digits);
         Ld_100 = NormalizeDouble(Ask + pips_124 * Point, Digits);
         Li_148 = f0_18(OP_BUY, Ld_92, Ask, Ld_100, Ld_108, S2_Magic, "", Blue);
      }
      if (S2_OpenShort(Gi_548, iTime(NULL, G_timeframe_592, 0))) {
         Ld_100 = 0;
         Ld_108 = 0;
         Ld_116 = 0;
         pips_124 = 0;
         stoplevel_132 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         Ld_152 = MathMax(iHigh(NULL, PERIOD_H4, 0), iHigh(NULL, PERIOD_H4, 1));
         Ld_116 = (Ld_152 - Bid) / Point + 5.0 * G_pips_396;
         Ld_116 = MathMax(S2_MinStopLoss * G_pips_396, MathMin(S2_MaxStopLoss * G_pips_396, Ld_116));
         pips_124 = MathMax(S2_TakeProfit * G_pips_396, stoplevel_132);
         Ld_108 = NormalizeDouble(Ask + Ld_116 * Point, Digits);
         Ld_100 = NormalizeDouble(Bid - pips_124 * Point, Digits);
         Li_160 = f0_18(OP_SELL, Ld_92, Bid, Ld_100, Ld_108, S2_Magic, "", Blue);
      }
   }
   return (0);
}
	  		 		 			 		  					 			   	 	 	 		  			   	 		 	    	 	 	  			   		   					 		 		 	  	  	 		 		   						 	 			 			 	 	  				   				 	 	    	 	
// FE3015C6EDFDE894DB7D09030346A754
int f0_33() {
   int magic_20;
   double iopen_28;
   double iopen_36;
   double iclose_44;
   double iopen_52;
   double iclose_60;
   double istochastic_68;
   double istochastic_76;
   double Ld_84;
   double Ld_92;
   double Ld_100;
   double pips_108;
   double pips_116;
   double stoplevel_124;
   int Li_132;
   int Li_136;
   int Li_0 = SetMarket(Gi_552, G_datetime_408, Point, G_pips_396, MarketInfo(Symbol(), MODE_SPREAD), MarketInfo(Symbol(), MODE_TICKVALUE));
   SetBalance(Gi_552, AccountBalance(), AccountCurrency());
   int count_4 = 0;
   int count_8 = 0;
   int count_12 = 0;
   for (int pos_16 = OrdersTotal() - 1; pos_16 >= 0; pos_16--) {
      if (OrderSelect(pos_16, SELECT_BY_POS)) {
         if (OrderSymbol() == Symbol()) {
            magic_20 = OrderMagicNumber();
            if (magic_20 == S1_Magic) {
               count_4++;
               continue;
            }
            if (magic_20 == S2_Magic) {
               count_8++;
               continue;
            }
            if (magic_20 == S3_Magic) {
               count_12++;
               switch (OrderType()) {
               case OP_BUY:
                  if (S3_TrailingStop <= 0.0) break;
                  if (Bid - OrderOpenPrice() < Point * G_pips_396 * S3_TrailingStop) break;
                  if (!(OrderStopLoss() < Bid - Point * G_pips_396 * S3_TrailingStop || OrderStopLoss() == 0.0)) break;
                  f0_17();
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_396 * S3_TrailingStop, Digits), OrderTakeProfit(), 0, Green);
                  break;
               case OP_SELL:
                  if (S3_TrailingStop <= 0.0) break;
                  if (OrderOpenPrice() - Ask < Point * G_pips_396 * S3_TrailingStop) break;
                  if (!(OrderStopLoss() > Ask + Point * G_pips_396 * S3_TrailingStop || OrderStopLoss() == 0.0)) break;
                  f0_17();
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_396 * S3_TrailingStop, Digits), OrderTakeProfit(), 0, Red);
               }
            }
         }
      }
   }
   if (Li_0 && count_4 == 0 && count_8 == 0 && count_12 == 0) {
      for (pos_16 = OrdersHistoryTotal() - 1; pos_16 >= 0; pos_16--) {
         if (OrderSelect(pos_16, SELECT_BY_POS, MODE_HISTORY))
            if (OrderMagicNumber() == S3_Magic && OrderOpenTime() >= Gi_416) count_12++;
      }
      if (count_12 == 0) {
         HideTestIndicators(TRUE);
         iopen_28 = iOpen(NULL, PERIOD_M5, 0);
         iopen_36 = iOpen(NULL, PERIOD_M1, 0);
         iclose_44 = iClose(NULL, PERIOD_M1, 0);
         iopen_52 = iOpen(NULL, PERIOD_H1, 1);
         iclose_60 = iClose(NULL, PERIOD_H1, 1);
         istochastic_68 = iStochastic(NULL, PERIOD_M15, 25, 13, 3, MODE_EMA, 0, MODE_MAIN, 0);
         istochastic_76 = iStochastic(NULL, PERIOD_M15, 25, 13, 3, MODE_EMA, 0, MODE_SIGNAL, 0);
         S3_SetIndicators(Gi_552, iopen_28, iopen_36, iclose_44, iopen_52, iclose_60, istochastic_68, istochastic_76);
         if (S3_Risk > 0.0) Ld_84 = f0_29(S3_Risk, AccountFreeMargin());
         else Ld_84 = f0_6(S3_Lot);
         if (S3_OpenLong(Gi_552)) {
            Ld_92 = 0;
            Ld_100 = 0;
            pips_108 = 0;
            pips_116 = 0;
            stoplevel_124 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            pips_108 = MathMax(S3_StopLoss * G_pips_396, stoplevel_124);
            pips_116 = MathMax(S3_TakeProfit * G_pips_396, stoplevel_124);
            Ld_100 = NormalizeDouble(Bid - pips_108 * Point, Digits);
            Ld_92 = NormalizeDouble(Ask + pips_116 * Point, Digits);
            Li_132 = f0_18(OP_BUY, Ld_84, Ask, Ld_92, Ld_100, S3_Magic, "", Blue);
         }
         if (S3_OpenShort(Gi_552)) {
            Ld_92 = 0;
            Ld_100 = 0;
            pips_108 = 0;
            pips_116 = 0;
            stoplevel_124 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            pips_108 = MathMax(S3_StopLoss * G_pips_396, stoplevel_124);
            pips_116 = MathMax(S3_TakeProfit * G_pips_396, stoplevel_124);
            Ld_100 = NormalizeDouble(Ask + pips_108 * Point, Digits);
            Ld_92 = NormalizeDouble(Bid - pips_116 * Point, Digits);
            Li_136 = f0_18(OP_SELL, Ld_84, Bid, Ld_92, Ld_100, S3_Magic, "", Blue);
         }
      }
   }
   return (0);
}
//------------------------------------------------------3
void CheckForOpen() {
//----------------
RefreshRates();

  double SymbolAUDUSDAsk=MarketInfo(SymbolAUDUSD,MODE_ASK);
  double SymbolAUDUSDBid=MarketInfo(SymbolAUDUSD,MODE_BID);

Print(SymbolAUDUSD + "-" +MyTime_AUUS+ "-" + MyTimeCAUS +"-" + MyTimeEUGB + ": x,,,,g TRADE,,TIME");

//-------
CTHour_EUGB();
CTHour_CAUS();
CTHour_AUUS();
double RSI,RSI1,RSIP,RSI15,RSI15P,S4H,S4H2,SD,EMA1,EMA2,down,up,WP,S4s1,S4s2;

   S4H=iStochastic(Symbol(),PERIOD_M5,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   down=0;
   up=0;
 if(S4H<40.0  ) down=1;//&& EMA1<EMA2 && iCCI_Signal > iCCI_OpenFilter
 if(S4H>60.0  ) up=1;//&& EMA1>EMA2&& iCCI_Signal > iCCI_OpenFilter


if (TRADEAUDUSD==TRUE)	
{
 mytrendAUDUSDHAK();
F4H_symbolAUDUSD();
//CheckTradingHour();
CTHour_EUGB();
CTHour_CAUS();
CTHour_AUUS();

checkhilowSymbolAUDUSD();
if (Volume[0] <= 1.0) {

if(MyTime_AUUS==1 || MyTimeCAUS==1 ||  MyTimeEUGB==1 && TrendAUDUSD==1 && g_lowest_404SymbolAUDUSD == 2 && SymbolAUDUSDBid <= F4_high_376SymbolAUDUSD - (800*Point))
{
if( CountOrders(SymbolAUDUSD,OP_BUY,Magic)<1)
MAXTRADE=1;else MAXTRADE=2;
if(AUDUSD_BUY==TRUE && CountOrders(SymbolAUDUSD,OP_BUY,Magic)<MAXTRADE)OrderSend(SymbolAUDUSD,OP_BUY,LotsOptimized(),SymbolAUDUSDAsk, 6, 0, 0, comment, Magic, 0, Blue);
}         
if( MyTime_AUUS==1 || MyTimeCAUS==1 ||  MyTimeEUGB==1 && TrendAUDUSD==2 && g_lowest_404SymbolAUDUSD == 2 && SymbolAUDUSDBid <= F4_low_392SymbolAUDUSD  + (15*Point))
{
OrderSend(SymbolAUDUSD,OP_BUY,LotsOptimized(),SymbolAUDUSDAsk, 6, 0, 0, comment2, Magic2, 0, Blue);
}

if(MyTime_AUUS==1 || MyTimeCAUS==1 ||  MyTimeEUGB==1 && TrendAUDUSD==2 && g_highest_400SymbolAUDUSD == 2 && SymbolAUDUSDAsk >= F4_low_392SymbolAUDUSD + (800*Point))
{
if(CountOrders(SymbolAUDUSD,OP_SELL,Magic)<1)
MAXTRADE=1;else MAXTRADE=2;
if( AUDUSD_SELL==TRUE && CountOrders(SymbolAUDUSD,OP_SELL,Magic)<MAXTRADE)OrderSend(SymbolAUDUSD, OP_SELL,LotsOptimized(), SymbolAUDUSDBid, 6, 0, 0,comment , Magic, 0, Red);
}

if(MyTime_AUUS==1 || MyTimeCAUS==1 ||  MyTimeEUGB==1 && TrendAUDUSD==1 && g_highest_400SymbolAUDUSD  == 2 && SymbolAUDUSDAsk >= F4_high_376SymbolAUDUSD - (15*Point))
{
OrderSend(SymbolAUDUSD, OP_SELL, LotsOptimized(), SymbolAUDUSDBid, 6, 0, 0,comment2, Magic2, 0, Red);
}

}}}


//8----------------
//----------------END OPEN ORDER


int CountOrders(string symbol,int Type,int Magic)
{
   int _CountOrd;
   _CountOrd=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==symbol)
      {
         if((OrderType()==Type&&(OrderMagicNumber()==Magic)||Magic==0))_CountOrd++;
      }
   }
   return(_CountOrd);
}
void CTHour_AUUS()
{
bool IS_AUUS=false;
int TH=TimeHour(TimeLocal());
  if(TH>=StartHour_AUUS+GMTOFFSET && TH<EndHour_AUUS+GMTOFFSET )
     IS_AUUS=true;
                 if(IS_AUUS==true)Trade_AUUS=1;
            else Trade_AUUS=2;
if(Trade_AUUS==1 )MyTime_AUUS=1;
    else if(Trade_AUUS==2 )MyTime_AUUS=2;
    else MyTime_AUUS=3;
return(MyTime_AUUS);
   }
void CTHour_CAUS()
{
bool IS_CAUS=false;
int TH=TimeHour(TimeLocal());
  if(TH>=StartHour_CAUS+GMTOFFSET && TH<EndHour_CAUS+GMTOFFSET )
     IS_CAUS=true;
                 if(IS_CAUS==true)TradeCAUS=1;
            else TradeCAUS=2;
if(TradeCAUS==1 )MyTimeCAUS=1;
    else if(TradeCAUS==2 )MyTimeCAUS=2;
    else MyTimeCAUS=3;
return(MyTimeCAUS);
   }
void CTHour_EUGB()
{
bool IS_EUGB=false;
int TH=TimeHour(TimeLocal());
  if(TH>=StartHour_EUGB+GMTOFFSET && TH<EndHour_EUGB+GMTOFFSET )
     IS_EUGB=true;
                 if(IS_EUGB==true)TradeEUGB=1;
            else TradeEUGB=2;
if(TradeEUGB==1 )MyTimeEUGB=1;
    else if(TradeEUGB==2 )MyTimeEUGB=2;
    else MyTimeEUGB=3;
return(MyTimeEUGB);
   }
double checkhilowSymbolAUDUSD() {
   if (Volume[0] <= 1.0) {
      for (gi_416SymbolAUDUSD = gi_176SymbolAUDUSD; gi_416SymbolAUDUSD >= gi_176SymbolAUDUSD; gi_416SymbolAUDUSD--) {
         gd_360SymbolAUDUSD = 0;
         gd_368SymbolAUDUSD = 0;
         g_highest_400SymbolAUDUSD = iHighest(SymbolAUDUSD, PERIOD_M5, MODE_HIGH, float, gi_416SymbolAUDUSD);
         g_lowest_404SymbolAUDUSD = iLowest(SymbolAUDUSD, PERIOD_M5, MODE_LOW, float, gi_416SymbolAUDUSD);
         g_high_376SymbolAUDUSD = iHigh(SymbolAUDUSD, PERIOD_M5,g_highest_400SymbolAUDUSD);
         g_low_392SymbolAUDUSD = iLow(SymbolAUDUSD, PERIOD_M5,g_lowest_404SymbolAUDUSD);
         gd_192SymbolAUDUSD = g_high_376SymbolAUDUSD - g_low_392SymbolAUDUSD;
         }
   }
   return (0.0);
}
double F4H_symbolAUDUSD() {
   if (Volume[0] <= 1.0) {
      for (F4_416SymbolAUDUSD = F4_176SymbolAUDUSD; F4_416SymbolAUDUSD >= F4_176SymbolAUDUSD; F4_416SymbolAUDUSD--) {
         F4_360SymbolAUDUSD = 0;
         F4_368SymbolAUDUSD = 0;
         F4_highest_400SymbolAUDUSD = iHighest(SymbolAUDUSD, PERIOD_H1, MODE_HIGH, floatH4, F4_416SymbolAUDUSD);
         F4_lowest_404SymbolAUDUSD = iLowest(SymbolAUDUSD, PERIOD_H1, MODE_LOW, floatH4, F4_416SymbolAUDUSD);
         F4_192SymbolAUDUSD = F4_high_376SymbolAUDUSD - F4_low_392SymbolAUDUSD;
         F4_high_376SymbolAUDUSD = iHigh(SymbolAUDUSD, PERIOD_H1,F4_highest_400SymbolAUDUSD);
         F4_low_392SymbolAUDUSD = iLow(SymbolAUDUSD, PERIOD_H1,F4_lowest_404SymbolAUDUSD);
                }
   }
   return (0.0);
}
double F1D_symbolAUDUSD() {
   if (Volume[0] <= 1.0) {
      for (F1d_416SymbolAUDUSD = F1d_176SymbolAUDUSD; F1d_416SymbolAUDUSD >= F1d_176SymbolAUDUSD; F1d_416SymbolAUDUSD--) {
         F1d_360SymbolAUDUSD = 0;
         F1d_368SymbolAUDUSD = 0;
         F1d_highest_400SymbolAUDUSD = iHighest(SymbolAUDUSD, PERIOD_D1, MODE_HIGH, FLOATD1, F1d_416SymbolAUDUSD);
         F1d_lowest_404SymbolAUDUSD = iLowest(SymbolAUDUSD, PERIOD_D1, MODE_LOW, FLOATD1, F1d_416SymbolAUDUSD);
         F1d_192SymbolAUDUSD = F1d_high_376SymbolAUDUSD - F1d_low_392SymbolAUDUSD;
         F1d_high_376SymbolAUDUSD = iHigh(SymbolAUDUSD, PERIOD_D1,F1d_highest_400SymbolAUDUSD);
         F1d_low_392SymbolAUDUSD = iLow(SymbolAUDUSD, PERIOD_D1,F1d_lowest_404SymbolAUDUSD);
                }
   }
   return (0.0);
}
double F1W_symbolAUDUSD() {
   if (Volume[0] <= 1.0) {
      for (F1W_416SymbolAUDUSD = F1W_176SymbolAUDUSD; F1W_416SymbolAUDUSD >= F1W_176SymbolAUDUSD; F1W_416SymbolAUDUSD--) {
         F1W_360SymbolAUDUSD = 0;
         F1W_368SymbolAUDUSD = 0;
         F1W_highest_400SymbolAUDUSD = iHighest(SymbolAUDUSD, PERIOD_W1, MODE_HIGH, FLOATW1, F1W_416SymbolAUDUSD);
         F1W_lowest_404SymbolAUDUSD = iLowest(SymbolAUDUSD, PERIOD_D1, MODE_LOW, FLOATW1, F1W_416SymbolAUDUSD);
         F1W_192SymbolAUDUSD = F1W_high_376SymbolAUDUSD - F1W_low_392SymbolAUDUSD;
         F1W_high_376SymbolAUDUSD = iHigh(SymbolAUDUSD, PERIOD_W1,F1W_highest_400SymbolAUDUSD);
         F1W_low_392SymbolAUDUSD = iLow(SymbolAUDUSD, PERIOD_D1,F1W_lowest_404SymbolAUDUSD);
                }
   }
   return (0.0);
}
int CalculateCurrentOrders(string as_unused_0) {
   int l_count_8 = 0;
   int l_count_12 = 0;
   for (int l_pos_16 = 0; l_pos_16 < OrdersTotal(); l_pos_16++) {
      if (OrderSelect(l_pos_16, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == 123456) {
         if (OrderType() == OP_BUY) l_count_8++;
         if (OrderType() == OP_SELL) l_count_12++;
      }
   }
   if (l_count_8 > 0) return (l_count_8);
   return (-l_count_12);
}
double LotsOptimized() {
   double l_lots_0 = MYLots;
   int l_hist_total_8 = OrdersHistoryTotal();
   int l_count_12 = 0;
   l_lots_0 = NormalizeDouble(AccountFreeMargin() * MaximumRisk / 10000.0, 1);
   if (DecreaseFactor > 0.0) {
      for (int l_pos_16 = l_hist_total_8 - 1; l_pos_16 >= 0; l_pos_16--) {
         if (OrderSelect(l_pos_16, SELECT_BY_POS, MODE_HISTORY) == FALSE) {
            Print("Error in history!");
            break;
         }
         if (OrderSymbol() != Symbol() || OrderType() > OP_SELL) continue;
         if (OrderProfit() > 0.0) break;
         if (OrderProfit() < 0.0) l_count_12++;
      }
      if (l_count_12 > 1) l_lots_0 = NormalizeDouble(l_lots_0 - l_lots_0 * l_count_12 / DecreaseFactor, 1);
   }
   if (l_lots_0 < MYLots) l_lots_0 = 0.01;
   return (l_lots_0);
}
void mytrendAUDUSDHAK()
  {
int AUDUSD_H_A_K;
double s1_AUDUSD=iCustom(SymbolAUDUSD, PERIOD_D1, H_A_K,4,0);
double s2_AUDUSD=iCustom(SymbolAUDUSD, PERIOD_D1,H_A_K,5,0);
double sd1_AUDUSD=iCustom(SymbolAUDUSD, PERIOD_D1, H_A_K,4,1);
double sd2_AUDUSD=iCustom(SymbolAUDUSD, PERIOD_D1,H_A_K,5,1);
  if(s2_AUDUSD>s1_AUDUSD && sd2_AUDUSD>sd1_AUDUSD )AUDUSD_H_A_K=1;
    else if(s2_AUDUSD<s1_AUDUSD && sd2_AUDUSD<sd1_AUDUSD)AUDUSD_H_A_K=2;
    else AUDUSD_H_A_K=3;
  {  if(AUDUSD_H_A_K==1 )TrendAUDUSD=1;
    else if(AUDUSD_H_A_K==2)TrendAUDUSD=2;
    else TrendAUDUSD=3;
return(TrendAUDUSD);
}}
void CloseAllProfit()
{
  for(int i=OrdersTotal()-1;i>=0;i--)
 {
    OrderSelect(i, SELECT_BY_POS);
RefreshRates();
 if (OrderMagicNumber()==Magic && OrderType() == OP_BUY && OrderProfit()+OrderSwap()>=MYProfitTarget*OrderLots()*100) OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
 if (OrderMagicNumber()==Magic && OrderType() == OP_SELL && OrderProfit()+OrderSwap()>=MYProfitTarget*OrderLots()*100) OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
 if (OrderMagicNumber()==Magic2 && OrderType() == OP_BUY && OrderProfit()+OrderSwap()>=MYProfitTarget_RT*OrderLots()*100) OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red );
 if (OrderMagicNumber()==Magic2 && OrderType() == OP_SELL && OrderProfit()+OrderSwap()>=MYProfitTarget_RT*OrderLots()*100) OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red );
 }
  return;
}

