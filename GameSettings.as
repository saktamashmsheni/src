package 
{
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class GameSettings 
	{
		
		public static var GAME_ID:int;
		public static var GAME_NAME:String = "20 slice fruit";
		public static var PATH:String = GAME_NAME + "/"; // saxeli da path meqneba albat shesacvleli dinamiuri ro iyos
		
		public static var SYS_NUM:int = 0;
		public static var PAYTABLE_AR:Array = [];
		
		public static var BALANCE:Number;
		
		public static var GAME_XML:XML;
		
		public static var TOTAL_LINES:int;
		public static var ACT_LINES:int;
		public static var LINES_FIXED:Boolean;
		public static var LINES_VISIBILITY:Boolean;
		public static var LINES_COUNT_CONFIG:Array;
		
		public static var BET_INDEX:int;
		public static var TOTAL_BET:int;
		public static var BETS_AR:Array;
		
		public static var TOTAL_ICONS:int;
		
		public static var SCATTERS_AR:Array;
		public static var WILDS_AR:Array;
		public static var BONUSES_AR:Array;
		
		
		public static var CREDIT_AR:Array = [1, 2, 5, 10];;
		public static var CREDIT_INDEX:int;
		public static var CREDIT_VAL:int = 1;
		
		public static var Currency_ID:int;
		public static var Currency_Rate:Number;
		public static var Currency_Values:Array = [ { name:"GEL", order:2 }, { name:"USD", order:3 },  { name:"EUR", order:4 },  { name:"GBP", order:5 },  { name:"RUB", order:6 },  { name:"UAH", order:7 } ];
		
		
		public static var SOUND_ENABLED:Boolean = true;
		
		public static var IS_JACKPOT_ON:Boolean;
		
		
		public static var REEL_TYPE:Array = [[3, 3], [5, 3], [5, 4]];
		public static var MASHINE_OPTIONS:Array = [{xDist:154, yDist:145},
												   {xDist:154, yDist:145},
												   {xDist:154, yDist:120 } ]
												  
		public static const ICONS_SIZE:Vector.<Array> = new <Array>[[120,120],[120,120],[120,120]];
		public static const ICONSFRAME_SIZE:Vector.<Array> = new <Array>[[130,130],[130,130],[120,120]];
												   
		
		//machine and icon settings
		
		public static var HOVER_ANIM_ENABLED:Boolean = true;
		public static var HOVER_ANIM_LOOP:Boolean = false;
												   
		
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