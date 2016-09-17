package cashier
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.utils.GoogleAnalytics;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import connection.ConnectionManager;
	import feathers.controls.Button;
	import feathers.controls.ProgressBar;
	import feathers.controls.Slider;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
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
	public class TransferContainer extends Sprite
	{
		
		private var mainBalance:String;
		private var gameBalance:String;
		private var finalTransferNum:Number;
		
		private var transferHost:String;
		
		private var transferTogameBol:Boolean = true;
		
		private static const DONE_LOADING:String = "doneLoading";
		
		public static var CLOSE_TRANSFER:String = "shouldCloseTransfer";
		
		private var moneyObject:Object;
		
		private var onlyInPermition:Boolean = false;
		private var bgMc:Sprite;
		private var quad:Quad;
		private var trBg:Image;
		private var x_btn:MyButton;
		private var logo:Image;
		private var toGame_btn:MyButton;
		private var toMain_btn:MyButton;
		private var transferedMoneyBg:Image;
		private var loadBg:Image;
		private var maska:Quad;
		private var sliderBg:Image;
		private var button:MyButton;
		private var buttonQuad:Quad;
		private var head:MyButton;
		private var headBg:Image;
		private var tomain_txt:TextField;
		private var mainB_bg:Image;
		private var mainBalance_txt:TextFieldTextRenderer;
		private var toGame_txt:TextField;
		private var gameB_bg:Image;
		private var gameBalance_txt:TextFieldTextRenderer;
		private var arrow:Image;
		private var transfer_btn:MyButton;
		private var slider:SliderTransf;
		private var transfer_txt:TextInput;
		private var transferValuta_txt:TextField;
		private var valuta_txt:TextField;
		private var progressBar:ProgressBar;
		public var shouldRemoveThis:Boolean = false;
		
		
		public function TransferContainer(_onlyInPermition:Boolean = false) 
		{
			onlyInPermition = _onlyInPermition;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initTransfer();
			initialise();
			
			TweenMax.from(this, 0.6, { scaleX:0.5, scaleY:0.5, alpha:0, ease:Expo.easeOut } );
		}
		
		
		private function initTransfer():void 
		{
			bgMc = new Sprite();
			addChild(bgMc);
			quad = new Quad(this.stage.stageWidth + 400, this.stage.stageHeight + 400, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			bgMc.addChild(quad);
			bgMc.alpha = 0.85;
			
			trBg = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("transferBg.png"));
			trBg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(trBg);
			trBg.y = -55;
			
			x_btn = new MyButton((Assets.getAtlas("transferSheet", "transferSheetXml").getTextures("xBtn")), "CC");
			x_btn.x = 245;
			x_btn.y = -175;
			addChild(x_btn);
			
			/*logo = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("logo.png"));
			logo.alignPivot(Align.CENTER, Align.CENTER);
			logo.y = -235;
			addChild(logo);*/
			
			var $textShadow:Object = new Object;
			$textShadow.blurX = 2;
			$textShadow.blurY = 2;
			$textShadow.distance = 2;
			$textShadow.color = 0x000202;
			$textShadow.alpha = 1;
			$textShadow.angle = 90;
			$textShadow.quality = 2;
			$textShadow.strength = 1;
			
			toGame_btn = new MyButton(Assets.getAtlas("transferSheet", "transferSheetXml").getTextures("inBtn"), "CC");
			toGame_btn.hoverEnabled = false;
			toGame_btn.x = -80;
			toGame_btn.y = -90;
			addChild(toGame_btn);
			toGame_btn.setFontText(GameSettings.GAME_XML.transfer.shetana, "_bpgMrgvlovaniCaps", 14, 0xffffff, $textShadow, TextFormatAlign.CENTER);
			toGame_btn.val_txt.x += 8;
			toGame_btn.val_txt.y += 20;
			
			toMain_btn = new MyButton(Assets.getAtlas("transferSheet", "transferSheetXml").getTextures("outBtn"), "CC");
			toMain_btn.hoverEnabled = false;
			toMain_btn.x = 80;
			toMain_btn.y = -90;
			addChild(toMain_btn);
			toMain_btn.setFontText(GameSettings.GAME_XML.transfer.gamotana, "_bpgMrgvlovaniCaps", 14, 0xffffff, $textShadow, TextFormatAlign.CENTER);
			toMain_btn.val_txt.x += 8;
			toMain_btn.val_txt.y += 20;
			
			
			
			//----------slider------------------------------------------------------------------
			slider = new SliderTransf();
			slider.y = -27;
			slider.addEventListener(Event.CHANGE, slider_changeHandler);
			addChild(slider);
			
			
			
			transferedMoneyBg = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("transferedMoneyBg.png"));
			transferedMoneyBg.alignPivot(Align.CENTER, Align.CENTER);
			transferedMoneyBg.scaleX = 1.5;
			transferedMoneyBg.x = 0;
			transferedMoneyBg.y = 0;
			addChild(transferedMoneyBg);
			
			transfer_txt = new TextInput();
			this.addChild(transfer_txt);
			transfer_txt.text = "0.00";
			transfer_txt.restrict = "0-9";
			transfer_txt.maxChars = 16;
			transfer_txt.width = 183;
			transfer_txt.height = 43;
			transfer_txt.alignPivot(Align.CENTER, Align.CENTER);
			transfer_txt.x = 0;
			transfer_txt.y = transferedMoneyBg.y;
			transfer_txt.textEditorFactory = function():StageTextTextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.autoCorrect = false;
				editor.multiline = false;
				editor.textAlign = TextFormatAlign.CENTER;
				//editor.fontFamily = "_myriadProBold";
				editor.fontFamily = Assets.getFont("PerpetuaBold").name;
				editor.fontSize = 22;
				editor.color = 0x000000;
				return editor;
			}
			transfer_txt.addEventListener( FeathersEventType.FOCUS_IN, input_focusInHandler );
			
			
			
			var $tf:TextFormat = new TextFormat;
			$tf.font = Assets.getFont("dejavuSans").name;
			$tf.size =  13;
			$tf.color = 0x8c8a8a;
			$tf.bold = true;
			
			
			transferValuta_txt = new TextField(300, 23, "", $tf);
			transferValuta_txt.alignPivot(Align.CENTER, Align.CENTER);
			transferValuta_txt.y = -63;
			addChild(transferValuta_txt);
			
			valuta_txt = new TextField(300, 23, "", $tf);
			valuta_txt.alignPivot(Align.CENTER, Align.CENTER);
			valuta_txt.x = -155;
			valuta_txt.y = 200;
			addChild(valuta_txt);
			
			
			tomain_txt = new TextField(300, 23, GameSettings.GAME_XML.transfer.mainbal, $tf);
			tomain_txt.alignPivot(Align.CENTER, Align.CENTER);
			tomain_txt.x = -135;
			tomain_txt.y = 70;
			addChild(tomain_txt);
			mainB_bg = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("balanceMoneyBg.png"));
			mainB_bg.alignPivot(Align.CENTER, Align.CENTER);
			mainB_bg.x = -135;
			mainB_bg.y = 110;
			addChild(mainB_bg);
			mainBalance_txt =  StaticGUI._creatTextFieldTextRenderer(this, "0.00", -135, 115, 183, 43, '_myriadProBold', 22, 0xcdf3fb, $textShadow, TextFormatAlign.CENTER);
			mainBalance_txt.alignPivot(Align.CENTER, Align.CENTER);
			//mainBalance_txt.x = -135;
			//mainBalance_txt.y = 106;
			addChild(mainBalance_txt);
			
			
			
			
			toGame_txt = new TextField(300, 23, GameSettings.GAME_XML.transfer.gameBal, $tf);
			toGame_txt.alignPivot(Align.CENTER, Align.CENTER);
			toGame_txt.x = 135;
			toGame_txt.y = tomain_txt.y;
			addChild(toGame_txt);
			gameB_bg = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("balanceMoneyBg.png"));
			gameB_bg.alignPivot(Align.CENTER, Align.CENTER);
			gameB_bg.x = 135;
			gameB_bg.y = mainB_bg.y;
			addChild(gameB_bg);
			//gameBalance_txt = new TextField(183, 43, "0.00", Assets.getFont("PerpetuaBold").name, 26, 0xffffff, true);
			gameBalance_txt =  StaticGUI._creatTextFieldTextRenderer(this, "0.00", 135, mainBalance_txt.y, 183, 43, '_myriadProBold', 22, 0xcdf3fb, $textShadow, TextFormatAlign.CENTER);
			gameBalance_txt.alignPivot(Align.CENTER, Align.CENTER);
			//gameBalance_txt.x = 135;
			//gameBalance_txt.y = mainBalance_txt.y;
			addChild(gameBalance_txt);
			
			
			
			
			arrow = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("arrow.png"));
			arrow.pivotX = arrow.width / 2; 
			arrow.pivotY = arrow.height / 2;
			arrow.x = 0;
			arrow.y = 108;
			addChild(arrow);
			
			
			transfer_btn = new MyButton(Assets.getAtlas("transferSheet", "transferSheetXml").getTextures("transferBtn"), "CC");
			transfer_btn.y = 180;
			transfer_btn.setFontText(GameSettings.GAME_XML.transfer.transferb, "_bpgMrgvlovaniCaps", 17, 0xffffff, $textShadow, TextFormatAlign.CENTER);
			transfer_btn.val_txt.y = 15;
			addChild(transfer_btn);
			transfer_btn.scaleX = transfer_btn.scaleY = 0.85;
			
			
			toGame_btn.addEventListener(MouseEvent.CLICK, transFerToGameF);
			toMain_btn.addEventListener(MouseEvent.CLICK, transFerToMainF);
			x_btn.addEventListener(MouseEvent.CLICK, onXClick);
			transfer_btn.addEventListener(MouseEvent.CLICK, onTransferClick);
			
			GoogleAnalytics._sendScreenView('Slot cashier screen');
		}
		
		
		private function input_focusInHandler(e:Event):void 
		{
			transfer_txt.removeEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler);
			transfer_txt.addEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler);
			transfer_txt.selectRange(0, transfer_txt.text.length);
			transfer_txt.addEventListener(KeyboardEvent.KEY_DOWN, onKeyhandler);
			//transfer_txt.backgroundSkin = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("transfertextBg.png"));
			transfer_txt.addEventListener(Event.CHANGE, onTransferTextChange);
		}
		
		private function input_focusOutHandler(e:Event):void 
		{
			transfer_txt.removeEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler);
			transfer_txt.addEventListener(FeathersEventType.FOCUS_OUT, input_focusOutHandler);
			transfer_txt.selectRange(0, 0);
			transfer_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyhandler);
			//transfer_txt.backgroundSkin = null;
			transfer_txt.removeEventListener(Event.CHANGE, onTransferTextChange);
		}
		
		private function onTransferTextChange(e:Event):void
		{
			makeChanges();
		}
		
		private function onKeyhandler(e:KeyboardEvent):void 
		{
			//Tracer._log(e.charCode);
			if (e.charCode == 46)
			{
				makeChanges(true);
			}
		   // if the key is ENTER
		   if (e.charCode == 13) {
			   
			   makeChanges();
		   }
		   
		    //makeChanges();
		}
		
		//MAKE CHANGES FUNCTION
		private function makeChanges(dotBol:Boolean = false):void
		{
			if (Number(transferTogameBol == true ? mainBalance : gameBalance) == 0)
			{
				transfer_txt.text = "0.00";
				return;
			}
			
			if (dotBol == true)
			{
				transfer_txt.selectRange(transfer_txt.text.length-2, transfer_txt.text.length-2);
			}
			
			var strAr:Array = String(transfer_txt.text).split(" ");
			transfer_txt.text = strAr[0];
			
			transfer_txt.text = Number(transfer_txt.text).toFixed(2);
			if (isNaN(Number(transfer_txt.text)))
			{
				transfer_txt.text = "0.00";
			}
			
			if (Number(transfer_txt.text) > (Number(transferTogameBol == true ? mainBalance : gameBalance)))
			{
				finalTransferNum = (Number(transferTogameBol == true ? mainBalance : gameBalance))
				transfer_txt.text = finalTransferNum.toFixed(2);
			}
			else
			{
				finalTransferNum = Number(transfer_txt.text);
			}
			
			slider.removeEventListener(Event.CHANGE, slider_changeHandler);
			slider.value =  finalTransferNum * slider.maximum / Number(transferTogameBol == true ? mainBalance : gameBalance);
			slider.addEventListener(Event.CHANGE, slider_changeHandler);
			
			
		    updateSliderBalance(finalTransferNum);
		}
		
		
		
		private function initialise():void 
		{
			toMain_btn.gotoAndStop(2);
			transferMoney("getBalance");
			
			if (GameSettings.Currency_ID != 2)
			{
				valuta_txt.text = "1 " + getCurrecyType() + " = " + GameSettings.Currency_Rate + " GEL";
			}
			else
			{
				valuta_txt.text = "";
				transferValuta_txt.text = "";
			}
		}
		
		
		private function transFerToGameF(e:MouseEvent):void 
		{
			arrow.rotation = deg2rad(0);
			//head.x = 0;
			toGame_btn.gotoAndStop(1);
			toMain_btn.gotoAndStop(2);
			transfer_txt.text = "0.00";
			//finalTransferNum = 0;
		    transfer_txt.text = Number(transfer_txt.text).toFixed(2);
			transferTogameBol = true;
			makeSliderFull();
			
		}
		
		
		private function transFerToMainF(e:MouseEvent):void 
		{
			arrow.rotation = deg2rad(180);
			//head.x = 0;
			toGame_btn.gotoAndStop(2);
			toMain_btn.gotoAndStop(1);
			transfer_txt.text = "0.00";
			//finalTransferNum = 0;
		    transfer_txt.text = Number(transfer_txt.text).toFixed(2);
			transferTogameBol = false;
			makeSliderFull();
		}
		
		
		private function slider_changeHandler(e:Event):void 
		{
			var slider:Slider = Slider( e.currentTarget );
			Tracer._log( "slider.value changed:", slider.value );
			
			updateSliderBalance();
			
			slider = null;
		}
		
		
		public function getCurrecyType():String
		{
			for (var i:int = 0; i < GameSettings.Currency_Values.length; i++) 
			{
				if (GameSettings.Currency_Values[i].order == GameSettings.Currency_ID)
				{
					return GameSettings.Currency_Values[i].name;
				}
			}
			return "";
		}
		
		
		private function updateSliderBalance(number:Number = 0):void 
		{
			
			var transferString:String;
			
			if (number == 0)
			{
				transferString = String(Number(transferTogameBol == true ? mainBalance : gameBalance) * slider.value / slider.maximum); 
			}
			else
			{
				transferString = String(number); 
			}
			
			transferString = String(Number(transferString).toFixed(2));
			
			var stringArray:Array = transferString.split('.');
			
			
			
			//after dot string
			var afterDotString:String;
			afterDotString = stringArray[1];
			
			var ceilNum:Number = Number(afterDotString);
			ceilNum = ceilNum/10;
			ceilNum = Math.ceil(ceilNum);
			ceilNum = ceilNum * 10;
			
			
			//ანუ თუ არ არის ხელით ჩაწერილი თანხა
			if (number == 0)
			{
				//tu mtliani balansi metia an tolia damgvalebul ciafrianis ricxvis mashin iqneba damrgvalebuli
				if (Number((transferTogameBol == true ? mainBalance : gameBalance)) >= Number(String(stringArray[0] + "." + String(ceilNum))) && ceilNum != 100)
				{
					afterDotString = String(ceilNum);
				}
			}
				
			
			if (number == 0)
			{
				//tu afterDotString udrida 100 mashin 1 mtelit unda moimatebina ricxvs da magitoa es
				//Tracer._log(Number(afterDotString) + 9);
				if ((Number(afterDotString) + 9) >= 100)
				{
					finalTransferNum = Number(Number(Number(stringArray[0]) + 1).toFixed(2));
					transfer_txt.text = String(Number(Number(stringArray[0]) + 1).toFixed(2))
					if (GameSettings.Currency_ID != 2 && transferTogameBol == true)
					{
						transfer_txt.text = String(transfer_txt.text) + " " + getCurrecyType();
					}
					else
					{
						transfer_txt.text = String(transfer_txt.text) + " GEL";
					}
				}
				else
				{
					finalTransferNum = Number(String(stringArray[0] + "." + afterDotString));
					transfer_txt.text = String(Number(stringArray[0] + "." + afterDotString).toFixed(2));
					if (GameSettings.Currency_ID != 2 && transferTogameBol == true)
					{
						transfer_txt.text = String(transfer_txt.text) + " " + getCurrecyType();
					}
					else
					{
						transfer_txt.text = String(transfer_txt.text) + " GEL";
					}
				}
				
				Tracer._log(transfer_txt.text)
				Tracer._log(gameBalance);
				
				//shemowmeba mtlianisa da gadasaricxis tu metia
				if (finalTransferNum > Number((transferTogameBol == true ? mainBalance : gameBalance)))
				{
					transfer_txt.text = String((transferTogameBol == true ? mainBalance : gameBalance))
					if (GameSettings.Currency_ID != 2 && transferTogameBol == true)
					{
						transfer_txt.text = String(transfer_txt.text) + " " + getCurrecyType();
					}
					else
					{
						transfer_txt.text = String(transfer_txt.text) + " GEL";
					}
				}
				
				
				if (finalTransferNum > Number((transferTogameBol == true ? mainBalance : gameBalance)))
				{
					finalTransferNum = Number((transferTogameBol == true ? mainBalance : gameBalance));
				}
			}
			else
			{
				finalTransferNum = number;
			}
			
			
			var strAr:Array = String(transfer_txt.text).split(" ");
			
			if (GameSettings.Currency_ID != 2)
			{
				if (transferTogameBol == true)
				{
					transferValuta_txt.text = strAr[0] + " " + getCurrecyType() + " = " + String((Number(strAr[0]) * GameSettings.Currency_Rate).toFixed(2)) + " GEL";
				}
				else
				{
					transferValuta_txt.text = strAr[0] + " GEL" + " = " + String((Number(strAr[0]) / GameSettings.Currency_Rate).toFixed(2)) + " " + getCurrecyType();
				}
			}
		}
		
		
		
		
		
		public function transferMoney(action:String):void
		{
			if (action != "getBalance")
			{
				if (Math.round(finalTransferNum * 100) == 0)
				{
					return;
				}
			}
			
			//transfer_btn.removeEventListener(MouseEvent.CLICK, onTransferClick);
			
			GameHolder.cont.showLoader();
			
			if (action == "getBalance")
			{
				Root.connectionManager.sendData({"MT":54})
			}
			else if (action == "getMoney")
			{
				shouldRemoveThis = true;
				Root.connectionManager.sendData({"MT":52,"IM": {"Amount": int(finalTransferNum*100)}})
			}
			else if (action == "addMoney")
			{
				Root.connectionManager.sendData({"MT":53,"IM": {"Amount": int(finalTransferNum*100)}})
			}
			
		}
		
		
		public function processData(obj:Object):void {
			
			moneyObject = new Object();
			
			GameHolder.cont.hideLoader();
			
			switch (obj.MT)
			{
				
				case 54:
					moneyObject.action = "GetUserBalance";
					moneyObject.adjaraUserTotalBalance = obj.IM.MainBalance;
					moneyObject.adjaraUserGameBalance = Root.userChips = obj.IM.GameBalance;
					onDoneLoading();
					
					
					makeSliderFull();
					
					if (shouldRemoveThis)
					{
						onXClick(null);
					}
					
					
					break;
				case 52:
					moneyObject.action = "GetMoney"
					onDoneLoading();
					break;
				case 53:
					moneyObject.action = "AddMoney"
					onDoneLoading();
					break;
			}
		}
		
		private function onDoneLoading():void 
		{
			Tracer._log("done loadiiiiing");
			//slider.head.x = 0;
			transfer_txt.text = "0.00";
			finalTransferNum = 0;
			
			//transfer_btn.addEventListener(MouseEvent.CLICK, onTransferClick);
			
			switch(moneyObject.action)
			{
				
				case "GetUserBalance":
					
					mainBalance = String(moneyObject.adjaraUserTotalBalance);
					gameBalance = String(moneyObject.adjaraUserGameBalance);
					
					mainBalance = String(Math.round(Number(mainBalance)));
					gameBalance = String(Math.round(Number(gameBalance)));
					
					mainBalance = String(Number(mainBalance) / 100);
					gameBalance = String(Number(gameBalance) / 100);
					
					mainBalance = String(Number(mainBalance).toFixed(2));
					gameBalance = String(Number(gameBalance).toFixed(2));
			
					mainBalance_txt.text = mainBalance + " " + getCurrecyType();
					gameBalance_txt.text = gameBalance + " GEL";		
					break;
					
				case "GetMoney":
					transferMoney("getBalance");
					break;
				case "AddMoney":
					transferMoney("getBalance");
					break;
			}
		}
		
		
		
		private function makeSliderFull():void 
		{
			slider.value = slider.maximum;
			updateSliderBalance();
		}
		
		
		private function onXClick(e:MouseEvent):void 
		{
			GameHolder.cont.removeCashier();
		}
		
		
		private function onTransferClick(e:MouseEvent):void 
		{
			if (finalTransferNum == 0)
			{
				return;
			}
			
			
			if (transferTogameBol)
			{
				transferMoney("getMoney");
			}
			else
			{
				transferMoney("addMoney");
			}
		}
		
		
	}

}