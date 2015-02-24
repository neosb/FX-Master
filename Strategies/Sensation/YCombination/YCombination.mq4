
#property copyright "Copyright © 2013, Forex Sensation Championship"
#property link      "http://www.forexsensation.com/"

#include <WinUser32.mqh>
//#include <stdlib.mqh>
#import "stdlib.ex4"
   string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A
#import "YCombination.dll"
   bool CheckVersion(string a0);
   void Initialize(string a0, string a1, int a2, int a3, string a4);
   int StatusWait();
   int Status();
   int Utc();
   int Msg(int a0, int a1, int& a2[]);
   bool GetMsg(int a0, int a1, string& a2[], int& a3[], int a4);
#import

extern string v.1.00 = "";
extern string Code = "";
extern double MaxDrawDown = 50.0;
extern double Risk = 0.5;
extern double Lot = 0.01;
extern double Multiplier = 1.4;
extern double TradeDelay = 0.25;
extern double TradeOffset = 10.0;
extern int MaxTrades = 8;
extern int BreakEvenTrade = 2;
extern double GridKoeff = 1.0;
extern int Magic = 78965125;
int Gi_160 = 20;
int Gi_164 = 20;
int G_color_168 = Olive;
int Gi_172 = 1993170;
int Gi_176 = 16737380;
string Gsa_180[] = {".", "..", "...", "....", "....."};
int Gi_unused_184 = 0;
int Gi_unused_188 = 0;
int Gi_192 = 0;
int Gi_196 = 0;
int Gi_200 = 0;
int Gi_204;
int Gi_208;
int Gi_212;
int Gi_216;
string Gs_220 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
int Gi_unused_228 = 0;
int Gi_unused_232 = 0;
double Gda_unused_236[];
bool Gi_240 = FALSE;
string Gsa_244[];
string Gsa_248[];
int Gia_252[];
int Gia_256[];
int Gi_260;
int Gi_264;
string G_str_concat_268;
string Gs_276;
bool G_bool_284 = FALSE;
int Gi_288 = 7;
bool Gi_292 = FALSE;
double Gd_296 = 10.0;
bool Gi_304 = FALSE;
double Gd_308 = 100.0;
bool Gi_316 = TRUE;
int Gi_320 = 0;
bool Gi_324 = FALSE;
int Gi_328 = 1;
int Gi_332 = 0;
int Gi_336 = 0;
bool Gi_340 = FALSE;
bool Gi_344 = FALSE;
bool Gi_348 = TRUE;
bool Gi_352 = FALSE;
int Gi_356 = 4;
int Gi_360 = 2;
double Gd_364 = 10.0;
double Gd_372 = 0.0;
double Gd_380 = 0.0;
bool Gi_388 = FALSE;
bool Gi_392 = FALSE;
double Gd_396 = 70.0;
double Gd_404 = 30.0;
int Gi_412 = 2;
bool Gi_416 = FALSE;
double Gd_420 = 600.0;
string Gs_428 = "4,4";
string Gs_436 = "25,50,100";
string Gs_444 = "50,100,200";
int G_period_452 = 100;
double Gd_456 = 10.0;
int G_period_464 = 14;
int G_period_468 = 10;
double Gd_472 = 10.0;
double Gd_480 = 2.0;
int Gi_488 = 20;
int G_period_492 = 10;
int G_period_496 = 2;
int G_slowing_500 = 2;
int G_timeframe_504 = PERIOD_H1;
int G_period_508 = 14;
int G_applied_price_512 = PRICE_CLOSE;
int G_period_516 = 10;
int G_ma_method_520 = MODE_SMA;
bool Gi_524 = FALSE;
bool Gi_528 = FALSE;
int G_slippage_532 = 99;
int Gi_536 = 0;
int Gi_540;
int Gi_544;
int Gi_548;
int Gi_552;
double Gd_556;
int G_count_564;
double Gd_568;
double Gd_576;
int Gi_584;
double Gd_588;
double Gd_596;
double Gd_604;
bool Gi_612;
int G_error_616;
int Gi_620;
int Gi_624;
int Gi_628;
int Gi_632;
int Gi_636;
int Gia_640[][2];
int Gi_644;
double Gd_648;
double G_lotstep_656;
double Gd_664;
bool Gi_672;
int Gia_unused_680[][2][2];
double Gda_692[];
int Gia_696[][2];
double Gd_700;
double Gd_708;
double Gd_716;
double Gd_740;
double Gd_748;
int Gi_756;
int G_ticket_760;
int G_count_764;
int Gi_768;
int G_file_772;
bool Gi_776;
bool Gi_780;
string G_name_784;
double Gd_792;
double Gd_800;

// E3EEC3F2E5BF785368EFFB4040FD4F55
string f0_16(int Ai_0) {
   return (StringConcatenate("YCombination", " lb: ", Ai_0));
}
	 		 	 			 		   	   	   		  				     	 			 		 			 	 		  			   	  	   		 		   						 			 	   	  			  	  	 			 	 	  	   	 	 		  			 		    	   	 		 
// 1D75F0D638248553D80CFFB8D1DC6682
void f0_0(int Ai_0, int &Ai_4, int &Ai_8) {
   string name_12 = f0_16(Ai_0);
   if (ObjectFind(name_12) == 0) {
      Ai_4 = ObjectGet(name_12, OBJPROP_XDISTANCE);
      Ai_8 = ObjectGet(name_12, OBJPROP_YDISTANCE);
   }
}
	   		   		    	  		   	 			 		 	 				   		   	    	 	 	 	 		 										 						  	 	 			  		     			    		  		  	  		 		    	 	     	  	  		  	 	
// C3BAA9C535265F9452B54C5C75FB8004
void f0_10(string A_text_0, color A_color_8 = -1, int Ai_12 = -1, double Ad_16 = -1.0, int Ai_24 = 0) {
   if (A_color_8 == CLR_NONE) A_color_8 = G_color_168;
   if (Ai_12 == -1) Ai_12 = Gi_196;
   if (Ad_16 == -1.0) Ad_16 = Gi_192;
   string name_28 = f0_16(Ai_12);
   if (ObjectFind(name_28) != 0) {
      ObjectCreate(name_28, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name_28, OBJPROP_CORNER, 0);
   }
   ObjectSetText(name_28, A_text_0, 9, "Courier New", A_color_8);
   ObjectSet(name_28, OBJPROP_XDISTANCE, Gi_208 + Ai_24);
   ObjectSet(name_28, OBJPROP_YDISTANCE, Gi_204 + 14.0 * Ad_16);
   Gi_192 = MathMax(Gi_192, Ad_16 + 1.0);
   Gi_196 = MathMax(Gi_196, Ai_12 + 1);
   Gi_200 = MathMax(Gi_200, Ai_12);
}
	     		 		 			   					  				  		 		  		 		 		 	   		 	  	 	 	  				     			   	 	 		     						 									    			  	 	       	 	     		   				 		
// BF5A9BC44BBE42C10E8B2D4446B20D89
void f0_8(int Ai_0 = -1, double Ad_4 = -1.0, int Ai_12 = 0) {
   if (Ai_0 == -1) Ai_0 = Gi_196;
   if (Ad_4 == -1.0) Ad_4 = Gi_192;
   f0_10("_______", G_color_168, Ai_0, Ad_4 - 0.3, Ai_12);
   Gi_192 = MathMax(Gi_192, Ad_4 + 1.0);
}
	  	    						 		 	 		 				 	 	   	     							 	   	  			   			 		   					   	 		  	 			 	 		  			 		   	 	         				  	 		 	  	 	 		 	 			  
// 8A6D85A0B52E3C8A8E55A15F14BE6D0A
int f0_5(string As_0, string As_8, int Ai_16 = -1, double Ad_20 = -1.0, int Ai_28 = 0) {
   if (Ai_16 == -1) Ai_16 = Gi_196;
   if (Ad_20 == -1.0) Ad_20 = Gi_192;
   f0_10(As_0, G_color_168, Ai_16, Ad_20, Ai_28);
   f0_10(As_8, Gi_172, Ai_16 + 1, Ad_20, Ai_28 + 7 * (StringLen(As_0) + 1));
   return (0);
}
						     	   	 	     	     		 		  		     	  	  		  	 	  	 	 			   				    			   	  			 	              	 				  			 	 		 				 	  				  	 	    	 	
// C2C5CA64BFA878771207E31C1E4B9E4F
void f0_9(int Ai_0, int Ai_4) {
   Gi_208 = Ai_0;
   Gi_204 = Ai_4;
   if (Gi_212 != Ai_0 || Gi_216 != Ai_4) {
      Gi_212 = Gi_164;
      Gi_216 = Gi_160;
   } else f0_0(0, Gi_208, Gi_204);
   Gi_196 = 0;
   Gi_192 = 0;
}
		 						 		  	 			   	 	 	  	 	 		 					 		   			   		 	   	     	 		  	 	 		 		    	  			   			 	   		   					 	  	   		 		  			 		 	 			    	 
// D61FF371629181373AAEA1B1C60EF302
void f0_14(int Ai_0, int Ai_4 = 0) {
   if (Ai_4 == 0) {
      Ai_4 = Gi_200;
      Gi_200 = Ai_0 - 1;
   }
   for (int Li_8 = Ai_0; Li_8 <= Ai_4; Li_8++) ObjectDelete(f0_16(Li_8));
}
	 		 	 			 		   	   	   		  				     	 			 		 			 	 		  			   	  	   		 		   						 			 	   	  			  	  	 			 	 	  	   	 	 		  			 		    	   	 		 
// CC9E8226BD8EC7D27CF11D972D60721C
int f0_12(string Asa_0[], int Aia_4[], int Ai_8 = -1, double Ad_12 = -1.0, int Ai_20 = 0) {
   int Li_36;
   if (Ai_8 == -1) Ai_8 = Gi_196;
   if (Ad_12 == -1.0) Ad_12 = Gi_192;
   int arr_size_24 = ArraySize(Asa_0);
   if (arr_size_24 != ArraySize(Aia_4)) return (Ai_8);
   int Li_28 = 0;
   for (int index_32 = 0; index_32 < arr_size_24; index_32++) {
      Li_36 = Gi_172;
      if (Aia_4[index_32] & 8 > 0) Li_36 = Gi_176;
      f0_10(Asa_0[index_32], Li_36, Ai_8, Ad_12, Ai_20 + 7 * Li_28);
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
void f0_6(string &Asa_0[], int Aia_4[], int Ai_8) {
   ArrayResize(Asa_0, Ai_8);
   ArrayResize(Aia_4, Ai_8);
   for (int index_12 = 0; index_12 < Ai_8; index_12++) Asa_0[index_12] = StringTrimLeft("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
}
								   	  	  	    	      	 			  				   	   	 		  		   	 	   	   		      		 	  	  	   	    		      			 									 	    				  	 				 	  	     		
// 57862CA56FB6CA780A1AA075901C0C7C
double f0_3(string As_0) {
   int Li_24;
   As_0 = f0_13(As_0);
   int str_len_8 = StringLen(As_0);
   double Ld_ret_12 = 0;
   for (int Li_20 = 0; Li_20 < str_len_8; Li_20++) {
      Li_24 = StringFind(Gs_220, StringSubstr(As_0, str_len_8 - Li_20 - 1, 1));
      Ld_ret_12 += Li_24 * MathPow(36, Li_20);
   }
   return (Ld_ret_12);
}
		 	    	 				 				 		 		 	 	 	  		     	 					 		  	  		    			  	   			 	   	 	   	 					 		  	 	 		     	     	   					 	 		 		 	 	 				 			  
// DF423827A5F770FA7875E68553FDD0BB
string f0_15(double Ad_0) {
   string str_concat_8 = "";
   for (Ad_0 = MathAbs(Ad_0); Ad_0 >= 1.0; Ad_0 = MathFloor(Ad_0 / 36.0)) str_concat_8 = StringConcatenate(StringSubstr(Gs_220, MathMod(Ad_0, 36), 1), str_concat_8);
   return (str_concat_8);
}
	 	 	  	 	   	     	 	   	 	  			  		  	 	   			  		     						 		 		 	  	 		 		 			  	    	 	 	 	 	 	 				 	  		 					   	 				  	 		     	 				
// D27AF7D1516C24C3278EA8BCC56C9759
string f0_13(string As_0) {
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
	        		 		 	  				 	 				 	 	 		     		 			    		  	 	 	 							  		 			  	  	 		 		  				   					  		      	  	 			     		      	 	  					 	
// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   int Li_0;
   int str2int_4;
   int str2int_8;
   int Li_12;
   int Li_16;
   string Ls_unused_36;
   double global_var_44;
   double Ld_52;
   int Li_64;
   f0_9(Gi_164, Gi_160);
   G_str_concat_268 = StringConcatenate("YCombination", " v.", "1.00");
   f0_10(G_str_concat_268, Gi_172);
   f0_8();
   Gi_240 = CheckVersion("1.00");
   if (!Gi_240) {
      f0_5("Error:", "Dll and Expert versions mismatch");
      return (0);
   }
   Code = StringTrimLeft(StringTrimRight(Code));
   if (StringLen(Code) <= 0) {
      if (GlobalVariableCheck("YC_CODE")) {
         global_var_44 = GlobalVariableGet("YC_CODE");
         Code = f0_15(global_var_44);
      }
   } else {
      Ld_52 = f0_3(Code);
      GlobalVariableSet("YC_CODE", Ld_52);
   }
   Gs_276 = AccountName();
   Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   f0_10("Authentication...");
   WindowRedraw();
   int Li_60 = StatusWait();
   Gi_196--;
   Gi_192--;
   if (Li_60 & 1 == 0) {
      Li_64 = f0_1(1, 0, Gi_260, Gsa_244, Gia_252);
      if (Li_64 == 0) f0_5("Authentication Failed! Error: ", Li_60);
      Print("Authentication Failed! Error: ", Li_60);
   } else {
      Li_64 = f0_1(1, 0, Gi_260, Gsa_244, Gia_252);
      if (Li_64 == 0) f0_10("Authenticated");
   }
   G_bool_284 = StringFind(Symbol(), "USDJPY") >= 0 || StringFind(Symbol(), "USDCHF") >= 0;
   if (!G_bool_284) {
      f0_8();
      f0_10("This currency is not supported!", Gi_172);
      MessageBox("You have selected the wrong currency pair!", G_str_concat_268 + ": Warning", MB_ICONEXCLAMATION);
   }
   if (Digits == 3 || Digits == 5) Gi_548 = 10;
   else Gi_548 = 1;
   if (Gi_304) Gi_584 = 10;
   else Gi_584 = 1;
   Gd_404 = NormalizeDouble(Gd_404 * Gi_548 * Point, Digits);
   TradeOffset = NormalizeDouble(TradeOffset * Gi_548 * Point, Digits);
   Gd_456 = NormalizeDouble(Gd_456 * Gi_548 * Point, Digits);
   Gd_472 = NormalizeDouble(Gd_472 * Gi_548 * Point, Digits);
   Gd_420 = NormalizeDouble(Gd_420 * Gi_548 * Point, Digits);
   Gd_364 = NormalizeDouble(Gd_364 * Gi_548 * Point, Digits);
   Gd_372 = NormalizeDouble(Gd_372 * Gi_548 * Point, Digits);
   Gd_380 = NormalizeDouble(Gd_380 * Gi_548 * Point, Digits);
   G_slippage_532 *= Gi_548;
   if (Gd_296 >= 1.0) Gd_296 = MathMin(Gd_296 / 100.0, 1);
   if (Gd_396 >= 1.0) Gd_396 = MathMin(Gd_396 / 100.0, 1);
   if (Gd_308 > 1.0) Gd_308 = MathMin(Gd_308 / 100.0, 1);
   Gd_596 = AccountBalance();
   Gd_588 = Gd_596 * (1 - Gd_296);
   HideTestIndicators(TRUE);
   Gd_648 = MathMax(Lot, MarketInfo(Symbol(), MODE_MINLOT));
   G_lotstep_656 = MarketInfo(Symbol(), MODE_LOTSTEP);
   Gi_612 = TRUE;
   if (Gi_320 < 0 || Gi_320 > 3) Gi_320 = 3;
   if (Gi_328 < 0 || Gi_328 > 2) Gi_328 = 0;
   if (Gi_332 < 0 || Gi_332 > 2) Gi_332 = 0;
   if (Gi_336 < 0 || Gi_336 > 2) Gi_336 = 0;
   if (Gi_360 == 0) Gi_360 = MaxTrades;
   ArrayResize(Gia_696, 6);
   for (Gi_620 = 0; Gi_620 < ArrayRange(Gia_696, 0); Gi_620++) {
      if (Gi_620 > 0) Gia_696[Gi_620][0] = MathPow(10, Gi_620);
      Gia_696[Gi_620][1] = Gi_620;
   }
   Gd_664 = Gia_696[ArrayBsearch(Gia_696, 1 / G_lotstep_656, WHOLE_ARRAY, 0, MODE_ASCEND)][1];
   if (!Gi_344) {
      ArrayResize(Gia_640, MaxTrades);
      while (Li_12 < MaxTrades) {
         if (StringFind(Gs_428, ",") == -1 && Li_12 == 0) {
            Li_16 = 1;
            break;
         }
         Li_0 = StrToInteger(StringSubstr(Gs_428, 0, StringFind(Gs_428, ",")));
         if (Li_0 > 0) {
            Gs_428 = StringSubstr(Gs_428, StringFind(Gs_428, ",") + 1);
            str2int_4 = StrToInteger(StringSubstr(Gs_436, 0, StringFind(Gs_436, ",")));
            Gs_436 = StringSubstr(Gs_436, StringFind(Gs_436, ",") + 1);
            str2int_8 = StrToInteger(StringSubstr(Gs_444, 0, StringFind(Gs_444, ",")));
            Gs_444 = StringSubstr(Gs_444, StringFind(Gs_444, ",") + 1);
         } else Li_0 = MaxTrades;
         if (str2int_4 == 0 || str2int_8 == 0) {
            Li_16 = 2;
            break;
         }
         for (int Li_68 = Li_12; Li_68 <= MathMin(Li_12 + Li_0 - 1, MaxTrades - 1); Li_68++) {
            Gia_640[Li_68][0] = str2int_4;
            Gia_640[Li_68][1] = str2int_8;
         }
         Li_12 = Li_68;
      }
      if (Li_16 > 0 || Gia_640[0][0] == 0 || Gia_640[0][1] == 0) Gi_612 = FALSE;
   } else {
      while (Li_12 < 4) {
         Li_0 = StrToInteger(StringSubstr(Gs_428, 0, StringFind(Gs_428, ",")));
         Gs_428 = StringSubstr(Gs_428, StringFind(Gs_428, DoubleToStr(Li_0, 0)) + 2);
         if (Li_12 == 0 && Li_0 < 1) {
            Li_16 = 1;
            break;
         }
         if (Li_12 == 0) Gi_624 = Li_0;
         else {
            if (Li_12 == 1 && Li_0 > 0) Gi_628 = Gi_624 + Li_0;
            else {
               if (Li_12 == 1) Gi_628 = 0;
               else {
                  if (Li_12 == 2 && Li_0 > 0) Gi_632 = Gi_628 + Li_0;
                  else {
                     if (Li_12 == 2) Gi_632 = 0;
                     else {
                        if (Li_12 == 3 && Li_0 > 0) Gi_636 = Gi_632 + Li_0;
                        else
                           if (Li_12 == 3) Gi_636 = 0;
                     }
                  }
               }
            }
         }
         Li_12++;
      }
      if (Li_16 == 1 || Gi_624 == 0) Gi_612 = FALSE;
   }
   if (Gi_348) {
      ArrayResize(Gda_692, G_period_508 + G_period_516);
      ArraySetAsSeries(Gda_692, TRUE);
   }
   G_name_784 = "B3_" + Magic + ".dat";
   G_file_772 = FileOpen(G_name_784, FILE_BIN|FILE_READ);
   if (G_file_772 != -1) {
      Gi_756 = FileReadInteger(G_file_772, LONG_VALUE);
      FileClose(G_file_772);
      Gd_700 = f0_4();
      Gi_776 = TRUE;
   }
   return (0);
}
		  	  	  	  	   			 	    		  							  	  	  			 	 	       				 	 			 	   			 		   	  	  			 	 	  		 	 		   	  			 				  	  				 	  		   			 				
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   switch (UninitializeReason()) {
   case REASON_REMOVE:
   case REASON_CHARTCLOSE:
      f0_14(0, Gi_200);
      Gi_200 = 0;
      if (IsDemo() && Gi_544 > 0) while (Gi_544 > 0) Gi_544 -= f0_7(5, Red);
   case REASON_RECOMPILE:
   case REASON_PARAMETERS:
   case REASON_CHARTCHANGE:
   case REASON_ACCOUNT:
      f0_14(1, Gi_200);
      Gi_200 = 1;
   }
   return (0);
}
			 		 	         	 	       	 					 			 	      		 			 	    			 	 	  				    					  		 		  	 	   	   	   		 	 		 						 	  		 	 		 		 	    	 	  			
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_0;
   double order_open_price_8;
   double order_lots_16;
   int datetime_24;
   double Ld_28;
   double Ld_36;
   double Ld_44;
   double ima_on_arr_52;
   double Ld_60;
   double order_open_price_68;
   double Ld_76;
   int Li_84;
   double Ld_88;
   double Ld_96;
   double Ld_104;
   double Ld_112;
   double Ld_120;
   double Ld_128;
   bool Li_136;
   bool Li_140;
   bool Li_144;
   bool is_deleted_148;
   bool Li_152;
   int cmd_156;
   double iatr_168;
   double Ld_176;
   double Ld_184;
   double Ld_192;
   double Ld_200;
   double Ld_208;
   double Ld_216;
   double Ld_224;
   double Ld_232;
   double Ld_240;
   double Ld_248;
   int Li_256;
   double ima_260;
   double icci_268;
   double icci_276;
   double icci_284;
   double icci_292;
   double icci_300;
   double icci_308;
   double icci_316;
   double icci_324;
   int Li_332;
   int Li_336;
   double ima_340;
   double istddev_348;
   double Ld_356;
   double Ld_364;
   double Ld_372;
   double Ld_380;
   double istochastic_388;
   double istochastic_396;
   int Li_512;
   int Li_516;
   int Li_520;
   int count_404 = 0;
   int count_408 = 0;
   int count_412 = 0;
   int count_416 = 0;
   int count_420 = 0;
   int count_424 = 0;
   double Ld_428 = 0;
   double Ld_436 = 0;
   double Ld_444 = 0;
   double order_open_price_452 = 0;
   double order_open_price_460 = 0;
   double Ld_468 = 0;
   double Ld_476 = 0;
   double Ld_484 = 0;
   double Ld_492 = 0;
   double Ld_500 = MarketInfo(Symbol(), MODE_TICKVALUE) / Point;
   Gd_800 = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
   if ((!Gi_240) || !G_bool_284) return (0);
   if (Gs_276 != AccountName()) {
      Gs_276 = AccountName();
      Initialize(AccountCompany(), AccountServer(), AccountNumber(), IsDemo(), Code);
   }
   int Li_508 = Status();
   if ((!IsTesting()) || IsVisualMode()) {
      f0_0(0, Gi_208, Gi_204);
      Gi_196 = 0;
      Gi_192 = 0;
      f0_10(G_str_concat_268, Gi_172);
      f0_8();
      if (Li_508 & 1 == 0) {
         Li_512 = f0_1(1, 0, Gi_260, Gsa_244, Gia_252);
         if (Li_512 == 0) f0_5("Authentication Failed! Error: ", Li_508);
      } else {
         Li_512 = f0_1(1, 0, Gi_260, Gsa_244, Gia_252);
         if (Li_512 == 0) f0_10("Authenticated");
         f0_8();
         Li_516 = f0_1(2, 0, Gi_264, Gsa_248, Gia_256);
         if (Li_516 > 0) f0_8();
         f0_5("ServerTime:", TimeToStr(TimeCurrent()));
         f0_5("UtcTime:", TimeToStr(Utc()));
         f0_8();
         Li_520 = MarketInfo(Symbol(), MODE_SPREAD);
         f0_5("Spread:", StringConcatenate(DoubleToStr(Li_520 / (1.0 * Gi_548), 1), " (", Li_520, " pips)"));
         f0_5("Leverage:", StringConcatenate(AccountLeverage(), ":1"));
         f0_8();
         f0_5("Lot:", DoubleToStr(Lot, 2));
      }
      f0_14(Gi_196);
      WindowRedraw();
   }
   for (Gi_620 = 0; Gi_620 < OrdersTotal(); Gi_620++) {
      if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
         cmd_156 = OrderType();
         if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol()) continue;
         if (OrderTakeProfit() > 0.0) f0_17(OrderOpenPrice(), OrderStopLoss());
         if (cmd_156 <= OP_SELL) {
            Ld_88 += OrderProfit();
            Ld_484 += OrderSwap() + OrderCommission();
            Ld_128 += OrderLots() * OrderOpenPrice();
            if (OrderOpenTime() >= datetime_24) {
               datetime_24 = OrderOpenTime();
               order_lots_16 = OrderLots();
               order_open_price_8 = OrderOpenPrice();
            }
            if (OrderOpenTime() < Gi_756 || Gi_756 == 0) Gi_756 = OrderOpenTime();
            if (OrderOpenTime() < Ld_76 || Ld_76 == 0.0) {
               Ld_76 = OrderOpenTime();
               G_ticket_760 = OrderTicket();
               order_open_price_68 = OrderOpenPrice();
            }
            if (Gi_416 && OrderStopLoss() == 0.0) Li_152 = TRUE;
            if (cmd_156 == OP_BUY) {
               count_404++;
               Ld_428 += OrderLots();
               continue;
            }
            count_408++;
            Ld_436 += OrderLots();
            continue;
         }
         if (cmd_156 == OP_BUYLIMIT) {
            count_412++;
            order_open_price_452 = OrderOpenPrice();
            continue;
         }
         if (cmd_156 == OP_SELLLIMIT) {
            count_416++;
            order_open_price_460 = OrderOpenPrice();
            continue;
         }
         if (cmd_156 == OP_BUYSTOP) {
            count_420++;
            continue;
         }
         count_424++;
      }
   }
   Gi_540 = count_404 + count_408;
   Gi_544 = count_412 + count_416 + count_420 + count_424;
   Ld_444 = Ld_428 + Ld_436;
   if (Ld_444 > 0.0) {
      Ld_128 = NormalizeDouble(Ld_128 / Ld_444, Digits);
      Ld_88 = NormalizeDouble(Ld_88 + Ld_484, 2);
      if (Ld_88 > Gd_708 || Gd_708 == 0.0) Gd_708 = Ld_88;
      if (Ld_88 < Gd_716 || Gd_716 == 0.0) Gd_716 = Ld_88;
      if (count_404 > 0 && Gd_792 > 0.0) {
         Ld_492 = NormalizeDouble((Gd_792 - Ld_128) * Ld_500 * Ld_444 + Ld_484, 2);
         Ld_96 = NormalizeDouble((Bid - Ld_128) / Point / Gi_548, 1);
      }
      if (count_408 > 0 && Gd_792 > 0.0) {
         Ld_492 = NormalizeDouble((Ld_128 - Gd_792) * Ld_500 * Ld_444 + Ld_484, 2);
         Ld_96 = NormalizeDouble((Ld_128 - Ask) / Point / Gi_548, 1);
      }
      if (!Gi_776) {
         G_file_772 = FileOpen(G_name_784, FILE_BIN|FILE_WRITE);
         if (G_file_772 > -1) {
            FileWriteInteger(G_file_772, Gi_756);
            FileClose(G_file_772);
            Gi_776 = TRUE;
         }
      }
   } else {
      if (Gi_776) {
         Gd_604 = 0;
         Gd_792 = 0;
         Gd_708 = 0;
         Gd_716 = 0;
         Gi_756 = 0;
         Gd_700 = 0;
         Gd_748 = 0;
         G_count_764 = 0;
         Gi_768 = 0;
         G_file_772 = FileOpen(G_name_784, FILE_BIN|FILE_READ);
         if (G_file_772 > -1) {
            FileClose(G_file_772);
            G_error_616 = GetLastError();
            FileDelete(G_name_784);
            G_error_616 = GetLastError();
            if (G_error_616 == 0/* NO_ERROR */) Gi_776 = FALSE;
            else Print("Error deleting file: " + G_name_784 + " " + G_error_616 + " " + ErrorDescription(G_error_616));
         } else Gi_776 = FALSE;
      }
   }
   if (Gi_540 == 0 && (!Gi_672)) {
      Gi_672 = TRUE;
      for (Gi_620 = OrdersTotal() - 1; Gi_620 >= 0; Gi_620--) {
         if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderMagicNumber() != Magic || OrderType() <= OP_SELL) continue;
            if (OrderLots() > Lot) {
               Gi_672 = FALSE;
               is_deleted_148 = OrderDelete(OrderTicket());
               if (!(is_deleted_148)) return;
               Gi_672 = TRUE;
               return;
            }
         }
      }
   } else {
      if (Gi_540 > 0 && Gi_672) {
         Gi_672 = FALSE;
         for (Gi_620 = OrdersTotal() - 1; Gi_620 >= 0; Gi_620--) {
            if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
               if (OrderMagicNumber() != Magic || OrderType() <= OP_SELL) continue;
               if (OrderLots() == Lot) {
                  Gi_672 = TRUE;
                  is_deleted_148 = OrderDelete(OrderTicket());
                  if (!(is_deleted_148)) return;
                  Gi_672 = FALSE;
                  return;
               }
            }
         }
      }
   }
   if (Gi_352 && Gi_540 >= Gi_356 && G_count_764 < Gi_360) {
      if (Gd_792 > 0.0 && (!Gi_780) && (count_404 > 0 && order_open_price_68 > Gd_792) || (count_408 > 0 && order_open_price_68 < Gd_792)) {
         Gi_620 = f0_7(4, DarkViolet);
         if (Gi_620 == 1) {
            Gd_700 = f0_4();
            Gi_536 = 0;
            return;
         }
      }
   }
   if (Gi_540 > 0) {
      if (Gd_700 < 0.0 && (!Gi_524)) {
         Gd_700 = 0;
         Gi_780 = TRUE;
      }
      Ld_112 = Ld_88 + Gd_700;
      if (Gd_700 != Gd_740) {
         Gi_780 = TRUE;
         Gd_740 = Gd_700;
         Gd_748 = NormalizeDouble(Gd_700 / Ld_500 / Ld_444, Digits);
      }
      if (Ld_60 > 0.0 || (Ld_60 < 0.0 && Gi_524)) Ld_112 += Ld_60;
   }
   if (Gi_540 == 0 && 0) {
      f0_7(2, Red);
      return;
   }
   switch (Gi_536) {
   case 1:
      if (!(Gi_540 == 0 && Gi_544 == 0)) break;
      Gi_536 = 0;
      break;
   case 2:
      Gi_536 = 0;
      break;
   case 3:
      if (!(Gi_540 == 0 && Gi_544 == 0 && 1)) break;
      Gi_536 = 0;
      break;
   default:
      Gi_536 = 0;
   }
   if (Gi_536 > 0) {
      f0_7(Gi_536, Red);
      return;
   }
   if (Gi_540 + G_count_764 >= BreakEvenTrade && Ld_112 > 0.0) {
      f0_7(3, Lime);
      return;
   }
   if (Gi_388) {
      f0_7(3, Red);
      Gi_388 = FALSE;
      return;
   }
   if (Gi_540 == 0 && 1 && Gi_292) {
      if (Gi_612) Gi_612 = FALSE;
      if (Gi_544 > 0) f0_7(5, Red);
   }
   if (Gi_612 && Li_508 & 4 > 0) {
      if (Gi_344) {
         iatr_168 = iATR(NULL, PERIOD_D1, 21, 0);
         if (Digits < 4) Gi_644 = 100.0 * iatr_168 / 5.0;
         else Gi_644 = 10000.0 * iatr_168 / 5.0;
         if (Gi_540 + G_count_764 >= Gi_636 && Gi_636 > 0) {
            Ld_28 = 12 * Gi_644;
            Ld_36 = 18 * Gi_644;
         } else {
            if (Gi_540 + G_count_764 >= Gi_632 && Gi_632 > 0) {
               Ld_28 = Gi_644 * 8;
               Ld_36 = 12 * Gi_644;
            } else {
               if (Gi_540 + G_count_764 >= Gi_628 && Gi_628 > 0) {
                  Ld_28 = Gi_644 * 4;
                  Ld_36 = Gi_644 * 8;
               } else {
                  if (Gi_540 + G_count_764 >= Gi_624 && Gi_624 > 0) {
                     Ld_28 = Gi_644 * 2;
                     Ld_36 = Gi_644 * 4;
                  } else {
                     Ld_28 = Gi_644;
                     Ld_36 = Gi_644 * 2;
                  }
               }
            }
         }
      } else {
         if (Gi_540 + G_count_764 <= MaxTrades) {
            Gi_620 = MathMax(Gi_540 + G_count_764 - 1, 0);
            Ld_28 = Gia_640[Gi_620][0];
            Ld_36 = Gia_640[Gi_620][1];
         } else {
            Ld_28 = Gia_640[MaxTrades - 1][0];
            Ld_36 = Gia_640[MaxTrades - 1][1];
         }
      }
      Ld_28 = NormalizeDouble(Ld_28 * GridKoeff * Gi_548 * Point, Digits);
      Ld_36 = NormalizeDouble(Ld_36 * GridKoeff * Gi_548 * Point, Digits);
      if ((Gi_540 > 0 && Gd_792 == 0.0) || Gi_540 + 0 != Gi_768 || Gi_780) {
         Gi_768 = Gi_540 + 0;
         if (count_404 > 0) {
            if (Gd_748 != 0.0) Ld_128 -= Gd_748;
            if (Gd_372 > 0.0) Ld_176 = Ld_128 + Gd_372;
            else {
               if (G_count_764 > 0 && Gd_364 > 0.0) Ld_176 = Ld_128 + Gd_364;
               else Ld_176 = order_open_price_8 + Ld_36;
            }
            if (Gd_380 > 0.0) Ld_176 = MathMax(Ld_176, Ld_128 + Gd_380);
         } else {
            if (count_408 > 0) {
               if (Gd_748 != 0.0) Ld_128 += Gd_748;
               if (Gd_372 > 0.0) Ld_176 = Ld_128 - Gd_372;
               else {
                  if (G_count_764 > 0 && Gd_364 > 0.0) Ld_176 = Ld_128 - Gd_364;
                  else Ld_176 = order_open_price_8 - Ld_36;
               }
               if (Gd_380 > 0.0) Ld_176 = MathMin(Ld_176, Ld_128 - Gd_380);
            }
         }
         Gi_780 = FALSE;
         if (Gd_792 != Ld_176) {
            Gd_792 = Ld_176;
            return;
         }
      }
      Ld_184 = NormalizeDouble(AccountBalance() * Gd_308, 2);
      if (Ld_112 < 0.0) Ld_120 = (-Ld_112) / Ld_184;
      if (Ld_120 >= MaxDrawDown / 100.0) f0_7(3, Red);
      else {
         if (-Ld_112 > Gd_568) Gd_568 = -Ld_112;
         Ld_192 = Gd_596 * (Gd_296 + 1.0);
         Ld_200 = AccountBalance() * (1 - Gd_296);
         Ld_208 = Ld_192 * (1 - Gd_296);
         if (Ld_200 > Ld_208) {
            Gd_596 = Ld_192;
            Gd_588 = Ld_200;
         }
         Ld_216 = Gd_588 * Gd_308;
         if (Ld_184 < Ld_216) {
            Gi_612 = FALSE;
            return (0);
         }
         if (Risk > 0.0) {
            Ld_224 = AccountBalance() / 1000.0 * Gd_308;
            if (Multiplier == 1.0) Ld_232 = Gi_288;
            else Ld_232 = (MathPow(Multiplier, Gi_288) - Multiplier) / (Multiplier - 1.0);
            Ld_240 = Risk * Gi_584 * (Ld_224 / (Ld_232 + 1.0));
            if (Ld_240 > 100 / MathPow(Multiplier, Gi_288 - 1) && Gi_584 == 1) Ld_240 = 100 / MathPow(Multiplier, Gi_288 - 1);
            if (Ld_240 > 50 / MathPow(Multiplier, Gi_288 - 1) && Gi_584 == 10) Ld_240 = 50 / MathPow(Multiplier, Gi_288 - 1);
            Lot = f0_11(Ld_240);
         }
         if (Gi_540 > 0 && Gd_372 == 0.0 && !Gi_352 || (Gi_352 && Gd_364 == 0.0 || (Gd_364 > 0.0 && Gi_540 + G_count_764 < Gi_356))) {
            if (Gd_604 <= 0.0) Gd_604 = Lot * Ld_500 * Point * Gi_548 * Gia_640[0][1];
            Ld_104 = NormalizeDouble(Gd_604 * (Gi_540 + G_count_764), 2) - Gd_700;
            if (Gi_528) Ld_104 -= Ld_484 * (Ld_484 < 0.0);
            if (Ld_492 < Ld_104) {
               if (count_404 > 0) Ld_176 = NormalizeDouble(Ld_128 + Ld_104 / Ld_500 / Ld_444, Digits);
               else
                  if (count_408 > 0) Ld_176 = NormalizeDouble(Ld_128 - Ld_104 / Ld_500 / Ld_444, Digits);
               if (Gd_792 != Ld_176) {
                  Gd_792 = Ld_176;
                  return;
               }
            }
         }
         Ld_104 = Ld_492 + Gd_700;
         if (Gi_392) {
            if (Gi_540 == 0) {
               Gd_556 = 0;
               G_count_564 = 0;
               Gd_576 = 0;
            }
            if (Gi_540 > 0) {
               if (Gd_576 > 0.0 && Ld_112 <= Gd_576) {
                  f0_7(3, Green);
                  return;
               }
               if (Ld_104 > 0.0 && Ld_112 > Ld_104 * Gd_396) Gd_576 = Ld_104 * Gd_396;
               if (Gd_576 > 0.0 && Gd_576 > Gd_556 && Gd_404 > 0.0 && Gi_412 > G_count_564) {
                  if (count_404 > 0) Gd_792 += Gd_404;
                  else
                     if (count_408 > 0) Gd_792 -= Gd_404;
                  G_count_564++;
                  Gd_556 = Gd_576;
                  return;
               }
            }
         } else {
            if (Ld_112 > Ld_104) {
               f0_7(3, Green);
               return;
            }
         }
         if (Gi_416) {
            if (Gi_540 == 0) Gi_552 = 0;
            if ((Gi_540 > 0 && Gi_540 + G_count_764 > Gi_552) || Li_152) {
               Ld_248 = MathMin(Ld_184 * (MaxDrawDown + 1.0) / 100.0 / Ld_500 / Ld_444, Gd_420);
               Ld_468 = NormalizeDouble(Ld_128 - Ld_248, Digits);
               Ld_476 = NormalizeDouble(Ld_128 + Ld_248, Digits);
               for (Gi_620 = 0; Gi_620 < OrdersTotal(); Gi_620++) {
                  if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
                     if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol() || OrderType() > OP_SELL) continue;
                     if (OrderType() == OP_BUY && OrderStopLoss() != Ld_468) {
                        is_deleted_148 = f0_17(OrderOpenPrice(), Ld_468, Purple);
                        continue;
                     }
                     if (OrderType() == OP_SELL && OrderStopLoss() != Ld_476) is_deleted_148 = f0_17(OrderOpenPrice(), Ld_476, Purple);
                  }
               }
               Gi_552 = Gi_540 + G_count_764;
            }
         }
         ima_260 = iMA(Symbol(), 0, G_period_452, 0, MODE_EMA, PRICE_CLOSE, 0);
         if (Gi_320 == 3) {
            if (Bid > ima_260 + Gd_456) Li_256 = 0;
            else {
               if (Ask < ima_260 - Gd_456) Li_256 = 1;
               else Li_256 = 2;
            }
         } else Li_256 = Gi_320;
         if (Gi_328 > 0 && Gi_540 == 0 && Gi_544 < 2) {
            if (Bid > ima_260 + Gd_456 && !Gi_316 || (Gi_316 && Li_256 != 2)) {
               if (Gi_328 == 1) {
                  if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                  else Li_136 = FALSE;
                  if ((!Gi_324) && Li_144 && Li_140 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_140 = FALSE;
               } else {
                  if (Gi_328 == 2) {
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                     else Li_140 = FALSE;
                     if ((!Gi_324) && Li_144 && Li_136 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_136 = FALSE;
                  }
               }
            } else {
               if (Ask < ima_260 - Gd_456 && !Gi_316 || (Gi_316 && Li_256 != 2)) {
                  if (Gi_328 == 1) {
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                     else Li_140 = FALSE;
                     if ((!Gi_324) && Li_144 && Li_136 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_136 = FALSE;
                  } else {
                     if (Gi_328 == 2) {
                        if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                        else Li_136 = FALSE;
                        if ((!Gi_324) && Li_144 && Li_140 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_140 = FALSE;
                     }
                  }
               } else {
                  if (Gi_316 && Li_256 == 2) {
                     if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                  } else {
                     Li_136 = FALSE;
                     Li_140 = FALSE;
                  }
               }
            }
            Li_144 = TRUE;
         }
         if (Gi_332 > 0) {
            icci_268 = iCCI(Symbol(), PERIOD_M5, G_period_464, PRICE_CLOSE, 0);
            icci_276 = iCCI(Symbol(), PERIOD_M15, G_period_464, PRICE_CLOSE, 0);
            icci_284 = iCCI(Symbol(), PERIOD_M30, G_period_464, PRICE_CLOSE, 0);
            icci_292 = iCCI(Symbol(), PERIOD_H1, G_period_464, PRICE_CLOSE, 0);
            icci_300 = iCCI(Symbol(), PERIOD_M5, G_period_464, PRICE_CLOSE, 1);
            icci_308 = iCCI(Symbol(), PERIOD_M15, G_period_464, PRICE_CLOSE, 1);
            icci_316 = iCCI(Symbol(), PERIOD_M30, G_period_464, PRICE_CLOSE, 1);
            icci_324 = iCCI(Symbol(), PERIOD_H1, G_period_464, PRICE_CLOSE, 1);
         }
         if (Gi_332 > 0 && Gi_540 == 0 && Gi_544 < 2) {
            if (icci_300 > 0.0 && icci_308 > 0.0 && icci_316 > 0.0 && icci_324 > 0.0 && icci_268 > 0.0 && icci_276 > 0.0 && icci_284 > 0.0 && icci_292 > 0.0) {
               if (Gi_320 == 3) Li_256 = 0;
               if (Gi_332 == 1) {
                  if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                  else Li_136 = FALSE;
                  if ((!Gi_324) && Li_144 && Li_140 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_140 = FALSE;
               } else {
                  if (Gi_332 == 2) {
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                     else Li_140 = FALSE;
                     if ((!Gi_324) && Li_144 && Li_136 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_136 = FALSE;
                  }
               }
            } else {
               if (icci_300 < 0.0 && icci_308 < 0.0 && icci_316 < 0.0 && icci_324 < 0.0 && icci_268 < 0.0 && icci_276 < 0.0 && icci_284 < 0.0 && icci_292 < 0.0) {
                  if (Gi_320 == 3) Li_256 = 1;
                  if (Gi_332 == 1) {
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                     else Li_140 = FALSE;
                     if ((!Gi_324) && Li_144 && Li_136 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_136 = FALSE;
                  } else {
                     if (Gi_332 == 2) {
                        if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                        else Li_136 = FALSE;
                        if ((!Gi_324) && Li_144 && Li_140 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_140 = FALSE;
                     }
                  }
               } else {
                  if ((!Gi_324) && Li_144) {
                     Li_136 = FALSE;
                     Li_140 = FALSE;
                  }
               }
            }
            Li_144 = TRUE;
         }
         if (Gi_336 > 0 && Gi_540 == 0 && Gi_544 < 2) {
            Li_332 = Gi_488;
            Li_336 = 100 - Gi_488;
            ima_340 = iMA(Symbol(), 0, G_period_468, 0, MODE_SMA, PRICE_OPEN, 0);
            istddev_348 = iStdDev(Symbol(), 0, G_period_468, 0, MODE_SMA, PRICE_OPEN, 0);
            Ld_356 = ima_340 + Gd_480 * istddev_348;
            Ld_364 = ima_340 - Gd_480 * istddev_348;
            Ld_372 = Ld_356 + Gd_472;
            Ld_380 = Ld_364 - Gd_472;
            istochastic_388 = iStochastic(NULL, 0, G_period_492, G_period_496, G_slowing_500, MODE_LWMA, 1, MODE_MAIN, 1);
            istochastic_396 = iStochastic(NULL, 0, G_period_492, G_period_496, G_slowing_500, MODE_LWMA, 1, MODE_SIGNAL, 1);
            if (Ask < Ld_380 && istochastic_388 < Li_332 && istochastic_396 < Li_332) {
               if (Gi_336 == 1) {
                  if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                  else Li_136 = FALSE;
                  if ((!Gi_324) && Li_144 && Li_140 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_140 = FALSE;
               } else {
                  if (Gi_336 == 2) {
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                     else Li_140 = FALSE;
                     if ((!Gi_324) && Li_144 && Li_136 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_136 = FALSE;
                  }
               }
            } else {
               if (Bid > Ld_372 && istochastic_388 > Li_336 && istochastic_396 > Li_336) {
                  if (Gi_336 == 1) {
                     if (Gi_320 != 0 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_140)) Li_140 = TRUE;
                     else Li_140 = FALSE;
                     if ((!Gi_324) && Li_144 && Li_136 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_136 = FALSE;
                  } else {
                     if (Gi_336 == 2) {
                        if (Gi_320 != 1 && Gi_324 || (!Li_144) || ((!Gi_324) && Li_144 && Li_136)) Li_136 = TRUE;
                        else Li_136 = FALSE;
                        if ((!Gi_324) && Li_144 && Li_140 && !Gi_316 || (Gi_316 && Li_256 != 2)) Li_140 = FALSE;
                     }
                  }
               } else {
                  if ((!Gi_324) && Li_144) {
                     Li_136 = FALSE;
                     Li_140 = FALSE;
                  }
               }
            }
            Li_144 = TRUE;
         }
         if (Gi_320 < 2 && (!Li_144) && Gi_540 == 0) {
            if (Gi_320 == 0) Li_136 = TRUE;
            if (Gi_320 == 1) Li_140 = TRUE;
         }
         if (Gi_540 == 0 && Gi_544 < 2) {
            if (Gi_316) {
               if (Li_136) {
                  if ((count_420 == 0 && count_416 == 0 && Li_256 != 2 || Gi_328 == 0) || (count_420 == 0 && count_416 == 0 && Li_256 == 2 && Gi_328 == 1)) {
                     Ld_44 = Ld_28 - MathMod(Ask, Ld_28) + TradeOffset;
                     if (Ld_44 > Gd_800) Li_84 = f0_2(Symbol(), 4, Lot, Ld_44, 0, Magic, CLR_NONE);
                  }
                  if ((count_412 == 0 && count_424 == 0 && Li_256 != 2 || Gi_328 == 0) || (count_412 == 0 && count_424 == 0 && Li_256 == 2 && Gi_328 == 2)) {
                     Ld_44 = MathMod(Ask, Ld_28) + TradeOffset;
                     if (Ld_44 > Gd_800) Li_84 = f0_2(Symbol(), 2, Lot, -Ld_44, 0, Magic, CLR_NONE);
                  }
               }
               if (Li_140) {
                  if ((count_416 == 0 && count_420 == 0 && Li_256 != 2 || Gi_328 == 0) || (count_416 == 0 && count_420 == 0 && Li_256 == 2 && Gi_328 == 2)) {
                     Ld_44 = Ld_28 - MathMod(Bid, Ld_28) - TradeOffset;
                     if (Ld_44 > Gd_800) Li_84 = f0_2(Symbol(), 3, Lot, Ld_44, 0, Magic, CLR_NONE);
                  }
                  if ((count_424 == 0 && count_412 == 0 && Li_256 != 2 || Gi_328 == 0) || (count_424 == 0 && count_412 == 0 && Li_256 == 2 && Gi_328 == 1)) {
                     Ld_44 = MathMod(Bid, Ld_28) + TradeOffset;
                     if (Ld_44 > Gd_800) Li_84 = f0_2(Symbol(), 5, Lot, -Ld_44, 0, Magic, CLR_NONE);
                  }
               }
               if (Li_84 > 0) return;
            } else {
               if (Li_136) {
                  Li_84 = f0_2(Symbol(), 0, Lot, 0, G_slippage_532, Magic, Blue);
                  if (Li_84 > 0) return;
               }
               if (Li_140) {
                  Li_84 = f0_2(Symbol(), 1, Lot, 0, G_slippage_532, Magic, Red);
                  if (Li_84 > 0) return;
               }
            }
         } else {
            if (count_404 > 0) {
               if (TimeCurrent() - 3600.0 * TradeDelay > datetime_24 && count_404 + G_count_764 < MaxTrades) {
                  if (order_open_price_8 > Ask) Ld_44 = order_open_price_8 - (MathRound((order_open_price_8 - Ask) / Ld_28) + 1.0) * Ld_28;
                  else Ld_44 = order_open_price_8 - Ld_28;
                  if (Gi_340) Ld_0 = f0_11(order_lots_16 + MathMax(Lot, G_lotstep_656));
                  else Ld_0 = f0_11(MathMax(order_lots_16 * Multiplier, order_lots_16 + G_lotstep_656));
                  if (Gi_348) {
                     if (Ask < order_open_price_8 - Ld_28) {
                        for (Gi_620 = 0; Gi_620 < G_period_508 + G_period_516; Gi_620++) Gda_692[Gi_620] = iRSI(NULL, G_timeframe_504, G_period_508, G_applied_price_512, Gi_620);
                        ima_on_arr_52 = iMAOnArray(Gda_692, 0, G_period_516, 0, G_ma_method_520, 0);
                        if (Gda_692[0] > ima_on_arr_52) {
                           Li_84 = f0_2(Symbol(), 0, Ld_0, 0, G_slippage_532, Magic, Blue);
                           if (Li_84 > 0) {
                              Gi_780 = TRUE;
                              return;
                           }
                        }
                     }
                  }
                  if (count_412 == 0) {
                     if (Ask - Ld_44 > Gd_800) {
                        Li_84 = f0_2(Symbol(), 2, Ld_0, Ld_44 - Ask, 0, Magic, SkyBlue);
                        if (Li_84 > 0) return;
                     }
                  }
                  if (count_412 == 1 && Ld_44 - order_open_price_452 > Ld_28 / 2.0 && Ask - Ld_44 > Gd_800) {
                     for (Gi_620 = OrdersTotal(); Gi_620 >= 0; Gi_620--) {
                        if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
                           if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol() || OrderType() != OP_BUYLIMIT) continue;
                           is_deleted_148 = f0_17(Ld_44, 0, SkyBlue);
                           if (is_deleted_148) return;
                        }
                     }
                  }
               }
            } else {
               if (count_408 > 0) {
                  if (TimeCurrent() - 3600.0 * TradeDelay > datetime_24 && count_408 + G_count_764 < MaxTrades) {
                     if (Bid > order_open_price_8) Ld_44 = order_open_price_8 + (MathRound(((-order_open_price_8) + Bid) / Ld_28) + 1.0) * Ld_28;
                     else Ld_44 = order_open_price_8 + Ld_28;
                     if (Gi_340) Ld_0 = f0_11(order_lots_16 + MathMax(Lot, G_lotstep_656));
                     else Ld_0 = f0_11(MathMax(order_lots_16 * Multiplier, order_lots_16 + G_lotstep_656));
                     if (Gi_348) {
                        if (Bid > order_open_price_8 + Ld_28) {
                           for (Gi_620 = 0; Gi_620 < G_period_508 + G_period_516; Gi_620++) Gda_692[Gi_620] = iRSI(NULL, G_timeframe_504, G_period_508, G_applied_price_512, Gi_620);
                           ima_on_arr_52 = iMAOnArray(Gda_692, 0, G_period_516, 0, G_ma_method_520, 0);
                           if (Gda_692[0] < ima_on_arr_52) {
                              Li_84 = f0_2(Symbol(), 1, Ld_0, 0, G_slippage_532, Magic, Red);
                              if (Li_84 > 0) {
                                 Gi_780 = TRUE;
                                 return (0);
                              }
                           }
                        }
                     } else {
                        if (count_416 == 0) {
                           if (Ld_44 - Bid > Gd_800) {
                              Li_84 = f0_2(Symbol(), 3, Ld_0, Ld_44 - Bid, 0, Magic, Coral);
                              if (Li_84 > 0) return;
                           }
                        } else {
                           if (count_416 == 1 && order_open_price_460 - Ld_44 > Ld_28 / 2.0 && Ld_44 - Bid > Gd_800) {
                              for (Gi_620 = OrdersTotal() - 1; Gi_620 >= 0; Gi_620--) {
                                 if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
                                    if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol() || OrderType() != OP_SELLLIMIT) continue;
                                    is_deleted_148 = f0_17(Ld_44, 0, Coral);
                                    if (is_deleted_148) return;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (0);
}
	   		 				     	 		    				 			  				 				   			  	 	  		 		 	  						 										 	 		 	 		   					   	 	  		 	   		 	 	   	 			   	   	 		  		 
// C5FE8A154791B11AE15D60D226811087
double f0_11(double Ad_0) {
   Ad_0 = NormalizeDouble(Ad_0, Gd_664);
   Ad_0 = MathMin(Ad_0, MarketInfo(Symbol(), MODE_MAXLOT));
   Ad_0 = MathMax(Ad_0, Gd_648);
   return (Ad_0);
}
	 		  				 				 	   			 		  	  	      				 			 		 	 	 	 			  	   	      		     				 	   	   						  				 			  		  	  	  	 		 	 		 		 		 	   		 	 
// 3CC94C06370D2627C52A1F5EBCAEC673
int f0_2(string As_0, int Ai_8, double Ad_12, double Ad_20, double A_slippage_28, int A_magic_36, color A_color_40 = -1) {
   int ticket_44;
   double price_48;
   int Li_56 = 5;
   int count_60 = 0;
   int cmd_64 = MathMod(Ai_8, 2);
   if (AccountFreeMarginCheck(As_0, cmd_64, Ad_12) <= 0.0) return (-1);
   while (count_60 < 5 && 1) {
      count_60++;
      while (IsTradeContextBusy()) Sleep(100);
      if (IsStopped()) return (-1);
      if (cmd_64 == OP_BUY) price_48 = NormalizeDouble(MarketInfo(As_0, MODE_ASK) + Ad_20, MarketInfo(As_0, MODE_DIGITS));
      else price_48 = NormalizeDouble(MarketInfo(As_0, MODE_BID) + Ad_20, MarketInfo(As_0, MODE_DIGITS));
      ticket_44 = OrderSend(As_0, Ai_8, Ad_12, price_48, A_slippage_28, 0, 0, "", A_magic_36, 0, A_color_40);
      if (ticket_44 >= 0) break;
      G_error_616 = GetLastError();
      if (G_error_616 != 0/* NO_ERROR */) {
         Print("Error opening order: " + G_error_616 + " " + ErrorDescription(G_error_616) + " Symbol: " + As_0 + " TradeOP: " + Ai_8 + " OType: " + cmd_64 + " Ask: " + MarketInfo(As_0,
            MODE_ASK) + " Bid: " + MarketInfo(As_0, MODE_BID) + " OPrice: " + DoubleToStr(Ad_20, Digits) + " Price: " + DoubleToStr(price_48, Digits) + " Lots: " + DoubleToStr(Ad_12,
            2));
      }
      switch (G_error_616) {
      case 4/* SERVER_BUSY */:
      case 6/* NO_CONNECTION */:
      case 129/* INVALID_PRICE */:
      case 137/* BROKER_BUSY */:
      case 146/* TRADE_CONTEXT_BUSY */:
         count_60 += 1;
         break;
      case 149/* TRADE_HEDGE_PROHIBITED */:
         count_60 = Li_56;
         break;
      case 135/* PRICE_CHANGED */:
      case 136/* OFF_QUOTES */:
      case 138/* REQUOTE */:
         RefreshRates();
         continue;
         break;
      default:
         count_60 = Li_56;
      }
   }
   return (ticket_44);
}
	  		 		 			 		   	  		  		    		 	 	 		 			 	 	      	  	  		  			 	    		 	  	 	        	  			 		  					 		 			   		     			 	   				   	  	 		
// F235F73FF9E6C9B0402F9856A41D6B1B
int f0_17(double A_price_0, double A_price_8, color A_color_16 = -1) {
   bool bool_20 = FALSE;
   int Li_24 = 5;
   int count_28 = 0;
   while (count_28 < 5 && 1 && !bool_20) {
      count_28++;
      while (IsTradeContextBusy()) Sleep(100);
      if (IsStopped()) return (-1);
      bool_20 = OrderModify(OrderTicket(), A_price_0, A_price_8, 0, 0, A_color_16);
      if (!((!bool_20))) break;
      G_error_616 = GetLastError();
      if (G_error_616 > 0/* NO_ERROR */) {
         Print(" Error Modifying Order:", OrderTicket(), ", ", G_error_616, " :" + ErrorDescription(G_error_616), ", Ask:", Ask, ", Bid:", Bid, " OrderPrice: ", A_price_0,
            " StopLevel: ", Gd_800, ", SL: ", A_price_8, ", OSL: ", OrderStopLoss());
      } else bool_20 = TRUE;
      switch (G_error_616) {
      case 0/* NO_ERROR */:
      case 1/* NO_RESULT */:
         count_28 = Li_24;
         continue;
         break;
      case 4/* SERVER_BUSY */:
      case 6/* NO_CONNECTION */:
      case 129/* INVALID_PRICE */:
      case 136/* OFF_QUOTES */:
      case 137/* BROKER_BUSY */:
      case 146/* TRADE_CONTEXT_BUSY */:
      case 128/* TRADE_TIMEOUT */:
         count_28 += 1;
         continue;
         break;
      case 135/* PRICE_CHANGED */:
      case 138/* REQUOTE */:
         RefreshRates();
         break;
      default:
         count_28 = Li_24;
      }
   }
   return (bool_20);
}
	   				 		   	   		  	  			 	 		 						 		    	   	 		  	 		   						   					 	 	 	 	    		  		 			  				  					  		       	  	    	 	   		   		
// B75276FE165DA730AE20F9071D438F17
int f0_7(int Ai_0, color A_color_4, string As_8 = "") {
   bool Li_16;
   int Li_ret_20;
   Gi_536 = Ai_0;
   for (Gi_620 = OrdersTotal() - 1; Gi_620 >= 0; Gi_620--) {
      if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_TRADES)) {
         if (Ai_0 == 1 && OrderMagicNumber() != Magic) continue;
         if (Ai_0 == 3 && OrderMagicNumber() != Magic) continue;
         if (Ai_0 == 4 && OrderTicket() != G_ticket_760) continue;
         if (Ai_0 == 5 && OrderMagicNumber() != Magic || OrderType() <= OP_SELL) continue;
         while (IsTradeContextBusy()) Sleep(100);
         if (IsStopped()) return (-1);
         if (OrderType() > OP_SELL) Li_16 = OrderDelete(OrderTicket(), A_color_4);
         else Li_16 = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), G_slippage_532, A_color_4);
         if (Li_16) {
            Li_ret_20++;
            continue;
         }
         Print("Order ", OrderTicket(), " failed to close. Error:", ErrorDescription(GetLastError()));
      }
   }
   if (StringLen(As_8) > 0) Print("Closed ", Li_ret_20, " [", As_8, "]");
   else Print("Closed ", Li_ret_20);
   return (Li_ret_20);
}
	 				 			 	    	       		   			    		 			 	  			 	  	  			 	 	  	  			 		  							  		 	      			     	 					 	  	 	 	 	 			 			 			   	     		 
// 60A8917DED9805D5A2D3F3A173CF2A0C
double f0_4() {
   double Ld_ret_0;
   G_count_764 = 0;
   if (Gi_756 > 0) {
      for (Gi_620 = OrdersHistoryTotal() - 1; Gi_620 >= 0; Gi_620--) {
         if (OrderSelect(Gi_620, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderOpenTime() >= Gi_756) {
               if (OrderMagicNumber() == Magic) {
                  Ld_ret_0 += OrderProfit() + OrderSwap() + OrderCommission();
                  if (OrderMagicNumber() == Magic && OrderType() <= OP_SELL) G_count_764++;
               }
            }
         }
      }
   }
   return (Ld_ret_0);
}
	   	 					  		 	 		 		 				   	  			 					  	 		  	  	 		 			   				   					  			 	    	 		 							 			 	  	 		   			  	   		 		   			 	 		 	 	 
// 25D8FA49F2C78939384F1B1F7C3C8CC3
int f0_1(int Ai_0, int Ai_4, int &Ai_8, string Asa_12[], int Aia_16[], string As_20 = "") {
   int Lia_28[1];
   int str_len_36;
   int Li_ret_32 = Msg(Ai_0, Ai_4, Lia_28);
   if (Lia_28[0] != Ai_8 || Li_ret_32 != ArraySize(Asa_12)) {
      Ai_8 = Lia_28[0];
      f0_6(Asa_12, Aia_16, Li_ret_32);
      GetMsg(Ai_0, Ai_4, Asa_12, Aia_16, Li_ret_32);
   }
   if (Li_ret_32 > 0) {
      str_len_36 = StringLen(As_20);
      if (str_len_36 > 0) {
         f0_10(As_20);
         f0_12(Asa_12, Aia_16, Gi_196, Gi_192 - 1, 7 * (str_len_36 + 1));
      } else f0_12(Asa_12, Aia_16);
   }
   return (Li_ret_32);
}
