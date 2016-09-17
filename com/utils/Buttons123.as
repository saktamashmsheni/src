package com.utils 
{
	/**
	 * ...
	 * @author ...
	 */
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import src.Root;
	
	
	 
	public class Buttons123 extends MovieClip
	{
		public var mov:MovieClip;
		
		public function Buttons123(mc:MovieClip = null, mouseChildren:Boolean = false) 
		{
			if (mc != null)
			{
				mov = mc;
				mc.gotoAndStop(1);
			}
			else
			{
				mov = this;
			}
			
			stop();
			mov.mouseChildren = mouseChildren;
			mov.buttonMode = true;
			mov.addEventListener(MouseEvent.MOUSE_OVER, onButOver);
			mov.addEventListener(MouseEvent.MOUSE_OUT, onButOut);
			mov.addEventListener(MouseEvent.MOUSE_DOWN, onButMouseDown);
			mov.addEventListener(MouseEvent.MOUSE_UP, onButOver);
		}
		
		
		//on over
		private function onButOver(e:MouseEvent):void 
		{
			mov.gotoAndStop(2);
		}
		
		//on out
		private function onButOut(e:MouseEvent):void 
		{
			mov.gotoAndStop(1);
		}
		
		
		//on click
		private function onButMouseDown(e:MouseEvent):void 
		{
			mov.gotoAndStop(3);
			Root.soundManager.PlaySound("options_click");
		}
		
		public function removeOverListener():void
		{
			mov.buttonMode = false;
			mov.removeEventListener(MouseEvent.MOUSE_OVER, onButOver);
			mov.removeEventListener(MouseEvent.MOUSE_OUT, onButOut);
			mov.removeEventListener(MouseEvent.MOUSE_DOWN, onButMouseDown);
			mov.removeEventListener(MouseEvent.MOUSE_UP, onButOver);
		}
		
		public function addOverListener():void
		{
			mov.gotoAndStop(1);
			mov.buttonMode = true;
			mov.addEventListener(MouseEvent.MOUSE_OVER, onButOver);
			mov.addEventListener(MouseEvent.MOUSE_OUT, onButOut);
			mov.addEventListener(MouseEvent.MOUSE_DOWN, onButMouseDown);
			mov.addEventListener(MouseEvent.MOUSE_UP, onButOver);
		}
	}

}