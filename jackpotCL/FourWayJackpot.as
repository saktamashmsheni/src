package jackpotCL {
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import flash.geom.Point;
	import starling.display.MovieClip;
	import starling.display.Quad;
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class FourWayJackpot extends Sprite {
		private var brinjao_mc:Button;
		private var vercxli_mc:Sprite;
		private var oqro_mc:Sprite;
		private var platina_mc:Sprite;
		private var $bannersArray:Array;
		public static var cont:FourWayJackpot;
		public var _start:int;
		public var brinVal:int = 0;
		public var vercVal:int = 0;
		public var oqrVal:int = 0;
		public var platVal:int = 0;
		public var butHolder:Sprite
		public static var colorsAr:Array = [0xaf6c2b, 0x868686, 0xf3be08, 0xededed];
		private var lastInfoAr:Array;
		private var info_mc:Sprite;
		private var win_mc:Sprite;
		private var infoBg:MovieClip;
		
		public function FourWayJackpot() {
			//this.visible = false;////////////////////////////////////
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			this.alignPivot(Align.CENTER, Align.CENTER);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			cont = this;
			initFourWayJack();
			//info_mc.visible = false;
			//win_mc.visible = false;
		}
		
		private function initFourWayJack():void {
			
			var tt:TextFieldTextRenderer;
			var tt2:BitmapFontTextRenderer;
			
			
			var $textureAtlas:TextureAtlas = Assets.getAtlas("fourJackpotSheet", "fourJackpotSheetXml");
			
			var jackBg:Image = new Image($textureAtlas.getTexture("4jackbg.png"));
			addChild(jackBg);
			StaticGUI.setAlignPivot(jackBg);
			jackBg.y = -70;
			jackBg.touchable = false;
			
			
			butHolder = new Sprite;
			addChild(butHolder);
			
			brinjao_mc = setWinBanners('', -380, -82, null, 0x000000, -4);
			brinjao_mc.name = 'banner_1';
			vercxli_mc = setWinBanners('', -230, brinjao_mc.y, null, 0x000000, -4);
			vercxli_mc.name = 'banner_2';
			oqro_mc = setWinBanners('', 200, brinjao_mc.y, null, 0x000000, -4);
			oqro_mc.name = 'banner_3';
			platina_mc = setWinBanners('', 350, brinjao_mc.y, null, 0x000000, -4);
			platina_mc.name = 'banner_4';
			
			$bannersArray = [brinjao_mc, vercxli_mc, oqro_mc, platina_mc];
			
			var $textShadow:Object = new Object;
			$textShadow.blurX = 6;
			$textShadow.blurY = 6;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = 1;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			info_mc = new Sprite();
			info_mc.touchable = false;
			info_mc.x = -200;
			info_mc.y = -300;
			//info_mc.y =0;
			info_mc.alpha = 0;
			
			
			infoBg = new MovieClip($textureAtlas.getTextures("pop_jackpot_"));
			
			infoBg.currentFrame = 0;
			infoBg.pivotX = int(infoBg.width / 2);
			infoBg.pivotY = 10;
			//infoBg.pivotY = int(infoBg.height / 2);
			info_mc.addChild(infoBg);
			
			tt = StaticGUI._creatTextFieldTextRenderer(info_mc, 'მაქსიმალური მოგება:', -100, 40, 200, 20, '_bpgGELDejaVuSerifCaps', 11, 0xd7c294, $textShadow, TextFormatAlign.CENTER);
			tt.name = 'maxWin_txt';
			
			//tt.border = true;
			
			tt = StaticGUI._creatTextFieldTextRenderer(info_mc, '0-0-0', -100, 55, 200, 20, '_bpgGELDejaVuSerifCaps', 13, 0xd7c294, $textShadow, TextFormatAlign.CENTER);
			tt.name = 'maxWinDate_txt';
			
			tt2 = StaticGUI._creatBitmapFontTextRenderer(info_mc, 'e2512.25', -100, 70, 200, 20, Assets.getFont("bpgGELDejaVuSerifCaps_bitmapFont").name, TextFormatAlign.CENTER);
			tt2.name = "maxWinVal_txt";
			
			tt = StaticGUI._creatTextFieldTextRenderer(info_mc, 'მოგებული მოთამაშეების<br/>რაოდენობა:', -100, 125, 200, 100, '_bpgGELDejaVuSerifCaps', 11, 0xd7c294, $textShadow, TextFormatAlign.CENTER, true);
			tt.name = "totalWinners_txt";
			
		
			tt = StaticGUI._creatTextFieldTextRenderer(info_mc, '0', -100, 160, 200, 50, '_bpgGELDejaVuSerifCaps', 18, 0xf1d92b, $textShadow, TextFormatAlign.CENTER);
			tt.name = "totalWinnersVal_txt";
			
			tt = StaticGUI._creatTextFieldTextRenderer(info_mc, 'ბოლო მოგებული:', -100, 195, 200, 20, '_bpgGELDejaVuSerifCaps', 11, 0xd7c294, $textShadow, TextFormatAlign.CENTER);
			tt.name = "lastWin_txt";
			
			tt = StaticGUI._creatTextFieldTextRenderer(info_mc, '0-0-0', -100, 210, 200, 20, '_bpgGELDejaVuSerifCaps', 13, 0xd7c294, $textShadow, TextFormatAlign.CENTER);
			tt.name = "lastWinDate_txt";
			
			tt2 = StaticGUI._creatBitmapFontTextRenderer(info_mc, 'e256.25', -100, 225, 200, 20, Assets.getFont("bpgGELDejaVuSerifCaps_bitmapFont").name, TextFormatAlign.CENTER);
			tt2.name = "lastWinVal_txt";
			
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 1;
			$textShadow.color = 0xfff367;
			$textShadow.alpha = 1;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			win_mc = new Sprite();
			win_mc.y = this.y - 15;
			win_mc.x = -300;
			win_mc.touchable = false;
			
			var winBg:Image = new Image($textureAtlas.getTexture("jackpot_win_bg.png"));
			win_mc.addChild(winBg);
			win_mc.pivotX = int(infoBg.width / 2);
			win_mc.pivotY = 0;
			//win_mc.x = brinjao_mc.x+60;
			//win_mc.alignPivot(Align.CENTER, Align.TOP);
			tt = StaticGUI._creatTextFieldTextRenderer(win_mc, 'გათამაშდა', 0, 23, win_mc.width, 20, '_bpgGELDejaVuSerifCaps', 13, 0x17130b, $textShadow, TextFormatAlign.CENTER);
			
			tt.name = "val_txt";
				   
				    
		}
		
		private function setWinBanners(text:String, xPos:int, yPos:int, texture:Texture, shadowColor:uint, labelYOffset:int = 0):Button {
			var $btn:Button = new Button();
			//$btn.minTouchWidth = 500 
			$btn.isQuickHitAreaEnabled = true;
			//$btn.minTouchHeight = 50
			
			$btn.x = xPos;
			$btn.y = yPos;
			if (texture != null)
			{
				$btn.defaultSkin = new Image(texture);
			}
			$btn.addEventListener(TouchEvent.TOUCH, handleTouch);
			$btn.label = text;
			$btn.useHandCursor = true;
			$btn.labelFactory = function():ITextRenderer {
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = new TextFormat("_AvenirNextBold", 14, 0xffffff);
				textRenderer.embedFonts = true;
				
				return textRenderer;
			}
			$btn.defaultLabelProperties.nativeFilters = [new DropShadowFilter(1, 90, shadowColor, .7, 1, 2)];
			$btn.labelOffsetY = labelYOffset;
			
			$btn.validate();
			$btn.alignPivot(Align.CENTER, Align.CENTER);
			butHolder.addChild($btn);
			
			return $btn;
		}
		private var over:Boolean;
		private function handleTouch(e:TouchEvent):void {
			
			//if (Root.TESTING) return;
			
			var overTouch:Touch = e.getTouch(Button(e.target), TouchPhase.HOVER);
			
			if (overTouch){
				if (!over) {
					
					this.parent.addChild(info_mc);
					onItemsOver(Button(e.target));
					over = true;
				}
				
				
			}else {
				over = false;
				onItemsOut(Button(e.target));
			}
			
		}
		
		private function onItemsOut(target:Button):void {
			TweenLite.to(info_mc, 0.2, {delay: 0.4, autoAlpha: 0});
		}
		
		private function onItemsOver(target:Button):void {
			
			TextFieldTextRenderer(info_mc.getChildByName("maxWin_txt")).text = GameSettings.GAME_XML.fourWayJackpot.maxwin;
			TextFieldTextRenderer(info_mc.getChildByName("totalWinners_txt")).text = GameSettings.GAME_XML.fourWayJackpot.winNum;
			TextFieldTextRenderer(info_mc.getChildByName("lastWin_txt")).text = GameSettings.GAME_XML.fourWayJackpot.last;
			
			var ind:int = $bannersArray.indexOf(target);
			//TextField(info_mc.getChildByName("maxWinVal_txt")).color = colorsAr[ind];
			//TextField(info_mc.getChildByName("totalWinnersVal_txt")).color = colorsAr[ind];
			//TextField(info_mc.getChildByName("lastWinVal_txt")).color = colorsAr[ind];
			infoBg.currentFrame = ind;
			info_mc.visible = true;
			TweenLite.killTweensOf(info_mc);
			TweenLite.to(info_mc, 0.4, {autoAlpha: 1, x: target.x + 20, ease: Expo.easeInOut});
			
			if (String(retunCurAr(ind + 1)[8]) != "0001-01-01") {
				TextFieldTextRenderer(info_mc.getChildByName("maxWinDate_txt")).text = retunCurAr(ind + 1)[8];
				BitmapFontTextRenderer(info_mc.getChildByName("maxWinVal_txt")).text = (retunCurAr(ind + 1)[3] / 100).toFixed(2) + " e";
			} else {
				TextFieldTextRenderer(info_mc.getChildByName("maxWinDate_txt")).text = "0-0-0";
				BitmapFontTextRenderer(info_mc.getChildByName("maxWinVal_txt")).text = "0.00e";
			}
			
			TextFieldTextRenderer(info_mc.getChildByName("totalWinnersVal_txt")).text = retunCurAr(ind + 1)[5];
			
			if (String(retunCurAr(ind + 1)[7]) != "0001-01-01") {
				TextFieldTextRenderer(info_mc.getChildByName("lastWinDate_txt")).text = retunCurAr(ind + 1)[7];
				BitmapFontTextRenderer(info_mc.getChildByName("lastWinVal_txt")).text = (retunCurAr(ind + 1)[4] / 100).toFixed(2) + " e";
			} else {
				TextFieldTextRenderer(info_mc.getChildByName("lastWinDate_txt")).text = "0-0-0";
				BitmapFontTextRenderer(info_mc.getChildByName("lastWinVal_txt")).text = "0.00e";
			}
		}
		
		public function updateInfo(arr:Array, obj:Object):void {
			
			lastInfoAr = arr;

			if (obj.Win != null) {
				   this.parent.addChild(win_mc);
				   TextFieldTextRenderer(win_mc.getChildByName("val_txt")).text = GameSettings.GAME_XML.fourWayJackpot.winNow;
				   win_mc.visible = true;
				  //win_mc.x = returnMovieClip(obj.Win.JpID).x;
				   TweenMax.from(win_mc, 0.8, {alpha: 1, scaleX: 0, scaleY: 0, ease: Elastic.easeOut});
				   TweenMax.to(win_mc, .8, {x: returnMovieClip(obj.Win.JpID).x+20, ease: Elastic.easeOut});
			} else {
				preApdAn(arr);
			}
		}
		
		public function preApdAn(arr:Array):void {
		
			win_mc.visible = false;
			for (var i:int = 0; i < arr.length; i++) {
				{
					animate(arr, arr[i][0] - 1, arr[i]);
				}
			}
		}
		
		public function animate(arr:Array, num:int, currentAr:Array):void {
			$bannersArray[num].scaleX = 1;
			$bannersArray[num].scaleY = 1;
			
			
			TweenMax.to($bannersArray[num], 0.4, {scaleX: 1.1, scaleY: 1.1, ease: Expo.easeInOut, repeat: 1, yoyo: true, delay: (0)});
			
			switch (num) {
				case 0: 
					TweenMax.to(this, 1, {brinVal: Number(currentAr[1]), onUpdate: animUpdate, onUpdateParams: [num], ease: Linear.easeNone});
					break;
				case 1: 
					TweenMax.to(this, 1, {vercVal: Number(currentAr[1]), onUpdate: animUpdate, onUpdateParams: [num], ease: Linear.easeNone});
					break;
				case 2: 
					TweenMax.to(this, 1, {oqrVal: Number(currentAr[1]), onUpdate: animUpdate, onUpdateParams: [num], ease: Linear.easeNone});
					break;
				case 3: 
					TweenMax.to(this, 1, {platVal: Number(currentAr[1]), onUpdate: animUpdate, onUpdateParams: [num], ease: Linear.easeNone});
					break;
			}
			
			TweenLite.delayedCall(1, resetScaleAfterDelayedCall);
		}
		
		private function resetScaleAfterDelayedCall():void {
			for (var i:int = 0; i < 4; i++) {
				$bannersArray[i].scaleX = 1;
				$bannersArray[i].scaleY = 1;
			}
		}
		
		public function animUpdate(num:int):void {
			
			var $b:Button = this.$bannersArray[num] as Button;
			$b.label = String((returnVal(num) / 100).toFixed(2));
			//TextField(this.$bannersArray[num].label("val_txt")).text = String((returnVal(num) / 100).toFixed(2)) + " e";
		}
		
		public function returnVal(num:int):int {
			switch (num) {
				case 0: 
					return brinVal;
					break;
				case 1: 
					return vercVal;
					break;
				case 2: 
					return oqrVal;
					break;
				case 3: 
					return platVal;
					break;
			}
			
			return 0;
		}
		
		public function returnMovieClip(num:int):Sprite {
			switch (num) {
				case 1: 
					return brinjao_mc;
					break;
				case 2: 
					return vercxli_mc;
					break;
				case 3: 
					return oqro_mc;
					break;
				case 4: 
					return platina_mc;
					break;
			}
			
			return null;
		}
		
		public function retunCurAr(num:int):Array {
			
			for (var i:int = 0; i < lastInfoAr.length; i++) {
				if (lastInfoAr[i][0] == num) {
					return lastInfoAr[i];
				}
			}
			
			return null;
		}
	
	}

}