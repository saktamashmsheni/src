package com.utils {
	import feathers.controls.Button;
	import feathers.controls.TextArea;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	import flash.geom.*;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import game.footer.FooterHolder;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.Align;
	
	public class StaticGUI extends Object {
		
		
		public static const TOP_CENTER:String = "TC";
		public static const TOP_LEFT:String = "TL";
		public static const CENTER_CENTER:String = "CC";
		public static const BOTTOM_CENTER:String = "BC";
		public static const RIGHT_CENTER:String = "RC";
		public static const RIGHT_TOP:String = "RT";
		
		
		public function StaticGUI() {
			return;
		} // end function
		
		public static function commaNum(param1:int):String {
			var _loc_2:* = "";
			var _loc_3:* = String(param1);
			var _loc_4:* = 0;
			while (_loc_3.length > 0) {
				
				_loc_2 = (_loc_3.length > 3 ? (",") : ("")) + _loc_3.slice(_loc_3.length - 3, _loc_3.length) + _loc_2;
				_loc_3 = _loc_3.slice(0, _loc_3.length - 3);
			}
			return _loc_2;
		} // end function
		
		//[Inline]
		public static function safeRemoveChild(param1:DisplayObject, dispose:Boolean = false):Boolean {
			if (param1 == null) {
				//Tracer._log("couldnt remove: " + param1);
				return false;
			} else if (dispose == true) {
				param1.dispose();
			}
			if (param1.parent == null) {
				//Tracer._log("couldnt remove: " + param1);
				return false;
			}
			var _loc_2:* = param1.parent;
			_loc_2.removeChild(param1);
			return true;
		} // end function
		
		public static function removeChildren(param1:DisplayObjectContainer):void {
			if (param1 == null) {
				return;
			}
			while (param1.numChildren > 0) {
				
				param1.removeChildAt(0);
			}
			return;
		} // end function
		
		
		   
		   
		   public static function _setButtonBitmapLabel(target:Button,  lab:String, yoff:Number, fontName:String, ls:Number, fontSize:int = -1):Button{
			
			var $btn:Button = Button(target);
			$btn.label = lab;
			$btn.labelOffsetY = yoff;
			
			var format:BitmapFontTextFormat = new BitmapFontTextFormat(fontName);
			format.letterSpacing = ls;
			
			format.align = TextFormatAlign.CENTER;
			if (fontSize != -1)
			{
				format.size = fontSize;
			}
			
			$btn.defaultLabelProperties.textFormat = format;
			
			$btn.validate();
			
			return $btn; 
			
		}
		   
		   
		   
		   public static function _changeFormatOfBitmapText(_bitmapTextfield:BitmapFontTextRenderer,
															_x:Number, 
															_y:Number,
															fontName:Object, 
															_align:String = TextFormatAlign.LEFT,
														   _isHTML:Boolean = false,
														   _letterSpacing:int = -3,
														   _size:int = -1,
														   _color:uint = 0xffffff):void {
												   
				var htmlTxt:BitmapFontTextRenderer = _bitmapTextfield;

				var format:BitmapFontTextFormat = new BitmapFontTextFormat(fontName);
				format.letterSpacing = _letterSpacing;
				if (_size != -1)
				{
					format.size = _size;
				}
				
				format.color = _color;
				format.align = _align;
				htmlTxt.textFormat = format;
				htmlTxt.x = _x;
			    htmlTxt.y = _y;
				htmlTxt.wordWrap = true;
				htmlTxt.touchable = false;
			    htmlTxt.validate();
		   }
		
		
		public static function _creatTextFieldTextRenderer(cont:DisplayObjectContainer,
											   curText:String, 
													_x:Number, 
													_y:Number, 
												 _width:Number, 
												_height:Number,  
											  fontName:String, 
											  fontSize:int = 12, 
											 fontColor:uint = 0xffffff,
										  txtShadowObj:Object = null,
												_align:String = TextFormatAlign.LEFT,
											   _isHTML:Boolean = false):TextFieldTextRenderer {
												   
		   var htmlTxt:TextFieldTextRenderer = new TextFieldTextRenderer();

		   var format:TextFormat = new TextFormat( fontName );
		   
		   format.size = fontSize;
		   format.color = fontColor;
		   format.align = _align;
		   format.leading = fontSize-6;
		   htmlTxt.textFormat = format;
		   htmlTxt.text = curText;
		   htmlTxt.wordWrap = true;
		  
		   htmlTxt.touchable = false;
		   htmlTxt.embedFonts = true;
		   htmlTxt.antiAliasType = AntiAliasType.ADVANCED;
		   htmlTxt.isHTML = _isHTML;
		   cont.addChild(htmlTxt);
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
		 
		public static function _setButtonWithLabelShadow(cont:DisplayObjectContainer, propObj:Object, 
																							   defaultTexture:Texture, 
																							   hoverTexture:Texture, 
																							   downTexture:Texture, 
																							   disabledTexture:Texture,
																							   txtShadowObj:Object):Button {
			var $btn:Button = new Button();
			$btn.useHandCursor = true;
			if (StaticGUI._checkObj(propObj.xPos)) $btn.x = propObj.xPos;
			if (StaticGUI._checkObj(propObj.yPos)) $btn.y = propObj.yPos;
			if (StaticGUI._checkObj(propObj.width)) $btn.width = propObj.width;
			if (StaticGUI._checkObj(propObj.height)) $btn.height = propObj.height;
			
			if (defaultTexture) $btn.defaultSkin = new Image(defaultTexture);
			if (hoverTexture) $btn.hoverSkin = new Image(hoverTexture);
			if (downTexture) $btn.downSkin = new Image(downTexture);
			if (disabledTexture) $btn.disabledSkin = new Image(disabledTexture);
			
			if (StaticGUI._checkObj(propObj.text)) $btn.label = propObj.text;
			
			$btn.labelFactory = function():ITextRenderer{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				var ft:TextFormat = new TextFormat;
				if (StaticGUI._checkObj(propObj.font)) ft.font = propObj.font;
				if (StaticGUI._checkObj(propObj.textSize)) ft.size = propObj.textSize;
				if (StaticGUI._checkObj(propObj.textColor)) ft.color = propObj.textColor;
				
				textRenderer.textFormat = ft;
				
				if (StaticGUI._checkObj(propObj.embedFonts)) textRenderer.embedFonts = propObj.embedFonts;
				
				return textRenderer;
			}
			
			if(txtShadowObj){
				var $shadow:DropShadowFilter = new DropShadowFilter;
				
				for (var prop:String in txtShadowObj){
					$shadow[prop] = txtShadowObj[prop];
					
				}
				$btn.defaultLabelProperties.nativeFilters = [$shadow];
			}
			
			if (StaticGUI._checkObj(propObj.labelOffsetY)) $btn.labelOffsetY = propObj.labelOffsetY;
			
			
			//$btn.alignPivot(Align.CENTER, Align.CENTER);
			
			cont.addChild($btn);
			$btn.validate();
			$btn.pivotX = int($btn.width / 2);
			$btn.pivotY = int($btn.height / 2);
			
			return $btn; 
		}
		
		
		public static function _setButtonWithBitmapFont(cont:DisplayObjectContainer, propObj:Object, defaultTexture:Texture, 
																									 hoverTexture:Texture, 
																									 downTexture:Texture, 
																									 disabledTexture:Texture, fontName:String, ls:Number, fontSize:int = -1):Button{
																								   
			var $btn:Button = new Button();
			
			//$btn.useHandCursor = true;
			
			if (defaultTexture) $btn.defaultSkin = new Image(defaultTexture);
			if (hoverTexture) $btn.hoverSkin = new Image(hoverTexture);
			if (downTexture) $btn.downSkin = new Image(downTexture);
			if (disabledTexture) $btn.disabledSkin = new Image(disabledTexture);
			
			for (var prop:String in propObj){
				$btn[prop] = propObj[prop];
				
			}
			
			$btn.labelFactory = function():ITextRenderer{
				var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
				//textRenderer.width = $btn.width + 50;
				textRenderer.wordWrap = true;
				var format:BitmapFontTextFormat = new BitmapFontTextFormat(fontName);
				format.letterSpacing = ls;
				
				format.align = TextFormatAlign.CENTER;
				if (fontSize != -1)
				{
					format.size = fontSize;
				}
				textRenderer.textFormat = format
				
				 return textRenderer;
			}
			
			cont.addChild($btn);
			$btn.validate();
			$btn.pivotX = int($btn.width / 2);
			$btn.pivotY = int($btn.height / 2);
			
			return $btn; 
			
		}
		
		
		public static function _creatBitmapFontTextRenderer(cont:DisplayObjectContainer,
					  curText:String, 
					 _x:Number, 
					 _y:Number, 
					 _width:Number, 
					_height:Number,  
					 fontName:Object, 
					_align:String = TextFormatAlign.LEFT,
					  _isHTML:Boolean = false,
					  _letterSpacing:int = -3,
					  _size:int = -1,
					  _leading:int = 0,
					  _color:uint = 0xffffff):BitmapFontTextRenderer {
					   
			var htmlTxt:BitmapFontTextRenderer = new BitmapFontTextRenderer();

			var format:BitmapFontTextFormat = new BitmapFontTextFormat(fontName);
			format.letterSpacing = _letterSpacing;
			if (_size != -1)
			{
			 format.size = _size;
			}
			
			format.color = _color;
			format.align = _align;
			format.leading = _leading;
			
			htmlTxt.textFormat = format;
			htmlTxt.text = curText;
			htmlTxt.wordWrap = true;
			htmlTxt.touchable = false;
			   cont.addChild(htmlTxt);
			if(_width!=-1)htmlTxt.width = _width;
			htmlTxt.height = _height;
			  
			   htmlTxt.x = _x;
			   htmlTxt.y = _y;
			   
			   htmlTxt.validate();
			   return htmlTxt;   
					   
		}
		
		
		
		public static function _creatTextArea(cont:DisplayObjectContainer ,
									   curText:String, 
											_x:Number, 
											_y:Number, 
										 _width:Number, 
										_height:Number,  
									  fontName:String, 
									  fontSize:int = 12, 
									 fontColor:uint = 0xffffff, 
									    _align:String = TextFormatAlign.LEFT,
									   _isHTML:Boolean = false, 
									_multiline:Boolean = false):TextArea {
		   

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
			   textEditor.textFormat = new TextFormat(fontName, fontSize, fontColor, null, null, null, null, null, _align );
			 
			   textEditor.multiline = _multiline;
			   textEditor.wordWrap = _multiline;
			   textEditor.embedFonts = true;
			   textEditor.isHTML = _isHTML;
			   
			   return textEditor;
			 }
			
			 cont.addChild(textArea);
			 textArea.validate();
			 return textArea;
		   
		  }
		
		//[Inline]
		public static function _initButton(cont: DisplayObjectContainer,
										   xPos: int = 0,
										   yPos: int = 0,
								    defaultSkin: Texture = null,
								      hoverSkin: Texture = null,
									   downSkin: Texture = null):Button {
			
			var $btn:Button = new Button();
			$btn.useHandCursor = true;
			if(defaultSkin) $btn.defaultSkin = new Image(defaultSkin);
			if(hoverSkin) $btn.hoverSkin = new Image(hoverSkin);
			if(downSkin) $btn.downSkin = new Image(downSkin);
			$btn.x = xPos;
			$btn.y = yPos;
			
			cont.addChild($btn);
			$btn.validate();
			
			return $btn;
		}
		[Inline]
		public static function _checkObj(obj:*):Boolean {
			if (obj != undefined) return true else return false;
		}
		public static function _updateButtonSkin(bt: Button,
										     btName: String = '',
									    defaultSkin: Texture = null,
								          hoverSkin: Texture = null,
									       downSkin: Texture = null):void {
			if (btName && btName != '') bt.name = btName;
			if (defaultSkin) bt.setSkinForState(Button.STATE_UP, new Image(defaultSkin));
			if (hoverSkin) bt.setSkinForState(Button.STATE_HOVER, new Image(hoverSkin));
			if (downSkin) bt.setSkinForState(Button.STATE_DOWN, new Image(downSkin));
		}
		
		
		//[Inline]
		public static function intWithZeros(num:int, length:int):String {
			var str:String = String(num);
			var strLen:int = str.length;
			var newStr:String = "";
			
			for (var i:int = 0; i < length - strLen; i++) {
				newStr += "0";
			}
			
			newStr = newStr + str;
			return newStr;
		}
		
		
		public static function setAlignPivot(disp:*, align:String = CENTER_CENTER):void
		{
			switch (align) 
			{
				case CENTER_CENTER:
					disp.pivotX = int(disp.width / 2);
					disp.pivotY = int(disp.height / 2);
				break;
				
				case TOP_CENTER:
					/*disp.pivotX = int(0);
					disp.pivotY = int(disp.height/2);*/
					disp.pivotX = int(disp.width / 2);
					disp.pivotY = int(0);
				break;
				
				case RIGHT_CENTER:
					disp.pivotX = int(disp.width);
					disp.pivotY = int(disp.height / 2);
				break;
				
				case RIGHT_TOP:
					disp.pivotX = int(disp.width);
					disp.pivotY = int(0);
				break;
				
			}
		}
		
		public static function random(min:int = 0, max:int = int.MAX_VALUE):int
		{
			if (min == max) return min;
			if (min < max) return min + (Math.random() * (max - min + 1));
			else return max + (Math.random() * (min - max + 1));
		}
		
		public static function randomTwoRange(firstRange:int, secondRange:int, diapason:int):int
		{
			var num:Number = Math.floor(Math.random() * 2);
			
			if (num == 0)
			{
				return random(firstRange - diapason, firstRange + diapason);
			}
			else
			{
				return random(secondRange - diapason, secondRange + diapason);
			}
		}
		
		
		[Inline]
		public static function isEvenInt(num:int):Boolean
		{
		  return (num % 2 == 0);
		}
		
		
	
		public static function modifiedBalanceString(amount:Number, withCurType:int = 0):String
		{
			return FooterHolder.InLari == false ? String(int(amount / GameSettings.CREDIT_VAL)) : scoreToValutaFixed(amount, withCurType);
			//return FooterHolder.InLari == false ? String(amount / GameSettings.CREDIT_VAL) : String((amount / 100).toFixed(2) + " GEL");
		}
		
		
		[Inline]
		public static function shuffleArray(arr:Array):Array
		{
			var shuffledArr:Array = new Array(arr.length);
			 
			var randomPos:Number = 0;
			for (var i:int = 0; i < shuffledArr.length; i++)
			{
				randomPos = int(Math.random() * arr.length);
				shuffledArr[i] = arr.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element
			}
			
			return shuffledArr;
		}
		
		[Inline]
		public static function getCurrecyType():String
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
		
		[Inline]
		public static function getCurrecyShortcuts():String
		{
			for (var i:int = 0; i < GameSettings.Currency_Values.length; i++) 
			{
				if (GameSettings.Currency_Values[i].order == GameSettings.Currency_ID)
				{
					return GameSettings.Currency_Values[i].shortCut;
				}
			}
			return "";
		}
		
		
		//[Inline]
		public static function scoreToValutaFixed(amount:Number, withSymbol:int = 0, alwaysInMoney:Boolean = false):String
		{
			var str:String
			if (FooterHolder.InLari || alwaysInMoney == true)
			{
				if (GameSettings.Currency_ID != 8)
				{
					str = String(Number(amount / 100).toFixed(2));
				}
				else
				{
					str = String(int(amount / 100));
				}
			}
			else
			{
				str =  String(amount);
			}
			
			
			if (withSymbol > 0)
			{
				if (withSymbol == 1)
				{
					return String(str) + "" + getCurrecyShortcuts();
				}
				else
				{
					return String(str) + " " + getCurrecyType();
				}
				
			}
			else
			{
				return String(str);
			}
		}
		
		
		
	
	}
}
