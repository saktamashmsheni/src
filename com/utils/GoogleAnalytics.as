package com.utils {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import libraries.uanalytics.tracker.AppTracker;
	import libraries.uanalytics.tracking.Configuration;
	import libraries.uanalytics.tracking.Tracker;
	
	
	
	public class GoogleAnalytics extends EventDispatcher {
		
		public static var GOOGLE_ANALYTICS_ID:String = 'UA-77948274-1';
		private static const APP_INSTALLER_ID:String = 'Betsense.ge';
		private static const APP_VERSION:String = '1.0';
		private static const APP_ID:String = 'ge.betsense.sliseSlots';
		
		private static const APP_NAME:String = 'SLICE SLOTS';
		
		private static var $tracker:AppTracker; 
		
		public static function _sendScreenView(screen:String = ""):void {
			
			if (!$tracker){
				$tracker = getTracker();
			}

			$tracker.screenview(screen);
		}
		
		public static function _sendActionEvent(category:String= "", actionEvent:String = "", label = ""):void {
			if (!$tracker){
				$tracker = getTracker();
			}
			
			$tracker.setOneTime( Tracker.EVENT_ACTION, "1" );
			$tracker.event(category, actionEvent, label);
		}
		
		
		private static function getTracker():AppTracker{
			
			var trackingID:String = GoogleAnalytics.GOOGLE_ANALYTICS_ID;
			var config:Configuration = new Configuration();
			config.forcePOST = true;
			
			var tracker:AppTracker = new AppTracker(trackingID, config);
			var gameinfo:Dictionary = new Dictionary();
			gameinfo[ Tracker.APP_NAME ] = APP_NAME;
			gameinfo[ Tracker.APP_ID ] = APP_ID;
			gameinfo[ Tracker.APP_VERSION ] = APP_VERSION;
			gameinfo[ Tracker.APP_INSTALLER_ID ] = APP_INSTALLER_ID;

			tracker.add( gameinfo );
			return tracker;
		}
	}
}