package notifi {
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	import starling.utils.Align;
	
	public class FreeSpinStatus extends Sprite {
		
		private var thisMC:FreeSpinStatus;
		private var OKButt:MyButton;
		private var _parent:Sprite;
		private var start:Boolean;
		private var win:Number;
		private var gameState:int;
		private var error_txt:TextField;
		private var statusState:int;
		private var statusBg:Image;
		private var quad:Quad;
		private var frCount:int;
		private var win_txt:BitmapFontTextRenderer;
		
		public function FreeSpinStatus(statusState:int, frCount:int = 0, win:Number = 0, gameState:int = -1) {
			this.frCount = frCount;
			this.statusState = statusState;
			this.alignPivot(Align.CENTER, Align.CENTER);
			this.gameState = gameState;
			this.win = win;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initFreeSpinStatus();
			thisMC = this;
			
			
			TweenMax.from(this, 1, {scaleX: 0, scaleY:0, alpha: 0, ease: Back.easeInOut});
			
			
		}
		
		private function initFreeSpinStatus():void {
			
			quad = new Quad(this.stage.stageWidth + 300, this.stage.stageHeight + 300, 0x000000);
			quad.alpha = 0.5;
			addChild(quad);
			
			StaticGUI.setAlignPivot(quad);
			
			statusBg = new Image(Assets.getAtlas("freeSpinsSheet", "freeSpinsSheetXml").getTexture(statusState + ".png"));
			statusBg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(statusBg);
			
			switch (statusState) 
			{
				case 0:
					OKButt = new MyButton(Assets.getAtlas("freeSpinsSheet", "freeSpinsSheetXml").getTextures("start"), "CC");
				break;
				case 1:
					OKButt = new MyButton(Assets.getAtlas("freeSpinsSheet", "freeSpinsSheetXml").getTextures("continue"), "CC");
				break;
				case 2:
					OKButt = new MyButton(Assets.getAtlas("freeSpinsSheet", "freeSpinsSheetXml").getTextures("continue"), "CC");
					win_txt = StaticGUI._creatBitmapFontTextRenderer(this, StaticGUI.modifiedBalanceString(win,1), 10, 90, 500, 200, Assets.getFont("free_spin_win").name, TextFormatAlign.CENTER, false, -8);
					StaticGUI.setAlignPivot(win_txt);
				break;
				
			}
			
			OKButt.x = 10;
			OKButt.y = 118;
			addChild(OKButt);
			
			OKButt.addEventListener(MouseEvent.CLICK, onOkClick);
			
		}
		
		private function onOkClick(e:MouseEvent):void {
			if (statusState == 0 || statusState == 1) {
				dispatchEvent(new GameEvents(GameEvents.FREE_SPINS_START, {lastState: gameState}));
			} else {
				dispatchEvent(new GameEvents(GameEvents.FREE_SPINS_END, {lastState: gameState}));
			}
			GameHolder.cont.removeFreeSpins();
		}
		
		public function disposeFrStatus():void 
		{
			StaticGUI.safeRemoveChild(statusBg, true);
			statusBg = null;
			
			StaticGUI.safeRemoveChild(quad, true);
			quad = null;
			
			TweenMax.killTweensOf(this);
		}
	
	}

}