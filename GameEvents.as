package
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameEvents extends Event
	{
		// event constants
		public static const LINE_CHANGED:String = "lineChanged";
		public static const SPIN_STARTED:String = "startSpin";
		public static const SPIN_COMPLETE:String = "spinComplete";
		public static const FREE_SPINS_START:String = "freeSpinsStart";
		public static const FREE_SPINS_END:String = "freeSpinsEnd";
		public static const BONUS_FINISHED:String = "bonusFinished";
		public static const TRANFER_FINISHED:String = "transferFinished";
		static public const CONNECTED:String = "connected";
		static public const CREDIT_CHANGED:String = "creditChanged";
		static public const ALL_ASSETS_LOADED:String = "allAssetsLoaded";
		static public const CUR_ASSET_LOADED:String = "curAssetLoaded";
		static public const CUR_ASSET_PROGRESS_INFO:String = "curAssetProgressInfo";
		static public const SOUND_CHANGED:String = "soundChanged";
		static public const SEND_PROGRESS_TO_PRELOADER:String = "sendProgressToPreloader";
		
		public var params:Object;
		
		
		public function GameEvents(type:String, $params:Object = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			
			this.params = $params;
		}
		
		public function get reParams():Boolean  { return params; }
	}

}