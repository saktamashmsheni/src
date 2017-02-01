package game {
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.StaticGUI;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class BigWin extends Sprite {
		
		private var winamount:int;
		private var val_txt:TextField;
		private var starsAr:Array;
		private var bigWinImg:Image;
		public var _win:int;
		public var _start:int;
		//public static var COEF:int = 250;
		public static var COEF:int = 250;
		
		public function BigWin(winamount:int) {
			this.winamount = winamount;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			
			initBigWin();
			
			var num:Number = this.numChildren;
			for (var i:int = 0; i < num; i++) {
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
			bigWinImg = new Image(Assets.getTexture("bigWin"));
			bigWinImg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(bigWinImg);
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("exRounded").name;
			$tf.size =  50;
			$tf.color = 0xffffff;
			$tf.bold = true;
			
			val_txt = new TextField(400, 400, "0", $tf);
			val_txt.alignPivot(Align.CENTER, Align.CENTER);
			val_txt.y = 30;
			addChild(val_txt);
			
			starsAr = [];
			
			for (var i:int = 0; i < 100; i++) {
				mc = new MovieClip(Assets.getAtlas("starEffectSheet", "starEffectSheetXml").getTextures("star"), 40);
				mc.alignPivot(Align.CENTER, Align.CENTER);
				mc.x = Math.round(Math.random() * 600 - Math.random() * 600);
				mc.y = Math.round(Math.random() * 600 - Math.random() * 600);
				mc.scaleX = mc.scaleY = Math.random() * 1;
				addChild(mc);
				Starling.juggler.add(mc);
				starsAr.push(mc);
			}
			
			mc = null;
		}
		
		public function updateTotal():void {
			this.val_txt.text = String((int(_start / GameSettings.CREDIT_VAL))) + "";
		}
		
		public function hide():void {
			var num:Number = this.numChildren;
			for (var i:int = 0; i < num; i++) {
				TweenLite.to(this.getChildAt(i), 0.4, {delay: (i) * 0.01, scaleX: 0, scaleY: 0, alpha: 0, ease: Back.easeIn});
			}
			
			TweenLite.delayedCall(3, removeMe);
		}
		
		public function removeMe():void {
			
			for (var i:int = 0; i < starsAr.length; i++) {
				Starling.juggler.remove(starsAr[i]);
				StaticGUI.safeRemoveChild(starsAr[i], true);
				starsAr[i] = null;
			}
			this.removeChildren();
			this.dispose();
			starsAr = [];
			
			Assets.disposeTextureItem("bigWinImg");
			bigWinImg.dispose();
			bigWinImg = null;
			
			try {
				GameHolder.cont.bigWinAnim = null;
				StaticGUI.safeRemoveChild(this);
			} catch (err:Error) {
				if (this.parent) {
					GameHolder.cont.bigWinAnim = null;
					this.parent.removeChild(this);
				} else {
					GameHolder.cont.bigWinAnim = null;
					StaticGUI.safeRemoveChild(this);
				}
			}
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