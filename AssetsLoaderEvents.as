package
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AssetsLoaderEvents extends Event
	{
		// event constants
		static public const ALL_ASSETS_LOADED:String = "allAssetsLoaded";
		static public const CUR_ASSET_LOADED:String = "curAssetLoaded";
		static public const CUR_ASSET_PROGRESS_INFO:String = "curAssetProgressInfo";
		static public const SEND_PROGRESS_TO_PRELOADER:String = "sendProgressToPreloader";
		
		public var params:Object;
		
		
		public function AssetsLoaderEvents($type:String, $params:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			
			this.params = $params;
		}
		
		public override function clone():Event
		{
			return new AssetsLoaderEvents(type, this.params, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("CustomEvent", "params", "type", "bubbles", "cancelable");
		}
	}

}