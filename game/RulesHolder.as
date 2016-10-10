package game 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.utils.GoogleAnalytics;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.layout.VerticalLayout;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.machine.Machine;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	import starling.utils.Align;
	import starling.utils.Align;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class RulesHolder extends Sprite
	{
		private var scoresArr:Array;
		private var betAmount:Number;
		private var pagesCont:Sprite3D;
		private var pageBg:Image;
		private var pageBgTexture:Texture;
		private var prev_btn:MyButton;
		private var back_btn:MyButton;
		private var next_btn:MyButton;
		private var count:int;
		private var totalPages:int;
		private var scatter_txt:TextFieldTextRenderer;
		private var wild_txt:TextFieldTextRenderer;
		private var page1_txt:TextFieldTextRenderer;
		private var page2_txt:TextFieldTextRenderer;
		private var page2Bot_txt:TextFieldTextRenderer;
		private var page3_txt:TextFieldTextRenderer;
		private var page4_txt:TextFieldTextRenderer;
		private var page5_txt:TextFieldTextRenderer;
		private var first_txt:TextFieldTextRenderer;
		private var second_txt:TextFieldTextRenderer;
		private var bronze:TextFieldTextRenderer;
		private var gold:TextFieldTextRenderer;
		private var silver:TextFieldTextRenderer;
		private var platinum:TextFieldTextRenderer;
		private var gadaxdaAr:Array = [];
		private var scoresPositionsArr:Array;
		private var $textStroke:Object;
		private var $textShadowWhite:Object;
		private var wildChoose_btn:MyButton;
		private var $textShadow:Object;
		private var wildIcon:Image;
		private var gameAmountTXT:TextFieldTextRenderer;
		private var toWinTXT:TextFieldTextRenderer;
		private var toWinTXTMast:TextFieldTextRenderer;
		private var page4_Prize_txt:TextFieldTextRenderer;
		private var prizesAr:Array;
		private var prizesAr_text:TextFieldTextRenderer;
		private var container:ScrollContainer;
		
		public function RulesHolder(bet:Number) 
		{
			betAmount = bet;
			prizesAr = Root.prizesAr;
			scoresArr = [[10, 30, 100], [10, 30, 100], [20, 50, 200], [40, 100, 500], [40, 100, 500], [10, 50, 200, 3000], [15, 100, 500], [100]];
			scoresPositionsArr = [new Point(145,90), new Point(-240, 90), new Point(145,-25), new Point(-240,-25), new Point(145,-130), new Point(-240,-150), new Point(10,-30), new Point(10, 145)];
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			initPayTable();
			//this.alignPivot(Align.CENTER, Align.CENTER);
		}
		
		private function initPayTable():void 
		{
			totalPages = GameSettings.PAYTABLE_TOTAL_PAGES;
			
			$textShadow = {};
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = .8;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			
			$textStroke = {};
			$textStroke.blurX = 2;
			$textStroke.blurY = 2;
			$textStroke.distance = 0;
			$textStroke.color = 0x000000;
			$textStroke.alpha = 0.7;
			$textStroke.angle = 120;
			$textStroke.quality = 5;
			$textStroke.strength = 15;
			
			$textShadowWhite = {};
			$textShadowWhite.blurX = 2;
			$textShadowWhite.blurY = 2;
			$textShadowWhite.distance = 1;
			$textShadowWhite.color = 0xffffff;
			$textShadowWhite.alpha = .38;
			$textShadowWhite.angle = 90;
			$textShadowWhite.quality = 1;
			$textShadowWhite.strength = 1;
			
			
			pagesCont = new Sprite3D();
			pagesCont.y = -10;
			pagesCont.x = 0;
			addChild(pagesCont);
			
			prev_btn = new MyButton(Assets.getAtlas("paytableAssetsImg", "paytableAssetsXml").getTextures("backBtn"), "CC");
			prev_btn.x = -105;
			prev_btn.y = 261;
			addChild(prev_btn);
			
			back_btn = new MyButton(Assets.getAtlas("paytableAssetsImg", "paytableAssetsXml").getTextures("togameBtn"), "CC");
			back_btn.x = 0;
			back_btn.y = prev_btn.y;
			addChild(back_btn);
			
			next_btn = new MyButton(Assets.getAtlas("paytableAssetsImg", "paytableAssetsXml").getTextures("nextBtn"), "CC");
			next_btn.x = 105;
			next_btn.y = prev_btn.y-1;
			addChild(next_btn);
			
			prev_btn.addEventListener(MouseEvent.CLICK, onNextPrevClick);
			next_btn.addEventListener(MouseEvent.CLICK, onNextPrevClick);
			back_btn.addEventListener(MouseEvent.CLICK, onBackClick);
			
			count = 1;
			setPage(count);
			
			TweenMax.from(pagesCont, 0.8, { rotationX:deg2rad( -80), alpha:0, ease:Back.easeInOut } );
			
			TweenMax.from(this, 0.8, {scaleX:0, scaleY:0, ease:Expo.easeOut});
			
			
			GoogleAnalytics._sendScreenView('Slot paytable screen');
			
		}
		
		private function onBackClick(e:MouseEvent):void 
		{
			this.touchable = false;
			TweenMax.to(pagesCont, 1, { rotationX:deg2rad( -80), alpha:0, ease:Back.easeInOut } );
			TweenMax.to(this, 1, { scaleX:2, scaleY:2, alpha:0, ease:Expo.easeInOut, onComplete:GameHolder.cont.removePaytable } );
		}
		
		public function disposePaytable():void 
		{
			Assets.disposeTextureItem("paytableBg1");
			Assets.disposeTextureItem("paytableBg2");
			Assets.disposeTextureItem("paytableBg3");
			Assets.disposeTextureItem("paytableBg4");
			Assets.disposeTextureItem("paytableBg5");
			Assets.disposeTextureItem("paytableBg6");
			//Assets.disposeAtlasItem("paytableAssetsImg");
			StaticGUI.safeRemoveChild(pagesCont, true);
			StaticGUI.safeRemoveChild(prev_btn, true);
			StaticGUI.safeRemoveChild(back_btn, true);
			StaticGUI.safeRemoveChild(next_btn, true);
			clearPage(); 
			//GameHolder.cont.removePaytable();
		}
		
		private function onNextPrevClick(e:MouseEvent):void 
		{
			if (e.params.currentTarget == next_btn)
			{
				if (count + 1 > totalPages)
				{
					count = 1;
					setPage(count);
				}
				else
				{
					count++;
					if (count == 4)
					count++;
					setPage(count);
				}
			}
			else
			{
				if (count - 1 <= 0)
				{
					count = totalPages;
					setPage(count);
				}
				else
				{
					count--;
					if (count == 4)
					count--;
					setPage(count);
				}
			}
			
			//updateScores();
			//updateTexts();
		}
		
		
		
		public function setPage(num:Number):void 
		{
			var format:TextFormat;
			/*if (pageBgTexture != null)
				pageBgTexture.dispose();
			if (pageBg != null)
				pageBg.dispose();
			*/
			
			
			for (var i:int = 0; i < pagesCont.numChildren; i++) 
			{
				StaticGUI.safeRemoveChild(pagesCont.getChildAt(i), true);
			}
			
			pageBgTexture = Assets.getTexture("paytableBg" + String(num));
			pageBg = new Image(pageBgTexture);
			if (num == 4)
			{
				pageBg.y -= 30;
			}
			pageBg.alignPivot(Align.CENTER, Align.CENTER);
			pagesCont.addChild(pageBg);
			
			clearPage();
			if (num == 1)
			{
				
				gadaxdaAr = [];
				var scoreString:String;
				var numsTxt:TextFieldTextRenderer;
				var numAr:Array = [5, 4, 3, 2];
				for (var j:int = 0; j < scoresArr.length; j++) 
				{
					scoreString = "";
					for (var k:int = 0; k < scoresArr[j].length; k++) 
					{
						scoreString += (j == 7 ? String(3) : String(numAr[k])) + '<font color="#ffffff"> •    ' + String(Number(scoresArr[j][scoresArr[j].length-k-1]) * betAmount) + "</font><br/>";
					}
					
					numsTxt = returnTFRenderer(scoreString, 200, 100, scoresPositionsArr[j].x, scoresPositionsArr[j].y, "_myriadProBold", j==6?22:19, TextFormatAlign.LEFT, 0xfba90c, $textStroke);
					gadaxdaAr.push(numsTxt);
					pagesCont.addChild(numsTxt);
				}
				
			}
			
		}
		
		private function removeScrollTween(e:TouchEvent):void 
		{
			TweenMax.killTweensOf(container);
		}
		
		
		
		private function addAutoScrollFunc():void 
		{
			var max:int = container.maxVerticalScrollPosition;
			TweenMax.to(container, 15, {delay:0.8, verticalScrollPosition:max, ease:Linear.easeNone});
		}
		
		
		private function onWildSelectorClick(e:MouseEvent):void 
		{
			GameHolder.cont.addWildSelector();
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
		
		
		
		private function clearPage():void
		{
			StaticGUI.safeRemoveChild(scatter_txt, true);
			scatter_txt = null;
			StaticGUI.safeRemoveChild(wildIcon, true);
			wildIcon = null;
			StaticGUI.safeRemoveChild(wild_txt, true);
			wild_txt = null;
			StaticGUI.safeRemoveChild(wild_txt, true);
			wild_txt = null;
			StaticGUI.safeRemoveChild(page1_txt, true);
			page1_txt = null;
			StaticGUI.safeRemoveChild(page2_txt, true);
			page2_txt = null;
			StaticGUI.safeRemoveChild(prizesAr_text, true);
			prizesAr_text = null;
			StaticGUI.safeRemoveChild(page2Bot_txt, true);
			page2Bot_txt = null;
			StaticGUI.safeRemoveChild(page3_txt, true);
			page3_txt = null;
			StaticGUI.safeRemoveChild(page4_txt, true);
			page4_txt = null;
			StaticGUI.safeRemoveChild(page4_Prize_txt, true);
			page4_Prize_txt = null;
			StaticGUI.safeRemoveChild(page5_txt, true);
			page5_txt = null;
			StaticGUI.safeRemoveChild(first_txt, true);
			first_txt = null;
			StaticGUI.safeRemoveChild(second_txt, true);
			second_txt = null;
			StaticGUI.safeRemoveChild(bronze, true);
			bronze = null;
			StaticGUI.safeRemoveChild(gold, true);
			gold = null;
			StaticGUI.safeRemoveChild(silver, true);
			silver = null;
			StaticGUI.safeRemoveChild(platinum, true);
			platinum = null;
			StaticGUI.safeRemoveChild(container, true);
			container = null;
			
			
			StaticGUI.safeRemoveChild(gameAmountTXT, true);
			gameAmountTXT = null;
			StaticGUI.safeRemoveChild(toWinTXT, true);
			toWinTXT = null;
			StaticGUI.safeRemoveChild(toWinTXTMast, true);
			toWinTXTMast = null;
			
			if (wildChoose_btn != null) wildChoose_btn.removeEventListener(MouseEvent.CLICK, onWildSelectorClick);
			StaticGUI.safeRemoveChild(wildChoose_btn, true);
			wildChoose_btn = null;
			
			
			for (var i:int = 0; i < gadaxdaAr.length; i++) 
			{
				StaticGUI.safeRemoveChild(gadaxdaAr[i], true);
				gadaxdaAr[i] = null;
			}
			
			gadaxdaAr = [];
			
		}
		
	}

}