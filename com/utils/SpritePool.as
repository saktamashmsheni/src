package com.utils
{
	import starling.display.DisplayObject;
	import starling.utils.deg2rad;
	

	public class SpritePool
	{
		private var pool:Array;
		private var counter:int;
		private var type:Class;
		
		public function SpritePool(type:Class, len:int)
		{
			this.type = type;
			pool = new Array();
			counter = len;
			
			var i:int = len;
			while(--i > -1)
				pool[i] = new type();
				
		}
		
		public function getSprite():DisplayObject
		{
			if (counter > 0)
			{
				//trace(counter);
				return pool[--counter];
			}
			else
				throw new Error("You exhausted the pool!");
				
			
		}
		
		public function returnSprite(s:DisplayObject):void
		{
			pool[counter++] = s;
			//trace(counter);
		}
	}
}