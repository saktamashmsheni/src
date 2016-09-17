package leaderBoard 
{
	import caurina.transitions.properties.TextShortcuts;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	/**
	 * ...
	 * @author ...
	 */
	public class LeaderItem extends Sprite
	{
		
		
		public var _indexInBoard:int;
		public var _position:int;
		public var _itsMe:Boolean;
		public var _username:String;
		
		public var _startScore:int = 0;
		public var _endScore:int = 0;
		
		public var _startPosition:int = 0;
		public var _endPosition:int = 0;
		
		public static var distanceAr:Array = [21, 0];
		
		public static var topColorsAr:Array = [0x22c810, 0x219c25, 0x1d6930];
		public static var meColors:Array = [0xffffff, 0xffffff, 0xffffff];
		
		
		private var bgMe:Image;
		private var bg:Image;
		private var meAnimCount:int;
		private var top50ListBol:Boolean;
		private var position_txt:BitmapFontTextRenderer;
		private var username_txt:BitmapFontTextRenderer;
		private var scoreVal_txt:BitmapFontTextRenderer;
		
		public function LeaderItem(_indexInBoard:int, top50ListBol:Boolean = false) 
		{
			this.top50ListBol = top50ListBol;
			this._indexInBoard = _indexInBoard;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			position_txt = StaticGUI._creatBitmapFontTextRenderer(this, "", 6, 13, 40, 30, Assets.getFont("roboto_slab_bold_23").name, TextFormatAlign.CENTER, false, -4, 20, 0x8ed400);
			username_txt = StaticGUI._creatBitmapFontTextRenderer(this, "", 50, 6, 100, 30, Assets.getFont("roboto_slab_bold_top").name, TextFormatAlign.LEFT, false, -4, 16, 0x8ed400);
			scoreVal_txt = StaticGUI._creatBitmapFontTextRenderer(this, "", 50, 25, 100, 30, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3, 14, 0xc4d3a5);
			
			
			changeStyle();
		}
		
		
		public function updateInfo(position:int, username:String, scoreLoc:int, itsMe:Boolean, index:int):void 
		{
			_indexInBoard = index;
			
			if (position > 999)
				StaticGUI._changeFormatOfBitmapText(position_txt,position_txt.x,position_txt.y, Assets.getFont("roboto_slab_bold_23").name, TextFormatAlign.CENTER, false, -4, 15, 0x8ed400);
			else
				StaticGUI._changeFormatOfBitmapText(position_txt,position_txt.x,position_txt.y, Assets.getFont("roboto_slab_bold_23").name, TextFormatAlign.CENTER, false, -4, 20, 0x8ed400);
			
				
			TweenLite.killTweensOf(this);
			
			
			if (_itsMe != itsMe)
			{
				changeStyle(itsMe);
			}
			
			
			
			this._username = username;
			this._itsMe = itsMe;
			this._position = position;
			
			_startScore = _endScore;
			_endScore = scoreLoc;
			
			TweenLite.to(this, (top50ListBol == false) ? 1 : 0, {_startScore:_endScore, ease:Linear.easeNone, onUpdate:animateScore});
			
			_startPosition = _endPosition;
			_endPosition = position;
			
			if (_username.length > 12)
			{
				var newUser:String = username.substr(0, 11);
				newUser += "...";
				username_txt.text = newUser.toUpperCase();
			}
			else
			{
				username_txt.text = _username.toUpperCase();
			}
			TweenLite.to(this, (top50ListBol == false) ? 1 : 0, {_startPosition:_endPosition, ease:Linear.easeNone, onUpdate:animatePisitionWithName});
			
		}
		
		
		
		
		public function changeStyle(itsMe:Boolean = false):void
		{
			if (itsMe)
			{
				StaticGUI.safeRemoveChild(bg, true);
				bg = new Image(Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml").getTexture("leader_user_me_bg.png"));
				addChildAt(bg,0);
				
				StaticGUI._changeFormatOfBitmapText(position_txt, position_txt.x, position_txt.y, Assets.getFont("roboto_slab_bold_23").name, TextFormatAlign.CENTER, false, -4, 20);
				StaticGUI._changeFormatOfBitmapText(username_txt, username_txt.x, username_txt.y, Assets.getFont("roboto_slab_bold_top_black").name, TextFormatAlign.LEFT, false, -1, 16, meColors[1]);
				StaticGUI._changeFormatOfBitmapText(scoreVal_txt, scoreVal_txt.x, scoreVal_txt.y, Assets.getFont("bpg_gel_dejavu_serif_black").name, TextFormatAlign.LEFT, false, 0, 12, meColors[2]);
			}
			else
			{
				StaticGUI.safeRemoveChild(bg, true);
				bg = new Image(Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml").getTexture("leader_user_item_bg.png"));
				addChildAt(bg,0);
				
				StaticGUI._changeFormatOfBitmapText(position_txt, position_txt.x, position_txt.y, Assets.getFont("roboto_slab_bold_23").name, TextFormatAlign.CENTER, false, -4, 20,0x8ed400);
				StaticGUI._changeFormatOfBitmapText(username_txt, username_txt.x, username_txt.y, Assets.getFont("roboto_slab_bold_top").name, TextFormatAlign.LEFT, false, -4, 16, 0x8ed400);
				StaticGUI._changeFormatOfBitmapText(scoreVal_txt, scoreVal_txt.x, scoreVal_txt.y, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.LEFT, false, -3, 14, 0xc4d3a5);
			}
		}
		
		
		private function animateScore():void 
		{
			//score_txt.text = String(_startScore);
			scoreVal_txt.text = GameSettings.GAME_XML.leaderBoard.qula + ": " + String(_startScore);
		}
		
		private function animatePisitionWithName():void 
		{
			//val_txt.text = String(String(_startPosition) + ". " + _username);
			position_txt.text = "#" + String(_startPosition);
		}
		
		
	}

}