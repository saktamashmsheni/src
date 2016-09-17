package notifi 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.utils.StaticGUI;
	import game.GameHolder;
	import game.footer.FooterHolder;
	import starling.display.Image;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author ...
	 */
	public class ScatterWinWindow extends Sprite3D
	{
		private var bg:Image;
		private var win_txt:TextField;
		private var winAmount:int;
		public var _win:int;
		public var _start:int;
		
		public function ScatterWinWindow(winAmount:int) 
		{
			this.winAmount = winAmount;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			bg = new Image(Assets.getTexture("scatterWinBg"));
			StaticGUI.setAlignPivot(bg);
			addChild(bg);
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("avirBlackBitmap_bitmapFont").name;
			$tf.size =  40;
			$tf.color = Color.YELLOW;
			$tf.bold = true;
			
			win_txt = new TextField(500, 70, "", $tf);
			StaticGUI.setAlignPivot(win_txt);
			addChild(win_txt);
			win_txt.y = 55;
			
			Root.soundManager.schedule("congratulations", 0.4);
			_start = 0;
			_win = winAmount;
			TweenMax.to(this, 2, {delay: 0, _start: _win, onUpdate: updateTotal, ease: Circ.easeInOut});
			
			
			TweenMax.from(this, 2.5, { rotationX:deg2rad( -80),  rotation:deg2rad( -80), scaleX:0.1, scaleY:0.1,  ease:Elastic.easeOut } );
			TweenMax.from(this, 0.4, { alpha:0 } );
			
			
			TweenLite.delayedCall(3, hide);
		}
		
		public function updateTotal():void {
			this.win_txt.text = StaticGUI.modifiedBalanceString(_start);
		}
		
		public function hide():void {
			var num:Number = this.numChildren;
			TweenMax.to(this, 0.6, { rotationX:deg2rad( -80),  rotation:deg2rad( 180), alpha:0, scaleX:0.1, scaleY:0.1,  ease:Back.easeIn } );
			
			TweenLite.delayedCall(0.7, removeMe);
		}
		
		
		
		private function removeMe():void 
		{
			Assets.disposeTextureItem("scatterWinBg");
			StaticGUI.safeRemoveChild(bg, true);
			bg = null;
			StaticGUI.safeRemoveChild(win_txt, true);
			win_txt = null;
			
			GameHolder.cont.scatterWinMc = null;
			this.removeChildren();
			StaticGUI.safeRemoveChild(this, true);
			
			
		}
		
	}

}