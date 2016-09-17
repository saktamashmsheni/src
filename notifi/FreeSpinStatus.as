package notifi {
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import game.GameHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	import starling.utils.Align;
	
	public class FreeSpinStatus extends Sprite3D {
		
		private var thisMC:FreeSpinStatus;
		private var OKButt:MyButton;
		private var _parent:Sprite;
		private var start:Boolean;
		private var win:Number;
		private var gameState:int;
		private var pp:Sprite;
		private var error_txt:TextField;
		private var customText:String;
		
		public function FreeSpinStatus(pp:GameHolder, customText:String = "", start:Boolean = true, win:Number = 0, gameState:int = -1) {
			this.customText = customText;
			this.alignPivot(Align.CENTER, Align.CENTER);
			this.gameState = gameState;
			this.win = win;
			this.start = start;
			this.pp = pp;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initFreeSpinStatus();
			thisMC = this;
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("dejavuSans").name;
			$tf.size = 18;
			$tf.color = 0xFFFFFF;
			
			error_txt = new TextField(400, 92, "HERE WILL BE LOREM IPSUM SOON", $tf);
			error_txt.alignPivot(Align.CENTER, Align.CENTER);
			error_txt.y = 25;
			addChild(error_txt);
			
			OKButt = new MyButton(Assets.getAtlas("bonusStatusSheet", "bonusStatusSheetXml").getTextures("okBut"), "CC");
			addChild(OKButt);
			OKButt.y = 90;
			
			$tf.font = Assets.getFont("bebas").name;
			
			var ok_txt:TextField = new TextField(100, 28, "OK", $tf);
			ok_txt.alignPivot(Align.CENTER, Align.CENTER);
			OKButt.addChild(ok_txt);
			OKButt.addEventListener(MouseEvent.CLICK, onOkClick);
			
			error_txt.text = customText;
			
			TweenMax.from(this, 1, {rotationX: deg2rad(-80), alpha: 0, ease: Back.easeInOut});
		}
		
		private function initFreeSpinStatus():void {
			var bgMc:Sprite = new Sprite();
			addChild(bgMc);
			var quad:Quad = new Quad(this.stage.stageWidth + 40, this.stage.stageHeight + 40, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			bgMc.addChild(quad);
			bgMc.alpha = 0.5;
			
			var statusBg:Image = new Image(Assets.getAtlas("bonusStatusSheet", "bonusStatusSheetXml").getTexture("freeSpinStatusBg.png"));
			statusBg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(statusBg);
		}
		
		private function onOkClick(e:MouseEvent):void {
			if (start == true) {
				dispatchEvent(new GameEvents(GameEvents.FREE_SPINS_START, {lastState: gameState}));
			} else {
				dispatchEvent(new GameEvents(GameEvents.FREE_SPINS_END, {lastState: gameState}));
			}
			removeError();
		}
		
		public function removeError():void {
			try {
				_parent.removeChild(this);
			} catch (err:Error) {
				try {
					this.parent.removeChild(this);
				} catch (err:Error) {
					StaticGUI.safeRemoveChild(this);
				}
			}
		}
	
	}

}