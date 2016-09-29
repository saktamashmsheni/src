package com.utils {
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Line extends Sprite {
		private var baseQuad:Quad;
		private var _thickness:Number = 5;
		private var _color:uint = 0xff0000;
		private var saveLineToX:int;
		private var saveLineToY:int;
		private var moveToX:int;
		private var moveToY:int;
		
		
		public function Line() {
			
		}
		
		public function lineTo(toX:int, toY:int, movX:int=0, movY:int=0):void {
			
			baseQuad = new Quad(1, _thickness, _color);
			baseQuad.x = saveLineToX+moveToX;
			baseQuad.y = saveLineToY+moveToY;
			baseQuad.width = Math.round(Math.sqrt((toX*toX)+(toY*toY)));
			baseQuad.rotation = Math.atan2(toY, toX);
			saveLineToX += toX;
			saveLineToY += toY;
			
			addChild(baseQuad);
		}
		
		
		public function moveTo(xPos:int, yPos:int):void {
			moveToX = xPos;
			moveToY = yPos;
		}
		
		public function set thickness(t:Number):void {
			var currentRotation:Number = baseQuad.rotation;
			baseQuad.rotation = 0;
			baseQuad.height = _thickness = t;
			baseQuad.rotation = currentRotation;
		}
		
		public function get thickness():Number {
			return _thickness;
		}
		
		public function set color(c:uint):void {
			baseQuad.color = _color = c;
		}
		
		public function get color():uint {
			return _color;
		}
	}

}