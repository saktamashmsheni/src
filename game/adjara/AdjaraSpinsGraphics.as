package game.adjara 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class AdjaraSpinsGraphics extends Sprite
	{
		private var _Atlas:TextureAtlas;
		private var bg:Image;
		private var freeSpin_btn:MyButton;
		private var congradulatuon:Image;
		public var stageState:int = 0;
		private var adjaratext_img:Image;
		private var counter_txt:BitmapFontTextRenderer;
		private var arrowImg:Image;
		private var spin_txt:BitmapFontTextRenderer;
		private var spinCount_txt:BitmapFontTextRenderer;
		private var info_txt:TextFieldTextRenderer;
		private var $textShadow:Object;
		public static var cont:AdjaraSpinsGraphics;
		
		public function AdjaraSpinsGraphics() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			cont = this;
			
		}
		
		
		
		
		
		public function initAdjaraSpins():void 
		{
			_Atlas = Assets.getAtlas("adjaraSpinsSheet", "adjaraSpinsSheetXml");
			bg = new Image(_Atlas.getTexture("bg.png"));
			bg.alignPivot(Align.CENTER, Align.TOP);
			addChild(bg);
				
			if (AdjaraSpins.FreeSpinMode == false)
			{
				congradulatuon = new Image(_Atlas.getTexture("congratulation.png"));
				congradulatuon.alignPivot(Align.CENTER, Align.TOP);
				addChild(congradulatuon);
				congradulatuon.y = 15;
				
				$textShadow = {};
				$textShadow.blurX = 2;
				$textShadow.blurY = 2;
				$textShadow.distance = 2;
				$textShadow.color = 0x543014;
				$textShadow.alpha = .6;
				$textShadow.angle = 90;
				$textShadow.quality = 2;
				$textShadow.strength = 2;
				
				
				//spin_txt = StaticGUI._creatBitmapFontTextRenderer(this, 'თქვენ დაგერიცხათ', -this.width/2, 50, this.width, 30, Assets.getFont("adjspinText").name, TextFormatAlign.CENTER, false, -5, 20);
				//spinCount_txt = StaticGUI._creatBitmapFontTextRenderer(this, '10', -this.width/2, 80, this.width, 30, Assets.getFont("adjspinText").name, TextFormatAlign.CENTER, false, -5, 30);
				info_txt = returnTFRenderer(Root.gameXML.adjaraSpins.dagericxaT + '<br><font color="#ffd618" size="24">'+AdjaraSpins.totalSpins+'</font><br>' + Root.gameXML.adjaraSpins.datrialeba + '<br/><br/><font size="10">' + Root.gameXML.adjaraSpins.activate, this.width, this.height, -this.width/2, 42, "_bpgMrgvlovaniCaps", 13, TextFormatAlign.CENTER, 0xffffff, $textShadow);
				addChild(info_txt);
				
				arrowImg = new Image(_Atlas.getTexture("arrow.png"));
				arrowImg.alignPivot(Align.CENTER, Align.TOP);
				addChild(arrowImg);
				arrowImg.y = 200;
				
				freeSpin_btn = new MyButton(_Atlas.getTextures("freeSpin_btn"),"CC");
				addChild(freeSpin_btn);
				freeSpin_btn.y = bg.height + 40;
				freeSpin_btn.addEventListener(MouseEvent.CLICK, onFreeClick);
				stageState = 1;
				
				TweenLite.from(this, 0.4, {scaleX:0.5, scaleY:0.5, ease:Expo.easeOut, alpha:0});
			}
			else
			{
				if (stageState == 1)
				{
					freeSpin_btn.removeEventListener(MouseEvent.CLICK, onFreeClick);
					StaticGUI.safeRemoveChild(freeSpin_btn, true);
					freeSpin_btn = null;
					StaticGUI.safeRemoveChild(congradulatuon, true);
					congradulatuon = null;
					StaticGUI.safeRemoveChild(arrowImg, true);
					arrowImg = null;
					StaticGUI.safeRemoveChild(info_txt, true);
					info_txt = null;
					
				}
				
				adjaratext_img = new Image(_Atlas.getTexture("adjFrSpTxt.png"));
				adjaratext_img.alignPivot(Align.CENTER, Align.TOP);
				addChild(adjaratext_img);
				adjaratext_img.y = 60;
				
				counter_txt = StaticGUI._creatBitmapFontTextRenderer(this, '0/' + AdjaraSpins.totalSpins, -this.width/2, 125, this.width, 30, Assets.getFont("adjara_spin_count_font").name, TextFormatAlign.CENTER, false, 0);
				
				
				stageState = 2;
			}
		}
		
		public function onChange(cur:int, total:int):void 
		{
			if (stageState != 2) return;
			counter_txt.text = cur + "/" + total;
		}
		
		
		
		
		public function disposeAll():void 
		{
			StaticGUI.safeRemoveChild(bg, true);
			bg = null;
			
			if (stageState == 1)
			{
				try 
				{
					freeSpin_btn.removeEventListener(MouseEvent.CLICK, onFreeClick);
					StaticGUI.safeRemoveChild(freeSpin_btn, true);
					freeSpin_btn = null;
					StaticGUI.safeRemoveChild(congradulatuon, true);
					congradulatuon = null;
					StaticGUI.safeRemoveChild(arrowImg, true);
					arrowImg = null;
					StaticGUI.safeRemoveChild(info_txt, true);
					info_txt = null;
				}catch (err:Error)
				{
					
				}
			}
			else if(stageState == 2)
			{
				StaticGUI.safeRemoveChild(adjaratext_img, true);
				adjaratext_img = null;
				StaticGUI.safeRemoveChild(counter_txt, true)
				counter_txt = null;
			}
		}
		
		
		
		public function canActivate(val:Boolean):void 
		{
			if (val)
			{
				this.touchable = true;
				this.alpha = 1;
			}
			else
			{
				this.touchable = false;
				this.alpha = 0.3;
			}
		}
		
		public function elapsed():void 
		{
			if (stageState == 2)
			{
				disposeAll();
				stageState = 0;
				AdjaraSpins.FreeSpinMode = false;
				initAdjaraSpins();
				freeSpin_btn.removeEventListener(MouseEvent.CLICK, onFreeClick);
				StaticGUI.safeRemoveChild(freeSpin_btn, true);
				freeSpin_btn = null;
				StaticGUI.safeRemoveChild(congradulatuon, true);
				congradulatuon = null;
				StaticGUI.safeRemoveChild(arrowImg, true);
				arrowImg = null;
			}
			
			info_txt.text = Root.gameXML.adjaraSpins.elapsed;
			
			TweenLite.delayedCall(5, GameHolder.cont.removeAdjaraSpinsCont);
			
			
			AdjaraSpins.FreeSpinMode = false;
			AdjaraSpins.curSpin = 0;
			AdjaraSpins.totalSpins = 0;
			
			try 
			{
				GameHolder.cont.footerHolder.spinEnabled = true;
				GameHolder.cont.footerHolder.sendSpinSecureCount = 0;
				GameHolder.cont.footerHolder.spinBtn.label = "SPIN";
			}catch (err:Error){}
		}
		
		private function onFreeClick(e:MouseEvent):void 
		{
			if (GameHolder.cont.freeSpinsState == true || GameHolder.gameState == GameHolder.DOUBLE_STATE || GameHolder.cont.bonusHolder != null || GameHolder.cont.machineHolder.isScrolling)
			{
				info_txt.text = Root.gameXML.adjaraSpins.err;
				TweenLite.delayedCall(5, removeErrorText);
				return;
			}
			AdjaraSpins.activateAdjaraSpins();
		}
		
		private function removeErrorText():void 
		{
			if (info_txt == null) return;
			info_txt.text = Root.gameXML.adjaraSpins.dagericxaT + '<br><font color="#ffd618" size="24">10</font><br>' + Root.gameXML.adjaraSpins.datrialeba + '<br/><br/><font size="10">' + Root.gameXML.adjaraSpins.activate
		}
		
		
		
		private function returnTFRenderer(curText:String, _width:Number, _height:Number, _x:Number, _y:Number, fontName:String, fontSize:int = 12, _align:String = TextFormatAlign.LEFT, fontColor:uint = 0xffffff, txtShadowObj:Object = null):TextFieldTextRenderer
		{
		   var htmlTxt:TextFieldTextRenderer = new TextFieldTextRenderer();

		   var format:TextFormat = new TextFormat( fontName );
		   
		   format.size = fontSize;
		   format.color = fontColor;
		   format.align = _align;
		   htmlTxt.textFormat = format;
		   htmlTxt.text = curText;
		   htmlTxt.wordWrap = true;
		   htmlTxt.touchable = false;
		   htmlTxt.embedFonts = true;
		   htmlTxt.antiAliasType = AntiAliasType.ADVANCED;
		   htmlTxt.isHTML = true;
		   if(_width!=-1)htmlTxt.width = _width;
		   htmlTxt.height = _height;
		  
		   htmlTxt.x = _x;
		   htmlTxt.y = _y;
		   
		   if(txtShadowObj){
			var $shadow:DropShadowFilter = new DropShadowFilter;
			
			for (var prop:String in txtShadowObj){
				$shadow[prop] = txtShadowObj[prop];
				
			}
			htmlTxt.nativeFilters = [$shadow];
			}
		   htmlTxt.validate();
		   return htmlTxt; 
		   
		   
			
		}
		
		
	}

}