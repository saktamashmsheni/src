package 
{
	import com.Rijndael.util.Hex;
	import connection.ConnectionManager;
	import flash.globalization.NumberParseResult;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class Root 
	{
		public static var ip:String = "5.10.35.195";
		public static var port:Number = 5003;
		
		public static var TESTING:Boolean = true;
		
		public static var Key:ByteArray = Hex.toArray(Hex.fromString(CONFIG::KEY));
		public static var Key1:ByteArray = Hex.toArray(Hex.fromString(CONFIG::KEY));
		
		
		static public var soundLibrary:*;
		
		
		static public var ALL_WILD_INDEX:int = 20;
		
		
		
		public static var betsArray:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 25, 50, 75, 100];
		
		public static var prizesAr:Array = [2000, 1600, 1200, 900, 600, 500, 400, 300, 200, 160, 100, 100, 100, 100, 100, 80, 80, 80, 80, 80, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 20, 20, 20, 20, 20, 20, 20, 20];
			
		
		public static var userIdentifire:int;
		public static var lang:String = "en";
		
		public static var name:String = "Jigsaw";
		public static var avatar:String = "";
		
		public static var userChips:Number;
		
		
		public static var token:Number = 3;
		
		
		
		public static var balance:Number;
		
				
		public static var connectionManager:ConnectionManager = new ConnectionManager();
		
		public static var soundManager:SoundManager = new SoundManager();
		
		
		public static var reconProcess:Boolean = false;
		
		
		///rooom
		//public static var userRoomId:Number =  -Math.ceil(Math.random()*9999);
		public static var userRoomId:Number = -3285;
		public static var userRoomSession:String = "";
		
		public static function connectToServer():void
		{
			//Root.connectionManager.connect("5.10.35.246", 8888);
			Root.connectionManager.connect(ip, port);
		}
		
		
		
		public static var leaderInd:int = 0;
		public static var leaderAr:Array = [{"Position":5, "Users":[[1, "ng_gamble", 410500], [2, "gfhh", 110323], [3, "chitalTest", 56609], [4, "nikagg", 40220], [5, "adjaratest3", 22495], [6, "test60", 16005], [7, "asrew", 4187], [8, "gfsgfs", 2125], [9, "fsdghdh", 1385]]},
											{"Position":5, "Users":[[2, "ng_gamble", 410500], [1, "joraaaa", 999999999], [3, "chitalTest", 56609], [4, "nikagg", 40220], [5, "adjaratest3", 22495], [6, "test60", 16005], [7, "asrew", 4187], [8, "gfsgfs", 2125], [9, "fsdghdh", 1385]]},
											{"Position":5, "Users":[[3, "ng_gamble", 410500], [2, "joraaaa", 999999999], [1, "ablabuda", 999999999], [4, "12f1f", 40220], [5, "nikagg", 40220], [6, "adjaratest3", 22495], [7, "test60", 16005], [8, "asrew", 4187], [9, "gfsgfs", 2125], [10, "fsdghdh", 1385], [11, "CHITALAAA", 1385]]},
											{"Position":5, "Users":[[2, "45612", 410500], [11, "joraaaa", 999999999], [5, "465165", 999999999], [4, "12f1f", 40220], [3, "nikagg", 40220], [6, "adjaratest3", 22495], [7, "test60", 16005], [8, "asrew", 4187], [9, "gfsgfs", 2125], [10, "fsdghdh", 1385], [1, "CHITALAAA", 1385]]}
											];
	}

}