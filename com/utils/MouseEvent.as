package com.utils 
{
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class MouseEvent extends Event
	{
		
		public static const CLICK:String = "click";
		public static const MOUSE_DOWN:String = "mouseDown";
		public static const MOUSE_OVER:String = "mouseOver";
		public static const MOUSE_OUT:String = "mouseOut";
		public static const MOUSE_MOVE:String = "mouseMove";
		
		
		public var params:Object;
		
		public function MouseEvent(type:String, $params:Object = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			
			this.params = $params;
		}
		
		public function get reParams():Boolean  { return params; }
		
	}

}