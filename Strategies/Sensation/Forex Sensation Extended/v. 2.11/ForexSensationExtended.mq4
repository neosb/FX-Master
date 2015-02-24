
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
   void GetTime(int a0, int& a1[], int& a2[], int& a3[], int& a4[]);
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
   void S3_SetIndicators(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8);
   bool S3_OpenLong(int a0);
   bool S3_OpenShort(int a0);
   void S4_SetParameters(int a0, double a1, double a2);
   void S4_SetIndicators(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7);
   bool S4_OpenLong(int a0, double a1, int a2);
   bool S4_OpenShort(int a0, double a1, int a2);
#import

extern string v.1.11.5.133 = "";
extern string Code = "";
extern double TesterGmtOffset = 0.0;
extern double MaxSpread = 2.1;
extern bool NewsFilter = TRUE;
extern string _1 = "Strategy 1";
extern bool S1 = TRUE;
extern double S1_Lot = 0.1;
extern double S1_Risk = 0.2;
extern bool S1_AdaptiveLot = FALSE;
extern double S1_TakeProfit = 10.0;
extern double S1_StopLoss = 30.0;
extern double S1_AdaptiveTPk = 0.6;
extern double S1_AdaptiveSLk = 3.0;
extern double S1_MinStopLoss = 20.0;
extern double S1_MinTakeProfit = 5.0;
extern double S1_MaxStopLoss = 100.0;
extern double S1_MaxTakeProfit = 30.0;
extern string _2 = "Strategy 2";
extern bool S2 = TRUE;
extern double S2_Lot = 0.1;
extern double S2_Risk = 0.2;
extern bool S2_AdaptiveLot = TRUE;
extern double S2_TakeProfit = 70.0;
extern double S2_MinStopLoss = 20.0;
extern double S2_MaxStopLoss = 40.0;
extern double S2_TrailingStop = 20.0;
extern string _3 = "Strategy 3";
extern bool S3 = TRUE;
extern bool S3_Aggressive = FALSE;
extern double S3_Lot = 0.1;
extern double S3_Risk = 0.2;
extern bool S3_AdaptiveLot = TRUE;
extern double S3_TakeProfit = 40.0;
extern double S3_MinStopLoss = 20.0;
extern double S3_MaxStopLoss = 40.0;
extern double S3_TrailingStop = 7.0;
extern string _4 = "Strategy 4";
extern bool S4 = TRUE;
bool Gi_352 = FALSE;
extern double S4_Lot = 0.1;
extern double S4_Risk = 0.2;
extern bool S4_AdaptiveLot = TRUE;
extern double S4_TakeProfit = 40.0;
extern double S4_MinStopLoss = 20.0;
extern double S4_MaxStopLoss = 40.0;
extern double S4_TrailingStop = 10.0;
extern double S4_ThresholdK = 1.2;
extern double S4_TimeThreshold = 0.05;
extern int S1_Magic = 761349;
int G_magic_428 = 650238;
extern int S2_Magic = 4563216;
extern int S3_Magic = D'19.04.2001 06:23:51';
extern int S4_Magic = 789963;
double Gd_444 = 1.0;
bool Gi_452 = FALSE;
double Gd_456 = 5.0;
double Gd_464 = 1.5;
double Gd_472 = 4.0;
bool G_bool_480 = TRUE;
int Gi_484 = 20;
int Gi_488 = 20;
extern color TextColor1 = IndianRed;
extern color TextColor2 = Tomato;
int G_color_500 = C'0x64,0x64,0xFF';
double G_pips_504;
int G_global_var_512 = 0;
int G_datetime_516;
int Gi_520;
int Gi_524;
int Gi_unused_528;
int Gi_532;
int G_spread_536;
string Gsa_540[] = {".", "..", "...", "....", "....."};
int Gi_unused_544 = 0;
int Gi_unused_548 = 0;
int Gi_552 = 0;
int Gi_556 = 0;
int Gi_560 = 0;
int Gi_564;
int Gi_568;
int Gi_572;
int Gi_576;
string Gs_580 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
int Gi_unused_588 = 0;
int Gi_unused_592 = 0;
double Gda_unused_596[];
bool Gi_600 = FALSE;
string Gsa_604[];
string Gsa_608[];
string Gsa_612[];
int Gia_616[];
int Gia_620[];
int Gia_624[];
int Gi_628;
int Gi_632;
int Gi_636;
string G_str_concat_640;
string Gs_648;
int Gi_656 = -1;
int Gi_660 = -1;
int Gi_664 = -1;
int Gi_668 = -1;
bool Gi_672 = FALSE;
int Gia_676[1];
int Gia_680[1];
int Gia_684[1];
int Gia_688[1];
int G_period_692 = 70;
int G_period_696 = 11;
int G_period_700 = 11;
int G_period_704 = 18;
int G_period_708 = 18;
int Gi_712 = 56;
double G_ima_716;
int G_spread_724 = 0;
int G_spread_728 = 0;
int G_timeframe_732 = PERIOD_M5;
int G_period_736 = 17;
int G_spread_740 = 0;
int G_spread_744 = 0;
int G_spread_748 = 0;
int G_spread_752 = 0;
int G_spread_756 = 0;
int G_spread_760 = 0;

// 3BE4B59601B7B2E82D21E1C5C718B88F
double f0_7(bool Ai_0, double Ad_4, double Ad_12) {
   if (Ai_0) return (Ad_4);
   return (Ad_12);
}
					   	  	 	 			   	 		     	  	  	   	  	 		 			    		 	 				    	 			   	 	 	 	   				   	  	    	    			    		 											 						 			   		  
// 06CCE67E6D164C6A1BBC38BAD20E8EDF
int f0_0(bool Ai_0, int Ai_4, int Ai_8) {
   if (Ai_0) return (Ai_4);
   return (Ai_8);
}
	 		  		 	 				     			  	  	  		     		 	 			 	  	 	 	  		  	  		       	     	 		 	       				 	  								  			 	  	    		 	 	  		 		     		 		
// AEAA03D41A3A752C422C407A2EBDF031
string f0_20(int Ai_0) {
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
string f0_32(int Ai_0) {
   return (StringConcatenate("ForexSensationExtended", " lb: ", Ai_0));
}
	  			 					    	 	     			  			  	 		 					  			    	  		  	 	  		 			 			 						   		 	 	    				    	 	 			 	    	 	 	  		 			  		   	 	   		 
// 1D75F0D638248553D80CFFB8D1DC6682
void f0_2(int Ai_0, int &Ai_4, int &Ai_8) {
   string name_12 = f0_32(Ai_0);
   if (ObjectFind(name_12) == 0) {
      Ai_4 = ObjectGet(name_12, OBJPROP_XDISTANCE);
      Ai_8 = ObjectGet(name_12, OBJPROP_YDISTANCE);
   }
}
		 			 	  		     		       	  						 		 	  		  		 	   	      	 	 	 	 			   	 				     		  		    	  	    		  			 			  	 	  	 		 		 	 		    		   			
// C3BAA9C535265F9452B54C5C75FB8004
void f0_24(string A_text_0, color A_color_8 = -1, int Ai_12 = -1, double Ad_16 = -1.0, int Ai_24 = 0) {
   if (A_color_8 == CLR_NONE) A_color_8 = TextColor1;
   if (Ai_12 == -1) Ai_12 = Gi_556;
   if (Ad_16 == -1.0) Ad_16 = Gi_552;
   string name_28 = f0_32(Ai_12);
   if (ObjectFind(name_28) != 0) {
      ObjectCreate(name_28, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_28, OBJPROP_CORNER, 0);
   }
   ObjectSetText(name_28, A_text_0, 9, "Courier New", A_color_8);
   ObjectSet(name_28, OBJPROP_XDISTANCE, Gi_568 + Ai_24);
   ObjectSet(name_28, OBJPROP_YDISTANCE, Gi_564 + 14.0 * Ad_16);
   Gi_552 = MathMax(Gi_552, Ad_16 + 1.0);
   Gi_556 = MathMax(Gi_556, Ai_12 + 1);
   Gi_560 = MathMax(Gi_560, Ai_12);
}
			 		 	         	 	       	 					 			 	      		 			 	    			 	 	  				    					  		 		  	 	   	   	   		 	 		 						 	  		 	 		 		 	    	 	  			
// BF5A9BC44BBE42C10E8B2D4446B20D89
void f0_22(int Ai_0 = -1, double Ad_4 = -1.0, int Ai_12 = 0) {
   if (Ai_0 == -1) Ai_0 = Gi_556;
   if (Ad_4 == -1.0) Ad_4 = Gi_552;
   f0_24("_______", TextColor1, Ai_0, Ad_4 - 0.3, Ai_12);
   Gi_552 = MathMax(Gi_552, Ad_4 + 1.0);
}
		   		   	 	 		 				 		  				  				 		   	 	    	 					   	   		 		 	 	  		 	     			 	 				 	   			 	 	    		 		 	   	 	       	    		 				   	
// 8A6D85A0B52E3C8A8E55A15F14BE6D0A
int f0_15(string As_0, string As_8, int Ai_16 = -1, double Ad_20 = -1.0, int Ai_28 = 0) {
   if (Ai_16 == -1) Ai_16 = Gi_556;
   if (Ad_20 == -1.0) Ad_20 = Gi_552;
   f0_24(As_0, TextColor1, Ai_16, Ad_20, Ai_28);
   f0_24(As_8, TextColor2, Ai_16 + 1, Ad_20, Ai_28 + 7 * (StringLen(As_0) + 1));
   return (0);
}
	 		    		 			 		   		 			  	 	         		 				 	 	 	  				  			 	    				    	 			 	 			   		  		  		   			      	  				 		 		 	 		 	 		   			  
// C2C5CA64BFA878771207E31C1E4B9E4F
void f0_23(int Ai_0, int Ai_4) {
   Gi_568 = Ai_0;
   Gi_564 = Ai_4;
   if (Gi_572 != Ai_0 || Gi_576 != Ai_4) {
      Gi_572 = Gi_488;
      Gi_576 = Gi_484;
   } else f0_2(0, Gi_568, Gi_564);
   Gi_556 = 0;
   Gi_552 = 0;
}
	     	  		 				  						 				   	 		  	  		 		     		 		 	 	 	 					   	 			     	 		  	  					  						 		    	 	  	 	 	     	       			  				  	
// D61FF371629181373AAEA1B1C60EF302
void f0_28(int Ai_0, int Ai_4 = 0) {
   if (Ai_4 == 0) {
      Ai_4 = Gi_560;
      Gi_560 = Ai_0 - 1;
   }
   for (int Li_8 = Ai_0; Li_8 <= Ai_4; Li_8++) ObjectDelete(f0_32(Li_8));
}
			    		   		  		 			  	  		 		 	 	   		   									   	 		 		    	  	 	  	  			 			 	 		 			 		  			 	  	    	 			 		 			  						  	  		 					 
// CC9E8226BD8EC7D27CF11D972D60721C
int f0_25(string Asa_0[], int Aia_4[], int Ai_8 = -1, double Ad_12 = -1.0, int Ai_20 = 0) {
   int color_36;
   if (Ai_8 == -1) Ai_8 = Gi_556;
   if (Ad_12 == -1.0) Ad_12 = Gi_552;
   int arr_size_24 = ArraySize(Asa_0);
   if (arr_size_24 != ArraySize(Aia_4)) return (Ai_8);
   int Li_28 = 0;
   for (int index_32 = 0; index_32 < arr_size_24; index_32++) {
      color_36 = TextColor2;
      if (Aia_4[index_32] & 8 > 0) color_36 = G_color_500;
      f0_24(Asa_0[index_32], color_36, Ai_8, Ad_12, Ai_20 + 7 * Li_28);
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
void f0_21(string &Asa_0[], int Aia_4[], int Ai_8) {
   ArrayResize(Asa_0, Ai_8);
   ArrayResize(Aia_4, Ai_8);
   for (int index_12 = 0; index_12 < Ai_8; index_12++) Asa_0[index_12] = StringTrimLeft("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
}
	 			   		 	 	 		    	 			    	     	   		 	 		 	 	    				 				 	  	 				  	 	 			   			    	  		   	   				     	 					 					 	 				 		    		  
// 57862CA56FB6CA780A1AA075901C0C7C
double f0_12(string As_0) {
   int Li_24;
   As_0 = f0_27(As_0);
   int str_len_8 = StringLen(As_0);
   double Ld_ret_12 = 0;
   for (int Li_20 = 0; Li_20 < str_len_8; Li_20++) {
      Li_24 = StringFind(Gs_580, StringSubstr(As_0, str_len_8 - Li_20 - 1, 1));
      Ld_ret_12 += Li_24 * MathPow(36, Li_20);
   }
   return (Ld_ret_12);
}
	 	    	 	  		     			   	 		 			  	   	 	  				  			    			 		 		 	  	  	 	  		 				 	    			 	 	 			 				    		 		 		   	  			  	  	     						
// DF423827A5F770FA7875E68553FDD0BB
string f0_31(double Ad_0) {
   string str_concat_8 = "";
   for (Ad_0 = MathAbs(Ad_0); Ad_0 >= 1.0; Ad_0 = MathFloor(Ad_0 / 36.0)) str_concat_8 = StringConcatenate(StringSubstr(Gs_580, MathMod(Ad_0, 36), 1), str_concat_8);
   return (str_concat_8);
}
	  	 		  				 		  	 	 		 		 		  	 	  		  				       				 	     				  	 	 		  	   	  		 	  	 	 	  		 	 	 		 	 		 	      	   	       	  		  	 	   	
// D27AF7D1516C24C3278EA8BCC56C9759
string f0_27(string As_0) {
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
int f0_18() {
   for (int count_0 = 0; IsTradeContextBusy() && count_0 < 10; count_0++) Sleep(15);
   if (count_0 >= 10) Print("Trade context is buisy more than ", DoubleToStr(15 * count_0 / 1000, 2), " seconds");
   else
      if (count_0 > 0) Print("Trade context was buisy ", DoubleToStr(15 * count_0 / 1000, 2), " seconds");
   return (count_0);
}
		        	 		 	 					 	  			 	 				      	 			  	 		  	   	 				 		  		  		  	    		 		 					    				  	       		 	 			 	   		  	   	 	 						 	
// A908BF30D5A0CAE9E3CAA8BBF9AF6384
int f0_19(int A_cmd_0, double A_lots_4, double A_price_12, double A_price_20, double A_price_28, int A_magic_36, string A_comment_40, color A_color_48, bool Ai_52 = FALSE) {
   double price_56;
   double price_64;
   int error_76;
   double price_84;
   int ticket_72 = -1;
   int count_80 = 0;
   bool Li_92 = FALSE;
   double Ld_96 = 2.0 * G_pips_504 * Point;
   double slippage_104 = 3.0 * G_pips_504;
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
      f0_18();
      ticket_72 = OrderSend(Symbol(), A_cmd_0, A_lots_4, A_price_12, slippage_104, price_64, price_56, A_comment_40, A_magic_36, 0, A_color_48);
      if (ticket_72 >= 0) break;
      count_80++;
      error_76 = GetLastError();
      switch (error_76) {
      case 130/* INVALID_STOPS */:
         if (!Ai_52) G_global_var_512 = 1;
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
            f0_18();
            OrderModify(ticket_72, OrderOpenPrice(), A_price_28, A_price_20, 0, A_color_48);
         }
      }
      if (count_80 > 5) Print(f0_20(A_cmd_0) + " operation attempts: ", count_80);
   } else Print(f0_20(A_cmd_0) + " operation failed - error(", error_76, "): ", ErrorDescription(error_76), " attempts: ", count_80);
   return (ticket_72);
}
	 			 	 		 	 				    					          	 	 		 	 	  	 	   					 		 	 	  	  			  	   			    		    		 		   		  				 	   	 		 		 				  	 							    	   
// 0D8DF1C15E383B163F5CB1A2BE7799FC
int f0_1(int A_ticket_0, int Ai_4, double Ad_8 = 1.0) {
   if (OrderSelect(A_ticket_0, SELECT_BY_TICKET)) return (f0_26(Ai_4, Ad_8));
   return (-2);
}
					 			  	 		 		   		 	      	 	  	 			  	 	 				   	 	 	 		      	   	   	  		 	     		   				    			  			 		 		 		  						 								 		   	 	 
// D0B773F3CEA185836A86C349E30F8167
int f0_26(color A_color_0, double Ad_4 = 1.0) {
   double order_lots_12;
   double price_44;
   int error_52;
   string symbol_20 = OrderSymbol();
   if (Ad_4 == 1.0) order_lots_12 = OrderLots();
   else order_lots_12 = f0_6(OrderLots() * Ad_4);
   bool Li_28 = FALSE;
   double slippage_32 = 3.0 * f0_13(symbol_20);
   for (int count_40 = 0; count_40 < 10; count_40++) {
      if (f0_18() > 5) RefreshRates();
      if (OrderType() == OP_BUY) price_44 = MarketInfo(symbol_20, MODE_BID);
      else price_44 = MarketInfo(symbol_20, MODE_ASK);
      if (OrderClose(OrderTicket(), order_lots_12, price_44, slippage_32, A_color_0)) {
         Li_28 = TRUE;
         if (Ad_4 >= 1.0) return (-1);
         f0_11(OrderMagicNumber(), OrderType());
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
double f0_30(double Ad_0, double Ad_8) {
   int Li_16;
   return (f0_33(Ad_0, Ad_8, Li_16));
}
						     	   	 	     	     		 		  		     	  	  		  	 	  	 	 			   				    			   	  			 	              	 				  			 	 		 				 	  				  	 	    	 	
// EB20E9232C8D576D1AF86E66E193C68A
double f0_33(double Ad_0, double Ad_8, int &Ai_16) {
   if (AccountLeverage() < 100) return (f0_16(Ad_0 * Ad_8 / MarketInfo(Symbol(), MODE_MARGINREQUIRED), Ai_16));
   return (f0_16(Ad_0 * Ad_8 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / (AccountLeverage() / 100.0), Ai_16));
}
	  				 				  			 	   					  	    	 			 				    	    					  	  	 		 		 				 		  		   	 		 	   	 			   	  	 				     	  		  		   	  		 			 	      
// 38350FE142782EF0E6BB82AC5D70CEFB
double f0_6(double Ad_0) {
   int Li_8;
   return (f0_16(Ad_0, Li_8));
}
	      				 		  	 				  					 		  		   				 					  		   		 	 		  			  	 				  				 		 	 	 				 							 	 	     	   	 		 	    				    	  	 						 
// 8BB10F52F0AC31289E87BEDAE9317915
double f0_16(double Ad_0, int &Ai_8) {
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
double f0_13(string A_symbol_0) {
   double Ld_ret_8 = 0.0001 / MarketInfo(A_symbol_0, MODE_POINT);
   if (MarketInfo(A_symbol_0, MODE_DIGITS) < 4.0) Ld_ret_8 = 100.0 * Ld_ret_8;
   return (Ld_ret_8);
}
		  		    	    	 			   	  		 		 						    	   	  	 	 	 	   		 			 						  					    	 			 			      		    	   		  		 		 		 	  	 	  	  	  	 			  	 	
// 556B050CE914D18480D6EA30308C7790
int f0_11(int A_magic_0, int A_cmd_4) {
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
   f0_23(Gi_488, Gi_484);
   G_str_concat_640 = StringConcatenate("ForexSensationExtended", " v.", "1.12");
   f0_24(G_str_concat_640, TextColor2);
   f0_22();
   Gi_600 = CheckVersion("1.12");
   if (!Gi_600) {
      f0_15("Error:", "Dll and Expert versions mismatch");
      WindowRedraw();
      return (0);
   }
   Code = StringTrimLeft(StringTrimRight(Code));
   if (StringLen(Code) <= 0) {
      if (GlobalVariableCheck("FSEX_CODE")) {
         global_var_0 = GlobalVariableGet("FSEX_CODE");
         Code = f0_31(global_var_0);
      }
   } else {
      Ld_8 = f0_12(Code);
      GlobalVariableSet("FSEX_CODE", Ld_8);
   }
   G_bool_480 = G_bool_480 && (!IsTesting()) || IsVisualMode();
   Gs_648 = AccountName();
   Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   f0_24("Authentication...");
   WindowRedraw();
   int str_concat_16 = StatusWait();
   Gi_556--;
   Gi_552--;
   if (str_concat_16 & 1 == 0) {
      Li_20 = f0_3(1, 0, Gi_628, Gsa_604, Gia_616);
      Li_24 = ErrorCode();
      if (Li_24 == 0) str_concat_28 = str_concat_16;
      else str_concat_28 = StringConcatenate(str_concat_16, " (", Li_24, ")");
      if (Li_20 == 0) f0_15("Authentication Failed! Error: ", str_concat_28);
      Print("Authentication Failed! Error: ", str_concat_28);
   } else {
      Li_20 = f0_3(1, 0, Gi_628, Gsa_604, Gia_616);
      if (Li_20 == 0) f0_24("Authenticated");
   }
   if (S1) {
      Li_36 = 0;
      if (!NewsFilter) Li_36 |= 16;
      Gi_656 = StartExpert(1, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_656 < 0) f0_15("Strategy1:", "This currency is not supported!");
   } else Gi_656 = -1;
   if (S2) {
      Li_36 = 0;
      if (!NewsFilter) Li_36 |= 16;
      Gi_660 = StartExpert(2, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_660 < 0) f0_15("Strategy2:", "This currency is not supported!");
   } else Gi_660 = -1;
   if (S3) {
      Li_36 = 0;
      if (!NewsFilter) Li_36 |= 16;
      if (S3_Aggressive) Li_36 |= 1048576;
      Gi_664 = StartExpert(3, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_664 < 0) f0_15("Strategy3:", "This currency is not supported!");
   } else Gi_664 = -1;
   if (S4) {
      Li_36 = 0;
      if (Gi_352) Li_36 |= 2097152;
      Gi_668 = StartExpert(4, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_668 < 0) f0_15("Strategy4:", "This currency is not supported!");
      else S4_SetParameters(Gi_668, S4_ThresholdK, S4_TimeThreshold);
   } else Gi_668 = -1;
   WindowRedraw();
   if (Gi_656 < 0 && Gi_660 < 0 && Gi_664 < 0 && Gi_668 < 0) MessageBox("You have selected the wrong currency pair!", G_str_concat_640 + ": Warning", MB_ICONEXCLAMATION);
   G_pips_504 = f0_13(Symbol());
   G_global_var_512 = 0;
   if (!IsTesting())
      if (GlobalVariableCheck("FSEX_MARKET")) G_global_var_512 = GlobalVariableGet("FSEX_MARKET");
   return (0);
}
	   	   			  	 		 		 	 					  	   			   			  		 	  	   			 					 				 							 	 		 	  			 		 	  				 	   	  	      						   			 	   		 		 		 		  
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   StopExpert(Gi_656);
   StopExpert(Gi_660);
   StopExpert(Gi_664);
   StopExpert(Gi_668);
   if (IsTesting()) {
      if (!(!IsVisualMode())) return (0);
      f0_22();
      f0_15("TesterGmtOffset:", DoubleToStr(TesterGmtOffset, 1));
      f0_22();
      f0_15("Spread:", StringConcatenate(DoubleToStr(G_spread_536 / G_pips_504, 1), " (", G_spread_536, " pips)"));
      f0_22();
      return (0);
   }
   GlobalVariableSet("FSEX_MARKET", G_global_var_512);
   switch (UninitializeReason()) {
   case REASON_CHARTCLOSE:
   case REASON_REMOVE:
      f0_28(0, Gi_560);
      Gi_560 = 0;
      break;
   case REASON_RECOMPILE:
   case REASON_CHARTCHANGE:
   case REASON_PARAMETERS:
   case REASON_ACCOUNT:
      f0_28(1, Gi_560);
      Gi_560 = 1;
   }
   return (0);
}
	    		  		 	 		  			 		 					  	 		 		  		 	      					 	 	   					 	 	 			 	   	 			 	  			 	  				 	 		   		 	  	   	              		  			   	
// 25D8FA49F2C78939384F1B1F7C3C8CC3
int f0_3(int Ai_0, int Ai_4, int &Ai_8, string Asa_12[], int Aia_16[], string As_20 = "") {
   int Lia_28[1];
   int str_len_36;
   int Li_ret_32 = Msg(Ai_0, Ai_4, Lia_28);
   if (Lia_28[0] != Ai_8 || Li_ret_32 != ArraySize(Asa_12)) {
      Ai_8 = Lia_28[0];
      f0_21(Asa_12, Aia_16, Li_ret_32);
      GetMsg(Ai_0, Ai_4, Asa_12, Aia_16, Li_ret_32);
   }
   if (Li_ret_32 > 0) {
      str_len_36 = StringLen(As_20);
      if (str_len_36 > 0) {
         f0_24(As_20);
         f0_25(Asa_12, Aia_16, Gi_556, Gi_552 - 1, 7 * (str_len_36 + 1));
      } else f0_25(Asa_12, Aia_16);
   }
   return (Li_ret_32);
}
	  			 	 			      	      		  				 	 		 	 			  		     	   	  	 	 			 			  		 				 	   		   	    	 		    			 			 		   	 	    		 		   		     	   			
// 288510B44320B9D19D3AD3E90BD66D99
double f0_4(string As_0, double Ad_8, double Ad_16) {
   double Ld_ret_24;
   int Li_32;
   if (Ad_16 > 0.0) Ld_ret_24 = f0_33(Ad_16, AccountFreeMargin(), Li_32);
   else Ld_ret_24 = f0_16(Ad_8, Li_32);
   f0_15(StringConcatenate(As_0, "Lot:"), DoubleToStr(Ld_ret_24, 2));
   switch (Li_32) {
   case 1:
      f0_24("Maximum Lot size exeeded!");
      break;
   case -1:
      f0_24("Minimum Lot size exeeded!");
   }
   return (Ld_ret_24);
}
						     	   	 	     	     		 		  		     	  	  		  	 	  	 	 			   				    			   	  			 	              	 				  			 	 		 				 	  				  	 	    	 	
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   int Li_4;
   int Li_8;
   string str_concat_12;
   int Li_20;
   int Li_24;
   double Ld_28;
   double Ld_36;
   bool Li_44;
   if (!Gi_600) return (0);
   if (Gi_656 < 0 && Gi_660 < 0 && Gi_664 < 0 && Gi_668 < 0) return (0);
   if (Gs_648 != AccountName()) {
      Gs_648 = AccountName();
      Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   }
   int str_concat_0 = Status();
   if (G_bool_480) {
      f0_2(0, Gi_568, Gi_564);
      Gi_556 = 0;
      Gi_552 = 0;
      f0_24(G_str_concat_640, TextColor2);
      f0_22();
      if (str_concat_0 & 1 == 0) {
         Li_4 = f0_3(1, 0, Gi_628, Gsa_604, Gia_616);
         Li_8 = ErrorCode();
         if (Li_8 == 0) str_concat_12 = str_concat_0;
         else str_concat_12 = StringConcatenate(str_concat_0, " (", Li_8, ")");
         if (Li_4 == 0) f0_15("Authentication Failed! Error: ", str_concat_12);
      } else {
         Li_4 = f0_3(1, 0, Gi_628, Gsa_604, Gia_616);
         if (Li_4 == 0) f0_24("Authenticated");
         f0_22();
         Li_20 = f0_3(2, 0, Gi_632, Gsa_608, Gia_620);
         if (Li_20 > 0) f0_22();
         if (NewsFilter) {
            Li_24 = f0_3(3, f0_0(Gi_656 >= 0, Gi_656, f0_0(Gi_660 >= 0, Gi_660, Gi_664)), Gi_636, Gsa_612, Gia_624, "Market Alert:");
            if (Li_24 > 0) f0_22();
         }
         f0_15("ServerTime:", TimeToStr(TimeCurrent()));
         f0_15("UtcTime:", TimeToStr(Utc()));
         f0_22();
         f0_15("Spread:", StringConcatenate(DoubleToStr(G_spread_536 / G_pips_504, 1), " (", G_spread_536, " pips)"));
         f0_15("Leverage:", StringConcatenate(AccountLeverage(), ":1"));
         f0_22();
         Ld_28 = 0;
         if (Gi_656 >= 0) Ld_28 = MathMax(Ld_28, f0_4("S1 ", S1_Lot, S1_Risk));
         if (Gi_660 >= 0) Ld_28 = MathMax(Ld_28, f0_4("S2 ", S2_Lot, S2_Risk));
         if (Gi_664 >= 0) Ld_28 = MathMax(Ld_28, f0_4("S3 ", S3_Lot, S3_Risk));
         if (Gi_668 >= 0) Ld_28 = MathMax(Ld_28, f0_4("S4 ", S4_Lot, S4_Risk));
         Ld_36 = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED) * Ld_28, 8);
         Li_44 = NormalizeDouble(AccountFreeMargin(), 8) < Ld_36;
         if (Gi_672 != Li_44) {
            if (Li_44) Print("Not enough money! Available margin = ", DoubleToStr(AccountFreeMargin(), 2), ", Required margin = ", DoubleToStr(Ld_36, 2));
            Gi_672 = Li_44;
         }
         if (Li_44) {
            f0_22();
            f0_24("Not enough money!");
            f0_15("Available margin =", DoubleToStr(AccountFreeMargin(), 2));
            f0_15("Required margin =", DoubleToStr(Ld_36, 2));
         }
      }
      f0_28(Gi_556);
      WindowRedraw();
   }
   if (Gi_656 >= 0) f0_9();
   if (Gi_660 >= 0) f0_17();
   if (Gi_664 >= 0) f0_35();
   if (Gi_668 >= 0) f0_10();
   return (0);
}
	 		  		 	 				     			  	  	  		     		 	 			 	  	 	 	  		  	  		       	     	 		 	       				 	  								  			 	  	    		 	 	  		 		     		 		
// ED0B27723C00E3D9B41FB699DDF18A06
int f0_34(int Ai_0) {
   RefreshRates();
   G_datetime_516 = TimeCurrent();
   G_spread_536 = MarketInfo(Symbol(), MODE_SPREAD);
   int Li_ret_4 = SetMarket(Ai_0, G_datetime_516, Point, G_pips_504, G_spread_536, MarketInfo(Symbol(), MODE_TICKVALUE));
   GetTime(Ai_0, Gia_676, Gia_680, Gia_684, Gia_688);
   Gi_520 = Gia_676[0];
   Gi_unused_528 = Gia_680[0];
   Gi_524 = Gia_684[0];
   Gi_532 = Gia_688[0];
   SetBalance(Ai_0, AccountBalance(), AccountCurrency());
   return (Li_ret_4);
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
   double Ld_168;
   int Li_0 = f0_34(Gi_656);
   f0_14();
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
            if (OrderMagicNumber() == G_magic_428) {
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
            pips_96 = MathMax(S1_TakeProfit * G_pips_504, stoplevel_88);
            order_takeprofit_52 = NormalizeDouble(Ask + pips_96 * Point, Digits);
         }
         if (order_stoploss_44 == 0.0) {
            pips_104 = MathMax(S1_StopLoss * G_pips_504, stoplevel_88);
            order_stoploss_44 = NormalizeDouble(Bid - pips_104 * Point, Digits);
         }
         f0_18();
         OrderModify(ticket_4, order_open_price_20, order_stoploss_44, order_takeprofit_52, 0, Green);
      }
      if (Gi_452) {
         if (f0_5(ticket_4, ticket_12)) {
            ticket_4 = f0_1(ticket_4, 32768);
            ticket_12 = f0_1(ticket_12, 32768);
         }
      } else
         if (S1_CloseLong(Gi_656, Bid, order_open_price_20, datetime_36)) ticket_4 = f0_1(ticket_4, 255);
   } else
      if (ticket_12 >= 0) ticket_12 = f0_1(ticket_12, 32768);
   if (ticket_8 >= 0) {
      if (order_stoploss_60 == 0.0 || order_takeprofit_68 == 0.0) {
         stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         if (order_takeprofit_68 == 0.0) {
            pips_96 = MathMax(S1_TakeProfit * G_pips_504, stoplevel_88);
            order_takeprofit_68 = NormalizeDouble(Bid - pips_96 * Point, Digits);
         }
         if (order_stoploss_60 == 0.0) {
            pips_104 = MathMax(S1_StopLoss * G_pips_504, stoplevel_88);
            order_stoploss_60 = NormalizeDouble(Ask + pips_104 * Point, Digits);
         }
         f0_18();
         OrderModify(ticket_8, order_open_price_28, order_stoploss_60, order_takeprofit_68, 0, Green);
      }
      if (Gi_452) {
         if (f0_5(ticket_8, ticket_16)) {
            ticket_8 = f0_1(ticket_8, 32768);
            ticket_16 = f0_1(ticket_16, 32768);
         }
      } else
         if (S1_CloseShort(Gi_656, Ask, order_open_price_28, datetime_40)) ticket_8 = f0_1(ticket_8, 255);
   } else
      if (ticket_16 >= 0) ticket_16 = f0_1(ticket_16, 32768);
   if (Li_0 && ticket_4 < 0 || ticket_8 < 0) {
      if (S1_Risk > 0.0) Ld_112 = f0_30(S1_Risk, AccountFreeMargin());
      else Ld_112 = f0_6(S1_Lot);
      Li_120 = f0_29();
      Li_124 = f0_8();
      Ld_128 = S1_TakeProfit * G_pips_504;
      Ld_136 = S1_StopLoss * G_pips_504;
      if (Li_120 || Li_124 && S1_AdaptiveTPk > 0.0) {
         iatr_144 = iATR(NULL, PERIOD_M15, 14, 0);
         Ld_128 = S1_AdaptiveTPk * iatr_144 / Point;
         Ld_136 = S1_AdaptiveSLk * iatr_144 / Point;
         Ld_128 = MathMax(S1_MinTakeProfit * G_pips_504, MathMin(S1_MaxTakeProfit * G_pips_504, Ld_128));
         Ld_136 = MathMax(S1_MinStopLoss * G_pips_504, MathMin(S1_MaxStopLoss * G_pips_504, Ld_136));
      }
      if (Li_120 || Li_124 && Gd_444 > 0.0) {
         for (pos_76 = OrdersHistoryTotal() - 1; pos_76 >= 0; pos_76--) {
            if (OrderSelect(pos_76, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol()) {
                  if (OrderMagicNumber() == S1_Magic) {
                     if ((G_datetime_516 - OrderCloseTime()) / 3600.0 <= Gd_444) {
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
         if (G_spread_536 <= MaxSpread * G_pips_504) {
            Ld_152 = 0;
            Ld_160 = 0;
            Ld_168 = 1;
            pips_104 = 0;
            pips_96 = 0;
            stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            pips_104 = MathMax(Ld_136, stoplevel_88);
            pips_96 = MathMax(Ld_128, stoplevel_88);
            if (S1_AdaptiveLot) Ld_168 = S1_MinStopLoss * G_pips_504 / pips_104;
            Ld_160 = NormalizeDouble(Bid - pips_104 * Point, Digits);
            Ld_152 = NormalizeDouble(Ask + pips_96 * Point, Digits);
            ticket_4 = f0_19(OP_BUY, Ld_112 * Ld_168, Ask, Ld_152, Ld_160, S1_Magic, "", Blue);
            if (ticket_4 >= 0) Print("S1: Buy order placed [spread: ", G_spread_536, "]");
         } else {
            if (G_spread_724 < G_spread_536) Print("S1 Buy failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
            G_spread_724 = G_spread_536;
         }
      }
      if (Li_124 && ticket_8 < 0) {
         if (G_spread_536 <= MaxSpread * G_pips_504) {
            Ld_152 = 0;
            Ld_160 = 0;
            pips_104 = 0;
            pips_96 = 0;
            Ld_168 = 1;
            stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            pips_104 = MathMax(Ld_136, stoplevel_88);
            pips_96 = MathMax(Ld_128, stoplevel_88);
            if (S1_AdaptiveLot) Ld_168 = S1_MinStopLoss * G_pips_504 / pips_104;
            Ld_160 = NormalizeDouble(Ask + pips_104 * Point, Digits);
            Ld_152 = NormalizeDouble(Bid - pips_96 * Point, Digits);
            ticket_8 = f0_19(OP_SELL, Ld_112 * Ld_168, Bid, Ld_152, Ld_160, S1_Magic, "", Blue);
            if (ticket_8 >= 0) Print("S1: Sell order placed [spread: ", G_spread_536, "]");
         } else {
            if (G_spread_728 < G_spread_536) Print("S1 Sell failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
            G_spread_728 = G_spread_536;
         }
      }
   }
   return (0);
}
	 	 	 				   		 	  	 		 		 	   	   		 				   	 		 		  	 						   	 		   		 		  					    	  	 					 	 			 		 	 		  				  	 	 		 		 	 			 	  	 	 	 
// 635171E21C4AAA4E3B8671F1CEA4CD16
void f0_14() {
   HideTestIndicators(TRUE);
   double iopen_0 = iOpen(NULL, PERIOD_M15, 1);
   double iclose_8 = iClose(NULL, PERIOD_M15, 1);
   G_ima_716 = iMA(NULL, PERIOD_M15, G_period_692, 0, MODE_SMMA, PRICE_MEDIAN, 1);
   double istochastic_16 = iStochastic(NULL, PERIOD_M15, G_period_696, 1, 1, MODE_SMA, 0, MODE_MAIN, 1);
   double iwpr_24 = iWPR(NULL, PERIOD_M1, G_period_700, 0);
   double icci_32 = iCCI(NULL, PERIOD_M1, G_period_704, PRICE_CLOSE, 0);
   double icci_40 = iCCI(NULL, PERIOD_M5, G_period_708, PRICE_CLOSE, 0);
   double ima_48 = iMA(NULL, PERIOD_M15, G_period_692 / 2.0, 0, MODE_SMMA, PRICE_MEDIAN, 1);
   S1_SetIndicators(Gi_656, iopen_0, iclose_8, G_ima_716, istochastic_16, iwpr_24, icci_32, icci_40, ima_48);
}
		   	 		 	 	   					   	 						 			 	 		 	 	 				 			  	  	  	   		 		 	 		 				  				 					  		 			  	     	 	 	 	  	 		    				      					 		 
// D925AC83A3A30655165085569C2CB44E
int f0_29() {
   bool Li_0;
   double ihigh_4;
   double ima_12;
   int datetime_24;
   double ihigh_28;
   double ima_36;
   if (S1_OpenLong1(Gi_656, Bid)) return (1);
   if (S1_OpenLong2(Gi_656, Bid)) {
      Li_0 = TRUE;
      ihigh_4 = iHigh(NULL, PERIOD_M15, 1);
      ima_12 = G_ima_716;
      for (int Li_20 = 2; Li_20 < Gi_712; Li_20++) {
         datetime_24 = iTime(NULL, PERIOD_M15, Li_20);
         ihigh_28 = iHigh(NULL, PERIOD_M15, Li_20);
         ima_36 = iMA(NULL, PERIOD_M15, G_period_692, 0, MODE_SMMA, PRICE_MEDIAN, Li_20);
         if (TimeDayOfWeek(datetime_24) != Gi_532) break;
         if (ihigh_28 < ima_36) break;
         if (ihigh_28 > ihigh_4) {
            ihigh_4 = ihigh_28;
            ima_12 = ima_36;
            Li_0 = Li_20;
         }
      }
      return (S1_OpenLong22(Gi_656, Li_0, ihigh_4, ima_12));
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
   if (S1_OpenShort1(Gi_656, Bid)) return (1);
   if (S1_OpenShort2(Gi_656, Bid)) {
      Li_0 = TRUE;
      ilow_4 = iLow(NULL, PERIOD_M15, 1);
      ima_12 = G_ima_716;
      for (int Li_20 = 2; Li_20 < Gi_712; Li_20++) {
         datetime_24 = iTime(NULL, PERIOD_M15, Li_20);
         ilow_28 = iLow(NULL, PERIOD_M15, Li_20);
         ima_36 = iMA(NULL, PERIOD_M15, G_period_692, 0, MODE_SMMA, PRICE_MEDIAN, Li_20);
         if (TimeDayOfWeek(datetime_24) != Gi_532) break;
         if (ilow_28 > ima_36) break;
         if (ilow_28 < ilow_4) {
            ilow_4 = ilow_28;
            ima_12 = ima_36;
            Li_0 = Li_20;
         }
      }
      return (S1_OpenShort22(Gi_656, Li_0, ilow_4, ima_12));
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
      if (Ld_16 < (-Gd_456) * G_pips_504 && G_datetime_516 - datetime_52 <= 3600.0 * Gd_472) {
         Ld_60 = f0_6(order_lots_44 * Gd_464);
         Print("Opening DA order with lot: ", DoubleToStr(Ld_60, 2), " [target_profit: ", DoubleToStr(Ld_16, 1), "]");
         A_ticket_4 = f0_19(cmd_24, Ld_60, f0_7(cmd_24 == OP_BUY, Bid, Ask), order_takeprofit_28, order_stoploss_36, G_magic_428, A_ticket_0, Green);
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
            f0_18();
            OrderModify(OrderTicket(), OrderOpenPrice(), order_stoploss_36, order_takeprofit_28, 0, Green);
         }
      } else return (0);
      if (S1_CloseDa(Gi_656, datetime_52, order_profit_8, order_profit_68, order_lots_44)) {
         Print("Closing DA bucket with profit: ", DoubleToStr(order_profit_8 + order_profit_68, 2));
         return (1);
      }
   }
   return (0);
}
	 	  	 			  	   	  		   		 					   	 	 			  	 			 				  				  	  	 	 		 		 	 										 	  		  			 		  	 		  	 	  		  	 	 	   			 	     	  		 		 
// 9C188057B3CC2464220D62DC135F3C65
int f0_17() {
   double Ld_92;
   double istochastic_100;
   double Ld_108;
   double Ld_116;
   double Ld_124;
   double Ld_132;
   double pips_140;
   double stoplevel_148;
   double Ld_156;
   int Li_164;
   double Ld_168;
   int Li_176;
   int Li_0 = f0_34(Gi_660);
   HideTestIndicators(TRUE);
   double ima_4 = iMA(NULL, PERIOD_M5, G_period_736, 0, MODE_SMA, PRICE_CLOSE, 0);
   double ima_12 = iMA(NULL, PERIOD_M5, G_period_736, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ima_20 = iMA(NULL, PERIOD_M5, 40, 0, MODE_SMA, PRICE_CLOSE, 0);
   double imacd_28 = iMACD(NULL, PERIOD_M5, 12, 120, 24, PRICE_CLOSE, MODE_MAIN, 0);
   double imacd_36 = iMACD(NULL, PERIOD_M5, 12, 120, 24, PRICE_CLOSE, MODE_SIGNAL, 0);
   double iopen_44 = iOpen(NULL, PERIOD_M5, 0);
   double iclose_52 = iClose(NULL, PERIOD_M5, 0);
   double iopen_60 = iOpen(NULL, PERIOD_M1, 1);
   double iclose_68 = iClose(NULL, PERIOD_M1, 1);
   S2_SetIndicators(Gi_660, ima_4, ima_12, ima_20, imacd_28, imacd_36, iopen_44, iclose_52, iopen_60, iclose_68, iTime(NULL, G_timeframe_732, 0));
   int count_76 = 0;
   int count_80 = 0;
   for (int pos_84 = OrdersTotal() - 1; pos_84 >= 0; pos_84--) {
      if (OrderSelect(pos_84, SELECT_BY_POS)) {
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != S2_Magic) continue;
         switch (OrderType()) {
         case OP_BUY:
            if (S2_CloseLong(Gi_660, OrderProfit())) f0_26(Red);
            else {
               if (S2_TrailingStop > 0.0) {
                  if (Bid - OrderOpenPrice() >= Point * G_pips_504 * S2_TrailingStop) {
                     if (OrderStopLoss() < Bid - Point * G_pips_504 * S2_TrailingStop || OrderStopLoss() == 0.0) {
                        f0_18();
                        OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_504 * S2_TrailingStop, Digits), OrderTakeProfit(), 0, Green);
                     }
                  }
               }
               count_76++;
            }
            break;
         case OP_SELL:
            if (S2_CloseShort(Gi_660, OrderProfit())) f0_26(Red);
            else {
               if (S2_TrailingStop > 0.0) {
                  if (OrderOpenPrice() - Ask >= Point * G_pips_504 * S2_TrailingStop) {
                     if (OrderStopLoss() > Ask + Point * G_pips_504 * S2_TrailingStop || OrderStopLoss() == 0.0) {
                        f0_18();
                        OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_504 * S2_TrailingStop, Digits), OrderTakeProfit(), 0, Red);
                     }
                  }
               }
               count_80++;
            }
         }
      }
   }
   if (Li_0 && count_76 == 0 && count_80 == 0) {
      if (S2_Risk > 0.0) Ld_92 = f0_30(S2_Risk, AccountFreeMargin());
      else Ld_92 = f0_6(S2_Lot);
      istochastic_100 = iStochastic(NULL, PERIOD_H1, 48, 13, 3, MODE_SMA, 0, MODE_MAIN, 0);
      if (S2_OpenLong(Gi_660, iTime(NULL, G_timeframe_732, 0)) && istochastic_100 < 75.0 && istochastic_100 > 25.0) {
         if (G_spread_536 <= MaxSpread * G_pips_504) {
            Ld_108 = 0;
            Ld_116 = 0;
            Ld_124 = 1;
            Ld_132 = 0;
            pips_140 = 0;
            stoplevel_148 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            Ld_156 = MathMin(iLow(NULL, PERIOD_M30, 0), iLow(NULL, PERIOD_M30, 1));
            Ld_132 = (Bid - Ld_156) / 1.5 / Point + 5.0 * G_pips_504;
            Ld_132 = MathMax(S2_MinStopLoss * G_pips_504, MathMin(S2_MaxStopLoss * G_pips_504, Ld_132));
            Ld_132 = MathMax(Ld_132, stoplevel_148);
            pips_140 = MathMax(S2_TakeProfit * G_pips_504, stoplevel_148);
            if (S2_AdaptiveLot) Ld_124 = S2_MinStopLoss * G_pips_504 / Ld_132;
            Ld_116 = NormalizeDouble(Bid - Ld_132 * Point, Digits);
            Ld_108 = NormalizeDouble(Ask + pips_140 * Point, Digits);
            Li_164 = f0_19(OP_BUY, Ld_92 * Ld_124, Ask, Ld_108, Ld_116, S2_Magic, "", Blue);
            if (Li_164 >= 0) Print("S2: Buy order placed [spread: ", G_spread_536, "]");
         } else {
            if (G_spread_740 < G_spread_536) Print("S2 Buy failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
            G_spread_740 = G_spread_536;
         }
      }
      if (S2_OpenShort(Gi_660, iTime(NULL, G_timeframe_732, 0)) && istochastic_100 > 25.0 && istochastic_100 < 75.0) {
         if (G_spread_536 <= MaxSpread * G_pips_504) {
            Ld_108 = 0;
            Ld_116 = 0;
            Ld_132 = 0;
            pips_140 = 0;
            Ld_124 = 1;
            stoplevel_148 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            Ld_168 = MathMax(iHigh(NULL, PERIOD_M30, 0), iHigh(NULL, PERIOD_M30, 1));
            Ld_132 = (Ld_168 - Bid) / 1.5 / Point + 5.0 * G_pips_504;
            Ld_132 = MathMax(S2_MinStopLoss * G_pips_504, MathMin(S2_MaxStopLoss * G_pips_504, Ld_132));
            pips_140 = MathMax(S2_TakeProfit * G_pips_504, stoplevel_148);
            if (S2_AdaptiveLot) Ld_124 = S2_MinStopLoss * G_pips_504 / Ld_132;
            Ld_116 = NormalizeDouble(Ask + Ld_132 * Point, Digits);
            Ld_108 = NormalizeDouble(Bid - pips_140 * Point, Digits);
            Li_176 = f0_19(OP_SELL, Ld_92 * Ld_124, Bid, Ld_108, Ld_116, S2_Magic, "", Blue);
            if (Li_176 >= 0) Print("S2: Sell order placed [spread: ", G_spread_536, "]");
         } else {
            if (G_spread_744 < G_spread_536) Print("S2 Sell failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
            G_spread_744 = G_spread_536;
         }
      }
   }
   return (0);
}
	 	 				 	    	    	  	  	 	 	 		  					 	     	  		 		  				   		 			   	 			 	 			 	     	  		 	 	  					 					 			     	 	  	  	 	 	    	   		
// FE3015C6EDFDE894DB7D09030346A754
int f0_35() {
   int magic_24;
   double irsi_32;
   double irsi_40;
   double iatr_48;
   double iatr_56;
   double istochastic_64;
   double istochastic_72;
   double istochastic_80;
   double istochastic_88;
   double istochastic_96;
   double Ld_104;
   double Ld_112;
   double Ld_120;
   double Ld_128;
   double Ld_136;
   double pips_144;
   double stoplevel_152;
   double Ld_160;
   int Li_168;
   double Ld_172;
   int Li_180;
   int Li_0 = f0_34(Gi_664);
   int count_4 = 0;
   int count_8 = 0;
   int count_12 = 0;
   int count_16 = 0;
   for (int pos_20 = OrdersTotal() - 1; pos_20 >= 0; pos_20--) {
      if (OrderSelect(pos_20, SELECT_BY_POS)) {
         if (OrderSymbol() == Symbol()) {
            magic_24 = OrderMagicNumber();
            if (magic_24 == S1_Magic) {
               count_4++;
               continue;
            }
            if (magic_24 == S2_Magic) {
               count_8++;
               continue;
            }
            if (magic_24 == S4_Magic) {
               count_16++;
               continue;
            }
            if (magic_24 == S3_Magic) {
               count_12++;
               switch (OrderType()) {
               case OP_BUY:
                  if (S3_TrailingStop <= 0.0) break;
                  if (Bid - OrderOpenPrice() < Point * G_pips_504 * S3_TrailingStop) break;
                  if (!(OrderStopLoss() < Bid - Point * G_pips_504 * S3_TrailingStop || OrderStopLoss() == 0.0)) break;
                  f0_18();
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_504 * S3_TrailingStop, Digits), OrderTakeProfit(), 0, Green);
                  break;
               case OP_SELL:
                  if (S3_TrailingStop <= 0.0) break;
                  if (OrderOpenPrice() - Ask < Point * G_pips_504 * S3_TrailingStop) break;
                  if (!(OrderStopLoss() > Ask + Point * G_pips_504 * S3_TrailingStop || OrderStopLoss() == 0.0)) break;
                  f0_18();
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_504 * S3_TrailingStop, Digits), OrderTakeProfit(), 0, Red);
               }
            }
         }
      }
   }
   if (Li_0 && count_4 == 0 && count_8 == 0 && count_12 == 0 && count_16 == 0) {
      for (pos_20 = OrdersHistoryTotal() - 1; pos_20 >= 0; pos_20--) {
         if (OrderSelect(pos_20, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != S3_Magic) continue;
            if (OrderOpenTime() >= Gi_524) count_12++;
         }
      }
      if (count_12 == 0) {
         HideTestIndicators(TRUE);
         irsi_32 = iRSI(NULL, PERIOD_M1, 10, PRICE_CLOSE, 0);
         irsi_40 = iRSI(NULL, PERIOD_M1, 10, PRICE_CLOSE, 2);
         iatr_48 = iATR(NULL, PERIOD_M1, 3, 0);
         iatr_56 = iATR(NULL, PERIOD_M1, 10, 0);
         istochastic_64 = iStochastic(NULL, PERIOD_M15, 25, 13, 3, MODE_EMA, 0, MODE_MAIN, 0);
         istochastic_72 = iStochastic(NULL, PERIOD_M15, 25, 13, 3, MODE_EMA, 0, MODE_SIGNAL, 0);
         istochastic_80 = iStochastic(NULL, PERIOD_M15, 25, 13, 3, MODE_EMA, 0, MODE_MAIN, 1);
         istochastic_88 = iStochastic(NULL, PERIOD_M15, 25, 13, 3, MODE_EMA, 0, MODE_MAIN, 3);
         istochastic_96 = iStochastic(NULL, PERIOD_M15, 24, 13, 3, MODE_SMA, 0, MODE_MAIN, 0);
         S3_SetIndicators(Gi_664, irsi_32, irsi_40, iatr_48, iatr_56, istochastic_64, istochastic_72, istochastic_80, istochastic_88);
         if (S3_Risk > 0.0) Ld_104 = f0_30(S3_Risk, AccountFreeMargin());
         else Ld_104 = f0_6(S3_Lot);
         if (S3_OpenLong(Gi_664) && istochastic_96 < 84.0) {
            if (G_spread_536 <= MaxSpread * G_pips_504) {
               Ld_112 = 0;
               Ld_120 = 0;
               Ld_128 = 1;
               Ld_136 = 0;
               pips_144 = 0;
               stoplevel_152 = MarketInfo(Symbol(), MODE_STOPLEVEL);
               Ld_160 = MathMin(MathMin(iLow(NULL, PERIOD_H1, 0), iLow(NULL, PERIOD_H1, 1)), iLow(NULL, PERIOD_H1, 2));
               Ld_136 = (Bid - Ld_160) / Point + 5.0 * G_pips_504;
               Ld_136 = MathMax(S3_MinStopLoss * G_pips_504, MathMin(S3_MaxStopLoss * G_pips_504, Ld_136));
               Ld_136 = MathMax(Ld_136, stoplevel_152);
               pips_144 = MathMax(S3_TakeProfit * G_pips_504, stoplevel_152);
               if (S3_AdaptiveLot) Ld_128 = S3_MinStopLoss * G_pips_504 / Ld_136;
               Ld_120 = NormalizeDouble(Bid - Ld_136 * Point, Digits);
               Ld_112 = NormalizeDouble(Ask + pips_144 * Point, Digits);
               Li_168 = f0_19(OP_BUY, Ld_104 * Ld_128, Ask, Ld_112, Ld_120, S3_Magic, "", Blue);
               if (Li_168 >= 0) Print("S3: Buy order placed [spread: ", G_spread_536, "]");
            } else {
               if (G_spread_748 < G_spread_536) Print("S3 Buy failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
               G_spread_748 = G_spread_536;
            }
         }
         if (S3_OpenShort(Gi_664) && istochastic_96 > 16.0) {
            if (G_spread_536 <= MaxSpread * G_pips_504) {
               Ld_112 = 0;
               Ld_120 = 0;
               Ld_136 = 0;
               pips_144 = 0;
               Ld_128 = 1;
               stoplevel_152 = MarketInfo(Symbol(), MODE_STOPLEVEL);
               Ld_172 = MathMax(MathMax(iHigh(NULL, PERIOD_H1, 0), iHigh(NULL, PERIOD_H1, 1)), iHigh(NULL, PERIOD_H1, 2));
               Ld_136 = (Ld_172 - Bid) / Point + 5.0 * G_pips_504;
               Ld_136 = MathMax(S3_MinStopLoss * G_pips_504, MathMin(S3_MaxStopLoss * G_pips_504, Ld_136));
               pips_144 = MathMax(S3_TakeProfit * G_pips_504, stoplevel_152);
               if (S3_AdaptiveLot) Ld_128 = S3_MinStopLoss * G_pips_504 / Ld_136;
               Ld_120 = NormalizeDouble(Ask + Ld_136 * Point, Digits);
               Ld_112 = NormalizeDouble(Bid - pips_144 * Point, Digits);
               Li_180 = f0_19(OP_SELL, Ld_104 * Ld_128, Bid, Ld_112, Ld_120, S3_Magic, "", Blue);
               if (Li_180 >= 0) Print("S3: Sell order placed [spread: ", G_spread_536, "]");
            } else {
               if (G_spread_752 < G_spread_536) Print("S3 Sell failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
               G_spread_752 = G_spread_536;
            }
         }
      }
   }
   return (0);
}
		 	 	    			  	 		 	  	  	 			 			  	    			 	  	  		 	      			 	  			  	  		     				 		 	     	 	   	  	 	  		    		 	 	  	  	 	   	 		 	 	 	
// 46A00F137DAF4FF1870B7A33CD046E7D
int f0_10() {
   double imacd_16;
   double imacd_24;
   double iatr_32;
   int Li_40;
   double Ld_44;
   double Ld_52;
   double Ld_60;
   double Ld_68;
   double Ld_76;
   double pips_84;
   double stoplevel_92;
   double Ld_100;
   int Li_108;
   double Ld_112;
   int Li_120;
   int Li_0 = f0_34(Gi_668);
   int count_4 = 0;
   for (int pos_8 = OrdersTotal() - 1; pos_8 >= 0; pos_8--) {
      if (OrderSelect(pos_8, SELECT_BY_POS)) {
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != S4_Magic) continue;
         count_4++;
         switch (OrderType()) {
         case OP_BUY:
            if (S4_TrailingStop <= 0.0) break;
            if (Bid - OrderOpenPrice() < Point * G_pips_504 * S4_TrailingStop) break;
            if (!(OrderStopLoss() < Bid - Point * G_pips_504 * S4_TrailingStop || OrderStopLoss() == 0.0)) break;
            f0_18();
            OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_504 * S4_TrailingStop, Digits), OrderTakeProfit(), 0, Green);
            break;
         case OP_SELL:
            if (S4_TrailingStop <= 0.0) break;
            if (OrderOpenPrice() - Ask < Point * G_pips_504 * S4_TrailingStop) break;
            if (!(OrderStopLoss() > Ask + Point * G_pips_504 * S4_TrailingStop || OrderStopLoss() == 0.0)) break;
            f0_18();
            OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_504 * S4_TrailingStop, Digits), OrderTakeProfit(), 0, Red);
         }
      }
   }
   if (Li_0 && count_4 == 0) {
      HideTestIndicators(TRUE);
      imacd_16 = iMACD(NULL, PERIOD_M5, 6, 24, 12, PRICE_CLOSE, MODE_MAIN, 0);
      imacd_24 = iMACD(NULL, PERIOD_M5, 6, 24, 12, PRICE_CLOSE, MODE_SIGNAL, 0);
      iatr_32 = iATR(NULL, PERIOD_M5, 4, 1);
      S4_SetIndicators(Gi_668, iOpen(NULL, PERIOD_M5, 1), iLow(NULL, PERIOD_M5, 1), iHigh(NULL, PERIOD_M5, 1), iClose(NULL, PERIOD_M5, 1), iatr_32, imacd_16, imacd_24);
      Li_40 = 0;
      for (pos_8 = OrdersHistoryTotal() - 1; pos_8 >= 0; pos_8--) {
         if (OrderSelect(pos_8, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != S4_Magic) continue;
            if (Li_40 < OrderOpenTime()) Li_40 = OrderOpenTime();
         }
      }
      if (Li_40 > 0) Li_40 -= G_datetime_516 - Gi_520;
      if (S4_Risk > 0.0) Ld_44 = f0_30(S4_Risk, AccountFreeMargin());
      else Ld_44 = f0_6(S4_Lot);
      if (S4_OpenLong(Gi_668, Bid, Li_40)) {
         if (G_spread_536 <= MaxSpread * G_pips_504) {
            Ld_52 = 0;
            Ld_60 = 0;
            Ld_68 = 1;
            Ld_76 = 0;
            pips_84 = 0;
            stoplevel_92 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            Ld_100 = MathMin(iLow(NULL, PERIOD_H1, 0), iLow(NULL, PERIOD_H1, 1));
            Ld_100 = MathMin(Ld_100, iLow(NULL, PERIOD_H1, 2));
            Ld_100 = MathMin(Ld_100, iLow(NULL, PERIOD_H1, 3));
            Ld_76 = (Bid - Ld_100) / Point + 6.0 * G_pips_504;
            Ld_76 = MathMax(S4_MinStopLoss * G_pips_504, MathMin(S4_MaxStopLoss * G_pips_504, Ld_76));
            Ld_76 = MathMax(Ld_76, stoplevel_92);
            pips_84 = MathMax(S4_TakeProfit * G_pips_504, stoplevel_92);
            if (S4_AdaptiveLot) Ld_68 = S4_MinStopLoss * G_pips_504 / Ld_76;
            Ld_60 = NormalizeDouble(Bid - Ld_76 * Point, Digits);
            Ld_52 = NormalizeDouble(Ask + pips_84 * Point, Digits);
            Li_108 = f0_19(OP_BUY, Ld_44 * Ld_68, Ask, Ld_52, Ld_60, S4_Magic, "", Blue);
            if (Li_108 >= 0) Print("S4: Buy order placed [spread: ", G_spread_536, "]");
         } else {
            if (G_spread_756 < G_spread_536) Print("S4 Buy failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
            G_spread_756 = G_spread_536;
         }
      }
      if (S4_OpenShort(Gi_668, Bid, Li_40)) {
         if (G_spread_536 <= MaxSpread * G_pips_504) {
            Ld_52 = 0;
            Ld_60 = 0;
            Ld_76 = 0;
            pips_84 = 0;
            Ld_68 = 1;
            stoplevel_92 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            Ld_112 = MathMax(iHigh(NULL, PERIOD_H4, 0), iHigh(NULL, PERIOD_H4, 1));
            Ld_112 = MathMax(Ld_112, iHigh(NULL, PERIOD_H1, 2));
            Ld_112 = MathMax(Ld_112, iHigh(NULL, PERIOD_H1, 3));
            Ld_76 = (Ld_112 - Bid) / Point + 6.0 * G_pips_504;
            Ld_76 = MathMax(S4_MinStopLoss * G_pips_504, MathMin(S4_MaxStopLoss * G_pips_504, Ld_76));
            pips_84 = MathMax(S4_TakeProfit * G_pips_504, stoplevel_92);
            if (S4_AdaptiveLot) Ld_68 = S4_MinStopLoss * G_pips_504 / Ld_76;
            Ld_60 = NormalizeDouble(Ask + Ld_76 * Point, Digits);
            Ld_52 = NormalizeDouble(Bid - pips_84 * Point, Digits);
            Li_120 = f0_19(OP_SELL, Ld_44 * Ld_68, Bid, Ld_52, Ld_60, S4_Magic, "", Blue);
            if (Li_120 >= 0) Print("S4: Sell order placed [spread: ", G_spread_536, "]");
         } else {
            if (G_spread_760 < G_spread_536) Print("S4 Sell failed: Max spread limit exceeded [spread: ", G_spread_536, "]");
            G_spread_760 = G_spread_536;
         }
      }
   }
   return (0);
}
