package game.machine {
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.utils.StaticGUI;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import game.footer.FooterHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LineWinStatus extends Sprite {
		private var $textShadow:Object;
		private var lastX:Number;
		private var test_txt:TextFieldTextRenderer;
		private var imgIC:Image;
		private var test2_txt:TextFieldTextRenderer;
		private var winStBg:Image;
		private var contMc:Sprite;
		private var clearAr:Array;
		private var showYPos:Number = 433;
		private var showXPos:Number = -165;
		private var maska:Quad;
		private var shadowImg:Image;
		public function LineWinStatus() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			this.x = showXPos;
			this.y = showYPos;
			
			this.visible = false;
			
			contMc = new Sprite();
			addChild(contMc);
			
			winStBg = new Image(Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("credit_btn_bg_1.png"));
			winStBg.name = "bg";
			winStBg.x = 545;
			winStBg.x = 170;
			winStBg.scaleY = 1.1;
			winStBg.scaleX = 0.9;
			//StaticGUI.setAlignPivot(winStBg);
			contMc.addChild(winStBg);
			winStBg.color = Color.YELLOW;
			
			
			maska = new Quad(winStBg.width + 20, winStBg.height + 40, Color.RED);
			addChild(maska);
			maska.x = winStBg.x - 10;
			maska.y = winStBg.y + 6;
			contMc.mask = maska;
			
			/*shadowImg = new Image(Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("credit_shadow.png"));
			StaticGUI.setAlignPivot(shadowImg);
			addChild(shadowImg);
			shadowImg.scaleY = 1.1;
			shadowImg.scaleX = 0.9;
			shadowImg.x = winStBg.x + 70;
			shadowImg.y = winStBg.y + 43;
			contMc.addChild(shadowImg);*/
			
			//setStatus([3, 7, 5, 9000]);
		}
		
		public function setStatus(arr:Array):void {
			var i:int;
			clear();
			
			$textShadow = {};
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = .8;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			
			clearAr = [];
			
			
			
			
			test_txt = StaticGUI._creatTextFieldTextRenderer(contMc, "Line " + (arr[0] + 1) + ": ", 177, 18, 100, 20, "_AvenirNextBoldItalic", 13, 0xffffff, null, TextFormatAlign.LEFT, true);
			test_txt.alignPivot(Align.LEFT, Align.CENTER);
			
			clearAr.push(test_txt);
			
			for (i = 0; i < arr[2]; i++) {
				imgIC = new Image(Assets.getAtlas("allIconsImg", "allIconsXml").getTexture("icons" + StaticGUI.intWithZeros((arr[1])*2, 4)));
				imgIC.scaleX = imgIC.scaleY = 0.1;
				imgIC.x = test_txt.x + (imgIC.width + 1) * i + 55;
				imgIC.textureSmoothing = TextureSmoothing.TRILINEAR;
				imgIC.y = test_txt.y - 1;
				imgIC.alignPivot(Align.CENTER, Align.CENTER);
				contMc.addChild(imgIC);
				lastX = imgIC.x;
				clearAr.push(imgIC);
				imgIC = null;
			}
			
			test2_txt = StaticGUI._creatTextFieldTextRenderer(contMc, "= " + StaticGUI.modifiedBalanceString(arr[3]), test_txt.x , test_txt.y + 18, 100, 25, "_AvenirNextBoldItalic", 13, 0xffffff, null, TextFormatAlign.LEFT, true);
			test2_txt.alignPivot(Align.LEFT, Align.CENTER);
			
			clearAr.push(test2_txt);
			
			
			
			if (this.visible == true)
			{
				for (i = 0; i < clearAr.length; i++) 
				{
					TweenLite.from(clearAr[i], 0.3, { alpha: 0} );
				}
				return;
			}
			
			this.alpha = 1;
			TweenLite.from(this, 0.4, {alpha:0 } );
			this.visible = true;
		}
		
		public function clear():void {
			TweenLite.killTweensOf(this);
			$textShadow = null
			StaticGUI.safeRemoveChild(test_txt, true);
			StaticGUI.safeRemoveChild(imgIC, true);
			StaticGUI.safeRemoveChild(test2_txt, true);
			test_txt = null
			imgIC = null
			test2_txt = null
			
			if (clearAr == null) return;
			
			for (var i:int = 0; i < clearAr.length; i++) 
			{
				StaticGUI.safeRemoveChild(clearAr[i], true);
			}
		}
		
		public function hide():void
		{
			TweenLite.to(this, 0.2, {autoAlpha:0 } );
		}
	
	}

}