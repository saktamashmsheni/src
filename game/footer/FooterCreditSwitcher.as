package game.footer {
	import com.greensock.TweenLite;
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import flash.geom.Point;
	import game.GameHolder;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	import starling.display.MovieClip;
	

	public class FooterCreditSwitcher extends Sprite {
		
		private var $creditSwtcher:Button;
		private var $creditSwtcherLine:Image;
		private var $backGround:MovieClip;
		private var $switcherAngles:Vector.<int> = new Vector.<int>;
		private var $creditChangeHandler:Function;
		
		public function FooterCreditSwitcher() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(e:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, remmovedHandler);
			
			$switcherAngles.push(125, 45, -45, -120);
			var $atlas:TextureAtlas = Assets.getAtlas("footerSheet", "footerSheetXml");
			
			$backGround = new MovieClip($atlas.getTextures("credit_dot_controller_"));
			$backGround.x = -9;
			$backGround.y = -2;
			$backGround.currentFrame = 0;
			addChild($backGround);
			
			$creditSwtcher = StaticGUI._initButton(this, 0, 0, 
														$atlas.getTexture("credit_controller_1.png"), 
														$atlas.getTexture("credit_controller_1.png"), 
														$atlas.getTexture("credit_controller_2.png"));
														
														
			$creditSwtcher.setSkinForState( Button.STATE_DISABLED, new Image( $atlas.getTexture("credit_controller_4.png") ) );
			
			$creditSwtcher.addEventListener(Event.TRIGGERED, creditButtonTriggerHandler);
			
			//$creditSwtcher.iconPosition = Button.ICON_POSITION_MANUAL;
			addChild($creditSwtcher);
			$creditSwtcher.validate();
			
			$creditSwtcherLine = new Image($atlas.getTexture("credit_controller_line.png"));
			$creditSwtcherLine.touchable = false;
			$creditSwtcherLine.x = 36;
			$creditSwtcherLine.y = 32;
			$creditSwtcherLine.pivotX = $creditSwtcherLine.width  * 0.5;
			$creditSwtcherLine.pivotY = 5;
			$creditSwtcherLine.rotation = deg2rad($switcherAngles[GameSettings.CREDIT_INDEX]);
			addChild($creditSwtcherLine);
			
			
			
			var $switchPointsVect:Vector.<Point> = new Vector.<Point>;
			$switchPointsVect.push(new Point(-2, 11), new Point(6, 52), new Point(58, 53), new Point(67, 10));
			
			var $dotBtnSt:Quad;
			
			var $i:uint = 0;
			var $b:Button;
			
			for ($i = 0; $i < $switchPointsVect.length; $i++ ){
				$dotBtnSt = new Quad(10, 10, 0xff0000);
				
				$dotBtnSt.alpha = 0;
				$b = new Button; //StaticGUI._initButton(this, 0, 0, Texture($dotBtnSt));
				$b.defaultSkin = $dotBtnSt ;
				$b.move($switchPointsVect[$i].x, $switchPointsVect[$i].y); 
				$b.addEventListener(Event.TRIGGERED, creditDotButtonTriggerHandler);
				$b.name = 'dot_' + $i;
				$b.useHandCursor = true;
				addChild($b);
				$b.validate();
			}

			
			//$creditSwtcherLine.alignPivot(Align.CENTER, Align.TOP);
			//$creditSwtcherLine.rotation = deg2rad(-90);
			//addChild($creditSwtcherLine);
			//TweenLite.to($creditSwtcherLine, 1, { rotation:deg2rad( -120) } );
			//$creditSwtcher.defaultIcon = $creditSwtcherLine;
			//$creditSwtcher.iconOffsetX = 1;
			//$creditSwtcher.iconOffsetY = 1;
			
			//this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnt);
		}
		
		private function creditDotButtonTriggerHandler(e:Event):void {
			if (GameHolder.cont.freeSpinsState == true || GameHolder.cont.footerHolder.spinEnabled == false || GameHolder.gameState == GameHolder.DOUBLE_STATE) {
				return;
			}
			
			Root.soundManager.PlaySound("options_click");
			var $index:Array = String(Button(e.target).name).split('_');
			
			GameSettings.CREDIT_INDEX  =  $index[1];
			TweenLite.to($creditSwtcherLine, .4, { rotation: deg2rad($switcherAngles[GameSettings.CREDIT_INDEX]) } );
			$backGround.currentFrame = GameSettings.CREDIT_INDEX;
			GameSettings.CREDIT_VAL = GameSettings.CREDIT_AR[GameSettings.CREDIT_INDEX];
			$creditChangeHandler();
			
		}
		
		public function _isEnabled(boo:Boolean = true):void{
			
			this.touchable = boo
			$creditSwtcher.isEnabled = boo;
			this.useHandCursor = boo;
			if (boo){
				//this.alpha = 1;
			}else{
				//this.alpha = .5;
			}
		}
		
				
		private function creditButtonTriggerHandler(e:Event):void {
			
			if (GameHolder.cont.freeSpinsState == true || GameHolder.cont.footerHolder.spinEnabled == false || GameHolder.gameState == GameHolder.DOUBLE_STATE) {
				return;
			}
			
			Root.soundManager.PlaySound("options_click");
			
			GameSettings.CREDIT_INDEX ++;
			if (GameSettings.CREDIT_INDEX > GameSettings.CREDIT_AR.length - 1) {
				GameSettings.CREDIT_INDEX = 0;
			}
			$backGround.currentFrame = GameSettings.CREDIT_INDEX;
			TweenLite.to($creditSwtcherLine, .4, { rotation: deg2rad($switcherAngles[GameSettings.CREDIT_INDEX]) } );
			
			GameSettings.CREDIT_VAL = GameSettings.CREDIT_AR[GameSettings.CREDIT_INDEX];
			$creditChangeHandler();
		}
		
		public function set _creditChangeCallBack(func:Function):void {
			$creditChangeHandler = func;
		}
				
		private function onEnt(e:EnterFrameEvent):void {
			$creditSwtcherLine.rotation += deg2rad(2);
		}
		
		private function remmovedHandler(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, remmovedHandler);
			if ($creditSwtcher) {
				$creditSwtcher.removeEventListener(Event.TRIGGERED, creditButtonTriggerHandler);
				$creditSwtcher.dispose();
			}
			
			this.dispose();
			this.removeChildren();
		}
		
	}

}