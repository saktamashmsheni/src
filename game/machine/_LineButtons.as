package game.machine {
	import com.utils.StaticGUI;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LineButtons extends Sprite {
		private var numAr:Array = [4, 2, 20, 16, 10, 1, 11, 17, 3, 5, 14, 12, 9, 18, 6, 7, 19, 8, 13, 15];
		
		public function LineButtons() {
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			//initButtons();
		}
		
		private function initButtons():void 
		{
			var img:Image;
			var imgSp:Sprite;
			//var tt:TextField;
			
			var yCount:int = 0;
			var xCount:int = 0;
			
			for (var i:int = 0; i < GameSettings.TOTAL_LINES; i++) 
			{
				imgSp = new Sprite();
				
				//trace(StaticGUI.intWithZeros(numAr[i], 2));
				img = new Image(Assets.getAtlas("lineButtons", "lineButtonsXml").getTexture("b" + StaticGUI.intWithZeros(numAr[i], 2)));
				imgSp.addChild(img);
				addChild(imgSp);
				//tt = new TextField(40, 30, String(numAr[i]), Assets.getFont("IRON").name, 25, 0xFFFFFF, true);
				//tt.y = 0;
				//imgSp.addChild(tt);
				imgSp.name = "b" + String(numAr[i]);
				//tt.alignPivot(Align.CENTER, Align.CENTER);
				img.alignPivot(Align.CENTER, Align.CENTER);
				imgSp.alignPivot(Align.CENTER, Align.CENTER);
				
				imgSp.y = yCount * (45);
				yCount++;
				if (xCount == 1)
					imgSp.x = 860;
				
				if (yCount == 10)
				{
					yCount = 0;
					xCount = 1;
				}
				
				img.dispose();
			}
			
			img = null;
			imgSp = null;
			//tt = null;
		}
	}
}