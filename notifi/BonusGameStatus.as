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
	import game.footer.FooterHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author Giorgi Chitaladze
	 */
	public class BonusGameStatus extends Sprite3D {
		
		private var thisMC:BonusGameStatus;
		private var winAmount:Number;
		private var gameOver:Boolean;
		private var win_txt:TextField;
		private var backToGame_btn:Button;
		private var statusBg:Image;
		
		public function BonusGameStatus(winAmount:Number, gameOver:Boolean) {
			this.gameOver = gameOver;
			this.winAmount = winAmount;
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			initBonusStatus();
			thisMC = this;
		}
		
		private function initBonusStatus():void {
			/*var bgMc:Sprite = new Sprite();
			addChild(bgMc);
			var quad:Quad = new Quad(this.stage.stageWidth + 40, this.stage.stageHeight + 40, Color.BLACK);
			quad.alignPivot(Align.CENTER, Align.CENTER);
			bgMc.addChild(quad);
			bgMc.alpha = 0.5;
			var $atlas:TextureAtlas = Assets.getAtlas("bonusStatusSheet", "bonusStatusSheetXml");
			
			backToGame_btn = new Button();
			var $title:Image;
			
			
			
			
			if (gameOver == true) {
				
				statusBg = new Image($atlas.getTexture("lose_bg.png"));
				statusBg.y = 35;
				
				
				var $tf:TextFormat = new TextFormat;
				$tf.font = Assets.getFont("notifiLoseBonusGame").name;
				$tf.bold = true;
			
				win_txt = new TextField(400, 200, StaticGUI.modifiedBalanceString(winAmount), $tf);
				//win_txt.fontSize = BitmapFont.NATIVE_SIZE;
				//win_txt.color = Color.WHITE;
				win_txt.alignPivot(Align.CENTER, Align.CENTER);
				win_txt.x = -5;
				win_txt.y = 140;
				
				$title = new Image($atlas.getTexture("lose_title.png"));
				$title.x = - $title.width / 2;
				$title.y = -10;
				
				backToGame_btn = setButtonWithLabelShadow('BACK TO MAIN', 
																	   0, 
																	 220, 
								$atlas.getTexture("lose_back_btn_1.png"), 
								$atlas.getTexture("lose_back_btn_2.png"), 
								$atlas.getTexture("lose_back_btn_3.png"), 
								    							0x1f1105,
																	  -8);

				
			} else {
				
				$tf.font = Assets.getFont("bebas").name;
				$tf.size =  50;
				$tf.color = 0xFF0000;
				$tf.bold = true;
				
				statusBg = new Image($atlas.getTexture("win_bg.png"));
				statusBg.y = 15;
				win_txt = new TextField(400, 200, StaticGUI.modifiedBalanceString(winAmount), $tf);
				win_txt.alignPivot(Align.CENTER, Align.CENTER);
				win_txt.x = 22;
				win_txt.y = 25;
				
				
				
				backToGame_btn = setButtonWithLabelShadow('"Back To Game', 
																	   22, 
																	  140, 
								  $atlas.getTexture("win_back_btn_1.png"), 
								  $atlas.getTexture("win_back_btn_2.png"), 
								  $atlas.getTexture("win_back_btn_3.png"), 
																0x000000);
			}
			
			backToGame_btn.validate();
			
			statusBg.alignPivot(Align.CENTER, Align.CENTER);
			
			addChild(statusBg);
			
			addChild($title)
			addChild(win_txt);
			addChild(backToGame_btn);
			backToGame_btn.addEventListener(Event.TRIGGERED, onCl);
			backToGame_btn.useHandCursor = true;
			
			TweenMax.from(this, 1, { rotationX: deg2rad( -80), alpha: 0, ease: Back.easeInOut } );*/
			
		}
		
		/*private function setButtonWithLabelShadow(text:String, xPos:int, yPos:int, defaultTexture:Texture, 
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
				textRenderer.textFormat = new TextFormat( "_robotoBlack", 21, 0xffffff );
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
			dispatchEvent(new GameEvents(GameEvents.BONUS_FINISHED, {win: winAmount}));
			TweenMax.to(this, 1, {rotationX: deg2rad(-80), scaleX: 2, scaleY: 2, alpha: 0, ease: Back.easeInOut, onComplete: destroyFunc});
		}
		
		private function destroyFunc():void {
			StaticGUI.safeRemoveChild(statusBg, true);
			statusBg = null;
			Assets.disposeTextureItem("bonusGameStatusBg1.png");
			Assets.disposeTextureItem("BonusGameStatusBg2.png");
			StaticGUI.safeRemoveChild(backToGame_btn, true);
			backToGame_btn = null;
			StaticGUI.safeRemoveChild(win_txt, true);
			win_txt = null;
		}*/
	
	}

}