package bonus 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import connection.SocketAnaliser;
	import feathers.controls.text.TextFieldTextRenderer;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.footer.FooterHolder;
	import game.GameHolder;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.Align;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class BonusMcContainer extends Sprite
	{
		
		public var bonusWin:Number = 0;
		public var startWin:Number;
		
		private var bonusBg:Image;
		private var statusBg:Image;
		private var bonusScoreItem:Sprite;
		
		private var bonusScoresAr:Array = [];
		private var backgroundImg:Image;
		private var daxliImg:Image;
		private var begemotiMc:MovieClip;
		private var sasworiImg:Image;
		private var totalBetImg:Image;
		private var bonusWinImg:Image;
		private var totalWinImg:Image;
		private var totalBet_txt:TextFieldTextRenderer;
		private var $textShadow:Object;
		private var TotalBet_mc:Sprite;
		private var bonusWin_mc:Sprite;
		private var totalWin_mc:Sprite;
		public var bonusWin_txt:TextFieldTextRenderer;
		public var totalWin_txt:TextFieldTextRenderer;
		private var totalBetAmount:Number;
		private var sazamtroMcAr:Array;
		private var saz_con:Sprite;
		private var BonusStrikes:int;
		private var bonusStrikes_txt:TextFieldTextRenderer;
		public var bonusInited:Boolean = false;
		
		
		public function BonusMcContainer(totalBetAmount:Number, BonusStrikes:int) 
		{
			this.BonusStrikes = BonusStrikes;
			this.totalBetAmount = totalBetAmount;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			this.y = 22;
			this.x = -1;
			
			initBonusStage();
			
			Root.soundManager.PlaySound("bonusSound");
		}
		
		
		private function initBonusStage():void 
		{
			backgroundImg = new Image(Assets.getTexture("bonusBg"));
			backgroundImg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(backgroundImg);
			
			begemotiMc = new MovieClip(Assets.getAtlas("begemotianimation", "begemotianimationXml").getTextures(""), 40);
			begemotiMc.alignPivot(Align.CENTER, Align.CENTER);
			begemotiMc.x = 50;
			begemotiMc.y = -15;
			addChild(begemotiMc);
			//Starling.juggler.add(begemotiMc);
			
			daxliImg = new Image(Assets.getTexture("daxli"));
			daxliImg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(daxliImg);
			daxliImg.y = 30;
			
			
			var canvas:Canvas;
			saz_con = new Sprite();
			var pnt:Point;
			var posAr:Array;
			var saz_btn:MyButton;
			var sazamtroImg:Image;
			var xmlClass:Class = Assets["sazamtroSheetXml"];
			var sazamtroXml:XML = XML(new xmlClass());
			var sazXmlList:XMLList = new XMLList(sazamtroXml.layer);
			sazamtroMcAr = [];
			
			for (var i:int = 0; i < sazXmlList.length(); i++) 
			{
				posAr = sazXmlList[i].@pos.split(",");
				pnt = new Point(posAr[0], posAr[1]);
				
				saz_btn = new MyButton(null);
				saz_btn.DEFAULT_SOUND = "bonusItemClick";
				saz_btn.name = sazXmlList[i].@id;
				sazamtroImg = new Image(Assets.getTexture("sazamtroSheet"));
				sazamtroImg.name = sazXmlList[i].@id;
				sazamtroImg.color = 0xf8ff3d;
				sazamtroImg.touchable = false;
				saz_btn.x = pnt.x;
				saz_btn.y = pnt.y;
				saz_btn.addChild(sazamtroImg);
				saz_con.addChild(saz_btn);
				
				canvas = new Canvas();
				canvas.beginFill(0xff0000);
				canvas.drawCircle(80, 110, 65);
				canvas.endFill();
				canvas.alpha = 0;
				saz_btn.addChild(canvas);
				saz_btn.opt.bonusInd = (i);
				sazamtroMcAr.push(saz_btn);
				
				saz_btn.addEventListener(MouseEvent.MOUSE_OVER, onSazamtroOver);
				saz_btn.addEventListener(MouseEvent.MOUSE_OUT, onSazamtroOut);
				saz_btn.addEventListener(MouseEvent.CLICK, onSazamtroClick);
				pnt = null;
			}
			
			saz_con.pivotX = int(saz_con.width / 2) ;
			saz_con.pivotY = int(saz_con.height / 2) ;
			//saz_con.alignPivot(Align.CENTER, Align.CENTER);
			addChild(saz_con);
			saz_con.y = 175;
			saz_con.x = 25;
			
			sasworiImg = new Image(Assets.getAtlas("bonusAssetsImg", "bonusAssetsXml").getTexture("saswori.png"));
			sasworiImg.pivotX = int(sasworiImg.width/2)
			sasworiImg.pivotY = int(sasworiImg.height / 2)
			sasworiImg.scaleX = sasworiImg.scaleY = 0.8;
			addChild(sasworiImg);
			sasworiImg.x = -385;
			sasworiImg.y = 260;
			sasworiImg.touchable = false;
			
			
			TotalBet_mc = new Sprite();
			addChild(TotalBet_mc);
			totalBetImg = new Image(Assets.getAtlas("bonusAssetsImg", "bonusAssetsXml").getTexture("totalBet.png"));
			TotalBet_mc.addChild(totalBetImg);
			
			/*bonusWin_mc = new Sprite();
			addChild(bonusWin_mc);
			bonusWinImg = new Image(Assets.getAtlas("bonusAssetsImg", "bonusAssetsXml").getTexture("bonusWin.png"));
			bonusWin_mc.addChild(bonusWinImg);*/
			
			totalWin_mc = new Sprite();
			addChild(totalWin_mc);
			totalWinImg = new Image(Assets.getAtlas("bonusAssetsImg", "bonusAssetsXml").getTexture("totalWin.png"));
			totalWin_mc.addChild(totalWinImg);
			
			
			totalWin_mc.x = 203;
			totalWin_mc.y = -260;
			
			TotalBet_mc.x = -412;
			TotalBet_mc.y = -260;
			
			/*bonusWin_mc.x = -412;
			bonusWin_mc.y = -140;*/
			
			
			$textShadow = {};
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = .8;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 2;
			
			totalBet_txt = returnTFRenderer(String(FooterHolder.InLari == false ? totalBetAmount : Number(totalBetAmount/100).toFixed(2)), 200, 100, 0, 0, "_digital7", 30, TextFormatAlign.CENTER, 0xffbd0e, $textShadow);
			totalBet_txt.y = 60;
			TotalBet_mc.addChild(totalBet_txt);
			
			/*bonusWin_txt = returnTFRenderer("0", 200, 100, 0, 0, "_digital7", 30, TextFormatAlign.CENTER, 0xffbd0e, $textShadow);
			bonusWin_txt.y = 60;
			bonusWin_mc.addChild(bonusWin_txt);*/
			
			totalWin_txt = returnTFRenderer("0", 200, 100, 0, 0, "_digital7", 30, TextFormatAlign.CENTER, 0xffbd0e, $textShadow);
			totalWin_txt.x = 20;
			totalWin_txt.y = 60;
			totalWin_mc.addChild(totalWin_txt);
			
			
			for (var j:int = 0; j < this.numChildren; j++) 
			{
				TweenLite.from(this.getChildAt(j), 0.8, {alpha:0, scaleX:0.5, scaleY:0.5, delay:j*0.1, ease:Back.easeOut});
			}
			
			for (var k:int = 0; k < sazamtroMcAr.length; k++) 
			{
				TweenLite.from(sazamtroMcAr[sazamtroMcAr.length - k - 1], 1, {alpha:0, delay:k*0.05, y:-300, ease:Bounce.easeOut});
			}
			
			
			bonusStrikes_txt = returnTFRenderer("", 400, 100, 0, 0, "_robotoBlack", 28, TextFormatAlign.CENTER, 0xffbd0e, $textShadow);
			bonusStrikes_txt.x = 0;
			bonusStrikes_txt.y = 348;
			addChild(bonusStrikes_txt);
			bonusStrikes_txt.alignPivot(Align.CENTER, Align.CENTER);
			
			updateBonusStrikes(BonusStrikes);
			
			bonusInited = true;
			
			
		}
		
		private function updateBonusStrikes(bb:int):void 
		{
			bonusStrikes_txt.text = "BONUS STRIKES: " + String(bb);
		}
		
		
		private function createStatusMc():void
		{
			
		}
		
		
		//on tipebi mouse event
		private function onSazamtroOut(e:MouseEvent):void 
		{
			var but:MyButton = e.params.currentTarget as MyButton;
			//but.filter = BlurFilter.createGlow(0xf8ff3d, 0);
			//but.getChildByName(but.name).alpha = 0;
			but.filter = null;
			but = null;
			
		}
		
		private function onSazamtroOver(e:MouseEvent):void 
		{
			var but:MyButton = e.params.currentTarget as MyButton;
			//but.filter = BlurFilter.createGlow(0xf8ff3d, 1, 30, 2);
			
			var filterRed:ColorMatrixFilter = new ColorMatrixFilter();
			filterRed.tint(Color.YELLOW, 1);
			but.filter = filterRed;
			but = null;
		}
		
		private function onSazamtroClick(e:MouseEvent):void 
		{
			//Root.connectionManager.sendData( {MT:SocketAnaliser.bonusItem, SID:"",IM:{"Index":13}});
			Root.connectionManager.sendData( {MT:SocketAnaliser.bonusItem, SID:"",IM:{"Index":e.params.currentTarget.opt.bonusInd}});
		}
		
		
		
		
		
		
		
		public function bonusItemChosen(obj:Object):void 
		{
			/*MyButton(sazamtroMcAr[obj.Index]).mouseEnabled = false;
			MyButton(sazamtroMcAr[obj.Index]).filter = null;
			MyButton(sazamtroMcAr[obj.Index]).alpha = 0.4;
			
			MyButton(sazamtroMcAr[obj.Index]).removeEventListener(MouseEvent.MOUSE_OVER, onSazamtroOver);
			MyButton(sazamtroMcAr[obj.Index]).removeEventListener(MouseEvent.MOUSE_OUT, onSazamtroOut);
			MyButton(sazamtroMcAr[obj.Index]).removeEventListener(MouseEvent.CLICK, onSazamtroClick);
			
			
			BonusStrikes = BonusStrikes - 1;
			updateBonusStrikes(BonusStrikes);
			
			bonusScoreItem = new Sprite();
			var bonusScoreBg:Image = new Image(Assets.getAtlas("bonusAssetsImg", "bonusAssetsXml").getTexture("scoreItem.png"));
			bonusScoreBg.scaleX = bonusScoreBg.scaleY = 0.8;
			bonusScoreBg.color = Color.YELLOW;
			bonusScoreBg.alignPivot(Align.CENTER, Align.CENTER);
			bonusScoreItem.addChild(bonusScoreBg);
			var val_txt:TextField = new TextField(100, 50, "+" + obj.Bonus, "_myriadProBold", 26, 0x000000, true);
			val_txt.alignPivot(Align.CENTER, Align.CENTER);
			val_txt.y = -4;
			bonusScoreItem.addChild(val_txt);
			
			bonusScoreItem.x = sazamtroMcAr[obj.Index].x + sazamtroMcAr[obj.Index].width/2;
			bonusScoreItem.y = sazamtroMcAr[obj.Index].y + sazamtroMcAr[obj.Index].height / 2 - 30;
			saz_con.addChild(bonusScoreItem);
			
			if (obj.Wolf == true)
			{
				Starling.juggler.add(begemotiMc);
				begemotiMc.addEventListener(Event.COMPLETE, stopbegemotiF);
				bonusScoreBg.scaleX = bonusScoreBg.scaleY = 1.2;
				bonusScoreBg.color = Color.WHITE;
				MyButton(sazamtroMcAr[obj.Index]).alpha = 0;
				val_txt.text = "x" + obj.Bonus;
			}
			
			TweenMax.from(bonusScoreItem, 0.8, { alpha:0, scaleX:0, scaleY:0, ease:Elastic.easeOut } );
			
			bonusScoresAr.push(bonusScoreItem);
			bonusScoreItem = null;
			val_txt = null;
			bonusScoreBg = null;
			
			startWin = bonusWin;
			bonusWin = obj.BonusWin;
			TweenMax.to(this, 1, { startWin:bonusWin, onUpdate:updateWinAnim, ease:Circ.easeOut } );
			
			//bonusWin_txt.text = String(totalBetAmount) + " x " + obj.Bonus + " = " + (totalBetAmount * obj.Bonus); 
			//bonusWin_txt.text = String(totalBetAmount * obj.Bonus); 
			
			
			
			
			
			if (obj.End == true)
			{
				this.touchable = false;
				
				TweenLite.delayedCall(2, GameHolder.cont.bonusFinish, [bonusWin, false]);
				
				//Root.soundManager.PlaySound("roundLose");
				Root.soundManager.PlaySound("roundWin");
			}*/
			
			
		}
		
		private function stopbegemotiF(e:Event):void 
		{
			begemotiMc.stop();
			begemotiMc.currentFrame = 0;
			Starling.juggler.remove(begemotiMc);
		}
		
		
		
		
		private function updateWinAnim():void
		{
			totalWin_txt.text = "" + String(FooterHolder.InLari == false ? int(int(startWin)/GameSettings.CREDIT_VAL) : Number(startWin/100).toFixed(2));
		}
		
		
		
		
		
		
		
		
		private function animateBeforeExit():void
		{
			for (var j:int = 0; j < this.numChildren; j++) 
			{
				TweenMax.to(this.getChildAt(j), 0.4, {delay:j*0.1, alpha:0, scaleX:0, scaleY:0, ease:Back.easeIn});
			}
			
			TweenLite.delayedCall(0.4 + 0.1*j, disposeBonusStage);
		}

		
		private function disposeBonusStage():void 
		{
			
		}
		
		public function hide():void
		{
			animateBeforeExit();
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
		
		
		public function modifyCharacters(obj:Object):void 
		{
			for (var i:int = 0; i < obj.BonusIndexes.length; i++) 
			{
				MyButton(sazamtroMcAr[obj.BonusIndexes[i]]).mouseEnabled = false;
				MyButton(sazamtroMcAr[obj.BonusIndexes[i]]).visible = false;
				
				MyButton(sazamtroMcAr[obj.BonusIndexes[i]]).removeEventListener(MouseEvent.MOUSE_OVER, onSazamtroOver);
				MyButton(sazamtroMcAr[obj.BonusIndexes[i]]).removeEventListener(MouseEvent.MOUSE_OUT, onSazamtroOut);
				MyButton(sazamtroMcAr[obj.BonusIndexes[i]]).removeEventListener(MouseEvent.CLICK, onSazamtroClick);
				
				
				
				
				/*bonusScoreItem = new Sprite();
				var bonusScoreBg:Image = new Image(Assets.getAtlas("bonusAssetsImg", "bonusAssetsXml").getTexture("scoreItem.png"));
				bonusScoreBg.scaleX = bonusScoreBg.scaleY = 0.8;
				bonusScoreBg.color = Color.YELLOW;
				bonusScoreBg.alignPivot(Align.CENTER, Align.CENTER);
				bonusScoreItem.addChild(bonusScoreBg);
				var val_txt:TextField = new TextField(100, 50, "+" + obj.BonusWins[i], "_myriadProBold", 26, 0x000000, true);
				val_txt.alignPivot(Align.CENTER, Align.CENTER);
				val_txt.y = -4;
				bonusScoreItem.addChild(val_txt);
				
				bonusScoreItem.x = sazamtroMcAr[obj.BonusIndexes[i]].x + sazamtroMcAr[obj.BonusIndexes[i]].width/2;
				bonusScoreItem.y = sazamtroMcAr[obj.BonusIndexes[i]].y + sazamtroMcAr[obj.BonusIndexes[i]].height / 2 - 30;
				saz_con.addChild(bonusScoreItem);
				
				if (obj.Wolf == true)
				{
					Starling.juggler.add(begemotiMc);
					begemotiMc.addEventListener(Event.COMPLETE, stopbegemotiF);
					bonusScoreBg.scaleX = bonusScoreBg.scaleY = 1.2;
					bonusScoreBg.color = Color.WHITE;
					MyButton(sazamtroMcAr[obj.Index]).alpha = 0;
					val_txt.text = "x" + obj.Bonus;
				}
				
				TweenMax.from(bonusScoreItem, 0.8, { alpha:0, scaleX:0, scaleY:0, ease:Elastic.easeOut } );
				
				
				
				bonusScoresAr.push(bonusScoreItem);
				bonusScoreItem = null;
				val_txt = null;*/
				
				/*startWin = bonusWin;
				bonusWin = obj.BonusWin;
				TweenMax.to(this, 1, {startWin:bonusWin, onUpdate:updateWinAnim, ease:Circ.easeOut});*/
			}
		}
		
	}

}