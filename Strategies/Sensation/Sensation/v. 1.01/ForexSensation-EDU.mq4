
#property copyright "Copyright © 2013, Forex Sensation Championship"
#property link      "http://www.forexsensation.com/"

#include <WinUser32.mqh>
//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A
#import "ForexSensation.dll"
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

extern string v.1.01.4.96 = "";
// extern string Code = "";
extern double TesterGmtOffset = 0.0;
extern double Lots = 0.1;
extern double Risk = 0.2;
extern bool S1 = TRUE;
extern bool S2 = TRUE;
extern bool S3 = TRUE;
extern bool S3_Aggressive = FALSE;
extern double MaxSpread = 2.1;
bool Gi_140 = TRUE;
extern int S1_Magic = 761349;
int G_magic_148 = 650238;
extern int S2_Magic = 4563216;
extern int S3_Magic = D'19.04.2001 06:23:51';
string Gs_unused_160 = "Strategy 1";
double Gd_168 = 1.0;
double Gd_176 = 10.0;
double Gd_184 = 30.0;
double Gd_192 = 1.0;
double Gd_200 = 3.0;
double Gd_208 = 20.0;
double Gd_216 = 5.0;
double Gd_224 = 100.0;
double Gd_232 = 30.0;
bool Gi_240 = FALSE;
double Gd_244 = 5.0;
double Gd_252 = 1.5;
double Gd_260 = 4.0;
string Gs_unused_268 = "Strategy 2";
double Gd_276 = 20.0;
double Gd_284 = 40.0;
double Gd_292 = 70.0;
double Gd_300 = 20.0;
string Gs_unused_308 = "Strategy 3";
double Gd_316 = 40.0;
double Gd_324 = 20.0;
double Gd_332 = 7.0;
bool G_bool_340 = TRUE;
int Gi_344 = 20;
int Gi_348 = 20;
int G_color_352 = DeepSkyBlue;
int Gi_356 = 16748574;
int Gi_360 = 16737380;
double G_pips_364;
int G_global_var_372 = 0;
int G_datetime_376;
int Gi_380;
int Gi_384;
int Gi_unused_388;
int G_day_of_week_392;
string Gsa_396[] = {".", "..", "...", "....", "....."};
int Gi_unused_400 = 0;
int Gi_unused_404 = 0;
int Gi_408 = 0;
int Gi_412 = 0;
int Gi_416 = 0;
int Gi_420;
int Gi_424;
int Gi_428;
int Gi_432;
string Gs_436 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
int Gi_unused_444 = 0;
int Gi_unused_448 = 0;
double Gda_unused_452[];
bool Gi_456 = FALSE;
string Gsa_460[];
string Gsa_464[];
string Gsa_468[];
int Gia_472[];
int Gia_476[];
int Gia_480[];
int Gi_484;
int Gi_488;
int Gi_492;
string G_str_concat_496;
string Gs_504;
int Gi_512 = -1;
int Gi_516 = -1;
int Gi_520 = -1;
bool Gi_524 = FALSE;
int G_period_528 = 70;
int G_period_532 = 11;
int G_period_536 = 11;
int G_period_540 = 18;
int G_period_544 = 18;
int Gi_548 = 56;
double G_ima_552;
int G_timeframe_560 = PERIOD_M5;
int G_period_564 = 17;

// 3BE4B59601B7B2E82D21E1C5C718B88F
double f0_6(bool Ai_0, double Ad_4, double Ad_12) {
   if (Ai_0) return (Ad_4);
   return (Ad_12);
}
			 	 			    		 		 	 		 	  	   	 	 		 			    	 					  	 	 				     		   	  		  		 		    		 	 				  	 			  	 	 		 					  			 		 				 			 		 	 	 	 
// AEAA03D41A3A752C422C407A2EBDF031
string f0_18(int Ai_0) {
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
string f0_30(int Ai_0) {
   return (StringConcatenate("ForexSensation", " lb: ", Ai_0));
}
			   	     				 	 					   		   		 	  	     		   				 		  		 	 		  	   	   	      			  	 	 				    				 	 	   	 				 	 	 		  	   		  			 	 			  	
// 1D75F0D638248553D80CFFB8D1DC6682
void f0_2(int Ai_0, int &Ai_4, int &Ai_8) {
   string name_12 = f0_30(Ai_0);
   if (ObjectFind(name_12) == 0) {
      Ai_4 = ObjectGet(name_12, OBJPROP_XDISTANCE);
      Ai_8 = ObjectGet(name_12, OBJPROP_YDISTANCE);
   }
}
		 	 	 		 			   			 	   	 	 				 		  	 		 			 				  		  	     	   	  		 	 	  				   			 			 	  		 	 	  	   	 	 	 	    	 		 	  				 	    			 	 		 
// C3BAA9C535265F9452B54C5C75FB8004
void f0_22(string A_text_0, color A_color_8 = -1, int Ai_12 = -1, double Ad_16 = -1.0, int Ai_24 = 0) {
   if (A_color_8 == CLR_NONE) A_color_8 = G_color_352;
   if (Ai_12 == -1) Ai_12 = Gi_412;
   if (Ad_16 == -1.0) Ad_16 = Gi_408;
   string name_28 = f0_30(Ai_12);
   if (ObjectFind(name_28) != 0) {
      ObjectCreate(name_28, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_28, OBJPROP_CORNER, 0);
   }
   ObjectSetText(name_28, A_text_0, 9, "Courier New", A_color_8);
   ObjectSet(name_28, OBJPROP_XDISTANCE, Gi_424 + Ai_24);
   ObjectSet(name_28, OBJPROP_YDISTANCE, Gi_420 + 14.0 * Ad_16);
   Gi_408 = MathMax(Gi_408, Ad_16 + 1.0);
   Gi_412 = MathMax(Gi_412, Ai_12 + 1);
   Gi_416 = MathMax(Gi_416, Ai_12);
}
	  	  		 						   	 			  		 	  		 	   		 					 	    	 	  	   	  			      		    	 	  	     	 				 		 						 	  			    	     	 	 	   	 		   	 		 		
// BF5A9BC44BBE42C10E8B2D4446B20D89
void f0_20(int Ai_0 = -1, double Ad_4 = -1.0, int Ai_12 = 0) {
   if (Ai_0 == -1) Ai_0 = Gi_412;
   if (Ad_4 == -1.0) Ad_4 = Gi_408;
   f0_22("_______", G_color_352, Ai_0, Ad_4 - 0.3, Ai_12);
   Gi_408 = MathMax(Gi_408, Ad_4 + 1.0);
}
		    		  	 			  						   			  					  		  	 		 	 	 		 	    	 	  	 		      		   	   		    							  							     				 	 	   	   	 	 	   		  					 		
// 8A6D85A0B52E3C8A8E55A15F14BE6D0A
int f0_13(string As_0, string As_8, int Ai_16 = -1, double Ad_20 = -1.0, int Ai_28 = 0) {
   if (Ai_16 == -1) Ai_16 = Gi_412;
   if (Ad_20 == -1.0) Ad_20 = Gi_408;
   f0_22(As_0, G_color_352, Ai_16, Ad_20, Ai_28);
   f0_22(As_8, Gi_356, Ai_16 + 1, Ad_20, Ai_28 + 7 * (StringLen(As_0) + 1));
   return (0);
}
					 			  	 		 		   		 	      	 	  	 			  	 	 				   	 	 	 		      	   	   	  		 	     		   				    			  			 		 		 		  						 								 		   	 	 
// C2C5CA64BFA878771207E31C1E4B9E4F
void f0_21(int Ai_0, int Ai_4) {
   Gi_424 = Ai_0;
   Gi_420 = Ai_4;
   if (Gi_428 != Ai_0 || Gi_432 != Ai_4) {
      Gi_428 = Gi_348;
      Gi_432 = Gi_344;
   } else f0_2(0, Gi_424, Gi_420);
   Gi_412 = 0;
   Gi_408 = 0;
}
		 			  	 		   				    		 	  		  		 		  	 		  	 		   	 		   	 		  	 					 	 			 	    						     	 	        			   	  	 				 		 	 		 		  				   	  
// D61FF371629181373AAEA1B1C60EF302
void f0_26(int Ai_0, int Ai_4 = 0) {
   if (Ai_4 == 0) {
      Ai_4 = Gi_416;
      Gi_416 = Ai_0 - 1;
   }
   for (int Li_8 = Ai_0; Li_8 <= Ai_4; Li_8++) ObjectDelete(f0_30(Li_8));
}
				   		  			  		  		  	   	 		 	     		  								 	   	 	  		       	 	     			 	 	 	 		  		 		   		 	  		   	 		  		 				 							 	  		  				 
// CC9E8226BD8EC7D27CF11D972D60721C
int f0_23(string Asa_0[], int Aia_4[], int Ai_8 = -1, double Ad_12 = -1.0, int Ai_20 = 0) {
   int Li_36;
   if (Ai_8 == -1) Ai_8 = Gi_412;
   if (Ad_12 == -1.0) Ad_12 = Gi_408;
   int arr_size_24 = ArraySize(Asa_0);
   if (arr_size_24 != ArraySize(Aia_4)) return (Ai_8);
   int Li_28 = 0;
   for (int index_32 = 0; index_32 < arr_size_24; index_32++) {
      Li_36 = Gi_356;
      if (Aia_4[index_32] & 8 > 0) Li_36 = Gi_360;
      f0_22(Asa_0[index_32], Li_36, Ai_8, Ad_12, Ai_20 + 7 * Li_28);
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
void f0_19(string &Asa_0[], int Aia_4[], int Ai_8) {
   ArrayResize(Asa_0, Ai_8);
   ArrayResize(Aia_4, Ai_8);
   for (int index_12 = 0; index_12 < Ai_8; index_12++) Asa_0[index_12] = StringTrimLeft("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
}
			 	 			    		 		 	 		 	  	   	 	 		 			    	 					  	 	 				     		   	  		  		 		    		 	 				  	 			  	 	 		 					  			 		 				 			 		 	 	 	 
// 57862CA56FB6CA780A1AA075901C0C7C
double f0_10(string As_0) {
   int Li_24;
   As_0 = f0_25(As_0);
   int str_len_8 = StringLen(As_0);
   double Ld_ret_12 = 0;
   for (int Li_20 = 0; Li_20 < str_len_8; Li_20++) {
      Li_24 = StringFind(Gs_436, StringSubstr(As_0, str_len_8 - Li_20 - 1, 1));
      Ld_ret_12 += Li_24 * MathPow(36, Li_20);
   }
   return (Ld_ret_12);
}
	  		    			 	 	  	  	 	 		   	 	 	 	    			 		        	 	  							 	 		 		 	 	  	    		  	  	   		  	  		 		   	   				   				    			 	  	  		 	
// DF423827A5F770FA7875E68553FDD0BB
string f0_29(double Ad_0) {
   string str_concat_8 = "";
   for (Ad_0 = MathAbs(Ad_0); Ad_0 >= 1.0; Ad_0 = MathFloor(Ad_0 / 36.0)) str_concat_8 = StringConcatenate(StringSubstr(Gs_436, MathMod(Ad_0, 36), 1), str_concat_8);
   return (str_concat_8);
}
			   	 	   						 						  		    	 	  	 	   		  					 			 		 	 	   	   		  	    	 			  			 				 	  				   	   	  			 	 				  	  			  					 			   
// D27AF7D1516C24C3278EA8BCC56C9759
string f0_25(string As_0) {
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
int f0_16() {
   for (int count_0 = 0; IsTradeContextBusy() && count_0 < 10; count_0++) Sleep(15);
   if (count_0 >= 10) Print("Trade context is buisy more than ", DoubleToStr(15 * count_0 / 1000, 2), " seconds");
   else
      if (count_0 > 0) Print("Trade context was buisy ", DoubleToStr(15 * count_0 / 1000, 2), " seconds");
   return (count_0);
}
	 	  					  	 	 	  		 	 		 			 	   	 					  	  		 					 				     	 	 	  		 	 	 							  	  		 				 		 		 		  			  		    	 	    		 	   	 	  		  	 
// A908BF30D5A0CAE9E3CAA8BBF9AF6384
int f0_17(int A_cmd_0, double A_lots_4, double A_price_12, double A_price_20, double A_price_28, int A_magic_36, string A_comment_40, color A_color_48, bool Ai_52 = FALSE) {
   double price_56;
   double price_64;
   int error_76;
   double price_84;
   int ticket_72 = -1;
   int count_80 = 0;
   bool Li_92 = FALSE;
   double Ld_96 = 2.0 * G_pips_364 * Point;
   double slippage_104 = 3.0 * G_pips_364;
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
      f0_16();
      ticket_72 = OrderSend(Symbol(), A_cmd_0, A_lots_4, A_price_12, slippage_104, price_64, price_56, A_comment_40, A_magic_36, 0, A_color_48);
      if (ticket_72 >= 0) break;
      count_80++;
      error_76 = GetLastError();
      switch (error_76) {
      case 130/* INVALID_STOPS */:
         if (!Ai_52) G_global_var_372 = 1;
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
            f0_16();
            OrderModify(ticket_72, OrderOpenPrice(), A_price_28, A_price_20, 0, A_color_48);
         }
      }
      if (count_80 > 5) Print(f0_18(A_cmd_0) + " operation attempts: ", count_80);
   } else Print(f0_18(A_cmd_0) + " operation failed - error(", error_76, "): ", ErrorDescription(error_76), " attempts: ", count_80);
   return (ticket_72);
}
	 	 						    	 	  	  	 		 	 	 	   							     		 		 		 					    	 			  		 			 					 	  	  	  				 	  		 		 				  			   	 	 	  		 	 	 	 	  	   	 
// 0D8DF1C15E383B163F5CB1A2BE7799FC
int f0_1(int A_ticket_0, int Ai_4, double Ad_8 = 1.0) {
   if (OrderSelect(A_ticket_0, SELECT_BY_TICKET)) return (f0_24(Ai_4, Ad_8));
   return (-2);
}
				 	 	   		    	  	       						   	 	   		 		 		 		    	   	 	    		      			  	 			  	  	  	    	  		 		 	 				   	  			  		 			     	  	 			
// D0B773F3CEA185836A86C349E30F8167
int f0_24(color A_color_0, double Ad_4 = 1.0) {
   double order_lots_12;
   double price_44;
   int error_52;
   string symbol_20 = OrderSymbol();
   if (Ad_4 == 1.0) order_lots_12 = OrderLots();
   else order_lots_12 = f0_5(OrderLots() * Ad_4);
   bool Li_28 = FALSE;
   double slippage_32 = 3.0 * f0_11(symbol_20);
   for (int count_40 = 0; count_40 < 10; count_40++) {
      if (f0_16() > 5) RefreshRates();
      if (OrderType() == OP_BUY) price_44 = MarketInfo(symbol_20, MODE_BID);
      else price_44 = MarketInfo(symbol_20, MODE_ASK);
      if (OrderClose(OrderTicket(), order_lots_12, price_44, slippage_32, A_color_0)) {
         Li_28 = TRUE;
         if (Ad_4 >= 1.0) return (-1);
         f0_9(OrderMagicNumber(), OrderType());
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
double f0_28(double Ad_0, double Ad_8) {
   int Li_16;
   return (f0_31(Ad_0, Ad_8, Li_16));
}
			    		   		  		 			  	  		 		 	 	   		   									   	 		 		    	  	 	  	  			 			 	 		 			 		  			 	  	    	 			 		 			  						  	  		 					 
// EB20E9232C8D576D1AF86E66E193C68A
double f0_31(double Ad_0, double Ad_8, int &Ai_16) {
   if (AccountLeverage() < 100) return (f0_14(Ad_0 * Ad_8 / MarketInfo(Symbol(), MODE_MARGINREQUIRED), Ai_16));
   return (f0_14(Ad_0 * Ad_8 / MarketInfo(Symbol(), MODE_MARGINREQUIRED) / (AccountLeverage() / 100.0), Ai_16));
}
				   	   			   	  		      	 				     	   					 		 	     	  		 	     	       		  	 	 	  	  		 	    		 		 		   				  		  			 			 			 	   	  					
// 38350FE142782EF0E6BB82AC5D70CEFB
double f0_5(double Ad_0) {
   int Li_8;
   return (f0_14(Ad_0, Li_8));
}
	 		  				 				 	   			 		  	  	      				 			 		 	 	 	 			  	   	      		     				 	   	   						  				 			  		  	  	  	 		 	 		 		 		 	   		 	 
// 8BB10F52F0AC31289E87BEDAE9317915
double f0_14(double Ad_0, int &Ai_8) {
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
double f0_11(string A_symbol_0) {
   double Ld_ret_8 = 0.0001 / MarketInfo(A_symbol_0, MODE_POINT);
   if (MarketInfo(A_symbol_0, MODE_DIGITS) < 4.0) Ld_ret_8 = 100.0 * Ld_ret_8;
   return (Ld_ret_8);
}
	        		 		 	  				 	 				 	 	 		     		 			    		  	 	 	 							  		 			  	  	 		 		  				   					  		      	  	 			     		      	 	  					 	
// 556B050CE914D18480D6EA30308C7790
int f0_9(int A_magic_0, int A_cmd_4) {
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
   f0_21(Gi_348, Gi_344);
   G_str_concat_496 = StringConcatenate("ForexSensation", " v.", "1.01");
   f0_22(G_str_concat_496, Gi_356);
   f0_20();
/*	
   Gi_456 = CheckVersion("1.01");
   if (!Gi_456) {
      f0_13("Error:", "Dll and Expert versions mismatch");
      return (0);
   }
   Code = StringTrimLeft(StringTrimRight(Code));
   if (StringLen(Code) <= 0) {
      if (GlobalVariableCheck("FS_CODE")) {
         global_var_0 = GlobalVariableGet("FS_CODE");
         Code = f0_29(global_var_0);
      }
   } else {
      Ld_8 = f0_10(Code);
      GlobalVariableSet("FS_CODE", Ld_8);
   }
*/	
   G_bool_340 = G_bool_340 && (!IsTesting()) || IsVisualMode();
   Gs_504 = AccountName();
//   Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   f0_22("Authentication...");
   WindowRedraw();
//   int str_concat_16 = StatusWait();
   Gi_412--;
   Gi_408--;
/*	
   if (str_concat_16 & 1 == 0) {
      Li_20 = f0_3(1, 0, Gi_484, Gsa_460, Gia_472);
      Li_24 = ErrorCode();
      if (Li_24 == 0) str_concat_28 = str_concat_16;
      else str_concat_28 = StringConcatenate(str_concat_16, " (", Li_24, ")");
      if (Li_20 == 0) f0_13("Authentication Failed! Error: ", str_concat_28);
      Print("Authentication Failed! Error: ", str_concat_28);
   } else {
      Li_20 = f0_3(1, 0, Gi_484, Gsa_460, Gia_472);
      if (Li_20 == 0) f0_22("Authenticated");
   }
*/  
   if (S1) {
      Li_36 = 0;
      if (!Gi_140) Li_36 |= 16;
      Gi_512 = StartExpert(1, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_512 >= 0) SetMaxSpread(Gi_512, MaxSpread);
      else f0_13("Strategy1:", "This currency is not supported!");
   } else Gi_512 = -1;
   if (S2) {
      Li_36 = 0;
      if (!Gi_140) Li_36 |= 16;
      Gi_516 = StartExpert(2, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_516 >= 0) SetMaxSpread(Gi_516, MaxSpread);
      else f0_13("Strategy2:", "This currency is not supported!");
   } else Gi_516 = -1;
   if (S3) {
      Li_36 = 0;
      if (!Gi_140) Li_36 |= 16;
      if (S3_Aggressive) Li_36 |= 1048576;
      Gi_520 = StartExpert(3, IsTesting(), Symbol(), TesterGmtOffset, Li_36);
      if (Gi_520 >= 0) SetMaxSpread(Gi_520, MaxSpread);
      else f0_13("Strategy3:", "This currency is not supported!");
   } else Gi_520 = -1;
   WindowRedraw();
   if (Gi_512 < 0 && Gi_516 < 0 && Gi_520 < 0) MessageBox("You have selected the wrong currency pair!", G_str_concat_496 + ": Warning", MB_ICONEXCLAMATION);
   G_pips_364 = f0_11(Symbol());
   G_global_var_372 = 0;
   if (!IsTesting())
      if (GlobalVariableCheck("FS_MARKET")) G_global_var_372 = GlobalVariableGet("FS_MARKET");
   return (0);
}
		 	    	 				 				 		 		 	 	 	  		     	 					 		  	  		    			  	   			 	   	 	   	 					 		  	 	 		     	     	   					 	 		 		 	 	 				 			  
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   int spread_0;
   StopExpert(Gi_512);
   StopExpert(Gi_516);
   StopExpert(Gi_520);
   if (IsTesting()) {
      if (!(!IsVisualMode())) return (0);
      f0_20();
      f0_13("TesterGmtOffset:", DoubleToStr(TesterGmtOffset, 1));
      f0_20();
      spread_0 = MarketInfo(Symbol(), MODE_SPREAD);
      f0_13("Spread:", StringConcatenate(DoubleToStr(spread_0 / G_pips_364, 1), " (", spread_0, " pips)"));
      f0_20();
      return (0);
   }
   GlobalVariableSet("FS_MARKET", G_global_var_372);
   switch (UninitializeReason()) {
   case REASON_CHARTCLOSE:
   case REASON_REMOVE:
      f0_26(0, Gi_416);
      Gi_416 = 0;
      break;
   case REASON_RECOMPILE:
   case REASON_CHARTCHANGE:
   case REASON_PARAMETERS:
   case REASON_ACCOUNT:
      f0_26(1, Gi_416);
      Gi_416 = 1;
   }
   return (0);
}
					 		   	 		  	   		        			  	 		   	 	 	 		   	   	 		  	   	       	  	  	      	   			     				 			 					 		   					 	 						  	   	 		
// 03B62516184FB6EF591F45BD4974B753
void f0_0() {
   RefreshRates();
   G_datetime_376 = TimeCurrent();
   if (IsTesting()) Gi_380 = G_datetime_376 - 3600.0 * TesterGmtOffset;
   else Gi_380 = Utc();
   Gi_384 = G_datetime_376 - 3600.0 * TimeHour(Gi_380) - 60 * TimeMinute(Gi_380) - TimeSeconds(Gi_380);
   Gi_unused_388 = Gi_380 - 3600.0 * TimeHour(Gi_380) - 60 * TimeMinute(Gi_380) - TimeSeconds(Gi_380);
   G_day_of_week_392 = TimeDayOfWeek(Gi_380);
}
					 			  	 		 		   		 	      	 	  	 			  	 	 				   	 	 	 		      	   	   	  		 	     		   				    			  			 		 		 		  						 								 		   	 	 
// 25D8FA49F2C78939384F1B1F7C3C8CC3
int f0_3(int Ai_0, int Ai_4, int &Ai_8, string Asa_12[], int Aia_16[], string As_20 = "") {
   int Lia_28[1];
   int str_len_36;
   int Li_ret_32 = Msg(Ai_0, Ai_4, Lia_28);
   if (Lia_28[0] != Ai_8 || Li_ret_32 != ArraySize(Asa_12)) {
      Ai_8 = Lia_28[0];
      f0_19(Asa_12, Aia_16, Li_ret_32);
      GetMsg(Ai_0, Ai_4, Asa_12, Aia_16, Li_ret_32);
   }
   if (Li_ret_32 > 0) {
      str_len_36 = StringLen(As_20);
      if (str_len_36 > 0) {
         f0_22(As_20);
         f0_23(Asa_12, Aia_16, Gi_412, Gi_408 - 1, 7 * (str_len_36 + 1));
      } else f0_23(Asa_12, Aia_16);
   }
   return (Li_ret_32);
}
		  				  	   	  			  	   		 	 									  	    	 	 	 		    		   	 				    				 	   	 	   			  		  		  			   						 		    	  	  	 	  	 	  			   		
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   int Li_4;
   int Li_8;
   string str_concat_12;
   int Li_20;
   int Li_24;
   int spread_28;
   double Ld_32;
   int Li_40;
   double Ld_48;
   bool Li_56;
   if (!Gi_456) return (0);
   if (Gi_512 < 0 && Gi_516 < 0 && Gi_520 < 0) return (0);
   if (Gs_504 != AccountName()) {
      Gs_504 = AccountName();
//      Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   }
   int str_concat_0 = Status();
   f0_0();
   if (G_bool_340) {
      f0_2(0, Gi_424, Gi_420);
      Gi_412 = 0;
      Gi_408 = 0;
      f0_22(G_str_concat_496, Gi_356);
      f0_20();
/*		
      if (str_concat_0 & 1 == 0) {
         Li_4 = f0_3(1, 0, Gi_484, Gsa_460, Gia_472);
         Li_8 = ErrorCode();
         if (Li_8 == 0) str_concat_12 = str_concat_0;
         else str_concat_12 = StringConcatenate(str_concat_0, " (", Li_8, ")");
         if (Li_4 == 0) f0_13("Authentication Failed! Error: ", str_concat_12);
      } else 
*/
		{
         Li_4 = f0_3(1, 0, Gi_484, Gsa_460, Gia_472);
         if (Li_4 == 0) f0_22("Authenticated");
         f0_20();
         Li_20 = f0_3(2, 0, Gi_488, Gsa_464, Gia_476);
         if (Li_20 > 0) f0_20();
         if (Gi_140) {
            Li_24 = f0_3(3, Gi_512, Gi_492, Gsa_468, Gia_480, "Market Alert:");
            if (Li_24 > 0) f0_20();
         }
         f0_13("ServerTime:", TimeToStr(G_datetime_376));
         f0_13("UtcTime:", TimeToStr(Gi_380));
         f0_20();
         spread_28 = MarketInfo(Symbol(), MODE_SPREAD);
         f0_13("Spread:", StringConcatenate(DoubleToStr(spread_28 / G_pips_364, 1), " (", spread_28, " pips)"));
         f0_13("Leverage:", StringConcatenate(AccountLeverage(), ":1"));
         f0_20();
         if (Risk > 0.0) Ld_32 = f0_31(Risk, AccountFreeMargin(), Li_40);
         else Ld_32 = f0_14(Lots, Li_40);
         f0_13("Lot:", DoubleToStr(Ld_32, 2));
         switch (Li_40) {
         case 1:
            f0_22("Maximum Lot size exeeded!");
            break;
         case -1:
            f0_22("Minimum Lot size exeeded!");
         }
         Ld_48 = NormalizeDouble(MarketInfo(Symbol(), MODE_MARGINREQUIRED) * Ld_32, 8);
         Li_56 = NormalizeDouble(AccountFreeMargin(), 8) < Ld_48;
         if (Gi_524 != Li_56) {
            if (Li_56) Print("Not enough money! Available margin = ", DoubleToStr(AccountFreeMargin(), 2), ", Required margin = ", DoubleToStr(Ld_48, 2));
            Gi_524 = Li_56;
         }
         if (Li_56) {
            f0_20();
            f0_22("Not enough money!");
            f0_13("Available margin =", DoubleToStr(AccountFreeMargin(), 2));
            f0_13("Required margin =", DoubleToStr(Ld_48, 2));
         }
      }
      f0_26(Gi_412);
      WindowRedraw();
   }
   if (Gi_512 >= 0) f0_8();
   if (Gi_512 >= 0 && Gi_516 >= 0) f0_0();
   if (Gi_516 >= 0) f0_15();
   if (Gi_512 >= 0 || Gi_516 >= 0 && Gi_520 >= 0) f0_0();
   if (Gi_520 >= 0) f0_32();
   return (0);
}
	 	 				 	    	    	  	  	 	 	 		  					 	     	  		 		  				   		 			   	 			 	 			 	     	  		 	 	  					 					 			     	 	  	  	 	 	    	   		
// 4280E6883D02734AF90C834569725E81
int f0_8() {
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
   int Li_0 = SetMarket(Gi_512, G_datetime_376, Point, G_pips_364, MarketInfo(Symbol(), MODE_SPREAD), MarketInfo(Symbol(), MODE_TICKVALUE));
   SetBalance(Gi_512, AccountBalance(), AccountCurrency());
   f0_12();
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
            if (OrderMagicNumber() == G_magic_148) {
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
            pips_96 = MathMax(Gd_176 * G_pips_364, stoplevel_88);
            order_takeprofit_52 = NormalizeDouble(Ask + pips_96 * Point, Digits);
         }
         if (order_stoploss_44 == 0.0) {
            pips_104 = MathMax(Gd_184 * G_pips_364, stoplevel_88);
            order_stoploss_44 = NormalizeDouble(Bid - pips_104 * Point, Digits);
         }
         f0_16();
         OrderModify(ticket_4, order_open_price_20, order_stoploss_44, order_takeprofit_52, 0, Green);
      }
      if (Gi_240) {
         if (f0_4(ticket_4, ticket_12)) {
            ticket_4 = f0_1(ticket_4, 32768);
            ticket_12 = f0_1(ticket_12, 32768);
         }
      } else
         if (S1_CloseLong(Gi_512, Bid, order_open_price_20, datetime_36)) ticket_4 = f0_1(ticket_4, 255);
   } else
      if (ticket_12 >= 0) ticket_12 = f0_1(ticket_12, 32768);
   if (ticket_8 >= 0) {
      if (order_stoploss_60 == 0.0 || order_takeprofit_68 == 0.0) {
         stoplevel_88 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         if (order_takeprofit_68 == 0.0) {
            pips_96 = MathMax(Gd_176 * G_pips_364, stoplevel_88);
            order_takeprofit_68 = NormalizeDouble(Bid - pips_96 * Point, Digits);
         }
         if (order_stoploss_60 == 0.0) {
            pips_104 = MathMax(Gd_184 * G_pips_364, stoplevel_88);
            order_stoploss_60 = NormalizeDouble(Ask + pips_104 * Point, Digits);
         }
         f0_16();
         OrderModify(ticket_8, order_open_price_28, order_stoploss_60, order_takeprofit_68, 0, Green);
      }
      if (Gi_240) {
         if (f0_4(ticket_8, ticket_16)) {
            ticket_8 = f0_1(ticket_8, 32768);
            ticket_16 = f0_1(ticket_16, 32768);
         }
      } else
         if (S1_CloseShort(Gi_512, Ask, order_open_price_28, datetime_40)) ticket_8 = f0_1(ticket_8, 255);
   } else
      if (ticket_16 >= 0) ticket_16 = f0_1(ticket_16, 32768);
   if (Li_0 && ticket_4 < 0 || ticket_8 < 0) {
      if (Risk > 0.0) Ld_112 = f0_28(Risk, AccountFreeMargin());
      else Ld_112 = f0_5(Lots);
      Li_120 = f0_27();
      Li_124 = f0_7();
      Ld_128 = Gd_176 * G_pips_364;
      Ld_136 = Gd_184 * G_pips_364;
      if (Li_120 || Li_124 && Gd_192 > 0.0) {
         iatr_144 = iATR(NULL, PERIOD_M15, 14, 0);
         Ld_128 = Gd_192 * iatr_144 / Point;
         Ld_136 = Gd_200 * iatr_144 / Point;
         Ld_128 = MathMax(Gd_216 * G_pips_364, MathMin(Gd_232 * G_pips_364, Ld_128));
         Ld_136 = MathMax(Gd_208 * G_pips_364, MathMin(Gd_224 * G_pips_364, Ld_136));
      }
      if (Li_120 || Li_124 && Gd_168 > 0.0) {
         for (pos_76 = OrdersHistoryTotal() - 1; pos_76 >= 0; pos_76--) {
            if (OrderSelect(pos_76, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol()) {
                  if (OrderMagicNumber() == S1_Magic) {
                     if ((G_datetime_376 - OrderCloseTime()) / 3600.0 <= Gd_168) {
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
         ticket_4 = f0_17(OP_BUY, Ld_112, Ask, Ld_152, Ld_160, S1_Magic, "", Blue);
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
         ticket_8 = f0_17(OP_SELL, Ld_112, Bid, Ld_152, Ld_160, S1_Magic, "", Blue);
      }
   }
   return (0);
}
			 		  	      			 	   		  	 		  	 			  	     	 				 	 		 			 		   						  				 	 		 					 	    	  	      	 		   				 					 	 	 			 	  			 	  	  
// 635171E21C4AAA4E3B8671F1CEA4CD16
void f0_12() {
   HideTestIndicators(TRUE);
   double iopen_0 = iOpen(NULL, PERIOD_M15, 1);
   double iclose_8 = iClose(NULL, PERIOD_M15, 1);
   G_ima_552 = iMA(NULL, PERIOD_M15, G_period_528, 0, MODE_SMMA, PRICE_MEDIAN, 1);
   double istochastic_16 = iStochastic(NULL, PERIOD_M15, G_period_532, 1, 1, MODE_SMA, 0, MODE_MAIN, 1);
   double iwpr_24 = iWPR(NULL, PERIOD_M1, G_period_536, 0);
   double icci_32 = iCCI(NULL, PERIOD_M1, G_period_540, PRICE_CLOSE, 0);
   double icci_40 = iCCI(NULL, PERIOD_M5, G_period_544, PRICE_CLOSE, 0);
   double ima_48 = iMA(NULL, PERIOD_M15, G_period_528 / 2.0, 0, MODE_SMMA, PRICE_MEDIAN, 1);
   S1_SetIndicators(Gi_512, iopen_0, iclose_8, G_ima_552, istochastic_16, iwpr_24, icci_32, icci_40, ima_48);
}
	  	 	  					  		 	 	  				 			   	  	  					 	 	   		 			    		 		  						  		 		  					 	 	   			 	    	 	 	        			  	  	 	  	   		 	 	 	  
// D925AC83A3A30655165085569C2CB44E
int f0_27() {
   bool Li_0;
   double ihigh_4;
   double ima_12;
   int datetime_24;
   double ihigh_28;
   double ima_36;
   if (S1_OpenLong1(Gi_512, Bid)) return (1);
   if (S1_OpenLong2(Gi_512, Bid)) {
      Li_0 = TRUE;
      ihigh_4 = iHigh(NULL, PERIOD_M15, 1);
      ima_12 = G_ima_552;
      for (int Li_20 = 2; Li_20 < Gi_548; Li_20++) {
         datetime_24 = iTime(NULL, PERIOD_M15, Li_20);
         ihigh_28 = iHigh(NULL, PERIOD_M15, Li_20);
         ima_36 = iMA(NULL, PERIOD_M15, G_period_528, 0, MODE_SMMA, PRICE_MEDIAN, Li_20);
         if (TimeDayOfWeek(datetime_24) != G_day_of_week_392) break;
         if (ihigh_28 < ima_36) break;
         if (ihigh_28 > ihigh_4) {
            ihigh_4 = ihigh_28;
            ima_12 = ima_36;
            Li_0 = Li_20;
         }
      }
      return (S1_OpenLong22(Gi_512, Li_0, ihigh_4, ima_12));
   }
   return (0);
}
				  			  				 		  			 	   	  	 	    			  			 				 	 	 	 	  	          	      		 	 	   		  					   				  		  		 		  	  				 	 					 		 		  		 	 
// 3DAB84832E3339AFE000C7FCBE935FFE
int f0_7() {
   bool Li_0;
   double ilow_4;
   double ima_12;
   int datetime_24;
   double ilow_28;
   double ima_36;
   if (S1_OpenShort1(Gi_512, Bid)) return (1);
   if (S1_OpenShort2(Gi_512, Bid)) {
      Li_0 = TRUE;
      ilow_4 = iLow(NULL, PERIOD_M15, 1);
      ima_12 = G_ima_552;
      for (int Li_20 = 2; Li_20 < Gi_548; Li_20++) {
         datetime_24 = iTime(NULL, PERIOD_M15, Li_20);
         ilow_28 = iLow(NULL, PERIOD_M15, Li_20);
         ima_36 = iMA(NULL, PERIOD_M15, G_period_528, 0, MODE_SMMA, PRICE_MEDIAN, Li_20);
         if (TimeDayOfWeek(datetime_24) != G_day_of_week_392) break;
         if (ilow_28 > ima_36) break;
         if (ilow_28 < ilow_4) {
            ilow_4 = ilow_28;
            ima_12 = ima_36;
            Li_0 = Li_20;
         }
      }
      return (S1_OpenShort22(Gi_512, Li_0, ilow_4, ima_12));
   }
   return (0);
}
		  		  	 	    					   		 		 		  					  	 	   	 		 	 	 		  		 		  							 					 	  	 							    	 		        		   	 		 				  	 	 		  	  					  	  
// 3685F5650D16B72FFB48183DC7AFC721
int f0_4(int A_ticket_0, int &A_ticket_4) {
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
      if (Ld_16 < (-Gd_244) * G_pips_364 && G_datetime_376 - datetime_52 <= 3600.0 * Gd_260) {
         Ld_60 = f0_5(order_lots_44 * Gd_252);
         Print("Opening DA order with lot: ", DoubleToStr(Ld_60, 2), " [target_profit: ", DoubleToStr(Ld_16, 1), "]");
         A_ticket_4 = f0_17(cmd_24, Ld_60, f0_6(cmd_24 == OP_BUY, Bid, Ask), order_takeprofit_28, order_stoploss_36, G_magic_148, A_ticket_0, Green);
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
            f0_16();
            OrderModify(OrderTicket(), OrderOpenPrice(), order_stoploss_36, order_takeprofit_28, 0, Green);
         }
      } else return (0);
      if (S1_CloseDa(Gi_512, datetime_52, order_profit_8, order_profit_68, order_lots_44)) {
         Print("Closing DA bucket with profit: ", DoubleToStr(order_profit_8 + order_profit_68, 2));
         return (1);
      }
   }
   return (0);
}
	 			 				 	 		 	    		 		     	    	 				 	 	 		 	   	 			 		   	  	   		  	  				     	    					   			 				 		  	 		  	 				 		 					 	    	 	 
// 9C188057B3CC2464220D62DC135F3C65
int f0_15() {
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
   int Li_0 = SetMarket(Gi_516, G_datetime_376, Point, G_pips_364, MarketInfo(Symbol(), MODE_SPREAD), MarketInfo(Symbol(), MODE_TICKVALUE));
   SetBalance(Gi_516, AccountBalance(), AccountCurrency());
   HideTestIndicators(TRUE);
   double ima_4 = iMA(NULL, PERIOD_M5, G_period_564, 0, MODE_SMA, PRICE_CLOSE, 0);
   double ima_12 = iMA(NULL, PERIOD_M5, G_period_564, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ima_20 = iMA(NULL, PERIOD_M5, 40, 0, MODE_SMA, PRICE_CLOSE, 0);
   double imacd_28 = iMACD(NULL, PERIOD_M5, 12, 120, 24, PRICE_CLOSE, MODE_MAIN, 0);
   double imacd_36 = iMACD(NULL, PERIOD_M5, 12, 120, 24, PRICE_CLOSE, MODE_SIGNAL, 0);
   double iopen_44 = iOpen(NULL, PERIOD_M5, 0);
   double iclose_52 = iClose(NULL, PERIOD_M5, 0);
   double iopen_60 = iOpen(NULL, PERIOD_M1, 1);
   double iclose_68 = iClose(NULL, PERIOD_M1, 1);
   S2_SetIndicators(Gi_516, ima_4, ima_12, ima_20, imacd_28, imacd_36, iopen_44, iclose_52, iopen_60, iclose_68, iTime(NULL, G_timeframe_560, 0));
   int count_76 = 0;
   int count_80 = 0;
   for (int pos_84 = OrdersTotal() - 1; pos_84 >= 0; pos_84--) {
      if (OrderSelect(pos_84, SELECT_BY_POS)) {
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != S2_Magic) continue;
         switch (OrderType()) {
         case OP_BUY:
            if (S2_CloseLong(Gi_516, OrderProfit())) f0_24(Red);
            else {
               if (Gd_300 > 0.0) {
                  if (Bid - OrderOpenPrice() >= Point * G_pips_364 * Gd_300) {
                     if (OrderStopLoss() < Bid - Point * G_pips_364 * Gd_300 || OrderStopLoss() == 0.0) {
                        f0_16();
                        OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_364 * Gd_300, Digits), OrderTakeProfit(), 0, Green);
                     }
                  }
               }
               count_76++;
            }
            break;
         case OP_SELL:
            if (S2_CloseShort(Gi_516, OrderProfit())) f0_24(Red);
            else {
               if (Gd_300 > 0.0) {
                  if (OrderOpenPrice() - Ask >= Point * G_pips_364 * Gd_300) {
                     if (OrderStopLoss() > Ask + Point * G_pips_364 * Gd_300 || OrderStopLoss() == 0.0) {
                        f0_16();
                        OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_364 * Gd_300, Digits), OrderTakeProfit(), 0, Red);
                     }
                  }
               }
               count_80++;
            }
         }
      }
   }
   if (Li_0 && count_76 == 0 && count_80 == 0) {
      if (Risk > 0.0) Ld_92 = f0_28(Risk, AccountFreeMargin());
      else Ld_92 = f0_5(Lots);
      if (S2_OpenLong(Gi_516, iTime(NULL, G_timeframe_560, 0))) {
         Ld_100 = 0;
         Ld_108 = 0;
         Ld_116 = 0;
         pips_124 = 0;
         stoplevel_132 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         Ld_140 = MathMin(iLow(NULL, PERIOD_H4, 0), iLow(NULL, PERIOD_H4, 1));
         Ld_116 = (Bid - Ld_140) / Point + 5.0 * G_pips_364;
         Ld_116 = MathMax(Gd_276 * G_pips_364, MathMin(Gd_284 * G_pips_364, Ld_116));
         Ld_116 = MathMax(Ld_116, stoplevel_132);
         pips_124 = MathMax(Gd_292 * G_pips_364, stoplevel_132);
         Ld_108 = NormalizeDouble(Bid - Ld_116 * Point, Digits);
         Ld_100 = NormalizeDouble(Ask + pips_124 * Point, Digits);
         Li_148 = f0_17(OP_BUY, Ld_92, Ask, Ld_100, Ld_108, S2_Magic, "", Blue);
      }
      if (S2_OpenShort(Gi_516, iTime(NULL, G_timeframe_560, 0))) {
         Ld_100 = 0;
         Ld_108 = 0;
         Ld_116 = 0;
         pips_124 = 0;
         stoplevel_132 = MarketInfo(Symbol(), MODE_STOPLEVEL);
         Ld_152 = MathMax(iHigh(NULL, PERIOD_H4, 0), iHigh(NULL, PERIOD_H4, 1));
         Ld_116 = (Ld_152 - Bid) / Point + 5.0 * G_pips_364;
         Ld_116 = MathMax(Gd_276 * G_pips_364, MathMin(Gd_284 * G_pips_364, Ld_116));
         pips_124 = MathMax(Gd_292 * G_pips_364, stoplevel_132);
         Ld_108 = NormalizeDouble(Ask + Ld_116 * Point, Digits);
         Ld_100 = NormalizeDouble(Bid - pips_124 * Point, Digits);
         Li_160 = f0_17(OP_SELL, Ld_92, Bid, Ld_100, Ld_108, S2_Magic, "", Blue);
      }
   }
   return (0);
}
			 					     	 		 	  	 	  	 	 	 	 						      					 		 	 			      			  	  			 		 		 	  		 	  			  	  		  	 				 				   			 	  				 	 	 		 	   	 
// FE3015C6EDFDE894DB7D09030346A754
int f0_32() {
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
   int Li_0 = SetMarket(Gi_520, G_datetime_376, Point, G_pips_364, MarketInfo(Symbol(), MODE_SPREAD), MarketInfo(Symbol(), MODE_TICKVALUE));
   SetBalance(Gi_520, AccountBalance(), AccountCurrency());
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
                  if (Gd_332 <= 0.0) break;
                  if (Bid - OrderOpenPrice() < Point * G_pips_364 * Gd_332) break;
                  if (!(OrderStopLoss() < Bid - Point * G_pips_364 * Gd_332 || OrderStopLoss() == 0.0)) break;
                  f0_16();
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Bid - Point * G_pips_364 * Gd_332, Digits), OrderTakeProfit(), 0, Green);
                  break;
               case OP_SELL:
                  if (Gd_332 <= 0.0) break;
                  if (OrderOpenPrice() - Ask < Point * G_pips_364 * Gd_332) break;
                  if (!(OrderStopLoss() > Ask + Point * G_pips_364 * Gd_332 || OrderStopLoss() == 0.0)) break;
                  f0_16();
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(Ask + Point * G_pips_364 * Gd_332, Digits), OrderTakeProfit(), 0, Red);
               }
            }
         }
      }
   }
   if (Li_0 && count_4 == 0 && count_8 == 0 && count_12 == 0) {
      for (pos_16 = OrdersHistoryTotal() - 1; pos_16 >= 0; pos_16--) {
         if (OrderSelect(pos_16, SELECT_BY_POS, MODE_HISTORY))
            if (OrderMagicNumber() == S3_Magic && OrderOpenTime() >= Gi_384) count_12++;
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
         S3_SetIndicators(Gi_520, iopen_28, iopen_36, iclose_44, iopen_52, iclose_60, istochastic_68, istochastic_76);
         if (Risk > 0.0) Ld_84 = f0_28(Risk, AccountFreeMargin());
         else Ld_84 = f0_5(Lots);
         if (S3_OpenLong(Gi_520)) {
            Ld_92 = 0;
            Ld_100 = 0;
            pips_108 = 0;
            pips_116 = 0;
            stoplevel_124 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            pips_108 = MathMax(Gd_324 * G_pips_364, stoplevel_124);
            pips_116 = MathMax(Gd_316 * G_pips_364, stoplevel_124);
            Ld_100 = NormalizeDouble(Bid - pips_108 * Point, Digits);
            Ld_92 = NormalizeDouble(Ask + pips_116 * Point, Digits);
            Li_132 = f0_17(OP_BUY, Ld_84, Ask, Ld_92, Ld_100, S3_Magic, "", Blue);
         }
         if (S3_OpenShort(Gi_520)) {
            Ld_92 = 0;
            Ld_100 = 0;
            pips_108 = 0;
            pips_116 = 0;
            stoplevel_124 = MarketInfo(Symbol(), MODE_STOPLEVEL);
            pips_108 = MathMax(Gd_324 * G_pips_364, stoplevel_124);
            pips_116 = MathMax(Gd_316 * G_pips_364, stoplevel_124);
            Ld_100 = NormalizeDouble(Ask + pips_108 * Point, Digits);
            Ld_92 = NormalizeDouble(Bid - pips_116 * Point, Digits);
            Li_136 = f0_17(OP_SELL, Ld_84, Bid, Ld_92, Ld_100, S3_Magic, "", Blue);
         }
      }
   }
   return (0);
}

//======================== Decompiled DLL-function =========================

int dword_100765C8 = 0;
int dword_100765CC;

// returns either 0 or -1
// bool CheckVersion (string a1)

int Status()
{
	return ( dword_100765C8 );
}

int ErrorCode()
{
	return ( dword_100765CC );
}