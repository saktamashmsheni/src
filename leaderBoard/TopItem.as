package leaderBoard 
{
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class TopItem extends Sprite
	{
		private var position:int;
		private var userName:String;
		private var points:int;
		private var prizeAmount:int;
		private var _atlas:TextureAtlas;
		private var position_txt:BitmapFontTextRenderer;
		private var username_txt:BitmapFontTextRenderer;
		private var score_txt:BitmapFontTextRenderer;
		private var scoreVal_txt:BitmapFontTextRenderer;
		private var prize_txt:BitmapFontTextRenderer;
		private var prizeVal_txt:BitmapFontTextRenderer;
		private var quad:Quad;
		private var img_line:Image;
		
		public function TopItem(position:int, userName:String, points:int, prizeAmount:int) 
		{
			this.prizeAmount = prizeAmount;
			this.points = points;
			this.userName = userName;
			this.position = position;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initTopItem();
		}
		
		
		
		private function initTopItem():void 
		{
			_atlas = Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml");
			
			quad = new Quad(100, 60);
			quad.alpha = 0;
			addChild(quad);
			
			img_line = new Image(_atlas.getTexture("top_line.png"));
			addChild(img_line);
			img_line.y = 58;
			img_line = null;
			
			position_txt = StaticGUI._creatBitmapFontTextRenderer(this, "#" + String(position), 6, 0, 100, 30, Assets.getFont("roboto_slab_bold_top").name, TextFormatAlign.LEFT, false, -4, -1, 0, 0x71ff1b);
			if (userName.length > 10)
			{
				userName = userName.substr(0, 9);
				userName += "...";
			}
			username_txt = StaticGUI._creatBitmapFontTextRenderer(this, userName.toUpperCase(), 33, position_txt.y-1, 100, 30, Assets.getFont("roboto_slab_bold_top").name, TextFormatAlign.LEFT, false, -4);
			
			score_txt = StaticGUI._creatBitmapFontTextRenderer(this, /*GameSettings.GAME_XML.leaderBoard.qula + */"P:", 6, position_txt.y + 25, 100, 30, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3, 12, 0, 0xffaf00);
			scoreVal_txt = StaticGUI._creatBitmapFontTextRenderer(this, points.toString(), 0, position_txt.y + 23, 130, 30, Assets.getFont("roboto_slab_bold_prizes").name, TextFormatAlign.RIGHT, false, -3);
			
			prize_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.prizi + ":", 6, position_txt.y + 40, 100, 30, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3, 12, 0, 0xffaf00);
			prizeVal_txt = StaticGUI._creatBitmapFontTextRenderer(this, String((prizeAmount/100).toFixed(2)) + "" + StaticGUI.getCurrecyShortcuts(), 0, position_txt.y + 38, 130, 30, Assets.getFont("roboto_slab_bold_prizes").name, TextFormatAlign.RIGHT, false, -3, -1, 0, 0x71ff1b);
			
			
		}
		
		
		public function disposeAll():void 
		{
			_atlas = null;
			StaticGUI.safeRemoveChild(quad, true);
			quad = null;
			StaticGUI.safeRemoveChild(img_line, true);
			img_line = null;
			StaticGUI.safeRemoveChild(position_txt, true);
			position_txt = null;
			StaticGUI.safeRemoveChild(username_txt, true);
			username_txt = null;
			StaticGUI.safeRemoveChild(score_txt, true);
			score_txt = null;
			StaticGUI.safeRemoveChild(scoreVal_txt, true);
			scoreVal_txt = null;
			StaticGUI.safeRemoveChild(prize_txt, true);
			prize_txt = null;
			StaticGUI.safeRemoveChild(prizeVal_txt, true);
			prizeVal_txt = null;
			
		}
		
	}

}