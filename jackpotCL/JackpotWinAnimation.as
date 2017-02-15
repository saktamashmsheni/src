package jackpotCL 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.utils.StaticGUI;
	import game.GameHolder;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	import starling.utils.Align;
	import starling.utils.Align;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class JackpotWinAnimation extends Sprite
	{
		private var bgMc:Sprite;
		private var quad:Quad;
		private var backgroundLight:Image;
		private var bottomBack:Image;
		private var jackpotBg:Image;
		private var bottomTop:Image;
		private var monetebiLeft:Image;
		private var monetebiRight:Image;
		private var lightsMc:MovieClip;
		private var jackType_mc:MovieClip;
		private var winval_txt:TextField;
		
		public var win:Number;
		//private var coin:Coin;
		private var c:Color;
		private var jackId:int;
		private var coinsAr:Array;
		public var _start:Number;
		public var _end:Number;
		
		public function JackpotWinAnimation(win:Number, jackId:int) 
		{
			this.win = win;
			this.jackId = jackId;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			initJackpotWin();
			
			initAnimation();
		}
		
		private function initJackpotWin():void 
		{
			bgMc = new Sprite();
			addChild(bgMc);
			quad = new Quad(this.stage.stageWidth + 40, this.stage.stageHeight + 40, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			bgMc.addChild(quad);
			bgMc.alpha = 0.5;
			
			backgroundLight = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("backgroundLight.png"));
			backgroundLight.alignPivot(Align.CENTER, Align.CENTER);
			addChild(backgroundLight);
			
			tweenBGLight();
			
			
			bottomBack = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("bottomBack.png"));
			bottomBack.alignPivot(Align.CENTER, Align.CENTER);
			bottomBack.y = 47;
			addChild(bottomBack);
			
			jackpotBg = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("jackpotBg.png"));
			jackpotBg.alignPivot(Align.CENTER, Align.CENTER);
			jackpotBg.y = -66;
			addChild(jackpotBg);
			
			lightsMc = new MovieClip(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTextures("lights"), 2);
			lightsMc.alignPivot(Align.CENTER, Align.CENTER);
			lightsMc.x = -28;
			lightsMc.y = -79;
			Starling.juggler.add(lightsMc);
			addChild(lightsMc);
			
			jackType_mc = new MovieClip(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTextures("jackpor_text_"));
			jackType_mc.alignPivot(Align.CENTER, Align.CENTER);
			jackType_mc.x = 10;
			jackType_mc.y = -69;
			addChild(jackType_mc);
			
			bottomTop = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("bottomTop.png"));
			bottomTop.alignPivot(Align.CENTER, Align.CENTER);
			bottomTop.y = 52;
			addChild(bottomTop);
			
			monetebiLeft = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("monetebi.png"));
			monetebiLeft.alignPivot(Align.CENTER, Align.CENTER);
			monetebiLeft.x = -285;
			monetebiLeft.y = -70;
			addChild(monetebiLeft);
			
			monetebiRight = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("monetebi.png"));
			monetebiRight.alignPivot(Align.CENTER, Align.CENTER);
			monetebiRight.x = 275;
			monetebiRight.y = -70;
			monetebiRight.rotation = deg2rad(70);
			addChild(monetebiRight);
			
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("roboto_slab_bold_23").name;
			$tf.size =  40;
			$tf.color = 0xE60909;
			$tf.bold = true;
			
			winval_txt = new TextField(400, 50, "0.00 " + StaticGUI.getCurrecyShortcuts() , $tf);
			winval_txt.alignPivot(Align.CENTER, Align.CENTER);
			winval_txt.y = 35;
			addChild(winval_txt);
			
		}
		
		
		
		private function tweenBGLight():void 
		{
			TweenMax.to(backgroundLight, 10, {rotation:deg2rad(360), ease:Linear.easeNone, onComplete:tweenBGLight});
		}
		
		
		
		
		private function initAnimation():void 
		{
			var j:int;
			Root.soundManager.schedule("congratulations");
			
			jackType_mc.currentFrame = jackId-1;
			
			for (j = 0; j < this.numChildren; j++) 
			{
				TweenMax.from(this.getChildAt(j), 0.6, {delay:j*0.1, scaleX:0, scaleY:0, alpha:0, ease:Back.easeOut});
			}
			
			_start = 0;
			_end = win;
			TweenMax.to(this, 8, { delay:0, _start:_end, onUpdate:updateTotal, ease:Linear.easeNone } );
			
			coinsAr = [];
			var coin:Image;
			for (j = 0; j < 800; j++) 
			{
				coin = new Image(Assets.getAtlas("jackpotWinAssetsImg", "jackpotWinAssetsXml").getTexture("coin.png"));
				coin.x = Math.random() * 800 - 420;
				coin.rotation = deg2rad(Math.random() * 820);
				coin.y = -400;
				coin.alpha = 0;
				//coin.transform.colorTransform = c;
				addChildAt(coin, 1);
				coinsAr.push(coin);
				TweenMax.to(coin, 2, {delay:j*0.015, y:600 - Math.random()*400-200, alpha:1, rotation:0, ease:Bounce.easeOut});
			}
			
			
			TweenLite.delayedCall(17, GameHolder.cont.removeJackpotAnim);
		}
		
		
		public function updateTotal():void 
		{
			winval_txt.text = String((int(_start)/100).toFixed(2)) + " " + StaticGUI.getCurrecyShortcuts();
		}
		
		public function disposeAll():void 
		{
			
		}
		
		
		
		
	}

}