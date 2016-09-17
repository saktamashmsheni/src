package com.utils {
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MyButton extends Sprite {
		private var _buttonMode:Boolean;
		private var _mouseEnabled:Boolean;
		private var textures:Vector.<Texture>;
		private var btnMc:MovieClip;
		private static var OVER_MODE:int = 0;
		private static var OUT_MODE:int = 1;
		private static var DOWN_MODE:int = 2;
		private static var CLICK_MODE:int = 3;
		private var touchMode:int = OUT_MODE;
		private var _hoverEnabled:Boolean;
		private var alighn:String;
		public var val_txt:*;
		public var opt:Object = {};
		
		public var DEFAULT_SOUND:String = "options_click";
		public var mouseX:Number;
		public var mouseY:Number;
		
		public function MyButton(textures:Vector.<Texture>, alighn:String = "TL") {
			_updateTexture(textures, alighn);
		}
		
		public function _updateTexture(textures:Vector.<Texture>, alighn:String = "TL", clearAssets:Boolean = false):void {
			
			if (clearAssets) {
				this.textures = null;
				btnMc.dispose();
				if (this.contains(btnMc)) {
					btnMc.dispose();
					removeChild(btnMc);
					btnMc = null;
				}
			}
			
			this.alighn = alighn;
			this.textures = textures;
			if (textures != null) {
				btnMc = new MovieClip(textures, 1);
				
				switch (alighn) {
					case "TL": 
						btnMc.x = 0;
						btnMc.y = 0;
						break;
					case "TC": 
						btnMc.x = -btnMc.width / 2;
						btnMc.y = 0;
						break;
					case "CC": 
						btnMc.x = -btnMc.width / 2;
						btnMc.y = -btnMc.height / 2;
						break;
					case "BC": 
						btnMc.x = -btnMc.width / 2;
						btnMc.y = -btnMc.height;
						break;
					case "TC": 
						btnMc.x = -btnMc.width / 2;
						btnMc.y = 0;
						break;
				}
				addChild(btnMc);
			}
			
			buttonMode = true;
			mouseEnabled = true;
			hoverEnabled = true;
		}
		
		
		public function setHover(disp:*, opacity:Number = 0):void
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				this.getChildAt(i).touchable = false;
			}
			addChild(disp);
			disp.alpha = opacity;
		}
		
		private function onButtonTouch(e:TouchEvent):void {
			
			//var location:Point;
			
			var endTouch:Touch = e.getTouch(this, TouchPhase.ENDED);
			var overTouch:Touch = e.getTouch(this, TouchPhase.HOVER);
			var downTouch:Touch = e.getTouch(this, TouchPhase.BEGAN);
			
			
			/*//if (overTouch != null && this.hitTest(this.globalToLocal(new Point(endTouch.globalX, endTouch.globalY))))
			//{
				for each (var touch:Touch in overTouch)
				{
					if (touch.phase == TouchPhase.HOVER ){
						var location:Point = touch.getLocation(this);
						mouseX = location.x;
						mouseY = location.y;
					}
				}
			//}*/
			
			
			
			if (endTouch != null && this.hitTest(this.globalToLocal(new Point(endTouch.globalX, endTouch.globalY)))) {
				touchMode = CLICK_MODE;
				dispatchEvent(new MouseEvent(MouseEvent.CLICK, {target: e.target, currentTarget: e.currentTarget}));
				Root.soundManager.PlaySound(this.DEFAULT_SOUND);
				
			} else if (downTouch != null && this.hitTest(this.globalToLocal(new Point(downTouch.globalX, downTouch.globalY)))) {
				touchMode = DOWN_MODE;
				// location = downTouch.getLocation(this);
				//mouseX = location.x;
				//mouseY = location.y;
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, {target: e.target, currentTarget: e.currentTarget/*, This:this*/}));
				
				if (!hoverEnabled)
					return;
				if (btnMc != null && btnMc.numFrames > 2)
					btnMc.currentFrame = 2;
				else if (btnMc != null)
					btnMc.currentFrame = 0;
					
			} else if (overTouch != null && touchMode != OVER_MODE) {
				touchMode = OVER_MODE;
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, {target: e.target, currentTarget: e.currentTarget}));
				
				if (!hoverEnabled)
					return;
				if (btnMc != null && btnMc.numFrames > 1)
					btnMc.currentFrame = 1;
					
			} else if (!overTouch && (downTouch == null || (downTouch != null && !this.hitTest(this.globalToLocal(new Point(downTouch.globalX, downTouch.globalY))))) && touchMode != OUT_MODE) {
				touchMode = OUT_MODE;
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, {target: e.target, currentTarget: e.currentTarget}));
				
				if (!hoverEnabled)
					return;
				if (btnMc != null)
					btnMc.currentFrame = 0;
					
			} /*else if (overTouch != null) {
				location = overTouch.getLocation(this);
				mouseX = location.x;
				mouseY = location.y;
				dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, {target: e.target, currentTarget: e.currentTarget, This:this}));
			}*/
			
			
			
		}
		
		public function gotoAndStop(frame:int):void {
			if (btnMc != null && btnMc.numFrames >= frame) {
				btnMc.currentFrame = frame - 1;
			}
		}
		
		public function disableHoverFunctions():void {
		
		}
		
		public function get buttonMode():Boolean {
			return _buttonMode;
		}
		
		public function set buttonMode(value:Boolean):void {
			_buttonMode = value;
			this.useHandCursor = value;
		}
		
		public function setText(textVal:String, fontName:String, size:int = 12, color:uint = 0xFFFFFF):void {
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont(fontName).name;
			$tf.size =  size;
			$tf.color = color;
			//$tf.bold = true;
			
			val_txt = new TextField(this.width, this.height, textVal, $tf);
			//val_txt.border = true;
			switch (alighn) {
				case "TL": 
					val_txt.x = 0;
					val_txt.y = 0;
					break;
				case "TC": 
					StaticGUI.setAlignPivot(val_txt, StaticGUI.TOP_CENTER)
					//val_txt.x = -this.width / 2;
					//val_txt.y = 0;
					break;
				case "CC": 
					val_txt.alignPivot(Align.CENTER, Align.CENTER);
					val_txt.y = val_txt.y - val_txt.height / 8;
					break;
				case "BC": 
					val_txt.x = -this.width / 2;
					val_txt.y = -this.height;
					break;
			}
			
			addChild(val_txt);
		}
		
		public function setFontText(textVal:String, fontName:String, size:int = 12, color:uint = 0xFFFFFF, shadow:Object = null, textAlign:String = TextFormatAlign.LEFT):void {
			val_txt = StaticGUI._creatTextFieldTextRenderer(this, textVal, 0, 0, this.width, this.height, fontName, size, color, shadow, textAlign);
			switch (alighn) {
				case "TL": 
					val_txt.x = 0;
					val_txt.y = 0;
					break;
				case "TC": 
					StaticGUI.setAlignPivot(val_txt, StaticGUI.TOP_CENTER)
					//val_txt.x = -this.width / 2;
					//val_txt.y = 0;
					break;
				case "CC": 
					val_txt.alignPivot(Align.CENTER, Align.CENTER);
					val_txt.y = val_txt.y - val_txt.height / 8;
					break;
				case "BC": 
					val_txt.x = -this.width / 2;
					val_txt.y = -this.height;
					break;
			}
			
			addChild(val_txt);
		}
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
			this.touchable = value;
			
			if (value == true)
				this.addEventListener(TouchEvent.TOUCH, onButtonTouch);
			else
				this.removeEventListener(TouchEvent.TOUCH, onButtonTouch);
		}
		
		public function get hoverEnabled():Boolean {
			return _hoverEnabled;
		}
		
		public function set hoverEnabled(value:Boolean):void {
			_hoverEnabled = value;
		}
		
		
	
	}

}