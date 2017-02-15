package leaderBoard 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import com.utils.Timecodes;
	import connection.SocketAnaliser;
	import feathers.controls.Button;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class LeaderBoardHolder extends Sprite
	{
		private var boardBg:Image;
		private var logo:Image;
		
		private var activeInLeaderBoard:Boolean = false;
		
		public static var cont:LeaderBoardHolder;
		public static var FILLED:Boolean = false;
		
		private static const MIDDLE_POINT:int = 97;
		private var info_btn:MyButton;
		private var timerStatus_txt:BitmapFontTextRenderer;
		private var sprizeStatus_txt:BitmapFontTextRenderer;
		private var playerCountStatus_txt:BitmapFontTextRenderer;
		private var join_txt:BitmapFontTextRenderer;
		private var _atlas:TextureAtlas;
		private var enter_txt:BitmapFontTextRenderer;
		private var prize_amount_txt:BitmapFontTextRenderer;
		private var timer_con:Sprite;
		private var timer_txt:BitmapFontTextRenderer;
		private var optWindow:LeaderOptWindow;
		private var enterAnim_con:Sprite;
		private var enter_text_bg:Image;
		private var enterAnim_mc:MovieClip;
		private var enterAnimBg:Image;
		private var joinTextBg:Image;
		private var joinText_mc:Sprite;
		private var oldInd:int = -1;
		
		
		private var items_con:Sprite;
		private var swapItem:LeaderItem;
		private static var eachStaticDist:Number = 54;
		private var leaderItemsAr:Array;
		private var cc:CircleMaskAnimStarling;
		private var placeToWin_txt:BitmapFontTextRenderer;
		private var ToStart:Boolean;
		private var top3_btn:Button;
		private var prizes_btn:Button;
		private var infoBar_con:LeaderboardInfo;
		
		private var BlackWhiteFilter:ColorMatrixFilter;
		
		
		public function LeaderBoardHolder() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			
			BlackWhiteFilter = new ColorMatrixFilter(); 
			BlackWhiteFilter.adjustSaturation( -1);
		}
		
		
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			cont = this;
			//initLeaderBoard();
			
		}
		
		
		
		
		
		
		public function initLeaderBoard():void 
		{
			
			_atlas = Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml");
			
			boardBg = new Image(_atlas.getTexture("bg.png"));
			boardBg.x = GameSettings.PREFERENCES.leaderboard.bg.OF_X;
			boardBg.y = GameSettings.PREFERENCES.leaderboard.bg.OF_Y;
			addChild(boardBg);
			
			logo = new Image(_atlas.getTexture("leaderboard_logo.png"));
			StaticGUI.setAlignPivot(logo, "TC");
			logo.x = MIDDLE_POINT;
			logo.y = 7;
			addChild(logo);
			
			
			
			
			timerStatus_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.iwyeba, MIDDLE_POINT, 67, 200, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.CENTER, false, -3,12);
			StaticGUI.setAlignPivot(timerStatus_txt, "TC");
			
			sprizeStatus_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.prizi, MIDDLE_POINT, 180, 200, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.CENTER, false, -3,12);
			StaticGUI.setAlignPivot(sprizeStatus_txt, "TC");
			
			
			placeToWin_txt = StaticGUI._creatBitmapFontTextRenderer(this, "", MIDDLE_POINT+2, 124, 100, 300, Assets.getFont("bpg_gel_dejavu_serif_22_yellow").name, TextFormatAlign.CENTER, false, -2, 17);
			StaticGUI.setAlignPivot(placeToWin_txt, "TC");
			
			prize_amount_txt = StaticGUI._creatBitmapFontTextRenderer(this, "o 0 " + StaticGUI.getCurrecyShortcuts(), MIDDLE_POINT-3, 201, 100, 100, Assets.getFont("roboto_slab_bold_23").name, TextFormatAlign.CENTER, false, -4,25);
			StaticGUI.setAlignPivot(prize_amount_txt, "TC");
			
			
			playerCountStatus_txt = StaticGUI._creatBitmapFontTextRenderer(this, "0 " + GameSettings.GAME_XML.leaderBoard.motamashe, MIDDLE_POINT, 277, 410, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.CENTER, false, -3, 12);
			StaticGUI.setAlignPivot(playerCountStatus_txt, "TC");
			
			
			
			
			
			
			var opt_con:Sprite = new Sprite();
			
			prizes_btn = StaticGUI._setButtonWithBitmapFont(opt_con, 
																	   {x:0, y:0, label:GameSettings.GAME_XML.leaderBoard.prizebiBtn, 	labelOffsetX:12, labelOffsetY:1},
																	   _atlas.getTexture("prizes_btn_1.png"),
																	   _atlas.getTexture("prizes_btn_2.png"),
																	   _atlas.getTexture("prizes_btn_1.png"),
																	   _atlas.getTexture("prizes_btn_1.png"),
																	   Assets.getFont("bpg_gel_dejavu_serif_white").name,
																	   -4, 15);
			prizes_btn.name = "prizesBtn";
			prizes_btn.addEventListener(Event.TRIGGERED, onOptBtnsClick);
			
			top3_btn = StaticGUI._setButtonWithBitmapFont(opt_con, 
																	   {x:101, y:0, label:"TOP 20", labelOffsetX:-12, labelOffsetY:1},
																	   _atlas.getTexture("top3_btn_1.png"),
																	   _atlas.getTexture("top3_btn_2.png"),
																	   _atlas.getTexture("top3_btn_1.png"),
																	   _atlas.getTexture("top3_btn_1.png"),
																	   Assets.getFont("bpg_gel_dejavu_serif_white").name,
																	   -4, 15);
			top3_btn.name = "top3Btn"
			top3_btn.addEventListener(Event.TRIGGERED, onOptBtnsClick);
			
			opt_con.x = 48;
			opt_con.y = 252;
			addChild(opt_con);
			
			
			
			//-----timer
			timer_con = new Sprite();
			timer_con.x = MIDDLE_POINT;
			timer_con.y = 100;
			addChild(timer_con);
			
			var timerBg:Image = new Image(_atlas.getTexture("timer_bg.png"));
			StaticGUI.setAlignPivot(timerBg, "CC");
			timer_con.addChild(timerBg);
			
			
			
			
			timer_txt = StaticGUI._creatBitmapFontTextRenderer(this, "", 34, 41, 200, 100, Assets.getFont("roboto_slab_bold_timer_22").name, TextFormatAlign.LEFT, true, -4, 19);
			StaticGUI.setAlignPivot(timer_txt, "CC");
			timer_con.addChild(timer_txt);
			
			
			
			info_btn = new MyButton(_atlas.getTextures("info_btn"));
			info_btn.x = 163;
			info_btn.y = 35;
			addChild(info_btn);
			info_btn.addEventListener(MouseEvent.CLICK, onInfoClick);
			
			
		}
		
		
		private function onInfoClick(e:MouseEvent):void {
			
			if (infoBar_con != null)
			{
				removInfoBar();
				return;
			}
			infoBar_con = new LeaderboardInfo();
			infoBar_con.x = 180;
			infoBar_con.y = 70;
			addChild(infoBar_con);
		}
		
		private function removInfoBar():void {
			infoBar_con.disposeAll();
			StaticGUI.safeRemoveChild(infoBar_con, true);
			infoBar_con = null;
		}
		
		
		///enter anim
		private function initEnterAnim():void 
		{
			//-------------------------------------------------------------- enter anim
			enterAnim_con = new Sprite();
			enterAnim_con.x = MIDDLE_POINT + 2;
			enterAnim_con.y = 375;
			addChild(enterAnim_con);
			
			joinText_mc = new Sprite();
			joinTextBg = new Image(_atlas.getTexture("entry_bg.png"));
			StaticGUI.setAlignPivot(joinTextBg, "CC");
			joinText_mc.addChild(joinTextBg);
			enterAnim_con.addChild(joinText_mc);
			joinText_mc.x = 0;
			joinText_mc.y = 147;
			
			
			enterAnimBg = new Image(_atlas.getTexture("enterAnimFrame.png"));
			enterAnim_con.addChild(enterAnimBg);
			StaticGUI.setAlignPivot(enterAnimBg, "CC");
			
			enterAnim_mc = new MovieClip(Assets.getAtlas("leaderboardEnterAnimSheet", "leaderboardEnterAnimSheetXml").getTextures(""),18);
			enterAnim_con.addChild(enterAnim_mc);
			enterAnim_mc.y = 5;
			StaticGUI.setAlignPivot(enterAnim_mc, "CC");
			Starling.juggler.add(enterAnim_mc);
			enterAnim_mc.addEventListener(Event.COMPLETE, whenEnterAnimComplete);
			
			enter_text_bg = new Image(_atlas.getTexture("enterTextBg.png"));
			enterAnim_con.addChild(enter_text_bg);
			StaticGUI.setAlignPivot(enter_text_bg, "CC");
			
			enter_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.enterTxt, 0, 43, 120, 100, Assets.getFont("bpg_gel_dejavu_serif_white").name, TextFormatAlign.CENTER, false, -3, 12);
			StaticGUI.setAlignPivot(enter_txt, "CC");
			enterAnim_con.addChild(enter_txt);
			
			join_txt = StaticGUI._creatBitmapFontTextRenderer(this, GameSettings.GAME_XML.leaderBoard.join_txt, 0, 30, 120, 100, Assets.getFont("bpg_gel_dejavu_serif_22").name, TextFormatAlign.CENTER, true, -8, 21);
			StaticGUI.setAlignPivot(join_txt, "CC");
			joinText_mc.addChild(join_txt);
		}
		
		
		private function changeEnterAnimTxt():void 
		{
			if (join_txt != null) 
			{
				if (ToStart)
					join_txt.text =  GameSettings.GAME_XML.leaderBoard.jjj;
				else
					join_txt.text =  GameSettings.GAME_XML.leaderBoard.join_txt;
			}
			if (enter_txt != null)
			{
				if (ToStart)
					enter_txt.text =  GameSettings.GAME_XML.leaderBoard.jjj;
				else
					enter_txt.text =  GameSettings.GAME_XML.leaderBoard.enterTxt;
			}
			
		}
		
		
		private function whenEnterAnimComplete(e:Event):void {
			enterAnim_mc.stop();
			
			TweenLite.delayedCall(4, enterAnim_mc.play);
		}
		
		
		private function removeEnterAnim():void
		{
			StaticGUI.safeRemoveChild(join_txt, true);
			join_txt = null;
			StaticGUI.safeRemoveChild(enter_txt, true);
			enter_txt = null;
			StaticGUI.safeRemoveChild(enter_text_bg, true);
			enter_text_bg = null;
			Starling.juggler.remove(enterAnim_mc);
			StaticGUI.safeRemoveChild(enterAnim_mc, true);
			enterAnim_mc = null;
			StaticGUI.safeRemoveChild(enterAnimBg, true);
			enterAnimBg = null;
			StaticGUI.safeRemoveChild(joinTextBg, true);
			joinTextBg = null;
			StaticGUI.safeRemoveChild(joinText_mc, true);
			joinText_mc = null;
			StaticGUI.safeRemoveChild(enterAnim_con, true);
			enterAnim_con = null;
			
		}
		
		
		//leaderboard users
		private function initLeaderBoardUsers():void 
		{
			
			leaderItemsAr = [];
			var leadItem_mc:LeaderItem;
			
			items_con = new Sprite();
			items_con.x = 20;
			items_con.y = 300;
			addChild(items_con);
			
			for (var i:int = 0; i < 5; i++) 
			{
				leadItem_mc = new LeaderItem(i);
				leadItem_mc.y = eachStaticDist * i;
				items_con.addChild(leadItem_mc);
				leaderItemsAr.push(leadItem_mc);
			}
			
			leadItem_mc = null;
		}
		
		
		
		public function updateLeaderInfo(obj:Object):void 
		{
			try 
			{
				
			ToStart = obj.ToStart;
			if (obj.ToStart == false)
			{
				top3_btn.label = "TOP " + obj.WinnerCount.toString();
				
				this.filter = null;
			}
			else
			{
				top3_btn.label = "WINNERS";
				top3_btn.labelOffsetY = 8;
				
				if (this.filter == null)
				{
					this.filter = BlackWhiteFilter;
				}
			}
			
			prize_amount_txt.text = "o" + String((obj.PrizeSum / 100).toFixed(2))  + StaticGUI.getCurrecyShortcuts();
			playerCountStatus_txt.text = String(obj.UsersCount) + " " + GameSettings.GAME_XML.leaderBoard.motamashe;
			
			var i:int;
			
			if (activeInLeaderBoard == false)
			{
				for (i = 0; i < obj.Users.length; i++) 
				{
					if (obj.Users[i][0] == obj.Position)
					{
						if (obj.Users[i][2] > 0)
						{
							activeInLeaderBoard = true;
							break;
						}
						else
						{
							activeInLeaderBoard = false;
						}
					}
				}
				
				if (activeInLeaderBoard == false && enterAnim_con == null)
				{
					initEnterAnim();
					if (obj.ToStart && enterAnim_mc != null)
					{
						enterAnim_mc.stop();
					}
					else
					{
						if (enterAnim_mc.isPlaying == false)
						{
							enterAnim_mc.play();
						}
					}
				}
				else
				{
					removeEnterAnim();
				}
			}
			
			
			
			if (enterAnim_con != null)
			{
				changeEnterAnimTxt();
			}
			
			
			
			if (activeInLeaderBoard)
			{
				if (items_con == null)
				{
					initLeaderBoardUsers();
				}
				
				for (i = 0; i < obj.Users.length; i++) 
				{
					
					if (isInBoard(obj.Users[i][1]) != null)
					{
						swapItem = isInBoard(obj.Users[i][1]);
						//if (i != swapItem._indexInBoard)
						{
							swapIndexes(leaderItemsAr[i], swapItem);
						}
						
						swapItem.updateInfo(obj.Users[i][0], obj.Users[i][1], obj.Users[i][2], obj.Users[i][0] == obj.Position, i);
					}
					else
					{
						leaderItemsAr[i].updateInfo(obj.Users[i][0], obj.Users[i][1], obj.Users[i][2], obj.Users[i][0] == obj.Position, i);
					}
					
					
				}
				
				if (obj.Position <= obj.WinnerCount)
				{
					placeToWin_txt.text = "#" + String(obj.Position) + " \n" + GameSettings.GAME_XML.leaderBoard.momgebiania;
				}
				else
				{
					placeToWin_txt.text = String(obj.Position - obj.WinnerCount) + " " + GameSettings.GAME_XML.leaderBoard.toWin;
					//placeToWin_txt.
					//StaticGUI._changeFormatOfBitmapText(placeToWin_txt,placeToWin_txt.x,placeToWin_txt.y, Assets.getFont("bpg_gel_dejavu_serif_22_yellow").name, TextFormatAlign.CENTER, false, -2, 16);
				}
				
				animateAllItemsPositions();
				
			}
			else
			{
				if (ToStart == false)
				{
					placeToWin_txt.text = GameSettings.GAME_XML.leaderBoard.spin;
				}
				else
				{
					placeToWin_txt.text = GameSettings.GAME_XML.leaderBoard.inactive;
				}
				
			}
			}
			catch (err:Error)
			{
				
			}
		}
		
		
		public function animateAllItemsPositions():void
		{
			leaderItemsAr.sortOn("_position", Array.NUMERIC );
			
			for (var i:int = 0; i < leaderItemsAr.length; i++) 
			{
				var item:LeaderItem = leaderItemsAr[i];
				//trace(item._username + "   " + item._position + "   " + item.txt);
				/*if (i == 0)
				{*/
					TweenMax.to(item, 1, {y:i*eachStaticDist, ease:Expo.easeInOut});
				/*	
				}
				else if( i<2)
				{
					TweenMax.to(item, 1, {y:i*eachStaticDist + i*LeaderItem.distanceAr[0], ease:Expo.easeInOut});
					//TweenMax.to(item, 1, {y:leaderItemsAr[i - 1].y + (leaderItemsAr[i-1].height + i*40), ease:Expo.easeInOut});
				}
				else
				{
					TweenMax.to(item, 1, {y:i*eachStaticDist+ 2*LeaderItem.distanceAr[0], ease:Expo.easeInOut});
					//TweenMax.to(item, 1, {y:leaderItemsAr[i - 1].y + (leaderItemsAr[i-1].height + 2*40), ease:Expo.easeInOut});
				}*/
				item = null;
			}
		}
		
		
		
		private function timeChangeEvent(e:LeaderBoardEvents):void 
		{
			timer_txt.text = Timecodes.secondsToTimecode(e.params.timerCount);
		}
		
		public function updateTimer(obj:Object):void 
		{
			if (cc == null)
			{
				cc = new CircleMaskAnimStarling();
				timer_con.addChild(cc);
				StaticGUI.setAlignPivot(cc, "CC");
				cc.addEventListener(LeaderBoardEvents.TIMER_EVENT, timeChangeEvent);
			}
			
			cc.upldateTimer(obj.Time, obj.TotalTime, obj.ToStart);
			
			
			if (obj.PrizeSum)
			{
				prize_amount_txt.text = "o" + String((obj.PrizeSum / 100).toFixed(2)) + StaticGUI.getCurrecyShortcuts();
			}
			
			
			ToStart = obj.ToStart;
			
			
			if (obj.ToStart)
			{
				timerStatus_txt.text = GameSettings.GAME_XML.leaderBoard.iwyeba;
			}
			else
			{
				timerStatus_txt.text = GameSettings.GAME_XML.leaderBoard.mtavrdeba;
			}
		}
		
		
		
		private function onOptBtnsClick(e:Event):void 
		{
			var btn:Button = e.target as Button;
			
			switch (btn.name) 
			{
				case "prizesBtn":
					
					if (optWindow != null)
					{
						oldInd = optWindow.WINDOW_TYPE;
						optWindow.disposeAll();
						optWindow = null;
					}
					
					if (oldInd == -1 || oldInd == 1)
					{
						optWindow = new LeaderOptWindow(0);
						addChild(optWindow);
						optWindow.x = 20;
						optWindow.y = 270;
					}
					else
					{
						oldInd = -1
					}
					Root.connectionManager.sendData({MT: SocketAnaliser._leaderPrizes, SID: ""});
					
				break;
				case "top3Btn":
					if (optWindow != null)
					{
						oldInd = optWindow.WINDOW_TYPE;
						optWindow.disposeAll();
						optWindow = null;
					}
					
					if (oldInd == -1 || oldInd == 0)
					{
						optWindow = new LeaderOptWindow(1);
						addChild(optWindow);
						optWindow.x = 20;
						optWindow.y = 270;
					}
					else
					{
						oldInd = -1
					}
					Root.connectionManager.sendData({MT: SocketAnaliser._leaderTOPUsers, SID: ""});
				break;
			}
			
			btn = null;
		}
		
		
		
		public function onTopUsersResponse(obj:Object):void
		{
			if (optWindow != null && optWindow.WINDOW_TYPE == 1)
			{
				optWindow.addInfo(obj);
			}
		}
		
		public function onPrizesResponse(obj:Object):void
		{
			if (optWindow != null && optWindow.WINDOW_TYPE == 0)
			{
				optWindow.addInfo(obj);
			}
		}
		
		
		
		
		public function isInBoard(nameStr:String):LeaderItem
		{
			for (var i:int = 0; i < leaderItemsAr.length; i++) 
			{
				if (leaderItemsAr[i]._username == nameStr)
				{
					return leaderItemsAr[i];
				}
			}
			return null;
		}
		
		public function swapIndexes(item1:LeaderItem, item2:LeaderItem):void
		{
			var obj1:Object = {};
			obj1._indexInBoard = item1._indexInBoard;
			item1._indexInBoard = item2._indexInBoard;
			item2._indexInBoard = obj1._indexInBoard;
		}
		
		public function getItemByIndex(ind:int):LeaderItem
		{
			for (var i:int = 0; i < leaderItemsAr.length; i++) 
			{
				if (leaderItemsAr[i]._indexInBoard == ind)
				{
					return leaderItemsAr[i];
				}
			}
			
			return null;
		}
		
		
		
		
		
		
		public function spinStarted():void
		{
			if (optWindow != null)
			{
				optWindow.disposeAll();
				optWindow = null;
			}
			
			if (infoBar_con != null)
			{
				removInfoBar();
			}
			
		}
		
		
	}

}