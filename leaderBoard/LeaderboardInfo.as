package leaderBoard {
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author ...
	 */
	public class LeaderboardInfo extends Sprite{
		private var _atlas:TextureAtlas;
		private var bg:Image;
		private var info1_txt:BitmapFontTextRenderer;
		private var info2_txt:BitmapFontTextRenderer;
		private var info3_txt:BitmapFontTextRenderer;
		
		public function LeaderboardInfo() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initInfo();
		}
		
		private function initInfo():void 
		{
			_atlas = Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml");
			
			bg = new Image(_atlas.getTexture("info_bar.png"));
			addChild(bg);
			
			
			info1_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.info.t1, 17, 12, 250, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3,14);
			info2_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.info.t2, 17, 115, 250, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3,14);
			info3_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.info.t3, 17, 285, 250, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3,14);
		}
		
		public function disposeAll():void
		{
			_atlas = null;
			
			StaticGUI.safeRemoveChild(bg, true);
			bg = null;
			StaticGUI.safeRemoveChild(info1_txt, true);
			info1_txt = null;
			StaticGUI.safeRemoveChild(info2_txt, true);
			info2_txt = null;
			StaticGUI.safeRemoveChild(info3_txt, true);
			info3_txt = null;
			
		}
		
	}

}