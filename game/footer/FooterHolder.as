package game.footer {
	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.GAnalyticsEvents;
	import com.utils.GoogleAnalytics;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StateButton;
	import com.utils.StaticGUI;
	import connection.SocketAnaliser;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import game.header.musicPlayer.MusicManager;
	import game.machine.Lines;
	import game.PlusMinusButs;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	import starling.utils.Align;
	import starling.utils.Align;
	

	public class FooterHolder extends Sprite {
		
		private var _spinEnabled:Boolean = true;
		private var lastWasLari:Boolean = InLari;
		private var balanceTXT:BitmapFontTextRenderer;
		private var totalBetTXT:TextFieldTextRenderer;
		private var winTXT:BitmapFontTextRenderer;
		//private var linesTXT:TextField;
		private var betTxt:TextFieldTextRenderer;
		
		private var maxLinesBtn:MyButton;
		private var maxBetBtn:MyButton;
		
		//private var lineButs:PlusMinusButs;
		private var betButs:PlusMinusButs;
		private var autoSpinBtn:Button;
		private var autoSpinTXT:TextField;
		private var spinTXT:TextField;
		private var creditHolder:CreditContainer;
		
		private var $atlas:TextureAtlas;
		
		private static const betAttrStr:String = "";
		
		
		private const BALANCE_TEXT:String = 'BALANCE: ';
		//private const TOTALBET_TEXT:String = '<font color="#ffffff">TOTAL BET: </font>';
		private const TOTALBET_TEXT:String = '';
		private const WIN_TEXT:String = 'WIN: ';
		private var changeLariBtn:MyButton;
		private var $spnObj:Object;
		
		public var spinBtn:Button;
		public static var InLari:Boolean = false;
		public var winAmount:Number = 0;
		public var freeSpinsWinAmount:Number = 0;
		public var sendSpinSecureCount:int = 0;
		public var autoSpinAmount:int;
		public var _startWin:Number;
		public var _start:Number;
		public var _win:Number;
		public var totalBetAmount:int;
		public var balanceAmount:Number;
		public var autospinNumsAr:Array = [5, 10, 15, 20];
		public var _bonusGame:Boolean;
		public static var cont:FooterHolder;
		
		public function FooterHolder() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			initFooter();
			
		}
		

		
		private function initFooter():void {
			
			cont = this;
			
			$atlas = Assets.getAtlas("footerSheet", "footerSheetXml");
			
			
			//-----shua teqstebi
			var balanceBgImg:Image = new Image($atlas.getTexture("balance_bg.png"));
			balanceBgImg.x = -73;
			addChild(balanceBgImg);
			
			balanceTXT = StaticGUI._creatBitmapFontTextRenderer(this, BALANCE_TEXT + '0', -60, 20, 380, 23, Assets.getFont("balance_bfont").name, TextFormatAlign.CENTER, false, -13, -1);
			changeLariBtn = new MyButton(null, "CC");
			changeLariBtn.x = balanceTXT.x;
			changeLariBtn.y = balanceTXT.y;
			addChild(changeLariBtn);
			var quad:Quad = new Quad(balanceTXT.width, balanceTXT.height+20, Color.RED);
			
			quad.alpha = 0;
			changeLariBtn.addChild(quad);
			changeLariBtn.addEventListener(MouseEvent.CLICK, onBalanceClick);
			
			
			
			var winBgImg:Image = new Image($atlas.getTexture("win_bg.png"));
			winBgImg.x = 313;
			winBgImg.y = -1;
			addChild(winBgImg);
			winTXT = StaticGUI._creatBitmapFontTextRenderer(this, WIN_TEXT + '0', 260, 20, 380, 23, Assets.getFont("win_bfont").name, TextFormatAlign.CENTER, false, -13, -1);
			
			
			
			
			var footAttrImg:Image = new Image($atlas.getTexture("footer_attr.png"));
			addChild(footAttrImg);
			footAttrImg.x = -103;
			footAttrImg.y = -13;
			
			
			
			
			var $btnPropObj:Object = new Object;
			
			

			/*spinBtn.addEventListener(MouseEvent.MOUSE_OVER, onSpinOver);
			spinBtn.addEventListener(MouseEvent.MOUSE_OUT, onSpinOut);*/
			
			var $btnTextShadow:Object = new Object;
			$btnTextShadow.blurX = 2;
			$btnTextShadow.blurY = 2;
			$btnTextShadow.distance = 1;
			$btnTextShadow.color = 0x000000;
			$btnTextShadow.alpha = .35;
			$btnTextShadow.angle = 90;
			$btnTextShadow.quality = 3;
			$btnTextShadow.strength = 2;
			
			var $textShadow:Object = new Object;
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = 0.35;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			//autoSpin
			
			
			var $autoObj:Object = new Object;
			$autoObj.label = 'AUTO';
			$autoObj.x = 530;
			$autoObj.y = 95;
			//$autoObj.maxWidth = 229;
			//$autoObj.maxHeight = 116;
			$autoObj.labelOffsetY = -7;
			$autoObj.labelOffsetX = -10;
			
			
			autoSpinBtn = StaticGUI._setButtonWithBitmapFont(this,
													$autoObj, 
					 $atlas.getTexture("auto_spin_controller_1.png"), 
					 $atlas.getTexture("auto_spin_controller_2.png"), 
					 $atlas.getTexture("auto_spin_controller_3.png"),
					                                       null,
												Assets.getFont("auto_spin_font").name, -7);
			
			autoSpinBtn.addEventListener( Event.TRIGGERED, onAutoSpinClick);
			


			
			
			
			$spnObj = new Object;
			$spnObj.label = 'SPIN';
			$spnObj.x = 700;
			$spnObj.y = 67;
			//$spnObj.maxWidth = 229;
			//$spnObj.maxHeight = 116;
			$spnObj.labelOffsetY = 0;
			spinBtn = StaticGUI._setButtonWithBitmapFont(this,
													$spnObj, 
					 $atlas.getTexture("spin_controller_1.png"), 
					 $atlas.getTexture("spin_controller_2.png"), 
					 $atlas.getTexture("spin_controller_3.png"),
					                                       null,
												Assets.getFont("SPIN_FONT").name, -13, -1);
												
			

			spinBtn.addEventListener( Event.TRIGGERED, onSpinClick);
			
			
			
			
			
			
		   creditHolder = new CreditContainer();
		   creditHolder.x = 20;
		   creditHolder.y = 95;
		   creditHolder.addEventListener(GameEvents.CREDIT_CHANGED, whenCreditChanged);
		   addChild(creditHolder);
		   
		    betButs = new PlusMinusButs($atlas.getTextures("plus_btn"), 
										$atlas.getTextures("minus_btn"));
			var betBgImg:Image = new Image($atlas.getTexture("bet_bg.png"));
			betButs.addChildAt(betBgImg, 0);
			betBgImg.x = 7;
			betBgImg.y = -6;
			betBgImg = null;
			betButs.x = 107;
			betButs.y = 76;
			betButs.plusBtn.addEventListener(MouseEvent.CLICK, onBetPlusMinusClick);
			betButs.minusBtn.addEventListener(MouseEvent.CLICK, onBetPlusMinusClick);
			addChild(betButs);
			
			betTxt = StaticGUI._creatTextFieldTextRenderer(betButs, betAttrStr + "1", 46, 14, 79, 20, '_AvenirNextBold', 16, 0xffffff, $textShadow, TextFormatAlign.CENTER);
			
			
			
			var totalBetCon:Sprite = new Sprite();
			totalBetCon.x = 268;
			totalBetCon.y = 77;
			addChild(totalBetCon);
			var totalbetBgImg:Image = new Image($atlas.getTexture("totalbet_bg.png"));
			totalBetCon.addChildAt(totalbetBgImg, 0);
			totalbetBgImg.x = 7;
			totalbetBgImg.y = -7;
			totalbetBgImg = null;
			
			totalBetTXT = StaticGUI._creatTextFieldTextRenderer(totalBetCon, TOTALBET_TEXT + '0', 46, 14, 79, 20, '_AvenirNextBold', 16, 0xffffff, $textShadow, TextFormatAlign.CENTER);
		   
			
			
			$atlas = null;
		}
		
		
		private function onBalanceClick(e:MouseEvent):void {
			if (InLari)
			{
				InLari = false;
			}
			else
			{
				InLari = true;
			}
			
			changeScoreTypes();
		}
		
		private function onDoubleUp_btnClick(e:Event):void {
			
			
			switch(GameHolder.gameState) {
					
				case GameHolder.DOUBLE_STATE:
					Root.soundManager.stopSound();
					GameHolder.cont.showDoubleHolder(winAmount);
					GameHolder.cont.machineHolder.stopIconsAnimation(true);
					GameHolder.cont.hideSlotItemsForStates();
					Lines.cont.killDelayedCalls();
					//$betSlider._isEnabled(false);
					
					//spinBtn.isEnabled = false;
					//spinBtn.useHandCursor = false;
					Root.soundManager.PlaySound("options_click");
					MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_MUTE);
					autoSpinBtn.isEnabled = false
					autoSpinBtn.useHandCursor = false;
					break;
			}
		}
		
		private function betChangeCallBackHandler():void {
			Root.soundManager.PlaySound("options_click");
			updateBet(GameSettings.BET_INDEX);
		}
		
		private function whenCreditChanged(e:GameEvents):void {
			//Root.soundManager.PlaySound("options_click");
			changeScoreTypes();
		}
		
		private function onSpinOver(e:MouseEvent):void {
			//TweenMax.to(e.params.currentTarget.getChildByName("spinBg"), 0.8, { rotation: deg2rad(-5), ease:Elastic.easeOut } );
		}
		
		private function onSpinOut(e:MouseEvent):void {
			//TweenMax.to(e.params.currentTarget.getChildByName("spinBg"), 0.8, { rotation: deg2rad(0), ease:Elastic.easeOut } );
		}
		
		//on spin click
		public function onSpinClick(e:Event = null):void {
			
			Root.soundManager.stopSound();
			if (e != null)
			{
				Root.soundManager.PlaySound("options_click");
			}
			
			if (spinEnabled == false && spinBtn.label == "STOP") {
				GameHolder.cont.machineHolder.makeFastStop();
				spinStopDisable();
				GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS,'spin stop','spin stop clicked');
				return;
			}
			
			try{
				
				GameHolder.cont.machineHolder.stopIconsAnimation(true);
			}catch (err:Error){}
			
			
			
			if (totalBetAmount > balanceAmount / GameSettings.CREDIT_VAL && GameHolder.gameState != GameHolder.DOUBLE_STATE) {
				if (balanceAmount > 4 && GameHolder.cont.freeSpinsState == false) 
				{
					GameHolder.gameState = GameHolder.NORMAL_STATE
					updateState(GameHolder.gameState);
					spinEnabled = true;
					
					while (GameSettings.TOTAL_LINES * Root.betsArray[GameSettings.BET_INDEX] * GameSettings.CREDIT_VAL > balanceAmount) 
					{
						if (GameSettings.BET_INDEX != 0) {
							GameSettings.BET_INDEX = GameSettings.BET_INDEX - 1;
							updateBet(GameSettings.BET_INDEX);
						}
						else
						{
							break;
						}
						
					}
					
					return;
				} else {
					if (GameHolder.cont.freeSpinsState == false) {
						GameHolder.cont.addCashier();
						return;
					}
				}
			}
			
			if (this.spinEnabled == false && (GameHolder.gameState != GameHolder.AUTOPLAY_STATE && e != null)) {
				return;
			}
			
			if (GameHolder.gameState == GameHolder.NORMAL_STATE || GameHolder.gameState == GameHolder.AUTOPLAY_STATE) {
				if (GameHolder.cont.machineHolder.isScrolling) {
					
					return;
				}
				sendSpinSecureCount++;
				//Tracer._log("sendSpinSecureCount: " + sendSpinSecureCount + String(new Date()));
				if (sendSpinSecureCount > 1) {
					return;
				}
				
				this.spinEnabled = false;
				if (GameHolder.gameState == GameHolder.NORMAL_STATE) {
					TweenLite.killDelayedCallsTo(spinStopDisable);
					spinBtn.label = "STOP";
					TweenLite.delayedCall(1.5, spinStopDisable);
				}
				
				//$betSlider._isEnabled(false);
				MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_MUTE_ONDELAY);
				
				//Root.connectionManager.sendData({MT: SocketAnaliser.spinScatter, SID: "", IM: {Lines: GameSettings.ACT_LINES, Bet: Root.betsArray[GameSettings.BET_INDEX] * GameSettings.CREDIT_VAL}, UID: Root.userRoomId}, true);
				//Root.connectionManager.sendData({MT: SocketAnaliser.spinWild, SID: "", IM: {Lines: GameSettings.ACT_LINES, Bet: Root.betsArray[GameSettings.BET_INDEX] * GameSettings.CREDIT_VAL}, UID: Root.userRoomId}, true);
				Root.connectionManager.sendData({MT: SocketAnaliser.spin, SID: "", IM: {Lines: GameSettings.ACT_LINES, Bet: Root.betsArray[GameSettings.BET_INDEX] * GameSettings.CREDIT_VAL}, UID: Root.userRoomId}, true);
				dispatchEvent(new GameEvents(GameEvents.SPIN_STARTED));
				GameHolder.cont.machineHolder.startMachineSpin();
				
				GameHolder.cont.linesHolder.checkWildTransofmedArr();
				
				
				
				
				/*if (GameHolder.cont.freeSpinsState == false)
				   {
				   if (FooterHolder.InLari == true)
				   {
				   updateBalance(balanceAmount - totalBetAmount*CreditContainer.CREDIT);
				   }
				   else
				   {
				   updateBalance(balanceAmount - totalBetAmount*CreditContainer.CREDIT);
				   }
				   }*/
			} else if (GameHolder.gameState == GameHolder.DOUBLE_STATE) {
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				updateState(GameHolder.gameState);
				GameHolder.cont.linesHolder.shown = false;
				
				spinEnabled = false;
				
				if (GameHolder.cont.freeSpinsState == false || (GameHolder.cont.freeSpinsState == true && GameHolder.cont.currentFreeSpinNum == GameHolder.cont.freeSpinsAmount)) {
					updateBalance(balanceAmount, true);
					resetWin(true);
				}
				
				TweenLite.delayedCall(0, GameHolder.cont.showSlotItemsForStates);
				
				GameHolder.cont.removeDoubleHolder();
				Root.connectionManager.sendData({MT: SocketAnaliser.collect, SID: "", IM: {"Color": -1}});
				
				GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS,'collect win','collect clicked');
				
				GameHolder.cont.machineHolder.stopIconsAnimation(true);
			}
		
		}
		
		public function spinStopDisable():void {
			if (spinEnabled == false && spinBtn.label == "STOP") {
				spinBtn.label = "SPIN";
				//spinBtn.alpha = 0.5
				//spinBtn.touchable = false;
				spinBtn.isEnabled = false;
				spinBtn.useHandCursor = false
				
				
				//$betSlider._isEnabled(spinBtn.isEnabled);
			}
		}
		
		public function onAutoSpinClick(e:Event):void {
			
			
			if (totalBetAmount > balanceAmount / GameSettings.CREDIT_VAL && GameHolder.gameState != GameHolder.DOUBLE_STATE) {
				if (balanceAmount > 4 && GameHolder.cont.freeSpinsState == false) 
				{
					GameHolder.gameState = GameHolder.NORMAL_STATE
					updateState(GameHolder.gameState);
					spinEnabled = true;
					
					while (GameSettings.TOTAL_LINES * Root.betsArray[GameSettings.BET_INDEX] * GameSettings.CREDIT_VAL > balanceAmount) 
					{
						if (GameSettings.BET_INDEX != 0) {
							GameSettings.BET_INDEX = GameSettings.BET_INDEX - 1;
							updateBet(GameSettings.BET_INDEX);
						}
						else
						{
							break;
						}
						
					}
					
					return;
				} else {
					if (GameHolder.cont.freeSpinsState == false) {
						GameHolder.cont.addCashier();
						return;
					}
				}
			}
			
			switch(GameHolder.gameState) {
				case GameHolder.NORMAL_STATE:
					
					if (spinEnabled == false)
					return;
				
					if (autoSpinAmount > 0) {
						GameHolder.gameState = GameHolder.AUTOPLAY_STATE;
						updateState(GameHolder.gameState);
						autoSpinFunction();
						spinEnabled = false;
						return;
					}
					
					autoSpinAmount = 9999999999;
					GameHolder.gameState = GameHolder.AUTOPLAY_STATE;
					updateState(GameHolder.gameState);
					autoSpinFunction();
					spinEnabled = false;
					
					GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS,'Auto spin','auto spin clicked');
					
					break;
					
				case GameHolder.DOUBLE_STATE:
					GameHolder.cont.showDoubleHolder(winAmount);
					Lines.cont.killDelayedCalls();
					GameHolder.cont.machineHolder.stopIconsAnimation(true);
					Root.soundManager.stopSound();
					MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_MUTE);
					GameHolder.cont.hideSlotItemsForStates();
					//$betSlider._isEnabled(false);
					Root.soundManager.PlaySound("options_click");
					autoSpinBtn.isEnabled = false
					autoSpinBtn.useHandCursor = false;
					break;
					
				case GameHolder.AUTOPLAY_STATE:
					Tracer._log('ssssssssssssssadasdsa' )
					GameHolder.gameState = GameHolder.NORMAL_STATE;
					updateState(GameHolder.gameState);
					autoSpinAmount = 0;
					
					break;
					
			}
			
		}
		
		//auto spin function
		public function autoSpinFunction():void {
			if (autoSpinAmount == 0 || GameHolder.gameState != GameHolder.AUTOPLAY_STATE) {
				if (GameHolder.cont.freeSpinsState && GameHolder.cont.currentFreeSpinNum > 0 && (GameHolder.cont.currentFreeSpinNum) != GameHolder.cont.freeSpinsAmount) {
					//es mere chavamate ragac atrakebda scaterze rames ro icherda cherdeboda
				} else {
					if (!Root.TESTING) {
						ExternalInterface.call("console.log", "aq ar unda shesuliyo")
					}
					;
					Tracer._log("aq ar unda shesuliyo");
					if (winAmount > 0) {
						GameHolder.gameState = GameHolder.DOUBLE_STATE;
					} else {
						GameHolder.gameState = GameHolder.NORMAL_STATE;
					}
					updateState(GameHolder.gameState);
					
					spinEnabled = true;
					return;
				}
			}
			
			onSpinClick(null);
			autoSpinAmount--;
		}
		
		//update state
		public function updateState(gameState:int):void {
			/*if (gameState >= 2)
			   spinTextMc.currentFrame = 0;
			   else
			   spinTextMc.currentFrame = gameState;
			 */
			spinBtn.isEnabled = true;
			spinBtn.useHandCursor = true;
			
			
			
			switch (gameState) {
				case GameHolder.NORMAL_STATE: 
					autoSpinBtn.label = "AUTO";
					
					spinBtn = StaticGUI._setButtonBitmapLabel(spinBtn,"SPIN", $spnObj.labelOffsetY, Assets.getFont("SPIN_FONT").name, -13, Assets.getFont("SPIN_FONT").size);
					//spinBtn.label = "SPIN";
					//$betSlider._isEnabled((false));
					
					break;
				
				case GameHolder.AUTOPLAY_STATE: 
					autoSpinBtn.label = "STOP";
					spinBtn.isEnabled = false;
					spinBtn.useHandCursor = false;
					
					//$betSlider._isEnabled(false);
					
					MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_DONT_MUTE);
					
					break;
				
				case GameHolder.DOUBLE_STATE: 
					//$betSlider._isEnabled(false);
					//autoSpinBtn.alpha = .5;
					spinBtn = StaticGUI._setButtonBitmapLabel(spinBtn,"COLLECT", $spnObj.labelOffsetY, Assets.getFont("SPIN_FONT").name, -8, 40);
					//spinBtn.label = "COLLECT";
					autoSpinBtn.label = "DOUBLE";
					
					break;
				
				case GameHolder.FREE_SPINS_STATE: 
					autoSpinBtn.label = "AUTO";
					spinBtn = StaticGUI._setButtonBitmapLabel(spinBtn,"SPIN", $spnObj.labelOffsetY, Assets.getFont("SPIN_FONT").name, -13, Assets.getFont("SPIN_FONT").size);
					//spinBtn.label = "SPIN";
					break;
			}
			//autoSpin_btn.title_mc.gotoAndStop(gameState + 1);
		
		}
		
		public function updateBalance(num:Number, animate:Boolean = false, altWin:Number = 0):void {
			this.balanceAmount = num;
			if (animate == false) {
				balanceTXT.text = BALANCE_TEXT+String(num);
				changeScoreTypes();
				TweenMax.killTweensOf(this);
				
			} else {
				_start = altWin == 0 ? balanceAmount : balanceAmount - altWin;
				_win = balanceAmount + winAmount;
				//Tracer._log(" winAmount/totalBetAmount/5 + 0.3 : " + (winAmount / totalBetAmount / 5 + 0.3));
				TweenMax.to(this, winAmount / totalBetAmount / 5 / GameSettings.CREDIT_VAL + 0.3, {_start: _win, onUpdate: updateBalanceAnimUpdate, ease: Circ.easeOut, onComplete: changeScoreTypes});
			}
		}
		
		private function updateBalanceAnimUpdate():void {
			balanceTXT.text = InLari == false ? BALANCE_TEXT + String(int(_start / GameSettings.CREDIT_VAL)) : BALANCE_TEXT + String((_start / 100).toFixed(2)) + " §";
		}
		
		public function updateWin(num:Number, freeSpinState:Boolean = false):void {
			if (freeSpinState) {
				this.freeSpinsWinAmount += num;
				winTXT.text = WIN_TEXT+String(freeSpinsWinAmount);
				
			} else {
				this.winAmount = num;
				winTXT.text = WIN_TEXT+String(winAmount);
			}
			
			changeScoreTypes();
		}
		
		public function resetWin(animate:Boolean = false):void {
			if (GameHolder.cont.freeSpinsState == true && GameHolder.cont.currentFreeSpinNum >= 0 && GameHolder.cont.currentFreeSpinNum != GameHolder.cont.freeSpinsAmount)
				return;
			
			if (winAmount == 0)
				return;
			
			GameHolder.cont.linesHolder.shown = false;
			
			if (animate == false) {
				winTXT.text = WIN_TEXT+"0";
				winAmount = 0;
				changeScoreTypes();
			} else {
				if (GameHolder.cont.freeSpinsState == true)
					_startWin = freeSpinsWinAmount;
				else
					_startWin = winAmount;
				
				if (_startWin > 0) {
					Root.soundManager.schedule("shot2", 0.3);
				}
				winAmount = 0;
				TweenMax.to(this, _startWin / totalBetAmount / 5 / GameSettings.CREDIT_VAL + 0.3, {_startWin: 0, onUpdate: resetWinAnimUpdate, ease: Circ.easeOut, onComplete: changeScoreTypes});
			}
		}
		
		private function resetWinAnimUpdate():void {
			winTXT.text = InLari == false ? WIN_TEXT+String(int(_startWin / GameSettings.CREDIT_VAL)) : WIN_TEXT+String((_startWin / 100).toFixed(2))
		}
		
		//on lines click
		private function onLinePlusMinusClick(e:MouseEvent):void {
			if (this.spinEnabled == false)
				return;
			
			if (e.params.currentTarget.name == "plus") {
				if (GameSettings.ACT_LINES + 1 <= 20)
					GameSettings.ACT_LINES++;
			} else if (e.params.currentTarget.name == "minus") {
				if (GameSettings.ACT_LINES - 1 > 0)
					GameSettings.ACT_LINES--;
			}
			updateLines(GameSettings.ACT_LINES);
		}
		
		//on bet click
		private function onBetPlusMinusClick(e:MouseEvent):void {
			if (this.spinEnabled == false)
				return;
			
			if (e.params.currentTarget.name == "plus") {
				if (GameSettings.BET_INDEX + 1 < Root.betsArray.length)
					GameSettings.BET_INDEX++;
			} else if (e.params.currentTarget.name == "minus") {
				if (GameSettings.BET_INDEX - 1 >= 0)
					GameSettings.BET_INDEX--;
			}
			updateBet(GameSettings.BET_INDEX);
		}
		
		//--max bet
		private function onMaxBetClick(e:MouseEvent):void {
			if (this.spinEnabled == false) {
				return;
			}
			if (GameSettings.BET_INDEX != Root.betsArray.length - 1) {
				GameSettings.BET_INDEX = Root.betsArray.length - 1;
				updateBet(GameSettings.BET_INDEX);
			} else {
				GameSettings.BET_INDEX = 0;
				updateBet(GameSettings.BET_INDEX);
			}
		}
		
		//---max lines
		private function onMaxLineClick(e:MouseEvent):void {
			if (this.spinEnabled == false) {
				return;
			}
			
			if (GameSettings.ACT_LINES != GameSettings.TOTAL_LINES) {
				GameSettings.ACT_LINES = GameSettings.TOTAL_LINES;
				updateLines(GameSettings.ACT_LINES);
			} else {
				GameSettings.ACT_LINES = 1;
				updateLines(GameSettings.ACT_LINES);
			}
		}
		
		public function updateLines(num:int):void {
			GameSettings.ACT_LINES = num;
			//linesTXT.text = "LINES: " + String(num);
			//dispatchEvent(new GameEvents(GameEvents.LINE_CHANGED, {activted: GameSettings.ACT_LINES}));
			updateTotalBet();
		}
		
		public function updateBet(index:Number):void {
			GameSettings.BET_INDEX = index;
			betTxt.text = betAttrStr + String(Root.betsArray[GameSettings.BET_INDEX]);
			updateTotalBet();
			
			GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS,'bet change','bet changed');
		}
		
		private function updateTotalBet():void {
			totalBetTXT.text = TOTALBET_TEXT+String(Root.betsArray[GameSettings.BET_INDEX] * GameSettings.ACT_LINES);
			totalBetAmount = Root.betsArray[GameSettings.BET_INDEX] * GameSettings.ACT_LINES;
			
			changeScoreTypes();
		}
		
		public function changeScoreTypes():void {
			
			lastWasLari = InLari;
			
			if (InLari) {
				balanceTXT.text = BALANCE_TEXT+String((balanceAmount / 100).toFixed(2)) + " §";
				totalBetTXT.text = TOTALBET_TEXT+String((totalBetAmount / 100 * GameSettings.CREDIT_VAL).toFixed(2));
				betTxt.text = betAttrStr + String((Root.betsArray[GameSettings.BET_INDEX] / 100 * GameSettings.CREDIT_VAL).toFixed(2));
				if (GameHolder.cont.freeSpinsState && GameHolder.cont.currentFreeSpinNum >= 0) {
					winTXT.text = WIN_TEXT+String((freeSpinsWinAmount / 100).toFixed(2));
				} else {
					winTXT.text = WIN_TEXT+String((winAmount / 100).toFixed(2));
				}
			} else {
				balanceTXT.text = BALANCE_TEXT+String(int(balanceAmount / GameSettings.CREDIT_VAL));
				totalBetTXT.text = TOTALBET_TEXT+String(totalBetAmount);
				betTxt.text = betAttrStr + String(Root.betsArray[GameSettings.BET_INDEX]);
				if (GameHolder.cont.freeSpinsState && GameHolder.cont.currentFreeSpinNum >= 0) {
					winTXT.text = WIN_TEXT+String(int(freeSpinsWinAmount / GameSettings.CREDIT_VAL));
				} else {
					winTXT.text = WIN_TEXT+String(int(winAmount / GameSettings.CREDIT_VAL));
				}
			}
			
		}
		
		//spin enabled
		public function get spinEnabled():Boolean {
			return _spinEnabled;
		}
		
		public function set spinEnabled(value:Boolean):void {
			if (value == true) {
				if (GameHolder.cont.freeSpinsState == true && GameHolder.cont.currentFreeSpinNum > 0 && GameHolder.cont.currentFreeSpinNum != GameHolder.cont.freeSpinsAmount) {
					return;
				}
				
				
				switch(GameHolder.gameState) {
					
					case GameHolder.AUTOPLAY_STATE:
						autoSpinBtn.isEnabled = true;
						autoSpinBtn.useHandCursor = true;
						break;
						
					case GameHolder.NORMAL_STATE:
						spinBtn.isEnabled = true;
						spinBtn.useHandCursor = true;
						
						autoSpinBtn.isEnabled = true
						autoSpinBtn.useHandCursor = true;
						
						if (GameHolder.cont.freeSpinsState == false) {
							/*maxLinesBtn.alpha = 1;
							maxLinesBtn.mouseEnabled = true;
							maxBetBtn.alpha = 1;
							maxBetBtn.mouseEnabled = true;*/
							//lineButs.alpha = 1;
							//lineButs.mouseEnabled = true;
							
							creditHolder.alpha = 1;
							creditHolder.touchable = true;
							
							betButs.alpha = 1;
							betButs.mouseEnabled = true;
						}
						
						break;
						
					case GameHolder.AUTOPLAY_STATE:
						
						break;
						
					case GameHolder.DOUBLE_STATE:
						spinBtn.isEnabled = true;
						spinBtn.useHandCursor = true;
						autoSpinBtn.isEnabled = true;
						autoSpinBtn.useHandCursor = true;
						
						break;
					
				}
				
			} else {
				spinBtn.isEnabled = false;
				spinBtn.useHandCursor = false
				autoSpinBtn.isEnabled = false;
				autoSpinBtn.useHandCursor = false;
				/*maxLinesBtn.alpha = 0.5;
				   maxLinesBtn.mouseEnabled = false;
				   maxBetBtn.alpha = 0.5;
				   maxBetBtn.mouseEnabled = false;*/
				   //lineButs.alpha = 0.5;
				   //lineButs.mouseEnabled = false;
				   
				   betButs.alpha = 0.5;
				   betButs.mouseEnabled = false;
				   
				   creditHolder.alpha = 0.5;
				   creditHolder.touchable = false;
				
				if (!_bonusGame && GameHolder.gameState == GameHolder.AUTOPLAY_STATE && GameHolder.cont.freeSpinsState == false) {
					autoSpinBtn.isEnabled = true;
					autoSpinBtn.useHandCursor = true;
					
				}
				
				if (!_bonusGame && GameHolder.gameState == GameHolder.NORMAL_STATE) {
					spinBtn.isEnabled = true;
					spinBtn.useHandCursor = true;
				}
				
			}
			_spinEnabled = value;
		}
	
	}
}