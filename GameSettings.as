package 
{
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class GameSettings 
	{
		public static var CONFIG_JSON:Object;
		
		public static var GAME_ID:int;
		public static var GAME_NAME:String = "";
		public static var PATH:String;
		
		public static var GAMES_AND_PORTS:Array = [["frozen fruits", 8801], 
												   ["40 slice fruit", 8802], 
												   ["20 slice fruit", 8803], 
												   ["dragon fruit", 8804],
												   ["star fruit", 8805]
												   ];
		
		public static var MULTIPLE_WINS:Boolean;
		
		
		
		public static var WINNER_LINE_START_AND_DELAY:Number;
		public static var ANIMATE_LINE_DELAY:Number;
		
		
		public static var PREFERENCES:Object;
		
		public static var SYS_NUM:int = 0;
		public static var PAYTABLE_AR:Array = [];
		public static var PAYTABLE_TOTAL_PAGES:int;
		public static var POSITIONS_AR:Array;
		public static var PAYTABLE_SHEKVECA:Boolean;
		
		public static var BALANCE:Number;
		
		public static var GAME_XML:XML;
		
		public static var TOTAL_LINES:int;
		public static var ACT_LINES:int;
		public static var LINES_FIXED:Boolean;
		public static var LINES_VISIBILITY:Boolean;
		public static var LINES_COUNT_CONFIG:Array;
		
		public static var ALL_ICONS_OFFSET_X:int;
		public static var ALL_ICONS_OFFSET_Y:int;
		public static var FRAMES_OFFSET_X:int;
		public static var FRAMES_OFFSET_Y:int;
		public static var LINEMAST_OFFSET_X:int;
		public static var LINEMAST_OFFSET_Y:int;
		
		public static var BET_INDEX:int;
		public static var TOTAL_BET:int;
		public static var BETS_AR:Array;
		
		public static var TOTAL_ICONS:int;
		public static var ICONS_OFF_Y:int;
		public static var ICONS_OFF_X:int;
		
		public static var SCATTERS_AR:Array;
		public static var WILDS_AR:Array;
		public static var BONUSES_AR:Array;
		
		
		public static var CREDIT_AR:Array = [1, 2, 5, 10];;
		public static var CREDIT_INDEX:int;
		public static var CREDIT_VAL:int = 1;
		
		public static var Currency_ID:int;
		public static var Currency_Rate:Number;
		public static var Currency_Values:Array = [ { name:"GEL", order:2, shortCut:"l"}, { name:"USD", order:3, shortCut:"d"},  { name:"EUR", order:4, shortCut:"e"},  { name:"GBP", order:5, shortCut:"f"},  { name:"RUB", order:6, shortCut:"r"},  { name:"UAH", order:7, shortCut:"u"} ,  { name:"AMD", order:8, shortCut:"a"} ];
		
		
		public static var SOUND_ENABLED:Boolean = true;
		
		public static var IS_JACKPOT_ON:Boolean;
		
		
		public static const REEL_TYPE:Array = [[3, 3], [5, 3], [5, 4]];
		public static const MASHINE_OPTIONS:Array = [{xDist:154, yDist:145},
													 {xDist:154, yDist:145},
												     {xDist:155, yDist:108 } ]
												   
												   
		public static const ICON_HOLDER_POS:Vector.<Array> = new <Array>[[-34,40],[-43,40],[-34,20]];
		
		public static const ICONS_SIZE:Vector.<Array> = new <Array>[[120,120],[135,135],[125,123]];
		public static var SCALE_ICONS:Number;
		
		
		public static const ICONSFRAME_SIZE:Vector.<Array> = new <Array>[[130,130],[130,135],[125,105]];
		public static const LINEMASK_LOOP:Vector.<uint> = new <uint>[9,15,20];
		public static const LINEMASK_STEPPER:Vector.<uint> = new <uint>[3,5,5];
		public static const LINEMASK_STEP_X_Y:Vector.<Array> = new <Array>[[154,145],[154,145],[154,105]];
		
		public static const ICONSFRAME_VERT_HELPER_LOOP:Vector.<uint> = new <uint>[2,4,4];
		public static const ICONSFRAME_VERT_HELPER_SIZE:Vector.<Array> = new <Array>[[24, 420],[24, 420],[24, 415]];
		public static const ICONSFRAME_VERT_HELPER_STEP_X:Vector.<uint> = new <uint>[154,154,154];
		public static const ICONSFRAME_VERT_HELPER_OFFSET:Vector.<uint> = new <uint>[130,130,130];
		
		public static const ICONSFRAME_HORIZ_HELPER_LOOP:Vector.<uint> = new <uint>[2,2,3];
		public static const ICONSFRAME_HORIZ_HELPER_SIZE:Vector.<Array> = new <Array>[[746, 16],[746, 16],[746, 5]];
		public static const ICONSFRAME_HORIZ_HELPER_STEP_Y:Vector.<uint> = new <uint>[145,145,105];
		public static const ICONSFRAME_HORIZ_HELPER_OFFSET:Vector.<uint> = new <uint>[130,130,100];
		
		public static const LINES_WIN_COORDS:Vector.<Array> = new <Array>[[[60,215,368,522,675], [60, 205, 350]],[[60,215,368,522,675], [60, 205, 350]],[[60,215,368,522,675], [60, 205, 350]]];
												   
		
		//machine and icon settings
		public static var HIDE_ICON:Boolean = true;
		public static var ICON_ANIM_ENABLED:Boolean = true;
		public static var ICON_ANIM_LOOP:Boolean = false;
		public static var ICON_ANIM_DELAY:Number = 1;
		public static var ICON_ANIM_FAST_REMOVE:Number;
		
		public static var HOVER_ANIM_ENABLED:Boolean = true;
		public static var HOVER_ANIM_LOOP:Boolean = false;
		public static var HOVER_FAST_REMOVE:Boolean;
		
	    public static var STATIC_ANIM_ENABLED:Boolean = true;
		public static var STATIC_ANIM_LOOP:Boolean = true;
		public static var STATIC_FAST_REMOVE:Boolean = true;
		
		public static var WILD_ANIM_ENABLED:Boolean;
		public static var WILD_ANIM_LOOP:Boolean;
		public static var WILD_HOVER_ENABLED:Boolean;
		public static var WILD_HOVER_LOOP:Boolean;
		
		
		
		
		public static var LINES_AR:Array = [
		
											[
												[2, 2, 2],
												[1, 1, 1],
												[3, 3, 3],
												[1, 2, 3],
												[3, 2, 1],
											],
		
											[ 
												 [2, 2, 2, 2, 2], //1
												 [1, 1, 1, 1, 1], //2
												 [3, 3, 3, 3, 3], //3
												 [1, 2, 3, 2, 1], //4
												 [3, 2, 1, 2, 3], //5
												 [1, 1, 2, 3, 3], //6
												 [3, 3, 2, 1, 1], //7
												 [2, 3, 3, 3, 2], //8
												 [2, 1, 1, 1, 2], //9
												 [1, 2, 2, 2, 1], //10
												 [3, 2, 2, 2, 3], //11
												 [2, 3, 2, 1, 2], //12
												 [2, 1, 2, 3, 2], //13
												 [1, 2, 1, 2, 1], //14
												 [3, 2, 3, 2, 3], //15
												 [2, 2, 3, 2, 2], //16
												 [2, 2, 1, 2, 2], //17
												 [1, 3, 1, 3, 1], //18
												 [3, 1, 3, 1, 3], //19
												 [2, 1, 3, 1, 2], 
												 [2, 3, 1, 3, 2], 
												 [1, 1, 3, 1, 1], 
												 [3, 3, 1, 3, 3], 
												 [1, 3, 3, 3, 1], 
												 [3, 1, 1, 1, 3], 
												 [1, 1, 2, 1, 1], 
												 [3, 3, 2, 3, 3], 
												 [1, 3, 2, 3, 1], 
												 [3, 1, 2, 1, 3], 
												 [2, 3, 2, 3, 2] 
											 ],
											 
											 [
												[2, 2, 2, 2, 2],
												[3, 3, 3, 3, 3],
												[1, 1, 1, 1, 1],
												[4, 4, 4, 4, 4],
												[2, 3, 4, 3, 2],
												[3, 2, 1, 2, 3],
												[1, 1, 2, 3, 4],
												[4, 4, 3, 2, 1],
												[3, 4, 4, 4, 3],
												[2, 1, 1, 1, 2],
												[1, 2, 3, 4, 4],
												[4, 3, 2, 1, 1],
												[3, 4, 3, 2, 3],
												[2, 1, 2, 3, 2],
												[1, 2, 1, 2, 1],
												[4, 3, 4, 3, 4],
												[2, 3, 2, 1, 2],
												[3, 2, 3, 4, 3],
												[1, 2, 2, 2, 1],
												[4, 3, 3, 3, 4],
												[2, 2, 3, 4, 4],
												[3, 3, 2, 1, 1],
												[1, 2, 3, 3, 4],
												[4, 3, 2, 2, 1],
												[2, 3, 3, 3, 4],
												[3, 2, 2, 2, 1],
												[1, 1, 2, 1, 1],
												[4, 4, 3, 4, 4],
												[3, 3, 4, 3, 3],
												[2, 2, 1, 2, 2],
												[1, 1, 1, 2, 3],
												[4, 4, 4, 3, 2],
												[3, 4, 4, 3, 2],
												[2, 1, 1, 2, 3],
												[1, 2, 2, 3, 4],
												[4, 3, 3, 2, 1],
												[3, 4, 3, 2, 1],
												[2, 1, 2, 3, 4],
												[1, 2, 3, 4, 3],
												[4, 3, 2, 1, 2]
											 ],
											 
											 [
												[1, 1, 1],
												[1, 1, 2],
												[1, 1, 3],
												[1, 2, 1],
												[1, 2, 2],
												[1, 2, 3],
												[1, 3, 1],
												[1, 3, 2],
												[1, 3, 3],
												[2, 1, 1],
												[2, 1, 2],
												[2, 1, 3],
												[2, 2, 1],
												[2, 2, 2],
												[2, 2, 3],
												[2, 3, 1],
												[2, 3, 2],
												[2, 3, 3],
												[3, 1, 1],
												[3, 1, 2],
												[3, 1, 3],
												[3, 2, 1],
												[3, 2, 2],
												[3, 2, 3],
												[3, 3, 1],
												[3, 3, 2],
												[3, 3, 3],
											 ]
		];
	}

}