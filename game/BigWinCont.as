package game {
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import starling.core.Starling;
	import starling.display.BlendMode;
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
		
		public static var COEF:int = 250;
		public static const BIG_WIN:String = 'bigWin';
		public static const MEGA_WIN:String = 'megaWin';
		public static const SUPER_WIN:String = 'superWin';
		
		
		public function BigWinCont(winamount:int, winType:String = BigWinCont.MEGA_WIN) {
			this.winamount = winamount;
			this.winType = winType;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			quadBg = new Quad(1500, 1500, Color.BLACK);
			quadBg.alpha = .6;
			quadBg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(quadBg);
			
			initBigWin();
			
			
			
			var num:Number = this.numChildren;
			for (var i:int = 1; i < num; i++) {
				TweenLite.from(this.getChildAt(i), 1.5, {delay: (i) * 0.02, scaleX: 0, scaleY: 0, alpha: 0, ease: Elastic.easeOut});
			}
			
			//Root.soundManager.schedule("bws", 0.4);
			Root.soundManager.schedule("congratulations", 0.4);
			_start = 0;
			_win = winamount;
			TweenMax.to(this, 6.3, {delay: 0.5, _start: _win, onUpdate: updateTotal, ease: Linear.easeNone});
			TweenLite.delayedCall(0.5, Root.soundManager.schedule, ["countsound"]);
			
			
			
			var bg:Quad = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, 0xff0000);
			bg.x = int(-bg.width / 2);
			bg.y = int(-bg.height / 2)+20;
			addChild( bg);
			bg.alpha = 0;
			
			TweenLite.delayedCall(8.2, hide);
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
			
			/*var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("winsPop_bfont").name;   
			$tf.size =  70;
			$tf.color = 0xffffff;
			$tf.bold = true;*/
			
			val_txt = StaticGUI._creatBitmapFontTextRenderer(this, '0', 0, 160, 800, 300, Assets.getFont("winsPop_bfont").name,TextFormatAlign.CENTER,false,-35);
			//new TextField(500, 300, "0", $tf);
			val_txt.alignPivot(Align.CENTER, Align.CENTER);
			//val_txt.y = 30;
			//val_txt.
			//addChild(val_txt);
			
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
			TweenLite.to(img, 1, { delay: showdelay, scale: 1, rotation:deg2rad(0), alpha: 1 } );
			TweenLite.delayedCall(showdelay, function():void{addChild(img)});
			
			return img;
		}
		
		public function updateTotal():void {
			this.val_txt.text = String((int(_start / GameSettings.CREDIT_VAL))) + " " + StaticGUI.getCurrecyShortcuts();
		}
		
		public function hide():void {
			var num:Number = this.numChildren;
			for (var i:int = 1; i < num; i++) {
				TweenLite.to(this.getChildAt(i), 0.3, {delay: (i) * 0.01, scaleX: 0, scaleY: 0, alpha: 0, ease: Back.easeIn});
			}
			
			TweenLite.delayedCall(1.5, removeMe);
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
			
			starImg.dispose();
			starImg = null;
			
			headerImg.dispose();
			headerImg = null;
			
			bigWinImg.dispose();
			bigWinImg = null;
			
			coinsImg.dispose();
			coinsImg = null;
			
			val_txt.dispose();
			val_txt = null;
			
			shineTexture.dispose();
			shineTexture = null;
			
			if (shineEffImg1) shineEffImg1.dispose();
			if (shineEffImg2) shineEffImg2.dispose();
			if (shineEffImg3) shineEffImg3.dispose();
			
			
			
			shineEffImg1 = null;
			shineEffImg2 = null;
			shineEffImg3 = null;
			
			atlas.dispose();
			atlas = null;
			
			this.removeChildren();
			this.dispose();
			starsAr = null;
			quadBg.dispose();
			quadBg = null;
		}
		
		public static function shouldShow(start:Number, end:Number):Boolean {
			if (start * COEF <= end / GameSettings.CREDIT_VAL) {
				return true;
			} else {
				return false;
			}
		}
	
	}

}