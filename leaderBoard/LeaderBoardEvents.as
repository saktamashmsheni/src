package leaderBoard
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LeaderBoardEvents extends Event
	{
		// event constants
		public static const TIMER_EVENT:String = "timerEvent";
		
		public var params:Object;
		
		
		public function LeaderBoardEvents(type:String, $params:Object = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			
			this.params = $params;
		}
		
		public function get reParams():Boolean  { return params; }
	}

}