//===================================================================================
//                                                           FFCal_mini.mq4
//                                           ver.0.4 20121110  fai_hatena
//===================================================================================
//                                                                FFCal.mq4
//                                            Copyright © 2006, Derk Wehler
//                                                   (derkwehler@gmail.com)
// Written in cooperation with:                 http://www.forexfactory.com
//
//                                            $Workfile:: FFCal.mq4                 $
//                                            $Revision:: 20                        $
//                                              $Author:: Derk                      $
//                                                $Date:: 7/07/09 5:40a             $
//
// This "indicator" calls DLLs to fetch a special XML file from the
// ForexFactory web site.  It then parses it and writes it out as a .CSV
// file, which it places in the folder: experts/files so that IsNewsTime()
// can use that file to tell if it is near announcement time.
//
// It does this once when it starts up and once per 6 hours in case there
// have been any updates to the annoucement calendar.  In order to lessen
// sudden traffic on the FF site, it refreshes every 6 hours on a random
// minute.
//
// SAMPLE CALLS TO THE INDICATOR:
//
//     int minutesSincePrevEvent =
//            iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 0);
//
//     int minutesUntilNextEvent =
//            iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 1);
//
//     // Use this call to get ONLY impact of previous event
//     int impactOfPrevEvent =
//            iCustom(NULL, 0, "FFCal", true, true, false, true, true, 2, 0);
//
//     // Use this call to get ONLY impact of nexy event
//     int impactOfNextEvent =
//            iCustom(NULL, 0, "FFCal", true, true, false, true, true, 2, 1);
//
//
// EXAMPLE CODE FOR USE IN AN EA:
// (NOTE I HAVE PUT IN CODE TO CALL THE INDICATOR ONLY ONCE PER MINUTE)
//
// // EA Setting variables
// extern int MinsBeforeNews = 60; // mins before an event to stay out of trading
// extern int MinsafterNews  = 60; // mins after  an event to stay out of trading
//
// // Global variable at top of file
// bool NewsTime;
//
// // Function to check if it is news time
// void NewsHandling()
// {
//     static int PrevMinute = -1;
//
//     if (Minute() != PrevMinute)
//     {
//         PrevMinute = Minute();
//
//         int minutesSincePrevEvent =
//             iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 0);
//
//         int minutesUntilNextEve nt =
//             iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 1);
//
//         NewsTime = false;
//         if ((minutesUntilNextEvent <= MinsBeforeNews) ||
//             (minutesSincePrevEvent <= MinsAfterNews))
//         {
//             NewsTime = true;
//         }
//     }
// }//newshandling
//
//=============================================================================
//
//                             OTHER CREDIT DUE
//      (For GrebWeb and LogUtils functionality (see end of this flie)
//
//  2/14/2007:  Robert Hill added code for using text objects instead
//              of Comment() for easier reading
//
//  2/25/2007:  Paul Hampton-Smith for his TimeZone DLL code
//  3/31/2007:  Code replaces by simpler method from BurgerKing
//
//  2/26/2007:  Mike Nguyen added the following things:
//              (search text for "Added by MN")
//
//            - Connection test so that MT4 doesnt hang when
//              there is no server connection
//            - Fixed some minor syntax because was getting
//              "too many files open error..."
//            - Added vertical lines and vertical news text so that
//              we have a visual reference of when the news happened.
//            - Now supports and correctly draws two simultaneous news
//              announcements
//            - Added text to say "xx min SINCE event..." after the
//              event as past
//            - Clean up old Objects left behind on old news annoumcents
//            - Now "Back Draws" Old news headlines onto the chart
//            - Now can choose which corner of the chart to place the
//              headlines
//
//  4/2/2007:  Mike Nguyen added the following things:
//             (search text for "Added by MN")
//           - Added ability to disable Web/URL updates. This is so that the
//             multiple instances of the indicator used by other charts or EAs
//             dont fight with each other (Error code 4103)
//           - Fixed deleting OBJ_TREND, only deletes its own Trend Lines
//             objects instead of all OBJ_TREND objects
//           - Fixed deleting OBJ_TEXT, only deletes its own Headlines
//             instead of all text
//           - Made file name global and indicator now deletes the xml file
//             each time the indicator is put on or removed from chart. Fixed
//             one case of divide by zero where multiple charts indicator is
//             on was trying to overwrite the same file (forces a new
//             download of the xml)
//
// 4/29/2007:  Derk Wehler
//           - Fixed problem where indicator returns zero for "Minutes Until
//             Next Event" when there are no more events for the week for
//             that currency pair.  That caused EAs calling it to think that
//             it was always new time.  Instead, we now set it to a flag
//             value, which EAs can test for.
//
// 5/16/2007:  Derk Wehler
//           - Added sample code to header
//           - Changed variable name from DispOldNews to DispVertNews
//
// 6/02/2007:  Derk Wehler (thanks to "Flourishing")
//           - Changed how often it updates the file from the FF site web
//             page.  Now it uses a global variable, so that when you have
//             it running on multiple charts, it should only update once
//             every 4 hours for all of them.
//
// 6/05/2007:  Derk Wehler
//           - Fixed logHandle error by resetting to -1 when closed
//           - Added "NeedToGetFile" variable for getting the XML if it
//             does not already exist
//           - Added extern "SaveXmlFiles", so that when FFCal de-inits,
//             the user can choose whether or not to delete old XML files
//
//=============================================================================
//+---------------------------------------------------------------------------+
//|                                                               WinInet.mqh |
//|                                                        Paul Hampton-Smith |
//|                                                        paul1000@pobox.com |
//|                                                                           |
//| This include has been adapted from the groundbreaking GrabWeb script      |
//| developed by Adbi that showed me how to import functions from wininet.dll |
//|---------------------------------------------------------------------------|
//|                                                               grabweb.mq4 |
//|                                                    Copyright © 2006, Abhi |
//|                                         http://www.megadelfi.com/experts/ |
//|                                     E-mail: grabwebexpert{Q)megadelfi.com |
//|                                fix my e-mail address before mailing me ;) |
//+---------------------------------------------------------------------------+


#property copyright "Copyright © 2006, Derk Wehler"
#property link      "http://www.forexfactory.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 CLR_NONE
#property indicator_color2 CLR_NONE
#property indicator_color3 CLR_NONE


#define TITLE     0
#define COUNTRY   1
#define DATE      2
#define TIME      3
#define IMPACT    4
#define FORECAST  5
#define PREVIOUS  6

#define EVENTMAX 256

//====================================================================================
//====================================================================================
//====================================================================================
//====================================================================================
//====================================================================================
//====================================================================================
//====================================================================================

extern bool 	IncludeHigh 		= true;
extern bool 	IncludeMedium 		= true;
extern bool 	IncludeLow 			= false;
extern bool 	IncludeSpeaks 		= true; 		// news items with "Speaks" in them have different characteristics
extern bool		IsEA_Call			= false;
extern int		OffsetHours			= 0;
extern bool		AllowWebUpdates     = true;	// Set this to false when using in another EA or Chart, so that the multiple instances of the indicator dont fight with each other
extern int		Alert1MinsBefore	=  -1;			// Set to -1 for no Alert
extern int		Alert2MinsBefore	=  -1;			// Set to -1 for no Alert
extern bool		ReportAllPairs		= false;
extern bool     SkipSameTimeNews    = false;
extern bool 	EnableLogging 		= false; 		// Perhaps remove this from externs once its working well
extern int		ShowEventsNum	    = 4;
extern bool     ShowTextOneLine     = true;
extern int 		TxtSize             =  10;
extern color 	TxtColorNews 		= DeepSkyBlue;// Vaild if TextOneLine = false
extern color 	TxtColorOldNews     = Gray;

extern color 	TxtColorImpactHigh  = Red;
extern color 	TxtColorImpactMed   = Orange;
extern color 	TxtColorImpactLow   = Khaki;

extern int		NewsCorner 			= 2;			// Choose which corner to place headlines 0=Upper Left, 1=Upper Right, 2=lower left , 3=lower right
extern bool		SaveXmlFiles		= false;		// If true, this will keep the daily XML files

extern bool     UseDailyFXData      = false;

int		DebugLevel = 5;


double 	minsBuffer0[];    // Contains (minutes until) each news event
double 	EAminBuffer1[];   // Contains only most recent and next news event ([0] & [1])
double 	ImpactBuffer2[];  // Contains impact value for most recent and next news event


string	sUrl = "http://www.forexfactory.com/ff_calendar_thisweek.xml";
int 	logHandle = -1;

string 	mainData[EVENTMAX][7];
datetime mainDataGMT[EVENTMAX];

string 	sTags[7] = { "<title>", "<country>", "<date>", "<time>", "<impact>", "<forecast>", "<previous>" };
string 	eTags[7] = { "</title>", "</country>", "</date>", "</time>", "</impact>", "</forecast>", "</previous>" };

string  ObjPrefix = "mFFCal_";
datetime CurrentGMT;
//=================================================================================================
int init()
{
  // If we are not logging, then do not output debug statements either
  // moved by euclid
  if ( !EnableLogging )
    DebugLevel = 0;

  // Open the log file (will not open if logging is turned off)
  // Filename changed by euclid
  OpenLog( StringConcatenate( "FFCal", Symbol(), Period() ) );

  SetIndexStyle ( 0, DRAW_NONE );
  SetIndexBuffer( 0, minsBuffer0 );

  SetIndexStyle ( 1, DRAW_NONE );
  SetIndexBuffer( 1, EAminBuffer1 );

  SetIndexStyle ( 2, DRAW_NONE );
  SetIndexBuffer( 2, ImpactBuffer2 );

  IndicatorShortName( "FFCal" );
  SetIndexLabel( 0, NULL );
  SetIndexLabel( 1, NULL );
  SetIndexLabel( 2, NULL );

  return( 0 );
}
//=================================================================================================
int deinit()
{
  if ( logHandle > 0 ) //added by euclid
    FileClose( logHandle );

  if( IsEA_Call ) return( 0 );

  for( int i = ObjectsTotal() - 1; i >= 0; i-- ) {
    string ObjName = ObjectName( i );
    if ( StringFind( ObjName, ObjPrefix ) == 0 ) ObjectDelete( ObjName );
  }

  return( 0 );
}
//=================================================================================================
string GetXmlFileName()
{
  return ( Month() + "-" + Day() + "-" + Year() + "-" + "FFCal.xml" );
}
//=================================================================================================
int start()
{
  static int newsIdx = 0;

  static datetime LastExecuteGMTTime = D'31.12.2037';

  // check to make sure we are connected, otherwise exit. Added by MN
  if ( !IsConnected() ) {
    Print( "News Indicator is disabled because NO CONNECTION to Broker!" );
    return( 0 );
  }
  //PlaySound("tick");
  // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
  static datetime PrevLocaltime = 0;
  if ( !IsEA_Call && TimeLocal() - PrevLocaltime <= 30 ) return ( true );
  PrevLocaltime = TimeLocal();


  // Init the buffer array to zero just in case
  ArrayInitialize( minsBuffer0 , 0 );
  ArrayInitialize( EAminBuffer1, 0 );

  CurrentGMT = TimeGMT() + ( OffsetHours * 3600 );

  static datetime PrevReadTime = 0;
  if( newsIdx == 0 || TimeLocal() - PrevReadTime > 60 * 60 ) {

    if( !UseDailyFXData ) {
      string sXMLData = ReadXMLFile();
      if( sXMLData == "" ) return( 0 );
      newsIdx = ParseXML( sXMLData );
    } else {
      int ret = DownloadCSVFile();
      newsIdx = ParseCSV();
    }

  PrevReadTime = TimeLocal();
  }



  int tmpMins = 10080;	// (a week)
  int idxOfNext = newsIdx - 1;

  for( int id = 0; id < newsIdx; id++ ) {
    // If we got this far then we need to calc the minutes until this event

    // Now calculate the minutes until this announcement (may be negative)
    int minsTillNews = MathFloor( ( mainDataGMT[id] - CurrentGMT ) / 60.0 );
    if ( DebugLevel > 0 ) {
      Log( "FOREX FACTORY\nTitle: " + mainData[id][TITLE] + "\n" + minsTillNews + "\n\n" );
    }

    // Keep track of the most recent news announcement.
    // Do that by saving each one until we get to the
    // first annoucement that isn't in the past; i.e.
    // minsTillNews > 0.  Then, keep this one instead for
    // display, but only once the minutes until the next
    // news is SMALLER than the minutes since the last.
//			Print("Mins till event: ", minsTillNews);
    if ( minsTillNews < 0 || MathAbs( tmpMins ) > minsTillNews ) {
      idxOfNext = id;
      tmpMins	= minsTillNews;
    }

    // Do alert if user has enabled
    if ( !IsEA_Call && Alert1MinsBefore != -1 && minsTillNews <= Alert1MinsBefore && minsTillNews > 0
         && LastExecuteGMTTime + Alert1MinsBefore * 60 + 60  <= mainDataGMT[id] ) {
      Alert( Alert1MinsBefore, "(", minsTillNews, ") mins until news for ",
             mainData[id][COUNTRY], ": ", mainData[id][TITLE], MakeForecastPreviousTEXT( mainData[id][FORECAST], mainData[id][PREVIOUS] ) );
    }

    if ( !IsEA_Call && Alert2MinsBefore != -1 && minsTillNews <= Alert2MinsBefore && minsTillNews > 0
         && LastExecuteGMTTime + Alert2MinsBefore * 60 + 60 <= mainDataGMT[id] ) {
      Alert( Alert2MinsBefore, "(", minsTillNews, ") mins until news for ",
             mainData[id][COUNTRY], ": ", mainData[id][TITLE], MakeForecastPreviousTEXT( mainData[id][FORECAST], mainData[id][PREVIOUS] ) );
    }

    // Buffers are set up as so:
    // minsBuffer0 contains the time UNTIL each announcement (can be negative)
    // e.g. [0] = -372; [1] = 25; [2] = 450; [3] = 1768 (etc.)
    // EAminBuffer1[0] has the mintutes since the last annoucement.
    // EAminBuffer1[1] has the mintutes until the next annoucement.
    minsBuffer0[id] = minsTillNews;
  }

  LastExecuteGMTTime = CurrentGMT;

  // Cycle through the events array and pick out the most recent
  // past and the next coming event to put into EAminBuffer1.
  // Put the corresponding impact for these two into ImpactBuffer2.
  bool first = true;
  EAminBuffer1[0]  = 999999;
  EAminBuffer1[1]  = 999999;
  ImpactBuffer2[0] = 0;
  ImpactBuffer2[1] = 0;

  string outNews = "Minutes until news events for " + Symbol() + " : ";
  for ( int i = 0; i < newsIdx; i++ ) {
    outNews = outNews + minsBuffer0[i] + ", ";
    if ( minsBuffer0[i] >= 0 && first ) {
      first = false;

      // Put the relevant info into the indicator buffers...

      // Minutes SINCE - - - - - - - - - - - - - - - - - - - - - - - - -
      // (does not apply if the first event of the week has not passed)
      if ( i > 0 ) {
        EAminBuffer1[0] = MathAbs( minsBuffer0[i - 1] );
        ImpactBuffer2[0] = ImpactToNumber( mainData[i - 1][IMPACT] );
      }

      // Minutes UNTIL - - - - - - - - - - - - - - - - - - - - - - - - -
      // Check if past the last event.
      if ( minsBuffer0[i] > 0 || ( minsBuffer0[i] == 0 && minsBuffer0[i + 1] > 0 ) ) {
        EAminBuffer1[1] = minsBuffer0[i];
      }
      ImpactBuffer2[1] = ImpactToNumber( mainData[i][IMPACT] );
    }
  }

  // If we are past all news events, then neither one will have been
  // set, so set the past event to the last (negative) minutes
  if ( first ) {
    EAminBuffer1[0]  = MathAbs( minsBuffer0[i - 1] );
    EAminBuffer1[1]  = 999999;
    ImpactBuffer2[0] = ImpactToNumber( mainData[i - 1][IMPACT] );
    minsBuffer0[idxOfNext] = 999999;
  }


  // For debugging...Print the tines until news events, as a "Comment"
  if ( DebugLevel > 0 ) {
    Print( outNews );
    Print( "LastMins (EAminBuffer1[0]) = ", EAminBuffer1[0] );
    Print( "NextMins (EAminBuffer1[1]) = ", EAminBuffer1[1] );
  }

  if ( !IsEA_Call ) {
    if( ShowTextOneLine )
      for( i = 0; i < ShowEventsNum; i++ ) OutputToChartTextOneLine( i, idxOfNext );
    else
      for( i = 0; i < ShowEventsNum; i++ ) OutputToChartText( i, idxOfNext );
  }

  return ( 0 );
}

//=================================================================================================
int OutputToChartText( int id, int idxOfNext )
{
  static int curY = 0;
  if( id == 0 ) {
    curY = TxtSize + 4;
  } else {
    curY = curY + TxtSize * 2 + 2;
  }

  color  TxtColorNews_  = TxtColorNews;
  color TxtColorImpact_ = TxtColorImpactHigh;

  string title   = mainData[idxOfNext + id][TITLE];
  string country = mainData[idxOfNext + id][COUNTRY];
  string impact  = mainData[idxOfNext + id][IMPACT];
  string forecast = mainData[idxOfNext + id][FORECAST];
  string previous = mainData[idxOfNext + id][PREVIOUS];
  int    minutes = minsBuffer0[idxOfNext + id];

  string times   = TimeToStr( mainDataGMT[idxOfNext + id] + ( TimeLocal() - CurrentGMT ), TIME_MINUTES );
  if( mainDataGMT[idxOfNext + id] - CurrentGMT > 60 * 60 * 24 ) {
    times   = TimeToStr( mainDataGMT[idxOfNext + id] + ( TimeLocal() - CurrentGMT ), TIME_DATE | TIME_MINUTES );
    times   = StringSubstr( times, 5 );
  }

  if( impact == "Low" )   TxtColorImpact_ = TxtColorImpactLow;
  if( impact == "Medium" )TxtColorImpact_ = TxtColorImpactMed;

  string ImpactObj  = ObjPrefix + "Impact" + id;
  string MinutesObj = ObjPrefix + "Minutes" + id;
  ObjectDelete( ImpactObj );
  ObjectDelete( MinutesObj );


  if( id != 0 && StringLen( title ) == 0 ) return( 0 );

  if ( minutes < 0 ) TxtColorNews_ = TxtColorOldNews;

  ObjectCreate( MinutesObj, OBJ_LABEL, 0, 0, 0 );
  ObjectSet( MinutesObj, OBJPROP_CORNER, NewsCorner );
  ObjectSet( MinutesObj, OBJPROP_XDISTANCE, 10 );
  ObjectSet( MinutesObj, OBJPROP_YDISTANCE, curY );
  if ( minutes == 999999 ) {
    ObjectSetText( MinutesObj, " (No more events this week)", TxtSize, "Verdana", TxtColorOldNews );
  } else {
    ObjectSetText( MinutesObj, country + ": " + title + MakeForecastPreviousTEXT( forecast, previous ), TxtSize, "Verdana", TxtColorNews_ );
    curY = curY + TxtSize + 6;
    ObjectCreate( ImpactObj, OBJ_LABEL, 0, 0, 0 );
    ObjectSetText( ImpactObj, times + " " + impact, TxtSize, "Verdana", TxtColorImpact_ );

    ObjectSet( ImpactObj, OBJPROP_CORNER, NewsCorner );
    ObjectSet( ImpactObj, OBJPROP_XDISTANCE, 10 );
    ObjectSet( ImpactObj, OBJPROP_YDISTANCE, curY );
  }

  return( 0 );
}
//=================================================================================================
int OutputToChartTextOneLine( int id, int idxOfNext )
{
  static int curY = 0;
  if( id == 0 ) {
    curY = TxtSize + 4;
  } else {
    curY = curY + TxtSize * 2 + 2;
  }

  color  TxtColorNews_  = TxtColorNews;
  color TxtColorImpact_ = TxtColorImpactHigh;

  string title   = mainData[idxOfNext + id][TITLE];
  string country = mainData[idxOfNext + id][COUNTRY];
  string impact  = mainData[idxOfNext + id][IMPACT];
  string forecast = mainData[idxOfNext + id][FORECAST];
  string previous = mainData[idxOfNext + id][PREVIOUS];
  int    minutes = minsBuffer0[idxOfNext + id];

  string times   = TimeToStr( mainDataGMT[idxOfNext + id] + ( TimeLocal() - CurrentGMT ), TIME_MINUTES );
  if( mainDataGMT[idxOfNext + id] - CurrentGMT > 60 * 60 * 24 ) {
    times   = TimeToStr( mainDataGMT[idxOfNext + id] + ( TimeLocal() - CurrentGMT ), TIME_DATE | TIME_MINUTES );
    times   = StringSubstr( times, 5 );
  }

  if( impact == "High" )   TxtColorNews_ = TxtColorImpactHigh;
  if( impact == "Low" )    TxtColorNews_ = TxtColorImpactLow;
  if( impact == "Medium" ) TxtColorNews_ = TxtColorImpactMed;

  string MinutesObj = ObjPrefix + "Minutes" + id;
  ObjectDelete( MinutesObj );

  if( id != 0 && StringLen( title ) == 0 ) return( 0 );

  if ( minutes < 0 ) TxtColorNews_ = TxtColorOldNews;

  ObjectCreate( MinutesObj, OBJ_LABEL, 0, 0, 0 );
  ObjectSet( MinutesObj, OBJPROP_CORNER, NewsCorner );
  ObjectSet( MinutesObj, OBJPROP_XDISTANCE, 10 );
  ObjectSet( MinutesObj, OBJPROP_YDISTANCE, curY );
  if ( minutes == 999999 ) {
    ObjectSetText( MinutesObj, " (No more events this week)", TxtSize, "Verdana", TxtColorOldNews );
  } else {
    ObjectSetText( MinutesObj, times + " " + country + " " + title + MakeForecastPreviousTEXT( forecast, previous ), TxtSize, "Verdana", TxtColorNews_ );
  }

  return( 0 );
}



//=================================================================================================
string MakeForecastPreviousTEXT( string f, string p )
{
  if( StringLen( f ) == 0 && StringLen( p ) == 0 ) return( "" );
  if( StringLen( f ) > 0 && StringLen( p ) == 0 ) return( "  (" + f + "/-.-)" );
  if( StringLen( f ) == 0 && StringLen( p ) >  0 ) return( "  (-.-/" + p + ")" );
  return( "  (" + f + "/" + p + ")" );
}
//=================================================================================================
double ImpactToNumber( string impact )
{
  if ( impact == "High" )  return ( 3 );
  if ( impact == "Medium" )return ( 2 );
  if ( impact == "Low" )   return ( 1 );
  return ( 0 );
}
//=================================================================================================
string MakeDateTime( string strDate, string strTime )
{
  // Print("Converting Forex Factory Time into Metatrader time..."); //added by MN
  // Converts forexfactory time & date into yyyy.mm.dd hh:mm
  int n1stDash = StringFind( strDate, "-" );
  int n2ndDash = StringFind( strDate, "-", n1stDash + 1 );

  string strMonth = StringSubstr( strDate, 0, 2 );
  string strDay = StringSubstr( strDate, 3, 2 );
  string strYear = StringSubstr( strDate, 6, 4 );
//	strYear = "20" + strYear;

  int nTimeColonPos = StringFind( strTime, ":" );
  string strHour = StringSubstr( strTime, 0, nTimeColonPos );
  string strMinute = StringSubstr( strTime, nTimeColonPos + 1, 2 );
  string strAM_PM = StringSubstr( strTime, StringLen( strTime ) - 2 );

  int nHour24 = StrToInteger( strHour );
  if ( strAM_PM == "pm" || strAM_PM == "PM" && nHour24 != 12 ) {
    nHour24 += 12;
  }
  if ( strAM_PM == "am" || strAM_PM == "AM" && nHour24 == 12 ) {
    nHour24 = 0;
  }
  string strHourPad = "";
  if ( nHour24 < 10 )
    strHourPad = "0";

  return( StringConcatenate( strYear, ".", strMonth, ".", strDay, " ", strHourPad, nHour24, ":", strMinute ) );
}
//=================================================================================================
string ReadXMLFile()
{
  string tmpData = "";
  bool NeedToGetFile = false;
  // Added this section to check if the XML file already exists.
  // If it does NOT, then we need to set a flag to go get it
  string xmlFileName = GetXmlFileName();
  int xmlHandle = FileOpen( xmlFileName, FILE_BIN | FILE_READ );

  // File does not exist if FileOpen return -1 or if GetLastError = ERR_CANNOT_OPEN_FILE (4103)
  if ( xmlHandle >= 0 ) {
    // Since file exists, close what we just opened
    if( FileSize( xmlHandle ) < 70 ) NeedToGetFile = true;
    FileClose( xmlHandle );
  } else {
    NeedToGetFile = true;
  }

  //added by MN. Set this to false when using in another EA or Chart, so that the multiple
  //instances of the indicator dont fight with each other
  if ( AllowWebUpdates ) {
    // New method: Use global variables so that when put on multiple charts, it
    // will not update overly often; only first time and every 4 hours
    if ( DebugLevel > 1 )
      Print( GlobalVariableGet( "LastUpdateTime" ) + " " + ( TimeLocal() - GlobalVariableGet( "LastUpdateTime" ) ) );

    if ( NeedToGetFile || GlobalVariableCheck( "LastUpdateTime" ) == false ||
         ( TimeLocal() - GlobalVariableGet( "LastUpdateTime" ) ) > 14400 ) {

      if ( DebugLevel > 1 ) Print( "sUrl == ", sUrl );
      if ( DebugLevel > 0 ) Print( "Grabbing Web, url = ", sUrl );

      // THIS CALL WAS DONATED BY PAUL TO HELP FIX THE RESOURCE ERROR
      GrabWeb( sUrl, tmpData ); //PlaySound("tick");

      if ( DebugLevel > 0 ) {
        Print( "Opening XML file...\n" );
        Print( tmpData );
      }

      // Write the contents of the ForexFactory page to an .htm file
      // If it is still open from the above FileOpen call, close it.
      xmlHandle = FileOpen( xmlFileName, FILE_BIN | FILE_WRITE );
      if ( xmlHandle < 0 ) {
        if ( DebugLevel > 0 )
          Print( "Can\'t open new xml file, the last error is ", GetLastError() );
        return( "" );
      }
      FileWriteString( xmlHandle, tmpData, StringLen( tmpData ) );
      FileClose( xmlHandle );

      if ( DebugLevel > 0 ) Print( "Wrote XML file...\n" );

      // THIS BLOCK OF CODE DONATED BY WALLY TO FIX THE RESOURCE ERROR
      //--- Look for the end XML tag to ensure that a complete page was downloaded ---//
      int end = StringFind( tmpData, "</weeklyevents>", 0 );

      if ( end <= 0 ) {
        Alert( "FFCal Error - Web page download was not complete!" );
        return( "" );
      } else {
        // set global to time of last update
        GlobalVariableSet( "LastUpdateTime", TimeLocal() );
        //
      }

      //-------------------------------------------------------------------------------//
    }
  } //end of allow web updates


  if( tmpData != "" ) return( tmpData );

  // Open the XML file
  //xmlFileName = "test.xml";
  xmlHandle = FileOpen( xmlFileName, FILE_BIN | FILE_READ );
  if ( xmlHandle < 0 ) {
    Print( "Can\'t open xml file: ", xmlFileName, ".  The last error is ", GetLastError() );
    return( "" );
  }
  if ( DebugLevel > 0 ) Print( "XML file open must be okay" );

  // Read in the whole XML file
  // Workaround for FileReadString limitation - added by euclid
  tmpData = "";
  while ( StringLen( tmpData ) < FileSize( xmlHandle ) )
    tmpData = StringConcatenate( tmpData, FileReadString( xmlHandle, FileSize( xmlHandle ) - StringLen( tmpData ) ) );
  //changed to StringConcatenate (string + string is not reliable) - euclid

  if ( StringLen( tmpData ) < FileSize( xmlHandle ) )
    Print( "Error: can\'t Read in the whole XML file ", GetLastError( ) );

  // Because MT4 build 202 complained about too many files open and MT4 hung. Added by MN
  FileClose( xmlHandle );



  static string OLDxmlFileName = "";
  if( !SaveXmlFiles && AllowWebUpdates )
    if( xmlFileName != OLDxmlFileName &&  OLDxmlFileName != "" ) FileDelete( OLDxmlFileName );
  OLDxmlFileName = xmlFileName;


  return( tmpData );
}

//=================================================================================================
//=================================================================================================
//====================================   GrabWeb Functions   ======================================
//=================================================================================================
//=================================================================================================
// Main Webscraping function
// ~~~~~~~~~~~~~~~~~~~~~~~~~
// bool GrabWeb(string strUrl, string& strWebPage)
// returns the text of any webpage. Returns false on timeout or other error
//
// Parsing functions
// ~~~~~~~~~~~~~~~~~
// string GetData(string strWebPage, int nStart, string strLeftTag, string strRightTag, int& nPos)
// obtains the text between two tags found after nStart, and sets nPos to the end of the second tag
//
// void Goto(string strWebPage, int nStart, string strTag, int& nPos)
// Sets nPos to the end of the first tag found after nStart

bool bWinInetDebug = false;

int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig = 0;
int Internet_Open_Type_Direct = 1;
int Internet_Open_Type_Proxy = 3;
int Buffer_LEN = 80;

#import "wininet.dll"

#define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100 // Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy.
#define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000 // Does not add the returned entity to the cache. 
#define INTERNET_FLAG_RELOAD            0x80000000 // Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.

int InternetOpenA(
  string 	sAgent,
  int		lAccessType,
  string 	sProxyName = "",
  string 	sProxyBypass = "",
  int 	lFlags = 0
);

int InternetOpenUrlA(
  int 	hInternetSession,
  string 	sUrl,
  string 	sHeaders = "",
  int 	lHeadersLength = 0,
  int 	lFlags = 0,
  int 	lContext = 0
);

int InternetReadFile(
  int 	hFile,
  string 	sBuffer,
  int 	lNumBytesToRead,
  int& 	lNumberOfBytesRead[]
);

int InternetCloseHandle(
  int 	hInet
);
#import


int hSession( bool Direct )
{
  string InternetAgent;
  if ( hSession_IEType == 0 ) {
    InternetAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
    hSession_IEType = InternetOpenA( InternetAgent, Internet_Open_Type_Preconfig, "0", "0", 0 );
    hSession_Direct = InternetOpenA( InternetAgent, Internet_Open_Type_Direct, "0", "0", 0 );
  }
  if ( Direct ) {
    return( hSession_Direct );
  } else {
    return( hSession_IEType );
  }
}


bool GrabWeb( string strUrl, string& strWebPage )
{
  int 	hInternet;
  int		iResult;
  int 	lReturn[]	= {1};
  string 	sBuffer		= "                                                                                                                                                                                                                                                               ";	// 255 spaces
  int 	bytes;
  bWinInetDebug = EnableLogging;  //added by euclid
  hInternet = InternetOpenUrlA( hSession( FALSE ), strUrl, "0", 0,
                                INTERNET_FLAG_NO_CACHE_WRITE |
                                INTERNET_FLAG_PRAGMA_NOCACHE |
                                INTERNET_FLAG_RELOAD, 0 );

  if ( bWinInetDebug ) Log( "hInternet: " + hInternet );
  if ( hInternet == 0 ) return( false );

  if ( DebugLevel > 1 ) Log( "Reading URL: " + strUrl );	 //added by MN modified by euclid
  iResult = InternetReadFile( hInternet, sBuffer, Buffer_LEN, lReturn );

  if ( bWinInetDebug ) Log( "iResult: " + iResult );
  if ( bWinInetDebug ) Log( "lReturn: " + lReturn[0] );
  if ( bWinInetDebug ) Log( "iResult: " + iResult );
  if ( bWinInetDebug ) Log( "sBuffer: " +  sBuffer );
  if ( iResult == 0 )  return( false );
  bytes = lReturn[0];

  strWebPage = StringSubstr( sBuffer, 0, lReturn[0] );

  // If there's more data then keep reading it into the buffer
  while ( lReturn[0] != 0 ) {
    iResult = InternetReadFile( hInternet, sBuffer, Buffer_LEN, lReturn );
    if ( lReturn[0] == 0 )
      break;
    bytes = bytes + lReturn[0];
    strWebPage = strWebPage + StringSubstr( sBuffer, 0, lReturn[0] );
  }

  if ( DebugLevel > 1 ) Log( "Closing URL web connection" ); //added by MN modified by euclid
  iResult = InternetCloseHandle( hInternet );
  if ( iResult == 0 ) return( false );

  return( true );
}



//=================================================================================================
//=================================================================================================
//===================================   LogUtils Functions   ======================================
//=================================================================================================
//=================================================================================================

void OpenLog( string strName )
{
  if ( !EnableLogging ) return;

  if ( logHandle <= 0 ) {
    string strMonthPad = "";
    string strDayPad = "";
    if ( Month() < 10 ) strMonthPad = "0";
    if ( Day() < 10 )   strDayPad   = "0";

    string strFilename = StringConcatenate( strName, "_", Year(), strMonthPad, Month(), strDayPad, Day(), "_log.txt" );

    logHandle = FileOpen( strFilename, FILE_CSV | FILE_READ | FILE_WRITE );
    Print( "logHandle =================================== ", logHandle );
  }
  if ( logHandle > 0 ) {
    FileFlush( logHandle );
    FileSeek( logHandle, 0, SEEK_END );
  }
}


void Log( string msg )
{
  if ( !EnableLogging ) return;
  if ( logHandle <= 0 ) return;

  msg = TimeToStr( TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS ) + " " + msg;
  FileWrite( logHandle, msg );
}

//=================================================================================================
//=================================================================================================
//===================================   Timezone Functions   ======================================
//=================================================================================================
//=================================================================================================


#import "kernel32.dll"
int  GetTimeZoneInformation( int& TZInfoArray[] );
#import

#define TIME_ZONE_ID_UNKNOWN   0
#define TIME_ZONE_ID_STANDARD  1
#define TIME_ZONE_ID_DAYLIGHT  2

int TZInfoArray[43];

datetime TimeGMT()  //modified by euclid
{
  int ret = GetTimeZoneInformation( TZInfoArray );
  int bias = TZInfoArray[0];
  if ( ret == TIME_ZONE_ID_STANDARD ) bias += TZInfoArray[21];
  if ( ret == TIME_ZONE_ID_DAYLIGHT ) bias += TZInfoArray[42];
  return( TimeLocal() + bias * 60 );
}


//=================================================================================================
//=================================================================================================
//=================================   END IMPORTED FUNCTIONS  =====================================
//=================================================================================================
//=================================================================================================

int ParseXML( string sData )
{
  //Print("Parse XML");
  // Get the currency pair, and split it into the two countries
  string pair = Symbol();
  string cntry1 = StringSubstr( pair, 0, 3 );
  string cntry2 = StringSubstr( pair, 3, 3 );
  if ( DebugLevel > 0 ) Print( "cntry1 = ", cntry1, "    cntry2 = ", cntry2 );
  if ( DebugLevel > 0 ) Log( "Weekly calendar for " + pair + "\n\n" );

  // -------------------------------------------------
  // Parse the XML file looking for an event to report
  // -------------------------------------------------
  int newsIdx = 0;
  int BoEvent = 0;
  int begin, next, end;
  string PrevNewsTime = "";
  while ( newsIdx < EVENTMAX ) {
    BoEvent = StringFind( sData, "<event>", BoEvent );
    if ( BoEvent == -1 ) break;

    BoEvent += 7;
    next = StringFind( sData, "</event>", BoEvent );
    if ( next == -1 ) break;

    string myEvent = StringSubstr( sData, BoEvent, next - BoEvent );
    BoEvent = next;

    begin = 0;
    bool skip = false;
    for ( int i = 0; i < 7; i++ ) {
      mainData[newsIdx][i] = "";
      next = StringFind( myEvent, sTags[i], begin );

      // Within this event, if tag not found, then it must be missing; skip it
      if ( next == -1 )
        continue;
      else {
        // We must have found the sTag okay...
        begin = next + StringLen( sTags[i] );			// Advance past the start tag
        end = StringFind( myEvent, eTags[i], begin );	// Find start of end tag
        if ( end > begin && end != -1 ) {
          // Get data between start and end tag
          //mainData[newsIdx][i] = StringSubstr(myEvent, begin, end - begin);


          // Get data between start and end tag
          mainData[newsIdx][i] = StringSubstr( myEvent, begin, end - begin );
          //check for CDATA tag - added by euclid
          if ( StringSubstr( mainData[newsIdx][i], 0, 9 ) == "<![CDATA[" ) {
            mainData[newsIdx][i] = StringSubstr( mainData[newsIdx][i], 9, StringLen( mainData[newsIdx][i] ) - 12 );
          }
          if ( StringSubstr( mainData[newsIdx][i], 0, 4 ) == "&lt;" ) {
            mainData[newsIdx][i] = "<" + StringSubstr( mainData[newsIdx][i], 4 );
          }
          if ( StringSubstr( mainData[newsIdx][i], 0, 4 ) == "&gt;" ) {
            mainData[newsIdx][i] = ">" + StringSubstr( mainData[newsIdx][i], 4 );
          }

          //also needs to check for HTML entities here... (euclid)
        }
      }
    }

//		for (i=6; i >= 0; i--)
//			Print(sTags[i], "  =  ", mainData[newsIdx][i]);
//Print(sTags[0], "  =  ", mainData[newsIdx][0]," ",newsIdx);

    // = - =   = - =   = - =   = - =   = - =   = - =   = - =   = - =   = - =   = - =
    // Test against filters that define whether we want to
    // skip this particular annoucement
    if ( cntry1 != mainData[newsIdx][COUNTRY] && cntry2 != mainData[newsIdx][COUNTRY] &&
         ( !ReportAllPairs ) )
      skip = true;

    if ( !IncludeHigh && mainData[newsIdx][IMPACT]   == "High" )   skip = true;
    if ( !IncludeMedium && mainData[newsIdx][IMPACT] == "Medium" ) skip = true;
    if ( !IncludeLow && mainData[newsIdx][IMPACT]    == "Low" )    skip = true;
    if ( mainData[newsIdx][IMPACT] == "Holiday" )                  skip = true;

    if ( !IncludeSpeaks && ( StringFind( mainData[newsIdx][TITLE], "speaks" ) != -1 ||
                             StringFind( mainData[newsIdx][TITLE], "Speaks" ) != -1 ) )
      skip = true;
    if ( mainData[newsIdx][TIME] == "All Day" ||
         mainData[newsIdx][TIME] == "Tentative" ||
         mainData[newsIdx][TIME] == "" )
      skip = true;


    if( SkipSameTimeNews && PrevNewsTime == mainData[newsIdx][DATE] + mainData[newsIdx][TIME] )
      skip = true;

    PrevNewsTime = mainData[newsIdx][DATE] + mainData[newsIdx][TIME];

    // = - =   = - =   = - =   = - =   = - =   = - =   = - =   = - =   = - =   = - =

    // If not skipping this event, then log it into the draw buffers
    if ( !skip ) {
      mainDataGMT[newsIdx] = StrToTime( MakeDateTime( mainData[newsIdx][DATE], mainData[newsIdx][TIME] ) );
      Log( "Weekly calendar for " + pair + "\n\n" );
      if ( DebugLevel > 0 ) {
        Log( "FOREX FACTORY\nTitle: " + mainData[newsIdx][TITLE] +
             "\nCountry: " + mainData[newsIdx][COUNTRY] +
             "\nDate: " + mainData[newsIdx][DATE] +
             "\nTime: " + mainData[newsIdx][TIME] +
             "\nImpact: " + mainData[newsIdx][IMPACT] +
             "\nForecast: " + mainData[newsIdx][FORECAST] +
             "\nPrevious: " + mainData[newsIdx][PREVIOUS] + "\n\n" );
      }
      newsIdx++;
    } else {
      // delete skipped data.
      mainData[newsIdx][TITLE] = "";
    }
  }//while

  return( newsIdx );
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// These code was  added for DailyFX.com.
//=================================================================================================
int DownloadCSVFile()
{
  string tmpData;
  string file = GetFileName( TimeLocal() );
  string sUrl = "http://www.dailyfx.com/files/" + file;
  GrabWeb( sUrl, tmpData ); // Get HTTP Data..


  int Handle = FileOpen( file, FILE_BIN | FILE_WRITE );
  if ( Handle < 0 ) {
    Print( "Can\'t open new  file, the last error is ", GetLastError() );
    return( -2 );
  }

  FileWriteString( Handle, tmpData, StringLen( tmpData ) );
  FileClose( Handle );

  if( StringSubstr( tmpData, 0, 20 ) != "Date,Time,Time Zone," ) {
    Print( "[" + StringSubstr( tmpData, 0, 20 ) + "]" );
    tmpData = "";
    return( -1 );
  } else {
    return( 0 );
  }
}

//=================================================================================================
string GetFileName( datetime tm )
{
  tm = tm - TimeDayOfWeek( tm ) * 24 * 60 * 60;
  string day = TimeDay( tm );
  string month = TimeMonth( tm );
  string year = TimeYear( tm );

  if( StringLen( day ) == 1 ) day = "0" + day;
  if( StringLen( month ) == 1 ) month = "0" + month;
  return( "Calendar-" + month + "-" + day + "-" + year + ".csv" );

}
//=================================================================================================
int ParseCSV()
{
  datetime CurrentGMT = TimeGMT();
  string file = GetFileName( TimeLocal() );
  int handle = FileOpen( file, FILE_CSV | FILE_READ, "," );
  if ( handle < 0 ) {
    Print( "Can\'t open ", file, ".. the last error is ", GetLastError() );
    return( 0 );
  }
  int i = 0;
  string dmy;
  // skip first line.
  mainData[i][DATE]     = FileReadString( handle );
  mainData[i][TIME]     = FileReadString( handle );
  dmy                   = FileReadString( handle );
  mainData[i][COUNTRY]  = FileReadString( handle );
  mainData[i][TITLE]    = FileReadString( handle );
  mainData[i][IMPACT]   = FileReadString( handle );
  dmy                   = FileReadString( handle );
  mainData[i][FORECAST] = FileReadString( handle );
  mainData[i][PREVIOUS] = FileReadString( handle );

  i = 0;
  while( !FileIsEnding( handle ) ) {
    //Date	Time	TimeZone	Currency	Event	Importance	Actual	Forecast	Previous

    mainData[i][DATE]     = FileReadString( handle );
    mainData[i][TIME]     = FileReadString( handle );
    dmy                   = FileReadString( handle );
    mainData[i][COUNTRY]  = toUpper( FileReadString( handle ) );
    mainData[i][TITLE]    = DelSymbolHeader( FileReadString( handle ) );
    mainData[i][IMPACT]   = FileReadString( handle );
    dmy                   = FileReadString( handle );
    mainData[i][FORECAST] = FileReadString( handle );
    mainData[i][PREVIOUS] = FileReadString( handle );

    string DateArray[3];
    Explode( mainData[i][DATE], " ", DateArray );
    string t = StringConcatenate( TimeYear( CurrentGMT ), ".", ConvMonth( DateArray[1] ), ".", DateArray[2], " ", mainData[i][TIME] );
    mainDataGMT[i] = StrToTime( t );


    if( StringLen( mainData[i][TITLE] ) > 0 ) i++;
  }
  FileClose( handle );
  return( i );
}
//=================================================================================================
string DelSymbolHeader( string m )
{
  string Sym[] = {"AUD ", "JPY ", "NZD ", "CHF ", "USD ", "EUR ", "GBP ", "CAD ", "CNY "};
  for( int i = 0; i < ArraySize( Sym ); i++ ) {
    if ( StringSubstr( m, 0, 4 ) == Sym[i] ) {
      m = StringSubstr( m, 4 );
      return( m );
    }
  }
  return( m );
}
//=================================================================================================
int ConvMonth( string m )
{
  int mon = 0;
  string Mon[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
  for( int i = 0; i < ArraySize( Mon ); i++ )
    if( m == Mon[i] ) return( i + 1 );

}
//=================================================================================================
string toUpper( string s )
{
  int n = StringLen( s );
  for ( int i = 0; i < n; i++ ) {
    int c = StringGetChar( s, i );
    if ( c >= 'a' && c <= 'z' ) {
      c += 'A' - 'a';
      s = StringSetChar( s, i, c );
    }
  }

  return( s );
}
//=================================================================================================
int Explode( string str, string delimiter, string& arr[] )
{
  int i = 0;
  int pos = StringFind( str, delimiter );
  while( pos != -1 ) {
    if( pos == 0 ) arr[i] = "";
    else arr[i] = StringSubstr( str, 0, pos );
    i++;
    str = StringSubstr( str, pos + StringLen( delimiter ) );
    pos = StringFind( str, delimiter );
    if( pos == -1 || str == "" ) break;
  }
  arr[i] = str;

  return( i + 1 );
}
//=================================================================================================