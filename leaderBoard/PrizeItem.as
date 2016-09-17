package leaderBoard 
{
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class PrizeItem extends Sprite
	{
		private var _atlas:TextureAtlas;
		private var position_txt:BitmapFontTextRenderer;
		private var position:int;
		private var prize_txt:BitmapFontTextRenderer;
		private var prizeAmount:int;
		private var line_img:Image;
		
		public function PrizeItem(position:int, prizeAmount:int = 60000) 
		{
			this.prizeAmount = prizeAmount;
			this.position = position;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			initPrizeItem();
		}
		
		private function initPrizeItem():void 
		{
			_atlas = Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml");
			
			
			line_img = new Image(_atlas.getTexture("prizes_line.png"));
			addChild(line_img);
			
			
			
			position_txt = StaticGUI._creatBitmapFontTextRenderer(this, "#" + String(position), 6, 8, 100, 30, Assets.getFont("roboto_slab_bold_prizes").name, TextFormatAlign.LEFT, false, -4);
			
			prize_txt = StaticGUI._creatBitmapFontTextRenderer(this, String((prizeAmount/100).toFixed(2)) + "e", 0, 8, 130, 30, Assets.getFont("roboto_slab_bold_prizes").name, TextFormatAlign.RIGHT, false, -4);
			
		}
		
		
		public function disposeAll():void 
		{
			_atlas = null;
			StaticGUI.safeRemoveChild(line_img, true);
			line_img = null;
			StaticGUI.safeRemoveChild(position_txt, true);
			position_txt = null;
			StaticGUI.safeRemoveChild(position_txt, true);
			position_txt = null;
			
		}
		
	}

}