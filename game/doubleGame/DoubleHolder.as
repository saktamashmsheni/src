package game.doubleGame {
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.utils.GoogleAnalytics;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import connection.SocketAnaliser;
	import feathers.controls.Button;
	import feathers.controls.TextArea;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import game.doubleGame.Card;
	import game.footer.FooterHolder;
	import game.header.musicPlayer.MusicManager;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	import starling.utils.Align;
	import starling.utils.Align;
	
	
	public class DoubleHolder extends Sprite {
		private var start_txt:BitmapFontTextRenderer;
		private var nextWin_txt:BitmapFontTextRenderer;
		private var nextWinDouble_txt:BitmapFontTextRenderer;
		
		private var $redBtn:Button;
		private var $blackBtn:Button;
		private var $halfBtn:Button;
		private var $collectBtn:Button;
		
		private var bg:Image;
		private var histBgCon:Sprite;
		private var histCard:Card;
		private var cardMc:Card;
		private var history_con:Sprite;
		private var $suitCont:Sprite; 
		private var pp:Sprite;
		public static var maxWinCount:int = 1;
		private var selectedColor:Number;
		private var winCount:int;
		private var gameAmountTXT:BitmapFontTextRenderer;
		private var toWinTXT:BitmapFontTextRenderer;

		private var histBgImg:Image;
		private var $atlas:TextureAtlas;
		private var $suitBtnVector:Array;
		private var iMask:Quad;
		private var toWinDoubledTXT:BitmapFontTextRenderer;
		
		public function DoubleHolder(pp:Sprite) {
			this.visible = false;
			this.pp = pp;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			initDouble();
		}
		
		private function removed(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			if ($redBtn) $redBtn.removeEventListener( Event.TRIGGERED, onColorClick );
			if ($blackBtn) $blackBtn.removeEventListener( Event.TRIGGERED, onColorClick );
			if ($halfBtn) $halfBtn.removeEventListener( Event.TRIGGERED, onHalfClick );
			if ($collectBtn) $collectBtn.removeEventListener( Event.TRIGGERED, onCollectClick );
			
			for (var i:uint = 0; i < 4; i++) {
				if ($suitBtnVector[i])$suitBtnVector[i].removeEventListener( MouseEvent.CLICK, onSuitClick );
			}
			
			this.removeChildren();
		}
		
		private function initDouble():void {
			
			
			GoogleAnalytics._sendScreenView('Double game');
			
			$atlas = Assets.getAtlas("doubleSheet", "doubleSheetXml");
			
			var quad:Quad = new Quad(757, 424, Color.BLACK);
			quad.alpha = .9;
			quad.alignPivot(Align.CENTER, Align.CENTER);
			quad.x = 25;
			quad.y = 5;
			addChild(quad);
			
			
			bg = new Image($atlas.getTexture("double_bg.jpg"));
			bg.pivotX = int(bg.width / 2);
			bg.pivotY = int(bg.height / 2);
			//bg.alignPivot(Align.CENTER, Align.CENTER);
			bg.x = 22;
			
			addChild(bg);
			
			gameAmountTXT = StaticGUI._creatBitmapFontTextRenderer(this, "GAMBLE AMOUNT", -175, -140, 300, 40, Assets.getFont("double_roboto_bold").name, TextFormatAlign.CENTER, false,-10);
			gameAmountTXT.pivotX = int(gameAmountTXT.width / 2);
			
			
			
			start_txt = StaticGUI._creatBitmapFontTextRenderer(this, "0", -175, -115, 500, 40, Assets.getFont("double_roboto_bold_nums").name, TextFormatAlign.CENTER, false, -10,-1, 0, 0x78d341);
			start_txt.pivotX = int(start_txt.width / 2);
			
			
			
			toWinTXT = StaticGUI._creatBitmapFontTextRenderer(this, "RED/BLACK WINS", 222, -140, 300, 40, Assets.getFont("double_roboto_bold").name, TextFormatAlign.CENTER, false,-10);
			toWinTXT.pivotX = int(toWinTXT.width / 2);
			
			
			
			nextWin_txt = StaticGUI._creatBitmapFontTextRenderer(this, "0", 222, -115, 500, 40, Assets.getFont("double_roboto_bold_nums").name, TextFormatAlign.CENTER, false, -10,-1);
			nextWin_txt.pivotX = int(nextWin_txt.width / 2);
			
			
			toWinDoubledTXT = StaticGUI._creatBitmapFontTextRenderer(this, "SUIT WINS", 222, 75, 300, 40, Assets.getFont("double_roboto_bold").name, TextFormatAlign.CENTER, false,-10);
			toWinDoubledTXT.pivotX = int(toWinDoubledTXT.width / 2);
			
			
			nextWinDouble_txt = StaticGUI._creatBitmapFontTextRenderer(this, "0", 222, 100, 500, 40, Assets.getFont("double_roboto_bold_nums").name, TextFormatAlign.CENTER, false, -10,-1, 0, 0xd30808);
			nextWinDouble_txt.pivotX = int(nextWinDouble_txt.width / 2);
			
			var $btnPropObj:Object = new Object;
			//$btnPropObj.text = 'RED';
			$btnPropObj.xPos = -175;
			$btnPropObj.yPos = -27;
			
			$btnPropObj.font = '_robotoBlack';
			$btnPropObj.textSize = 24;
			$btnPropObj.textColor = 0xffffff;
			$btnPropObj.embedFonts = true;
			$btnPropObj.labelOffsetY = -5;
			
			var $btnTextShadow:Object = new Object;
			$btnTextShadow.blurX = 2;
			$btnTextShadow.blurY = 2;
			$btnTextShadow.distance = 2;
			$btnTextShadow.color = 0x020202;
			$btnTextShadow.alpha = .65;
			$btnTextShadow.angle = 90;
			$btnTextShadow.quality = 3;
			
			$redBtn = StaticGUI._setButtonWithLabelShadow(this,
													$btnPropObj, 
							   $atlas.getTexture("red_btn_1.png"), 
							   $atlas.getTexture("red_btn_2.png"), 
							   $atlas.getTexture("red_btn_1.png"), null,
							   //$atlas.getTexture("red_btn_disabled.png"),
												 $btnTextShadow);

			$btnPropObj.xPos = 215;
			//$btnPropObj.text = 'BLACK';
			$blackBtn = StaticGUI._setButtonWithLabelShadow(this, 
													  $btnPropObj, 
							   $atlas.getTexture("black_btn_1.png"), 
							   $atlas.getTexture("black_btn_2.png"), 
							   $atlas.getTexture("black_btn_1.png"), null,
							   //$atlas.getTexture("black_btn_disabled.png"),
												   $btnTextShadow);
			
			$btnPropObj.xPos = -70;
			$btnPropObj.yPos = 180;
			//$btnPropObj.text = 'HALF';
			$btnPropObj.textColor = 0x000000;
			$btnPropObj.labelOffsetY = -8;
			
			$btnTextShadow.color = 0xffffff;
			$btnTextShadow.distance = 1;
			$btnTextShadow.alpha = .33;
			$btnTextShadow.blurX = 1;
			$btnTextShadow.blurY = 1;
			$halfBtn = StaticGUI._setButtonWithLabelShadow(this, 
													 $btnPropObj,
							   $atlas.getTexture("half_btn_1.png"), 
							   $atlas.getTexture("half_btn_2.png"), 
							   $atlas.getTexture("half_btn_3.png"), null,
							   //$atlas.getTexture("half_btn_disabled.png"),
												  $btnTextShadow);
			$halfBtn.addEventListener( Event.TRIGGERED, onHalfClick );
									  
			//$btnPropObj.text = 'COLLECT';
			$btnPropObj.xPos = 120;
			$collectBtn = StaticGUI._setButtonWithLabelShadow(this, 
														$btnPropObj,
							   $atlas.getTexture("collect_btn_1.png"), 
							   $atlas.getTexture("collect_btn_2.png"), 
							   $atlas.getTexture("collect_btn_3.png"), null,
							   //$atlas.getTexture("collect_btn_disabled.png"),
													 $btnTextShadow);
										 
			$collectBtn.addEventListener( Event.TRIGGERED, onCollectClick );
			
			histBgCon = new Sprite();
			histBgCon.x = -15;
			histBgCon.y = -165;
			histBgImg;
			/*for (var i:int = 0; i < 9; i++) {
				histBgImg = new Image($atlas.getTexture("history_card_bg.png"));
				histBgImg.x = i * (histBgImg.width + 8);
				histBgCon.addChild(histBgImg);
				histBgImg = null;
			}
			addChild(histBgCon);*/
			
			cardMc = new Card();
			cardMc.scaleX = cardMc.scaleY = 1.1;
			cardMc.y = -5;
			cardMc.x = 24;
			addChild(cardMc);
			
			history_con = new Sprite();
			history_con.x = histBgCon.x;
			history_con.y = histBgCon.y;
			addChild(history_con);
			
			$suitCont = new Sprite;
			addChild($suitCont);
			
				
				
			var $suitServerVect:Vector.<int> = new Vector.<int>;
			$suitServerVect.push(4, 3, 5, 2);
			$suitBtnVector = [];
			
			var $suitsArray:Vector.<String> = new Vector.<String>;
			$suitsArray.push("suit_hearts_btn");
			$suitsArray.push("suit_diamon_btn");
			$suitsArray.push("suit_spades_btn");
			$suitsArray.push("suit_club_btn");
			
			var suitBtn:MyButton;
			
			
			var suirPostAr:Array = [new Point(-234, 0), new Point(-170, 0), new Point(160, 0), new Point(220, 0)];
			
			for (var i:int = 0; i < 4; i++) 
			{
				suitBtn = new MyButton($atlas.getTextures($suitsArray[i]));
				suitBtn.name = 'suitBtn_' + $suitServerVect[i];
				suitBtn.addEventListener(MouseEvent.CLICK, onSuitClick);
				
				suitBtn.x = suirPostAr[i].x;
				suitBtn.y = suirPostAr[i].y;
				addChild(suitBtn);
				
				$suitBtnVector.push(suitBtn);
			}
			
			suitBtn = null;
			
			
			
			$redBtn.addEventListener( Event.TRIGGERED, onColorClick );
			$blackBtn.addEventListener( Event.TRIGGERED, onColorClick );
			
			
			
			iMask = new Quad(820, 436);
			iMask.color = Color.RED;
			iMask.alpha = .5;
			iMask.pivotX = int(iMask.width / 2);
			iMask.pivotY = int(iMask.height / 2);
			addChild(iMask);
			this.mask = iMask;
		}
		
		private function onHalfClick(e:Event):void {
			Root.soundManager.PlaySound("options_click");
			_btnStatus(false);
			Root.connectionManager.sendData({MT: SocketAnaliser.doubleGameHalf, SID: "", IM: {"Type": GameSettings.CREDIT_AR[GameSettings.CREDIT_INDEX]}});
			
			GoogleAnalytics._sendActionEvent('Double game','half','halfed clicked');
		}
		
		private function onCollectClick(e:Event):void {
			_btnStatus(false);
			FooterHolder.cont.onSpinClick(null);
			//TweenLite.delayedCall(.2, GameHolder.cont.showSlotItemsForStates);
			
			GoogleAnalytics._sendActionEvent('Double game', 'collected' ,'collect clicked');
		}
		
		private function onSuitClick(e:MouseEvent):void {
			_btnStatus(false);
			Root.soundManager.PlaySound("options_click");
			
			var $nameArr:Array = e.params.currentTarget.name.split('_');
			var $suitColor:int = parseInt($nameArr[1]);
			selectedColor = $suitColor;
			Root.connectionManager.sendData({MT: SocketAnaliser.collect, SID: "", IM: {"Color": selectedColor}});
			
			GoogleAnalytics._sendActionEvent('Double game','suit: '+String($suitColor) ,'suit clicked');
			
		}
		
		private function onColorClick(e:Event):void {
			Root.soundManager.PlaySound("options_click");
			
			if (e.currentTarget == $blackBtn) {
				selectedColor = 0;
				Root.connectionManager.sendData({MT: SocketAnaliser.collect, SID: "", IM: {"Color": 0}});
			} else if (e.currentTarget == $redBtn) {
				selectedColor = 1;
				Root.connectionManager.sendData({MT: SocketAnaliser.collect, SID: "", IM: {"Color": 1}});
			}
			
			_btnStatus(false);
			
			GoogleAnalytics._sendActionEvent('Double game','color: '+String(selectedColor) ,'color clicked');
		}
		
		public function _btnStatus(stBoo:Boolean):void{
			
			$redBtn.isEnabled = stBoo;
			$blackBtn.isEnabled = stBoo;
			$halfBtn.isEnabled = stBoo;
			$collectBtn.isEnabled = stBoo;
			
			for (var i:uint = 0; i < 4; i++) {
				if ($suitBtnVector[i])$suitBtnVector[i].mouseEnabled = stBoo;
			}
		}
		
		public function show(winAmount:Number):void {
			if (this.visible != true) {
				this.visible = true;
				init();
				start_txt.text = String(StaticGUI.modifiedBalanceString(winAmount));
				nextWin_txt.text = String(StaticGUI.modifiedBalanceString(winAmount*2));
				nextWinDouble_txt.text = String(StaticGUI.modifiedBalanceString(winAmount*4));
				
				
				
				cardMc.makeFaceDown();
				
				var i:int = 0;
				//winStatus_txt.text = "";
				/*for (var i:int = 0; i < this.numChildren; i++) {
					TweenLite.from(getChildAt(i), 0.6, {delay: i * 0.05, scaleY: 1.1, scaleX: 1.1, ease: Expo.easeOut})
				}*/
				
				TweenLite.from(this, 0.5, {delay: 0, y:-500, ease: Expo.easeOut})
				TweenLite.from(iMask, 0.5, {delay: 0, y:500, ease: Expo.easeOut})
				
				Root.soundManager.PlaySound("double");
				
				for (i = 0; i < GameHolder.cont.histArray.length; i++) {
					if (i == 9) {
						break;
					}
					
					histCard = GameHolder.cont.histArray[GameHolder.cont.histArray.length - (i + 1)]
					histCard.x = i * 37 - 116;
					histCard.y = -20;
					history_con.addChild(histCard);
					//histCard.scaleX = histCard.scaleY = .19;
					
					
				}
				
			} else {
				//hide();
			}
		}
		
		private function init():void {
			winCount = 0;
			cardMc.makeFaceDown();
			var children:int = history_con.numChildren;
			while (children--) {
				StaticGUI.safeRemoveChild(history_con.getChildAt(children));
			}
		}
		
		public function updateHalf(obj:Object):void{
			_btnStatus(true);
			
			FooterHolder.cont.updateBalance(obj.Chips);
			FooterHolder.cont.updateWin(obj.Amount);
			if (!obj.CanHalf){
				$halfBtn.isEnabled = false;
			}
			
			start_txt.text = String(StaticGUI.modifiedBalanceString(obj.Amount));
			nextWin_txt.text = String(StaticGUI.modifiedBalanceString(obj.Amount*2));
			nextWinDouble_txt.text = String(StaticGUI.modifiedBalanceString(obj.Amount*4));
			//TweenLite.delayedCall(2, nextTryInit);
			
		}
		
		public function update(obj:Object):void {
			if (obj.Win > 0) {
				winCount++;
				
				if (obj.DoubleEnd != true) {
					start_txt.text = String(StaticGUI.modifiedBalanceString(obj.Win));
					nextWin_txt.text = String(StaticGUI.modifiedBalanceString(obj.Win*2));
					nextWinDouble_txt.text = String(StaticGUI.modifiedBalanceString(obj.Win*4));
					TweenLite.delayedCall(2, nextTryInit);
				}
				
				//winStatus_txt.text = "YOU WIN";
				Root.soundManager.schedule("gadavebaMogeba", 0.6);
				
			} else {
				start_txt.text = "0";
				nextWin_txt.text = "0";
				nextWinDouble_txt.text = "0";
				
				//winStatus_txt.text = "YOU LOSE";
				Root.soundManager.schedule("gadavebaWageba", 0.6);
			}
			
			
			for (var j:int = 0; j < history_con.numChildren; j++) {
				StaticGUI.safeRemoveChild(history_con.getChildAt(j));
			}
			
			histCard = new Card(obj.Card, true);
			
			histCard.alpha = 1;
			histCard.makeFaceUp();
			GameHolder.cont.histArray.push(histCard);
			
			
			
			for (var i:int = 0; i < GameHolder.cont.histArray.length; i++) {
				
				if (i == 9) {
					break;
				}
				
				histCard = GameHolder.cont.histArray[GameHolder.cont.histArray.length - (i + 1)]
				histCard.x = i * 37 - 116;
				histCard.y = -20;
				history_con.addChild(histCard);
				//histCard.scaleX = histCard.scaleY = .19;
				
				
			}
			
			cardMc.setValue(obj.Card);
			cardMc.makeFaceUp();
			
			if (obj.DoubleEnd) {
				GameHolder.cont.updateFromDoubleGame(obj.Win, obj.DoubleEnd);
				TweenLite.delayedCall(1, GameHolder.cont.showSlotItemsForStates);
			} else {
				GameHolder.cont.updateFromDoubleGame(obj.Win);
			}
		}
		
		private function nextTryInit():void {
			//winStatus_txt.text = "";
			cardMc.makeFaceDown();
			$redBtn.touchable = true;
			$blackBtn.touchable = true;
			$redBtn.alpha = 1;
			$blackBtn.alpha = 1;
			_btnStatus(true);
		}
		
		public function hide():void {
			disposeAll();
		}
		
		public function disposeAll():void {
			TweenLite.killDelayedCallsTo(nextTryInit);
			StaticGUI.safeRemoveChild(bg);
			StaticGUI.safeRemoveChild(gameAmountTXT);
			StaticGUI.safeRemoveChild(toWinTXT);
			StaticGUI.safeRemoveChild(start_txt);
			StaticGUI.safeRemoveChild(nextWin_txt);
			StaticGUI.safeRemoveChild(nextWin_txt);
			StaticGUI.safeRemoveChild(cardMc);
			StaticGUI.safeRemoveChild(toWinDoubledTXT);
			
			$redBtn.removeEventListener(MouseEvent.CLICK, onColorClick);
			$blackBtn.removeEventListener(MouseEvent.CLICK, onColorClick);
			StaticGUI.safeRemoveChild($redBtn);
			StaticGUI.safeRemoveChild($blackBtn);
			for (var j:int = 0; j < histBgCon.numChildren; j++) {
				StaticGUI.safeRemoveChild(histBgCon.getChildAt(j));
			}
			StaticGUI.safeRemoveChild(histBgCon);
			StaticGUI.safeRemoveChild(this);
			histCard = null;
			bg = null;
			gameAmountTXT = null;
			toWinTXT = null;
			toWinDoubledTXT = null;
			start_txt = null;
			nextWin_txt = null;
			nextWin_txt = null;
			cardMc = null;
			$redBtn = null;
			$blackBtn = null;
			histBgCon = null;
			MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_MUTE_ONDELAY);
		}
		
		
		public function modifyCardsOnReconnect(cardsAr:Array):void 
		{
			var i:int = 0;
			for (i = 0; i < cardsAr.length; i++) {
				histCard = new Card(cardsAr[i], true);
				histCard.x = i * 37 - 116;
				histCard.y = -20;
				history_con.addChild(histCard);
				//histCard.scaleX = histCard.scaleY = .19;
				GameHolder.cont.histArray.push(histCard);
				histCard.makeFaceUp();
				
				if (i == 9) {
					break;
				}
			}
		}
	
	}

}