package game.footer 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class CreditContainer extends Sprite
	{
		
		private var mcAr:Array = [];
		private var typeAr:Array = GameSettings.CREDIT_AR;
		private var opened:Boolean = false;
		private var testCreditBtn:MyButton;
		//private var dropBtn:MyButton;
		private var shadowImg:Image;
		public static var CREDIT:int = GameSettings.CREDIT_VAL;
		
		public static var cont:CreditContainer;
		
		public function CreditContainer() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			cont = this;
			
			initCredit();
			
		}
		
		
		
		private function initCredit():void 
		{
			var quad:Quad;
			var creditTxt:TextFieldTextRenderer;
			
			var $textShadow:Object = new Object;
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = 0.35;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			
			
			
			/*shadowImg = new Image(Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("credit_shadow.png"));
			StaticGUI.setAlignPivot(shadowImg);
			addChild(shadowImg);
			shadowImg.y = 20;*/
			
			
			/*dropBtn = new MyButton(Assets.getAtlas("footerSheet", "footerSheetXml").getTextures("credit_arrow_btn"));
			StaticGUI.setAlignPivot(dropBtn);
			addChild(dropBtn);
			dropBtn.y = -22;
			dropBtn.addEventListener(MouseEvent.CLICK, onButsClick);*/
			
			
			
			
			for (var i:int = 0; i < 4; i++) 
			{
				var str:String = "";
				if (typeAr[i] <= 9)
					str = "0";
				str += String(typeAr[i]);
				
				quad = new Quad(155, 41, 0xff0000);
				StaticGUI.setAlignPivot(quad);
				testCreditBtn = new MyButton(Assets.getAtlas("footerSheet", "footerSheetXml").getTextures("credit_btn_bg"), "CC");
				testCreditBtn.setHover(quad);
				testCreditBtn.name = "cred" + String(typeAr[i]);
				testCreditBtn.y = - i * (testCreditBtn.height - 4);
				testCreditBtn.opt.openY = testCreditBtn.y;
				testCreditBtn.opt.openX = testCreditBtn.x;
				testCreditBtn.y = 0;
				testCreditBtn.addEventListener(MouseEvent.CLICK, onButsClick);
				addChild(testCreditBtn);
				creditTxt = StaticGUI._creatTextFieldTextRenderer(testCreditBtn, '<font color="#ffffff">1</font> CREDIT = <font color="#f1bc45">'+(Number(typeAr[i]) / 100).toFixed(2)+"</font> GEL", 0, -3, 180, 17, '_BebasNeue', 18, 0xffffff, $textShadow, TextFormatAlign.CENTER, true);
				StaticGUI.setAlignPivot(creditTxt);
				mcAr.push(testCreditBtn);
				
				if (i > 0)
				{
					testCreditBtn.alpha = 0;
				}
			}
			
			addChild(mcAr[0]);
			//MyButton(mcAr[0]).hoverEnabled = false;
			MyButton(mcAr[0]).gotoAndStop(1);
			
			
			
		}
		
		
		
		
		
		private function addListeners():void
		{
			for (var i:int = 0; i < mcAr.length; i++) 
			{
				mcAr[i].mouseEnabled = true;
			}
		}
		
		private function removeListeners():void
		{
			for (var i:int = 0; i < mcAr.length; i++) 
			{
				mcAr[i].mouseEnabled = false;
			}
		}
		
		
		private function resetButs():void 
		{
			for (var i:int = 0; i < mcAr.length; i++) 
			{
				mcAr[i].hoverEnabled = true;
				mcAr[i].gotoAndStop(1);
				
			}
		}
		
		
		private function onButsClick(e:MouseEvent):void 
		{
			
			if (GameHolder.cont.freeSpinsState == true || GameHolder.cont.footerHolder.spinEnabled == false || GameHolder.gameState == GameHolder.DOUBLE_STATE)
			{
				//resetButs();
				for (i = 0; i < mcAr.length; i++) 
				{
					TweenLite.to(mcAr[i], 0.3, {y:0, ease:Expo.easeOut});
				}
				return;
			}
			var i:int;
			
			if (!opened)
			{
				removeListeners();
				for (i = 0; i < mcAr.length; i++) 
				{
					mcAr[i].alpha = 1;
					TweenLite.to(mcAr[i], 0.3, {y:mcAr[i].opt.openY, ease:Expo.easeOut});
				}
				
				opened = true;
				TweenLite.delayedCall(0.3, addListeners);
				
				//dropBtn.visible = false;
			}
			else
			{
				resetButs();
				//e.params.currentTarget.hoverEnabled = false;
				e.params.currentTarget.gotoAndStop(1);
				
				var namestr:String = e.params.currentTarget.name;
				var strAR:Array = namestr.split("cred");
				GameSettings.CREDIT_VAL = CREDIT = strAR[1];
				dispatchEvent(new GameEvents(GameEvents.CREDIT_CHANGED));
				
				addChild(e.params.currentTarget);
				
				
				removeListeners();
				for (i = 0; i < mcAr.length; i++) 
				{
					TweenLite.to(mcAr[i], 0.3, {y:0, x:0, ease:Expo.easeOut, onComplete:onCompleteAnim, onCompleteParams:[i]});
				}
				
				opened = false;
				TweenLite.delayedCall(0.3, addListeners);
				
				//dropBtn.visible = true;
			}
		}
		
		private function onCompleteAnim(num:int):void 
		{
			if (mcAr[num].name == "cred" + GameSettings.CREDIT_VAL.toString())
			{
				return;
			}
			mcAr[num].alpha = 0;
		}
		
	}

}