package notifi {
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.utils.MouseEvent;
	import com.utils.MyButton;
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import game.footer.FooterHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	import starling.utils.Align;
	

	public class ErrorStatus extends Sprite3D {
		
		private var cont:ErrorStatus;
		private var win_txt:TextField;
		private var backToGame_btn:Button;
		private var statusBg:Image;
		
		private var errorNum:Number;
		private var gameXML:XML;
		private var customText:String;
		
		
		public function ErrorStatus(errorNum:Number, gameXML:XML = null, customText:String = "") {
			this.errorNum = errorNum;
			this.gameXML = gameXML;
			this.customText = customText;
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initBonusStatus();
			cont = this;
		}
		
		private function initBonusStatus():void {
			
			var bgMc:Sprite = new Sprite();
			addChild(bgMc);
			var quad:Quad = new Quad(this.stage.stageWidth + 800, this.stage.stageHeight + 800, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			bgMc.addChild(quad);
			bgMc.alpha = 0.5;
			var $atlas:TextureAtlas = Assets.getAtlas("errorSheet", "errorSheetXml");
			
			backToGame_btn = new Button();
			
			statusBg = new Image($atlas.getTexture("error_bg.png"));
			statusBg.y = 15;
			
			Root.soundManager.PlaySound("support");
			
			if (gameXML == null) {
				gameXML = GameSettings.GAME_XML;
			}
			var errorString:String = checkErrorCode(errorNum, GameSettings.GAME_XML);
			
			if (customText != "") {
				errorString = customText;
			}
			
			var $tf:starling.text.TextFormat = new starling.text.TextFormat;
			$tf.font = '_bpgGELDejaVuSerifCaps';
			$tf.size = 15;
			$tf.color = 0xFFFFFF;
			
			win_txt = new TextField(350, 120, errorString, $tf);
			//win_txt.border = true;
			win_txt.isHtmlText = true;
			win_txt.alignPivot(Align.CENTER, Align.CENTER);
			win_txt.x = 0;
			win_txt.y = 0;
			
			backToGame_btn = setButtonWithLabelShadow('BACK TO GAME', 
																   0, 
																  70,
						 $atlas.getTexture("error_return_normal.png"),
						  $atlas.getTexture("error_return_hover.png"), 
																 null,
															 0x000000,
															      -8);
			
			backToGame_btn.validate();
			
			statusBg.pivotX = int(statusBg.width / 2);
			statusBg.pivotY = int(statusBg.height / 2)
			
			addChild(statusBg);
			
			addChild(win_txt);
			addChild(backToGame_btn);
			backToGame_btn.addEventListener(Event.TRIGGERED, onCl);
			backToGame_btn.useHandCursor = true;
			
			TweenMax.from(this, 1, { rotationX: deg2rad( -80), alpha: 0, ease: Back.easeInOut } );
			
			this.x = int(this.stage.stageWidth / 2);
			this.y = int(this.stage.stageHeight / 2); 
			
		}
		
		public function checkErrorCode(errCode:Number, gameXML:XML):String {
			var errorText:String = "";
			
			for (var i:int = 0; i < gameXML.errors.err.@code.length(); i++) {
				if (gameXML.errors.err.@code[i] == errCode) {
					errorText = gameXML.errors.err[i];
				}
			}
			
			if (errorText == "") {
				errorText = "ERROR CODE: " + errCode;
			}
			
			return errorText;
		}
		
		private function setButtonWithLabelShadow(text:String, xPos:int, yPos:int, defaultTexture:Texture, 
																					 hoverTexture:Texture, 
																					  downTexture:Texture, shadowColor:uint, labelYOffset:int = 0):Button {
			var $btn:Button = new Button();
			$btn.x = xPos;
			$btn.y = yPos;
			if (defaultTexture) $btn.defaultSkin = new Image(defaultTexture);
			if (hoverTexture) $btn.hoverSkin = new Image(hoverTexture);
			if (downTexture) $btn.downSkin = new Image(downTexture);
			
			$btn.label = text;
			
			$btn.labelFactory = function():ITextRenderer{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				textRenderer.textFormat = new TextFormat( "_robotoBlack", 16, 0xffffff );
				textRenderer.embedFonts = true;
				
				return textRenderer;
			}
			$btn.defaultLabelProperties.nativeFilters = [new DropShadowFilter(3, 90, shadowColor, 1, 5, 5)];
			$btn.labelOffsetY = labelYOffset;
			
			$btn.validate();
			$btn.alignPivot(Align.CENTER, Align.CENTER);
			addChild($btn);
			
			return $btn; 
		}
		
		private function onCl(e:Event):void {
			
			TweenMax.to(this, 1, {rotationX: deg2rad(-80), scaleX: 2, scaleY: 2, alpha: 0, ease: Back.easeInOut, onComplete: destroyFunc});
		}
		
		private function destroyFunc():void {
			StaticGUI.safeRemoveChild(statusBg, true);
			
			Assets.disposeTextureItem("error_bg.png");
			
			StaticGUI.safeRemoveChild(backToGame_btn, true);
			
			StaticGUI.safeRemoveChild(win_txt, true);
			StaticGUI.safeRemoveChild(this, true);
			
			backToGame_btn.dispose();
			win_txt.dispose();
			
			cont = null;
			win_txt = null;
			backToGame_btn = null;
			statusBg = null;
			
			
			gameXML = null;
			customText = null;
			
		}
	
	}

}