package game {
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import game.footer.FooterHolder;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	import starling.utils.Align;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class BigWinCont extends Sprite {
		
		private var winamount:int;
		private var val_txt:BitmapFontTextRenderer;
		private var starsAr:Array;
		private var bigWinImg:Image;
		private var starImg:Image;
		private var headerImg:Image;
		private var coinsImg:Image;
		
		private var shineEffImg1:Image;
		private var shineEffImg2:Image;
		private var shineEffImg3:Image;
		
		private var starBgTexture:Texture;
		private var bigWinTexture:Texture;
		private var headerTexture:Texture;
		private var coinsTexture:Texture;
		private var shineTexture:Texture;
		
		
		private var atlas:TextureAtlas;
		
		public var _win:int;
		public var _start:int;
		private var winType:String;
		private var quadBg:Quad;
		
		
		public static const BIG_WIN:String = 'bigWin';
		public static const MEGA_WIN:String = 'megaWin';
		public static const SUPER_WIN:String = 'superWin';
		
		public static var BING_WIN_COEF:int = 20;
		public static var MEGA_WIN_COEF:int = 50;
		public static var COEFS_ARR:Array = [BING_WIN_COEF, MEGA_WIN_COEF];
		public static var WIN_NAMES:Array = [BIG_WIN, MEGA_WIN];
		
		
		public function BigWinCont(winamount:int, winIndex:int = -1) {
			
			this.winamount = winamount;
			this.winType = WIN_NAMES[winIndex];
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			quadBg = new Quad(5, 5, Color.BLACK);
			quadBg.alpha = 0;
			quadBg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(quadBg);
			
			initBigWin();
			
			
			
			var num:Number = this.numChildren;
			for (var i:int = 1; i < num; i++) {
				TweenMax.from(this.getChildAt(i), 1.6, {delay: (i) * 0.1, scaleX: 0, scaleY: 0, alpha: 0, ease: Elastic.easeOut});
			}
			
			
			TweenMax.delayedCall(1.4, animanim, [DisplayObject(headerImg)]);
			TweenMax.delayedCall(1.3, animanim2, [DisplayObject(starImg)]);
			TweenMax.delayedCall(1.5, animanim3, [DisplayObject(coinsImg)]);
			TweenMax.delayedCall(1.5, animanim4, [DisplayObject(bigWinImg)]);
			
			//Root.soundManager.schedule("bws", 0.4);
			Root.soundManager.schedule("congratulations", 0.4);
			_start = 0;
			_win = winamount;
			TweenMax.to(this, 6.3, {delay: 0.5, _start: _win, onUpdate: updateTotal, ease: Linear.easeNone});
			TweenLite.delayedCall(0.5, Root.soundManager.PlaySound, ["countsound"]);
			
			
			
			var bg:Quad = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, 0xff0000);
			bg.x = int(-bg.width / 2);
			bg.y = int(-bg.height / 2)+20;
			addChild( bg);
			bg.alpha = 0;
			
			this.touchable = false;
			
			TweenMax.delayedCall(8.2, hide);
		}
		
		
		private function animanim(mov:DisplayObject):void
		{
			TweenMax.killTweensOf(mov);
			mov.scaleX = mov.scaleY = 1;
			mov.alpha = 1;
			TweenMax.from(mov, 1, {delay:0, scaleX: 0.7, scaleY: 0.7, alpha: 0.8, ease: Elastic.easeOut, yoyo:true, repeat:6});
			
		}
		
		private function animanim2(mov:DisplayObject):void
		{
			TweenMax.killTweensOf(mov);
			mov.scaleX = mov.scaleY = 1;
			mov.alpha = 1;
			TweenMax.to(mov, 1, {delay:0, x: 0, scaleX: 1.1, scaleY: 1.1, alpha: 1, yoyo:true, repeat:6});
			
		}
		
		private function animanim3(mov:DisplayObject):void
		{
			TweenMax.killTweensOf(mov);
			mov.scaleX = mov.scaleY = 1;
			mov.alpha = 1;
			TweenMax.to(mov, 0.6, {delay:0, x: 0, scaleX: 1.1, scaleY: 1.1, alpha: 1, yoyo:true, repeat:10});
			
		}
		
		private function animanim4(mov:DisplayObject):void
		{
			TweenMax.killTweensOf(mov);
			mov.scaleX = mov.scaleY = 1;
			mov.alpha = 1;
			TweenMax.to(mov, 0.6, {delay:0, scaleX: 1, scaleY: 1, alpha: 1, yoyo:true, repeat:10});
			
		}
		
		private function initBigWin():void {
			var mc:MovieClip;
			
			atlas = Assets.getAtlas("winsPopAsset", "winsPopAssetXml");
			shineTexture = atlas.getTexture("shine_effect.png");
			
			switch(winType) {
				case BigWinCont.BIG_WIN:
					
					starBgTexture = atlas.getTexture("big_win_stars.png");
					bigWinTexture = atlas.getTexture("big_win_bg.png");
					headerTexture = atlas.getTexture("big_win_header.png");
					coinsTexture = atlas.getTexture("big_win_coins.png");
					
					break;
					
				case BigWinCont.SUPER_WIN:
					starBgTexture = atlas.getTexture("super_win_star.png");
					bigWinTexture = atlas.getTexture("super_win_bg.png");
					headerTexture = atlas.getTexture("super_win_header.png");
					coinsTexture = atlas.getTexture("super_win_coins.png");
					
					break;
					
				case BigWinCont.MEGA_WIN:
					
					starBgTexture = atlas.getTexture("mega_win_stars.png");
					bigWinTexture = atlas.getTexture("mega_win_bg.png");
					headerTexture = atlas.getTexture("mega_win_header.png");
					coinsTexture = atlas.getTexture("mega_win_coins.png");
					
					
					break;
			}
			starImg = new Image(starBgTexture);
			starImg.alignPivot(Align.CENTER, Align.CENTER);
			starImg.y = -200;
			addChild(starImg);
			
			bigWinImg = new Image(bigWinTexture);
			bigWinImg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(bigWinImg);
			
			headerImg = new Image(headerTexture);
			headerImg.alignPivot(Align.CENTER, Align.CENTER);
			headerImg.y = -50;
			addChild(headerImg);
			
			coinsImg = new Image(coinsTexture);
			coinsImg.alignPivot(Align.CENTER, Align.CENTER);
			//coinsImg.y = -50;
			switch(winType) {
				case BigWinCont.BIG_WIN: coinsImg.y = -50; break;
				case BigWinCont.SUPER_WIN: coinsImg.y = -50;break;
				case BigWinCont.MEGA_WIN: coinsImg.y = 120;break;
			}
			addChild(coinsImg);
			
			val_txt = StaticGUI._creatBitmapFontTextRenderer(this, '0', 0, 160, 800, 300, Assets.getFont("winsPop_bfont").name,TextFormatAlign.CENTER,false,-35);
			val_txt.alignPivot(Align.CENTER, Align.CENTER);
			
			starsAr = [];
			
			/*for (var i:int = 0; i < 100; i++) {
				mc = new MovieClip(Assets.getAtlas("starEffectSheet", "starEffectSheetXml").getTextures("star"), 40);
				mc.alignPivot(Align.CENTER, Align.CENTER);
				mc.x = Math.round(Math.random() * 600 - Math.random() * 600);
				mc.y = Math.round(Math.random() * 600 - Math.random() * 600);
				mc.scaleX = mc.scaleY = Math.random() * 1;
				addChild(mc);
				Starling.juggler.add(mc);
				starsAr.push(mc);
			}*/
			
			switch(winType) {
				case BigWinCont.BIG_WIN:

					shineEffImg1 = addShineEff(shineTexture, 140, -110, 1);
					shineEffImg2 = addShineEff(shineTexture, -190, 40, 2.5);
					
					addChild(shineEffImg2);
					
					break;
					
				case BigWinCont.SUPER_WIN:
					
					shineEffImg1 = addShineEff(shineTexture, 0, -250, 1);
					shineEffImg2 = addShineEff(shineTexture, 160, 30, 1.5);
					shineEffImg3 = addShineEff(shineTexture, -270, -40, 2.3);
					
					break;
					
				case BigWinCont.MEGA_WIN:
					
					shineEffImg1 = addShineEff(shineTexture, -160, -180, 1);
					shineEffImg2 = addShineEff(shineTexture, 170, -105, 1.8);
					
					break;
			}
			
			
			
			mc = null;
		}
		
		
		private function addShineEff(texture:Texture, xpos:int = 0, ypos:int = 0, showdelay:uint = 0):Image {
			var img:Image = new Image(texture);
			img.blendMode = BlendMode.SCREEN;
			img.alignPivot(Align.CENTER, Align.CENTER);
			img.rotation = deg2rad(Math.random() * 180);
			img.alpha = 0;
			img.scale = .2;
			img.x = xpos;
			img.y = ypos;
			TweenMax.to(img, 3, { delay: showdelay, scale: 1, rotation:deg2rad(0), alpha: 1, ease:Elastic.easeOut } );
			TweenMax.delayedCall(showdelay, function():void{addChild(img)});
			
			return img;
		}
		
		public function updateTotal():void {
			//this.val_txt.text = String((int(_start / GameSettings.CREDIT_VAL))) + " " + StaticGUI.getCurrecyShortcuts();
			this.val_txt.text = StaticGUI.scoreToValutaFixed(_start / GameSettings.CREDIT_VAL,int(FooterHolder.InLari));
		}
		
		public function hide(fastRemove:Boolean = false):void {
			
			TweenMax.killTweensOf(this);
			TweenMax.killDelayedCallsTo(hide);
			
			GameHolder.cont.bigWinAnim = null;
			
			Root.soundManager.stopSound();
			
			if (fastRemove)
			{
				removeMe();
				return;
			}
			
			var num:Number = this.numChildren;
			for (var i:int = 1; i < num; i++) {
				TweenLite.to(this.getChildAt(i), 0.3, {delay: (i) * 0.01, scaleX: 0, scaleY: 0, alpha: 0, ease: Back.easeIn});
			}
			
			TweenMax.delayedCall(1.5, removeMe);
		}
		
		public function removeMe():void {
			
			for (var i:int = 0; i < starsAr.length; i++) {
				Starling.juggler.remove(starsAr[i]);
				StaticGUI.safeRemoveChild(starsAr[i], true);
				starsAr[i] = null;
			}
			
			
			try {
				StaticGUI.safeRemoveChild(this);
			} catch (err:Error) {
				if (this.parent) {
					this.parent.removeChild(this);
				} else {
					StaticGUI.safeRemoveChild(this);
				}
			}
			
			StaticGUI.safeRemoveChild(starImg);
			starImg = null;
			
			headerImg.dispose();
			headerImg = null;
			
			bigWinImg.dispose();
			bigWinImg = null;
			
			coinsImg.dispose();
			coinsImg = null;
			
			val_txt.dispose();
			val_txt = null;
			
			//shineTexture.dispose();
			shineTexture = null;
			
			if (shineEffImg1) shineEffImg1.dispose();
			if (shineEffImg2) shineEffImg2.dispose();
			if (shineEffImg3) shineEffImg3.dispose();
			
			
			
			shineEffImg1 = null;
			shineEffImg2 = null;
			shineEffImg3 = null;
			
			//atlas.dispose();
			atlas = null;
			
			this.removeChildren();
			this.dispose();
			starsAr = null;
			quadBg.dispose();
			quadBg = null;
		}
		
		public static function shouldShow(start:Number, end:Number):int {
			var curCoef:int = end / GameSettings.CREDIT_VAL / start;
			
			for (var i:int = COEFS_ARR.length-1; i >= 0; i--) 
			{
				if (curCoef >= COEFS_ARR[i])
				{
					return i;
				}
			}
			
			return -1;
		}
		
		
	
	}

}