package game.machine {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import com.utils.Line;

	public class LineHelper extends Sprite {
		private var lineBmd:BitmapData;
		private var lineTexure:Texture;
		private var lineImg:Image;
		private var flashSprite:flash.display.Sprite;
		
		public function LineHelper() {
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		
		}
		
		private function added(e:Event):void {

			/*var lineTest:Line = new Line;
			for (var i:uint; i < lineArray.length; i++ ) {
				
				
				lineTest.lineTo(120, 0);
				lineTest.lineTo(0, 120);
				lineTest.lineTo(-120, 0);
				lineTest.lineTo(0, -120);
				
				
			}
			//lineTest.lineTo(lineArray[i]*120+5, 0);
			
			defaultNum = zz[0];
			lineTest.moveTo(0, 120 * (zz[0])-120/2);
			lineTest.lineTo(60, 0);
			lineTest.lineTo(120+40, getCorrectYCord(zz[1]));
			lineTest.lineTo(120+40, -360+120/2);
			/*lineTest.lineTo(120, getCorrectYCord(zz[3]));
			lineTest.lineTo(120, getCorrectYCord(zz[4]));*/
			
			//lineTest.lineTo(110, 100);
			/*lineTest.lineTo(-120, 0);
			lineTest.lineTo(0, -120);*/
			
			//addChild(lineTest);*/
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed)
		}
		
		public function _showLine(lineArr:Array):void {
			//trace(lineArr)
			var zz:Array = lineArr;
			
			var yArray:Array = [60, 205, 350];
			var xArray:Array = [60,215,368,522,675];
			flashSprite = new flash.display.Sprite();
			
			//flashSprite.graphics.beginFill(0xCCCCCC);
			
			flashSprite.graphics.lineStyle(5, 0xff0000, 1);
			
			if (zz[0] == 1) {
				flashSprite.graphics.moveTo(xArray[0], yArray[0]);
			}else if (zz[0] == 2) {
				flashSprite.graphics.moveTo(xArray[0], yArray[1]);
			}else {
				flashSprite.graphics.moveTo(xArray[0], yArray[2]);
			}
			
			for(var i:uint; i<zz.length; i++){
				if (i > 0) {
					flashSprite.graphics.lineTo(xArray[i], yArray[zz[i]-1]);//90+(zz[i] - 1) * 120
				}
			}
			
			
			/*for (var i:uint; i < 4; i++ ) {
				
				flashSprite.graphics.lineTo(xArray[i], yArray[zz[i]-1]);
			}*/
			
			flashSprite.graphics.endFill();
			var imgHeight:uint = yArray[yArray.length - 1] + 60;
			lineBmd = new BitmapData(flashSprite.width+60,imgHeight, true, 0x00000000);
			lineBmd.draw(flashSprite);
			lineTexure = Texture.fromBitmapData(lineBmd);
			lineImg = new Image(lineTexure);
			this.addChild(lineImg);
			
			flashSprite.graphics.clear();
			flashSprite = null;
		}
		
		public function _disposeLine():void {
			if(lineBmd)lineBmd.dispose();
			
			if(lineTexure)lineTexure.dispose();
		
			if (lineImg && this.contains(lineImg)) this.removeChild(lineImg);
			
			lineImg.dispose();
			lineImg = null;
			lineTexure = null;
			lineBmd = null;
		}
		
		
		
		private function removed(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
		}
	
	}

}