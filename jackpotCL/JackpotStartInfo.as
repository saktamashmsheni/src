package jackpotCL 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.TextArea;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import game.GameHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	import starling.utils.Align;
	import starling.utils.Align;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class JackpotStartInfo extends Sprite
	{
		private var backgroundImg:Image;
		private var quad:Quad;
		private var xBtn:MyButton;
		private var startGame:MyButton;
		private var bronze:TextArea;
		private var gold:TextArea;
		private var silver:TextArea;
		private var platinum:TextArea;
		private var startText_txt:TextArea;
		
		public function JackpotStartInfo() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			initialise();
		}
		
		
		
		private function initialise():void 
		{
			quad = new Quad(this.stage.stageWidth + 400, this.stage.stageHeight + 400, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			addChild(quad);
			quad.alpha = 0.5;
			
			backgroundImg = new Image(Assets.getAtlas("startJacpotInfoSheet", "startJacpotInfoSheetXml").getTexture("bg.png"));
			backgroundImg.alignPivot(Align.CENTER, Align.CENTER);
			addChild(backgroundImg);
			
			xBtn = new MyButton(Assets.getAtlas("startJacpotInfoSheet", "startJacpotInfoSheetXml").getTextures("xBtn"));
			xBtn.x = 232;
			xBtn.y = -187;
			addChild(xBtn);
			
			startGame = new MyButton(Assets.getAtlas("startJacpotInfoSheet", "startJacpotInfoSheetXml").getTextures("start"));
			startGame.alignPivot(Align.CENTER, Align.CENTER);
			startGame.x = 0;
			startGame.y = 135;
			addChild(startGame);
			startGame.setText(GameSettings.GAME_XML.startT, "dejavuSans", 15);
			startGame.val_txt.y -= 3;
			
			startGame.addEventListener(MouseEvent.CLICK, onX);
			xBtn.addEventListener(MouseEvent.CLICK, onX);
			
			
			
			startText_txt = returnTFRenderer(GameSettings.GAME_XML.startPageInfo, 465, 75, -234, -137, "_bpgMrgvlovaniCaps", 13, TextFormatAlign.CENTER);
			addChild(startText_txt);
			
			bronze = returnTFRenderer(GameSettings.GAME_XML.payTable.page6.ji[0], 180, 50, -191, -50, "_bpgMrgvlovaniCaps", 9);
			addChild(bronze);
			
			gold = returnTFRenderer(GameSettings.GAME_XML.payTable.page6.ji[2], 180, 50, -191, 43, "_bpgMrgvlovaniCaps", 9);
			addChild(gold);
			
			silver = returnTFRenderer(GameSettings.GAME_XML.payTable.page6.ji[1], 180, 50, 23, -50, "_bpgMrgvlovaniCaps", 9);
			addChild(silver);
			
			platinum = returnTFRenderer(GameSettings.GAME_XML.payTable.page6.ji[3], 180, 50, 23, 43, "_bpgMrgvlovaniCaps", 9);
			addChild(platinum);
			
			
			TweenLite.from(this, 0.6, { delay:0.5, alpha:0, scaleX:0, scaleY:0, ease:Back.easeOut } );
			TweenLite.delayedCall(1.7, Root.soundManager.PlaySound, ["jackpotChange"]);
		}
		
		private function onX(e:MouseEvent):void 
		{
			disposeAll();
			GameHolder.cont.removeJackpotStartInfo();
		}
		
		
		private function disposeAll():void 
		{
			StaticGUI.safeRemoveChild(quad, true)
			quad = null;
			StaticGUI.safeRemoveChild(backgroundImg, true)
			backgroundImg = null;
			StaticGUI.safeRemoveChild(startGame, true)
			startGame = null;
			StaticGUI.safeRemoveChild(startText_txt, true)
			startText_txt = null;
			StaticGUI.safeRemoveChild(bronze, true)
			bronze = null;
			StaticGUI.safeRemoveChild(gold, true)
			gold = null;
			StaticGUI.safeRemoveChild(silver, true)
			silver = null;
			StaticGUI.safeRemoveChild(platinum, true)
			platinum = null;
		}
		
		
		
		
		private function returnTFRenderer(curText:String, _width:Number, _height:Number, _x:Number, _y:Number, fontName:String, fontSize:int = 12, _align:String = TextFormatAlign.LEFT, fontColor:uint = 0xffffff):TextArea
		{

			var textArea:TextArea = new TextArea();
		   textArea.width = _width;
		   textArea.height = _height;
		   textArea.isEditable = false;
		   textArea.isEnabled = false;
		   textArea.x = _x
		   textArea.y = _y;
		   textArea.text = curText;
		   textArea.textEditorFactory = function():ITextEditorViewPort{
			var textEditor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
			textEditor.styleProvider = null;
			textEditor.textFormat = new TextFormat(fontName, fontSize, fontColor, null, null, null, null, null, _align);
			textEditor.multiline = true;
			textEditor.embedFonts = true;
			textEditor.isHTML = true;
			textEditor.wordWrap = true;
			
			return textEditor;
		   }
		   
		   textArea.validate();
		   return textArea;
			
		}
		
	}

}