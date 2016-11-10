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
		public static var port:Number = 5007;
		
		public static var TESTING:Boolean = true;
		
		public static var Key:ByteArray = Hex.toArray(Hex.fromString(CONFIG::KEY));
		public static var Key1:ByteArray = Hex.toArray(Hex.fromString(CONFIG::KEY));
		
		
		static public var soundLibrary:*;
		
		public static var prizesAr:Array = [2000, 1600, 1200, 900, 600, 500, 400, 300, 200, 160, 100, 100, 100, 100, 100, 80, 80, 80, 80, 80, 60, 60, 60, 60, 60, 60, 60, 60, 60, 60, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 20, 20, 20, 20, 20, 20, 20, 20];
		
		public static var userIdentifire:int;
		public static var lang:String = "en";
		
		public static var name:String = "Jigsaw";
		public static var avatar:String = "";
		
		public static var userChips:Number;
		
		public static var token:Number = 3;
		
		public static var connectionManager:ConnectionManager = new ConnectionManager();
		
		public static var soundManager:SoundManager = new SoundManager();
		
		public static var reconProcess:Boolean = false;
		
		///rooom
		//public static var userRoomId:Number =  -Math.ceil(Math.random()*9999);
		public static var userRoomId:Number = -3291;
		public static var userRoomSession:String = "";
		
		public static function connectToServer():void
		{
			//Root.connectionManager.connect("5.10.35.246", 8888);
			Root.connectionManager.connect(ip, port);
		}
		
		
	}

}