package game 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.utils.GoogleAnalytics;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import connection.SocketAnaliser;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.text.TextFormatAlign;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.utils.Color;
	/**
	 * ...
	 * @author ...
	 */
	public class WildSelector extends Sprite
	{
		private var bg:Image;
		private var quad:Quad;
		private var wildIcAr:Array;
		private var wildIcHolder:MyButton;
		private var tt1:TextFieldTextRenderer;
		private var tt2:TextFieldTextRenderer;
		private var firstOpen:Boolean;
		private var x_btn:MyButton;
		
		public function WildSelector(firstOpen:Boolean) 
		{
			this.firstOpen = firstOpen;
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			initWildSelector();
			
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				TweenLite.from(getChildAt(i), 0.6, {delay:i*0.1, alpha:0,  ease:Expo.easeOut});
			}
		}
		
		private function initWildSelector():void 
		{
			
			quad = new Quad(this.stage.stageWidth + 400, this.stage.stageHeight + 400, Color.BLACK);
			quad.alpha = 0.5;
			StaticGUI.setAlignPivot(quad);
			addChild(quad);
			
			bg = new Image(Assets.getAtlas("wildSelectorSheet", "wildSelectorSheetXml").getTexture("wild_selector_bg.png"));
			StaticGUI.setAlignPivot(bg);
			addChild(bg);
			
			
			if (firstOpen)
			{
				tt1 = StaticGUI._creatTextFieldTextRenderer(this, GameSettings.GAME_XML.wilSelector.txt1, 0, -225, 500, 26, '_bpgGELDejaVuSerifCaps', 25, 0xd7c294, null, TextFormatAlign.CENTER);
				tt2 = StaticGUI._creatTextFieldTextRenderer(this, GameSettings.GAME_XML.wilSelector.txt2, 0, -180, 800, 20, '_bpgGELDejaVuSerifCaps', 14, 0xd7c294, null, TextFormatAlign.CENTER);
				
				StaticGUI.setAlignPivot(tt1);
				StaticGUI.setAlignPivot(tt2);
			}
			else
			{
				tt1 = StaticGUI._creatTextFieldTextRenderer(this, GameSettings.GAME_XML.wilSelector.txt1, 0, -200, 500, 26, '_bpgGELDejaVuSerifCaps', 25, 0xd7c294, null, TextFormatAlign.CENTER);
				StaticGUI.setAlignPivot(tt1);
				
				x_btn = new MyButton((Assets.getAtlas("transferSheet", "transferSheetXml").getTextures("xBtn")), "CC");
				x_btn.x = 350;
				x_btn.y = -260;
				addChild(x_btn);
				x_btn.addEventListener(MouseEvent.CLICK, onXClick);
			}
			
			
			var wildBtn:Sprite;
			var img:Image
			
			wildIcHolder = new MyButton(null);
			wildIcHolder.x = -250;
			wildIcHolder.y = -100;
			addChild(wildIcHolder);
			wildIcHolder.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			wildIcHolder.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			wildIcHolder.addEventListener(MouseEvent.CLICK, onClick);
			
			wildIcAr = [];
			
			var canvas:Canvas;
			
			for (var i:int = 0; i < 24; i++) 
			{
				canvas = new Canvas();
				canvas.beginFill(0xff0000);
				canvas.drawRectangle(0, 0, 70,50);
				canvas.endFill();
				StaticGUI.setAlignPivot(canvas);
				canvas.alpha = 0;
				
				wildBtn = new Sprite();
				wildBtn.name = "w_" + String(i + 1);
				img = new Image(Assets.getAtlas("wildSelectorSheet", "wildSelectorSheetXml").getTexture("wild" + StaticGUI.intWithZeros((i + 1), 3) + ".png"));
				img.touchable = false;
				StaticGUI.setAlignPivot(img);
				wildBtn.addChild(img);
				wildBtn.addChild(canvas);
				
				wildBtn.x = 100 * (i%6);
				wildBtn.y = int(i / 6) * 75;
				
				wildIcAr.push(wildBtn);
				
				TweenLite.from(wildBtn, 0.6, {delay:0.01*i + 0.2, alpha:0, scaleX:0, scaleY:0, ease:Back.easeOut});
				
				wildIcHolder.addChild(wildBtn);
			}
			
			wildBtn = null;
			img = null;
			
			GoogleAnalytics._sendScreenView('Slot wild selector screen');
		}
		
		
		
		private function onXClick(e:MouseEvent):void 
		{
			GameHolder.cont.removeWildSelector();
		}
		
		private function onOver(e:MouseEvent):void 
		{
			//Image(Sprite(e.params.target.parent).getChildAt(0)).color = Color.YELLOW
			
			if (e.params.target == null || e.params.target.parent == null || String(e.params.target.parent.name).slice(0, 1) != "w")
			{
				return;
			}
			
			for (var i:int = 0; i < wildIcAr.length; i++) 
			{
				wildIcAr[i].filter = null;
			}
			
			//e.params.target.parent.filter = BlurFilter.createGlow(0xffffff, 1, 15, 2);
		}
		
		private function onOut(e:MouseEvent):void 
		{
			/*if (e.params.target == null || e.params.target.parent == null || e.params.target.parent.name.slice(0, 1) != "w")
			{
				return;
			}*/
			
			e.params.target.parent.filter = null;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (e.params.target == null || e.params.target.parent == null || e.params.target.parent.name.slice(0, 1) != "w")
			{
				return;
			}
			
			var strAr:Array = e.params.target.parent.name.split("_");
			var ind:int = strAr[1];
			
			Root.connectionManager.sendData({MT: SocketAnaliser.wildSelect, IM:{Icon:ind}, SID: ""});
		}
		
		
		public function destroy():void 
		{
			StaticGUI.safeRemoveChild(quad, true);
			StaticGUI.safeRemoveChild(bg, true);
			quad = null;
			bg = null;
			
			if (x_btn != null)
			{
				x_btn.removeEventListener(MouseEvent.CLICK, onXClick);
				StaticGUI.safeRemoveChild(x_btn, true);
				x_btn = null;
			}
			
			for (var i:int = 0; i < wildIcAr.length; i++) 
			{
				StaticGUI.safeRemoveChild(wildIcAr[i], true);
			}
			
			wildIcHolder.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			wildIcHolder.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			wildIcHolder.addEventListener(MouseEvent.CLICK, onClick);
			
			StaticGUI.safeRemoveChild(wildIcHolder, true);
		}
		
	}

}